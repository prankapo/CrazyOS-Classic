;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GETCHAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global getchar
getchar:
	mov ah, 0x00		; for reading a key from the keyboard
	int 0x16		; AH = keyscan, AL = ASCII code, if it is there
	push ax
	

	cmp ah, 0x0e
	je .BACKSPACE
	cmp ah, 0x53
	je .DEL
	cmp ah, 0x50
	je .DOWN
	cmp ah, 0x4f
	je .END
	cmp ah, 0x1c
	je .ENTER
	cmp ah, 0x01
	je .ESC
	cmp ah, 0x47
	je .HOME
	cmp ah, 0x52
	je .INS
	cmp ah, 0x4b
	je .LEFT
	cmp ah, 0x51
	je .PGDN
	cmp ah, 0x49
	je .PGUP
	cmp ah, 0x4D
	je .RIGHT
	cmp ah, 0x48
	je .UP
	call putchar
	jmp .return_point

.BACKSPACE:
	mov al, 0x08
	call putchar
	mov al, 0x00
	call putchar
	mov al, 0x08
	call putchar
	jmp .return_point


.DEL:
	mov al, 0x00
	call putchar
	jmp .return_point


.DOWN:
	call findcursorposition
	cmp dh, 24d
	je .down1
	inc dh
.down1:
	mov ah, 0x02
	int 0x10
	jmp .return_point


.END:
	call findcursorposition
	mov dl, 79d
	mov ah, 0x02
	int 0x10
	jmp .return_point


.ENTER:
	mov al, 0x0a
	call putchar
	jmp .return_point


.ESC:
	
	jmp .return_point


.HOME:
	call findcursorposition
	mov dl, 00d
	mov ah, 0x02
	int 0x10
	jmp .return_point


.INS:
	jmp .return_point


.LEFT:
	mov al, 0x08
	call putchar
	jmp .return_point


.PGDN:
	jmp .return_point


.PGUP:
	jmp .return_point


.RIGHT:
	call findcursorposition
	inc dl
	mov ah, 0x02
	int 0x10
	jmp .return_point


.UP:
	call findcursorposition
	cmp dh, 0x00
	je .up1
	dec dh
.up1:
	mov ah, 0x02
	int 0x10
	jmp .return_point


.return_point:
	pop ax
	ret

findcursorposition:
	mov ah, 0x03
	mov bh, byte [.pg]
	int 0x10
	mov byte [.col], dl
	mov byte [.row], dh
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Cursor position variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.row: db 0x00
	.col: db 0x00
	.pg: db 0x00
