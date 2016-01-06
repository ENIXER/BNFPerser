/*
 * generated by Xtext
 */
package net.unicoen.validation

import net.unicoen.node.UniNode
import net.unicoen.uniMapperGenerator.Atom
import net.unicoen.uniMapperGenerator.Element
import net.unicoen.uniMapperGenerator.ParserRule
import net.unicoen.uniMapperGenerator.RuleRef
import net.unicoen.uniMapperGenerator.UniMapperGeneratorPackage.Literals
import org.eclipse.xtext.validation.Check

//import org.eclipse.xtext.validation.Check
/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class UniMapperGeneratorValidator extends AbstractUniMapperGeneratorValidator {

	@Check
	def checkNodeMembers(ParserRule r) {
		r.eAllContents.filter(Element).forEach [
			if (it.op == null) {
				return
			}
			val body = (it.body as Atom).body
			if (body instanceof RuleRef) {
				val ruleName = body.reference.name
				switch it.op {
					case "TODO": {
						warning('not Implemented: ' + ruleName + ' in ' + r.name, it, Literals.ELEMENT__OP)
					}
					case "ADD":
						return
					case "RETURN":
						return
					case "MERGE":
						r.checkMergeTarget(it, ruleName)
					default: {
						r.checkField(it)
					}
				}
			}
		]
	}

	def checkMergeTarget(ParserRule rule, Element elem, String ruleName) {
//		if (!rule.type.name.equals(elem.referenceReturnType)) {
//			val sb = new StringBuilder
//			sb.append('Type mismatch: The return type of ').append(rule.name).append(' is ').append(
//				rule.type.name).append(' but The return type of ').append(ruleName).append(' is ').append(
//				elem.referenceReturnType).append('.')
//			error(sb.toString, elem, Literals.ELEMENT__BODY)
//		}
	}

	def checkField(ParserRule r, Element elem) {
		val packagePrefix = if(r.type.name.startsWith('Uni')) UniNode.package.name + '.'
		try {
			val clazz = if(packagePrefix != null) Class.forName(packagePrefix + r.type.name)
			try {
				clazz.getField(elem.op)
			} catch (NoSuchFieldException e) {
				val sb = new StringBuilder
				sb.append('Field ').append(elem.op).append(' is not exist. The fields of class ').append(
					r.type.name).append(' are')
				clazz.fields.forEach [
					sb.append(' ').append(it.name)
					sb.append('(').append(it.type.name).append(')')
					if (it != clazz.fields.last) {
						sb.append(',')
					}
				]
				sb.append('.')
				error(sb.toString, elem, Literals.ELEMENT__OP)
			}
		} catch (ClassNotFoundException e) {
			error("No such class: " + r.type.name, r.type, Literals.UNICOEN_TYPE_DEC__NAME)
		}
	}

	def getReferenceReturnType(Element r) {
		if (r.body instanceof Atom) {
			val atom = r.body as Atom
			if (atom.body instanceof RuleRef) {
				val ref = atom.body as RuleRef
				if (ref.reference.type != null) {
					ref.reference.type.name
				}
			}
		}
	}
}
