Booting
=======

Booting Procedure
-----------------

The booting up procedure of the original IBM PC using 8088/86 has not changed till this date. For the purpose of this discussion, I will only consider original IBM PCs, like Amstrad PC 1512, which used 8088/86. 

When the PC is turned on, BIOS would read the first sector off from the first floppy drive (drive A:) and would consider it bootable if at the end of this sector was the magic number 0xaa55. Remember that each sector has 512 bytes. So this magic number needs to be at address 0x1fe (510). If this magic number was not there at the end of the very first sector, the disk was simply not considered to be bootable irrespective of the fact that it might be having your bootloader. BIOS would then read another disk (drive B: or C:) and check whether they were also bootable or not in a similar manner.

Once this magic number was found at the end of the first sector, BIOS would tag that drive as bootable. It would then load this sector at memory location 0x7c00. This first sector contained our bootloader whose purpose was to load kernel from a drive to memory and then handle the control to it. The kernel could be loaded at any location one likes, but at present, I am loading it at address 0x10000.

To read disk, display operations, etc., bootloader takes help of the interrupts set up by BIOS. The have been standardized for all IBM PCs for the sake of compatibility. These can be found `here <https://stanislavs.org/helppc/int_table.html>`_.

Controlling the display
-----------------------

To display something on the screen, we first blank it out by making use of ``int 0x10, 0x07``. This notation will be used again and again, so it would be better if I explain what it means.

Each interrupt as defined by BIOS targets some device (disk or display) and performs a number of functions. At any given time, we need to perform one function only. You wouldn't want to scroll-up and scroll-down the screen at the same time. To tell the ISR (interrupt service routine) the function we want it to perform, we load a number in register ``ah``. In the above example, we have loaded 0x07 into register ``ah``. When we raise ``int 0x10``, the ISR corresponding to this interrupt will jump to the code which would scroll the screen down. Had we loaded 0x06 into ``ah``, ISR for ``int 0x10`` would have performed scroll-up operation.

Okay, so we first blank out the screen, we can then set the position of cursor using ``int 0x10, 0x02``, and then we set up the page number. Though the system we are targetting is ancient, that doesn't mean it is not a technological marvel. Multiple "screens" or pages could be stored in memory. To display a particular page, you simply have to invoke ``int 0x10, 0x05``. Active page number is stored in ``al``.

To display an ASCII character, we use ``int 0x10, 0x0e``. It displays the ASCII character whose 8-bit hex code is stored in register ``al`` at the current position of the cursor and increment's cursor's position by one. When used recursively, we can use this to display a string.  The function in our bootloader used to display a string, and to print a newline, are ``print`` and ``printnl``. These are in *boot_util.asm*. Before using ``print``, the starting address of the string should be stored in ``si`` register. Also present in this source file is ``printhex`` which prints a 16-bit hexadecimal number present in ``dx``. I have used two different versions of ``printhex``. One is in the boot_util.asm, and the other one, as of commit ``16c185a``, is in *kernel.asm*. The former one is completely original and splits the higher and lower bytes into nibbles, stores in a template, operates on them and then prints them using ``print`` sub-routine. The latter one was taken from `here <https://github.com/PraneetKapoor2619/os-tutorial/blob/7aff64740e1e3fba9a64c30c5cead0f88514eb62/05-bootsector-functions-strings/boot_sect_print_hex.asm>`_.

Reading the disk
----------------

Disk is addressed using CHS (Cylinder-Head-Sector). To read sectors from the disk, we make use of ``int 0x13, 0x02``. Total of two sectors are read from drive 0 (bootable disk) starting from sector 2 (sector 1 is boot sector). The contents of these sectors are stored at memory location 0x1000:0x0000 which corresponds to 0x10000. If there were no errors, then a message is displayed which tells the user that the kernel has been loaded and the address at which it has been loaded. In case there has been an error during this operation, an error message is displayed and the system goes into an infinite loop.

Jumping to kernel
-----------------

Kernel has been loaded at 0x10000, which is a 20 bit value. Therefore, to jump to this command we make use of ``jmp 0x1000:0``.
