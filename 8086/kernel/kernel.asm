bits 16
section .text

kernel_entry:
	mov ax, cs
	mov ds, ax
	mov es, ax

kernel_main:
	mov si, MSG1
	call print
	call printnl
	mov dx, 0x1af4
	call printhex
	call printnl
	mov si, MSG1
	call print
	mov dx, 0xff12
	call printhex
	call printnl
	jmp $

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
	MSG1 db "Xello world", 0x00
