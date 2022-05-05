cpu 386
bits 16
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; KERNEL ENTRY POINT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MEMORY MAP
; 0x9A000:| BIOS related stuff |
;          --------------------
; 0x99fff:| Stack Base Pointer |
; 	  |	   ...	       |
;   ...   ~		       ~
;         |        ...         |
; 0x90000:| Stack Segment (SS) |
; 	   --------------------
; 	  |	   ...	       |
;   ...   ~		       ~
;         |        ...         |
; 0x20000:|        ...         |
; 0x10000:|    16-bit Kernel   |
; 	   --------------------
; 	  |	   ...	       |
;   ...   ~		       ~
; 0x7e00  |        ...         |
;	   --------------------
; 0x7cff: |        ...         |
; 0x7c00: | 16-bit Bootloader  |
;          --------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text

%include "ttyio.inc"
%include "clock.inc"

kernel_entry:
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ax, 0x9000
	mov ss, ax
	mov bp, 0x9fff
	mov sp, bp

kernel_main:
	mov al, 0x0a
	call putchar
	
	
	mov si, MSG1
	mov ax, 1234
	mov cx, 0x01
	call fstringdata
	call printf
	mov si, MSG2
	mov ax, 20
	mov cx, 1
	call fstringdata
	mov si, MSG2
	mov ax, 06
	mov cx, 2
	call fstringdata
	mov si, MSG2
	mov ax, 1999
	mov cx, 3
	call fstringdata
	mov si, MSG2
	mov di, MSG2
	call printf

	mov si, MSGCS
	mov ax, cs
	mov cx, 0x01
	call fstringdata
	mov si, MSGCS
	call printf

	mov si, MSGSS
	mov ax, ss
	mov cx, 0x01
	call fstringdata
	mov si, MSGSS
	call printf

	mov si, MSGBP
	mov ax, bp
	mov cx, 0x01
	call fstringdata
	mov si, MSGBP
	call printf

	mov si, MSGSP
	mov ax, sp
	mov cx, 0x01
	call fstringdata
	mov si, MSGSP
	call printf
	mov ax, sp
	call printhex
	call printnl

	mov si, MSG3
	call print
	call printnl
	call time
	call date
.1:
	call getchar
	call putchar
	jmp .1


section .data
	MSG1: dw "Hello world from kernel!! %d %x \t\n", 0x0000, 0xfff, 0xabcd
	MSG2: dw "My name is Praneet Kapoor I was born on %d %d %d!\n", 0x00, 0, 0, 0
	MSG3: dw "A big brown fox jumped over a little lazy dog! Now you should all run!!", 0x00
	MSGCS: dw "CS = %x\n", 0x00, 0x00
	MSGSS: dw "SS = %x\n", 0x00, 0x00
	MSGBP: dw "BP = %x\n", 0x00, 0x00
	MSGSP: dw "SP = %x\n", 0x00, 0x00
