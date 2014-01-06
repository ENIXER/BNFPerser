/*
 * generated by Xtext
 */
package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess

import org.xtext.example.mydsl.myDsl.Rule
import org.xtext.example.mydsl.myDsl.Model
import org.xtext.example.mydsl.myDsl.Expression

class MyDslGenerator implements IGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		for (m : resource.allContents.toIterable.filter(Model)) {
			fsa.generateFile(
				m.gram.gname.substring(0, 1).toUpperCase() + m.gram.gname.substring(1).toLowerCase() + ".g4",
				m.compile)
		}
	}

	def compile(Model m) '''
	grammar «m.gram.gname»;
	
	«FOR r : m.rules»«IF Character.isLowerCase(r.name.charAt(0))»«r.acompile»«ENDIF»«ENDFOR»
	
	«FOR r : m.rules»«IF Character.isUpperCase(r.name.charAt(0))»«r.bcompile»«ENDIF»«ENDFOR»
	
	Whitespace:
		[ \r\n\t] -> skip;'''

	def acompile(Rule r) '''«r.name»:
	«r.expression.acompile»;
	'''

	def acompile(Expression exp) '''«FOR ele : exp.elements»«FOR t : ele.terms»«FOR r : t.RCall»«IF !exp.elements.head.
		equals(ele) && ele.terms.head.equals(t)»| «ENDIF»«r.ref.name» «ENDFOR»«ENDFOR»«ENDFOR»'''

	def bcompile(Rule r) '''«r.name»:
	«r.expression.bcompile»;
	'''

	def bcompile(Expression exp) '''«FOR ele : exp.elements»«FOR t : ele.terms»«FOR k : t.KConstr»«IF !exp.elements.head.
		equals(ele) && ele.terms.head.equals(t)»| «ENDIF»'«k.SChar»' «IF !k.EChar.nullOrEmpty».. '«k.EChar»' «ENDIF»«ENDFOR»«ENDFOR»«ENDFOR»'''
}
