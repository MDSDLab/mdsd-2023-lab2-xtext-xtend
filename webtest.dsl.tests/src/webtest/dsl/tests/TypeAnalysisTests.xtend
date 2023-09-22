package webtest.dsl.tests

import org.junit.jupiter.api.Test
import webtest.dsl.WebTestExtensions
import webtest.model.Type

class TypeAnalysisTests extends TestBase {
	
	@Test
	def void testInference() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		operation hello using a
		    fill input "username" with a
		end
		''',
		#[
		]);
	}

	@Test
	def void testInferenceError() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		operation hello using a
		end
		''',
		#[
		"Could not infer the type of the variable 'a'."
		]);
	}

	@Test
	def void testInferenceError2() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		operation hello using a
		    fill input "username" with a
		    wait a seconds
		end
		''',
		#[
		"Could not infer the type of the variable 'a'."
		]);
	}

	@Test
	def void testExpectInteger() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		set a to 5
		wait a seconds
		''',
		#[
		]);
	}

	@Test
	def void testExpectIntegerError() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		set a to "hello"
		wait a seconds
		''',
		#[
		"Expression of type INTEGER expected but STRING was found." 
		]);
	}

	@Test
	def void testExpectString() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		set a to "Alice"
		fill input "user" with a
		''',
		#[
		]);
	}

	@Test
	def void testExpectStringError() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		set a to 5
		fill input "user" with a
		''',
		#[
		"Expression of type STRING expected but INTEGER was found." 
		]);
	}

	@Test
	def void testExpectBoolean() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		set a to true
		if a then
		end
		
		set b to false
		while b do
		end
		''',
		#[ 
		]);
	}

	@Test
	def void testExpectBooleanError() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		set a to "hello"
		if a then
		end
		
		set b to 5
		while b do
		end
		''',
		#[ 
		"Expression of type BOOLEAN expected but STRING was found.",
		"Expression of type BOOLEAN expected but INTEGER was found."
		]);
	}

	@Test
	def void testExpectElement() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		set a to input "user"
		click a
		''',
		#[
		]);
	}	

	@Test
	def void testExpectElementError() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		set a to "user"
		click a
		''',
		#[
		"Expression of type ELEMENT expected but STRING was found." 
		]);
	}
	
	@Test
	def void testUndefinedErrorAny() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
		end		

		operation op2 using b
		    click b
		    fill input "q" with b
		end		

		operation op3 using c
		    print c
		end		
		''',
		#{
		"a" -> Type.ERROR,
		"b" -> Type.ERROR,
		"c" -> Type.ANY
		});
	}	
	
	@Test
	def void testIsExpression() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a,b
			set c to a is b
		end		
		''',
		#{
		"a" -> Type.ELEMENT,
		"b" -> Type.STRING,
		"c" -> Type.BOOLEAN
		});
	}	
	
	@Test
	def void testContainsExpression() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a,b
			set c to a contains b
		end		
		''',
		#{
		"a" -> Type.ELEMENT,
		"b" -> Type.STRING,
		"c" -> Type.BOOLEAN
		});
	}	
	
	@Test
	def void testExistsExpression() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
			set c to a exists
		end		
		''',
		#{
		"a" -> Type.ELEMENT,
		"c" -> Type.BOOLEAN
		});
	}	
	
	@Test
	def void testNotExpression() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
			set c to not a
		end		
		''',
		#{
		"a" -> Type.BOOLEAN,
		"c" -> Type.BOOLEAN
		});
	}	
	
	@Test
	def void testConstantExpression() {
		assertTypes(
		'''
		webtest example.ExampleTest

		set a to "hello"
		set b to 5
		set c to true
		set d to input "q"
		set e to a
		set f to b
		set g to c
		set h to d 
		''',
		#{
		"a" -> Type.STRING,
		"b" -> Type.INTEGER,
		"c" -> Type.BOOLEAN,
		"d" -> Type.ELEMENT,
		"e" -> Type.STRING,
		"f" -> Type.INTEGER,
		"g" -> Type.BOOLEAN,
		"h" -> Type.ELEMENT
		});
	}	
	
	@Test
	def void testSetStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
			set c to a
		end		
		''',
		#{
		"a" -> Type.ANY,
		"c" -> Type.ANY
		});
	}	
	
	@Test
	def void testIfStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
			if a then
			else
			end
		end		
		''',
		#{
		"a" -> Type.BOOLEAN
		});
	}	
	
	@Test
	def void testWhileStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
			while a do
			end
		end		
		''',
		#{
		"a" -> Type.BOOLEAN
		});
	}	
	
	@Test
	def void testCallStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a,b,c,d
			if a then
			    fill b with c
			else
			    wait d seconds
			end
		end
		
		operation op2 using e,f,g,h
		    op1 using e,f,g,h
		end	
		
		operation op3 using i,j,k,l
		    op1 using d:i,c:j,b:k,a:l
		end	
		''',
		#{
		"a" -> Type.BOOLEAN,
		"b" -> Type.ELEMENT,
		"c" -> Type.STRING,
		"d" -> Type.INTEGER,
		"e" -> Type.BOOLEAN,
		"f" -> Type.ELEMENT,
		"g" -> Type.STRING,
		"h" -> Type.INTEGER,
		"l" -> Type.BOOLEAN,
		"k" -> Type.ELEMENT,
		"j" -> Type.STRING,
		"i" -> Type.INTEGER
		});
	}
	
	@Test
	def void testOpenStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
			open a
		end		
		''',
		#{
		"a" -> Type.STRING
		});
	}	
	
	@Test
	def void testFillStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a,b
			fill a with b
		end		
		''',
		#{
		"a" -> Type.ELEMENT,
		"b" -> Type.STRING
		});
	}	

	@Test
	def void testClickStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
			click a
		end		
		''',
		#{
		"a" -> Type.ELEMENT
		});
	}	
	
	@Test
	def void testContextStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		page X
		end

		operation op1 using a
			context a as X
			end
		end		

		operation op2 using b
			context b
			end
		end		
		''',
		#{
		"a" -> Type.ELEMENT,
		"b" -> Type.ELEMENT
		});
	}

	@Test
	def void testPrintStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
			print a
		end		
		''',
		#{
		"a" -> Type.ANY
		});
	}	

	@Test
	def void testAssertStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
			assert a
		end		
		''',
		#{
		"a" -> Type.BOOLEAN
		});
	}	

	@Test
	def void testWaitStatement() {
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a,b
			wait a seconds until b
		end		

		operation op2 using c
			wait c seconds
		end		

		operation op3 using d
			wait until d
		end		
		''',
		#{
		"a" -> Type.INTEGER,
		"b" -> Type.BOOLEAN,
		"c" -> Type.INTEGER,
		"d" -> Type.BOOLEAN
		});
	}	

	@Test
	def void testBasePages() {
		if (!WebTestExtensions.ENABLE_BASE_PAGES) return;
		assertTypes(
		'''
		webtest example.ExampleTest

		page A
			set a to 5
			set b to "hello"
			set c to true
			set d to input "q"
		end
		
		page B
			set a to false
			set c to input "q"
		end
		
		page C : A, B
			set a to "x"
			set c to 3
		end
		
		page D : A, B
			set a to 10
			set b to true
			set c to "a"
		end

		context as A
			set Aa to a
			set Ab to b
			set Ac to c
			set Ad to d
		end

		context as B
			set Ba to a
			set Bc to c
		end

		context as C
			set Ca to a
			set Cb to b
			set Cc to c
			set Cd to d
		end

		context as D
			set Da to a
			set Db to b
			set Dc to c
			set Dd to d
		end
		''',
		#{
		"Aa" -> Type.INTEGER,
		"Ab" -> Type.STRING,
		"Ac" -> Type.BOOLEAN,
		"Ad" -> Type.ELEMENT,
		"Ba" -> Type.BOOLEAN,
		"Bc" -> Type.ELEMENT,
		"Ca" -> Type.STRING,
		"Cb" -> Type.STRING,
		"Cc" -> Type.INTEGER,
		"Cd" -> Type.ELEMENT,
		"Da" -> Type.INTEGER,
		"Db" -> Type.BOOLEAN,
		"Dc" -> Type.STRING,
		"Dd" -> Type.ELEMENT
		});
	}	

	@Test
	def void testCapture() {
		if (!WebTestExtensions.ENABLE_CAPTURE) return;
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
		    capture a
		end
		''',
		#{
		"a" -> Type.ELEMENT
		});
	}	

	@Test
	def void testForEach() {
		if (!WebTestExtensions.ENABLE_FOR_EACH) return;
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a
		    foreach i in a
		    end
		end
		''',
		#{
		"a" -> Type.ELEMENT,
		"i" -> Type.ELEMENT
		});
	}	

	@Test
	def void testJavaScript() {
		if (!WebTestExtensions.ENABLE_JAVA_SCRIPT) return;
		assertTypes(
		'''
		webtest example.ExampleTest

		operation op1 using a,b,c
		    javascript a using b,c
		end
		''',
		#{
		"a" -> Type.STRING,
		"b" -> Type.ANY,
		"c" -> Type.ANY
		});
	}	

	@Test
	def void testManual() {
		if (!WebTestExtensions.ENABLE_MANUAL) return;
		assertTypes(
		'''
		webtest example.ExampleTest

		manual m1
		  set a to "hello"
		  fill input "q" with a
		  click button "ok"
		end
		''',
		#{
		"a" -> Type.STRING
		});
	}	

	@Test
	def void testTestParams() {
		if (!WebTestExtensions.ENABLE_TEST_PARAMS) return;
		assertTypes(
		'''
		webtest example.ExampleTest

		test t1 using a,b,c,d
		with input "q", "hello", 5, true
		with d:false, c:10, b:"world", a: input "r"
		  fill a with b
		  wait c seconds until d
		end
		''',
		#{
		"a" -> Type.ELEMENT,
		"b" -> Type.STRING,
		"c" -> Type.INTEGER,
		"d" -> Type.BOOLEAN
		});
	}	
}