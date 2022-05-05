####################################################################################
# Setup
####################################################################################
.PHONY: run all doc_run doc_srun doc_stop doc_del clean

AS := nasm
ASFLAGS := -I include/ -f elf32 

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

srun: diskmaker.exe 
	./diskmaker.exe
	cat CrazyOS.bin > CrazyOS.img
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
binaries: boot.bin kernel.bin $

boot.bin: 
	cd boot && make all
	cp boot/boot.bin .

kernel.bin: kernel/kernel.ld kernel/kernel.o \
	include/ttyio.o include/clock.o
	$(LD) $(LDFLAGS) $@ -T $^ --oformat binary

kernel/kernel.o: kernel/kernel.asm
	$(AS) $^ $(ASFLAGS) -o $@

include/ttyio.o: $(wildcard include/ttyio/*.asm)
	cd include && make ttyio.o

include/clock.o: $(wildcard include/clock/*.asm)
	cd include && make clock.o


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
	cd boot && make clean
	cd include && make clean

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
