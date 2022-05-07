;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CLEAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global clear
clear:
        ; blank out the screen
	mov ah, 0x07		; function code for scrolling down
	mov al, 0x00		; no. of lines to scroll, 0 for clrscr
	mov bh, 0x1f		; bf-gf = 1-f. blue bg, white fg
	mov ch, 0x00		; upper left row number
	mov cl, 0x00		; upper left column number
	mov dh, 24d		; lower right row number
	mov dl, 79d		; lower right column number
	int 0x10
	; reset the cursor
	mov ah, 0x02		; function code for setting cursor position
	mov bh, 0x00		; page number
	mov dh, 0x00		; row number
	mov dl, 0x00		; column number
	int 0x10
	; flush out the buffer
	call flush
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FLUSH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global flush
flush:
	mov di, BUFFER		; point to the buffer
	mov cx, 80		; buffer length is 80, so load that in cx
	mov al, 0x00		; this is the byte will be loading the buffer with
.1:
	stosb			; transfer the byte in al to address at di, inc di
	loop .1			; loop until cx = 0
	ret			

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GETCHAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global getchar
getchar:
	mov ah, 0x00		; for reading a key from the keyboard
	int 0x16		; AH = keyscan, AL = ASCII code, if it is there
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PUTCHAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global putchar
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GETLINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global getline
getline:
	call flush
	mov si, BUFFER
.get:
	call getchar
	; switch case
	cmp ah, 0x0e
	je .BACKSPACE
	cmp ah, 0x53
	je .BACKSPACE
	cmp ah, 0x1c
	je .ENTER
	cmp al, 0x0a
	je .ENTER
	cmp ah, 0x50
	je .DOWN
	cmp ah, 0x4f
	je .END
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
	; out of switch case
	cmp si, BUFFER_END
	je .get
	mov byte [si], al
	call putchar
	inc si
	jmp .get
.BACKSPACE:
	cmp si, BUFFER
	je .get
	dec si
	mov byte [si], 0x00
	mov al, 0x08
	call putchar
	mov al, 0x00
	call putchar
	mov al, 0x08
	call putchar
	; fix the buffer and the screen
	push si
	call findcursorposition
.L1:
	mov al, byte [si + 1]
	mov byte [si], al
	call putchar
	inc si
	cmp si, BUFFER_END
	jle .L1
	pop si
	mov bh, 0x00
	mov ah, 0x02
	int 0x10
	jmp .get
.ENTER:
	mov al, 0x0a
	mov byte [si], al
	call putchar
	jmp .return_point
.DOWN:
	jmp .get
.END: 
	jmp .get
.ESC:
	jmp .get
.HOME:
	jmp .get
.INS:
	jmp .get
.LEFT:
	dec si
	mov al, 0x08
	call putchar
	jmp .get
.PGDN:
	jmp .get
.PGUP:
	jmp .get
.RIGHT:
	call findcursorposition
	inc dl
	mov ah, 0x02
	int 0x10
	inc si
	jmp .get
.UP:
	jmp .get
.return_point:
	mov si, BUFFER
	call print
	call printnl
	call flush
	ret

findcursorposition:
	mov ah, 0x03
	mov bh, byte [.pg]
	int 0x10
	mov byte [.col], dl
	mov byte [.row], dh
	ret
	.row: db 0x00
	.col: db 0x00
	.pg: db 0x00

section .data
	BUFFER: times 80 db 0x00, 0x00
	BUFFER_END: