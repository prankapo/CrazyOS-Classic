####################################################################################
# Setup
####################################################################################
.PHONY: run all doc_run doc_srun doc_stop doc_del clean

AS := nasm
ASFLAGS := -f elf32

CC := x86_64-elf-gcc
CFLAGS := -m16 -std=gnu99 -ffreestanding -O1 -Wall -Wextra -Iinclude -g

LD := x86_64-elf-ld
LDFLAGS := -melf_i386 -n -o 


####################################################################################
# Qemu
####################################################################################
run: CrazyOS.bin
	qemu-system-i386 -m 1 -k en-us -rtc base=localtime\
		-device sb16\
		-device adlib\
		-device cirrus-vga\
		-fda CrazyOS.bin -boot order=a 

####################################################################################
# MAIN
####################################################################################
all: doc_run doc_stop diskmaker.exe
	./diskmaker.exe
	cat CrazyOS.bin > CrazyOS.img

####################################################################################
# Making Binaries
####################################################################################
binaries: boot.bin kernel.bin

boot.bin: boot.o boot.ld
	$(LD) $(LDFLAGS) $@ -T boot.ld boot.o --oformat binary

boot.o: $(wildcard boot/*.asm)
	$(AS) -I boot/ boot/boot.asm $(ASFLAGS) -o $@

kernel.bin: kernel.o terminal.o kernel.ld
	$(LD) $(LDFLAGS) $@ -T kernel.ld kernel.o terminal.o --oformat binary

kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c kernel/kernel.c -o kernel.o 

terminal.o: kernel/terminal.c
	$(CC) $(CFLAGS) -c kernel/terminal.c -o terminal.o




####################################################################################
# Comands for managing build environment
####################################################################################
doc_dep: tools/buildenv/Dockerfile
	docker build tools/buildenv -t crazyos_buildenv

doc_run: 
	docker run --rm -d -i --name=crazyos_buildenv -v "C:\Data Centre\Projects\CrazyOS\8086":/root/env crazyos_buildenv
	docker exec -d crazyos_buildenv make binaries

doc_srun:
	docker run --rm -it -i --name=crazyos_buildenv -v "C:\Data Centre\Projects\CrazyOS\8086":/root/env crazyos_buildenv

doc_stop: 
	docker stop crazyos_buildenv

doc_del:
	docker rm crazyos_buildenv

####################################################################################
# Commands for compiling and linking diskmaker tool
####################################################################################
diskmaker.exe: diskmaker.o
	gcc $< -o diskmaker.exe

diskmaker.o: tools/diskmaker/diskmaker.c
	gcc -c $^

####################################################################################
# Clean binaries and object files. Do before "gitting"
####################################################################################
clean: $(filter-out junk.bin, $(wildcard *.bin)) $(wildcard *.o)
	rm $^
