%{
#include "y.tab.h"
#include <stdlib.h>
%}

%option noyywrap

DIGIT   [0-9]
FNUM    {DIGIT}+\.{DIGIT}+
INUM    {DIGIT}+
IDCHAR  [a-egh-hozq-z]

%%

{FNUM}   { yylval.fvalue = atof(yytext); return FNUM; }
{INUM}   { yylval.fvalue = atoi(yytext); return INUM; }
{IDCHAR} { yylval.cvalue = yytext[0]; return ID; }

\/\/.*   { return COMMENT; }

float        { return FLOATDCL; }
int        { return INTDCL; }
=        { return ASSIGN; }
-        { return SUBTRACT; }
\+       { return PLUS; }
\*       { return MULTIPLY; }
\/       { return DIVIDE; }
print        { return PRINT; }

[ \t]+   { /* no espacios */ }
\n       { /* no saltos de línea */ }

.        { return yytext[0]; }

%%