/*
* generated by Xtext
*/
grammar InternalMyDsl;

options {
	superClass=AbstractInternalAntlrParser;
	
}

@lexer::header {
package org.xtext.example.mydsl.parser.antlr.internal;

// Hack: Use our own Lexer superclass by means of import. 
// Currently there is no other way to specify the superclass for the lexer.
import org.eclipse.xtext.parser.antlr.Lexer;
}

@parser::header {
package org.xtext.example.mydsl.parser.antlr.internal; 

import org.eclipse.xtext.*;
import org.eclipse.xtext.parser.*;
import org.eclipse.xtext.parser.impl.*;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.parser.antlr.AbstractInternalAntlrParser;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.parser.antlr.AntlrDatatypeRuleToken;
import org.xtext.example.mydsl.services.MyDslGrammarAccess;

}

@parser::members {

 	private MyDslGrammarAccess grammarAccess;
 	
    public InternalMyDslParser(TokenStream input, MyDslGrammarAccess grammarAccess) {
        this(input);
        this.grammarAccess = grammarAccess;
        registerRules(grammarAccess.getGrammar());
    }
    
    @Override
    protected String getFirstRuleName() {
    	return "Model";	
   	}
   	
   	@Override
   	protected MyDslGrammarAccess getGrammarAccess() {
   		return grammarAccess;
   	}
}

@rulecatch { 
    catch (RecognitionException re) { 
        recover(input,re); 
        appendSkippedTokens();
    } 
}




// Entry rule entryRuleModel
entryRuleModel returns [EObject current=null] 
	:
	{ newCompositeNode(grammarAccess.getModelRule()); }
	 iv_ruleModel=ruleModel 
	 { $current=$iv_ruleModel.current; } 
	 EOF 
;

// Rule Model
ruleModel returns [EObject current=null] 
    @init { enterRule(); 
    }
    @after { leaveRule(); }:
((
(
		{ 
	        newCompositeNode(grammarAccess.getModelAccess().getGramGrammarParserRuleCall_0_0()); 
	    }
		lv_gram_0_0=ruleGrammar		{
	        if ($current==null) {
	            $current = createModelElementForParent(grammarAccess.getModelRule());
	        }
       		set(
       			$current, 
       			"gram",
        		lv_gram_0_0, 
        		"Grammar");
	        afterParserOrEnumRuleCall();
	    }

)
)(
(
		{ 
	        newCompositeNode(grammarAccess.getModelAccess().getRulesRuleParserRuleCall_1_0()); 
	    }
		lv_rules_1_0=ruleRule		{
	        if ($current==null) {
	            $current = createModelElementForParent(grammarAccess.getModelRule());
	        }
       		add(
       			$current, 
       			"rules",
        		lv_rules_1_0, 
        		"Rule");
	        afterParserOrEnumRuleCall();
	    }

)
)+)
;





// Entry rule entryRuleGrammar
entryRuleGrammar returns [EObject current=null] 
	:
	{ newCompositeNode(grammarAccess.getGrammarRule()); }
	 iv_ruleGrammar=ruleGrammar 
	 { $current=$iv_ruleGrammar.current; } 
	 EOF 
;

// Rule Grammar
ruleGrammar returns [EObject current=null] 
    @init { enterRule(); 
    }
    @after { leaveRule(); }:
(	otherlv_0='grammar' 
    {
    	newLeafNode(otherlv_0, grammarAccess.getGrammarAccess().getGrammarKeyword_0());
    }
(
(
		lv_gname_1_0=RULE_ID
		{
			newLeafNode(lv_gname_1_0, grammarAccess.getGrammarAccess().getGnameIDTerminalRuleCall_1_0()); 
		}
		{
	        if ($current==null) {
	            $current = createModelElement(grammarAccess.getGrammarRule());
	        }
       		setWithLastConsumed(
       			$current, 
       			"gname",
        		lv_gname_1_0, 
        		"ID");
	    }

)
))
;





// Entry rule entryRuleRule
entryRuleRule returns [EObject current=null] 
	:
	{ newCompositeNode(grammarAccess.getRuleRule()); }
	 iv_ruleRule=ruleRule 
	 { $current=$iv_ruleRule.current; } 
	 EOF 
;

// Rule Rule
ruleRule returns [EObject current=null] 
    @init { enterRule(); 
    }
    @after { leaveRule(); }:
