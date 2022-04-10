[bits 32]
[extern main]
mov bx, 0x2f4b
mov word [0xb8000], bx 
call main
jmp $
