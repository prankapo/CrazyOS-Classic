SECTION .text
BITS 16

kernel_entry:
	mov al, 'D'		; X marks the spot
	mov ah, 0x0e
	int 0x10
	mov al, 'U'
	mov ah, 0x0e
	int 0x10
	mov al, 'C'
	mov ah, 0x0e
	int 0x10
	mov al, 'K'
	mov ah, 0x0e
	int 0x10
	jmp $
