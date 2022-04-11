;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BOOTLOADER CODE
; AUTHOR: PRANEET KAPOOR
; DATE: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SECTION .boot
;CPU 8086			; Use ONLY 8086 instructions
BITS 16
ORG 0x7c00			; Memory address where the first sector of
				; the disk is loaded

	jmp boot_main		; main code of bootloader resides here

%include "mbr_print.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BOOT_MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
boot_main: 
	mov bp, 0x8000		; initialise bottom of the stack and stack pointer
	mov sp, bp		; empty stack
	
	call clrscr		; clear screen
	call reset_curse	; reset cursor position
	call set_pg		; set page number
	
	mov si, BOOT_MSG1	; print booting up message
	call print
	call printnl

	mov dx, 0x02		; number of sectors to read
	call read_disk
	jmp 0x1000:0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CLEAR SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clrscr:
	mov ah, 0x07		; function code for scrolling down
	mov al, 0x00		; no. of lines to scroll, 0 for clrscr
	mov bh, 0x1f		; bf-gf = 1-f. blue bg, white fg
	mov ch, 0x00		; upper left row number
	mov cl, 0x00		; upper left column number
	mov dh, 24d		; lower right row number
	mov dl, 79d		; lower right column number
	int 0x10
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RESET CURSOR POSITION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
reset_curse:
	mov ah, 0x02		; function code for setting page number
	mov bh, 0x00		; page number
	mov dh, 0x00		; row number
	mov dl, 0x00		; column number
	int 0x10
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SET PAGE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_pg:
	mov ax, 0x0500		; function code for setting active display page
	int 0x10
 	ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; READ DISK, LOAD KERNEL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_disk:
	push dx			; save value of dx in the stack
	mov ah, 0x02		; read from the disk
	mov al, dl		; number of sectors to read
	mov ch, 0x00		; cylinder 0
	mov cl, 0x02		; sector 2, because sector 1 is MBR
	mov dh, 0x00		; head 0
	mov dl, [DRIVE_NUMBER]	; drive number
	mov bx, [KERNEL_BASE]	; Segment base address for kernel
	mov es, bx		; load seg. base addr. to es
	mov bx, [KERNEL_OFFSET]	; Kernel offset address
	int 0x13		; disk r/w using CHS addressing
	jc .disk_error		; if CF = 1, ERROR!!
	pop dx			; restore value of dl
	cmp al, dl		; cmp no. of sectors read to the value given
	jne .disk_error		; if not equal, show disk error
	jmp .no_error

.disk_error:			; print disk error code
	mov si, DISK_ERROR
	call print
	mov ah, 0x01		; status of disk after last operation
	int 0x13
	mov dx, 0x0000
	mov dl, al
	call printhex
	call printnl
	jmp $			; stop operation

.no_error:
	mov si, BOOT_MSG2
	call print
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VARIABLES AND CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	BOOT_MSG1 db "BOOTING ...", 0x00
	DISK_ERROR db "DISK ERROR: ", 0x00
	BOOT_MSG2 db "DISK READ SUCCESSFUL!! KERNEL LOADED!!", 0x00
	KERNEL_BASE dw 0x1000
	KERNEL_OFFSET dw 0x0000
	DRIVE_NUMBER db 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZERO PADDING AND MAGIC NUMBER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	times 510 - ($ - $$) db 0	
	dw 0xaa55		; magic number

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; END OF BOOTSECTOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
