%ifndef EDIT
%define EDIT
edit_main:
        lea si, [arg1]
        mov al, ':'
        call cmd_lexer
        lea si, [com]
        call atoh
        mov word [.segment], ax
        lea si, [arg1]
        call atoh
        mov word [.offset_main], ax
        mov word [.offset], ax
.edit_loop:
        call getline
        lodsb
        cmp al, '*'
        jne .add_line

        mov al, ' '
        call cmd_lexer
        
        lea si, [com]
        lea di, [.edit_edit]
        call strcmp
        mov ax, 0x00
        je .edit

        lea di, [.edit_list]
        call strcmp
        mov ax, 0x00
        je .list

        lea di, [.edit_exit]
        call strcmp
        mov ax, 0x00
        je .return_point
.add_line:
        dec si
        push es
        mov es, word [.segment]
        mov di, word [.offset]
        mov cx, 80d
        cld
        rep movsb
        mov word [.offset], di
        pop es
        jmp .edit_loop
.edit:
        lea si, [arg1]
        call atoi
        dec ax
        mov dx, 0x00
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
        jmp .edit_loop
.list:
        mov cx, word [.offset]
        sub cx, word [.offset_main]
        push ds
        push si
        mov ax, word [.segment]
        mov ds, ax
        mov si, word [.offset_main]
.list_loop1:
        lodsb
        call putchar
        loop .list_loop1
        pop si
        pop ds
        jmp .edit_loop
.return_point:
        ret
        .segment: dw 0x00
        .offset_main: dw 0x00
        .offset: dw 0x00
        .linenum: dw 0x00
        .edit_edit: db "edit", 0x00
        .edit_list: db "list", 0x00
        .edit_exit: db "exit", 0x00

%include "include/ttyio/ttyio.asm"
%include "include/string/string.asm"
%include "include/string/lexer.asm"
%endif