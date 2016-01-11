/*
 * generated by Xtext
 */
package net.unicoen.testcasegenerator.validation

import org.eclipse.xtext.validation.Check
import net.unicoen.testcasegenerator.testCaseGenerator.ClassName
import net.unicoen.testcasegenerator.testCaseGenerator.TestCaseGeneratorPackage.Literals
import net.unicoen.testcasegenerator.testCaseGenerator.TestCase
import net.unicoen.testcasegenerator.testCaseGenerator.NodeArchitecture

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class TestCaseGeneratorValidator extends AbstractTestCaseGeneratorValidator {

	@Check(NORMAL)
	def checkClassName(ClassName className) {
		if (!Character.isUpperCase(className.name.charAt(0))) {
			warning("Class name should start with a upper-case", Literals.CLASS_NAME__NAME);
		}
	}

	@Check(NORMAL)
	def checkTestCaseName(TestCase testCase) {
		if (!Character.isLowerCase(testCase.name.charAt(0))) {
			warning("Test case name should start with a lower-case", Literals.TEST_CASE__NAME)
		}
	}

	@Check(FAST)
	def checkNodeClass(NodeArchitecture arch) {
		val className = arch.nodeType
		try {
			val cls = Class.forName("net.unicoen.node." + className)
			if (arch.castType != null) {
				val castClassName = arch.castType
				try {
					val castCls = Class.forName("net.unicoen.node." + castClassName)
					if (!castCls.isAssignableFrom(cls)) {
						error("Class " + className + " cannot cast to " + castClassName,
							Literals.NODE_ARCHITECTURE__NODE_TYPE)
					}
				} catch (ClassNotFoundException e) {
					error("Class " + castClassName + " is not found in package \"net.unicoen.node\".",
						Literals.NODE_ARCHITECTURE__CAST_TYPE)
				}
			}
		} catch (ClassNotFoundException e) {
			error("Class " + className + " is not found in package \"net.unicoen.node\".",
				Literals.NODE_ARCHITECTURE__NODE_TYPE)
		}
	}

	@Check(FAST)
	def checkFieldName(NodeArchitecture arch) {
		val className = arch.nodeType
		try {
			val cls = Class.forName("net.unicoen.node." + className)
			val fields = cls.fields.map[it.name]
			arch.children.forEach [
				if (!fields.contains(it.fieldName)) {
					error(
						"Field " + it.fieldName + " cannot be found in class " + className + ".\nThe fields of class " +
							className + " is " + fields.toString + ".", it, Literals.CHILD_DECLARATION__FIELD_NAME)
				}
			]
		} catch (ClassNotFoundException e) {
		}
	}
}