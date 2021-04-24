%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <stdarg.h>
void yyerror(const char*);
int yylex();
void print_sym_tab();
void update_sym_tab(char* typ, char* nam, int line, int scope);
int scope[100];
int scope_ctr;
int scope_ind;
char typ[10]="none";
typedef struct AST{
	char lexeme[100];
	int NumChild;
	struct AST **child;
}AST_node;

struct AST* make_for_node(char* root, AST_node* child1, AST_node* child2, AST_node* child3, AST_node* child4);
/* changed next line*/
/* changing var type of arguments */
struct AST* make_node(char* , AST_node*, AST_node*);
struct AST* make_leaf(char* root);
void AST_print(struct AST *t);
extern FILE* yyin;
extern int yylineno;
/* adding c function declarations */
void yyerror(const char* arg);
void update_sym_tab(char* typ, char* nam, int line, int scope);
void print_sym_tab();
int look_up_sym_tab(char* nam);
int look_up_sym_tab_dec(char* nam, int scop);
int get_scope();
int yywrap();

%}
//%option noyywrap
%locations
/* changing the token data type of t_switch */
%token <var_type> T_DOT T_SINGLE T_SC  T_COMMA T_LETTER  T_OPBRACE T_CLBRACE T_CONTINUE T_BREAK T_POW T_OPEN T_CLOSE T_COMMENT 
/*%token <node> T_DOT T_SINGLE T_SC  T_COMMA T_LETTER  T_OPBRACE T_CLBRACE T_CONTINUE T_BREAK T_POW T_OPEN T_CLOSE T_COMMENT T_SWITCH */
%union {char* var_type; char* text; struct AST *node;}
%token <var_type> T_INT T_FLOAT T_CHAR T_SWITCH T_DOUBLE
%token <text> T_ID T_NUM T_PLUS T_MINUS T_MULT T_DIV T_ASSIGN T_SPLUS T_SMINUS T_SMULT T_SDIV T_INC T_DEC 
%token <node> T_MAIN T_RETURN T_DEFAULT T_CASE T_COLON 
%type <var_type> Type
%type <text> Varlist s_op
%type <node> F T E assign_expr1 assign_expr decl unary_expr stat comp_stat start jump_stat select_stat ST C B D s_operation 

%% 


/* changing make node function param */
/*start:T_INT T_MAIN T_OPEN T_CLOSE comp_stat  {$$ = make_leaf($1); $$=make_node("Main",$1,$5);printf("\n\nAbstract Syntax Tree:\n\n"); AST_print($$); 																printf("\n\n");print_sym_tab(); YYACCEPT;}   
     ;*/
     
     
start:	T_INT T_MAIN T_OPEN T_CLOSE comp_stat  {$$ = make_leaf($1); $$=make_node("Main",$2,$5); 
	printf("\n\n");print_sym_tab(); YYACCEPT;}   
     ;     

comp_stat: T_OPBRACE SCOPE stat T_CLBRACE {$$=$3;scope[scope_ind++]=0;}
		 ;
		 
SCOPE: {scope_ctr++;scope[scope_ind++]=scope_ctr;}
	 ;
stat:E T_SC stat               {$$=make_node("Statement",$1,$3);}
    |assign_expr stat        {$$=make_node("Statement",$1,$2);}
    |comp_stat stat          {$$=make_node("Statement",$1,$2);}
    |select_stat stat        {$$=make_node("Statement",$1,$2);}
    |decl stat    			 {$$=make_node("Statement",$1,$2);}
    |jump_stat stat     	 {$$=make_node("Statement",$1,$2);}
    |				{$$=make_leaf("  ");}
    | error T_SC
    ;

    
ST  : T_SWITCH T_OPEN T_ID T_CLOSE T_OPBRACE  {scope_ctr++;scope[scope_ind++]=scope_ctr;}  B T_CLBRACE {scope[scope_ind++]=0;$$=make_leaf($1); 																$$=make_node("Switch",(AST_node*)$5,$7);if(!look_up_sym_tab($3)){printf("Undeclared variable %s\n", $3); YYERROR;}}
    ;     

B   : C         {$$=$1;}
    | C D        {$$=make_node("Cases",$1,$2);}
    | C B       {$$=make_node("Cases",$1,$2);}
    ;
    
