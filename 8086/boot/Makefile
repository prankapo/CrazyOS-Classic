AS := nasm
ASFLAGS := -f elf32 

LD := x86_64-elf-ld
LDFLAGS := -melf_i386 -n -o 


all: boot.bin

boot.bin: boot.ld boot.o
	$(LD) $(LDFLAGS) $@ -T $^ --oformat binary

boot.o: boot.asm \
	../include/boot/boot_util.asm
	$(AS) boot.asm $(ASFLAGS) -o $@

clean: $(wildcard *.o) $(wildcard *.bin)
	rm $^
