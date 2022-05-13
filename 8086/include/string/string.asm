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
        jne .false
        dec si
        dec di
        mov al, byte [si]
        cmp al, byte [di]
        je .true
.false:
        mov ax, 0x01
        jmp .return_point
.true:
        mov ax, 0x00
.return_point:
        mov si, word [.ptr1]
        mov di, word [.ptr2]
        ret
        .ptr1: dw 0x00
        .ptr2: dw 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ATOI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
atoi:
        push si
        call strlen
        cmp ax, 0x05
        jg .error_length_exceeded
        mov cx, 0x05
        sub cx, ax     
        mov bx, .t4
.starting_multiplier:
        add bx, 0x02
        loop .starting_multiplier
        mov cx, ax
.1:     
        lodsb
        sub al, '0'
        xor ah, ah
        xor dx, dx
        mul word [bx]
        add word [.sum], ax
        add bx, 0x02
        loop .1
        jmp .return_point

.error_length_exceeded:
        mov si, .ERR_LENGTH_EXCEEDED
        call printf
        jmp .return_point

.return_point:
        mov ax, word [.sum]
        mov word [.sum], 0x00
        pop si
        ret
        .t4: dw 10000
        .t3: dw 1000
        .t2: dw 100
        .t1: dw 10
        .t0: dw 1
        .sum: dw 0
        .ERR_LENGTH_EXCEEDED: dw "Error: More than 5 decimal digits not supported\n", 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ATOH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
atoh:
        push si
        call strlen
        cmp ax, 0x04
        jg .error_length_exceeded
        mov cx, 0x04
        sub cx, ax
        mov bx, .t3
.starting_multiplier:
        add bx, 0x02
        loop .starting_multiplier
        mov cx, ax
.1:
        lodsb
        cmp al, '9'
        jle .less_than_9
        cmp al, 'F'
        jle .less_than_F
        jmp .error_invalid_digit
.2:
        xor ah, ah
        xor dx, dx
        mul word [bx]
        add word [.sum], ax
        add bx, 0x02
        loop .1
        jmp .return_point
.less_than_9:
        sub al, '0'
        jmp .2
.less_than_F:
        sub al, 'A'
        add al, 0x0a
        jmp .2
.error_length_exceeded:
        mov si, .ERR_LENGTH_EXCEEDED
        call printf
        jmp .return_point
.error_invalid_digit:
        mov si, .ERR_INVALID_DIGIT
        call printf
        jmp .return_point
.return_point:
        mov ax, word [.sum]
        mov word [.sum], 0x00
        pop si
        ret
        .t3: dw 4096
        .t2: dw 256
        .t1: dw 16
        .t0: dw 1
        .sum: dw 0x00
        .ERR_LENGTH_EXCEEDED: dw "Error: More than 4 hex-digits not supported\n", 0x00
        .ERR_INVALID_DIGIT: dw "Error: Invalid hex-digit\n", 0x00
%endif