%ifndef SHELL
%define SHELL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MAIN BODY OF THE SHELL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:
        mov si, PROMPT
        call printf
        call getline
        mov al, ' '
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

        lea di, [cmd_power]
        call strcmp
        cmp ax, 0x00
        je .cmd_power

        lea di, [cmd_disk]
        call strcmp
        cmp ax, 0x00
        je .cmd_disk

        lea di, [cmd_run]
        call strcmp
        cmp ax, 0x00
        je .cmd_run

        lea di, [cmd_edit]
        call strcmp
        cmp ax, 0x00
        je .cmd_edit

        lea di, [cmd_srng]
        call strcmp
        cmp ax, 0x00
        je .cmd_srng
        
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
        call power_com
        jmp .return_point
.cmd_disk:
        lea si, [arg1]
        call disk_com
        jmp .return_point
.cmd_run:
        lea si, [arg1]
        mov al, ':'
        call cmd_lexer
        
        lea si, [com]
        call atoh
        push ax                 ; code segment
        lea si, [arg1]
        call atoh
        push ax                 ; offset
        mov bp, sp              ; sets up a new stack frame
        call far [bp]           ; far call
        add sp, 0x04            ; move sp up by 4 bytes
        mov ax, cs              ; reset cs, ds, es
        mov ds, ax
        mov es, ax
        jmp .return_point
.cmd_edit:
        call edit_main
        jmp .return_point
.cmd_srng:
        call srng
        call printdec
        call printnl
        jmp .return_point
.return_point:
        call flush                      ; flush the line
        jmp main
        PROMPT: dw "> ", 0x00
        ERR_MSG: dw "' has not been implemented\n", 0x00

%include "include/ttyio/ttyio.asm"
%include "include/string/string.asm"
%include "include/string/lexer.asm"
%include "apps/shell/cmdlist.asm"
%include "include/cmos/cmos_com.asm"
%include "include/apm/apm_com.asm"
%include "include/disk/disk_com.asm"
%include "include/random/srng.asm"
%include "apps/edit/edit.asm"
%endif