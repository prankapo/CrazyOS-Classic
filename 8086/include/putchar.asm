global putchar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PUTCHAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
putchar:
	mov ah, 0x0e
	cmp al, 0x09
	je .TAB
	cmp al, 0x0a
	je .NEWLINE
	cmp al, 0x0d
	je .NEWLINE	
	int 0x10
	ret
.TAB:
	mov cx, 0x04
	mov al, ' '
.TAB1:
	int 0x10
	loop .TAB1
	ret
	
.NEWLINE:
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	ret
