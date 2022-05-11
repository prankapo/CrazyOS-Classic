String related functions are included in the directory. These functions take in a pointer to the string, and return some value in the ax register

FUNCTION NAME: strlen
DESCRIPTION: Calculates the length of the string
INPUT: SI = effective address of the first byte of the string
OUTPUT: AX = length of the string in bytes

FUNCTION NAME: strcmp
DESCRIPTION: Compares two strings
INPUT: SI = Pointer to string number 1
        DI = Pointer to string number 2
OUTPUT: If AX = 0, then both the strings are equal
        Else if AX = 1, then the strings are not equal