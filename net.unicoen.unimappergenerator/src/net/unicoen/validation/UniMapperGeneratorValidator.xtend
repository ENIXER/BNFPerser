/*
 * generated by Xtext
 */
package net.unicoen.validation

import org.eclipse.xtext.validation.Check
import net.unicoen.node.UniNode
import net.unicoen.uniMapperGenerator.*

//import org.eclipse.xtext.validation.Check
/**
 * Custom validation rules. 
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class UniMapperGeneratorValidator extends AbstractUniMapperGeneratorValidator {

	@Check
	def checkNodeMembers(ParserRule r) {
		val packagePrefix = if(r.type.list.bind.startsWith('Uni')) UniNode.package.name + '.'
		try {
			val clazz = if(packagePrefix != null) Class.forName(packagePrefix + r.type.list.bind)

			r.eAllContents.filter(ElementWithDollar).forEach [
				if (it.op == null) {
					return
				}
				val ruleName = ((it.body.body as Atom).body as RuleRef).reference.name
				switch it.op {
					case "TODO": {
						warning('not Implemented: ' + ruleName + ' in ' + r.name, it,
							UniMapperGeneratorPackage.Literals.ELEMENT_WITH_DOLLAR__OP)
					}
					case "ADD": {
						if (!r.type.list.bind.contains("List")) {
							error('Type ' + r.type.list.bind + ' is not List.', it,
								UniMapperGeneratorPackage.Literals.UNICOEN_TYPE_LIST__BIND)
						} else {
						}
					}
					case "APPEND":
						return
					case "RETURN":
						return
					case "MERGE": {
						if (!r.type.list.bind.equals(it.referenceReturnType)) {
							val sb = new StringBuilder
							sb.append('Type mismatch: The return type of ').append(r.name).append(' is ').append(
								r.type.list.bind).append(' but The return type of ').append(ruleName).append(' is ').
								append(it.referenceReturnType).append('.')
							error(sb.toString, it, UniMapperGeneratorPackage.Literals.ELEMENT_WITH_DOLLAR__BODY)
						}
					}
					default: {
						try {
							clazz.getField(it.op)
						} catch (NoSuchFieldException e) {
							val sb = new StringBuilder
							sb.append('Field ').append(it.op).append(' is not exist. The fields of class ').append(
								r.type.list.bind).append(' are')
							clazz.fields.forEach [
								sb.append(' ').append(it.name)
								if (it != clazz.fields.last) {
									sb.append(',')
								}
							]
							sb.append('.')
							error(sb.toString, it, UniMapperGeneratorPackage.Literals.ELEMENT_WITH_DOLLAR__OP)
						}
					}
				}
			]
		} catch (ClassNotFoundException e) {
			error("No such class: " + r.type.list.bind, r.type, UniMapperGeneratorPackage.Literals.UNICOEN_TYPE_DEC__LIST)
		}
	}

	def getReferenceReturnType(ElementWithDollar r) {
		if (r.body.body instanceof Atom) {
			val atom = r.body.body as Atom
			if (atom.body instanceof RuleRef) {
				val ref = atom.body as RuleRef
				if (ref.reference.type != null) {
					ref.reference.type.list.bind
				}
			}
		}
	}

}