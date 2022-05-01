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

	rprintf("Hello, world!%c", 0x0a);
	rprintf("%cHellodddddddddddddddd\t", 0x0d);
	rprintf("%d\n", 1234);
	rprintf("%x\n", 16);
	while (1) {
		;	
	}
}
