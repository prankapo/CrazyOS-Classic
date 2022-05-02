#include <terminal.h>

void main(void)
{
	asm __volatile__ (
			".code16gcc		\n\t"
			"movw %%cs, %%ax	\n\t"
			"movw %%ax, %%ds	\n\t"
			"movw %%ax, %%es	\n\t"
			"movw $0x9000, %%ax	\n\t"
			"movw %%ax, %%ss	\n\t"
			"movw $0x9fff, %%bp	\n\t"
			"movw %%bp, %%sp	\n\t"
			:
			:
			: "ax"
			);
	rprintf("A big brown fox jumped over a little lazy dog%d\n\t", 23456);
	while (1) {
		//ch = getchar();
		//putchar(ch);
	}
}
