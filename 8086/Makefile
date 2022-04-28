####################################################################################
# Setup
####################################################################################


####################################################################################
# Qemu
####################################################################################
.PHONY: run
run: CrazyOS.bin
	qemu-system-i386 -m 1 -k en-us -rtc base=localtime\
		-device sb16\
		-device adlib\
		-device cirrus-vga\
		-fda CrazyOS.bin -boot order=a 

####################################################################################
# MAIN
####################################################################################
.PHONY: all
all: CrazyOS.bin

CrazyOS.bin: boot.bin kernel.bin
	cat $^ > $@

boot.bin: boot.o boot.ld
	ld -melf_i386 -n -o $@ -T boot.ld $^ --oformat binary

boot.o: $(wildcard boot/*.asm)
	nasm -I boot/ boot/boot.asm -f elf32 -o $@

kernel.bin: kernel.o linker.ld
	ld -melf_i386 -n -o $@ -T linker.ld $^ --oformat binary

kernel.o: kernel/kernel.asm
	nasm $< -f elf32 -o $@

####################################################################################
# Comands for managing build environment
####################################################################################
.PHONY: doc_dep
doc_dep: tools/buildenv/Dockerfile
	docker build tools/buildenv -t crazyos_buildenv

.PHONY: doc_run
doc_run: 
	docker run --rm -it -v "C:\Data Centre\Projects\CrazyOS\8086":/root/env crazyos_buildenv

.PHONY: doc_del
doc_del: 
	docker stop crazyos_buildenv
	docker rm crazyos_buildenv

####################################################################################
# Commands for compiling and linking diskmaker tool
####################################################################################
.PHONY: diskmaker
diskmaker: diskmaker.o
	gcc $< -o diskmaker.exe

diskmaker.o: tools/diskmaker/diskmaker.c
	clear
	gcc -c $^

####################################################################################
# Clean binaries and object files. Do before "gitting"
####################################################################################
.PHONY: clean
clean: $(wildcard *.bin) $(wildcard *.o) CrazyOS.img
	rm $^
