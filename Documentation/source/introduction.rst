Introduction
============ 

This is an introduction to CrazyOS project. Read through it carefully to understand what it is all about and how you can try it yourself.

What is CrazyOS?
----------------

CrazyOS is a family of open source operating systems targetting x86, ARM, and RISC-V architectures. This operating system is being developed indigenously with simplicity in mind. Only the most fundamental system calls of the Unix operating system has been implemented and several radical design choices of key elements has been made which makes this family of OS a *weak hybrid clone* of the Unix operating system. This makes it different from *strong clones* of Unix operating system like GNU/Linux, MINIX and descendants of BSD. 

Motivation
----------

The main impetus behind developing CrazyOS was to gain a better understanding of the x86 processor family and to share it with others for education purposes. 

In the 20th century, programmer's efforts were directed towards designing languages and systems in which ideas could be easily implemented in comparison to assembly language without effecting the speed of execution of the resulting binary on a given machine. C and Unix were results of such efforts. C, which compiles directly to assembly language, has often been called "human-readable assembly language". Unix (and its descendants) was liked by developers because it provided them with a platform and tools to do development without worrying about the complexity of the machine.  

Also during this time period, many kids got introduced to programming through home computers like Commodore VIC-20 and Apple II. They educated themselves by programming on these machines in either assembly language or BASIC, and often referred to magazines which came with source code of interesting homebrew programs. 

In 21st century, the cost of computers decreased and Internet expanded. With the introduction of high level languages like Python and Java, and various frameworks, more and more software developers are inclined to pursue a career in web development. While the development of web applications is certainly interesting, current and future generations of programmers should be having some experience in bare-metal programming as this will only help them develop their skills. This calls for a need to share the fun of bare-metal programming and designing operating systems. 

Critics will say that such knowledge will never help or be used by a person in his/her career, however, the author(s) of this project would like to differ because of the following two reasons:

1. Writing bare-metal programs increases one's understanding of how the machine works. It will also give a programmer the valuable skill of breaking a problem into simple steps and then implementing as opposed to "developing on the go" which results in copy-pasted codes from online sources.

2. It is fun to program at the lowest level provided one is patient and perseverant. 

It is precisely for these reasons that CrazyOS has been developed. It is not trying to be a grand powerful operating system, but a simple system which the user can tinker with understand how the machine will work under its hood.

Applications
------------

The author(s) do not expect this project to become something as big as Linux. It is merely a project which one of the author's (Praneet Kapoor) wanted to do for the longest time.

Besides this satisfaction of personal curiosity, it is believed that this project can be used in the education sector to share with kids the joy of programming in assembly language. They will be free to tinker with it and will break the system often. It would be like a dirt bike for kids [quote stolen form T. Davis]: if they lean too much they will fall, but it will be a learning experience for them.

Furthermore, this project can be used as a springboard for developing a real time system for some embedded processor, or for a single user OS. If properly developed, it would be interesting to use because a simple single user (or embedded system) doesn't require as many "gears" which modern operating systems seems to provide [quote stolen from T. Davis].


