; A simple boot sector
[org 0x7c00]

; 'X' marks the spot program
	mov al, byte [var]
	mov ah, 0x0e
	int 0x10

var:
	db 'x'

; zero padding
	times 510 - ($ - $$) db 0

; magic number 0xaa55 = 1010 1010 0101 0101
; Note how this is a repeating bit patterm which can help in detecting 
; whether a system is big-endian or little-endian.
; Remember that it will saved in memory with the lower byte at lower address
; and higher byte at higher address, because our x86 system is little endian.
; However, you do not have to worry about how it is stored. Just helps in
; visualisation
	dw 0xaa55
