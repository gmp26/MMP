package org.maths
{
	public interface IExpression
	{
		
		function get type():Number;
		function set type(n:Number):void;
		
		function get name():String;
		function set name(s:String):void;
		
		function get value():Complex;
		function set value(c:Complex):void;
		
		function get real():Number;
		function set real(n:Number):void;
		
		function get expr0():Expression;
		function set expr0(e:Expression):void;
		
		function get expr1():Expression;
		function set expr1(e:Expression):void;
		
	}
}