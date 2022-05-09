cpu 386
bits 16
align 16
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; KERNEL ENTRY POINT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MEMORY MAP
; 0x9A000:| BIOS related stuff |
;          --------------------
; 0x99fff:| Stack Base Pointer |
; 	  |	   ...	       |
;   ...   ~		       ~
;         |        ...         |
; 0x90000:| Stack Segment (SS) |
; 	   --------------------
; 	  |	   ...	       |
;   ...   ~		       ~
;         |        ...         |
; 0x20000:|        ...         |
; 0x10000:|    16-bit Kernel   |
; 	   --------------------
; 	  |	   ...	       |
;   ...   ~		       ~
; 0x7e00  |        ...         |
;	   --------------------
; 0x7cff: |        ...         |
; 0x7c00: | 16-bit Bootloader  |
;          --------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%define RTCaddress 0x70
%define RTCdata 0x71
kernel_entry:
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ax, 0x9000
	mov ss, ax
	mov bp, 0x9fff
	mov sp, bp

kernel_main:
	call clear
	mov si, TEST_MSG
	call printf
	call showtime
.while:
	call getline
	mov si, GETLINE_BUFFER
	call print
	call printnl
	call flush
	jmp .while

	TEST_MSG: dw "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz\n", 0x00

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
	mov al, 0x02
	out RTCaddress, al
	in al, RTCdata
	call print8bitpackedBCD
	ret

%include "include/ttyio/ttyio.asm"