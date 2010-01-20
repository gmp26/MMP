package org.maths {
	public class Fraction {
		protected var _hasError:Boolean;
		protected var _num:int;
		protected var _den:int;
		
		public function Fraction(... args) {
			_num = 0;
			_den = 1;
			_hasError = false;

			if (args.length == 2) {
				_num = args[0];
				_den = args[1];
				if (!(_num is int)) {
					_hasError = true;
				}
				if (!(_den is int)) {
					_hasError = true;
				}
			}
			
			if (args.length == 1) {
				this.fromString(args[0]);
			}
			
			if (args.length > 2) {
				_hasError = true;
			}
		}
		
		public function clone():Fraction {
			var h:Fraction = new Fraction();
			h.setFraction(this._num, this._den);
			return h;
		}
		
		private function gcd(a:int,b:int):int {
			if ((a < 0) || (b < 0)) {
				return gcd(Math.abs(a),Math.abs(b));
			}
			if (a < b) {
				return gcd(b,a);
			}
			if (b == 0) {
				return a;
			}
			return gcd(b, a%b);
		}
		
		public function getNumer():int {
			return _num;
		}

		public function getDenom():int {
			return _den;
		}
		
		public function setFraction(a:int, b:int):void {
			_num = a;
			_den = b;
			_hasError = false;
			if (_den == 0) {
				_hasError = true;
			}
			this.reduce();
		}
		
		public function reduce():void {
			var n:int;
			var d:int;
			var c:int;
			n = this.getNumer();
			d = this.getDenom();
			c = gcd(n,d);
			n = n/c;
			d = d/c;
			
			if (d < 0) {
				n = -n;
				d = -d;
			}
			_num = n;
			_den = d;
		}
						
		public function fracAdd(a:*):Fraction {
			var n1:int;
			var n2:int;
			var d1:int;
			var d2:int;
			var f:Fraction = new Fraction();
			var h:Fraction = new Fraction();
			
			if (a is Fraction) {
				f = a.clone();
			} 
			else if (a is int) {
				f.setFraction(a,1);
			}
			else if (a is String) {
				f.fromString(a);
			}
			
			n1 = this.getNumer();
			d1 = this.getDenom();
			n2 = f.getNumer();
			d2 = f.getDenom();
			
			return (new Fraction(n1*d2 + n2*d1, d1*d2));
		}
		
		public function fracSub(a:*):Fraction {
			var n1:int;
			var n2:int;
			var d1:int;
			var d2:int;
			var f:Fraction = new Fraction();
			
			if (a is Fraction) {
				f = a.clone();
			} 
			else if (a is int) {
				f.setFraction(a,1);
			}
			else if (a is String) {
				f.fromString(a);
			}
			
			n1 = this.getNumer();
			d1 = this.getDenom();
			n2 = f.getNumer();
			d2 = f.getDenom();
			
			return (new Fraction(n1*d2 - n2*d1, d1*d2));
		}
		
		public function fracMul(a:*):Fraction {
			var n1:int;
			var n2:int;
			var d1:int;
			var d2:int;
			var f:Fraction = new Fraction();
			
			if (a is Fraction) {
				f = a.clone();
			} 
			else if (a is int) {
				f.setFraction(a,1);
			}
			else if (a is String) {
				f.fromString(a);
			}
			
			n1 = this.getNumer();
			d1 = this.getDenom();
			n2 = f.getNumer();
			d2 = f.getDenom();
			
			return (new Fraction(n1*n2, d1*d2));
		}
		
		public function fracDiv(a:*):Fraction {
			var n1:int;
			var n2:int;
			var d1:int;
			var d2:int;
			var f:Fraction = new Fraction();
			
			if (a is Fraction) {
				f = a.clone();
			} 
			else if (a is int) {
				f.setFraction(a,1);
			}
			else if (a is String) {
				f.fromString(a);
			}
			
			n1 = this.getNumer();
			d1 = this.getDenom();
			n2 = f.getNumer();
			d2 = f.getDenom();
			
			return (new Fraction(n1*d2, d1*n2));
		}
				
		public function isEqual(a:*):Boolean {
			var n1:int;
			var n2:int;
			var d1:int;
			var d2:int;
			var f:Fraction = new Fraction();
			
			if (a is Fraction) {
				f = a.clone();
			} 
			else if (a is int) {
				f.setFraction(a,1);
			}
			else if (a is String) {
				f.fromString(a);
			}

			n1 = this.getNumer();
			d1 = this.getDenom();
			n2 = f.getNumer();
			d2 = f.getDenom();
			
			if (this.hasError()) {
				return false;
			}
			
			if (f.hasError()) {
				return false;
			}
			
			if (n1*d2 == n2*d1) {
				return true;
			}
			return false;		
		}
		
		public function toString():String {
			var n:int;
			var d:int;
			n = this.getNumer();
			d = this.getDenom();
			if (n==0) {
				return "0";
			}
			if (d==1) {
				return String(n);
			}
			return (String(n) + "/" + String(d) );
		}

		public function toValue():Number {
			var n:int;
			var d:int;
			n = this.getNumer();
			d = this.getDenom();
			return (n/d);
		}

		public function fromString(s:String):void {
			var a:Array = s.split("/");
			_hasError = false;

			if ((a.length == 0)||(a.length>2)) {
				_hasError = true;
				return;
			}
			
			this._num = parseInt(a[0]);

			if (a.length == 2) {
				this._den = parseInt(a[1]);
			}

			if ( isNaN(this._num) || isNaN(this._den) ) {
				_hasError = true;
			}
		}
				
		public function hasError():Boolean {
			return _hasError;
		}
	}
}