%{
#include <stdio.h>
%}

DIG   [0-9]
VAR   [a-zA-Z]
FNUM  [0-9]+\.[0-9]+
INUM  [0-9]+

%%
\#.*           { printf("NOTA "); }
d              { printf("decimalvar "); }
e              { printf("entervar "); }
=             { printf("assignop "); }
-              { printf("minusop "); }
\+             { printf("plusop "); }
\*             { printf("timesop "); }
\/             { printf("divop "); }
o              { printf("output "); }
{VAR}          { printf("varname "); }
{INUM}         { printf("intnum "); }
{FNUM}         { printf("floatnum "); }
[ \t\n]+       { /* Ignorar espacios en blanco */ }
.              { printf("Carácter desconocido: %s\n", yytext); }
%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
