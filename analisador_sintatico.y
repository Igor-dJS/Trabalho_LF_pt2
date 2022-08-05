%{

/*
Instituto de Computação - Universidade Federal do Rio de Janeiro
Authors:
- Igor Santos
- João Pedro Silveira
- Vitória Serafim

Code: Syntatic analyser for LF language as assignment for "Linguagens Formais" course at IC - UFRJ
Last update: August 2022

Compilation instructions: make
Usage instructions: ./ling_lf <input .txt file> 
*/

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);

%}

%token 
    PLUS TIMES EQUAL ID LITERALINT LITERALFLOAT IF ELSE WHILE VAR
    CONST RETURN FN ATRIB BOOL INT FLOAT TRU FALS OPAR CPAR OBRAC CBRAC
    SCOL COL ERROR INVALID_INPUT

%start ESCOPOGLOBAL

%%

ESCOPOGLOBAL: 
	{printf("Fim do programa\n");}
	| CONDICIONAL ESCOPOGLOBAL
	| DECLARACAO ESCOPOGLOBAL
	| FUNCAO ESCOPOGLOBAL
	| LOOP ESCOPOGLOBAL
;

ESCOPOLOCAL: 
	{printf("(Bloco entre chaves, regra de derivacao: ESCOPOLOCAL -> empty, codigo gerador: empty)\n");}
	| ATRIBUICAO ESCOPOLOCAL { printf("(Bloco entre chaves, regra de derivacao: ESCOPOLOCAL -> ATRIBUICAO ESCOPOLOCAL , codigo gerador: ATRIBUICAO ESCOPOLOCAL, codigo gerador: ATRIBUICAO ESCOPOLOCAL)\n"); } 
	| DECLARACAO ESCOPOLOCAL {printf("(Bloco entre chaves, regra de derivacao: ESCOPOLOCAL ->  DECLARACAO ESCOPOLOCAL, codigo gerador: DECLARACAO ESCOPOLOCAL)\n");}
	| CONDICIONAL ESCOPOLOCAL {printf("(Bloco entre chaves, regra de derivacao: ESCOPOLOCAL -> CONDICIONAL ESCOPOLOCAL , codigo gerador: CONDICIONAL ESCOPOLOCAL)\n");}
	| FUNCAO ESCOPOLOCAL{printf("(Bloco entre chaves, regra de derivacao: ESCOPOLOCAL -> FUNCAO ESCOPOLOCAL , codigo gerador: FUNCAO ESCOPOLOCAL)\n");}
;

DECLARACAO:
	VAR ID COL TYPE INICIALIZACAOOPCIONAL {printf("(Declaração de variável, regra de derivacao: DECLARACAO -> VAR ID COL TYPE INICIALIZACAOOPCIONAL , codigo gerador: VAR ID: TYPE INICIALIZACAOOPCIONAL;)\n");}
	| CONST ID COL TYPE ATRIB EXPRESSAO SCOL {printf("(Declaração de constante, regra de derivacao: DECLARACAO -> CONST ID COL TYPE ATRIB EXPRESSAO SCOL, codigo gerador: CONST ID: TYPE = EXPRESSAO);\n");}
	
ATRIBUICAO:  
	ID ATRIB EXPRESSAO SCOL {printf("(Atribuição, regra de derivacao: ATRIBUICAO -> ID ATRIB EXPRESSAO SCOL , codigo gerador: ID = EXPRESSAO)\n");}
;

CONDICIONAL: 
	IF OPAR CONDICAO CPAR OBRAC ESCOPOLOCAL CBRAC ELSEOPCIONAL SCOL {printf("(Condicional, regra de derivacao: CONDICIONAL -> IF OPAR CONDICAO CPAR OBRAC ESCOPOLOCAL CBRAC ELSEOPCIONAL SCOL, codigo gerador: IF(CONDICAO){})\n");}
;

