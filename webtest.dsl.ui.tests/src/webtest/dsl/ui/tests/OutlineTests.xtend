package webtest.dsl.ui.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import org.eclipse.xtext.ui.testing.AbstractOutlineTest
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import webtest.dsl.WebTestExtensions

@ExtendWith(InjectionExtension)
@InjectWith(WebTestDslUiInjectorProvider)
class OutlineTests extends AbstractOutlineTest {
	
	@Test
	def void testOutline() {
		val code = 
		'''
		webtest example.WizardTest
		
		page LoginPage
			set username to input "username"
			set password to input "password"
			set loginButton to button "Log in"
		  
			operation login using u,p
				fill username with u
				fill password with p
				click loginButton
			end
		end
		
		test LoginTest
			open "https://example.com/login"
			context as LoginPage
				login using "Alice", "a"
			end
		end
		
		operation sayHello
			print "hello"
		end
		
		print "world"
		'''
		
		val outline = getOutlineTree(code)
		Assertions.assertEquals(3, outline.children.size)

		val loginPage = outline.children.get(0)
		checkNode(loginPage, "LoginPage", 4)
		checkNode(loginPage.children.get(0), "username: ELEMENT", 0)
		checkNode(loginPage.children.get(1), "password: ELEMENT", 0)
		checkNode(loginPage.children.get(2), "loginButton: ELEMENT", 0)
		checkNode(loginPage.children.get(3), "login(u: STRING, p: STRING)", 0)

		checkNode(outline.children.get(1), "LoginTest", 0)
		checkNode(outline.children.get(2), "sayHello()", 0)
		
	}
	
	@Test
	def void testOutlineWithManual() {
		if (!WebTestExtensions.ENABLE_MANUAL) return;
		val code = 
		'''
		webtest example.WizardTest
		
		page LoginPage
			set username to input "username"
			set password to input "password"
			set loginButton to button "Log in"
		  
			operation login using u,p
				fill username with u
				fill password with p
				click loginButton
			end
		end
		
		manual Search
			set q to input "q"
			set search to button "search"
			open "https://www.google.com"
			print "Type 'jwst' to the search field:"
			fill q with "jwst"
			print "Click the 'search' button:"
			click search
		end
		
		test LoginTest
			open "https://example.com/login"
			context as LoginPage
				login using "Alice", "a"
			end
		end
		
		operation sayHello
			print "hello"
		end
		
		print "world"
		'''
		
		val outline = getOutlineTree(code)
		Assertions.assertEquals(4, outline.children.size)

		val loginPage = outline.children.get(0)
		checkNode(loginPage, "LoginPage", 4)
		checkNode(loginPage.children.get(0), "username: ELEMENT", 0)
		checkNode(loginPage.children.get(1), "password: ELEMENT", 0)
		checkNode(loginPage.children.get(2), "loginButton: ELEMENT", 0)
		checkNode(loginPage.children.get(3), "login(u: STRING, p: STRING)", 0)

		checkNode(outline.children.get(1), "Search", 0)
		checkNode(outline.children.get(2), "LoginTest", 0)
		checkNode(outline.children.get(3), "sayHello()", 0)
	}
	
	@Test
	def void testOutlineWithTestParams() {
		if (!WebTestExtensions.ENABLE_TEST_PARAMS) return;
		val code = 
		'''
		webtest example.WizardTest
		
		page LoginPage
			set username to input "username"
			set password to input "password"
			set loginButton to button "Log in"
		  
			operation login using u,p
				fill username with u
				fill password with p
				click loginButton
			end
		end
		
		test LoginTest using u,p
		with u:"Alice",p:"a"
		with u:"Bob",p:"b"
			open "https://example.com/login"
			context as LoginPage
				login using u,p
			end
		end
		
		operation sayHello
			print "hello"
		end
		
		print "world"
		'''
		
		val outline = getOutlineTree(code)
		Assertions.assertEquals(3, outline.children.size)

		val loginPage = outline.children.get(0)
		checkNode(loginPage, "LoginPage", 4)
		checkNode(loginPage.children.get(0), "username: ELEMENT", 0)
		checkNode(loginPage.children.get(1), "password: ELEMENT", 0)
		checkNode(loginPage.children.get(2), "loginButton: ELEMENT", 0)
		checkNode(loginPage.children.get(3), "login(u: STRING, p: STRING)", 0)

		checkNode(outline.children.get(1), "LoginTest(u: STRING, p: STRING)", 0)
		checkNode(outline.children.get(2), "sayHello()", 0)
	}
	
	private def checkNode(IOutlineNode node, String label, int children) {
		Assertions.assertEquals(label, getNodeText(node))
		Assertions.assertEquals(children, node.children.size)
	} 
}