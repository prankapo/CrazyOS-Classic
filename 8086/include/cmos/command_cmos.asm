%ifndef COMMAND_CMOS
%define COMMAND_CMOS
bits 16
align 16

%include "include/cmos/cmos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SHOWTIME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showtime:
	call time
	mov ax, 0x00
	mov al, byte [HRS]
	call print8bitpackedBCD
        mov al, ':'
        call putchar
	mov al, byte [MIN]
	call print8bitpackedBCD
        mov al, ':'
        call putchar
	mov al, byte [SEC]
	call print8bitpackedBCD
	mov al, 0x0a
	call putchar
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TIME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
time:	
	mov ax, 0x00
	mov al, 0x04
	call read_cmos
	mov byte [HRS], al
	mov al, 0x02
	call read_cmos
	mov byte [MIN], al
	mov al, 0x00
	call read_cmos
	mov byte [SEC], al
	ret

	HRS: db 0x00
	MIN: db 0x00
	SEC: db 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DATE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showdate:
        call date
        mov al, byte [WEEKDAY]
        lea si, [SUN]
        sub ax, 0x01
        mov dh, 0x08
        mul dh
        add si, ax
        call printf

        mov al, byte [DAY_OF_THE_MONTH]
        call print8bitpackedBCD
        mov al, '-'
        call putchar
        mov al, byte [MONTH]
        call print8bitpackedBCD
        mov al, '-'
        call putchar
        mov al, byte [YEAR]
        call print8bitpackedBCD
        mov al, 0x0a
        call putchar
	ret

date:
	mov al, 0x06		; access register 0x06 in CMOS for weekday
        call read_cmos
        mov byte [WEEKDAY], al
	mov al, 0x07		; access register 0x07 in CMOS for day of the month
	call read_cmos
        mov byte [DAY_OF_THE_MONTH], al
	mov al, 0x08		; access register 0x08 in CMOS for month
        call read_cmos
        mov byte [MONTH], al
	mov al, 0x09		; access register 0x09 in CMOS for year
	call read_cmos
        mov byte [YEAR], al
        ret

        WEEKDAY: db 0x00
        DAY_OF_THE_MONTH: db 0x00
        MONTH: db 0x00
        YEAR: db 0x00
	SUN: dw "SUN, ", 0x00
	MON: dw "MON, ", 0x00
	TUE: dw "TUE, ", 0x00
	WED: dw "WED, ", 0x00
	THU: dw "THU, ", 0x00
	FRI: dw "FRI, ", 0x00
	SAT: dw "SAT, ", 0x00
%endif