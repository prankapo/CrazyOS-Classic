cmd_lexer:
        mov cx, 80d
        lea di, [.COPY]
.copy:
        movsb
        loop .copy
        mov cx, 80d
        lea di, [com]
        mov al, 0x00
.flushargs:
        stosb
        loop .flushargs
        lea si, [.COPY]
        mov byte [.flag], 0x00
        mov cx, 80d
        mov bx, 0x00
.storewords:
        lodsb
        cmp al, 0x00
        je .lexit
        cmp al, ' '
        je .clearflag
        cmp byte [.flag], 0x00
        je .setflag
        jne .store
.clearflag:
        mov byte [.flag], 0x00
        loop .storewords
.setflag:
        inc byte [.flag]
        lea di, [com]
        add di, bx
        add bx, 16d
.store:
        stosb
        loop .storewords
.lexit:
        ret

        .flag: db 0x00
        .COPY: times 80 db 0x00
        com: times 16 db 0x00
        arg1: times 16 db 0x00
        arg2: times 16 db 0x00
        arg3: times 16 db 0x00
        arg4: times 16 db 0x00