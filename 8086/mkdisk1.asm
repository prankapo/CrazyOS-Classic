incbin "build/boot.bin"
incbin "build/kernel.bin"

        times 1474560 - ($ - $$) db 0x00