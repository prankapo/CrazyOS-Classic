run: iso/CrazyOS.iso
	qemu-system-x86_64 -m 128M -usb iso/CrazyOS.iso 

iso/CrazyOS.iso: bin/mbr.bin obj/kernel_entry.o obj/kernel.o
	objcopy -O binary -j .text obj/kernel_entry.o bin/kernel_entry.bin
	objcopy -O binary -j .text obj/kernel.o bin/kernel.bin
	python bin/diskmaker.py
	yes y|piso convert bin/CrazyOS.bin -o iso/CrazyOS.iso

bin/mbr.bin: $(wildcard src/boot/*.asm)
	nasm -f bin -I src/boot/ src/boot/mbr_main.asm -o bin/mbr.bin

obj/kernel_entry.o: src/boot/kernel_entry.asm
	nasm $< -f elf32 -o $@

obj/kernel.o: src/kernel/kernel.c
	gcc -m32 -fno-pie -c $< -o $@

clean: $(wildcard bin/*.bin) $(wildcard obj/*.o)
	rm $^
