%ifndef _SRNG_
%define _SRNG_

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; A SIMPLE RANDOM NUMBER GENERATOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
srng:
        xor dx, dx
        mov al, 0x00
        call read_cmos
        mul word [.a]
        add ax, word [.b]
        ret
        .a: dw 8999d
        .b: dw 9923d

%include "include/cmos/cmos.asm"
%endif