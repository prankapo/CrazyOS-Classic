; A simple boot sector
; Memory address where the first sector of the disk is loaded
org 0x7c00
jmp boot

%include "print.asm"

boot: 

; initialise bottom of the stack and stack pointer
	mov bp, 0x8000
	mov sp, bp

; blank out the screen by scrolling down
	mov ah, 0x07
	mov al, 0x00
	mov bh, 0x1f
	mov ch, 0x00
	mov cl, 0x00
	mov dh, 24d
	mov dl, 79d
	int 0x10

; set cursor position
	mov ah, 0x02
	mov bh, 0x00
	mov dh, 0x00
	mov dl, 0x00
	int 0x10

; select page number 0
	mov ax, 0x0500
	int 0x10

; print string 
	mov si, string1
	call print
	call printnl
	mov si, string2
	call print

string1:
	db "Hello world", 0x00
string2: 
	db "BOOTING...", 0x00
; zero padding
	times 510 - ($ - $$) db 0

; magic number 0xaa55 = 0b1010 1010 0101 0101
	dw 0xaa55
