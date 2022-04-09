[bits 32]
[extern _start]
mov bx, 0x2f4b
mov word [0xb8000], bx 
call _start
jmp $