C   : T_CASE T_NUM T_COLON stat      {$$=make_node("Case",(AST_node*)$2,$4);}
    ;

D   : T_DEFAULT T_COLON stat       {$1=make_leaf(" "); $$=make_node("Default",$1,$3);}
    ;

select_stat: ST   {$$=$1;}
		   ;


jump_stat:T_CONTINUE T_SC            {$$=make_leaf("Continue");}
		 |T_BREAK T_SC      {$$=make_leaf("Break");}
		 |T_RETURN E T_SC    {$1=make_leaf("Return");$$ = make_node("Statement",$1,$2);}
		 ;		

decl:Type Varlist T_SC    {$1=(char*)make_leaf($1); $$=make_leaf($2); $$=make_node("Variable_Declaration",(AST_node*)$1,(AST_node*)$2); }     
    |Type assign_expr1   {$1=(char*)make_leaf($1); $$=make_node("Variable_Declaration",(AST_node*)$1,$2);} 
    ;
 
Type:T_INT 		{$$ = $1;strcpy(typ,$1);}
	|T_FLOAT      {$$ = $1;strcpy(typ,$1);}
	|T_DOUBLE	{$$ = $1;strcpy(typ,$1);}
	|T_CHAR		{$$ = $1;strcpy(typ,$1);}
	;

Varlist:Varlist T_COMMA T_ID    {$3=(char*)make_leaf($3);$$=(char*)make_node("Variable List",(AST_node*)$1,(AST_node*)$3);if(look_up_sym_tab_dec($3,scope[scope_ind-1])){ yyerror("Redeclaration\n");  YYERROR; } 
								if(scope[scope_ind-1]>0){update_sym_tab($<var_type>0,$3,yylineno,scope[scope_ind-1]);}else{int scop=get_scope();update_sym_tab($<var_type>0,$3,yylineno,scop);}}
	   |T_ID 			{$$=(char*)make_leaf($1); if(look_up_sym_tab_dec($1,scope[scope_ind-1])){ yyerror("Redeclaration\n");  YYERROR; }
	   					if(scope[scope_ind-1]>0){update_sym_tab($<var_type>0,$1,yylineno,scope[scope_ind-1]);}else{int scop=get_scope();update_sym_tab($<var_type>0,$1,yylineno,scop);}}
	   

assign_expr:T_ID T_ASSIGN E T_COMMA assign_expr     {$1=(char*)make_leaf($1); $$=make_for_node($2,(AST_node*)$1,(AST_node*)$3,make_leaf(","),$5); if(!look_up_sym_tab($1)){printf("Undeclared variable %s\n", $1); YYERROR;}}
		   |T_ID T_ASSIGN E T_SC            {$1=(char*)make_leaf($1); $$=make_node($2,(AST_node*)$1,(AST_node*)$3); if(!look_up_sym_tab($1)){printf("Undeclared variable %s\n", $1); YYERROR;} 												}
		   ;

assign_expr1:T_ID T_ASSIGN E T_COMMA assign_expr1    {$1=(char*)make_leaf($1);$$=make_for_node($2,(AST_node*)$1,(AST_node*)$3,make_leaf(","),$5); if(look_up_sym_tab_dec($1,scope[scope_ind-1])){ yyerror("Redeclaration\n");  YYERROR; }
if(scope[scope_ind-1]>0){update_sym_tab(typ,$1,yylineno,scope[scope_ind-1]);}else{int scop=get_scope();update_sym_tab(typ,$1,yylineno,scop);}}
		   |T_ID T_ASSIGN E T_SC           {$1=(char*)make_leaf($1);$$=make_node($2,(AST_node*)$1,(AST_node*)$3); if(look_up_sym_tab_dec($1,scope[scope_ind-1])){ yyerror("Redeclaration\n");  YYERROR; } if(scope[scope_ind-1]>0){update_sym_tab(typ,$1,yylineno,scope[scope_ind-1]);}else{int scop=get_scope();update_sym_tab(typ,$1,yylineno,scop);} }
		   ;

E:E T_PLUS T    {$$=make_node($2,$1,$3); }
 |E T_MINUS T    {$$=make_node($2,$1,$3);}
 |T            {$$=$1;}
 ;
 
