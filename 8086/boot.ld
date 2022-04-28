SECTIONS
{
	. = 0x7c1b;
	.text : { boot.o(.text) }
}
