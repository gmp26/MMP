package org.maths.tests {

import flexunit.framework.*;
import org.maths.Complex;

public class ComplexTest extends TestCase {
	
	public static var precision:Number = 1e-14;
	
    public static function suite() : TestSuite {
        var suite : TestSuite = new TestSuite();
        return suite;
    }

    public function ComplexTest(name : String = null) {
        super(name);
    }
    
    public function testOneEqualsOne():void {
    	var c1:Complex = new Complex(1);
    	var c2:Complex = new Complex(1,0);
    	assertTrue(c1.boolEquals(c2));
    }

    public function testMinusOneEqualsOneCis180():void {
    	var c1:Complex = new Complex(-1);
    	var c2:Complex = new Complex(1,Math.PI,true);
    	assertTrue(c1.minus(c2).length < precision);
    }

	public function testPlus():void {
		var c1:Complex = new Complex(1,1);
		var c2:Complex = new Complex(3.2, -0.88);
		assertTrue("commutative plus", c1.plus(c2).minus(c2.plus(c1)).length==0);
	}
	
	public function testDivideByZero():void {
		assertTrue("Divide By Zero", Complex.ONE.over(Complex.ZERO).boolEquals(Complex.INFINITY)); 
	}
	
	public function testEuler():void {
	 	assertTrue("Euler's equation", Complex.ONE.plus((new Complex(Math.E)).pow(new Complex(0,Math.PI))).length < precision);
	}
	
	public function testLogExp():void {
		var z:Complex = new Complex(2,1,true);
		assertTrue("Log Exp are inverse", z.ln().exp().minus(z).length < precision);
	}
	
	public function testArgument():void {
		var z:Complex = Complex.ONE.plus(Complex.I);
		var arg:Complex = new Complex(Math.PI/4,0);
		assertTrue("Argument", z.arg().minus(arg).length < precision);
	}
	
	public function testArgument2():void {
		var z:Complex = Complex.ONE.minus(Complex.I);
		var arg:Complex = new Complex(-Math.PI/4,0);
		assertTrue("Argument", z.arg().minus(arg).length < precision);
	}
	
	public function testSinAsin():void {
		var z:Complex;
		var s:Complex;
		for(var i:Number = -Math.PI; i < Math.PI; i += 0.05) {
			z = new Complex(1,i,true);
			s = z.sin().asin();
			assertTrue("asin inverts sin", z.minus(s).length < precision);
		}
	}
	
	public function testOver():void {
		var w:Complex = new Complex(1,2*Math.PI/3,true);
		var z:Complex = Complex.ONE.over(w).over(w).over(w);
		assertTrue("third root of unity", Complex.ONE.minus(z).length < precision);
	}
	
	public function testOver2():void {
		var w:Complex = new Complex(1,Math.PI/6,true);
		var z:Complex = Complex.ONE.over(w.times(w)).over(w.times(w)).over(w.pow(8));
		assertTrue("third root of unity", Complex.ONE.minus(z).length < precision);
	}
	
	public function testToString():void {
		Complex.util.rounding = "dp";
		Complex.util.figures = 2;
		assertEquals("to String", "3.25", new Complex(3.249,0).displayString());
	}
	
	public function testRounding():void {
		Complex.util.rounding = "sf";
		Complex.util.figures = 5;
		assertEquals("to 5sig fig String", "0.0012346", new Complex(0.00123456,0).displayString());		
	}
	
	// Following gives a compile error - as it should...
	/*
	public function writeOnly():void {
		Complex.ONE = new Complex(2);
	}
	*/
	
	// ------
	/*
    public function testFalse():void {
    	assertFalse("False", false);
    }

    public function testTrue():void {
    	assertTrue("True", true);
    }

   	public function testEquals():void {
    	assertEquals("Equals", 1, "1");
    }

   	public function testStrictlyEquals():void {
   		var foo:Object = "bar";
   		var zoo:Object = foo;
    	assertStrictlyEquals("StrictlyEquals", foo, zoo);
    }
    
	public function testUndefined():void {
		var foo:Array;
    	assertUndefined("Undefined", foo);
    }

	public function testNull():void {
		var foo:Object;
    	assertNull("Null", foo);
    }

	public function testNotNull():void {
		var foo:Number;
    	assertNotNull("NotNull", foo);
    }
	*/

}
}