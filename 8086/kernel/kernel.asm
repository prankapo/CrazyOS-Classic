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

%include "terminal.inc"
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
	
	mov si, MSGCS
	mov ax, cs
	mov cx, 0x01
	call fstringdata
	call printf
	
	mov si, MSGSS
	mov ax, ss
	mov cx, 0x01
	call fstringdata
	call printf

	mov si, MSGBP
	mov ax, bp
	mov cx, 0x01
	call fstringdata
	call printf

	call time
	call date
	jmp $


section .data
	MSG1: dw "Hello world from kernel!! %d %x %c\t\n", 0x0000, 0xfff, 0xabcd, '>'
	MSGCS: dw "CS = %x\n", 0x00, 0x00
	MSGSS: dw "SS = %x\n", 0x00, 0x00
	MSGBP: dw "BP = %x\n", 0x00, 0x00
	MSGSP: dw "SP = %x\n", 0x00, 0x00
