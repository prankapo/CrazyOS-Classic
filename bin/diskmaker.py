import os
import sys

def copypasta(ftarget, fsource, loc):
    global addr
    if (addr != loc):
        while (addr != loc):
            ftarget.write(b'\x00')
            addr += 0x01
    for line in fsource:
        for ch in line:
            ftarget.write(bytes([ch]))
            addr += 0x01
    print(addr, ftarget.tell())

os.chdir(os.path.dirname(sys.argv[0]))
ftarget = open("CrazyOS.bin", 'wb')
fboot = open("mbr.bin", 'rb')
fkernel_entry = open("kernel_entry.bin", 'rb')
fkernel = open("kernel.bin", 'rb')

addr = 0x00
copypasta(ftarget, fboot, 0x00)
copypasta(ftarget, fkernel_entry, addr)
copypasta(ftarget, fkernel, addr)
