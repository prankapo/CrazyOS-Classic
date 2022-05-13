%ifndef APM
%define APM
APM_SERVICE_ROUTINE:
        mov ah, 0x53
        int 0x15
        jc .APM_ERROR 
        ret
.APM_ERROR:
        cmp ah, 0x01
        je .01
        cmp ah, 0x02
        je .02
        cmp ah, 0x03
        je .03
        cmp ah, 0x05
        je .05
        cmp ah, 0x06
        je .06
        cmp ah, 0x07
        je .07
        cmp ah, 0x08
        je .08
        cmp ah, 0x09
        je .09
        cmp ah, 0x0a
        je .0a
        cmp ah, 0x0b
        je .0b
        cmp ah, 0x0c
        je .0c
        cmp ah, 0x0d
        je .0d
        cmp ah, 0x60
        je .60
        cmp ah, 0x80
        je .80
        cmp ah, 0x86
        je .86
        ret
.01:
        lea si, [.err_01]
        jmp .return_point
.02: 
        lea si, [.err_02]
        jmp .return_point
.03:
        lea si, [.err_03]
        jmp .return_point
.05:
        lea si, [.err_05]
        jmp .return_point
.06:
        lea si, [.err_06]
        jmp .return_point
.07:
        lea si, [.err_07]
        jmp .return_point
.08:
        lea si, [.err_08]
        jmp .return_point
.09:
        lea si, [.err_09]
        jmp .return_point
.0a:
        lea si, [.err_0a]
        jmp .return_point
.0b:
        lea si, [.err_0b]
        jmp .return_point
.0c:
        lea si, [.err_0c]
        jmp .return_point
.0d:
        lea si, [.err_0d]
        jmp .return_point
.60:
        lea si, [.err_60]
        jmp .return_point
.80:
        lea si, [.err_80]
        jmp .return_point
.86:
        lea si, [.err_86]
        jmp .return_point
.return_point:
        call printf
        ret
        .err_01: dw "Power management functionality disabled\n", 0x00
        .err_02: dw "Real mode interface connection already established\n", 0x00
        .err_03: dw "Interface not connected\n", 0x00
        .err_05: dw "16-bit protected mode interface already established\n", 0x00
        .err_06: dw "16-bit protected mode interface not supported\n", 0x00
        .err_07: dw "32-bit protected mode interface already established\n", 0x00
        .err_08: dw "32-bit protected mode interface not supported\n", 0x00
        .err_09: dw "Unrecognized device ID\n", 0x00
        .err_0a: dw "Parameter value out of range\n", 0x00
        .err_0b: dw "Interface not engaged\n", 0x00
        .err_0c: dw "Function not supported\n", 0x00
        .err_0d: dw "Resume timer disabled\n", 0x00
        .err_60: dw "Unable to enter request state\n", 0x00
        .err_80: dw "No power management events pending\n", 0x00
        .err_86: dw "APM not present\n", 0x00

APM_REAL_MODE_ENABLE:
        xor al, al              ; Check whether APM is present or not
        xor bx, bx
        call APM_SERVICE_ROUTINE
        mov al, 0x04            ; Disconnect APM from every device
        xor bx, bx
        call APM_SERVICE_ROUTINE
        mov al, 0x01            ; Connect to the real mode interface
        xor bx, bx
        call APM_SERVICE_ROUTINE
        mov al, 0x08            ; Enable power management for all the devices
        mov bx, 0x01
        mov cx, 0x01
        call APM_SERVICE_ROUTINE
        ret
APM_POWER_OFF_ROUTINE:
        call APM_REAL_MODE_ENABLE
        mov al, 0x07            ; Set the power state to OFF
        mov bx , 0x01
        mov cx, 0x03
        call APM_SERVICE_ROUTINE
        ret

APM_POWER_LEVEL_ROUTINE:
        call APM_REAL_MODE_ENABLE
        mov al, 0x0a
        mov bx, 0x8001
        call APM_SERVICE_ROUTINE
        ret
%endif