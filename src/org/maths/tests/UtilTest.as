package org.maths.tests {

import flexunit.framework.*;
import org.maths.Util;

public class UtilTest extends TestCase {
	
    public static function suite() : TestSuite {
        var suite : TestSuite = new TestSuite();
        return suite;
    }

    public function UtilTest(name : String = null) {
        super(name);
    }
    
    public function test2DP():void {
    	assertEquals("0.1235",0.12,Util.toDP(0.1235,2));
    	for(var i:int=0; i < 1000; i++) {
    		var n:Number = Math.random()*0.12345679;
    		var s:String = n.toString().substr(0,4);
    		var expect:Number = Number(s);
    		//trace("n - expect1 = " + (n - expect));
    		if(n-expect >= 0.005) expect += 0.0100000000000001;
    		//trace("expect1.5 = " + expect);
    		expect = Number(expect.toString().substr(0,4));
    		//trace("expect2 = " + expect);
     		assertEquals(n.toString(),expect,Util.toDP(n,2));
   		}
     }
	
	public function testNegative2DP():void {
  		assertEquals("negative DP", -0.15, Util.toDP(-0.14999,2));		
	}
	
	public function testNegative3DP():void {
  		assertEquals("negative DP", -100.389, Util.toDP(-100.3889,3));		
	}
	
	public function testNegative0DP():void {
  		assertEquals("negative DP", -100, Util.toDP(-100,0));		
	}
	
	public function test3SigFig():void {
		assertEquals("3 sig fig", 1.23, Util.toSigFig(1.2345,3));
	}
	
	public function testNegative3SigFig():void {
		assertEquals("Neg 3 sig fig", -1.23, Util.toSigFig(-1.2345,3));
	}
	
	public function testNegative3SigFig2():void {
		assertEquals("Neg 3 sig fig 2", -1, Util.toSigFig(-0.999999,3));
	}
	
	public function testLarge3SigFig():void {
		assertEquals("Large 3 sig fig", 1.22e17, Util.toSigFig(1.219e17,3));
	}
	
	public function testLargeNeg1SigFig():void {
		assertEquals("Large Neg 1 sig fig", -1e16, Util.toSigFig(-0.099e17,1));
	}

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