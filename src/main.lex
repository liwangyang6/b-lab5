%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

INTEGER [0-9]+

M_CHAR \'.?\'
M_STR \".+\"

ID [[:alpha:]_][[:alpha:][:digit:]_]*
%%

{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */


"true" {
    TreeNode *node = new TreeNode(lineno, NODE_BOOL);
    node->bool_val = true;
    yylval = node;
    return TRUE;
}
"false" {
    TreeNode *node = new TreeNode(lineno, NODE_BOOL);
    node->bool_val = false;
    yylval = node;
    return FALSE;
}

"int" return INT;
"char" return CHAR;
"void" return VOID;
"string" return STRING;

"if" return IF;
"while" return WHILE;
"else" return ELSE;
"return" return RETURN;
"for" return FOR;

"printf" return PRINTF;
"scanf" return SCANF;

"=" {
    TreeNode *node = new TreeNode(lineno, NODE_OP);
    node->optype = OP_ASSIGN;
    yylval = node;
    return ASSIGN;
}

"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"%" return MOD;

"!" return NOT;
"==" return EQUAL;
">" return BIG;
"<" return LESS;
"<=" return LE;
">=" return BE;
"!=" return NE;
"&&" return AND;
"||" return OR;

";" return SEMICOLON;
"(" return LPAREN;
")" return RPAREN;
"{" return LBRACE;
"}" return RBRACE;
"," return COMMA;

{INTEGER} {
    TreeNode *node = new TreeNode(lineno, NODE_CONST);
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}
{ID} {
    TreeNode *node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return ID;
}
{M_STR} {
    TreeNode *node = new TreeNode(lineno, NODE_STRING);
    string str = string(yytext);
    node->str_val = str;
    yylval = node;
    return M_STR;
}
{M_CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CHAR);
    node->ch_val = yytext[1];
    yylval = node;
    return M_CHAR;
}

{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%