ELSEOPCIONAL: 
	{printf("(Condicao contraria, regra de derivacao: ELSEOPCIONAL -> empty , codigo gerador: empty)\n");}
	| ELSE OBRAC ESCOPOLOCAL CBRAC {printf("(Condicao contraria, regra de derivacao: ELSEOPCIONAL -> ELSE OBRAC ESCOPOLOCAL CBRAC , codigo gerador: ELSE{ESCOPOLOCAL})\n");}
;

FUNCAO:
	FN ID OPAR ID COL TYPE CPAR COL TYPE OBRAC ESCOPOLOCAL CBRAC SCOL {printf("(Função, regra de derivacao: FUNCAO -> FN ID OPAR ID COL TYPE CPAR COL TYPE OBRAC ESCOPOLOCAL CBRAC SCOL , codigo gerador: FN ID(ID : TYPE): TYPE{ESCOPOLOCAL};))\n");}
;

LOOP:
	WHILE OPAR CONDICAO CPAR OBRAC ESCOPOLOCAL CBRAC SCOL {printf("(Loop while, regra de derivacao: LOOP -> WHILE OPAR CONDICAO CPAR OBRAC ESCOPOLOCAL CBRAC SCOL , codigo gerador: WHILE(CONDICAO){ESCOPOLOCAL};)\n");}

TYPE: 
	BOOL {printf("(Tipo, regra de derivacao: TYPE -> BOOL , codigo gerador: TYPE BOOL)\n");}
	| INT {printf("(Tipo, regra de derivacao: TYPE -> INT , codigo gerador: TYPE INT) \n");}
	| FLOAT {printf("(Tipo, regra de derivacao: TYPE -> FLOAT , regra de derivacao: TYPE FLOAT)\n");}
;

INICIALIZACAOOPCIONAL:  
	SCOL {printf("(Inicialização opcional, regra de derivacao: INICIALIZACAOOPCIONAL -> empty , codigo gerador: empty)\n");}
	| ATRIB EXPRESSAO SCOL {printf("(Inicialização opcional, regra de derivacao: INICIALIZACAOOPCIONAL -> ATRIB EXPRESSAO SCOL, codigo gerador: = EXPRESSAO;)\n");}
;

EXPRESSAO: 
	{printf("(Expressao, regra de derivacao: EXPRESSAO -> empty , codigo gerador: empty)\n");}
	| LITERALINT EXPRESSAO {printf("(Expressao, regra de derivacao: EXPRESSAO -> LITERALINT EXPRESSAO , codigo gerador: INT EXPRESSAO)\n");}
	| LITERALFLOAT EXPRESSAO {printf("(Expressao, regra de derivacao: EXPRESSAO -> LITERALFLOAT EXPRESSAO , codigo gerador: LITERALFLOAT EXPRESSAO)\n");}
	| ID EXPRESSAO {printf("(Expressao, regra de derivacao: EXPRESSAO -> ID EXPRESSAO , codigo gerador: ID EXPRESSAO)\n");}
	| PLUS EXPRESSAO {printf("(Expressao, regra de derivacao: EXPRESSAO -> PLUS EXPRESSAO , codigo gerador: + EXPRESSAO)\n");}
	| TIMES EXPRESSAO {printf("(Expressao, regra de derivacao: EXPRESSAO -> TIMES EXPRESSAO , codigo gerador: * EXPRESSAO)\n");}
;

CONDICAO: 
	{printf("(Condicao, regra de derivacao: CONDICAO -> empty , codigo gerador: empty)\n");}
	| EXPRESSAO EQUAL EXPRESSAO {printf("(Condicao, regra de derivacao: CONDICAO -> CONDICAO EQUAL EXPRESSAO , codigo gerador: EXPRESSAO == EXPRESSAO))\n");}


%%

int main(int argc, char *argv[]) 
{
	// abrir arquivo de entrada
	yyin = fopen(argv[1], "r");

	// parsear o arquivo de entrada até o fim
	do 
	{
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) 
{
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
