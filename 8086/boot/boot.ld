SECTIONS
{
	. = 0x7c00;
	.text : { boot.o(.text) }
}
