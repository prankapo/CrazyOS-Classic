Description of Important Functions in ttyio
===========================================

A terminal emulator, or terminal for short, emulates old teletypewriters. It
takes in some input from keys and then gives out some output on the screen
(instead of a paper roll). 
To build a good terminal emulator we require some standard functions for i/o
processing, which can be used not only by the main body of the tty, but also
by other applications which might be running. That's why some standard 
functions are implemented here. They can be used in building a program by 
a) including ttyio.inc file 
b) linking the object file of the program with ttyio.o file during the 
linking process.

Here I have described a primitive "token of information exchange", these
functions are using.

The first and the only major point to be noted is that information is
exchanged through ax register i.e., it is the carrier pigeon. 
Say you wish to call a function in ttyio library. The argument for the same 
should be stored in the ax register before calling the function. 

EXAMPLE:
	mov ax, 0x1234		; store 0x1234 in ax 
	call printhex		; print the value in ax as a hex number

The value returned by a function is stored in ax.

EXAMPLE:
	call getchar		; getchar returns the keyboard scan code
				; and the ascii character recorded after
				; a keystroke

The diagram below will make all this a bit easier to understand:

	         caller:------->ax
		    ^		|
		    |		|
		    |		|
		    |		v
		    |	     function
		    |	        |
		    |		|
		    |		|
		    |		|
		    |		V
		    <----------ax

NOTE: Here output = return value of the function

FUNCTION NAME: clear
DESCRIPTION: Clears the screen
INPUT: Nothing
OUTPUT: Nothing

FUNCTION NAME: print
DESCRIPTION: Prints out the string pointed at by si
INPUT: si = address of first byte of a string
OUTPUT: Nothing

FUNCTION NAME: printnl
DESCRIPTION: Prints out a newline
INPUT: Nothing
OUTPUT: Nothing

FUNCTION NAME: printhex
DESCRIPTION: Prints out a hexadecimal number in 0x0000 format
INPUT: ax = Number to be printed
OUTPUT: Nothing

FUNCTION NAME: printdec
DESCRIPTION: Prints out the decimal number stored in ax register
INPUT: ax = Number to be printed
OUTPUT: Nothing

FUNCTION NAME: print8bitpackedBCD
DESCRIPTION: Prints out a packed BCD in AL register
INPUT: AH = 0x00, AL = Packed BCD number
OUTPUT: Nothing

FUNCTION NAME: printf
DESCRIPTION: Prints out a formatted string
INPUT: si = address of first byte of the string, string is made up of words
OUTPUT: Nothing

FUNCTION NAME: fstringdata
DESCRIPTION: Enters data next to a formatted string
INPUT: si = address of the string
	ax = data to be entered
	cx = position at which data is to be entered
OUTPUT: Nothing

FUNCTION NAME: putchar
DESCRIPTION: Prints out a readable ascii character
INPUT:	AL = ASCII character
OUTPUT: Nothing

FUNCTION NAME: getchar
DESCRIPTION: Reads keystroke
INPUT: Nothing
OUTPUT: AH = Keyboard scan code
	AL = ASCII Character

FUNCTION NAME: getline
DESCRIPTION: Reads a keystroke, operates on an 80 character buffer and displays it till Enter key/Newline is encountered.
INPUT: Nothing
OUTPUT: BUFFER = This 80 character array stores the characters you have filled it with getline
	BUFFER_END = Contains the address of the last 'cell' of BUFFER.

FUNCTION NAME = flush
DESCRIPTION = Flushes the buffer
INPUT: Nothing
OUTPUT: Nothing