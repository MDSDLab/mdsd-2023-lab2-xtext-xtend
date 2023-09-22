package webtest.dsl.tests

import org.junit.jupiter.api.Test
import webtest.dsl.WebTestExtensions
import webtest.model.ForEachStatement
import webtest.model.PrintStatement
import webtest.model.Type
import webtest.model.VariableExpression

import static org.junit.jupiter.api.Assertions.*

class NameAnalysisTests extends TestBase {

	@Test
	def void testFlatContext() {
		assertTypes(
		'''
		webtest example.ExampleTest
		
		page A
		    set a to input "q"
		    set b to "hello"
		    set c to 5
		    set d to true
		    
		    operation op1 using x
		        click x
		    end
		end
		
		context as A
		    set Aa to a
		    set Ab to b
		    set Ac to c
		    set Ad to d
		    op1 using button "ok"
		end
		''',
		#{
		"Aa" -> Type.ELEMENT,
		"Ab" -> Type.STRING,
		"Ac" -> Type.INTEGER,
		"Ad" -> Type.BOOLEAN
		});
	}

	@Test
	def void testHierarchicalContext() {
		assertTypes(
		'''
		webtest example.ExampleTest
		
		page A
		    set a to input "q"
		    set b to "hello"
		    set c to 5
		    set d to true
		    
		    operation op1 using x
		        click x
		    end
		end
		
		page B
		    set a to "b"
		    set b to 11
		    
		    operation op1 using y
		        wait y seconds
		    end
		end
		
		page C
		    set a to 7
		    
		    operation op1 using z
		        wait until z
		    end
		end
		
		operation op1 using w
			fill input "q" with w
		end
		
		operation op0 using p,q,r,s
			context as A
			    set Aa to a
			    set Ab to b
			    set Ac to c
			    set Ad to d
			    op1 using p
			    context as B
			        set Ba to a
			        set Bb to b
			        set Bc to c
			        set Bd to d
			        op1 using q
			        context as C
				        set Ca to a
				        set Cb to b
				        set Cc to c
				        set Cd to d
				        op1 using r
			        end
			    end
			end
			op1 using s
		end
		''',
		#{
		"Aa" -> Type.ELEMENT,
		"Ab" -> Type.STRING,
		"Ac" -> Type.INTEGER,
		"Ad" -> Type.BOOLEAN,
		"Ba" -> Type.STRING,
		"Bb" -> Type.INTEGER,
		"Bc" -> Type.INTEGER,
		"Bd" -> Type.BOOLEAN,
		"Ca" -> Type.INTEGER,
		"Cb" -> Type.INTEGER,
		"Cc" -> Type.INTEGER,
		"Cd" -> Type.BOOLEAN,
		"p" -> Type.ELEMENT,
		"q" -> Type.INTEGER,
		"r" -> Type.BOOLEAN,
		"s" -> Type.STRING
		});
	}
	
	@Test
	def void testLocalVariables() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		operation op1 using m
		    set a to 5
		    set b to a
		    set c to m
		end

		set x to 5
		set y to x
		''',
		#[
		]);
	}	
	
	@Test
	def void testLocalVariableErrors() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		operation op1 using m
		    set a to b
		    set b to c
		    set c to m
		end

		set x to y
		set y to z
		set z to 5
		
		set w to true
		if w then
		    set w to 5
		    set u to 7
		else
		    set w to "w"
		end
		set v to u
		''',
		#[
		"Couldn't resolve reference to Variable 'b'.",
		"Couldn't resolve reference to Variable 'c'.",
		"Couldn't resolve reference to Variable 'y'.",
		"Couldn't resolve reference to Variable 'z'.",
		"Couldn't resolve reference to Variable 'u'.",
		"Could not infer the type of the variable 'a'.",
		"Could not infer the type of the variable 'b'.",
		"Could not infer the type of the variable 'x'.",
		"Could not infer the type of the variable 'y'.",
		"Could not infer the type of the variable 'v'.",
		"Variable 'w' is already defined.",
		"Variable 'w' is already defined."
		]);
	}
	
	@Test
	def void testDuplicateTests() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		test t1
		end
		
		test t1
		end
		''',
		#[
		"Test case 't1' is already defined."
		]);
	}	
	
	@Test
	def void testDuplicateVariables() {
		assertErrors(
		'''
		webtest example.ExampleTest
		
		operation op1
			set a to 5
			set a to 10
		end
		
		set b to true
		set b to "hello"
		''',
		#[
		"Variable 'a' is already defined.",
		"Variable 'b' is already defined."
		]);
	}	
	
	@Test
	def void testDuplicateOperations() {
		assertErrors(
		'''
		webtest example.ExampleTest

		page A
			operation op1 using a
				print a
			end
			
			operation op1
			end
			
			operation op1 using x,y
				print x,y
			end
		end

		operation op1 using b
			print b
		end
		
		operation op1
		end
		
		operation op1 using q,r
			print q,r
		end
		''',
		#[
		"Operation 'op1' is already defined.",
		"Operation 'op1' is already defined.",
		"Operation 'op1' is already defined.",
		"Operation 'op1' is already defined."
		]);
	}	
	
	@Test
	def void testDuplicateParameters() {
		assertErrors(
		'''
		webtest example.ExampleTest

		page A
			operation op1 using a,b,a
				print a,b
			end
		end

		operation op1 using x,y,y
			print x,y
		end
		''',
		#[
		"Parameter 'a' is already defined.",
		"Parameter 'y' is already defined.",
		"Could not infer the type of the variable 'a'.",
		"Could not infer the type of the variable 'y'."
		]);
	}
	
	@Test
	def void testLocalHidesParameter() {
		assertErrors(
		'''
		webtest example.ExampleTest

		page A
			operation op1 using a,b
				set a to 5
				print a,b
			end
		end

		operation op1 using x,y
			set y to "hello"
			print x,y
		end
		''',
		#[
		"Variable 'a' is already defined.",
		"Variable 'y' is already defined.",
		"Could not infer the type of the variable 'a'.",
		"Could not infer the type of the variable 'y'."
		]);
	}
	
	@Test
	def void testDuplicateArguments() {
		assertErrors(
		'''
		webtest example.ExampleTest

		page A
			operation op1 using a,b
				print a,b
			end
		end

		operation op1 using x,y
			print x,y
		end
		
		op1 using y:"hello",x:5,x:true
		context as A
			op1 using a:5,a:true,b:"hello"
		end
		''',
		#[
		"Argument 'a' is already defined.",
		"Argument 'x' is already defined.",
		"Operation 'op1' has 2 parameters but 3 arguments were specified.",
		"Operation 'op1' has 2 parameters but 3 arguments were specified."
		]);
	}
	
	@Test
	def void testInvalidArguments() {
		assertErrors(
		'''
		webtest example.ExampleTest

		page A
			operation op1 using a,b
				print a,b
			end
		end

		operation op1 using x,y
			print x,y
		end
		
		op1 using y:"hello",z:true
		context as A
			op1 using b:true,c:"hello"
		end
		''',
		#[
		"Operation 'op1' does not have a parameter named 'z'.",
		"Operation 'op1' does not have a parameter named 'c'.",
		"Argument for parameter 'x' missing.",
		"Argument for parameter 'a' missing."
		]);
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
			
			operation opA using opAA
				print opAA
			end
			
			operation opD using opAD
				print opAD
			end
		end
		
		page B
			set a to false
			set c to input "q"
			
			operation opA using opBA
				print opBA
			end

			operation opB using opBB
				print opBB
			end
		end
		
		page C : A, B
			set a to "x"
			set c to 3
			
			operation opA using opCA
				print opCA
			end
			
			operation opC using opCC
				print opCC
			end
		end
		
		page D : A, B
			set a to 10
			set b to true
			set c to "a"
			
			operation opA using opDA
				print opDA
			end
			
			operation opD using opDD
				print opDD
			end
		end

		context as A
			set Aa to a
			set Ab to b
			set Ac to c
			set Ad to d
			opA using opAA:5
			opD using opAD:5
		end

		context as B
			set Ba to a
			set Bc to c
			opA using opBA:5
			opB using opBB:5
		end

		context as C
			set Ca to a
			set Cb to b
			set Cc to c
			set Cd to d
			opA using opCA:5
			opB using opBB:5
			opC using opCC:5
			opD using opAD:5
		end

		context as D
			set Da to a
			set Db to b
			set Dc to c
			set Dd to d
			opA using opDA:5
			opB using opBB:5
			opD using opDD:5
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
	def void testBasePagesErrors() {
		if (!WebTestExtensions.ENABLE_BASE_PAGES) return;
		assertErrors(
		'''
		webtest example.ExampleTest

		page A
			set a to 5
			set b to "hello"
			set c to true
			set d to input "q"
			
			operation opA using opAA
				print opAA
			end
			
			operation opD using opAD
				print opAD
			end
		end
		
		page B
			set a to false
			set c to input "q"
			
			operation opA using opBA
				print opBA
			end

			operation opB using opBB
				print opBB
			end
		end
		
		page C : A, B
			set a to "x"
			
			operation opA using opCA
				print opCA
			end
			
			operation opC using opCC
				print opCC
			end
		end
		
		page D : A, B
			set b to true
			
			operation opA using opDA
				print opDA
			end
			
			operation opD using opDD
				print opDD
			end
		end
		
		page X : Y
			set x to 5
		end
		
		page Y : X
			set y to true
		end
		
		context as X
			if y then
				wait x seconds
			end
		end
		
		context as Y
			if y then
				wait x seconds
			end
		end
		''',
		#[
		"Variable 'c' is inherited ambiguously, it must be overriden in page 'C'.",	
		"Variable 'a' is inherited ambiguously, it must be overriden in page 'D'.",	
		"Variable 'c' is inherited ambiguously, it must be overriden in page 'D'.",	
		"Page 'X' is in a circular inheritance.",	
		"Page 'Y' is in a circular inheritance."	
		]);
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
		
		operation op2
		    capture page
		end
		''',
		#{
		"a" -> Type.ELEMENT
		});
	}	

	@Test
	def void testForEach() {
		if (!WebTestExtensions.ENABLE_FOR_EACH) return;
		val main = assertTypes(
		'''
		webtest example.ExampleTest

		foreach a in input "a"
			set b to a
			print a,b
		end
		
		foreach a in tr ""
			set c to a
			print a,c
		end
		''',
		#{
		"b" -> Type.ELEMENT,
		"c" -> Type.ELEMENT
		});
		val fe1 = main.body.statements.filter(ForEachStatement).get(0)
		val a1 = fe1.item
		val p1 = fe1.body.statements.get(1) as PrintStatement
		val pa1 = (p1.values.get(0) as VariableExpression).variable

		val fe2 = main.body.statements.filter(ForEachStatement).get(1)
		val a2 = fe2.item 
		val p2 = fe2.body.statements.get(1) as PrintStatement
		val pa2 = (p2.values.get(0) as VariableExpression).variable
		
		assertEquals(a1, pa1)
		assertEquals(a2, pa2)
		assertNotEquals(a1, a2)
		assertNotEquals(pa1, pa2)
	}	

	@Test
	def void testForEachErrors() {
		if (!WebTestExtensions.ENABLE_FOR_EACH) return;
		assertErrors(
		'''
		webtest example.ExampleTest

		operation op1 using x
			foreach x in input "x"
				print x
			end
		end

		set a to 7

		foreach a in input "a"
			set b to a
			print a,b
		end

		foreach b in input "b"
			foreach b in div "q"
				print b
			end
		end
		''',
		#[
		"Variable 'x' is already defined.",
		"Could not infer the type of the variable 'x'.",
		"Variable 'a' is already defined.",
		"Variable 'b' is already defined."
		]);
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
	def void testDuplicateManual() {
		if (!WebTestExtensions.ENABLE_MANUAL) return;
		assertErrors(
		'''
		webtest example.ExampleTest

		manual m1
		end

		manual m1
		end
		''',
		#[
		"Manual 'm1' is already defined."
		]);
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
	
	@Test
	def void testDuplicateTestParameters() {
		assertErrors(
		'''
		webtest example.ExampleTest

		test t1 using a,b,c,a
		with input "q", "hello", 5, true
		with c:10, b:"world", a: input "r"
		  fill a with b
		  wait c seconds
		end
		''',
		#[
		"Parameter 'a' is already defined.",
		"Could not infer the type of the variable 'a'.",
		"Test case 't1' has 4 parameters but 3 arguments were specified."
		]);
	}
	
	@Test
	def void testLocalHidesTestParameter() {
		assertErrors(
		'''
		webtest example.ExampleTest

		test t1 using a,b,c,d
		with input "q", "hello", 5, true
		with d:false, c:10, b:"world", a: input "r"
		  set b to 11
		  fill a with "x"
		  wait c seconds until d
		end
		''',
		#[
		"Variable 'b' is already defined.",
		"Could not infer the type of the variable 'b'."
		]);
	}
	
	@Test
	def void testDuplicateTestArguments() {
		assertErrors(
		'''
		webtest example.ExampleTest

		test t1 using a,b,c,d
		with input "q", "hello", 5, true
		with d:false, c:10, b:"world", d:true, a: input "r"
		  fill a with b
		  wait c seconds until d
		end
		''',
		#[
		"Argument 'd' is already defined.",
		"Test case 't1' has 4 parameters but 5 arguments were specified."
		]);
	}
	
	@Test
	def void testInvalidTestArguments() {
		assertErrors(
		'''
		webtest example.ExampleTest

		test t1 using a,b,c,d
		with input "q", "hello", 5, true
		with d:false, c:10, b:"world", z: input "r"
		  fill a with b
		  wait c seconds until d
		end
		''',
		#[
		"Test case 't1' does not have a parameter named 'z'.",
		"Argument for parameter 'a' missing."
		]);
	}
	
}