%ifndef DISK_COMMANDS
%define DISK_COMMANDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DISK COMMAND PROCESSING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disk_com:
        lea di, [.help]
        call strcmp
        cmp ax, 0x00
        je ._help
        lea di, [.status]
        call strcmp
        cmp ax, 0x00
        je ._status
        lea di, [.read]
        call strcmp
        cmp ax, 0x00
        je ._read
        lea di, [.write]
        call strcmp
        cmp ax, 0x00
        je ._write
        jmp ._err
._help:
        lea si, [.help_msg]
        call printf
        jmp .return_point
._status:
        call disk_status
        jmp .return_point
._read:
        call disk_rw_parameter_fill
        call disk_read
        jmp .return_point
._write:
        call disk_rw_parameter_fill
        call disk_write
        jmp .return_point
._err:
        lea si, [.err_msg]
        call printf
        jmp .return_point
.return_point:
        mov ax, 0x1000
        mov es, ax
        ret
        
        .help: db "-h", 0x00
        .status: db "status", 0x00
        .read: db "read", 0x00
        .write: db "write", 0x00
        .help_msg: dw "Options:\n\t1. status: Display status of the last operation\n\t2. read: Read sectors of a disk (D:C:H:S ES:BX N)\n\t3. write: Write sectors of a disk (D:C:H:S ES:BX N)\n\tD = Drive no. (dec)\n\tC = Cylinder/track no. (dec)\n\tH = Head no. (dec)\n\tS = Sector no. (dec)\n\tES:BX = Pointer to Buffer (hex)\n\tN = No. of sectors to operate (dec)\n", 0x00
        .err_msg: dw "Invalid option.\nType 'disk -h' for help\n", 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DISK READ/WRITE PARAMETER FILLING SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disk_rw_parameter_fill:
        lea si, [arg2]
        lea di, [.arg2_copy]
        call strcpy
        lea si, [arg3]
        lea di, [.arg3_copy]
        call strcpy
        lea si, [arg4]
        lea di, [.arg4_copy]
        call strcpy

        lea si, [.arg2_copy]
        mov al, ':'
        call cmd_lexer
        lea si, [com]
        call atoi
        mov byte [drive_number], al
        lea si, [arg2]
        call atoi
        mov byte [head_number], al
        lea si, [arg1]
        call atoi
        mov byte [cylinder_number], al
        lea si, [arg3]
        call atoi
        mov byte [sector_number], al

        lea si, [.arg3_copy]
        mov al, ':'
        call cmd_lexer
        lea si, [com]
        call atoh
        mov word [es_val], ax
        lea si, [arg1]
        call atoh
        mov word [bx_val], ax

        lea si, [.arg4_copy]
        call atoi
        mov byte [number_of_sectors], al

        mov dl, byte [drive_number]
        mov ch, byte [cylinder_number]
        mov cl, byte [sector_number]
        mov dh, byte [head_number]
        mov ax, cx
        mov bx, word [bx_val]
        mov ax, word [es_val]
        mov es, ax
        mov al, byte [number_of_sectors]
        ret
        .arg2_copy: times 16 db 0x00
        .arg3_copy: times 16 db 0x00
        .arg4_copy: times 16 db 0x00
        drive_number: db 0x00
        cylinder_number: db 0x00
        head_number: db 0x00
        sector_number: db 0x00
        es_val: dw 0x00
        bx_val: dw 0x00
        number_of_sectors: db 0x00
%include "include/disk/disk.asm"
%endif