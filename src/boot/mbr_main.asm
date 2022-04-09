;BOOTLOADER CODE

[bits 16]			; Use 16-bit instructions
[org 0x7c00]			; Memory address where the first sector of
				; the disk is loaded

	jmp boot_main		; main code of bootloader resides here

%include "mbr_print.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GLOBAL DESCRIPTOR TABLE
; inspired from "dev.to/frosnerd/writing-my-own-boot-loader-3mld"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gdt_start:
	dq 0x00			; null segment descriptor
				; if we try to load null segment,
				; general protection exception occurs.

gdt_code:			; code segment descriptor
	dw 0xffff		; segment limit set to max [15:0]
	dw 0x0000		; base address = 0x0000 [15:0]

	db 0x00			; base address [23:16]
	db 10011010b		; [P|DPL|1|TYPE]
	db 11011111b		; [BASE[31:24]|G|D|0|AVL|LIM[19:16]]
	db 0x00			; base address [31:24]

gdt_data:			; data segment descriptor
	dw 0xffff		; segment limit set to max [15:0]
	dw 0x0000		; base address = 0x0000 [15:0]

	db 0x00			; base address [23:16]
	db 10010010b		; [P|DPL|1|TYPE]
	db 11011111b		; [BASE[31:24]|G|D|0|AVL|LIM[19:16]]
	db 0x00			; base address [31:24]

gdt_end:

				; GDT Descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

	CODE_SEG equ gdt_code - gdt_start
	DATA_SEG equ gdt_data - gdt_start

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
	mov dx, [KERNEL_OFFSET]
	call printhex
	call printnl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SWITCH TO 32-BIT PROTECTED MODE
; copied from "dev.to/frosnerd/writing-my-own-boot-loader-3mld"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
switch_32:
	cli			; disable interrupts
	lgdt [gdt_descriptor]	; load GDT address into GDTR register
	mov eax, cr0
	or eax, 0x01		; enable protected mode
	mov cr0, eax
	jmp CODE_SEG:init_32bit	; far jump to code segment flushes the CPU queue of
				; any 16 bit instructions

[bits 32]
init_32bit:
	mov ax, DATA_SEG	; update segment registers
	mov ds, ax		; load ds with the segment address
	mov ss, ax		; load ss with stack address
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000	; setup a new stack frame
	mov esp, ebp
	call KERNEL_OFFSET
	mov si, BOOT_MSG3
	call print
	call printnl
	jmp $

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VARIABLES AND CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	BOOT_MSG1 db "BOOTING ...", 0x00
	DISK_ERROR db "DISK ERROR: ", 0x00
	BOOT_MSG2 db "DISK READ SUCCESSFUL!! KERNEL LOADED AT ", 0x00
	BOOT_MSG3 db "RETURNED TO BOOTLOADER", 0x00
	KERNEL_OFFSET equ 0x1000
	DRIVE_NUMBER db 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZERO PADDING AND MAGIC NUMBER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	times 510 - ($ - $$) db 0	
	dw 0xaa55		; magic number

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; END OF BOOTSECTOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
