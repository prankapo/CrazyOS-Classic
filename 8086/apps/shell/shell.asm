%ifndef SHELL
%define SHELL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MAIN BODY OF THE SHELL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:
        mov si, PROMPT
        call printf
        call getline
        call cmd_lexer
        
        lea si, [com]
        lea di, [cmd_time]
        call strcmp
        cmp ax, 0x00
        je .cmd_time
        
        lea di, [cmd_date]
        call strcmp
        cmp ax, 0x00
        je .cmd_date

        lea di, [cmd_clear]
        call strcmp
        cmp ax, 0x00
        je .cmd_clear

        lea di, [cmd_load]
        call strcmp
        cmp ax, 0x00
        je .cmd_load

        lea di, [cmd_power]
        call strcmp
        cmp ax, 0x00
        je .cmd_power
        
        mov al, 0x27            ; Executed when no match has been found
        call putchar
        lea si, [com]
        call printf
        lea si, [ERR_MSG]
        call printf
        jmp .return_point

.cmd_time:
        call showtime
        jmp .return_point
.cmd_date:
        call showdate
        jmp .return_point
.cmd_clear:
        call clear
        jmp .return_point
.cmd_load:
        mov ax, 'L'
        call putchar
        jmp .return_point
.cmd_power:
        lea si, [arg1]
        call apm_command
        jmp .return_point
.return_point:
        call flush                      ; flush the line
        jmp main

        PROMPT: dw "> ", 0x00
        ERR_MSG: dw "' has not been implemented\n", 0x00
%include "include/ttyio/ttyio.asm"
%include "include/string/string.asm"
%include "include/cmos/clock.asm"
%include "include/apm/command.asm"
%include "apps/shell/lexer.asm"
%include "apps/shell/cmdlist.asm"
%endif