T:T T_MULT F    {$$=make_node($2,$1,$3);}
 |T T_DIV F     {$$=make_node($2,$1,$3);}
 |F           {$$=$1;}
 ;
 
F:T_ID  {$$=make_leaf($1); if(!look_up_sym_tab($1)){printf("Undeclared Variable %s\n", $1); YYERROR;} }
 |T_NUM            {$$=make_leaf($1);}
 |T_OPEN E T_CLOSE   {$$=$2;}
 |unary_expr        {$$=$1;}
 |s_operation      {$$=$1;}
 ;
 
s_operation: T_ID s_op T_ID  {$1=(char*)make_leaf($1); $3=(char*)make_leaf($3); $$=make_node($2,(AST_node*)$1,(AST_node*)$3); if(!look_up_sym_tab($1)){printf("Undeclared variable %s\n", $1); YYERROR;}if(!look_up_sym_tab($3)){printf("Undeclared variable %s\n", $3); YYERROR;}}
			   | T_ID s_op T_NUM {$1=(char*)make_leaf($1); $3=(char*)make_leaf($3); $$=make_node($2,(AST_node*)$1,(AST_node*)$3); if(!look_up_sym_tab($1)){printf("Undeclared variable %s\n", $1); YYERROR;}}
			   | T_ID s_op T_OPEN E T_CLOSE {$1=(char*)make_leaf($1); $$=make_node($2,(AST_node*)$1,(AST_node*)$4);}
			   ;

s_op:T_SPLUS   {$$=$1;}
	|T_SMINUS   {$$=$1;}
	|T_SMULT   {$$=$1;}
	|T_SDIV    {$$=$1;}
	;

