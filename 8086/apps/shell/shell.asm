%ifndef SHELL
%define SHELL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MAIN BODY OF THE SHELL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:
        call getline
        call cmd_lexer
        
        lea si, [com]
        lea di, [cmd_time]
        call strcmp
        cmp ax, 0x00
        je .cmd_time
        
        lea si, [com]
        lea di, [cmd_date]
        call strcmp
        cmp ax, 0x00
        je .cmd_date

        lea si, [com]
        lea di, [cmd_clear]
        call strcmp
        cmp ax, 0x00
        je .cmd_clear

        lea si, [com]
        lea di, [cmd_load]
        call strcmp
        cmp ax, 0x00
        je .cmd_load
        jmp .return_point

.cmd_time:
        call showtime
        jmp .return_point
.cmd_date:
        call showdate
        jmp .return_point
.cmd_clear:
        ;call clear
        jmp .return_point
.cmd_load:
        mov ax, 'L'
        call putchar
        jmp .return_point

.return_point:
        call flush                      ; flush the line
        jmp main

        ERR_MSG: dw " has not been implemented\n", 0x00

%include "apps/shell/lexer.asm"
%include "apps/shell/cmdlist.asm"
%include "include/ttyio/ttyio.asm"
%include "include/string/string.asm"
%endif