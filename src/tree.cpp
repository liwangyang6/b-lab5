#include "tree.h"
void TreeNode::addChild(TreeNode* p) {
    if(this->child )
    {  
        this->child->addSibling(p);
    }
    else
    {
        this->child = p;
    }
}

void TreeNode::addSibling(TreeNode* p){   
    if(this->sibling)
    {   
        	this->sibling->addSibling(p);
    }
    else
    {
        this->sibling=p;
    }  
}

TreeNode::TreeNode(int lineno, NodeType type) {
    this->lineno=lineno;
    nodeType=type;
}

void TreeNode::genNodeId(int &i) {
    this->nodeID=i++;
    if(this->child)
        this->child->genNodeId(i);
    if(this->sibling )
        this->sibling->genNodeId(i);
}

void TreeNode::printNodeInfo()
{
    cout<<"Ino@"<<this->nodeID<<" @"<<lineno<<" ";
}

void TreeNode::printChildrenId() 
{
        TreeNode *node = this->child;
        if(this->child )
        {   
            cout<<"children: [";
            while(node)
            {
                cout<<"@"<<node->nodeID<<" ";
                node = node->sibling;
            }
            cout<<"]"<<" ";
        }
}


void TreeNode::printAST() 
{
    printNodeInfo();
    cout<<nodeTypeInfo()<<" ";
    printChildrenId();
    if(nodeType==NODE_VAR)
    {
        cout<<"varname: "<<var_name<<" ";
    }
    cout<<endl;
    if(this->child!=nullptr)
        this->child->printAST();
    if(this->sibling!=nullptr)
        this->sibling->printAST();
}

string TreeNode:: nodeTypeInfo()
{
        string s;
        if(this->nodeType==NODE_CONST)
            s="const";
        else if(this->nodeType==NODE_BOOL)
            s="bool";
        else if(this->nodeType==NODE_CHAR)
            s="char";
        else if(this->nodeType==NODE_VAR)
            s="variable";
        else if(this->nodeType==NODE_EXPR)
            s="expression";
        else if(this->nodeType==NODE_STRING)
            s="STRING";
        else if(this->nodeType==NODE_TYPE)
            switch(type->type)
            {
                case VALUE_INT:
                    s="tpye: int";
                    break;
                case VALUE_BOOL:
                    s="tpye: BOOL";
                    break;
                case VALUE_CHAR:
                    s="tpye: char";
                    break;
                case VALUE_STRING:
                    s="tpye: string";
                    break;
            }
        else if(this->nodeType==NODE_STMT)
            switch(stype)
            {
                case STMT_DECL:
                    s="statement stmt: decl";
                    break;
                case STMT_IF:
                   s="statement stmt: IF";
                   break;
                case STMT_PRINTF:
                    s="statement stmt: printf";
                    break;
                case STMT_WHILE:
                    s="statement stmt: while";
                    break;
                case STMT_SCANF:
                    s="statement stmt: SCANF";
                    break;
                case STMT_ASSIGN:
                    s="statement stmt: assign";
                    break;
                case STMT_FOR:
                    s="statement stmt: for";
                    break;
                case STMT_BOOL:
                    s="statement stmt: BOOL";
                    break;
                case STMT_SKIP:
                    s="statement stmt: skip";
                    break;
                case STMT_RETURN:
                    s="statement stmt: return";
                    break;
            }
        else if(this->nodeType==NODE_OP)
             switch(optype)
            {
                case OP_ADD:
                    s="operation op: add";
                    break;
                case OP_SUB:
                    s="operation op: sub";
                    break;
                case OP_MUL:
                    s="operation op: mul";
                    break;
                case OP_DIV:
                    s="operation op: div";
                    break;
                case OP_MOD:
                    s="operation op: mod";
                    break;
                case OP_EQUAL:
                    s="operation op: equal";
                    break;
                case OP_NOT:
                    s="operation op: not";
                    break;
                case OP_LESS:
                    s="operation op: less";
                    break;
                case OP_BIG:
                    s="operation op: bigger";
                    break;
                case OP_LE:
                    s="operation op: LessEqual";
                    break;
                case OP_BE:
                    s="operation op: BiggerEqual";
                    break;
                case OP_AND:
                    s="operation op: and";
                    break;
                case OP_OR:
                    s="operation op: or";
                    break;
                case OP_NE:
                    s="operation op: NotEqual";
                    break;
                case OP_ASSIGN:
                    s="operation op: ASSIGN";
                    break;
            }
        else if(this->nodeType==NODE_PROG)
            s="program";
        return s;
}


// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
            break;
        case NODE_VAR:
            break;
        case NODE_EXPR:
            break;
        case NODE_STMT:
            break;
        case NODE_TYPE:
            break;
        default:
            break;
    }
}

string TreeNode::sType2String(StmtType type) {
    return "?";
}


string TreeNode::nodeType2String (NodeType type){
    return "<>";
}
