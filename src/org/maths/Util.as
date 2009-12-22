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
			if(Math.abs(t) < Math.pow(10, -(dps+1))) {
				// getaround a toFixed bug (e.g. 0.0006.toFixed(2) gives 0.01; 0.0004.toFixed(2) gives 0.00)
				return Number((t+1).toFixed(dps)) - 1;
			}
			return Number(t.toFixed(dps));
		}
		
		/**
		 * Round to given number of significant figres
		 * @param t Number to be rounded
		 * @param sigfigs Number of significant figures
		 * @return result
		 */
		static public function toSigFig(t:Number, sigfigs:uint):Number {
			//
			// if t rounds to 1, there are problems with scientific notation
			//
			var s:String = t.toPrecision(sigfigs);
			var bugs:Array;
			if((bugs = s.match(/^(-)?e(.*)$/)) != null) {
				s = bugs[1] + "1.0e" + bugs[2]; 
			}
			return Number(s);
		}
	}
}