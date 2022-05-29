%ifndef APM_COMMANDS
%define APM_COMMANDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; POWER COMMAND PROCESSING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
power_com:
        lea di, [.power_help]
        call strcmp
        cmp ax, 0x00
        je ._help
        lea di, [.power_off]
        call strcmp
        cmp ax, 0x00
        je ._power_off
        lea di, [.power_level]
        call strcmp
        cmp ax, 0x00
        je ._power_level
        jmp ._err
._help:
        lea si, [.help_msg]
        call printf
        jmp .return_point
._power_off:
        call APM_POWER_OFF_ROUTINE
        jmp .return_point
._power_level:
        call APM_POWER_LEVEL_ROUTINE
        cmp cl, 0xff
        je ._power_level_unknown
        mov ah, 0x00
        mov al, cl
        call printdec
        mov al, '%'
        call putchar
        cmp bl, 0x03
        je ._charging
        lea si, [.msg_not_charging]
        call printf
        jmp .return_point
._power_level_unknown:
        lea si, [.msg_power_level_unknown]
        call printf
        jmp .return_point
._charging:
        lea si, [.msg_charging]
        call printf
        jmp .return_point
._err:
        lea si, [.err_msg]
        call printf
        jmp .return_point
.return_point:
        ret
        
        .power_off: db "off", 0x00
        .power_level: db "level", 0x00
        .power_help: db "-h", 0x00
        .help_msg: dw "Options:\n\t1. off: Shutdown the system\n\t2. level: Display the current power status of the system\n", 0x00
        .err_msg: dw "Invalid option\nType 'power -h' for help\n", 0x00
        .msg_charging: dw " Charging\n", 0x00
        .msg_not_charging: dw " Not charging\n", 0x00
        .msg_power_level_unknown: dw "Power level unknown\n", 0x00

%include "include/apm/apm.asm"
%include "include/string/string.asm"
%endif