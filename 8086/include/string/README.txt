String related functions are included in the directory. These functions take in a pointer to the string, and return some value in the ax register

FUNCTION NAME: strlen
DESCRIPTION: Calculates the length of the string
INPUT: SI = effective address of the first byte of the string
OUTPUT: AX = length of the string in bytes

FUNCTION NAME: strcmp
DESCRIPTION: Compares two strings
INPUT: SI = Pointer to string 1
        DI = Pointer to string 2
OUTPUT: If AX = 0, then both the strings are equal
        Else if AX = 1, then the strings are not equal

FUNCTION NAME: atoi
DESCRIPTION: Converts an integer string to an integer
INPUT: SI = Pointer to string
OUTPUT: AX = integer
EXAMPLES: 
        lea si, [NUM]
        call atoi               ; will store the integer present in the string in AX
        call printdec
        call printnl
             ...
        NUM: db "1234", 0x00
NOTE: 1.) Integer strings with more than 5 digits are not supported. An error will 
          be thrown if more than 5 digits are there in the integer string.
      2.) Negative integers are not supported.

FUNCTION NAME: atoh
DESCRIPTION: Converts a string storing a hexadecimal number to a hexadecimal number
INPUT: SI = Pointer to string
OUTPUT: AX = Hexadecimal number
EXAMPLES: 
        lea si, [NUM]
        call atoh               ; will store the hex-integer in the string in AX
        call printhex
        call printnl
             ...
        NUM: db "1A3F", 0x00
NOTE: 1.) Although the refix "0x" is used when printing hexadecimal numbers, make 
          sure that the string being passed to atoh does not have this prefix.
      2.) Only use uppercase alphabetical hex-digits i.e., A-F, and not a-f.
      3.) Hexadecimal numeric strings with more than 4 digits will throw an error.
      4.) Negativee integers are not supported.
        