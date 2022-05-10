;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT
; Responsible for basic string printing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINTHEX
; Basic hex printer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printhex:
	mov dx, ax
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
	.hex_num: db "0x0000", 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT8BITPACKEDBCD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print8bitpackedBCD:
	mov dx, 0x00
	mov dx, ax
	shl dx, 0x04
	shr dl, 0x04
	mov al, dh
	and al, 0x0f		; this removes junk from the higher order nibble 
	add al, '0'
	call putchar
	mov al, dl
	and al, 0x0f
	add al, '0'
	call putchar
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINTDEC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printdec:
	push dx
	push si
	push di

.divide:
	mov dx, 0x00
	div word [.divisor]
	mov byte [.q], al
	mov word [.copy], dx
.con1:	
	cmp byte [.q], 0
	jg .con1_1
	jmp .con2
.con1_1:
	cmp byte [.flag], 0x00
	jne .con2
	mov byte [.flag], 0x01
.con2:
	cmp byte [.flag], 0x01
	jne .checknset
	add byte [.q], '0'
	mov al, byte [.q]
	call putchar
.checknset:
	cmp word [.divisor], 0x01
	je .end
	mov dx, 0x00
	mov ax, word [.divisor]
	div word [.div2]
	mov word [.divisor], ax
	mov ax, word [.copy]
	jmp .divide
.end:
	pop di
	pop si
	pop dx
	mov byte [.flag], 0x00
	mov byte [.q], 0x00
	mov word [.copy], 0x00
	mov word [.divisor], 10000
	ret
	.flag: db 0x00
	.q: db 0x00
	.copy: dw 0x00
	.divisor: dw 10000
	.div2: dw 10

printnl: 
	call conditional_scrollup
	mov ah, 0x0e
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	ret