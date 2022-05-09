%ifndef CLOCK
%define CLOCK

%define RTCaddress 0x70
%define RTCdata 0x71
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SHOWTIME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showtime:
.1:	
	mov al, 0x0a
	out RTCaddress, al
	in al, RTCdata
	test al, 0x80		; if bit 7 is set, then an update is in progress
	je .1
	
	mov al, 0x04
	out RTCaddress, al
	in al, RTCdata
        call print8bitpackedBCD
        
        mov al, ':'
        call putchar
	
        mov al, 0x02
	out RTCaddress, al
	in al, RTCdata
        call print8bitpackedBCD
        
        mov al, ':'
        call putchar

        mov al, 0x00
        out RTCaddress, al
        in al, RTCdata
        call print8bitpackedBCD

        ret
%endif