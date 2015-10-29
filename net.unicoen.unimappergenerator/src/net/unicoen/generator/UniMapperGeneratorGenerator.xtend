/*
 * generated by Xtext
 */
package net.unicoen.generator

import java.lang.reflect.ParameterizedType
import java.lang.reflect.Type
import java.util.regex.Pattern
import net.unicoen.node.UniNode
import net.unicoen.uniMapperGenerator.Atom
import net.unicoen.uniMapperGenerator.Element
import net.unicoen.uniMapperGenerator.Grammar
import net.unicoen.uniMapperGenerator.ParserRule
import net.unicoen.uniMapperGenerator.RuleRef
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import net.unicoen.util.InvokingStateAnalyzer

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class UniMapperGeneratorGenerator implements IGenerator {
	private String _grammarName
	private int _indent;
	private InvokingStateAnalyzer _analyzer;

	override def doGenerate(Resource resource, IFileSystemAccess fsa) {
		val g4Generator = new ANTLRGrammarGenerator(fsa)
		val testGenerator = new MapperTestGenerator(fsa)
		resource.allContents.filter(Grammar).forEach [
			_grammarName = it.name.toCamelCase
			val parserCode = g4Generator.generate(_grammarName, it)
			_analyzer = new InvokingStateAnalyzer(parserCode, it)
			fsa.generateFile(_grammarName + "Mapper.xtend", it.generateMapper)
			testGenerator.generate(_grammarName, it)
		]
	}

	def generateImports() '''package net.unicoen.mapper

import java.io.FileInputStream
import java.util.ArrayList
import java.util.List
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CharStream
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.ParserRuleContext
import org.antlr.v4.runtime.RuleContext
import org.antlr.v4.runtime.tree.ParseTree
import org.antlr.v4.runtime.tree.RuleNode
import org.antlr.v4.runtime.tree.TerminalNode
import net.unicoen.parser.«_grammarName»Lexer
import net.unicoen.parser.«_grammarName»Parser
import net.unicoen.parser.«_grammarName»BaseVisitor
import net.unicoen.node.*
'''

	def generateMapper(Grammar g) {
		val sb = new StringBuilder
		sb.nl(generateImports)
		_indent = 0;

		sb.nl('''class «_grammarName»Mapper extends «_grammarName»BaseVisitor<Object> {''')
		sb.nl('''var _isDebugMode = false''')
		sb.nl
		sb.nl('''new(boolean isDebugMode) {''')
		sb.nl('''_isDebugMode = isDebugMode''')
		sb.nl('''}''')
		sb.nl
		sb.nl('''def parseFile(String path) {''')
		sb.nl('''val inputStream = new FileInputStream(path)''')
		sb.nl('''try {''')
		sb.nl('''parseCore(new ANTLRInputStream(inputStream))''')
		sb.nl('''} finally {''')
		sb.nl('''inputStream.close''')
		sb.nl('''}''')
		sb.nl('''}''')
		sb.nl
		sb.nl('''def parse(String code) {''')
		sb.nl('''parseCore(new ANTLRInputStream(code))''')
		sb.nl('''}''')
		sb.nl
		sb.nl('''def parseCore(CharStream chars) {''')
		sb.nl('''val lexer = new «_grammarName»Lexer(chars)''')
		sb.nl('''val tokens = new CommonTokenStream(lexer)''')
		sb.nl('''val parser = new «_grammarName»Parser(tokens)''')
		if (g.rules.size > 0) {
			sb.nl('''val tree = parser.«IF g.root != null»«g.root.root.name»«ELSE»«g.rules.get(0).name»«ENDIF»''')
			sb.nl
			sb.nl('''tree.visit''')
		}
		sb.nl('''}''')
		sb.nl
		sb.nl('''override public visitChildren(RuleNode node) {''')
		sb.nl('''val n = node.childCount;''')
		sb.nl('''(0 ..< n).fold(defaultResult) [ acc, i |''')
		sb.nl('''if (!node.shouldVisitNextChild(acc)) {''')
		sb.nl('''acc''')
		sb.nl('''} else {''')
		sb.nl('''val c = node.getChild(i)''')
		sb.nl('''val childResult = c.visit''')
		sb.nl('''acc.aggregateResult(childResult)''')
		sb.nl('''}''')
		sb.nl(''']''')
		sb.nl('''}''')
		sb.nl
		sb.nl('''override public visit(ParseTree tree) {''')
		sb.nl('''if (_isDebugMode) {''')
		sb.nl('''if (!(tree instanceof ParserRuleContext)) {''')
		sb.nl('''return visitTerminal(tree as TerminalNode)''')
		sb.nl('''}''')
		sb.nl('''val ruleName = «_grammarName»Parser.ruleNames.get((tree as ParserRuleContext).ruleIndex)''')
		sb.nl('''println("*** visit" + ruleName + " ***")''')
		sb.nl('''println(tree.text)''')
		sb.nl('''val ret = tree.accept(this)''')
		sb.nl('''println("returned: " + ret)''')
		sb.nl('''ret''')
		sb.nl('''} else {''')
		sb.nl('''tree.accept(this)''')
		sb.nl('''}''')
		sb.nl('''}''')
		sb.nl
		g.rules.filter(ParserRule).forEach [
			if (it.type != null) {
				if (it.type.list.bind.endsWith("Literal")) {
					sb.append(it.makeLiteralMethod)
				} else {
					sb.append(it.makeVisitMethod)
				}
			}
		]
		sb.nl('}')
		sb.toString
	}

	def toCamelCase(String str) {
		Character.toUpperCase(str.charAt(0)) + str.substring(1)
	}

	def makeVisitMethod(ParserRule r) {
		val sb = new StringBuilder
		val ruleName = r.name.toCamelCase
		sb.nl('''override public visit«ruleName»(«_grammarName»Parser.«ruleName»Context ctx) {''')
		val typeName = r.type.list.bind
		if (typeName.startsWith("Uni")) {
			val packagePrefix = UniNode.package.name + '.'
			sb.append(r.makeMethodBody(Class.forName(packagePrefix + typeName)))
		} else if (typeName.startsWith("List")) {
			val itemClassName = typeName.substring(typeName.indexOf('<') + 1, typeName.indexOf('>'))
			sb.append(r.makeListMethodBody(itemClassName))
		} else if (typeName.equals("String")) {
			sb.append(r.makeStringMethodBody)
		} else {
			die("Unknown Class Name: " + typeName)
		}
		sb.nl('''}''')
		sb.nl
		sb
	}

	def makeCaseStatement(ParserRule r, Element obj, String fieldTypeName, String fieldName, StringBuilder sb,
		String returnType) {
		val rule = obj.eAllContents.filter(RuleRef).head
		if (rule != null) {
			val ruleName = rule.reference.name.toCamelCase
			if (fieldTypeName.startsWith("java.util.List")) {
				sb.nl('''case «r.getInvokingState(obj)»: {''')
				val refType = obj.referenceReturnType
				if (refType == null) {
					die("Rule " + ruleName + " does not have return type.")
				}
				if (refType.startsWith("List")) {
					sb.nl('''if (bind.«fieldName» == null) {''')
					sb.nl('''bind.«fieldName» = it.visit as «fieldTypeName»''')
					sb.nl('''} else {''')
					sb.nl('''bind.«fieldName» += it.visit as «fieldTypeName»''')
					sb.nl('''}''')
				} else {
					sb.nl('''if (bind.«fieldName» == null) {''')
					sb.nl('''bind.«fieldName» = new ArrayList<«refType»>''')
					sb.nl('''}''')
					sb.nl('''bind.«fieldName» += it.visit as «refType»''')
				}
				sb.nl('''}''')
			} else {
				sb.nl('''case «r.getInvokingState(obj)»: {''')
				sb.nl('''bind.«fieldName» = it.visit as «fieldTypeName»''')
				sb.nl('''}''')
			}
			return
		}
		die("Unreach")
	}

	def makeMethodBody(ParserRule r, Class<?> clazz) {
		val sb = new StringBuilder
		sb.nl('''val bind = new «r.type.list.bind»''')
		if (r.type.list.ret != null) {
			sb.append('''val ret = new «r.type.list.ret»''')
		}
		sb.nl('''ctx.children.forEach [''')
		sb.nl('''if (it instanceof RuleContext) {''')
		sb.nl('''switch (it as RuleContext).invokingState {''')
		val list = r.eAllContents.filter(Element)
		list.forEach [
			if (it.op == null) {
				return
			}
			if (it.op.equals("MERGE")) {
				if (!r.type.list.bind.equals(it.referenceReturnType)) {
					die("Expected return type: " + r.type.list.bind + " actual type: " + it.referenceReturnType)
				}
				sb.nl('''case «r.getInvokingState(it)»: {''')
				sb.nl('''val child = it.visit as «r.type.list.bind»''')
				sb.nl('''bind.merge(child)''')
				sb.nl('''}''')
				return
			}
			if (it.op.equals("RETURN")) {
				sb.nl('''case «r.getInvokingState(it)»: {''')
				sb.nl('''bind = it.visit as «r.type.list.ret»''')
				sb.nl('''}''')
				return
			}
			try {
				val field = clazz.getField(it.op)
				val fieldTypeName = field.genericType.typeName
				r.makeCaseStatement(it, fieldTypeName, it.op, sb, r.type.list.bind)
			} catch (NoSuchFieldException e) {
				die("No such Field: " + it.op)
			}
		]
		sb.nl('''}''')
		sb.nl('''}''')
		sb.nl(''']''')
		if (r.type.list.ret != null) {
			sb.nl('''if (ret != null) {''')
			sb.nl('''return ret''')
			sb.nl('''}''')
		}
		sb.nl('''bind''')
	}

	def getReferenceReturnType(Element r) {
		val atom = r.body as Atom
		if (atom.body instanceof RuleRef) {
			val ref = atom.body as RuleRef
			if (ref.reference.type != null) {
				ref.reference.type.list.bind
			}
		}
	}

	def getTypeName(Type type) {
		switch type {
			Class<?>:
				return type.name
			ParameterizedType: {
				val sb = new StringBuilder
				sb.append(type.typeName).append('<')
				var isFirst = true
				for (Type arg : type.actualTypeArguments) {
					if (!isFirst) {
						sb.append(',')
					}
					sb.append(arg.typeName)
				}
				sb.append('>')
				return sb.toString
			}
			default:
				die("Unknown type:" + type.toString)
		}
	}

	def makeListMethodBody(ParserRule r, String itemClassName) {
		val sb = new StringBuilder
		sb.nl('''val list = new ArrayList<«itemClassName»>''')
		if (r.hasItemClassField(itemClassName)) {
			sb.nl('''val tNode = new «itemClassName»''')
		}
		sb.nl('''if (ctx.children != null) {''')
		sb.nl('''ctx.children.forEach [''')
		sb.nl('''if (it instanceof RuleContext) {''')
		sb.nl('''switch (it as RuleContext).invokingState {''')
		val list = r.eAllContents.filter(Element)
		list.forEach [
			if (it.op == null) {
				return
			}
			if (it.op.equals("ADD")) {
				sb.nl('''case «r.getInvokingState(it)»: {''')
				sb.nl('''list += it.visit as «itemClassName»''')
				sb.nl('''}''')
				return
			}
			if (it.op.equals("APPEND")) {
				if (!r.type.list.bind.equals(it.referenceReturnType)) {
					die("Expected return type: " + r.type.list.bind + " actual type: " + it.referenceReturnType)
				}
				sb.nl('''case «r.getInvokingState(it)»: {''')
				sb.nl('''list += it.visit as «r.type.list.bind»''')
				sb.nl('''}''')
			}
			if (r.hasItemClassField(itemClassName)) {
				try {
					val clazz = Class.forName(itemClassName)
					val field = clazz.getField(it.op)
					val fieldTypeName = field.genericType.typeName
					sb.nl('''case «r.getInvokingState(it)»: {''')
					sb.nl('''tNode.«field.name» = it.visit as «fieldTypeName»''')
					sb.nl('''}''')
				} catch (NoSuchFieldException e) {
					die("No such Field: " + it.op)
				} catch (ClassNotFoundException e) {
					die("No such class: " + itemClassName)
				}

			}
		]
		sb.nl('''}''')
		sb.nl('''}''')
		sb.nl(''']''')
		if(r.hasItemClassField(itemClassName)){
			sb.nl('''list.forEach[''')
			sb.nl('''it.merge(tNode)''')
			sb.nl(''']''')
		}
		sb.nl('''}''')
		sb.nl('''list''')
		sb
	}

	def makeStringMethodBody(ParserRule r) {
		val sb = new StringBuilder
		sb.nl('''ctx.text''')
		sb.toString
	}

	def makeLiteralMethod(ParserRule r) {
		val sb = new StringBuilder
		val methodName = "visit" + r.name.toCamelCase
		sb.nl('''override public «methodName»(«_grammarName»Parser.«r.name.toCamelCase»Context ctx) {''')
		sb.nl('''throw new RuntimeException("Unimplemented Method: «methodName»")''')
		sb.nl('''}''')
		sb.nl
		sb.toString
	}

	def die(String message) {
		throw new RuntimeException(message)
	}

	def nl(StringBuilder sb, CharSequence contents) {
		if (Pattern.compile("[}\\]]").matcher(contents).find) {
			_indent--;
		}
		for (var i = 0; i < _indent; i++) {
			sb.append('\t')
		}
		if (Pattern.compile("[{\\[]").matcher(contents).find) {
			_indent++;
		}
		sb.append(contents)
		sb.nl
	}

	def nl(StringBuilder sb) {
		sb.append(System.lineSeparator)
	}

	def getInvokingState(ParserRule r, Element obj) {
		_analyzer.getInvokingState(r, obj)
	}

	def hasItemClassField(ParserRule r, String itemClassName) {
		val list = r.eAllContents.filter(Element).toIterable
		for (elem : list) {
			if (itemClassName.hasField(elem.op)) {
				return true
			}
		}
		return false
	}

	def hasField(String itemClass, String fieldName) {
		try {
			val clazz = Class.forName(itemClass)
			clazz.getField(fieldName)
		} catch (Exception e) {
			return false
		}
		return true
	}

}
