package org.maths.tests {

	import flexunit.framework.TestSuite;
	import org.maths.tests.ComplexTest;
	import org.maths.tests.UtilTest;
	
	public class AllTests
	{
		public static function suite() : TestSuite
		{
			var testSuite:TestSuite = new TestSuite();		
			
			//testSuite.addTestSuite( TrialTest );
			//testSuite.addTestSuite( ComplexTest );
			//testSuite.addTestSuite( UtilTest );
			testSuite.addTestSuite( ExpressionTest );
			
			return testSuite;
		}
	}

}