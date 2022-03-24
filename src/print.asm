print:
	push bp
	mov bp, sp
	sub sp, 0x04
	mov [bp], si
.1:
	mov al, byte [si]
	mov ah, 0x0e
	int 0x10
	inc si
	cmp al, 0x00
	jne .1
	mov si, [bp]
	mov sp, bp
	pop bp
	ret

printnl: 
	mov ah, 0x0e
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	ret
