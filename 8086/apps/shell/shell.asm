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
        je .true
        lea si, [NC]
        call printf
.1:
        call flush                      ; flush the line
        jmp main

.true:
        lea si, [C]
        call printf
        jmp .1
        NC: dw "NOT SAME!!\n", 0x00
        C: dw "SAME!!\n", 0x00
%include "apps/shell/lexer.asm"
%include "include/ttyio/ttyio.asm"
%include "apps/shell/cmdlist.asm"
%include "include/string/string.asm"
%endif