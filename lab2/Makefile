all:
        lex calc.l
        yacc -d calc.y
        gcc y.tab.c lex.yy.c -o calc

clean:
        rm -rf calc
        rm -rf lex.yy.c
        rm -rf y.tab.c
        rm -rf y.tab.h
        rm -rf y.tab.h.gch