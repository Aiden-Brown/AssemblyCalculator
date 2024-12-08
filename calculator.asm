section .data
    ; Will be uncommented once I can get the addition working correctly and printing to console. 

    ;msg1 db "What is the first number?", 0xa         ; Creates a string with the message "Hello, World!"
    ;len1 equ $ -msg1                             ; Calculates the length of the string
                                                ; The $ is a pointer and equ is an assignment operator
    ;msg2 db "What is the second number?", 0xa
    ;len2 equ $ -msg2

    msg3 db "Result: ", 0
    len3 equ $ -msg3

    newline db 0xA

    num1 dd 9                           ; Creates an int with number 1
    num2 dd 11                          ; Creates an int with number 2
    
section .bss
    buffer resb 12
    res resb 1

section .text
global _start                           ; Tells the linker that the entry point is the start label
_start:                                 ; starts the program
    mov eax, [num1]                     ; mov puts the num1 variable in al register

    ; At moment comment/uncomment whichever line you want to subtract or add
    sub eax, [num2]                     ; sub makes the eax register add it's value with num2
    ;add eax, [num2]                     ; add makes the eax register add it's value with num2
    mov [res], eax                      ; Stores the result of eax in res

    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; file descriptor (stdout)
    mov ecx, msg3                       ; prints out "Result: "
    mov edx, len3                       ; message length used for printing
    int 0x80                            ; call kernel

    mov eax, [res]                      ; Load the result into eax
    mov edi, buffer + 11                ; Point to the last position in the buffer
                                        ; kind of like in an array but you have to start at the end hence the + 11
    call printNumber                    ; call printNumber function

    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; file descriptor (stdout)
    mov ecx, edi                        ; address of buffer
    mov edx, buffer + 12                ; set buffer to edx
                                        ; + 12 is used to go right to the very end 
    sub edx, ecx                        ; calculate length of number (edi - buffer)
    int 0x80                            ; call kernel

    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; file descriptor (stdout)
    mov ecx, newline                    ; loads up empty line to create a new line after numbers
    mov edx, 1                          ; Length of the newline
    int 0x80                            ; Call kernel
                                        
    mov eax, 1                          ; System call for exit
    mov ebx, 0                          ; exit without error
    int 0x80                            ; call kernel
                                        
printNumber:
    mov ecx, 10                         ; Divisor for base 10
print_loop:
    xor edx, edx                        ; Clear remainder register
    div ecx                             ; EAX = EAX / 10, EDX = remainder
    add dl, '0'                         ; adds ASCII 0 (48) to value to convert number to ASCII
    dec edi                             ; Move buffer pointer backwards
    mov [edi], dl                       ; Store ASCII character
    test eax, eax                       ; Check if quotient is 0
    jnz print_loop                      ; Repeat if quotient is not 0

    ret                                 ; return to function