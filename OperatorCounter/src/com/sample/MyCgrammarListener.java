package com.sample;

import java.util.*;
import java.util.Map.Entry;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.TerminalNode;

import parser.CgrammarBaseListener;
import parser.CgrammarLexer;
import parser.CgrammarParser;

public class MyCgrammarListener extends CgrammarBaseListener {
	private HashMap<String, Integer> _map;
	private Set<String> extractElementSet;

	public MyCgrammarListener(CgrammarParser parser) {
		_map = new HashMap<String, Integer>();
		extractElementSet = new HashSet<String>();
		extractElementSet.add("IF");
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
		String tokenName = CgrammarLexer.ruleNames[token.getType() - 1];
		System.out.println("*** visitTerminal ***");
		System.out.println(tokenName + ": " + token.getText());

		if (extractElementSet.contains(tokenName)) {
			// Count tokens
			Integer value = _map.get(tokenName);
			value = value == null ? 0 : value;
			_map.put(tokenName, value + 1);
		}
	}

	@Override
	public void enterEveryRule(ParserRuleContext ctx) {
		String ruleName = CgrammarParser.ruleNames[ctx.getRuleIndex()];
		System.out.println("*** visitRule ***");
		System.out.println(ruleName + ": " + ctx.getText());

		if (extractElementSet.contains(ruleName)) {
			Integer value = _map.get(ruleName);
			value = value == null ? 0 : value;
			_map.put(ruleName, value + 1);
		}
	}
}