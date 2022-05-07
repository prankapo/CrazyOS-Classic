global clear, getline, putline, pline, nline, cursorup, cursordn, pgup, pgdn

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
        ret

getline: 
        call getchar
        ; enter into the buffer until 0x0a or 0x0d
        cmp al, 0x0a
        je .return_point
        cmp al, 0x0d
        je .return_point

.return_point:
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GETCHAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global getchar
getchar:
	mov ah, 0x00		; for reading a key from the keyboard
	int 0x16		; AH = keyscan, AL = ASCII code, if it is there
	ret

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

	BUFFER: times 256 db 0x00