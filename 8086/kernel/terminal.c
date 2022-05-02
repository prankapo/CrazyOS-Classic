#include <terminal.h>

/*
 * NAME: setpg(char)
 * DESCRIPTION: Set page number. Not working correctly at present, except for page 0
 */
void setpg(char pg)
{
	term.page = pg;
	asm __volatile__ (
			".code16gcc		\n\t"
			"movb $0x05, %%ah	\n\t"
			"movb %0, %%al		\n\t"
			"int $0x10		\n\t"
			:
			: "m"(term.page)
			: "ax"
			);
}


/*
 * NAME: getxy()
 * DESCRIPTION: Sets curx and cury to the row and column at which the cursor is
 * positioned, respectively
 */
void getxy()
{
	asm __volatile__ (
			".code16gcc		\n\t"
			"movb $0x03, %%ah	\n\t"
			"movb %2, %%bh		\n\t"
			"int $0x10		\n\t"
			"movb %%dh, %0		\n\t"
			"movb %%dl, %1		\n\t"
			: "=m"(term.curx), "=m"(term.cury) 
			: "m"(term.page)
			: "ax", "bx", "dx"
			);
}

/*
 * NAME: gotoxy(char, char)
 * DESCRIPTION: Sets cursor to the row and column no. present in the parameter list
 */
void gotoxy(char x, char y)
{
	term.curx = x;
	term.cury = y;
	asm __volatile__ (
			".code16gcc		\n\t"
			"movb %0, %%bh		\n\t"
			"movb %1, %%dh		\n\t"
			"movb %2, %%dl		\n\t"
			"movb $0x02, %%ah	\n\t"
			"int $0x10		\n\t"
			:
			: "m"(term.page), "m"(term.curx), "m"(term.cury)
			: "ax", "bx", "dx"
			);
}

/*
 * NAME: rprintf(const char *, int)
 * DESCRIPTION: A funny little function for printing strings and numbers (decimal 
 * and hexadecimal).
 * If you want to print a string only, pass 0 as the integer argument.
 */
void rprintf(const char *buff, int arg)
{
	char ch, q;
	int copy = arg;
	
	for (int i = 0; buff[i] != 0; ++i) {
		ch = buff[i];
		if (ch != '%') {
			putchar(ch);
			continue;
		}
		else if (ch == '%') {
			switch (buff[++i]) {
				case 'd':
					ch = '0';
					char flag;				
					flag = 0;					
					for (int i = 1e+09; i >= 1; i /= 10) {
						q = copy / i;
						copy %= i;		
						if (q > 0 && flag == 0) {
							flag = 1;
						}
						if (flag == 1) {
							q += ch;
							putchar(q);
						}
					}
					break;
				case 'x':
				case 'X':
					;
					char hex_temp[] = "0x0000";
					int hexf = 2;
					for (int i = 5; copy > 0; --i) {
						q = copy % 16;
						copy /= 16;
						if (q < 10 && q >= 0) {
							hex_temp[i] = '0' + q;
						}
						else if (q >= 10 && q <= 15){
							hex_temp[i] = 'A' + (q - 10);
						}
						hexf = i;
					}
					putchar(hex_temp[0]);
					putchar(hex_temp[1]);
					for (int i = hexf;i < 6; ++i) {
						putchar(hex_temp[i]);
					}
					break;
				case 'c':
					ch = (char) arg;
					putchar(ch);
					break;
				case '%':
					putchar(buff[i]);
					break;
			}
		}	
	}
	return ;
}



/*
 * NAME: putchar(char)
 * DESCRIPTION: Prints a single ASCII character on the screen in TTY mode
 */
