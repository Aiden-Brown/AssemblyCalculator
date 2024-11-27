section .data
    ; Will be uncommented once I can get the addition working correctly and printing to console. 

    ;msg1 db "What is the first number?", 0xa         ; Creates a string with the message "Hello, World!"
    ;len1 equ $ -msg1                             ; Calculates the length of the string
                                                ; The $ is a pointer and equ is an assignment operator
    ;msg2 db "What is the second number?", 0xa
    ;len2 equ $ -msg2

    num1 dd 1                   ; Creates an int with number 1
    num2 dd 2                   ; Creates an int with number 2
    res dd 0

section .text
global _start                           ; Tells the linker that the entry point is the start label
_start:                                 ; starts the program
    mov al, [num1]                      ; mov puts the num1 variable in al register
    mov bl, [num2]                      ; add num2 to the al register
    add al, bl                          ; add makes the al register store the result with res
    mov [res], al                       ; Stores the result of num1 and num2 in res
    mov cl, [res]                       ; adds the value of res to cl register
    
    ;mov al, 0x30                       ; Should translate it into ascii to be printed
                                        ; but doesn't reverts it back to 0
    
    mov ebx, 1                          ; Set File descriptor

    mov eax, 4                          ; syscall number for sys_write
    int 0x80                            ; Call kernel

    mov eax, 1                          ; System call for exit
    int 0x80                            ; call kernel