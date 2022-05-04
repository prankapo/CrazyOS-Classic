####################################################################################
# Makefile for building objects for source code present in the library
####################################################################################
AS := nasm
ASFLAGS := -f elf32 

LD := x86_64-elf-ld
LDFLAGS := -melf_i386 -n -o 

OBJ := terminal.o clock.o

all: $(OBJ)

terminal.o: $(wildcard terminal/*.asm) terminal.inc
	$(AS) terminal/terminal.asm -I terminal/ $(ASFLAGS) -o $@
clock.o: clock/clock.asm clock.inc
	$(AS) clock/clock.asm $(ASFLAGS) -o $@
clean: $(OBJ)
	rm $^