void putchar(char ch)
{
	if (ch == 0x0a || ch == 0x0d) { 	// newline
		asm __volatile__ (
			".code16gcc		\n\t"
			"movb $0x0a, %%al	\n\t"
			"movb $0x0e, %%ah	\n\t"
			"int $0x10		\n\t"
			"movb $0x0d, %%al	\n\t"
			"int $0x10		\n\t"
			:
			: 
			: "ax", "bx"
			);
	}
	else if (ch == 0x09) {			// tabs
		for (int i = 0; i < 4; ++i) {
			putchar(' ');
		}
	}
	else if (term.ascii == 0x08 && term.keyscan == 0x0e) {	// backspace & del
		asm __volatile__ (
				".code16gcc		\n\t"
				"movb %0, %%bh		\n\t"	
				"movb $0x0e, %%ah	\n\t"
				"movb $0x08, %%al	\n\t"
				"int $0x10		\n\t"
				"movb $0x00, %%al	\n\t"
				"int $0x10		\n\t"
				"movb $0x08, %%al	\n\t"
				"int $0x10		\n\t"
				:
				: "m"(term.page)
				: "ax", "bx"
				);
	}
	else if (term.ascii == 0x00 && term.keyscan == 0x4b) {	// left arrow key
		asm __volatile__ (
				".code16gcc		\n\t"
				"movb $0x00, %%bh	\n\t"
				"movb $0x03, %%ah	\n\t"
				"int $0x10		\n\t"
				"cmpb $0x00, %%dl	\n\t"
				"je 1f			\n\t"
				"sub $0x01, %%dl	\n\t"
				"1:			\n\t"
				"movb $0x02, %%ah	\n\t"
				"int $0x10		\n\t"
				:
				:
				:"ax", "bx", "dx"
			       );
	}	
	else if (term.ascii == 0x00 && term.keyscan == 0x4d) {	// right arrow key
		asm __volatile__ (
				".code16gcc		\n\t"
				"movb $0x00, %%bh	\n\t"
				"movb $0x03, %%ah	\n\t"
				"int $0x10		\n\t"
				"cmpb $79, %%dl		\n\t"
				"je 1f			\n\t"
				"add $0x01, %%dl	\n\t"
				"1:			\n\t"
				"movb $0x02, %%ah	\n\t"
				"int $0x10		\n\t"
				:
				:
				:"ax", "bx", "dx"
			       );
	}
	else  {
		asm __volatile__ (
				".code16gcc		\n\t"
				"movb %0, %%al		\n\t"
				"movb %1, %%bh		\n\t"
				"movb $0x0e, %%ah	\n\t"
				"int $0x10		\n\t"
				:
				: "r"(ch), "m"(term.page)
				: "ax", "bx"
				);
	}
	return ;
}


/*
 * NAME: newline()
 * DESCRIPTION: Sets cursor to newline. A combination of line feed (0x0a) and 
 * carriage return (0x0d)
 */
void newline()
{
	asm __volatile__ (
			".code16gcc		\n\t"
			"movb $0x0a, %%al	\n\t"
			"movb %0, %%bh		\n\t"
			"movb $0x0e, %%ah	\n\t"
			"int $0x10		\n\t"
			"movb $0x0d, %%al	\n\t"
			"int $0x10		\n\t"
			:
			: "m"(term.page)
			: "ax", "bx"
			);
	return ;
}


/*
 * NAME: getchar()
 * DESCRIPTION: Reads a character from the keyboard, prints it, and returns it
 *
char getchar()
{
	asm __volatile__ (
			".code16gcc		\n\t"
			"movb $0x00, %%ah	\n\t"
			"int $0x16		\n\t"
			"movb %%al, %0		\n\t"
			"movb %%ah, %1		\n\t"
			: "=r"(term.ascii), "=r"(term.keyscan)
			:
			: "ax"
			);
	
	if (term.keyscan == 0x0e) {		// backspace as we know it (AWKI)
		putchar(0x08);
		putchar(0x00);
	}
	else if (keyscan == 0x4b) {	// left arrow AWKI
		;
	}
	//putchar(term.ascii);
	return term.ascii;
}*/