(	otherlv_0='<' 
    {
    	newLeafNode(otherlv_0, grammarAccess.getRuleAccess().getLessThanSignKeyword_0());
    }
(
(
		lv_name_1_0=RULE_ID
		{
			newLeafNode(lv_name_1_0, grammarAccess.getRuleAccess().getNameIDTerminalRuleCall_1_0()); 
		}
		{
	        if ($current==null) {
	            $current = createModelElement(grammarAccess.getRuleRule());
	        }
       		setWithLastConsumed(
       			$current, 
       			"name",
        		lv_name_1_0, 
        		"ID");
	    }

)
)	otherlv_2='>' 
    {
    	newLeafNode(otherlv_2, grammarAccess.getRuleAccess().getGreaterThanSignKeyword_2());
    }
	otherlv_3='::=' 
    {
    	newLeafNode(otherlv_3, grammarAccess.getRuleAccess().getColonColonEqualsSignKeyword_3());
    }
(
(
		{ 
	        newCompositeNode(grammarAccess.getRuleAccess().getExpressionExpressionParserRuleCall_4_0()); 
	    }
		lv_expression_4_0=ruleExpression		{
	        if ($current==null) {
	            $current = createModelElementForParent(grammarAccess.getRuleRule());
	        }
       		set(
       			$current, 
       			"expression",
        		lv_expression_4_0, 
        		"Expression");
	        afterParserOrEnumRuleCall();
	    }

)
))
;





// Entry rule entryRuleExpression
entryRuleExpression returns [EObject current=null] 
	:
	{ newCompositeNode(grammarAccess.getExpressionRule()); }
	 iv_ruleExpression=ruleExpression 
	 { $current=$iv_ruleExpression.current; } 
	 EOF 
;

// Rule Expression
ruleExpression returns [EObject current=null] 
    @init { enterRule(); 
    }
    @after { leaveRule(); }:
((
(
		{ 
	        newCompositeNode(grammarAccess.getExpressionAccess().getElementsElementParserRuleCall_0_0()); 
	    }
		lv_elements_0_0=ruleElement		{
	        if ($current==null) {
	            $current = createModelElementForParent(grammarAccess.getExpressionRule());
	        }
       		add(
       			$current, 
       			"elements",
        		lv_elements_0_0, 
        		"Element");
	        afterParserOrEnumRuleCall();
	    }

)
)(	otherlv_1='|' 
    {
    	newLeafNode(otherlv_1, grammarAccess.getExpressionAccess().getVerticalLineKeyword_1_0());
    }
(
(
		{ 
	        newCompositeNode(grammarAccess.getExpressionAccess().getElementsElementParserRuleCall_1_1_0()); 
	    }
		lv_elements_2_0=ruleElement		{
	        if ($current==null) {
	            $current = createModelElementForParent(grammarAccess.getExpressionRule());
	        }
       		add(
       			$current, 
       			"elements",
        		lv_elements_2_0, 
        		"Element");
	        afterParserOrEnumRuleCall();
	    }

)
))*)
;





// Entry rule entryRuleElement
entryRuleElement returns [EObject current=null] 
	:
	{ newCompositeNode(grammarAccess.getElementRule()); }
	 iv_ruleElement=ruleElement 
	 { $current=$iv_ruleElement.current; } 
	 EOF 
;

// Rule Element
ruleElement returns [EObject current=null] 
    @init { enterRule(); 
    }
    @after { leaveRule(); }:
(
(
		{ 
	        newCompositeNode(grammarAccess.getElementAccess().getTermsTermParserRuleCall_0()); 
	    }
		lv_terms_0_0=ruleTerm		{
	        if ($current==null) {
	            $current = createModelElementForParent(grammarAccess.getElementRule());
	        }
       		add(
       			$current, 
       			"terms",
        		lv_terms_0_0, 
        		"Term");
	        afterParserOrEnumRuleCall();
	    }

)
)+
;





// Entry rule entryRuleTerm
entryRuleTerm returns [EObject current=null] 
	:
	{ newCompositeNode(grammarAccess.getTermRule()); }
	 iv_ruleTerm=ruleTerm 
	 { $current=$iv_ruleTerm.current; } 
	 EOF 
;

// Rule Term
ruleTerm returns [EObject current=null] 
    @init { enterRule(); 
    }
    @after { leaveRule(); }:
