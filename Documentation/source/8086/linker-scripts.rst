Linker Scripts
==============

Linker scripts provide a flexible way to arrange sections in our programs and resolve the addresses of the symbols used in the programs. 

As of now, two linker scripts are being used, namely *boot.ld* and *linker.ld*. 

The task of *boot.ld* is to relocate and resolve the addresses of symbols by adding 0x7c00 to their offset addresses. This is because bootloader is loaded by the BIOS at address 0x7c00. We could have used ``org 0x7c00`` directive in boot.asm, however, we didn't because this gave us an opportunity to use our knowledge of linker scripts. The contents of boot.ld are given below:

.. code-block:: asm 

        SECTIONS
        {
        	. = 0x7c00;
	        .text : { boot.o(.text) }
        }

*linker.ld* is used for the similar task: resolution of symbol address. Here, the location counter in the script is set to 0x0000. This is because the kernel has been loaded at address 0x10000, which has an offset of 0x0000. Addresses of all the symbols should be computed relative to this. If the kernel was loaded at address 0x10001, then the location counter would have been set to 0x0001. The contents of linker.ld are given below:

.. code-block:: asm
        
        SECTIONS
        {
                . = 0x0000;
                .text : {
                        *(.text) 
                        }
                .data : { *(.data) }
                .bss  : { *(.bss)  }
        }
