package org.maths.tests {

import flexunit.framework.*;

public class TrialTest extends TestCase {
	
    public static function suite() : TestSuite {
        var suite : TestSuite = new TestSuite();
        suite.addTest(new TrialTest("testFalse"));
        suite.addTest(new TrialTest("testTrue"));
        suite.addTest(new TrialTest("testEquals"));
        suite.addTest(new TrialTest("testStrictlyEquals"));
        suite.addTest(new TrialTest("testUndefined"));
        suite.addTest(new TrialTest("testNull"));
        suite.addTest(new TrialTest("testNotNull"));
        return suite;
    }

    public function TrialTest(name : String = null) {
        super(name);
    }

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


}
}