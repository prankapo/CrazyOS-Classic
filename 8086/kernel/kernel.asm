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

kernel_entry:
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ax, 0x9000
	mov ss, ax
	mov bp, 0x9fff
	mov sp, bp

kernel_main:
	call printnl
	mov si, MSG1
	call printf
	
	mov si, MSGCS
	call print
	mov dx, cs
	call printhex
	call printnl
	
	mov si, MSGSS
	call print
	mov dx, ss
	call printhex
	call printnl

	mov si, MSGBP
	call print
	mov dx, bp
	call printhex
	call printnl

time:
	call hours
	call minutes
	call seconds
	jmp time

hours:
	cli
	mov al, 0x04		; access register 0x00 in CMOS for seconds
	out 0x70, al
	mov ax, 0x00
	nop			; wait...
	in al, 0x71
	push ax
	sti
	mov ah, 0x02		; function code for setting cursor position
	mov bh, 0x00		; page number
	mov dh, 23d		; row number
	mov dl, 57d		; column number
	int 0x10
	pop dx
	call printhex
	call printnl
	ret

minutes:
	cli
	mov al, 0x02		; access register 0x00 in CMOS for seconds
	out 0x70, al
	mov ax, 0x00
	nop			; wait...
	in al, 0x71
	push ax
	sti
	mov ah, 0x02		; function code for setting cursor position
	mov bh, 0x00		; page number
	mov dh, 23d		; row number
	mov dl, 64d		; column number
	int 0x10
	pop dx
	call printhex
	call printnl
	ret

seconds:
	cli
	mov al, 0x00		; access register 0x00 in CMOS for seconds
	out 0x70, al
	mov ax, 0x00
	nop			; wait...
	in al, 0x71
	push ax
	sti
	mov ah, 0x02		; function code for setting cursor position
	mov bh, 0x00		; page number
	mov dh, 23d		; row number
	mov dl, 71d		; column number
	int 0x10
	pop dx
	call printhex
	call printnl
	ret

section .data
	MSG1: dw "Hello %x world \n%c a big brown fox jumped over a little lazy dog\t%d\n", 0x0000, 0xabcd, '>', 1
	MSGCS: db "CS = ", 0x00
	MSGSS: db "SS = ", 0x00
	MSGBP: db "BP = ", 0x00
	MSGSP: db "SP = ", 0x00
