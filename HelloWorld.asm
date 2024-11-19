section .text
global _start                    ; Tells the linker that the entry point is the start label
_start:                          ; starts the program
    mov edx, len                ; mov puts the len variable in edx register
    mov ecx, msg               ; mov puts msg variable in ecx register

    mov ebx, 1                  ; Set File descriptor

    mov eax, 4                  ; syscall number for sys_write
    int 0x80                    ; Call kernel

    mov eax, 1                  ; System call for exit
    int 0x80                    ; call kernel
        

section .data
    msg db "Hello, World!"      ; Creates a string with the message "Hello, World!"
    len equ $ -msg              ; Calculates the length of the string
                                ; The $ is a pointer and equ is an assignment operator