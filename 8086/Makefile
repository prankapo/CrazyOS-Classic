####################################################################################
# Qemu
####################################################################################
run: iso/CrazyOS.iso
	qemu-system-x86_64 -bios OVMF.fd -boot iso/CrazyOS.iso 

####################################################################################
# MAIN
####################################################################################
iso: bin/mbr.bin bin/kernel.bin
	cat $^ > bin/CrazyOS.bin
	iat bin/CrazyOS.bin iso/CrazyOS.iso

bin/kernel.bin: obj/kernel_entry.o obj/kernel.o
	x86_64-elf-ld -n -o $@ -T linker.ld $^ --oformat binary

bin/mbr.bin: $(wildcard src/boot/*.asm)
	nasm -I src/boot/ src/boot/mbr_main.asm -o $@

obj/kernel_entry.o: src/boot/kernel_entry.asm
	nasm $< -f elf64 -o $@

obj/kernel.o: src/kernel/kernel.c
	x86_64-elf-gcc -c -ffreestanding $< -o $@

####################################################################################
# Comands for managing build environment
####################################################################################
doc_dep: buildenv/Dockerfile
	docker build buildenv -t crazyos_buildenv

doc_run: 
	docker run --rm -it -v "C:\Data Centre\Projects\CrazyOS\CrazyOS":/root/env crazyos_buildenv

doc_del: 
	docker stop crazyos_buildenv
	docker rm crazyos_buildenv

####################################################################################
# Clean binaries and object files. Do before "gitting"
####################################################################################
clean: $(wildcard bin/*.bin) $(wildcard obj/*.o)
	rm $^
