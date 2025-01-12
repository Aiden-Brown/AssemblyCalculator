section .data
    ; Will be uncommented once I can get the addition working correctly and printing to console. 

    msg1 db "What is the first number?", 0xa           ; Creates a string with the message "Hello, World!"
    len1 equ $ -msg1                                   ; Calculates the length of the string
                                                        ; The $ is a pointer and equ is an assignment operator
    msg2 db "What is the second number?", 0xa
    len2 equ $ -msg2

    msg3 db "Result: ", 0
    len3 equ $ -msg3

    minus db "-"
    lenminus equ $ -minus

    newline db 0xA

    num1 dd -2                           ; Creates an int with number 1
    num2 dd 3                           ; Creates an int with number 2
    tempnum dd 0                        ; used to temporarily store converted numbers
    
section .bss
    buffer resb 12
    res resb 12

section .text
global _start                           ; Tells the linker that the entry point is the start label
_start:                                 ; starts the program
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; file descriptor (stdout)
    mov ecx, msg1                       ; prints message asking for first number
    mov edx, len1                       ; message length used for printing
    int 0x80                            ; call kernel

    call readInput
    xor eax, eax                        ; Clear EAX (used for storing the result)
    mov ecx, 10                         ; Divisor for converting from ASCII
    mov edi, buffer + 12                ; Set EDI to point to the end of the buffer (or start of the converted value)

    call convert

    mov eax, [tempnum]
    mov [num1], eax                     ; mov puts the num1 variable in al register

    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; file descriptor (stdout)
    mov ecx, msg2                       ; prints message asking for second number
    mov edx, len2                       ; message length used for printing
    int 0x80                            ; call kernel

    call readInput
    xor eax, eax                        ; Clear EAX (used for storing the result)
    mov ecx, 10                          ; Divisor for converting from ASCII
    mov edi, buffer + 12                 ; Set EDI to point to the end of the buffer (or start of the converted value)

    call convert

    mov eax, [tempnum]
    mov [num2], eax

    call root

    ; Below is the mathy stuff while above is for user input
    ;add eax, [num1]                     ; mov puts the num1 variable in al register


    ;mov ecx, [num2]                     ; mov num2 into ebx. Needed for div and mul. 
                                        ; Addition and Subtraction does not need it but can if you wish

    ; At moment comment/uncomment whichever line you want to subtract, add, multiply or divide
    ;sub eax, [num2]                     ; sub makes the eax register subtract it's value with num2
    ;add eax, [num2]                     ; add makes the eax register add it's value with num2
    ;div eax                             ; div divides from the provided register down 
                                        ; (aka ecx = c->b->a or eax = a
    ;mul ebx                             ; mul multiplies the provided register down
                                        ; (aka ecx = c->b->a or eax = a
    mov [res], eax                      ; Stores the result of eax in res

    ;call powerCalc                      ; calls the powers calculation

    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; file descriptor (stdout)
    mov ecx, msg3                       ; prints out "Result: "
    mov edx, len3                       ; message length used for printing
    int 0x80                            ; call kernel

    mov eax, [res]                      ; Load the result into eax
    mov edi, buffer + 11                ; Point to the last position in the buffer
                                        ; kind of like in an array but you have to start at the end hence the + 11
    cmp eax, 0
    jl  printNeg                        ; prints negative numbers
    jge printNumber                     ; call printNumber function

    call end

end:
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; file descriptor (stdout)
    mov ecx, newline                    ; loads up empty line to create a new line after numbers
    mov edx, 1                          ; Length of the newline
    int 0x80                            ; Call kernel
                                        
    mov eax, 1                          ; System call for exit
    mov ebx, 0                          ; exit without error
    int 0x80                            ; call kernel
      
readInput:
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 12
    int 0x80
    mov byte [buffer + eax], 0

    ret
    
convert:
    xor edx, edx                        ; Clear remainder register (EDX will hold the remainder of the division)
    mov esi, buffer                     ; ESI points to the start of the buffer (input string)
    
convertLoop:
    movzx eax, byte [esi]               ; Load the next character from the input buffer into EAX
    test eax, eax                       ; tests if value is null then jumps to done
    jz doneConvert
    cmp eax, '0'                        ; tests if the value is less than 0, if so jump to done 
    jl doneConvert
    cmp eax, '9'                        ; tests if value is greater than 9, if so jump to done
    jg doneConvert
    
    sub eax, '0'                        ; Convert ASCII to integer (subtract ASCII value of '0')
    imul edx, edx, 10                   ; Multiply the current result by 10 (shift left one decimal place)
    add edx, eax                        ; Add the current digit to the result
    inc esi                             ; Move to the next character
    jmp convertLoop                    ; Loop for next digit

doneConvert:
    ; leaving this here just in case of some future expansion
    mov [tempnum], edx

    ret


printNeg:
    mov [res], eax
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; file descriptor (stdout)
    mov ecx, minus                      ; loads up empty line to create a new line after numbers
    mov edx, lenminus                   ; Length of the newline
    int 0x80                            ; Call kernel

    mov eax, [res]                      ; moves the result back to eax so it can be printed
    neg eax                             ; flips the negative number to it's positive counterpart
    call printNumber                    ; calls the print number function

    ret

printNumber:
    mov ecx, 10                         ; Divisor for base 10

    call printLoop

    ret

printLoop:
    xor edx, edx                        ; Clear remainder register
    div ecx                             ; EAX = EAX / 10, EDX = remainder
    add dl, '0'                         ; adds ASCII 0 (48) to value to convert number to ASCII
    dec edi                             ; Move buffer pointer backwards
    mov [edi], dl                       ; Store ASCII character
    test eax, eax                       ; Check if quotient is 0
    jnz printLoop                       ; Repeat if quotient is not 0

    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; file descriptor (stdout)
    mov ecx, edi                        ; address of buffer
    mov edx, buffer + 12                ; set buffer to edx
                                        ; + 12 is used to go right to the very end 
    sub edx, ecx                        ; calculate length of number (edi - buffer)
    int 0x80                            ; call kernel

    call end

powerCalc:
    add ebx, eax                        ; Adds eax value to ebx so it can be multiplied by itself
    sub ecx, 1                          ; subs 1 from the power so it runs the correct number of times
startPowerCalc:
    mul ebx                             ; does the multiplying
    sub ecx, 1                          ; subtracts 1 from power
    test ecx, ecx                       ; checks if the power is 0
    jnz startPowerCalc                  ; restart the multiplication process if there' still power

powerDone:
    mov [res], eax                      ; move the result so it can be safely accessed later
    ret

; This section is for roots. The below code had ChatGPT used to assist with understanding the root formula
; How to solve it and then how to program it. It will solve to the nearest whole number
; Below is the formla 
; x_n+1 = (1/n) * ((n-1) * x_n + a / (x_n^(n-1)))
; n = root value, a is the number we are trying to solve, x is the current approximation of the number

root:
    mov eax, [num1]                     ; Load the number we want to solve
    mov ebx, [num2]                     ; Load the root degree
    xor edx, edx                        ; Clear EDX for division
    div ebx                             ; starts off the iterative process
                                        ; e.g. x_0 = 27(num1)/3(num2) = 9(Starting point)
    mov ecx, eax                        ; Store the starting point in ECX

rootLoop:
    ; Step 1: Calculate x_n^(n-1)
    mov esi, ecx                        ; ESI = x_n (current guess)
    mov edi, ebx                        ; EDI = n (root degree)
    dec edi                             ; n-1
    mov eax, 1                          ; Start with 1 (for multiplication)

rootCalc:
    imul eax, esi                       ; eax = x_n
    dec edi                             ; decrement power counter
    jnz rootCalc                        ; repeat until n-1 multiplications done

    ; Step 2: Calculate a / x_n^(n-1)
    mov edx, 0                          ; Clear EDX for division
    mov ebx, eax                        ; EBX = x_n^(n-1)
    mov eax, [num1]                     ; Reload a into EAX
    div ebx                             ; EAX = a / x_n^(n-1)

    ; Step 3: Calculate (n-1) * x_n
    mov ebx, ecx                        ; EBX = x_n
    mov edi, [num2]                     ; EDI = n
    dec edi                             ; EDI = n-1
    imul ebx, edi                       ; EBX = (n-1) * x_n

    ; Step 4: Add (n-1)*x_n + a/x_n^(n-1)
    add eax, ebx                        ; EAX = (n-1)*x_n + a/x_n^(n-1)

    ; Step 5: Divide by n
    mov ebx, [num2]                     ; EBX = n
    xor edx, edx                        ; Clear EDX for division
    div ebx                             ; EAX = ((n-1)*x_n + a/x_n^(n-1)) / n

    ; Check for convergence
    cmp eax, ecx                        ; Compare new guess with previous guess
    je rootDone                         ; If stable, we're done
    mov ecx, eax                        ; Update guess for the next iteration
    jmp rootLoop                        ; Repeat the process

rootDone:
    mov [res], eax                      ; Store the result and return
    ret