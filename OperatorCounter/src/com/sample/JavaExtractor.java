package com.sample;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map.Entry;
import java.util.Set;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.TerminalNode;

import parser.JavaBaseListener;
import parser.JavaLexer;
import parser.JavaParser;

public class JavaExtractor extends JavaBaseListener {
	private HashMap<String, Integer> _map;
	private Set<String> extractCCElementSet;

	public JavaExtractor(JavaParser parser) {
		_map = new HashMap<String, Integer>();
		extractCCElementSet = new HashSet<String>();
		extractCCElementSet.add("if_statement");
	}

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
			tokenName = JavaLexer.ruleNames[token.getType() - 1];
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
		String ruleName = JavaParser.ruleNames[ctx.getRuleIndex()];
		System.out.println("*** visitRule ***");
		System.out.println(ruleName + ": " + ctx.getText());

		if (extractCCElementSet.contains(ruleName)) {
			Integer value = _map.get(ruleName);
			value = value == null ? 0 : value;
			_map.put(ruleName, value + 1);
		}
	}
}