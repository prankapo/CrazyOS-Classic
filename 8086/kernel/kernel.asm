bits 16
section .text

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
	call print
	call printnl
	
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

.1:
	call hours
	call minutes
	call seconds
	jmp .1

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

print:
	mov bx, si
.1:
	mov al, byte [si]
	mov ah, 0x0e
	int 0x10
	inc si
	cmp al, 0x00
	jne .1
	mov si, bx
	ret

printhex:
	mov cx, 0x04
.1:
	mov ax, dx
	and ax, 0x000f
	cmp ax, 0x0009
	jle .2
	jg .3
.2:
	add ax, '0'
	jmp .4
.3:
	sub ax, 0x0a
	add ax, 'A'
	jmp .4
.4:
	mov bx, .hex_num + 0x01
	add bx, cx
	mov byte [bx], al
	ror dx, 0x04
	loop .1
	mov si, .hex_num
	call print
	mov cx, 0x04
.5:	
	mov byte [si + 2], '0'
	inc si
	loop .5
	ret
.hex_num:
	db "0x0000", 0x00

printnl: 
	mov ah, 0x0e
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	ret	

section .data
	MSG1 db "Hello world from kernel", 0x00
	MSGCS db "CS = ", 0x00
	MSGSS db "SS = ", 0x00
	MSGBP db "BP = ", 0x00
	MSGSP db "SP = ", 0x00
