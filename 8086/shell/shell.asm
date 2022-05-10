%ifndef SHELL
%define SHELL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MAIN BODY OF THE SHELL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:
        call getline
        mov si, GETLINE_BUFFER
        ; do processing here
        call lexer
        call flush                      ; flush the line
        jmp main




lexer:
        mov byte [flag], 0x00
        mov cx, 80d
        mov di, com
.comargflush:
        mov al, 'X'
        call putchar
        mov byte [di], 0x00
        inc di
        loop .comargflush
        mov si, GETLINE_BUFFER
        mov di, com
        mov cx, 80
        mov dx, 0x00
.storewords:
        mov al, byte [si]
        push ax
        call putchar
        pop ax
        inc si
        cmp al, 0x00
        je .lexit
        cmp al, ' '
        je .clearflag
        cmp byte [flag], 0x00
        je .setflag
        jne .store
.clearflag:
        mov byte [flag], 0x00
        loop .storewords
.setflag:
        inc byte [flag]
        push ax
        mov ax, 16
        mul dl
        add di, ax
        inc dx
        pop ax
.store:
        mov byte [di], al
        inc di
        loop .storewords
.lexit:
        mov si, com
        call print
        call printnl
        ret
        flag: db 0x00 
        com: times 16 db 0x00
        arg1: times 16 db 0x00
        arg2: times 16 db 0x00
        arg3: times 16 db 0x00
        arg4: times 16 db 0x00


%include "include/ttyio/ttyio.asm"
%include "shell/cmdlist.asm"
%endif