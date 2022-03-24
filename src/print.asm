print:
	push bp
	mov bp, sp
	sub sp, 0x04
	mov [bp - 1], si
.1:
	mov al, byte [si]
	mov ah, 0x0e
	int 0x10
	inc si
	cmp al, 0x00
	jne .1
	mov si, [bp - 1]
	mov sp, bp
	pop bp
	ret

printhex:
	mov bx, dx
	mov ax, bx
	
	shr ah, 0x04
	mov [.hex_num + 2], ah
	and bh, 0x0f
	mov [.hex_num + 3], bh

	shr al, 0x04
	mov [.hex_num + 4], al
	and bl, 0x0f
	mov [.hex_num + 5], bl

	mov di, .hex_num
	add di, 0x02
	mov cx, 0x04
.1:
	cmp byte [di], 0x09
	jle .2
	jg .3
.2:
	add byte [di], '0'
	jmp .check
.3:
	sub byte [di], 0x0a
	add byte [di], 'A'
	jmp .check
.check:
	inc di
	loop .1
	mov si, .hex_num
	call print
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
