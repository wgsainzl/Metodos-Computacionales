%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
int yylex();
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

float symtab[26];  // a-z
%}

%union {
    float fvalue;
    char cvalue;
}

%token <cvalue> ID
%token <fvalue> INUM FNUM
%token FLOATDCL INTDCL PRINT ASSIGN
%token PLUS SUBTRACT MULTIPLY DIVIDE
%token COMMENT

%type <fvalue> expression expression_prime term term_prime factor

%start program

%%

program:
    statement_list
    ;

statement_list:
    statement
    | statement statement_list
    ;

statement:
      INTDCL ID {
          printf("Variable int declarada: %c\n", $2);
          symtab[$2 - 'a'] = 0;
      }
    | FLOATDCL ID {
          printf("Variable float declarada: %c\n", $2);
          symtab[$2 - 'a'] = 0.0;
      }
    | ID ASSIGN expression {
          symtab[$1 - 'a'] = $3;
          printf("Se asignó: %c = %g\n", $1, $3);
      }
    | PRINT ID {
          printf("Imprimiendo: %c = %g\n", $2, symtab[$2 - 'a']);
      }
    | expression {
          printf("= %g\n", $1);
      }
    | COMMENT {
          printf("Comentario\n");
      }
    ;

expression:
    term expression_prime {
        $$ = $2 == -1 ? $1 : $1 + $2;
    }
    ;

expression_prime:
      PLUS term expression_prime {
          $$ = $2 + ($3 == -1 ? 0 : $3);
      }
    | SUBTRACT term expression_prime {
          $$ = -$2 + ($3 == -1 ? 0 : $3);
      }
    | /* vacío */ {
          $$ = -1;
      }
    ;

term:
    factor term_prime {
        $$ = $2 == -1 ? $1 : $1 * $2;
    }
    ;

term_prime:
      MULTIPLY factor term_prime {
          $$ = $2 * ($3 == -1 ? 1 : $3);
      }
    | DIVIDE factor term_prime {
          $$ = $2 / ($3 == -1 ? 1 : $3);
      }
    | /* vacío */ {
          $$ = -1;
      }
    ;

factor:
      '(' expression ')' {
          $$ = $2;
      }
    | INUM {
          $$ = $1;
      }
    | FNUM {
          $$ = $1;
      }
    | ID {
          $$ = symtab[$1 - 'a'];
      }
    ;

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("No se puede abrir el archivo");
            return 1;
        }
        yyin = file;
    }

    yyparse();
    return 0;
}
