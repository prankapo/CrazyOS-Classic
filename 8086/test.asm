	jmp label
	dw 0xaa55
	times 20 db 0
	db 0
	dw 0
	db 0
label:
	mov bp, 0x8000
