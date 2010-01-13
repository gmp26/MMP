package org.maths
{
	public class Fraction extends FieldBase implements IField
	{
		public function Fraction(numerator:Number, denominator:Number)
		{
			super(numerator, denominator);
		}

		public function hasFunction(s:String):Boolean
		{
			return [
				/* list functions here */
			].indexOf(s) >= 0;
		}
		
		public function greaterThan(c:IField):IField
		{
			return null;
		}
		
		public function greaterEquals(c:IField):IField
		{
			return null;
		}
		
		public function lessThan(c:IField):IField
		{
			return null;
		}
		
		public function lessEquals(c:IField):IField
		{
			return null;
		}
		
		public function times(z:Object):IField
		{
			return null;
		}
		
		public function over(z:Object):IField
		{
			return null;
		}
		
		public function plus(z:Object):IField
		{
			return null;
		}
		
		public function minus(z:Object):IField
		{
			return null;
		}
		
		public function negate():IField
		{
			return null;
		}
		
		public function conjugate():IField
		{
			return null;
		}
		
		public function reciprocal():IField
		{
			return null;
		}
		
		public function abs():IField
		{
			return null;
		}
		
		public function arg():IField
		{
			return null;
		}
		
		public function exp():IField
		{
			return null;
		}
		
		public function sin():IField
		{
			return null;
		}
		
		public function asin():IField
		{
			return null;
		}
		
		public function cos():IField
		{
			return null;
		}
		
		public function acos():IField
		{
			return null;
		}
		
		public function tan():IField
		{
			return null;
		}
		
		public function atan():IField
		{
			return null;
		}
		
		public function sinh():IField
		{
			return null;
		}
		
		public function asinh():IField
		{
			return null;
		}
		
		public function cosh():IField
		{
			return null;
		}
		
		public function acosh():IField
		{
			return null;
		}
		
		public function tanh():IField
		{
			return null;
		}
		
		public function atanh():IField
		{
			return null;
		}
		
		public function ln():IField
		{
			return null;
		}
		
		public function sqrt():IField
		{
			return null;
		}
		
		public function sqr():IField
		{
			return null;
		}
		
		public function pow(z:Object):IField
		{
			return null;
		}
		
		public function round():IField
		{
			return null;
		}
		
		public function get length():Number
		{
			return 0;
		}
		
		public function get angle():Number
		{
			return 0;
		}
		
		public function polar():Object
		{
			return null;
		}
		
		public function finite():Boolean
		{
			return false;
		}
		
		public function specialString():String
		{
			return null;
		}
		
		public function fullString():String
		{
			return null;
		}
		
		public function displayString():String
		{
			return null;
		}
		
		public function polarString():String
		{
			return null;
		}
		
		public function dot(z:IField):Number
		{
			return 0;
		}
	}
}