# CrazyOS - Classic: *An operating system made because it's fun*
Have you ever wondered how computers work?  
Have you ever wondered how assembly code really works?  
Have you ever wondered how your keystrokes are logged and execute certain programs?  
Have you ever wondered how functions presented in the standard C library, like printf(), getchar(), putchar(), strcmp(), etc., are implemented?  
Have you ever wondered how files are written and read from a disk?  
Have you ever wondered how an operating system is really implemented?  
If your answer to any of these questions (or similar ones) is "Yes" then you will probably love the project in this repository.  
This repository contains the source code for a toy operating system named CrazyOS. CrazyOS is a single-user, single-tasking, real-mode operating system written single-handedly by me (Praneet Kapoor, or as my friends call me, P.K.), in 8086 assembly language. I undertook this project as a means to understand how computers really work. And also to have fun. Eventually, I presented this project as my major project during the final year of my undergraduate study in Electrical and Electronics Engineering.  

# Introduction
Developing my own operating system is a project that I wanted to do as a kid. Now, with the half-cooked knowledge that I have, I made one. Too many people have already made clones of UNIX, so I did not do that. I just implemented some basic libraries and played with the tools I had.
  
I wrote the entire operating system in 8086 assembly language. Writing programs in assembly language is something which is frowned upon by the folks on the Internet. However, I personally find coding in assembly language to be an enrichning experience which helps in developing a better understanding of the hardware.  
  
Why 8086? Why not something simpler like 6502 or ARM? Well, I took a course in *Microprocessors and Microcontrollers* and I was not at all pleased by the way that course was taught. Do note that I wanted to learn assembly language and how processors worked for a very long time. But when I finally gott to take that course, it was taught by people who were never really excited about it, or aware about the tools they could use to give students a great learning experience. Everyone (except for me) used *Emu8086* which is just a toy emulator. It's developer claims that new devices can be added to the emulator, but that's not true. I tried it, but failed. Given I am a human who does make mistakes, I contacted the developer by mail, but he never replied. In the end most of the "labwork" was done using this stupid emulator. I do not think that anyone in my class ever got interested in learning about assembly language. The only way folks were able to pass examinations was by viewing Bharat Acharya's excellent course on the 8086 microprocessor. Though I had his excellent lectures at my disposal, I studied about the 8086 from Intel's 1979 *The 8086 Family User Manual*. Yes, I prefer books over lectures. Yes, I am big rebel :-)  
  
Necessity is the mother of all invention: I have now created a tool which others can use to learn about the architecture of the 8086 processor and the original IBM PC.  
  
Why this name: CrazyOS? Well, my choices clearly indicate that I am a crazy person.  Who uses BIOS calls to deal with the hardware? Nobody but me. Hence the name _Crazy_ OS.  

# Downloading the Project
To download the repository, simply click on `Code` button on the right side of the repository on GitHub and then click `Download ZIP`. But this is not enough, you need to install a few more programs to run this operating system. You need an assembler and an emulator. The assembler of choice for this project is NASM, and the emulator I have used is QEMU. Now, some of you might say on why didn't I use VMWare. Well, firstly VMWare is very heavy. And secondly, it doesn't supports traditional booting using IBM PC BIOS (or maybe I am too stupid to have it figured out). Anyways, these are the tools I have used and they are used by professional OS developers.  
**Note:** Linux kernel developers usually use GNU AS for assembling their assembly code. I didn't use it for the following reasons:
1. GNU AS partially supports 16-bit 8086 instructions. Say you write a simple instruction `mul cx`. This instruction will be converted into `f7 e1` by an assembler which supports 16-bit 8086 microprocessor completely. This is not the case with GNU AS: It supports real mode/virtual 8086 mode, which means that it is going to prefix this machine code so that it can run in real mode in 808386 and later processors. This prefixed machine code will not work on machines using 8086/8088 processors. During the early days of this project, I tried doing this: running code compiled for virtual 8086 mode on 8086 emulators on PCem. Never worked.  
2. GNU AS mainly supports AT&T syntax. Most books, including Intel's and AMD's users manual use Intel syntax. An instruction performing transfer of a double word to the register ecx will be written in Intel syntax as `mov ecx, 0xaa55`. In AT&T syntax this will be written as `movl $0xaa55, %ecx`. To prevent confusion, I have used NASM which uses a simpler variant of the Intel syntax.  
3. GNU AS dishes out an object file. You will need a linker script to arrange its text, data and bss sections properly and then the linker will dish out a binary file. I didn't want people who will be using my code to understand the processor to get confused about the object files and the way they are linked. So, I used NASM: you can include source codes using include guards and assemble the code with `-f bin` flag to generate flat binaries.  

