; A simple boot sector
	mov ax, 0x002a
	mov ebx, 0xb8000
	mov ecx, 0x0100

; displays '*' with all possible combinations of bg and fg colors
vga_boot_test:
	mov word [ebx], ax
	add ebx, 0x02
	inc ah
	loop vga_boot_test

; zero padding
	times 510 - ($ - $$) db 0

; magic number 0xaa55 = 1010 1010 0101 0101
; Note how this is a repeating bit patterm which can help in detecting 
; whether a system is big-endian or little-endian.
; Remember that it will saved in memory with the lower byte at lower address
; and higher byte at higher address, because our x86 system is little endian.
; However, you do not have to worry about how it is stored. Just helps in
; visualisation
	dw 0xaa55
