%include "../lib64.asm"

section .data
    row db "Row № ", 0
    len_row equ $-row
    col db "Col № ", 0
    len_col equ $-col
    space db " ", 0
    len_space equ $-space

section .bss
    elems resd 1
    index resd 1
    col_number resd 1
    row_number resd 1
    result resd 1
    elem resd 1
    input resd 1
    len_input equ $-input
    output resd 1
    len_output equ $-output
    
section .text
    global _start
        _start:
            ;mov ebx, 0
            mov dword [col_number], 0
            mov dword [row_number], 1
            mov dword [result], 0
            mov dword [elems], 26
            mov dword [index], 4
            
            ; COUNT + 1
            ; LEN - 1
            matrix_loop:
                sub dword [elems], 1
                cmp dword [elems], 0
                je print_result
                ; row
                mov rax, 1
                mov rdi, 1
                mov rsi, row
                mov rdx, len_row
                syscall
                mov esi, output
                mov eax, [row_number]
                cwde
                call IntToStr64
                
                ; write number of row
                mov rax, 1
                mov rdi, 1
                mov rsi, output
                mov rdx, 2
                syscall
                
                ; write space
                mov rax, 1
                mov rdi, 1
                mov rsi, space
                mov rdx, len_space
                syscall
                
                ; column
                mov rax, 1
                mov rdi, 1
                mov rsi, col
                mov rdx, len_col
                syscall
                
                mov ebx, [col_number]
                add ebx, 1
                mov esi, output
                mov eax, ebx
                cwde
                call IntToStr64
                
                ; write number of column
                mov rax, 1
                mov rdi, 1
                mov rsi, output
                mov rdx, 2
                syscall
                
                ; write space
                mov rax, 1
                mov rdi, 1
                mov rsi, space
                mov rdx, len_space
                syscall
                
                ; read elem
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
                mov [elem], RAX
                mov ebx, [col_number]
                mov eax, [index]
                cmp ebx, eax
                
                ; column number < index
                jnl continue
                cmp dword [elem], 0 ; elem > 0
                jl continue
                mov ebx, [elem]
                ; result + elem
                add [result], ebx
                continue:
                    cmp dword [col_number], 4
                    ; LEN - 1
                    jl increasing
                    mov dword [col_number], 0
                    sub dword [index], 1
                    add dword [row_number], 1
                    jmp matrix_loop
                    
                increasing:
                    add dword [col_number], 1
                    jmp matrix_loop
                
                print_result:
                    mov esi, output
                    mov eax, [result]
                    cwde
                    call IntToStr64
                    ; write
                    mov rax, 1
                    mov rdi, 1
                    mov rsi, output
                    mov rdx, len_output
                    syscall
            exit:
                mov eax, 60
                xor rdi, rdi
                syscall