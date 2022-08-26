main:
        mov ax, 0x0012
        int 0x10
        xor cx, cx
        xor dx, dx
        mov bx, 0x00ff
        mov ax, 0x1000
        mov ds, ax
        mov si, 0x00
.1:
        push cx
        push dx
        lodsb
        mov ah, 0x0c
        int 0x10
        call sound_tiny
        pop dx
        pop cx
        inc cx
        cmp cx, 640d
        jl .1
        xor cx, cx
        inc dx
        cmp dx, 480d
        jl .1
        xor dx, dx
        jmp .1

%include "include/sound/sound.asm"