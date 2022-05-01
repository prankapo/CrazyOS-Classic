#include <stdarg.h>
#include <terminal.h>

/*
 * NAME: rprintf(const char *, int)
 * DESCRIPTION: A funny little function for printing strings and numbers (decimal 
 * and hexadecimal).
 * If you want to print only a string, pass 0 as the integer argument.
 */
void rprintf(const char *buff, int arg)
{
	char ch, q;
	int copy = arg;
	
	for (int i = 0; buff[i]; ++i) {
		ch = buff[i];
		if (ch != 0x25 && ch != '\n' && ch != '\t') {
			putchar(ch);
			continue;
		}
		else if (ch == 0x25) {
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
		else if (ch == '\n') {
			rprintf("%c", 0x0a);
			rprintf("%c", 0x0d);
		}
		else if (ch == '\t') {
			for (int i = 0; i < 4; ++i) {
				putchar(' ');
			}
		}
	}
}

void putchar(char ch)
{
	asm __volatile__ (
			"movb %0, %%al		\n\t"
			"movb $0x0e, %%ah	\n\t"
			"int $0x10		\n\t"
			:
			: "r"(ch)
			: "ax"
			);
}
