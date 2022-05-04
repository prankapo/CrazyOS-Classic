cpu 386
bits 16

section .text

%include "legacyprint.asm"
%include "printf.asm"
%include "putchar.asm"

global fstringdata

fstringdata:
	push ax
	push cx
	mov di, si
	xor ax, ax
	xor cx, cx
	dec cx
	cld
	repne scasw
	pop cx
	pop ax
	
	sub cx, 0x01
	cmp cx, 0x00
	je .1
.set_di:
	add di, 0x02	
	loop .set_di
.1:
	mov word [di], ax
	ret
	
