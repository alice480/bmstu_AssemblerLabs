%include "../lib64.asm"

section .data
    error db "the denominator is 0"
    len_error equ $-error
    
section .bss
    a resd 1
    b resd 1
    c resd 1
    y resd 1
    input resd 1
    len_input equ $-input
    output resd 1
    len_output equ $-output

section .text
    global _start
        _start:
        
            ; read a
            mov rax, 0          ; system function 0 (read)
            mov rdi, 0          ; file descriptor stdin=0
            mov rsi, input      ; input line address
            mov rdx, len_input  ; line length
            syscall
            
            ; str to int
            mov RSI, input
            call StrToInt64
            cmp RBX, 0
            jne StrToInt64.Error
            
            mov [a], RAX
            
            mov rsi, 0
            ; read b
            mov rax, 0
            mov rdi, 0
            mov rsi, input
            mov rdx, len_input
            syscall
            
            ; str to int
            mov RSI, input
            call StrToInt64
            cmp RBX, 0
            jne StrToInt64.Error
            
            mov [b], RAX
            
            ; read c
            mov rax, 0
            mov rdi, 0
            mov rsi, input
            mov rdx, len_input
            syscall
            
            ; str to int
            mov RSI, input
            call StrToInt64
            cmp RBX, 0
            jne StrToInt64.Error
            
            mov [c], RAX
            
            ; read y
            mov rax, 0
            mov rdi, 0
            mov rsi, input
            mov rdx, len_input
            syscall
            
            ; str to int
            mov RSI, input
            call StrToInt64
            cmp RBX, 0
            jne StrToInt64.Error
            
            mov [y], RAX
            
            mov eax, [a]
            mov ebx, [y]
            
            check:
                cmp eax, ebx
                jg continue
                jl continue
                
                ; error message
                mov rax, 1
                mov rdi, 1
                mov rsi, error
                mov rdx, len_error
                syscall
                
                ; exit
                mov eax, 60
                xor rdi, rdi
                syscall

            continue:
                ; calculating
                mov eax, [b]
                mul eax             ; b^2
                mov ebx, eax
                mov eax, [a]
                mov ecx, [y]
                sub ecx, eax        ; y - a
                sub eax, ebx        ; a - b^2
                cdq
                idiv ecx            ; (a - b^2) / (y - a)
                mov ebx, eax
                mov eax, [a]
                mul eax             ; a^2
                add ebx, eax        ; (a - b^2) / (y - a) + a^2
                mov eax, [c]
                sub ebx, eax        ; (a - b^2) / (y - a) + a^2 - c

                mov [a], ebx
                
                ; int to str
                mov esi, output
                mov ax, [a]
                cwde
                call IntToStr64
                
                ; write
                mov rax, 1         ; system function 1 (write)
                mov rdi, 1         ; file descriptor stdout=1
                mov rsi, output    ; output line address
                mov rdx, len_output ; line length
                syscall
                
            
                mov eax, 60        ; system function 60 (exit)
                xor rdi, rdi       ; return code 0
                syscall