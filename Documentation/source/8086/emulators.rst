Emulators
=========

Modern day computers use UEFI instead of BIOS. Some machine come with legacy boot options. Whatever the case is, it is better to run CrazyOS on a virtual machine, preferrably Qemu because that is what I am using. I also tried PCem but it didn't work. It is not able to execute both ``printhex`` sub-routines, and after some debugging I found out that the instructions which were causing problems were ``shr`` and ``ror``. Therefore, for testing CrazyOS, I would suggest that one should only use Qemu. Check Makefile in 8086 directory to see how ``qemu-system-i386`` is being used. 
