package org.maths {
	import org.maths.BasicStateImpl;
	import org.maths.Complex;
	import org.maths.Expression;
	import org.maths.IState;
	
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
		
		function MapDef(functionName:String) {
			this.functionName = functionName;
		}
		
		public function evaluate(arg0:Expression, arg1:Expression = null):Complex {
			var oldState:IState = Expression.state;
			var newState:BasicStateImpl = new BasicStateImpl();
			if(dummyVars.length > 0) {
				newState.define(dummyVars[0], arg0);
			}
			if(dummyVars.length > 1) {
				newState.define(dummyVars[1], arg1);
			}
			var z:Complex = expression.evaluate(true);
			Expression.state = oldState;
			return z;
		}
		
		
	}
}