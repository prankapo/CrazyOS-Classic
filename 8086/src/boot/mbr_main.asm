;BOOTLOADER CODE
section .boot
[bits 16]			; Use 16-bit instructions
[org 0x7c00]			; Memory address where the first sector of
				; the disk is loaded

	jmp boot_main		; main code of bootloader resides here

%include "mbr_print.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BOOT_MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
boot_main: 
	mov bp, 0x8000		; initialise bottom of the stack and stack pointer
	mov sp, bp
				; blank out the screen by scrolling down
	mov ah, 0x07
	mov al, 0x00
	mov bh, 0x1f
	mov ch, 0x00
	mov cl, 0x00
	mov dh, 24d
	mov dl, 79d
	int 0x10

				; set cursor position
	mov ah, 0x02
	mov bh, 0x00
	mov dh, 0x00
	mov dl, 0x00
	int 0x10

				; select page number 0
	mov ax, 0x0500
	int 0x10

				; print booting up msg 
	mov si, BOOT_MSG1
	call print
	call printnl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; READ DISK, LOAD KERNEL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_disk:			; load sectors from disk 0
	mov ah, 0x02		; read from the disk
	mov al, 0x02		; number of sectors to read
	mov ch, 0x00		; cylinder 0
	mov cl, 0x02		; sector 2, because sector 1 is MBR
	mov dh, 0x00		; head 0
	mov dl, [DRIVE_NUMBER]	; drive number
	mov bx, [KERNEL_OFFSET]	; Offset in memory at which kernel is to be 
				; loaded
	int 0x13		; disk r/w using CHS addressing
	jc .disk_error		; if CF = 1, ERROR!!
	jmp .no_error

.disk_error:			; print disk error code
	mov si, DISK_ERROR
	call print
	;mov ah, 0x01		; status of disk after last operation
	;int 0x13
	;mov dx, 0x0000
	;mov dl, al
	;call printhex
	;call printnl
	;jmp $			; stop operation

.no_error:
	mov si, BOOT_MSG2
	call print
	mov dx, [KERNEL_OFFSET]
	call printhex
	call printnl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VARIABLES AND CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	BOOT_MSG1 db "BOOTING ...", 0x00
	DISK_ERROR db "DISK ERROR: ", 0x00
	BOOT_MSG2 db "DISK READ SUCCESSFUL!! KERNEL LOADED AT ", 0x00
	BOOT_MSG3 db "RETURNED TO BOOTLOADER", 0x00
	KERNEL_OFFSET dw 0x1000
	DRIVE_NUMBER db 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZERO PADDING AND MAGIC NUMBER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	times 510 - ($ - $$) db 0	
	dw 0xaa55		; magic number

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; END OF BOOTSECTOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
