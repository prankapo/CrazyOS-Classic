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
        xchg ax, di
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STRCMP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strcmp:
        mov word [.p1], si
        mov word [.p2], di
        call strlen
        mov word [.n1], ax
        mov si, word [.p2]
        call strlen
        mov word [.n2], ax
        cmp ax, word [.n1]
        jne .false
        mov cx, ax
        mov si, word [.p1]
        mov di, word [.p2]
        repe cmpsb
        cmp cx, 0x00
        je .true
.false:
        mov ax, 0x01
        ret

.true:
        mov ax, 0x00
        ret
        .p1: dw 0x00
        .p2: dw 0x00
        .n1: dw 0x00
        .n2: dw 0x00
%endif