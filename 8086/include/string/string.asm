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
        push ax
        call printdec
        call printnl
        pop ax
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STRCMP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strcmp:
        mov word [.ptr1], si
        mov word [.ptr2], di
        push si
        call print
        pop si
        call strlen
        mov word [.n1], ax
        mov si, word [.ptr2]
        call strlen
        mov word [.n2], ax
        cmp ax, word [.n1]
        jne .false
        mov cx, ax
        mov si, word [.ptr1]
        mov di, word [.ptr2]
        repe cmpsb
        cmp cx, 0x00
        je .true
.false:
        mov ax, 0x01
        ret
.true:
        mov ax, 0x00
        ret
        .ptr1: dw 0x00
        .ptr2: dw 0x00
        .n1: dw 0x00
        .n2: dw 0x00
%endif