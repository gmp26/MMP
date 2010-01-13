package org.maths
{
	public interface IField
	{
		function IField(xr:Object, ytheta:Number, polar:Boolean);		
		function hasFunction(s:String):Boolean;
		function boolEquals(c:IField):Boolean;
		function equals(c:IField):IField;
		function notEquals(c:IField):IField;
		function logicalNot():IField;
		function greaterThan(c:IField):IField;
		function greaterEquals(c:IField):IField;
		function lessThan(c:IField):IField;
		function lessEquals(c:IField):IField;
		function times(z:Object):IField;
		function over(z:Object):IField;
		function plus(z:Object):IField;
		function minus(z:Object):IField;
		function negate():IField;
		function conjugate():IField;
		function reciprocal():IField;
		function abs():IField;
		function arg():IField;	
		function exp():IField;
		function sin():IField;
		function asin():IField;
		function cos():IField;
		function acos():IField;
		function tan():IField;
		function atan():IField;
		function sinh():IField;
		function asinh():IField;
		function cosh():IField;
		function acosh():IField;
		function tanh():IField;
		function atanh():IField;
		function ln():IField;
		function sqrt():IField;
		function sqr():IField;
		function pow(z:Object):IField;
		function round():IField;
		function get length():Number;		
		function get angle():Number;
		function polar():Object;
		function negligible(t:Number):Boolean;
		function finite():Boolean;
		function zfinite(z:Object):Boolean;
		function nan():Boolean;
		function specialString():String;
		function fullString():String;
		function toString():String;
		function displayString():String;
		function polarString():String
		function dot(z:IField):Number;
	}
}
