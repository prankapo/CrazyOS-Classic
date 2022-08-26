%ifndef CMOS
%define CMOS
%define RTCaddress 0x70
%define RTCdata 0x71
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; READ_CMOS
; AL = index of the register to be accessed
; Upon return, AL contains the value returned from port 0x71
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_cmos:
        cli
        out RTCaddress, al
        nop
        in al, RTCdata
        sti
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WRITE_CMOS
; AL = index of the register to be accessed
; BL = value to be written to the register
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
write_cmos:
        cli
        out RTCaddress, al
        nop
        mov al, bl 
        out RTCdata, al
        sti
        ret
%endif