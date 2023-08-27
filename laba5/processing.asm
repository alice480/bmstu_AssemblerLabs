%include "../lib64.asm"
    
section .bss
    count resb 1
    vowels resd 1
    
section .text
    global vow_count
        vow_count:
            mov BYTE [count], 0
            
            xor eax, eax
            lodsb
            browse_string:
                cmp eax, 0
                je end
                    mov rbx, rsi            ; i
                    xor rsi, rsi
                    mov rsi, rdi            ; vowels   
                    mov edx, eax            ; line[i]
                    
                    mov ecx, 13             ; count of vowels
                    lodsb                   ; vowels[j]
                    comparing:
                        cmp ecx, 0
                            dec ecx
                            je next_itertion
                                cmp eax, edx    ; vowels[i] == line[i]
                                    jne shift
                                    inc BYTE [count]
                                    jmp next_itertion
                                shift:
                                    lodsb
                                    jmp comparing
                             
                    next_itertion:
                        xor rsi, rsi
                        mov rsi, rbx
                        lodsb
                jmp browse_string
            
            end:
                mov al, BYTE [count]
                ret

