AS := nasm
ASFLAGS := -f bin

all: boot.bin

boot.bin: boot.asm \
	../include/boot/boot_util.asm
	$(AS) boot.asm $(ASFLAGS) -o $@

clean: $(wildcard *.o) $(wildcard *.bin)
	rm $^