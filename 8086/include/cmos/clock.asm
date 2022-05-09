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
	mov al, byte [MIN]
	call print8bitpackedBCD
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
date:
	call weekday
	mov si, SUN
	sub ax, 0x01
	mov dh, 0x08
	mul dh
	add si, ax
	call printf
	
	call day
	call print8bitpackedBCD
	mov al, '-'
	call putchar

	call month
	call print8bitpackedBCD
	mov al, '-'
	call putchar

	call year
	call print8bitpackedBCD
	ret
	

weekday:
	cli
	mov al, 0x06		; access register 0x06 in CMOS for weekday
	out 0x70, al
	mov ax, 0x00
	mov cx, 100		; wait...
.1:
	loop .1		
	in al, 0x71
	sti
	ret
day:
	cli
	mov al, 0x07		; access register 0x07 in CMOS for seconds
	out 0x70, al
	mov ax, 0x00
	mov cx, 100		; wait...
.1:
	loop .1		
	in al, 0x71
	sti
	ret
month:
	cli
	mov al, 0x08		; access register 0x08 in CMOS for seconds
	out 0x70, al
	mov ax, 0x00
	mov cx, 100		; wait...
.1:
	loop .1		
	in al, 0x71
	sti
	ret
year:
	cli
	mov al, 0x09		; access register 0x09 in CMOS for seconds
	out 0x70, al
	mov ax, 0x00
	mov cx, 100		; wait...
.1:
	loop .1		
	in al, 0x71
	sti
	ret

	SUN: dw "SUN, ", 0x00
	MON: dw "MON, ", 0x00
	TUE: dw "TUE, ", 0x00
	WED: dw "WED, ", 0x00
	THU: dw "THU, ", 0x00
	FRI: dw "FRI, ", 0x00
	SAT: dw "SAT, ", 0x00