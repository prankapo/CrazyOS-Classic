;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINTF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printf:
	push si
	mov di, si
	xor ax, ax
	xor cx, cx
	dec cx
	cld
	repne scasw
.1:
	lodsb
	cmp al, 0x00
	je .exit
	cmp al, '%'
	je .percent
	cmp al, '\'
	je .backslash
	call putchar
	jmp .1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IF PERCENTAGE SIGN IS ENCOUNTERED
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.percent:
	lodsb
	cmp al, 'c'
	je .char
	cmp al, 'd'
	je .num
	cmp al, 'x'
	je .hex
	jmp .2p
.char:
	mov ax, word [di]
	call putchar
	jmp .2p
.num:
	mov ax, word [di]
	call printdec
	jmp .2p
.hex:
	mov ax, word [di]
	push si
	push di
	call printhex
	pop di
	pop si
	jmp .2p
.2p:
	add di, 0x02
	jmp .1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IF BACKSLASH IS ENCOUNTERED
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.backslash:
	lodsb
	cmp al, 'n'
	je .newline
	cmp al, 't'
	je .tab
.2b:
	jmp .1
.newline:
	mov al, 0x0a
	call putchar
	jmp .2b
.tab:
	mov al, 0x09
	call putchar
	jmp .2b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IF NULL TERMINATOR IS ENCOUNTERED
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.exit:
	pop si
	ret