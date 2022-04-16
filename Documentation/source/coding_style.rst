Coding style
============

The coding style is pretty simple. 

1. Screen is 85 columns wide. 

2. Tabs are 8 spaces long. 

3. Comments are good, but don't clutter things too much. 

4. Before each subroutine/function, its purpose, or at least its title, should be given inside comment blocks. 

An example of this coding style is given below. It is a key snippet from ``boot.asm``: this chunk deals with reading sectors off from disk onto the memory location ``es:bx``. Sub-routine's purpose is clear from its title and important instruction are followed by very short comments **on the same line**.

.. code-block:: asm

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
                call printnl
                mov si, BOOT_MSG3
                call print
                mov dx, word [KERNEL_BASE]
                call printhex
                call printnl
                mov si, BOOT_MSG4
                call print
                mov dx, word [KERNEL_OFFSET]
                call printhex
                call printnl
                ret

Write code which is simple. It should be made up of simple little steps so that changing one thing is not a big headache. Not trying to be oversmart and doing some trick is of key importance here. The more tricks I or someone else will pull off, the harder it becomes to maintain the code later on.
