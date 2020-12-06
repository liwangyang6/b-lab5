#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"

enum NodeType{
    NODE_CONST,
    NODE_BOOL,
    NODE_VAR,
    NODE_EXPR,
    NODE_TYPE,
    NODE_STMT,
    NODE_PROG,
    NODE_OP,
    NODE_STRING,
    NODE_CHAR
};

enum StmtType{
    STMT_IF,
    STMT_WHILE,
    STMT_FOR,
    STMT_DECL,
    STMT_ASSIGN,
    STMT_PRINTF,
    STMT_SCANF,
    STMT_SKIP,
    STMT_BOOL,
    STMT_RETURN
};

enum OpType{
    OP_EQUAL,
    OP_NOT,
    OP_ADD,
    OP_SUB,
    OP_MUL,
    OP_DIV,
    OP_MOD,
    OP_LESS,
    OP_BIG,
    OP_LE,
    OP_BE,
    OP_NE,
    OP_AND,
    OP_OR,
    OP_ASSIGN
};


struct TreeNode {
public:
    int nodeID=0;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo();
    void printChildrenId();

    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    void printSpecialInfo();
    string nodeTypeInfo();
    void genNodeId(int&);

public:
    OpType optype;  // 如果是表达式
    Type* type;  // 变量、类型、表达式结点，有类型。
    ValueType vartype;
    StmtType stype;
    int int_val;
    char ch_val;
    bool bool_val;
    string str_val;
    string var_name;
public:
    static string nodeType2String (NodeType type);
    static string opType2String (OpType type);
    static string sType2String (StmtType type);

public:
    TreeNode(int lineno, NodeType type);
    TreeNode(){};
};

#endif