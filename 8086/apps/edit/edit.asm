%ifndef EDIT
%define EDIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MAIN BODY OF THE EDITOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
edit_main:
        lea si, [arg1]
        mov al, ':'
        call cmd_lexer
        lea si, [com]
        call atoh
        mov word [edit_loop.segment], ax        ; value of segment
        lea si, [arg1]
        call atoh
        mov word [edit_loop.offset_main], ax    ; buffer's first byte's offset
        mov word [edit_loop.offset], ax         ; buffer's last byte's offset
        ; when opened, search for 0xaa in the file and set the offset accordingly
        mov cx, 0xffff
        push es
        mov ax, word [edit_loop.segment]
        mov es, ax
        mov di, word [edit_loop.offset_main]
        mov al, 0xaa
        repne scasb
        ; case 1: it has found the magic no. In that case the loop ends, and we store
        ;         the value in di - 1
        ; case 2: it didn't found the magic number and cx went zero. di will now 
        ;         point to 0x0000, we store this value as the offset
        cmp cx, 0x00
        je .overshoot
        jne .no_overshoot
.overshoot:
        mov di, word [edit_loop.offset_main]
        jmp .offset_fixed
.no_overshoot:
        dec di
        jmp .offset_fixed
.offset_fixed:
        mov word [edit_loop.offset], di
        pop es
        mov ax, word [edit_loop.segment]
        call printhex
        mov ax, word [edit_loop.offset_main]
        call printhex
        mov ax, word [edit_loop.offset]
        call printhex
        call printnl
        call edit_loop
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; EDITOR'S MAIN PROCESSING LOOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
edit_loop:
        call getline
        lodsb
        cmp al, '*'
        jne .add_line

        mov al, ' '
        call cmd_lexer
        
        lea si, [com]
        lea di, [.edit_edit]
        call strcmp
        cmp ax, 0x00
        je .edit

        lea di, [.edit_list]
        call strcmp
        cmp ax, 0x00
        je .list

        lea di, [.edit_exit]
        call strcmp
        cmp ax, 0x00
        je .return_point
.add_line:
        dec si
        push es
        mov es, word [.segment]
        mov di, word [.offset]
        mov cx, 80d
        cld
        rep movsb
        add word [.offset], 80d
        mov di, word [.offset]
        mov byte [es:di], 0xaa
        pop es
        jmp edit_loop
.edit:
        lea si, [arg1]
        call atoi
        dec ax
        xor dx, dx
        mov cx, 80d
        mul cx
        push ax
        mov al, '>'
        call putchar
        call getline
        pop di
        push es
        mov es, word [.segment]
        mov cx, 80d
        cld
        rep movsb
        pop es
        jmp edit_loop
.list:
        call clear
.list_param_fill:   
        mov cx, word [.offset]
        sub cx, word [.offset_main]
        push ds
        push si
        mov ax, word [.segment]
        mov ds, ax
        mov si, word [.offset_main]
        mov bx, 0x01
.list_loop1:
        mov al, byte [ds:si]
        cmp al, 0xaa
        je .list_loop_end
        call printf
        call printnl
        add si, 80d
        inc bx
        jmp .list_loop1
.list_loop_end:
        pop si
        pop ds
        jmp edit_loop
.return_point:
        mov ax, word [.segment]
        call printhex
        mov ax, word [.offset_main]
        call printhex
        call printnl
        mov ax, word [.offset]
        sub ax, word [.offset_main]
        inc ax
        xor dx, dx
        mov bx, 512d
        div bx
        inc ax
        lea si, [.number_of_sectors]
        mov cx, 0x01
        call fstringdata
        call printf
        ret
        .segment: dw 0x00
        .offset_main: dw 0x00
        .offset: dw 0x00
        .linenum: dw 0x00
        .edit_edit: db "edit", 0x00
        .edit_list: db "list", 0x00
        .edit_exit: db "exit", 0x00
        .number_of_sectors: dw "No. of sectors required to store text in this buffer = %d\n", 0x00, 0x00

%include "include/ttyio/ttyio.asm"
%include "include/string/string.asm"
%include "include/string/lexer.asm"
%endif