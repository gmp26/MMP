package org.maths {
	public class Vector2D {
		public var x:Number = 0;
		public var y:Number = 0;
		private var _len:Number;
		function Vector2D(p:Object, q:Object=null) {
			if(p.x != null && p.y != null) {
				x = p.x;
				y = p.y;
			}
			else {
				x = Number(p);
				y = Number(q);
			}
			_len = Math.sqrt(x*x+y*y);
		}
		public function get length():Number {
			return _len;
		}
		public function plus(v:Vector2D):Vector2D {
			return new Vector2D({x:(x+v.x), y:(y+v.y)});
		}
		public function minus(v:Vector2D):Vector2D {
			return new Vector2D({x:(x-v.x), y:(y-v.y)});
		}
		public function negate():Vector2D {
			return new Vector2D({x:-x, y:-y});
		}
		public function times(s:Number):Vector2D {
			return new Vector2D({x:s*x, y:s*y});
		}
		public function dot(v:Vector2D):Number {
			return x*v.x + y*v.y;
		}
		public function crozz(v:Vector2D):Number {
			return (v.x*y - v.y*x);
		}
		public function hasValue():Boolean {
			return !(isNaN(x) || isNaN(y));
		}
		public function rotate(theta:Number):Vector2D {
			var c:Number = Math.cos(theta);
			var s:Number = Math.sin(theta);
			var x1:Number = c*x+s*y;
			var y1:Number = -s*x+c*y;
			return new Vector2D({x:x1, y:y1});
		}
		public function round():Vector2D {
			return new Vector2D({x:Math.round(x), y:Math.round(y)});
		}
		public function floor():Vector2D {
			return new Vector2D({x:Math.floor(x), y:Math.floor(y)});
		}
		public function toString():String {
			return "("+x+","+y+")";
		}
	}
}