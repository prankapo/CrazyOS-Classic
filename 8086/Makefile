####################################################################################
# Setup
####################################################################################
.PHONY: run all doc_run doc_srun doc_stop doc_del clean

AS := nasm
ASFLAGS := -f bin

KEEP := junk.bin disk2.bin

####################################################################################
# Qemu
####################################################################################
run: build
	qemu-system-i386 -m 1 -k en-us -rtc base=localtime\
		-device sb16\
		-device adlib\
		-device cirrus-vga\
		-fda build/CrazyOS.bin -fdb build/disk2.bin -boot order=a 

####################################################################################
# Making Binaries
####################################################################################
build: build/CrazyOS.bin build/disk2.bin

build/CrazyOS.bin: mkdisk1.asm build/boot.bin build/kernel.bin
	$(AS) $< $(ASFLAGS) -o $@

build/boot.bin: boot/boot.asm boot/boot_util.asm
	$(AS) $< $(ASFLAGS) -o $@

build/kernel.bin: kernel/kernel.asm\
	$(wildcard include/ttyio/*.asm)\
	$(wildcard include/clock/*.asm)
	$(AS) $< $(ASFLAGS) -o $@

build/disk2.bin: mkdisk2.asm
	$(AS) $^ $(ASFLAGS) -o $@
 
####################################################################################
# Clean binaries and object files. Do before "gitting"
####################################################################################
clean: $(filter-out $(KEEP), $(wildcard build/*.bin))
	rm $^