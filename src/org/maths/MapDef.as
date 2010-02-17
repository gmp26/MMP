package org.maths {
	import org.maths.XMLUtilities;
	
	
	/**
	 * Stores a defined map.
	 *  
	 * @author gmp26
	 * 
	 */
	public class MapDef
	{
		
		public var dummyVars:Vector.<String> = new Vector.<String>;
		public var functionName:String;
		public var expression:Expression = new Expression(null);
		public var expressionAsString:String;
		
		function MapDef(functionName:String) {
			this.functionName = functionName;
		}
		
		public function addDummyVar(s:String):void
		{
			var i:int = dummyVars.indexOf(s);
			if(i < 0)
				dummyVars.push(s);
		}
		
		public function evaluate(arg0:Complex, arg1:Complex = null):Complex {
			var oldState:IState = Expression.state;
			var newState:BasicStateImpl = new BasicStateImpl();
			if(dummyVars.length > 0) {
				newState.define(dummyVars[0], new Expression(arg0));
			}
			if(dummyVars.length > 1) {
				newState.define(dummyVars[1], new Expression(arg1));
			}
			var z:Complex = expression.evaluate(true);
			Expression.state = oldState;
			return z;
		}
		
		public function toXML():XML {
			
			var md:XML = <mapDef expr={expressionAsString}/>
			for(var i:int = 0; i < dummyVars.length; i++) {
				var dv:XML = <dummyVar name={dummyVars[i]}/>;
				md.appendChild(dv);
			}
			
			return md;
		}
		
		public function fromXML(md:XML):void {				
			expressionAsString = XMLUtilities.stringAttr(md.@expr, "x");
			expression = new Expression(expressionAsString);
			var dvList:XMLList = md.dummyVar;
			
			for(var i:int = 0; i < dvList.length(); i++) {
				addDummyVar(XMLUtilities.stringAttr(dvList[i].@name, "x"));
			}
		}
	}
}