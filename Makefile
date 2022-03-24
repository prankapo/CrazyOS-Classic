run: bin/a.bin
	qemu-system-x86_64 bin/a.bin

bin/a.bin: $(wildcard src/*.asm)
	nasm -f bin -I src/ src/boot_sector.asm -o bin/a.bin

