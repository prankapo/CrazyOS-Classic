%ifndef SHELL
%define SHELL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MAIN BODY OF THE SHELL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:
        call getline
        call cmd_lexer
        lea si, [com]
        call printf
        call printnl
        lea si, [arg1]
        call printf
        call printnl
        lea si, [arg2]
        call printf
        call printnl
        lea si, [arg3]
        call printf
        call printnl
        lea si, [arg4]
        call printf
        call printnl
        call flush                      ; flush the line
        jmp main

%include "shell/lexer.asm"
%include "include/ttyio/ttyio.asm"
%include "shell/cmdlist.asm"
%endif