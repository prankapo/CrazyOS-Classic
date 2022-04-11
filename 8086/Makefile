####################################################################################
# Qemu
####################################################################################
run: img/CrazyOS.img
	qemu-system-x86_64 img/CrazyOS.img 

####################################################################################
# MAIN
####################################################################################
img: bin/boot.bin bin/kernel.bin
	cat $^ > img/CrazyOS.img

bin/kernel.bin: obj/kernel.o linker.ld
	ld -n -o $@ -T linker.ld $^ --oformat binary

bin/boot.bin: $(wildcard src/boot/*.asm)
	nasm -I src/boot/ src/boot/mbr_main.asm -o $@

obj/kernel.o: src/kernel/kernel.asm
	nasm $< -f elf64 -o $@

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
clean: $(wildcard bin/*.bin) $(wildcard obj/*.o)
	rm $^
