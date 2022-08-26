%ifndef SOUND
%define SOUND
%define CONTROL_WORD 0x43
%define TIMER_2 0x42

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SOUND TINY : For generating sounds for small duration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sound_tiny:
        mov cx, bx
        push ax
        mov al, 10110110b
        out CONTROL_WORD, al

        pop ax
        out TIMER_2, al
        shr ax, 0x08
        out TIMER_2, al

        in al, 0x61
        or al, 00000011b
        out 0x61, al
.1:
        loop .1
        in al, 0x61
        and al, 11111100b
        out 0x61, al
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SOUND MEGA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sound_mega:
.1:
        call sound_tiny
        dec dx
        cmp dx, 0x00
        jne .1
        ret
%endif