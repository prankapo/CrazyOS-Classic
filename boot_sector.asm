; A simple boot sector
; Remember that we are at present in virtual 8086/16-bit/real mode
; Memory address where the first sector of the disk is loaded
org 0x7c00

; initialise bottom of the stack and stack pointer
	mov bp, 0x8000
	mov sp, bp

; blank out the screen by scrolling down
; int 0x10 with ah = 0x07
; previous lines are blanked. Attribute shown is store in bx
; bh = bg, bl = fg
; ch = upper left row no. from which you want to blank
; dh = lower right row no. till which you want to blank
; cl = upper left column no. from which you want to blank
; dl = lower right column no. till which you wish to blank
	mov ah, 0x07
	mov al, 0x00
	mov bh, 0x1f
	mov ch, 0x00
	mov cl, 0x00
	mov dh, 24d
	mov dl, 79d
	int 0x10

; set cursor position
; int 0x10 with ah = 0x02
; bh = page number
; dh = row number
; dl = column number
	mov ah, 0x02
	mov bh, 0x00
	mov dh, 0x00
	mov dl, 0x00
	int 0x10

; select page number 0
; int 0x10 with ah = 0x05 
; al = page number
	mov ax, 0x0500
	int 0x10

; enter teletypewriter (tty) mode
	mov ah, 0x0e

; print 'K'
	mov al, 'K'
	int 0x10

; zero padding
	times 510 - ($ - $$) db 0

; magic number 0xaa55 = 0b1010 1010 0101 0101
; Note how this is a repeating bit patterm which can help in detecting 
; whether a system is big-endian or little-endian.
; Remember that it will saved in memory with the lower byte at lower address
; and higher byte at higher address, because our x86 system is little endian.
; However, you do not have to worry about how it is stored. Just helps in
; visualisation
	dw 0xaa55