unary_expr:T_INC T_ID {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",(AST_node*)$1,(AST_node*)$2); if(!look_up_sym_tab($2)){printf("Undeclared variable %s\n", $2); YYERROR;}}
		  |T_ID T_INC {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",(AST_node*)$1,(AST_node*)$2); if(!look_up_sym_tab($1)){printf("Undeclared variable %s\n", $1); YYERROR;}}
		  |T_DEC T_ID {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",(AST_node*)$1,(AST_node*)$2); if(!look_up_sym_tab($2)){printf("Undeclared variable %s\n", $2); YYERROR;}}
		  |T_ID T_DEC {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",(AST_node*)$1,(AST_node*)$2); if(!look_up_sym_tab($1)){printf("Undeclared variable %s\n", $1); YYERROR;}}
		  | T_MINUS T_ID {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",(AST_node*)$1,(AST_node*)$2); if(!look_up_sym_tab($1)){printf("Undeclared variable %s\n", $1); YYERROR;}}
		  | T_MINUS T_NUM   {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",(AST_node*)$1,(AST_node*)$2);}
		  ;
%%
void yyerror(const char* arg)
{
	printf("%s\n",arg);
}

struct entry
{
	char name[30];
	char type[10];
	int width;
	int line_num;
	int scope;
};

struct entry sym_tab[100];
int ctr = 0;

void update_sym_tab(char* typ, char* nam, int line, int scope)
{
	strcpy(sym_tab[ctr].name,nam);

	if(strcmp(typ,"int")==0)
	{
		strcpy(sym_tab[ctr].type,typ);
		sym_tab[ctr].width=4;
	}

	else if(strcmp(typ,"float")==0)
	{
		strcpy(sym_tab[ctr].type,typ);
		sym_tab[ctr].width=8;
	}
	else if(strcmp(typ,"double")==0)
	{
		strcpy(sym_tab[ctr].type,typ);
		sym_tab[ctr].width=8;
	}
	else if(strcmp(typ,"char")==0)
	{
		strcpy(sym_tab[ctr].type,typ);
		sym_tab[ctr].width=1;	
	}
	sym_tab[ctr].line_num=line;
	sym_tab[ctr].scope=scope;
	ctr++;


}

void print_sym_tab()
 { 	
 		int i; 	
		printf("\n\nSymbol Table: \n"); 
		for(i=0;i<ctr;i++) 	
		{ 		
			printf("Token: %s, Type: %s, Size: %d, Line Number: %d, Scope: %d\n \n",sym_tab[i].name, sym_tab[i].type, sym_tab[i].width,sym_tab[i].line_num,sym_tab[i].scope); 	} 

}

int look_up_sym_tab(char* nam)
{
	int i; 
	for(i=0;i<ctr;i++)
	{
		if(strcmp(sym_tab[i].name,nam)==0)
		{
			int scop=sym_tab[i].scope;
			int flag=0;
			int zero_ctr=0;
			int j=scope_ind-1;
			while(j>=0)
			{
				if(scope[j]==0)
					zero_ctr++;
				else if(scope[j]!=0 && zero_ctr>0)
					zero_ctr--;
				else if(scope[j]!=0 && zero_ctr==0)
				{
					if(scope[j]==scop)
					{
						flag=1;
						return 1;
					}
				}
				j--;
			}
		}
	}
	return 0;
}


int yywrap() {  
// open next reference or source file and start scanning  
if(yyin != NULL) {  
  yylineno = 0; // reset line counter for next source file
  return 0;  
   }
return 1;
} 


int look_up_sym_tab_dec(char* nam, int scop)
{
	int i; 
	for(i=0;i<ctr;i++)
	{
		if(strcmp(sym_tab[i].name,nam)==0 && sym_tab[i].scope==scop)
		{
			return 1;
		}
	}
	return 0;
}


void AST_print(struct AST *t)
{
	static int ctr=0;
	//printf("inside print tree\n");
	int i;
	if(t->NumChild==0) 
		return;

	struct AST *t2=t;
	printf("\nRoot: %s\n",t2->lexeme);
	printf("Children: ");
	for(i=0;i<t2->NumChild;++i) 
	{
		printf("%s ",t2->child[i]->lexeme);
	}
	printf("\n\n");	
	for(i=0;i<t2->NumChild;++i)
	{
		AST_print(t->child[i]);
	}
}

struct AST* make_node(char* root, AST_node* child1, AST_node* child2)
{
	//printf("Creating new node\n");
	struct AST * node = (struct AST*)malloc(sizeof(struct AST));
	node->child = (struct AST**)malloc(2*sizeof(struct AST *));
	node->NumChild = 2;//
	strcpy(node->lexeme,root);
	//printf("Copied lexeme\n");
	//printf("%s\n",node->lexeme);
	//CHANGING THE FLWG TWO LINES
	node->child[0] = child1;
	//strcpy(node->child[0],child1);
	node->child[1] = child2;
	//strcpy(node->child[1],child2);
	return node;
}

struct AST* make_for_node(char* root, AST_node* child1, AST_node* child2, AST_node* child3, AST_node* child4)
{
	//printf("Creating new node\n");
	struct AST * node = (struct AST*)malloc(sizeof(struct AST));
	node->child = (struct AST**)malloc(4*sizeof(struct AST *));
	node->NumChild = 4;
	strcpy(node->lexeme,root);
	node->child[0] = child1;
	node->child[1] = child2;
	node->child[2] = child3;
	node->child[3] = child4;
	return node;
}


struct AST* make_leaf(char* root)
{
	//printf("Creating new leaf ");
	struct AST * node = (struct AST*)malloc(sizeof(struct AST));
	strcpy(node->lexeme,root);
	//printf("%s\n",node->lexeme);
	node->NumChild = 0;
	node->child = NULL;
	return node;
}



int main()
{
	printf("Parsing the following Input:\n\n");
	yyin=fopen("Input.txt","r");
	//print_sym_tab();
	//yylex();
	if(!yyparse())
	{
		printf("Success\n");

	}
	else
	{
		printf("Fail\n");
		print_sym_tab();
	}
	/*
	for(int i=0;i<scope_ind;i++)
		printf("%d ",scope[i]);
	printf("\n");
	*/
}

int get_scope()
{
	//printf("ind :%d\n",scope_ind);
	int i=scope_ind-1;
	int zero_ctr=0;
	int flag=1;
	while(flag && i>0)
	{
		if(scope[i]!=0)
			zero_ctr--;
		else
			zero_ctr++;
		if(zero_ctr==0)
		{
			i--;
			flag=0;
			break;
		}
		i--;
	}
	return scope[i];
}

