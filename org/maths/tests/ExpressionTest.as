package org.maths.tests {
	
	import flexunit.framework.*;
	import org.maths.Complex;
	import org.maths.Expression;
	import org.maths.IState;
	import org.maths.BasicStateImpl;
	
	public class ExpressionTest extends TestCase {
			
	    public static function suite() : TestSuite {
	        var suite : TestSuite = new TestSuite();
	        return suite;
	    }
	
	    public function ExpressionTest(name : String = null) {
	        super(name);
	    }
	    
	    override public function setUp():void {
			var state:IState = new BasicStateImpl();
			state.define("w", new Expression("2"));
			state.define("z", new Expression("5"));
			state.define("t", new Expression("-2"));
	    	Complex.precision = 1e-14;
	    }
	    
	    public function testSetUp():void {
	    	assertTrue("TRUE", true);
	    }
	    
	    public function testEchoI():void {
    		assertCEquals("i==i", (new Expression("i")).evaluate(), Complex.I);
	    }
	    
	    public function testW():void {
     		assertCEquals("w==2", (new Expression("w")).evaluate(), new Complex(2));
	    }
	    
	    public function testZ():void {
     		assertCEquals("z==5", (new Expression("z")).evaluate(), new Complex(5));
	    }
	    
	    public function testT():void {
     		assertCEquals("t==-2", (new Expression("t")).evaluate(), new Complex(-2));
	    }
	    
	    public function testMinusI():void {
     		assertCEquals("-i==-i", (new Expression("-i")).evaluate(), new Complex(0,-1));
	    }
	    
	    public function testPi():void {
     		assertCEquals("pi", (new Expression("pi")).evaluate(), new Complex(Math.PI));
	    }
	    
	    public function testMinusPi():void {
     		assertCEquals("-pi", (new Expression("-pi")).evaluate(), new Complex(-Math.PI));
	    }
	    
	    public function testE():void {
     		assertCEquals("e", (new Expression("e")).evaluate(), new Complex(Math.E));
	    }
	    
	    public function testMinusE():void {
     		assertCEquals("-i==-i", (new Expression("-e")).evaluate(), new Complex(-Math.E));
	    }
	    
	    public function testRational1():void {
	    	var e:Expression = new Expression("u=(z-5)/(5*z-1)");
	    	//trace(e.evaluate());
	    	assertCEquals("u=(z-5)/(5*z-1)", e.evaluate(), Complex.ZERO);
	    }

	    public function testRational2():void {
	    	var e:Expression = new Expression("u=(z+3)/(z-3)");
	    	//trace(e);
	    	assertCEquals("(z+3)/(z-3)", e.evaluate(), new Complex(4));
	    }

	    public function testRational3():void {
	    	var e:Expression = new Expression("u=-(z-3)/(z+3)");
	    	//trace(e);
	    	assertCEquals("-(z-3)/(z+3)", e.evaluate(), new Complex(-1/4));
	    }

	    public function testRational4():void {
	    	var e:Expression = new Expression("(1+i)/(1-i)");
	    	//trace(e);
	    	assertCEquals("(1+i)/(1-i)", e.evaluate(), Complex.I);
	    }

	    public function testAssignZ():void {
	    	var e:Expression = new Expression("z = (1.7+(1.2*i))");
	    	assertCEquals("z = (1.7+(1.2*i))", e.evaluate(), new Complex(1.7,1.2));
	    }
	    
	    public function testToString():void {
	    	var e:Expression = new Expression("z = (1.7+(1.2*i))");
	    	//trace(e.toString());
	    	assertTrue("z = (1.7+(1.2*i))", e.toString()=="z = (1.7 plus (1.2 times i))");

	    }
	    
	    public function testDisplayString():void {
	    	var e:Expression = new Expression("z = (1.7+(1.2*i))");
	    	assertTrue("z = (1.7+(1.2*i))", e.displayString()=="z = 1.7+1.2*i");

	    }
	    
	    public function testMultiPar():void {
	    	var e:Expression = new Expression("(((1)))");
	    	//trace(e);
	    	assertCEquals("(((1)))", e.evaluate(), Complex.ONE);
	    }

	    public function testDoubleNegative():void {
	    	var e:Expression = new Expression("--1");
	    	//trace(e);
	    	assertCEquals("--1", e.evaluate(), Complex.ONE);
	    }

	    public function testDivideByZero():void {
	    	var e:Expression = new Expression("1/0");
	    	//trace(e);
	    	assertCEquals("1/0", e.evaluate(), Complex.INFINITY);
	    }

	    public function testAdd1():void {
	    	var e:Expression = new Expression("1+2+4");
	    	//trace(e);
	    	assertCEquals("1+2+4", e.evaluate(), new Complex(7));
	    }

	    public function testAdd2():void {
	    	var e:Expression = new Expression("z+2");
	    	//trace(e);
	    	assertCEquals("z+2", e.evaluate(), new Complex(7));
	    }

	    public function testAdd3():void {
	    	var e:Expression = new Expression("z+t");
	    	//trace(e);
	    	assertCEquals("z+t", e.evaluate(), new Complex(3));
	    }

	    public function testAdd4():void {
	    	var e:Expression = new Expression("t+z");
	    	//trace(e);
	    	assertCEquals("t+z", e.evaluate(), new Complex(3));
	    }

	    public function testTimes1():void {
	    	var e:Expression = new Expression("1*2*4");
	    	//trace(e);
	    	assertCEquals("1*2*4", e.evaluate(), new Complex(8));
	    }

	    public function testDistrib1():void {
	    	var e:Expression = new Expression("2*(3+4)");
	    	//trace(e);
	    	assertCEquals("2*(3+4)", e.evaluate(), new Complex(14));
	    }

	    public function testPower1():void {
	    	var e:Expression = new Expression("2^0");
	    	//trace(e);
	    	assertCEquals("2^0", e.evaluate(), Complex.ONE);
	    }

	    public function testPower2():void {
	    	var e:Expression = new Expression("z^0");
	    	//trace(e);
	    	assertCEquals("z^0", e.evaluate(), Complex.ONE);
	    }

	    public function testPower3():void {
	    	var e:Expression = new Expression("2^-1");
	    	//trace(e);
	    	assertCEquals("2^-1", e.evaluate(), new Complex(0.5));
	    }

	    public function testPower4():void {
	    	var e:Expression = new Expression("3^5");
	    	//trace(e.evaluate());
	    	Complex.precision = 1e-12;
	    	assertCEquals("3^5", e.evaluate(), new Complex(243));
	    }

	    public function testPower5():void {
	    	var e:Expression = new Expression("3^5*7");
	    	//trace(e.evaluate());
	    	Complex.precision = 1e-11;
	    	assertCEquals("3^5*7", e.evaluate(), new Complex(243*7));
	    }

	    public function testPower6():void {
	    	var e:Expression = new Expression("3*5^7");
	    	//trace(e.evaluate());
	    	Complex.precision = 1e-11;
	    	assertCEquals("3*5^7", e.evaluate(), new Complex(3*Math.pow(5,7)));
	    }
	    
		/**
		 * 3^5^7 causes a floating point overflow represented by a result of 'Infinity'
		 */
	    public function testPower7():void {
	    	var e:Expression = new Expression("3^5^7");
	    	//trace(e.evaluate());
	    	Complex.precision = 1e-10;
	    	assertCEquals("3^5^7", e.evaluate(), new Complex(Math.pow(3,Math.pow(5,7))));
	    }

	    public function testPower8():void {
	    	var e:Expression = new Expression("z^(1-2*t)");
	    	//trace(e.evaluate());
	    	Complex.precision = 1e-12;
	    	assertCEquals("z^(1-2*t)", e.evaluate(), new Complex(Math.pow(5,5)));
	    }

		public function testParseError1():void {
			try {
				var e:Expression = new Expression("(3+4");
			}
			catch (err:Error) {
				assertTrue("(3+4", err.message.match(/expected closing bracket/));
				return;
			}
			// test failed if we get here
			assertTrue("(3+4", false);
		}
		
		/**
		 * If there are two expressions in a string, parse just returns the first one
		 */
		public function testParseError2():void {
			try {
				var e:Expression = new Expression("4 5");
				//trace(e.evaluate());
			}
			catch (err:Error) {
				//trace(err.message);
				//trace(err.getStackTrace());
				assertTrue("4 5", false);
				return;
			}
			assertCEquals("4 5", e.evaluate(), new Complex(4));
		}

		/**
		 * If there are two expressions in a string, parse just returns the first one
		 */
		public function testParseError3():void {
			try {
				var e:Expression = new Expression("3+4 5");
				//trace(e.evaluate());
			}
			catch (err:Error) {
				//trace(err.message);
				//trace(err.getStackTrace());
				assertTrue("3+4 5", false);
				return;
			}
			assertCEquals("3+4 5", e.evaluate(), new Complex(7));
		}

		//
		// Test Suite
		//
	
		// EVALUATE
		public static function test():void {
			var state:IState = new BasicStateImpl();
			state.define("w", new Expression("2"));
			state.define("z", new Expression("5"));
			state.define("t", new Expression("-2"));
			//echo("u=(z-5)/(5*z-1)");
			//echo("u=(z+3)/(z-3)");
			//echo("u=(z-3)/(z+3)");
			//echo("z = (1.7+(1.2*i))");
			//echo("(((1)))");
			//echo("2^0");
			//echo("z^0");
			//echo("--1");
			//echo("1/0");
			//echo("1+2+4");
			//echo("1*2*4");
			//echo("2+z");
			//echo("t + z");
			//echo("z + t");
			//echo("2*(3+4)")
			//echo("2^-1");
			//echo("3^5");
			//echo("3^5*7");
			//echo("3*5^7");
			//echo("3^5^7"); //overflows
			//echo("z^(1-2*t)");
			//echo("(3+4"); // missing )
			//echo("4 5"); // 2 expressions
			//echo("3+4 5"); // 2 expressions
			echo("-~sin(cos(z))");
			echo("tan(pi/4)");
			echo("~(3+4*i)");
			echo("cos(2)+i*sin(2)");
			echo("abs(cos(2)+i*sin(2))");
			echo("arg(cos(2)+i*sin(2))");
			echo("arg(1+i)/pi*4");
			echo("abs(3+4*i)");
			echo("sqrt(-1)");
			echo("e^(i*pi)");
			echo("exp(i*pi)");
			echo("abs(1+i)^2");
			echo("exp(ln(2))");
			echo("1/exp(ln(2))");
			echo("-sin(z + 2*z)");
			echo("sin(z + 2*z)");
			echo("(z + 2*z)");
			echo("(3 + 2*z)");
			echo("( 2*z)");
			echo("(2*z)");
			echo("2*z");
			echo("z*~z");
			echo("-sin(z + 2z)"); // space inside factor
			echo("3+4*-5", true);
			echo("321*432+543*-4.32e-5");
			echo("1 - 1/2");
			echo("1 - 0.5");
			echo("1 + 2");
			echo("-1 + -2");
			echo("1+2");
			echo("1-2");
			echo("1/2");
			echo("1*2");
			echo("3+4*5");
			echo("3*4+5");
			echo("321*432+543");
			echo("4*-5");
			echo("321*432+543*4.32e-5");
			echo("sin(z)");
			// RELOPS
			echo("abs(z) > 0.5");
			echo("abs(z) > 2");
			echo("abs(z) >= 1");
			echo("abs(z) < 1");
			echo("abs(z) > 1");
			echo("z > 3");
			echo("z > 1");
			echo("2==abs(w)");
			echo("z==i");
			echo("!(abs(z) > 0.5)");
			//
		}
		
		// test differentiation
		private static function difftest():void {
			var state:IState = new BasicStateImpl();
			diff("z", "z");
			diff("2*z", "z");
			diff("z^2", "z");
			diff("z^3", "z");
			diff("z^(-1)", "z");
			diff("3^z", "z");
			diff("1/z", "z");
			diff("1/z^2", "z");
			diff("z^z", "z");
			diff("sin(z)", "z");
			diff("cos(z)", "z");
			diff("tan(z)", "z");
			diff("sinh(z)", "z");
			diff("cosh(z)", "z");
			diff("tanh(z)", "z");
			diff("asin(z)", "z");
			diff("acos(z)", "z");
			diff("atan(z)", "z");
			diff("asinh(z)", "z");
			diff("acosh(z)", "z");
			diff("atanh(z)", "z");
			diff("exp(z)", "z");
			diff("ln(z)", "z");
			diff("sqr(z)", "z");
			diff("sqrt(z)", "z");
			diff("sin(2*z)","z");
			diff("1/sin(z)", "z");
			diff("(z-2)*(z-3)", "z");
			diff("atan(z^3)","z");
		}
		
		// ----
	    
	    public function assertCEquals(... rest) : void {
			var i:int = rest.length - 2;
			var c1:Complex = Complex(rest[i]);
			var c2:Complex = Complex(rest[i+1]);
			if(!c1.finite() && !c2.finite()) {
				assertTrue(true); 
			}
			else {
				var equal:Boolean = (c1.minus(c2).length < Complex.precision);
				assertTrue((i==0) ? "" : rest[0], equal);
			}
		}
		
	 	public static function echo(s:String, evaluate:Boolean=true, parsed:Boolean=true):void {
			var e:Expression;
			try {
				e = new Expression(s);
			}
			catch(err:Error) {
				// if(e.type == null) {
				trace("Syntax " + s + " " + err);
				return;
			}
			try {
				var v:String = evaluate ? (" val: " + e.evaluate()) : "";
				var p:String = parsed ? (" parsed as: " + e.displayString()) : "";
				var t:String = e.getTail()==null ? "" : (" ignored: " + e.getTail());
				trace('"'+ s +'"' +v + p + t);
			}
			catch (err:Error) {
				trace("Evaluation error: " + err);
			}
		}
		
		public static function diff(s:String, wrt:String):void {
			var e:Expression;
			var z:Expression;
			var d:Expression;
			try {
				e = new Expression(s);
				//z = new Expression(wrt)
				d = e.differentiate(wrt);
			}
			catch(err:Error) {
				// if(e.type == null) {
				trace("Syntax " + s + " " + err);
				return;
			}
			try {
				trace("e = " + e.displayString() + " d = " + d.displayString());
			}
			catch (err:Error) {
				trace("Error: " + err);
			}
		}

	}
}