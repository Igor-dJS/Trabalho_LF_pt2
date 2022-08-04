%{

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

%start DECLARACAO

%%

DECLARACAO: {printf("Fim do programa\n");}
	| VAR ID COL TYPE DVAR DECLARACAO {printf("Declarando variavel\n");}
	| CONST DCONS DECLARACAO {printf("Declarando constante\n");}
	| IFELSE DECLARACAO
	| ATRIBUICAO DECLARACAO
	| SCOL {printf("Fim do programa2323\n");}
	| FUNCAOZEIRA DECLARACAO
	| WHILEZEIRA DECLARACAO
;

AQUIDENTRO: {}
	| ATRIBUICAO AQUIDENTRO {} 
	| DECLARAVARIAVEL AQUIDENTRO {}
	| IFELSE AQUIDENTRO {}
	| FUNCAOZEIRA AQUIDENTRO{}
;

DECLARAVARIAVEL:
	VAR ID COL TYPE DVAR {printf("Declarando variavel\n");}
	| CONST DCONS {printf("Declarando constante\n");}
	


ATRIBUICAO:  ID ATRIB EXP SCOL {printf("atribuicao\n");}
;

IFELSE: 
	IF OPAR CONDZILLA CPAR OBRAC AQUIDENTRO CBRAC ELSEOPCIONAL SCOL {printf("IF(ID = LITERALINT);\n");}
;

ELSEOPCIONAL: {}
	| ELSE OBRAC AQUIDENTRO CBRAC {printf("ELSA LET IT GO\n");}
;

FUNCAOZEIRA:
	FN ID OPAR ID COL TYPE CPAR COL TYPE OBRAC AQUIDENTRO CBRAC SCOL {printf("EU SOU UMA FUNCAO\n");}
;

WHILEZEIRA:
	WHILE OPAR CONDZILLA CPAR OBRAC AQUIDENTRO CBRAC SCOL {printf("EU SOU MUUIIITTOOO WHILE\n");}



TYPE: BOOL {printf("Tipo booleano\n");}
	| INT {printf("Tipo inteiro\n");}
	| FLOAT {printf("Tipo float\n");}
;

DVAR:  SCOL {printf("Declarando varaivel sem iniciar valor\n");}
	| ATRIB DVAR2 {printf("Declarando variavel iniciando valor...\n");}
;

DVAR2: LITERALINT SCOL {printf("Declarando variavel com inteiro\n");}
	|  LITERALFLOAT SCOL {printf("Declarando variavel com float\n");}
;

DCONS: ID COL TYPE ATRIB DCONS2 {printf("Declarando constante...\n");}
;

DCONS2: LITERALINT SCOL { printf("Declarando constante com inteiro\n"); }
	|	LITERALFLOAT SCOL { printf("Declarando constante com float\n"); }
;

EXP: {}
	| LITERALINT EXP
	| LITERALFLOAT EXP
	| ID EXP
	| PLUS EXP {printf("Soma BOLADONA\n");}
	| TIMES EXP {printf("Multiplicação\n");}
;


CONDZILLA: {}
	| EXP EQUAL EXP {printf("CONDICIONAL LEGAL");}


%%

int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
