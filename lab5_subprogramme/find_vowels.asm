%include "../lib64.asm"

section .data
    space db " ", 10
    len_space equ $-space

section .bss
    new_line_len resd 1
    count resb 1
    line resb 1
    
section .text
    global _start
        _start:
            mov BYTE [new_line_len], 10    
        
            ; read line
            mov rax, 0       
            mov rdi, 0          
            mov rsi, line  
            mov rdx, 10
            syscall
            
            ; view symbols
            mov ecx, 10
            
            browse:
                cmp ecx, 0
                je write
                dec ecx
                
                    xor eax, eax
                    lodsb
                    cmp eax, 4fh
                        jne browse          ; moving on to the next iteration
                        
                        dec rsi             ; shift back by a character
                        
                        lodsw               ; viewing two characters
                        cmp eax, 504fh      ; comparison with OP
                        
                            jne browse
                           
                            dec BYTE [new_line_len]
                            
                            ; change O to !
                            mov edi, esi
                            sub edi, 2
                            mov eax, 21h        
                            stosb
                            
                            dec ecx
                            mov ebx, esi
                                             
                  rewrite:
                        cmp BYTE [rsi], 0
                            je continue
                        
                        mov eax, DWORD[rsi]
                        mov DWORD[rsi-1], eax
                        add rsi, 4
                        jmp rewrite
                   
                   continue:                                            
                        ; return to the previous position
                        dec ebx
                        mov esi, ebx
                        
                    
                    jmp browse
            
            write:            
                mov rax, 1
                mov rdi, 1 
                mov rsi, line
                mov edx, DWORD [new_line_len]
                syscall
                
                mov rax, 1
                mov rdi, 1 
                mov rsi, space
                mov edx, len_space
                syscall
                
                mov eax, 10
                sub eax, DWORD [new_line_len]
                
                mov esi, count
                call IntToStr64
                
                mov rax, 1
                mov rdi, 1 
                mov rsi, count
                mov edx, 2
                syscall
                
                mov rax, 1
                mov rdi, 1 
                mov rsi, space
                mov edx, len_space
                syscall

                           
            exit:
                mov eax, 60        ; system function 60 (exit)
                xor rdi, rdi       ; return code 0
                syscall