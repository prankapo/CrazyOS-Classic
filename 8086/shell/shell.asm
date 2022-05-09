%ifndef SHELL
%define SHELL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MAIN BODY OF THE SHELL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:
        call getline
        mov si, GETLINE_BUFFER
        ; do processing here
        mov byte [flag], 0x00
        mov cx, 0x00
        cld
lexer:
        cmp si, GETLINE_BUFFER_END
        je .exit
        cmp byte [si], 0x00
        je .exit
        lodsb
        cmp al, ' '
        jne .store
        mov byte [flag], 0x00
        jmp lexer
.store:
        cmp byte [flag], 0x00
        je .setflag
.store1:
        mov byte [di], al
        inc di
        jmp lexer
.setflag:
        inc byte [flag]
        push ax
        mov ax, 0x10
        mul cx
        mov di, com
        add di, ax
        inc cx
        pop ax
        jmp .store1
.exit:
        mov si, com
        call print
        call printnl
	
        mov al, 's'
        call putchar
        call printnl
        call flush                      ; flush the line
        jmp main

        flag: db 0x00 
        com: times 16 db 0x00
        arg1: times 16 db 0x00
        arg2: times 16 db 0x00
        arg3: times 16 db 0x00
        arg4: times 16 db 0x00


%include "include/ttyio/ttyio.asm"
%include "shell/cmdlist.asm"
%endif