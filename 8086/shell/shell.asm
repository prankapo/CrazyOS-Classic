%ifndef SHELL
%define SHELL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MAIN BODY OF THE SHELL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:
        call getline
        call lexer
        mov al, '>'
        call putchar
        mov si, com
        call print
        call printnl
        call flush                      ; flush the line
        jmp main

%include "include/ttyio/ttyio.asm"
%include "shell/lexer.asm"
%include "shell/cmdlist.asm"
%endif