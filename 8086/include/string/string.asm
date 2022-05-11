%ifndef STRING
%define STRING

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STRLEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen:
        mov di, si
        xor ax, ax
        xor cx, cx              ; THIS!!! You have to set cx = 0xffff so that you 
        dec cx                  ; can REPNE without any glitch
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
        call strlen
        mov bx, ax
        mov si, word [.ptr2]
        call strlen
        cmp bx, ax
        jne .false
        mov si, word [.ptr1]
        mov di, word [.ptr2]
        mov cx, bx
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
%endif