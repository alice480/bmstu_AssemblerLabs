%include "../lib64.asm"

section .data
    error db "the denominator is 0"
    len_error equ $-error
    mg_even db "even"
    len_even equ $-mg_even
    mg_odd db "odd"
    len_odd equ $-mg_odd
    
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
                        
            mov eax, [b]
            ; ZF = 0 --> odd  ZF = 1 --> even
            test eax, 1
            jnz odd                 ; ZF = 0
            jz even                 ; ZF = 1
            
            odd:
                mov rax, 1
                mov rdi, 1
                mov rsi, mg_odd
                mov rdx, len_odd
                syscall
                jmp continue
                
            even:
                mov rax, 1
                mov rdi, 1
                mov rsi, mg_even
                mov rdx, len_even
                syscall
                
            continue:
                mov eax, 60        ; system function 60 (exit)
                xor rdi, rdi       ; return code 0
                syscall