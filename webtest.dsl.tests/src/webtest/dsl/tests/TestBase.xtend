package webtest.dsl.tests

import java.util.ArrayList
import java.util.HashSet
import java.util.Map
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.^extension.ExtendWith
import webtest.dsl.WebTestParser
import webtest.model.Main
import webtest.model.Type
import webtest.model.Variable

import static org.junit.jupiter.api.Assertions.*

@ExtendWith(InjectionExtension)
@InjectWith(WebTestDslInjectorProvider)
class TestBase {
	def Main assertErrors(CharSequence code, Iterable<String> expectedErrors) {
		val parser = new WebTestParser(code)
		val actalErrors = parser.issues.filter[it.severity == Severity.ERROR].map[it.message].toList
		val unusedActualErrors = new ArrayList<String>(actalErrors)
		val unusedExpectedErrors = new ArrayList<String>()
		unusedExpectedErrors.addAll(expectedErrors);
		for (ae: actalErrors) {
			unusedExpectedErrors.remove(ae)
		}
		for (ae: expectedErrors) {
			unusedActualErrors.remove(ae)
		}
		if (unusedActualErrors.size > 0) {
			assertTrue(false, "Unexpected error: "+unusedActualErrors.get(0))
		}
		if (unusedExpectedErrors.size > 0) {
			assertTrue(false, "Expected error missing: "+unusedExpectedErrors.get(0))
		}
		return parser.model
	}
	
	def Main assertTypes(CharSequence code, Map<String, Type> variables) {
		val parser = new WebTestParser(code)
		val hasAnyErrors = variables.values.exists[it == Type.ERROR]
		if (!hasAnyErrors && parser.hasAnyErrors) {
			assertTrue(false, "Unexpected error: "+parser.firstError)
		}
		val codeVariables = EcoreUtil2.getAllContentsOfType(parser.model, Variable);
		val missingVariables = new HashSet<String>(variables.keySet) 
		for (v: codeVariables) {
			if (variables.containsKey(v.name)) {
				missingVariables.remove(v.name)
				val expectedType = variables.get(v.name)
				if (v.type != expectedType) {
					assertTrue(false, "Variable '"+v.name+"' must have a type "+expectedType+", but the compiler inferred "+v.type+".")
				}
			}
		}
		for (v: missingVariables) {
			assertTrue(false, "Variable '"+v+"' was not created by the compiler.")
		}
		return parser.model
	}
}