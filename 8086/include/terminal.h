#ifndef TERMINAL_H
#define TERMINAL_H

struct term {
	char curx, cury, page;
	char ascii, keyscan;
};
struct term term;
void setpg(char);
void getxy();
void gotoxy(char, char);


void rprintf(const char*, int);
void intprint(int);
void putchar(char);
void newline();


char getchar();
void rscanf(const char*, int);

#endif
