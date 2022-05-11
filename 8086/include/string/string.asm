%ifndef STRING
%define STRING

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STRLEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen:
        mov di, si
        xor ax, ax
        cld
        repne scasb
        sub di, si
        dec di
        xchg ax, di
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STRCMP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strcmp:
        mov word [.p1], si
        mov word [.p2], di
        call strlen
        mov bx, ax
        mov si, word [.p2]
        call strlen
        cmp ax, bx
        jne .false
        mov al, 'T'
        call putchar
        mov cx, bx
        mov si, word [.p1]
        mov di, word [.p2]
        repe cmpsb
        mov si, word [.p1]
        mov di, word [.p2]
        cmp cx, 0x00
        je .true
.false:
        mov al, 'F'
        call putchar
        mov ax, 0x01
        ret
.true:
        mov al, 'T'
        call putchar
        mov ax, 0x00
        ret
        .p1: dw 0x00
        .p2: dw 0x00
%endif