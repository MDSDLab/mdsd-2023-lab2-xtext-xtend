/*
 * generated by Xtext 2.31.0
 */
grammar InternalWebTestDsl;

options {
	superClass=AbstractInternalAntlrParser;
}

@lexer::header {
package webtest.dsl.parser.antlr.internal;

// Hack: Use our own Lexer superclass by means of import. 
// Currently there is no other way to specify the superclass for the lexer.
import org.eclipse.xtext.parser.antlr.Lexer;
}

@parser::header {
package webtest.dsl.parser.antlr.internal;

import org.eclipse.xtext.*;
import org.eclipse.xtext.parser.*;
import org.eclipse.xtext.parser.impl.*;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.parser.antlr.AbstractInternalAntlrParser;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.parser.antlr.AntlrDatatypeRuleToken;
import webtest.dsl.services.WebTestDslGrammarAccess;

}

@parser::members {

 	private WebTestDslGrammarAccess grammarAccess;

    public InternalWebTestDslParser(TokenStream input, WebTestDslGrammarAccess grammarAccess) {
        this(input);
        this.grammarAccess = grammarAccess;
        registerRules(grammarAccess.getGrammar());
    }

    @Override
    protected String getFirstRuleName() {
    	return "Main";
   	}

   	@Override
   	protected WebTestDslGrammarAccess getGrammarAccess() {
   		return grammarAccess;
   	}

}

@rulecatch {
    catch (RecognitionException re) {
        recover(input,re);
        appendSkippedTokens();
    }
}

// Entry rule entryRuleMain
entryRuleMain returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getMainRule()); }
	iv_ruleMain=ruleMain
	{ $current=$iv_ruleMain.current; }
	EOF;

// Rule Main
ruleMain returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		otherlv_0='webtest'
		{
			newLeafNode(otherlv_0, grammarAccess.getMainAccess().getWebtestKeyword_0());
		}
		(
			(
				lv_testClass_1_0=RULE_ID
				{
					newLeafNode(lv_testClass_1_0, grammarAccess.getMainAccess().getTestClassIDTerminalRuleCall_1_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getMainRule());
					}
					addWithLastConsumed(
						$current,
						"testClass",
						lv_testClass_1_0,
						"org.eclipse.xtext.common.Terminals.ID");
				}
			)
		)
		(
			otherlv_2='.'
			{
				newLeafNode(otherlv_2, grammarAccess.getMainAccess().getFullStopKeyword_2_0());
			}
			(
				(
					lv_testClass_3_0=RULE_ID
					{
						newLeafNode(lv_testClass_3_0, grammarAccess.getMainAccess().getTestClassIDTerminalRuleCall_2_1_0());
					}
					{
						if ($current==null) {
							$current = createModelElement(grammarAccess.getMainRule());
						}
						addWithLastConsumed(
							$current,
							"testClass",
							lv_testClass_3_0,
							"org.eclipse.xtext.common.Terminals.ID");
					}
				)
			)
		)*
	)
;

RULE_ID : '^'? ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*;

RULE_INT : ('0'..'9')+;

RULE_STRING : ('"' ('\\' .|~(('\\'|'"')))* '"'|'\'' ('\\' .|~(('\\'|'\'')))* '\'');

RULE_ML_COMMENT : '/*' ( options {greedy=false;} : . )*'*/';

RULE_SL_COMMENT : '//' ~(('\n'|'\r'))* ('\r'? '\n')?;

RULE_WS : (' '|'\t'|'\r'|'\n')+;

RULE_ANY_OTHER : .;
