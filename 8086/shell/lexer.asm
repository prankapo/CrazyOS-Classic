%ifndef LEXER
%define LEXER

lexer:
        mov byte [flag], 0x00
        mov cx, 80d
        mov di, com
.comargflush:
        mov byte [di], 0x00
        inc di
        loop .comargflush

        mov si, GETLINE_BUFFER
        mov di, com
        mov cx, 80d
        mov dh, 0xff
.storewords:
        lodsb
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
        jmp .lexit
.setflag:
        inc byte [flag]
        inc dh
        cmp dh, 0x00
        je .point_com
        cmp dh, 0x01
        je .point_arg1
        cmp dh, 0x02
        je .point_arg2
        cmp dh, 0x03
        je .point_arg3
        cmp dh, 0x04
        je .point_arg4
.point_com:
        mov di, com
        jmp .store
.point_arg1:
        mov di, arg1
        jmp .store
.point_arg2:
        mov di, arg2
        jmp .store
.point_arg3:
        mov di, arg3
        jmp .store
.point_arg4:
        mov di, arg4
        jmp .store
.store:
        stosb
        loop .storewords
.lexit:
        ret
        flag: db 0x00 
        com: times 16 db 0x00
        arg1: times 16 db 0x00
        arg2: times 16 db 0x00
        arg3: times 16 db 0x00
        arg4: times 16 db 0x00

%endif