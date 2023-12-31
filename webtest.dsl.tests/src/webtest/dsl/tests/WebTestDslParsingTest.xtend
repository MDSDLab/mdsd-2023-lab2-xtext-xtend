/*
 * generated by Xtext 2.30.0
 */
package webtest.dsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import webtest.model.Main

@ExtendWith(InjectionExtension)
@InjectWith(WebTestDslInjectorProvider)
class WebTestDslParsingTest {
	@Inject
	ParseHelper<Main> parseHelper
	
	@Test
	def void loadModel() {
		val result = parseHelper.parse('''
			webtest example.ExampleTest
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
}
