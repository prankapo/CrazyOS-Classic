###############################################################################
# Variables
###############################################################################
.PHONY = run build assemble clean

AS := nasm
ASFLAGS := -f bin

OS-DISK := build/CrazyOS-x86-64.bin
DATA-DISK := build/data.bin

QEMU := qemu-system-x86_64
QEMUFLAGS := -m 16M -k en-us -rtc base=localtime\
		-device sb16\
		-device adlib\
		-device cirrus-vga\
		-soundhw pcspk\
		-hdc $(OS-DISK) -hdd $(DATA-DISK) -boot order=c


###############################################################################
# Run Qemu
###############################################################################
run: all
	$(QEMU) $(QEMUFLAGS)


###############################################################################
# Create the disks
###############################################################################
all: $(OS-DISK) $(DATA-DISK)

$(OS-DISK): make-os-disk.asm build/boot.bin
	$(AS) $< $(ASFLAG) -o $@

$(DATA-DISK): make-data-disk.asm
	$(AS) $< $(ASFLAGS) -o $@


###############################################################################
# Assemble the source files
###############################################################################
build/boot.bin: boot/boot.asm\
	$(filter-out boot/boot.asm, $(wildcard boot/*.asm))
	$(AS) $< $(ASFLAGS) -o $@


###############################################################################
# Clean everything
###############################################################################
clean: $(filter-out $(DATA-DISK), $(wildcard build/*.bin))
	rm $^

clean\ all: $(wildcard build/*.bin)
	rm $^