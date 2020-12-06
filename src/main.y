%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token CHAR INT STRING BOOL VOID

%token SEMICOLON COMMA

%token ID INTEGER M_CHAR M_STR 
%token IF ELSE WHILE FOR RETURN
%token LPAREN RPAREN LBRACE RBRACE  
%token TRUE FALSE
%token ADD SUB MUL DIV MOD BIG LESS BE LE NE AND OR ASSIGN EQUAL NOT
%token PRINTF SCANF

%right NOT
%left ADD
%left SUB
%left MUL
%left DIV
%left MOD
%left EQUAL
%left BIG
%left LESS
%left BE
%left LE
%left NE
%left AND
%left OR
%right UMINUS

%right ASSIGN
%%

program
: T ID LPAREN RPAREN LBRACE statements RBRACE {root = new TreeNode(0, NODE_PROG); root->addChild($6);};

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| declaration SEMICOLON {$$ = $1;}
| assign SEMICOLON;
| bool_stmt{$$=$1;}
| if{$$=$1;}
| for{$$=$1;}
| while{$$=$1;}
| return SEMICOLON{$$=$1;}
| printf SEMICOLON{$$=$1;}
| scanf SEMICOLON{$$=$1;}
| LBRACE statements RBRACE {$$=$2;}
;

declaration
: T ID ASSIGN expr{  // 定义句式
	
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);	
    node->addChild($3);
    node->addChild($4);
    $$ = node;   
} 
| T ID {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;  
}
|  declaration COMMA ID{
	TreeNode* node = new TreeNode($1->lineno,NODE_STMT);
	node->stype = STMT_DECL;
	node->addChild($1);
	node->addChild($3);
	$$=node;
}
;

assign
: ID ASSIGN expr{
	TreeNode *node = new TreeNode(lineno, NODE_STMT);
	node->stype = STMT_ASSIGN;
	node->addChild($1);
	node->addChild($2);
	node->addChild($3);
	$$=node;
}


bool_stmt
: expr comp_op expr{
TreeNode* node = new TreeNode($1->lineno,NODE_STMT);
node->stype=STMT_BOOL;
node->addChild($1);
node->addChild($2);
node->addChild($3);
$$=node;
 }
| TRUE {$$=$1;}
| FALSE {$$=$1;}
;

if
: IF LPAREN bool_stmt RPAREN statement{// if句式
	TreeNode* node = new TreeNode($1->lineno,NODE_STMT);
	node->stype=STMT_IF;
	node->addChild($3);
	node->addChild($5);
	$$=node;
}
| IF LPAREN bool_stmt RPAREN  statement ELSE statement{
	TreeNode* node = new TreeNode($1->lineno,NODE_STMT);
	node->stype=STMT_IF;
	node->addChild($3);
	node->addChild($5);
	node->addChild($7);
	$$=node;
};

for
: FOR LPAREN declaration SEMICOLON bool_stmt SEMICOLON assign RPAREN  statement {
	TreeNode* node =new TreeNode($1->lineno,NODE_STMT);
	node->stype=STMT_FOR;
	node->addChild($3);
	node->addChild($5);
	node->addChild($7);
	node->addChild($9);
	$$=node;
};

while
: WHILE LPAREN bool_stmt RPAREN  statement {
	TreeNode* node =new TreeNode($1->lineno,NODE_STMT);
	node->stype=STMT_WHILE;
	node->addChild($3);
	node->addChild($5);
	$$=node;
}

return
: RETURN expr{
	TreeNode* node =new TreeNode($1->lineno,NODE_STMT);
	node->stype=STMT_RETURN;
	node->addChild($2);
	$$=node;
};
printf
: PRINTF LPAREN ids RPAREN{
	TreeNode* node =new TreeNode(lineno,NODE_STMT);
	node->stype=STMT_PRINTF;
	node->addChild($3);
	$$=node;
}
;
scanf
: SCANF LPAREN ids  RPAREN{
	TreeNode* node =new TreeNode(lineno,NODE_STMT);
	node->stype=STMT_PRINTF;
	node->addChild($3);
	$$=node;
};
ids
: ids COMMA expr {$$=$1;$$->addSibling($3);}
| expr {$$=$1;};

T: INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| STRING {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_STRING;}
| BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
;

comp_op:EQUAL{$$=new TreeNode(lineno,NODE_OP);$$->optype=OP_EQUAL;}
|	NE{$$=new TreeNode(lineno,NODE_OP);$$->optype=OP_NE;}
|	BE{$$=new TreeNode(lineno,NODE_OP);$$->optype=OP_BE;}
|	LE{$$=new TreeNode(lineno,NODE_OP);$$->optype=OP_LE;}
|	LESS{$$=new TreeNode(lineno,NODE_OP);$$->optype=OP_LESS;}
|	BIG{$$=new TreeNode(lineno,NODE_OP);$$->optype=OP_BIG;}
;
expr:ID{$$=$1;}
| INTEGER {$$=$1;}
| M_CHAR {$$=$1;}
| M_STR {$$=$1;}
| expr ADD expr {
        TreeNode *node=new TreeNode(lineno, NODE_OP);
        node->optype=OP_ADD;
        node->addChild($1);
        node->addChild($3);
        $$=node;   
    }
| expr SUB expr{
        TreeNode *node=new TreeNode(lineno, NODE_OP);
        node->optype=OP_SUB;
        node->addChild($1);
        node->addChild($3);
        $$=node;  
    }
| expr MUL expr{
        TreeNode *node=new TreeNode(lineno, NODE_OP);
        node->optype=OP_MUL;
        node->addChild($1);
        node->addChild($3);
        $$=node;  
    }
| expr DIV expr{
        TreeNode *node=new TreeNode(lineno, NODE_OP);
        node->optype=OP_DIV;
        node->addChild($1);
        node->addChild($3);
        $$=node;  
    }
| expr MOD expr{
        TreeNode *node=new TreeNode(lineno, NODE_OP);
        node->optype=OP_MOD;
        node->addChild($1);
        node->addChild($3);
        $$=node;  
    }
| SUB expr %prec UMINUS{
        TreeNode *node=new TreeNode(lineno, NODE_OP);
        node->optype=OP_SUB;
        node->addChild($2);
        $$=node;
    }
| NOT expr {
        TreeNode *node=new TreeNode(lineno, NODE_OP);
        node->optype=OP_NOT;
        node->addChild($2);
        $$=node;        
    }
| expr AND expr{
        TreeNode *node=new TreeNode(lineno, NODE_OP);
        node->optype=OP_AND;
        node->addChild($1);
        node->addChild($3);
        $$=node;  
    }
| expr OR expr{
        TreeNode *node=new TreeNode(lineno, NODE_OP);
        node->optype=OP_OR;
        node->addChild($1);
        node->addChild($3);
        $$=node;  
    }
%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}