package org.maths
{
	/**
	 * Utility functions for the MMP package
	 */ 
	public class Util
	{
		private var _figures:int = 2;
		private var _rounding:Function = toDP;
		
		/**
		 * rounding function specifier
		 * "dp" means decimal place rounding
		 * "sf" means significant figure rounding
		 */
		public function set rounding(method:String):void {
			_rounding = (method == "dp") ? toDP : toSigFig;
		}
		public function get rounding():String {
			return (_rounding == toDP) ? "dp" : "sf";
		}
		
		/**
		 * figures/digits of rounding precision
		 */ 
		public function set figures(d:int):void {
			_figures = d;
		}
		public function get figures():int {
			return _figures;
		}
		
		public function round(t:Number):Number {
			return _rounding(t, _figures);
		}
		
		/**
		 * Round to given number of decimal places
		 * @param t Number to be rounded
		 * @param dps Number of decimal places
		 * @return result
		 */
		static public function toDP(t:Number, dps:Number):Number {
			var s:Number = Math.abs(t);
			var whole:Number = Math.floor(s);
			var pten:Number = Math.pow(10,dps);
			var frac:Number = (s-whole)*pten;
			s = whole + Math.floor(frac+0.5)/pten;
			return (t > 0) ? s : -s;
		}
		
		/**
		 * Round to given number of significant figres
		 * @param t Number to be rounded
		 * @param sigfigs Number of significant figures
		 * @return result
		 */
		static public function toSigFig(t:Number, sigfigs:Number):Number {
			if(t==0) return t;
			var sign:Number=t/Math.abs(t);
			t = Math.abs(t);
			for(var k:int=0; t >= 10; k++) {
				t /= 10;
			}
			if(k==0) for(k=0; t < 1; k--) {
				t *= 10;
			}
			var n:Number = (Math.pow(10,sigfigs-1));
			t = Math.round(t*n)/n;
			t *= (sign*Math.pow(10,k));
			return t;
		}
	}
}