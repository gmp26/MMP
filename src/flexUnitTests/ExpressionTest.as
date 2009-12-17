package flexUnitTests
{
	import flexunit.framework.TestSuite;
	
	import org.maths.tests.ExpressionTest;
	
	public class ExpressionTest extends TestSuite
	{
		public function ExpressionTest(param:Object=null)
		{
			super(param);
		}
		
		public static function suite():TestSuite
		{
			var newTestSuite:TestSuite = new TestSuite();
			newTestSuite.addTestSuite(org.maths.tests.ExpressionTest);
			return newTestSuite;
		}
	}
}