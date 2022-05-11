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
        mov word [.ptr1], si
        mov word [.ptr2], di
        call printnl
        call strlen
        mov cx, ax
        mov si, word [.ptr1]
        mov di, word [.ptr2]
.1:
        mov al, byte [si]
        cmp byte [di], al
        jne .false
        inc di
        inc si
        loop .1
        cmp byte [di], 0x00
        jne .false
        mov al, 'T'
        call putchar
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
        .ptr1: dw 0x00
        .ptr2: dw 0x00
        .n1: dw 0x00
        .n2: dw 0x00
%endif