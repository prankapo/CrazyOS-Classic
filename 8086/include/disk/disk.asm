%ifndef DISK
%define DISK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GET DISK STATUS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disk_status:
        mov ah, 0x01
        int 0x13
        mov ah, al              ; disk status is returned in AL, move it to AH
        call print_disk_status
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINT DISK STATUS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_disk_status:
        cmp ah, 0x00            ; return value should be in AH
        je .00
        cmp ah, 0x01
        je .01
        cmp ah, 0x02
        je .02
        cmp ah, 0x03
        je .03
        cmp ah, 0x04
        je .04
        cmp ah, 0x05
        je .05
        cmp ah, 0x06
        je .06
        cmp ah, 0x07
        je .07
        cmp ah, 0x08
        je .08
        cmp ah, 0x09
        je .09
        cmp ah, 0x0a
        je .0a
        cmp ah, 0x0b
        je .0b
        cmp ah, 0x0c
        je .0c
        cmp ah, 0x0d
        je .0d
        cmp ah, 0x0e
        je .0e
        cmp ah, 0x0f
        je .0f
        cmp ah, 0x10
        je .10
        cmp ah, 0x11
        je .11
        cmp ah, 0x20
        je .20
        cmp ah, 0x40
        je .40
        cmp ah, 0x80
        je .80
        cmp ah, 0xaa
        je .aa
        cmp ah, 0xbb
        je .bb
        cmp ah, 0xcc
        je .cc
        cmp ah, 0xe0
        je .e0
        cmp ah, 0xff
        je .ff
.00:
        lea si, [.MSG_00]
        jmp .return_point
.01:
        lea si, [.MSG_01]
        jmp .return_point
.02:
        lea si, [.MSG_02]
        jmp .return_point
.03:
        lea si, [.MSG_03]
        jmp .return_point
.04:
        lea si, [.MSG_04]
        jmp .return_point
.05:
        lea si, [.MSG_05]
        jmp .return_point
.06:
        lea si, [.MSG_06]
        jmp .return_point
.07:
        lea si, [.MSG_07]
        jmp .return_point
.08:
        lea si, [.MSG_08]
        jmp .return_point
.09:
        lea si, [.MSG_09]
        jmp .return_point
.0a:
        lea si, [.MSG_0a]
        jmp .return_point
.0b:
        lea si, [.MSG_0b]
        jmp .return_point
.0c:
        lea si, [.MSG_0c]
        jmp .return_point
.0d:
        lea si, [.MSG_0d]
        jmp .return_point
.0e:
        lea si, [.MSG_0e]
        jmp .return_point
.0f:
        lea si, [.MSG_0f]
        jmp .return_point
.10:
        lea si, [.MSG_10]
        jmp .return_point
.11:
        lea si, [.MSG_11]
        jmp .return_point
.20:
        lea si, [.MSG_20]
        jmp .return_point
.40:
        lea si, [.MSG_40]
        jmp .return_point
.80:
        lea si, [.MSG_80]
        jmp .return_point
.aa:
        lea si, [.MSG_aa]
        jmp .return_point
.bb:
        lea si, [.MSG_bb]
        jmp .return_point
.cc:
        lea si, [.MSG_cc]
        jmp .return_point
.e0:
        lea si, [.MSG_e0]
        jmp .return_point
.ff:
        lea si, [.MSG_ff]
        jmp .return_point
.return_point:
        call printf
        ret
        .MSG_00: dw "Successful completion\n", 0x00
        .MSG_01: dw "Invalid function in AH or invalid parameter\n", 0x00
        .MSG_02: dw "Address mark not found or bad sector\n", 0x00
        .MSG_03: dw "Diskette write protected\n", 0x00
        .MSG_04: dw "Sector not found/read error\n", 0x00
        .MSG_05: dw "Reset failed (hard disk)\n", 0x00
        .MSG_06: dw "Diskette changed or removed (floppy)\n", 0x00
        .MSG_07: dw "Disk parameter activity failed (hard disk)\n", 0x00
        .MSG_08: dw "DMA overrun\n", 0x00
        .MSG_09: dw "Data boundary error: Attempted DMA access across 64K boundary or > 0x80 sectors\n", 0x00
        .MSG_0a: dw "Bad sector detected (hard disk)\n", 0x00
        .MSG_0b: dw "Bad track detected (hard disk)\n", 0x00
        .MSG_0c: dw "Unsupported track or invalid media\n", 0x00
        .MSG_0d: dw "Invalid number of sectors on format (PS/2 hard disk)\n", 0x00
        .MSG_0e: dw "Control data address mark detected (hard disk)\n", 0x00
        .MSG_0f: dw "DMA arbitration level out of range (hard disk)\n", 0x00
        .MSG_10: dw "Uncorrectable CRC or ECC error on read\n", 0x00
        .MSG_11: dw "Data ECC corrected (hard disk)\n", 0x00
        .MSG_20: dw "Controller failure\n", 0x00
        .MSG_40: dw "Seek failed\n", 0x00
        .MSG_80: dw "Timeout (not ready)\n", 0x00        
        .MSG_aa: dw "Drive not ready (hard disk)\n", 0x00
        .MSG_bb: dw "Undefined error (hard disk)\n", 0x00
        .MSG_cc: dw "Write fault (hard disk)\n", 0x00
        .MSG_e0: dw "Status register error (hard disk)\n", 0x00
        .MSG_ff: dw "Sense operation failed (hard disk)\n", 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; READ SECTORS FROM DISK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disk_read:
        mov ah, 0x02
        int 0x13
        jc disk_status
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WRITE SECTORS ON DISK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disk_write:
        mov ah, 0x03
        int 0x13
        jc disk_status
        ret
%endif