print:
	mov al, byte [bx]
	mov ah, 0x0e
	int 0x10
	inc bx
	cmp al, 0x00
	jne print
	ret
