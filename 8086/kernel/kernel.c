#include <stdarg.h>

void main(void)
{
	asm __volatile__ (
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
	char ch = 'X';
	asm __volatile__ (
			"movb $0x44, %%al	\n\t"
			"movb $0x0e, %%ah	\n\t"
			"int $0x10		\n\t"
			"movb %0, %%al		\n\t"
			"movb $0x0e, %%ah	\n\t"
			"int $0x10		\n\t"
			"movb $0x43, %%al	\n\t"
			"movb $0x0e, %%ah	\n\t"
			"int $0x10		\n\t"
			:
			: "r"(ch)
			: "ax"
			);
	while (1) {
		;	
	}
}