((
(
		{ 
	        newCompositeNode(grammarAccess.getTermAccess().getKConstrKeyConstrParserRuleCall_0_0()); 
	    }
		lv_kConstr_0_0=ruleKeyConstr		{
	        if ($current==null) {
	            $current = createModelElementForParent(grammarAccess.getTermRule());
	        }
       		add(
       			$current, 
       			"kConstr",
        		lv_kConstr_0_0, 
        		"KeyConstr");
	        afterParserOrEnumRuleCall();
	    }

)
)
    |(
(
		{ 
	        newCompositeNode(grammarAccess.getTermAccess().getRCallRuleCallParserRuleCall_1_0()); 
	    }
		lv_rCall_1_0=ruleRuleCall		{
	        if ($current==null) {
	            $current = createModelElementForParent(grammarAccess.getTermRule());
	        }
       		add(
       			$current, 
       			"rCall",
        		lv_rCall_1_0, 
        		"RuleCall");
	        afterParserOrEnumRuleCall();
	    }

)
))
;





// Entry rule entryRuleKeyConstr
entryRuleKeyConstr returns [EObject current=null] 
	:
	{ newCompositeNode(grammarAccess.getKeyConstrRule()); }
	 iv_ruleKeyConstr=ruleKeyConstr 
	 { $current=$iv_ruleKeyConstr.current; } 
	 EOF 
;

// Rule KeyConstr
ruleKeyConstr returns [EObject current=null] 
    @init { enterRule(); 
    }
    @after { leaveRule(); }:
((
(
		lv_SChar_0_0=RULE_STRING
		{
			newLeafNode(lv_SChar_0_0, grammarAccess.getKeyConstrAccess().getSCharSTRINGTerminalRuleCall_0_0()); 
		}
		{
	        if ($current==null) {
	            $current = createModelElement(grammarAccess.getKeyConstrRule());
	        }
       		setWithLastConsumed(
       			$current, 
       			"SChar",
        		lv_SChar_0_0, 
        		"STRING");
	    }

)
)(	otherlv_1='..' 
    {
    	newLeafNode(otherlv_1, grammarAccess.getKeyConstrAccess().getFullStopFullStopKeyword_1_0());
    }
(
(
		lv_EChar_2_0=RULE_STRING
		{
			newLeafNode(lv_EChar_2_0, grammarAccess.getKeyConstrAccess().getECharSTRINGTerminalRuleCall_1_1_0()); 
		}
		{
	        if ($current==null) {
	            $current = createModelElement(grammarAccess.getKeyConstrRule());
	        }
       		setWithLastConsumed(
       			$current, 
       			"EChar",
        		lv_EChar_2_0, 
        		"STRING");
	    }

)
))?)
;





// Entry rule entryRuleRuleCall
entryRuleRuleCall returns [EObject current=null] 
	:
	{ newCompositeNode(grammarAccess.getRuleCallRule()); }
	 iv_ruleRuleCall=ruleRuleCall 
	 { $current=$iv_ruleRuleCall.current; } 
	 EOF 
;

// Rule RuleCall
ruleRuleCall returns [EObject current=null] 
    @init { enterRule(); 
    }
    @after { leaveRule(); }:
(	otherlv_0='<' 
    {
    	newLeafNode(otherlv_0, grammarAccess.getRuleCallAccess().getLessThanSignKeyword_0());
    }
(
(
		{
			if ($current==null) {
	            $current = createModelElement(grammarAccess.getRuleCallRule());
	        }
        }
	otherlv_1=RULE_ID
	{
		newLeafNode(otherlv_1, grammarAccess.getRuleCallAccess().getRefRuleCrossReference_1_0()); 
	}

)
)	otherlv_2='>' 
    {
    	newLeafNode(otherlv_2, grammarAccess.getRuleCallAccess().getGreaterThanSignKeyword_2());
    }
)
;





RULE_ID : '^'? ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*;

RULE_INT : ('0'..'9')+;

RULE_STRING : ('"' ('\\' ('b'|'t'|'n'|'f'|'r'|'u'|'"'|'\''|'\\')|~(('\\'|'"')))* '"'|'\'' ('\\' ('b'|'t'|'n'|'f'|'r'|'u'|'"'|'\''|'\\')|~(('\\'|'\'')))* '\'');

RULE_ML_COMMENT : '/*' ( options {greedy=false;} : . )*'*/';

RULE_SL_COMMENT : '//' ~(('\n'|'\r'))* ('\r'? '\n')?;

RULE_WS : (' '|'\t'|'\r'|'\n')+;

RULE_ANY_OTHER : .;


