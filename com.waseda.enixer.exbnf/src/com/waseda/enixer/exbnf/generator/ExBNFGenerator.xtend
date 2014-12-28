/*
 * generated by Xtext
 */
package com.waseda.enixer.exbnf.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import com.waseda.enixer.exbnf.exBNF.*

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class ExBNFGenerator implements IGenerator {
	val nl = System.getProperty("line.separator")
	var name = new String

	override def doGenerate(Resource resource, IFileSystemAccess fsa) {
		var list = resource.allContents.toIterable.filter(Grammar)
		for (g : list) {
			name = g.name.toCamelCase
			fsa.generateFile(name + ".g4", g.compile)
			fsa.generateFile(name + "Mapper.xtend", g.generateMapper)
			fsa.generateFile(name + "MapperTest.xtend", g.generateMapperTestTemplate)
		}
	}

	def dispatch compile(Grammar g) {
		var sb = new StringBuilder
		sb.append(g.nameCompile + nl + nl)
		sb.append(header + nl + nl)
		for (p : g.prequels)
			sb.append(p.compile + nl)
		for (r : g.rules)
			sb.append(r.compile + nl)
		for (m : g.modes)
			sb.append(m.compile + nl)
		return sb.toString
	}

	def nameCompile(Grammar g) '''«IF g.type != null»«IF !g.type.equals(GrammarType.DEFAULT)»«g.type» «ENDIF»«ENDIF»grammar «g.
		name»;'''

	def header() '''@header{
	package net.unicoen.parser;
}'''

	def dispatch compile(Options op) '''«op.keyword»«FOR o : op.options» «o.compile»;«ENDFOR»}'''

	def dispatch compile(Option o) '''«o.name» = «o.value.compile»'''

	def dispatch compile(TokenVocab tv) '''«tv.name» = «tv.importURI»'''

	def dispatch compile(OptionValue opv) '''«IF opv.qopValue != null»«opv.qopValue»«ELSEIF opv.strValue != null»'«opv.strValue»'«ELSEIF opv.
		aopValue != null»«ELSE»«ENDIF»'''

	def dispatch compile(Imports im) '''«im.keyword» «FOR i : im.imports»«IF !im.imports.get(0).equals(i)», «ENDIF»«i.
		compile»«ENDFOR»'''

	def dispatch compile(Import i) '''«IF !i.alias.empty»«i.alias» = «ENDIF»«i.importURI»'''

	def dispatch compile(V4Tokens v4) '''«v4.keyword» «FOR t : v4.tokens»«IF !v4.tokens.get(0).equals(t)», «ENDIF»«t.
		compile»«ENDFOR»'''

	def dispatch compile(V4Token v4) '''«v4.name»'''

	def dispatch compile(EmptyTokens et) '''«et.keyword»}'''

	def dispatch compile(V3Tokens v3) '''«v3.keyword»«FOR t : v3.tokens» «t.compile»«ENDFOR»}'''

	def dispatch compile(V3Token v3) '''«v3.name»«IF !v3.value.empty» = «v3.value»«ENDIF»;'''

	def dispatch compile(GrammarAction ga) '''«ga.atSymbol»«IF !ga.scope.empty»«ga.scope» «ga.colonSymbol» «ENDIF»«ga.
		name» «ga.action»'''

	def dispatch compile(Mode m) '''mode «m.id»;«FOR lr : m.rules»«lr.compile»«ENDFOR»'''

	def dispatch compile(ParserRule pr) '''«pr.name»«IF pr.^return != null» «pr.^return.compile»«ENDIF»«IF pr.throws !=
		null» «pr.throws.compile»«ENDIF»«IF pr.locals != null» «pr.locals.compile»«ENDIF»«FOR p : pr.prequels» «p.compile»«ENDFOR» :
		«pr.body.compile»«pr.caught.compile»«pr.semicolonSymbol»'''

	def dispatch compile(ExceptionGroup eg) '''«FOR e : eg.handlers»«ENDFOR»«IF eg.^finally != null»«eg.^finally.compile»«ENDIF»'''

	def dispatch compile(ExceptionHandler eh) '''catch «eh.exception» «eh.body»'''

	def dispatch compile(FinallyClause fc) '''finally «fc.body»'''

	def dispatch compile(Return re) '''returns «re.body»'''

	def dispatch compile(com.waseda.enixer.exbnf.exBNF.Exceptions ex) '''throws «FOR e : ex.exceptions»«IF !ex.
		exceptions.get(0).equals(e)»,«ENDIF» «e»«ENDFOR»'''

	def dispatch compile(LocalVars lv) '''locals «lv.body»'''

	def dispatch compile(RuleAction ra) '''«ra.atSymbol» «ra.name» «ra.body»'''

	def dispatch compile(RuleBlock rb) '''«rb.body.compile»'''

	def dispatch compile(RuleAltList ral) '''«FOR a : ral.alternatives»«IF !ral.alternatives.get(0).equals(a)»| «ENDIF»«a.
		compile»«ENDFOR»'''

	def dispatch compile(LabeledAlt la) '''«la.body.compile»«IF la.poundSymbol != null» «la.poundSymbol»«la.label»«ENDIF»'''

	def dispatch compile(Alternative al) '''«IF al.options != null»«al.options.compile» «ENDIF»«FOR e : al.elements»«e.
		compile»«ENDFOR»'''

	def dispatch compile(ElementWithDollar lad) '''«lad.body.compile»'''

	def dispatch compile(Element el) '''«el.body.compile»«IF el.operator != null»«el.operator.compile»«ENDIF» '''

	def dispatch compile(Ebnf eb) '''«eb.body.compile»«IF eb.operator != null» «eb.operator.compile»«ENDIF»'''

	def dispatch compile(ActionElement ae) '''«ae.body»«IF ae.options != null»«ae.options.compile»«ENDIF»'''

	def dispatch compile(LabeledElement le) '''«le.name» «le.op» «le.body.compile»'''

	def dispatch compile(EbnfSuffix es) '''«es.operator»«IF es.nongreedy != null» «es.nongreedy»«ENDIF»'''

	def dispatch compile(Block bl) '''(«IF bl.colon != null»«IF bl.options != null»«bl.options.compile»«ENDIF»«FOR a : bl.
		actions» «a.compile»«ENDFOR»:«ENDIF» «bl.body.compile»)'''

	def dispatch compile(AltList al) '''«FOR a : al.alternatives»«IF !al.alternatives.get(0).equals(a)»|«ENDIF» «a.
		compile»«ENDFOR»'''

	def dispatch compile(Atom at) '''«at.body.compile»'''

	def dispatch compile(RuleRef rr) '''«rr.reference.name»«rr.args»«IF rr.options != null»«rr.options.compile»«ENDIF»'''

	def dispatch compile(ElementOptions eo) '''«eo.begin»«FOR o : eo.options»«o.compile»,«ENDFOR»«eo.end»'''

	def dispatch compile(Range ra) ''''«ra.from»'..'«ra.to»' '''

	def dispatch compile(Terminal te) '''«IF te.reference != null»«te.reference.refCompile»«IF te.options != null»«te.
		options.compile»«ENDIF»«ELSEIF te.literal != null»'«te.literal»'«IF te.options != null» «te.options.compile»«ENDIF»«ELSE»«te.
		eof»«ENDIF»'''

	def dispatch compile(NotSet ns) '''~«ns.body.compile»'''

	def dispatch compile(BlockSet bs) '''(«FOR e : bs.elements»«IF !bs.elements.get(0).equals(e)»|«ENDIF»«e.compile»«ENDFOR»)'''

	def dispatch compile(SetElement se) '''«IF se.tokenRef != null»«se.tokenRef»«ELSEIF se.stringLiteral != null»'«se.stringLiteral»'«ELSEIF se.
		range != null»«se.range»«ELSE»«se.charSet»«ENDIF»'''

	def dispatch compile(Wildcard wi) '''«wi.dot»«IF wi.options != null»«wi.options.compile»«ENDIF»'''

	def dispatch compile(ElementOption eo) '''«IF eo.qualifiedId != null»«eo.qualifiedId.compile»«ELSE»«eo.id» «eo.
		assign» «eo.value»«ENDIF»'''

	def dispatch compile(LexerRule lr) '''«IF lr.^fragment»flagment «ENDIF»«lr.name» :
		«lr.body.compile»«lr.semicolonSymbol»'''

	def dispatch compile(LexerRuleBlock lrb) '''«lrb.body.compile»'''

	def dispatch compile(LexerAltList lal) '''«FOR a : lal.alternatives»«IF !lal.alternatives.get(0).equals(a)»|«ENDIF»«a.
		compile»«ENDFOR»'''

	def dispatch compile(LexerAlt la) '''«la.body.compile» «IF la.commands != null»«la.commands.compile»«ENDIF»'''

	def dispatch compile(LexerElements le) '''«FOR e : le.elements»«e.compile»«ENDFOR»'''

	def dispatch compile(LexerElementWithDollar led) '''«led.body.compile»'''

	def dispatch compile(LexerElement le) '''«le.body.compile»«IF le.operator != null»«le.operator.compile»«ENDIF»'''

	def dispatch compile(LabeledLexerElement lle) '''«lle.label» «lle.op» «lle.body.compile»'''

	def dispatch compile(LexerAtom la) '''«la.body.compile»'''

	def dispatch compile(LexerCharSet lcs) '''«lcs.body»'''

	def dispatch compile(LexerBlock lb) '''(«IF lb.options != null»«lb.options» :«ENDIF»«lb.body.compile»)'''

	def dispatch compile(LexerCommands lc) '''«lc.keyword»«FOR c : lc.commands»«IF !lc.commands.get(0).equals(c)»|«ENDIF»«c.
		compile»«ENDFOR»'''

	def dispatch compile(LexerCommand lc) '''«lc.name»«IF lc.args != null»(«lc.args.compile»)«ENDIF»'''

	def dispatch compile(LexerCommandExpr lce) '''«IF lce.ref != null»«lce.ref.compile»«ELSE»«lce.value»«ENDIF»'''

	def dispatch compile(QualifiedId qi) '''«FOR n : qi.name»«n».«ENDFOR»'''

	def dispatch refCompile(V3Token v3) '''«v3.name» = '«v3.value»';'''

	def dispatch refCompile(V4Token v4) '''«v4.name»'''

	def dispatch refCompile(LexerRule lr) '''«lr.name»'''

	def generateMapperTestTemplate(Grammar g) '''package net.unicoen.mapper

import org.junit.Test
import static org.hamcrest.Matchers.*
import static org.junit.Assert.*

class «name»MapperTest {
	val mapper = new «name»Mapper

	@Test
	def «name»Test(){
		
	}

}
	'''

	def generateMapper(Grammar g) {
		var sb = new StringBuilder
		sb.append(
			'''package net.unicoen.mapper

import java.io.FileInputStream
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CharStream
import org.antlr.v4.runtime.CommonTokenStream
import net.unicoen.node.UniNode
import net.unicoen.parser.«name»Lexer
import net.unicoen.parser.«name»Parser
import net.unicoen.parser.«name»BaseVisitor
import net.unicoen.node.UniBinOp
import net.unicoen.node.UniExpr
import net.unicoen.node.UniIntLiteral
import net.unicoen.node.UniDoubleLiteral

class «name»Mapper extends «name»BaseVisitor<UniNode> {
	def parseFile(String path) {
		val inputStream = new FileInputStream(path)
		try {
			parseCore(new ANTLRInputStream(inputStream))
		} finally {
			inputStream.close
		}
	}

	def parse(String code) {
		parseCore(new ANTLRInputStream(code))
	}

	def parseCore(CharStream chars) {
		val lexer = new «name»Lexer(chars)
		val tokens = new CommonTokenStream(lexer)
		val parser = new «name»Parser(tokens)
		val tree = parser.«g.rules.get(0).name»
		visit(tree)
	}''' + nl + nl)
		for (r : g.rules) {
			if (r.type != null) {
				sb.append(r.visitMethod)
			}
		}
		sb.append('}' + nl)
		sb.toString
	}

	def toCamelCase(String str) {
		Character.toUpperCase(str.charAt(0)) + str.substring(1)
	}

	def dispatch visitMethod(ParserRule r) {
		var sb = new StringBuilder
		sb.append('''	override public visit«r.name.toCamelCase»(«name»Parser.«r.name.toCamelCase»Context ctx) {''' + nl)
		var type = r.type.name
		if (type.equals("UniBinOp")) {
			sb.append(r.makeUniBinOpMethodBody)
		} else if (type.equals("UniIntLiteral")) {
			sb.append(r.makeUniIntLiteralMethodBody)
		} else if (type.equals("UniDoubleLiteral")) {
			sb.append(r.makeUniDoubleLiteralMethodBody)
		} else if (type.equals("SWITCH")) {
			sb.append(r.makeBranchMethodBody)
		} else {
			sb.append(r.makeSuperMethodBody)
		}
		sb.append('''	}''' + nl + nl)
		sb
	}

	def makeUniBinOpMethodBody(ParserRule r) {
		var sb = new StringBuilder
		var children = r.eAllContents.toIterable.filter(ElementWithDollar)
		var left = new String;
		var operator = new String;
		var right = new String;
		for (c : children) {
			if (c.num == 0) {
				var grandchildren = c.eAllContents.toIterable.filter(RuleRef)
				left = grandchildren.get(0).reference.name
			}
			if (c.num == 1) {
				var grandchildren = c.eAllContents.toIterable.filter(RuleRef)
				operator = grandchildren.get(0).reference.name
			}
			if (c.num == 2) {
				var grandchildren = c.eAllContents.toIterable.filter(RuleRef)
				right = grandchildren.get(0).reference.name
			}
		}
		sb.append(
			'''		if (ctx.childCount == 1) {
			return visit(ctx.getChild(0))
		}
		var ret = new UniBinOp
		for (tree : ctx.children) {
			if (tree instanceof «name»Parser.«right.toCamelCase»Context) {
				ret.right = visit(tree) as UniExpr
			} else if (tree instanceof «name»Parser.«operator.toCamelCase»Context) {
				var temp = new UniBinOp
				temp.operator = tree.text
				if (ret.operator == null) {
					temp.left = ret.right
				} else {
					temp.left = ret
				}
				ret = temp
			} else {
				throw new RuntimeException
			}
		}
		ret
	''')
		sb.toString
	}

	def dispatch visitMethod(LexerRule r) {
		var name = r.type.name
		name
	}

	def makeUniIntLiteralMethodBody(ParserRule r) {
		var sb = new StringBuilder
		sb.append('''		new UniIntLiteral(Integer.parseInt(ctx.text))''' + nl)
		sb
	}

	def makeUniDoubleLiteralMethodBody(ParserRule r) {
		var sb = new StringBuilder
		sb.append('''		new UniDoubleLiteral(Double.parseDouble(ctx.text))''' + nl)
		sb
	}

	def makeSuperMethodBody(ParserRule r) {
		var sb = new StringBuilder
		sb.append('''		super.visit«r.name.toCamelCase»(ctx)''' + nl)
		sb
	}

	def makeBranchMethodBody(ParserRule r) {
		var sb = new StringBuilder
		sb.append('''		for (tree : ctx.children) {''' + nl)
		var children = r.eAllContents.toIterable.filter(ElementWithDollar)
		for (c : children) {
			if (c.dollarSymbol != null) {
				var grandchildren = c.eAllContents.toIterable.filter(RuleRef)
				sb.append(
					'''			if(tree instanceof «name»Parser.«grandchildren.get(0).reference.name.toCamelCase»Context) {
				return visit(tree)
			}''' + nl)
			}
		}
		sb.append('''		}''' + nl)
		sb
	}
}