## Downloading for Linux Users
I am just copy-pasting commands I used to install qemu from `.bash_history` file on my system. If something doesn't work, then internet is your best friend.  
```bash
sudo apt-get install nasm
sudo apt-get install qemu
sudo apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu qemu-kvm
```
## Downloading for Windows Users
Well, simply google *"Install MINGW"*, *"Install NASM"* and *"Install QEMU"* and you will be directed to the appropriate sites from where you can download these programs. Or you can download MSYS2 and then use its package manager to install the aforementioned tools. Or you can also use WSL2 or a docker image.

## Running the operating system
Once you have downloaded the required tools, go to the project directory in a terminal and type `make run`. This will run the operating sytsem. For more details, refer to [my report](Report/Report.pdf).


# Structure of the Project
If you have ever taken any course on operating systems or have looked at the block diagram of some popular operating systems kernels like Linux and Windows NT, you will easily be able to understand the structure of the project directory. It is very simple and intuitive once you get it. 
  
Everything starts with the bootloader (Well, one can say that everything starts with the BIOS, but then someone will say that everything starts with buying your computer. It's a never ending rabbit hole). The source code for the bootloader has been keep in the [`/boot`](boot/) folder.  
  
The bootloader loads the operating system from the floppy disk (using BIOS interrupts) into the main memory. It then pushes the segment address and offset of the `kernel_entry` subroutine in [`/kernel/kernel.asm`](kernel/kernel.asm) onto the stack. Then using `retf` (far return) instruction, it jumps to the `kernel_entry` subroutine. Here, various segment registers are set. Then a few test messages, including the current date and time, are printed on the screen.  
  
Various library functions which one can use in their own programs are kept in the [`/include`](include/) directory. I haven't implemented a single system call. I have heavily used BIOS calls to access the hardware. This makes stuff easy in two ways:  
1. Users of this operating system do not need to go through a separate manual listing these system calls. They can read the description of each BIOS interrupt from [Ralph Brown's interrupt list](https://www.ctyme.com/rbrown.htm).  
2. Reduced the time I had to spend in making this project :-). I had to make this project single-handedly. My teachers kept on prompting me about the deadlines. I had to cut corners to get it done in time.  
I highly recommend that you go through the [PDF version of my major project report](Report/Report.pdf) to get a better understanding of how the [`/include`](include/) directory is structured and what all library functions are included.  
  
At present this operating system comes with two "pre-installed apps", namely, the [shell](apps/shell/) and the [editor](apps/edit/). The functionality of the shell can be extended by adding the names of more commands in [`/apps/shell/cmdlist.asm`](apps/shell/cmdlist.asm) and including case for jumping to the newly added commands in [`/apps/shell/shell.asm`](apps/shell/shell.asm). To know more about the various commands you can use in the shell, read section 2.7.1 of the [report](Report/Report.pdf). As for the editor, it is a very greedy editor which fills memory with 80 bytes irrespective of whether the line contains any character or not. The explanation for the stupid design of this editor is simple: when the deadline for presenting a project is nearby, I curbed the urge to develop a perfect solution and just get things done.  
  
If you wish to make your own programs, use the library functions that I have provided, cook something up and put in the [`/disk-apps`](disk-apps/) directory. Do not forget to include a recipee for making the binary of your disk application in the [Makefile](Makefile) and "burning" it to the second disk using [mkdisk2.asm](mkdisk2.asm). At present, I have presented only a single app, [soundnlight.asm](disk-apps/soundnlight.asm) which reads the kernel byte by byte, and generates a corresponding colored pixel on the screen and a tone using the buzzer connected to the PIT chip on the motherboard.  
  
In the end, I highly recommend that you go through [my major project report](Report/Report.pdf) to gain a better understanding of this project.  

# You wanna say something?
Well, then send me a mail -> kapoorpraneet2619@gmail.com. Don't disturb those whose names have been mentioned in the report: they have got no clue regarding this project and you will be only wasting your time. Instead, if you have some query regarding this project, contact me.