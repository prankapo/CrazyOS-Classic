####################################################################################
# Qemu
####################################################################################
run: CrazyOS.img
	qemu-system-i386 -m 1 -k en-us -rtc base=localtime\
		-device sb16\
		-device adlib\
		-device cirrus-vga\
		-fda CrazyOS.img -boot order=a 

####################################################################################
# MAIN
####################################################################################
all: CrazyOS.img

CrazyOS.img: boot.bin kernel.bin
	cat $^ > $@

boot.bin: boot.o
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
doc_dep: buildenv/Dockerfile
	docker build buildenv -t crazyos_buildenv

doc_run: 
	docker run --rm -it -v "C:\Data Centre\Projects\CrazyOS\8086":/root/env crazyos_buildenv

doc_del: 
	docker stop crazyos_buildenv
	docker rm crazyos_buildenv

####################################################################################
# Clean binaries and object files. Do before "gitting"
####################################################################################
clean: $(wildcard *.bin) $(wildcard *.o) CrazyOS.img
	rm $^
