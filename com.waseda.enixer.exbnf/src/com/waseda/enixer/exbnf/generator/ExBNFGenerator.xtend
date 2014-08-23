/*
 * generated by Xtext
 */
package com.waseda.enixer.exbnf.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import com.waseda.enixer.exbnf.exBNF.Grammar
import com.waseda.enixer.exbnf.exBNF.Options
import com.waseda.enixer.exbnf.exBNF.Imports
import com.waseda.enixer.exbnf.exBNF.GrammarAction
import com.waseda.enixer.exbnf.exBNF.Option
import com.waseda.enixer.exbnf.exBNF.TokenVocab
import com.waseda.enixer.exbnf.exBNF.Mode
import com.waseda.enixer.exbnf.exBNF.QualifiedOption
import com.waseda.enixer.exbnf.exBNF.StringOption
import com.waseda.enixer.exbnf.exBNF.ActionOption
import com.waseda.enixer.exbnf.exBNF.IntOption
import com.waseda.enixer.exbnf.exBNF.Import
import com.waseda.enixer.exbnf.exBNF.V4Tokens
import com.waseda.enixer.exbnf.exBNF.V4Token
import com.waseda.enixer.exbnf.exBNF.EmptyTokens
import com.waseda.enixer.exbnf.exBNF.V3Tokens
import com.waseda.enixer.exbnf.exBNF.V3Token
import com.waseda.enixer.exbnf.exBNF.ParserRule
import com.waseda.enixer.exbnf.exBNF.Return
import com.waseda.enixer.exbnf.exBNF.LocalVars
import com.waseda.enixer.exbnf.exBNF.ExceptionGroup
import com.waseda.enixer.exbnf.exBNF.RuleBlock
import com.waseda.enixer.exbnf.exBNF.LexerRule
import com.waseda.enixer.exbnf.exBNF.GrammarType
import com.waseda.enixer.exbnf.exBNF.ExceptionHandler
import com.waseda.enixer.exbnf.exBNF.FinallyClause
import com.waseda.enixer.exbnf.exBNF.RuleAction
import com.waseda.enixer.exbnf.exBNF.RuleAltList
import com.waseda.enixer.exbnf.exBNF.LabeledAlt
import com.waseda.enixer.exbnf.exBNF.Alternative
import com.waseda.enixer.exbnf.exBNF.Element
import com.waseda.enixer.exbnf.exBNF.EbnfSuffix
import com.waseda.enixer.exbnf.exBNF.Ebnf
import com.waseda.enixer.exbnf.exBNF.ActionElement
import com.waseda.enixer.exbnf.exBNF.LabeledElement
import com.waseda.enixer.exbnf.exBNF.Block
import com.waseda.enixer.exbnf.exBNF.AltList
import com.waseda.enixer.exbnf.exBNF.Atom
import com.waseda.enixer.exbnf.exBNF.RuleRef
import com.waseda.enixer.exbnf.exBNF.Terminal
import com.waseda.enixer.exbnf.exBNF.NotSet
import com.waseda.enixer.exbnf.exBNF.BlockSet
import com.waseda.enixer.exbnf.exBNF.SetElement
import com.waseda.enixer.exbnf.exBNF.Wildcard
import com.waseda.enixer.exbnf.exBNF.ElementOption
import com.waseda.enixer.exbnf.exBNF.LexerRuleBlock
import com.waseda.enixer.exbnf.exBNF.LexerAltList
import com.waseda.enixer.exbnf.exBNF.LexerAlt
import com.waseda.enixer.exbnf.exBNF.LexerElements
import com.waseda.enixer.exbnf.exBNF.LexerElement
import com.waseda.enixer.exbnf.exBNF.LabeledLexerElement
import com.waseda.enixer.exbnf.exBNF.LexerAtom
import com.waseda.enixer.exbnf.exBNF.LexerCharSet
import com.waseda.enixer.exbnf.exBNF.LexerBlock
import com.waseda.enixer.exbnf.exBNF.LexerCommands
import com.waseda.enixer.exbnf.exBNF.LexerCommand
import com.waseda.enixer.exbnf.exBNF.LexerCommandExpr
import com.waseda.enixer.exbnf.exBNF.QualifiedId
import com.waseda.enixer.exbnf.exBNF.ElementOptions

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class ExBNFGenerator implements IGenerator {
	val nl = System.getProperty("line.separator")
	var root = ""

	override def doGenerate(Resource resource, IFileSystemAccess fsa) {
		var list = resource.allContents.toIterable.filter(Grammar)
		for (g : list) {
			fsa.generateFile(g.name + ".g4", g.compile)
			root = g.rules.get(0).name
			fsa.generateFile(g.name + "Main.java", g.makeMain)
			fsa.generateFile(g.name + "Extractor.java", g.makeExtractor)
		}
	}

	def dispatch compile(Grammar g) {
		var sb = new StringBuilder
		sb.append(g.nameCompile + nl)
		for (p : g.prequels)
			sb.append(p.compile + nl)
		for (r : g.rules)
			sb.append(r.compile + nl)
		for (m : g.modes)
			sb.append(m.compile + nl)
		return sb
	}

	def nameCompile(Grammar g) '''«IF g.getType() != null»«IF !g.type.equals(GrammarType.DEFAULT)»«g.type» «ENDIF»«ENDIF»grammar «g.
		name»;'''

	def dispatch compile(Options op) '''«op.keyword»«FOR o : op.options» «o.compile»;«ENDFOR»}'''

	def dispatch compile(Option o) '''«o.name» = «o.value.compile»'''

	def dispatch compile(TokenVocab tv) '''«tv.name» = «tv.importURI»'''

	def dispatch compile(QualifiedOption qo) '''«qo.value.compile»'''

	def dispatch compile(StringOption so) '''«so.value»'''

	def dispatch compile(ActionOption ao) '''«ao.value»'''

	def dispatch compile(IntOption io) '''«io.value»'''

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

	def dispatch compile(com.waseda.enixer.exbnf.exBNF.Range ra) '''«ra.from»..«ra.to»'''

	def dispatch compile(Terminal te) '''«IF te.reference != null»«te.reference.refCompile»«IF te.options != null»«te.
		options.compile»«ENDIF»«ELSE»«te.literal»«IF te.options != null»«te.options.compile»«ENDIF»«ENDIF»'''

	def dispatch compile(NotSet ns) '''~«ns.body.compile»'''

	def dispatch compile(BlockSet bs) '''(«FOR e : bs.elements»«IF !bs.elements.get(0).equals(e)»|«ENDIF»«e.compile»«ENDFOR»)'''

	def dispatch compile(SetElement se) '''«IF se.tokenRef != null»«se.tokenRef»«ELSEIF se.stringLiteral != null»«se.stringLiteral»«ELSEIF se.
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

	def dispatch refCompile(V3Token v3) '''«v3.name»'''

	def dispatch refCompile(V4Token v4) '''«v4.name»'''

	def dispatch refCompile(LexerRule lr) '''«lr.name»'''

	def makeMain(Grammar g) '''package com.sample;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

iimport org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import parser.«g.name»Parser;
import parser.«g.name»Lexer;

public class «g.name»Main {

	public static void main(String[] args) {
		System.out.print("Input target file: ");
		Scanner sc = new Scanner(System.in);
		String filePath = sc.next();
		sc.close();
		File file = new File(filePath);
		StringBuilder builder = new StringBuilder();
		try {
			sc = new Scanner(file);
			while(sc.hasNextLine())
				builder.append(sc.nextLine()).append(System.getProperty("line.separator"));
		} catch (FileNotFoundException e) {
			System.err.println("Error: File not found!");
			return;
		}
		CharStream input = new ANTLRInputStream(builder.toString());
		«g.name»Lexer lexer = new «g.name»Lexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		«g.name»Parser parser = new «g.name»Parser(tokens);
		ParseTreeWalker walker = new ParseTreeWalker();

		«g.name»Extractor extractor = new «g.name»Extractor(parser);

		// Parse code and generate a parse tree
		ParserRuleContext tree = parser.«root»();

		// Scan the parse tree
		walker.walk(extractor, tree);

		// Show PM counts
		extractor.showTokenCounts();

		// Show Complexity
		extractor.showCyclomaticComplexity();
	}
}
	
	'''

	def makeExtractor(Grammar g) '''package com.sample;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map.Entry;
import java.util.Set;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.TerminalNode;

import parser.«g.name»BaseListener;
import parser.«g.name»Lexer;
import parser.«g.name»Parser;

public class «g.name»Extractor extends «g.name»BaseListener {
	private HashMap<String, Integer> _map;
	private Set<String> extractElementSet;

	public «g.name»Extractor(«g.name»Parser parser) {
		_map = new HashMap<String, Integer>();
		extractCCElementSet = new HashSet<String>();
«FOR r : g.rules»«IF r.annotations != null»		extractCCElementSet.add("«r.name»");
«ENDIF»«ENDFOR»	}

	public void showTokenCounts() {
		System.out.println("*** showTokenCounts ***");
		for (Entry<String, Integer> nameAndCount : _map.entrySet()) {
			String name = nameAndCount.getKey();
			int count = nameAndCount.getValue();
			System.out.println(name + ": " + count);
		}
	}

	public void showCyclomaticComplexity() {
		System.out.println("*** showCyclomaticComplexity ***");
		int result = 1;
		for (Entry<String, Integer> nameAndCount : _map.entrySet()) {
			result += nameAndCount.getValue();
		}
		System.out.println("Cyclomatic Complexity : " + result);
	}

	@Override
	public void visitTerminal(TerminalNode node) {
		Token token = node.getSymbol();
		String tokenName = "EOF";
		if (token.getType() != Token.EOF)
			tokenName = «g.name»Lexer.ruleNames[token.getType() - 1];
		System.out.println("*** visitTerminal ***");
		System.out.println(tokenName + ": " + token.getText());

		if (extractCCElementSet.contains(tokenName)) {
			// Count tokens
			Integer value = _map.get(tokenName);
			value = value == null ? 0 : value;
			_map.put(tokenName, value + 1);
		}
	}

	@Override
	public void enterEveryRule(ParserRuleContext ctx) {
		String ruleName = «g.name»Parser.ruleNames[ctx.getRuleIndex()];
		System.out.println("*** visitRule ***");
		System.out.println(ruleName + ": " + ctx.getText());

		if (extractElementSet.contains(ruleName)) {
			Integer value = _map.get(ruleName);
			value = value == null ? 0 : value;
			_map.put(ruleName, value + 1);
		}
	}
}'''
}
