####################################################################################
# Setup
####################################################################################
.PHONY: run all doc_run doc_srun doc_stop doc_del clean

AS := nasm
ASFLAGS := -f bin

KEEP := build/disk2.bin build/asm.bin

####################################################################################
# Qemu
####################################################################################
run: build
	qemu-system-i386 -m 1 -k en-us -rtc base=localtime\
		-device sb16\
		-device adlib\
		-device cirrus-vga\
		-soundhw pcspk\
		-fda build/CrazyOS.bin -fdb build/disk2.bin -boot order=a 

####################################################################################
# Making Binaries
####################################################################################
build: build/CrazyOS.img build/disk2.bin

build/CrazyOS.img: mkdisk1.asm build/boot.bin build/kernel.bin
	$(AS) $< $(ASFLAGS) -o build/CrazyOS.bin
	cat build/CrazyOS.bin > build/CrazyOS.img

build/boot.bin: boot/boot.asm boot/boot_util.asm
	$(AS) $< $(ASFLAGS) -o $@

build/kernel.bin: kernel/kernel.asm\
	$(wildcard include/*/*.asm)\
	$(wildcard apps/*/*.asm)
	$(AS) $< $(ASFLAGS) -o $@

build/disk2.bin: mkdisk2.asm\
	disk-apps/soundnlight.asm
	$(AS) disk-apps/soundnlight.asm $(ASFLAGS) -o build/asm.bin
	$(AS) $< $(ASFLAGS) -o $@
 
####################################################################################
# Clean binaries and object files. Do before "gitting"
####################################################################################
clean: $(filter-out $(KEEP), $(wildcard build/*.bin)) $(wildcard build/*.img)
	rm $^