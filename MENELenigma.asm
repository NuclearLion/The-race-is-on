%include "../include/io.mac"

;; defining constants, you can use these as immediate values in your code
LETTERS_COUNT EQU 26
Z_ASCII EQU 90
A_ASCII EQU 65

section .data
    temp_data db 26 dup(0) ; temp array for storing the rotor while rotating
    extern len_plain
    notches dd 0 ; temp pointer to notches array
    counter dd 0 ; temp counter for the letters in plain text

section .text
    global rotate_x_positions
    global enigma
    extern printf

; void rotate_x_positions(int x, int rotor, char config[10][26], int forward);
rotate_x_positions:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; x
    mov ebx, [ebp + 12] ; rotor
    mov ecx, [ebp + 16] ; config (address of first element in matrix)
    mov edx, [ebp + 20] ; forward
    ;; DO NOT MODIFY
    ;; TODO: Implement rotate_x_positions
    ;; FREESTYLE STARTS HERE
    xor esi, esi ; empty esi
    xor edi, edi ; empty edi
    cmp edx, 1 ; check if forward
    jne no_offset_change ; if not forward, skip offset change
    mov edx, eax 
    sub eax, edx
    sub eax, edx ; offset = -offset
no_offset_change:
    mov esi, eax  ; use esi to store the offset
    mov eax, ebx ; use eax to store the rotor number
    add eax, eax 
    mov edx, LETTERS_COUNT
    mul edx
    add eax, ecx ; eax = config + 2 * rotor * LETTERS_COUNT
    ; eax store the starting position of the rotor in the config matrix


;; rotate the orderder line in the rotor
    xor edi, edi ; empty edi to use as counter
label_continue:
    xor ebx, ebx ; empty ebx
    mov bl, byte [eax + edi] ; store the current letter in bl
    add ebx, esi ; add the offset to the current letter
    cmp ebx, Z_ASCII ; check if the letter is out of range
    jle no_overflow_high ; if not, skip the overflow_high
    sub ebx, LETTERS_COUNT ; if overflow_high, subtract 26
no_overflow_high:
    cmp ebx, A_ASCII ; check if the letter is out of range
    jge no_overflow_low ; if not, skip the overflow_low
    add ebx, LETTERS_COUNT ; if overflow_low, add 26
no_overflow_low:

    mov byte [eax + edi], bl ; save the rotated letter in the config matrix
    add edi, 1 ; increase the counter
    cmp edi, LETTERS_COUNT ; check if the counter reach the number of letters
    jnz label_continue ; if not, continue the loop

    add eax, edi ; increase eax to point to the next line in the config matrix
    xor edi, edi ; empty edi to use as counter
    xor ebx, ebx ; empty ebx

;; save the combination of the rotor in the temp array
save_data:
    mov bh, [eax + edi] ; store the current letter in bh
    mov byte [temp_data + edi], bh ; save the letter in the temp array
    add edi, 1 ; increase the counter
    cmp edi, LETTERS_COUNT ; check if the counter reach the number of letters
    jnz save_data ; if not, continue the loop


    xor edi, edi ; empty edi to use as counter

;; rotate the combination line in the rotor using the temp array
continue_value:
    xor ebx, ebx ; empty ebx
    add ebx, esi ; add the offset to the current letter
    add ebx, edi ; add the counter to the current letter
    cmp ebx, LETTERS_COUNT ; check if the letter is out of range
    jl no_overflow_high2 ; if not, skip the overflow_high
    sub ebx, LETTERS_COUNT ; if overflow_high, subtract 26
no_overflow_high2: 
    cmp ebx, 0 ; check if the letter is out of range
    jge no_overflow_low2 ; if not, skip the overflow_low
    add ebx, LETTERS_COUNT ; if overflow_low, add 26
no_overflow_low2:
    mov ch, byte [temp_data + ebx] ; save the rotated letter in ch
    mov byte [eax + edi], ch ; save the rotated letter in the config matrix
    xor ch, ch ; empty ch
    add edi, 1 ; increase the counter
    cmp edi, LETTERS_COUNT ; check if the counter reach the number of letters
    jnz continue_value ; if not, continue the loop

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

; void enigma(char *plain, char key[3], char notches[3], char config[10][26], char *enc);
enigma:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; plain (address of first element in string)
    mov ebx, [ebp + 12] ; key
    mov ecx, [ebp + 16] ; notches
    mov edx, [ebp + 20] ; config (address of first element in matrix)
    mov edi, [ebp + 24] ; enc
    ;; DO NOT MODIFY
    ;; TODO: Implement enigma
    ;; FREESTYLE STARTS HERE

    xor esi, esi ; empty esi
    mov [notches], ecx ; save the pointer to notches
    mov esi, eax ; store the pointer to plain text in esi
    mov [counter], dword 0 ; set the counter to 0

;; encode each letter from plain text
next_letter:
    mov ecx, [notches] ; get the pointer to notches
    xor eax, eax ; empty eax

    mov al, byte [ebx + 2] ; get the key of the third rotor
    mov ah, al ; save the key in ah
    add al, 1 ; increase the key by 1 (rotate the key)
    cmp al, Z_ASCII ; check if the key is out of range
    jle no_overflow_high_1 ; if not, skip the overflow_high
    sub al, LETTERS_COUNT ; if overflow_high, subtract 26
no_overflow_high_1: 
    mov byte [ebx + 2], al ; save the rotated key in the key array

;; call the rotate function for the third rotor
    push dword 0 ;; forward direction
    push edx ;; config matrix
    push dword 2 ;; rotor number
    push dword 1 ;; offset
    call rotate_x_positions ;; rotate the third rotor
    add esp, 16 ;; clean the stack

; check if the key of the third rotor is equal to its notch
    cmp ah, byte [ecx + 2] 
    mov ah, byte [ebx + 1] ; store the key of the second rotor in ah
; if the key is not equal to its notch, skip rotate for the second rotor
    jnz no_rotate 
    mov al, ah ; save the key of the second rotor in al
    add al, 1 ; increase the key by 1 (rotate the key)
    cmp al, Z_ASCII ; check if the key is out of range
    jle no_overflow_high_2 ; if not, skip the overflow_high
    sub al, LETTERS_COUNT ; if overflow_high, subtract 26
no_overflow_high_2:
    mov byte [ebx + 1], al ; save the rotated key in the key array

;; call the rotate function for the second rotor
    push dword 0 ;; forward direction
    push edx ;; config matrix
    push dword 1 ;; rotor number
    push dword 1 ;; offset
    call rotate_x_positions ;; rotate the second rotor
    add esp, 16 ;; clean the stack

    no_rotate:

; check if the key of the second rotor is equal to its notch
    cmp ah, byte [ecx + 1]
; if the key is not equal to its notch, skip rotate for the first rotor
    jnz no_rotate1
    add ah, 1 ; increase the key by 1 (rotate the key)
    mov byte [ebx + 1], ah ; save the rotated key in the key array

;; call the rotate function for the second rotor
    push dword 0 ;; forward direction
    push edx ;; config matrix
    push dword 1 ;; rotor number
    push dword 1 ;; offset
    call rotate_x_positions ;; rotate the second rotor
    add esp, 16 ;; clean the stack

    mov al, byte [ebx] ; store the key of the first rotor in al

    add al, 1 ; increase the key by 1 (rotate the key)
    cmp al, Z_ASCII ; check if the key is out of range
    jle no_overflow_high_3 ; if not, skip the overflow_high
    sub al, LETTERS_COUNT ; if overflow_high, subtract 26
no_overflow_high_3:
    mov byte [ebx], al ; save the rotated key in the key array

;; call the rotate function for the first rotor
    push dword 0 ;; forward direction
    push edx ;; config matrix
    push dword 0 ;; rotor number
    push dword 1 ;; offset
    call rotate_x_positions ;; rotate the first rotor
    add esp, 16 ;; clean the stack
no_rotate1:

  mov ecx, [counter] ; get the counter
  xor eax, eax ; empty eax
  add al, byte [esi + ecx] ; get the current letter from plain text
  sub eax, A_ASCII ; subtract 65 from the letter to get the index

;; call the fwd encode function for the plug board
  push eax ; parameter -- index of the letter
  mov eax, edx ; config matrix
  add eax, 208 ; calcutate offset of the plug board
  push eax ; parameter -- offset of the plug board in the config matrix
  call encode_level_forword ; call the fwd encode function
  add esp, 8 ; clean the stack

;; call the fwd encode function for the third rotor
  push eax ; parameter -- index of the prev encoded letter
  mov eax, edx ; config matrix
  add eax, 104 ; calcutate offset of the third rotor
  push eax ; parameter -- offset of the third rotor in the config matrix
  call encode_level_forword ; call the fwd encode function
  add esp, 8 ; clean the stack

;; call the fwd encode function for the second rotor
  push eax ; parameter -- index of the prev encoded letter
  mov eax, edx ; config matrix
  add eax, 52 ; calcutate offset of the second rotor
  push eax ; parameter -- offset of the second rotor in the config matrix
  call encode_level_forword ; call the fwd encode function
  add esp, 8 ; clean the stack

;; call the fwd encode function for the first rotor
  push eax ; parameter -- index of the prev encoded letter
  push edx ; parameter -- offset of the first rotor in the config matrix
  call encode_level_forword ; call the fwd encode function
  add esp, 8 ; clean the stack

;; call the fwd encode function for the reflector
  push eax ; parameter -- index of the prev encoded letter
  mov eax, edx ; config matrix
  add eax, 156 ; calcutate offset of the reflector
  push eax ; parameter -- offset of the reflector in the config matrix
  call encode_level_forword ; call the fwd encode function
  add esp, 8 ; clean the stack

;; call the rev encode function for the first rotor
  push eax ; parameter -- index of the prev encoded letter
  push edx ; parameter -- offset of the first rotor in the config matrix
  call encode_level_reverse ; call the rev encode function
  add esp, 8 ; clean the stack

;; call the rev encode function for the second rotor
  push eax ; parameter -- index of the prev encoded letter
  mov eax, edx ; config matrix
  add eax, 52 ; calcutate offset of the second rotor
  push eax ; parameter -- offset of the second rotor in the config matrix
  call encode_level_reverse ; call the rev encode function
  add esp, 8 ; clean the stack

;; call the rev encode function for the third rotor
  push eax ; parameter -- index of the prev encoded letter
  mov eax, edx ; config matrix
  add eax, 104 ; calcutate offset of the third rotor
  push eax ; parameter -- offset of the third rotor in the config matrix
  call encode_level_reverse ; call the rev encode function
  add esp, 8 ; clean the stack
  
;; call the rev encode function for the plug board  
  push eax ; parameter -- index of the prev encoded letter
  mov eax, edx ; config matrix
  add eax, 208 ; calcutate offset of the plug board
  push eax ; parameter -- offset of the plug board in the config matrix
  call encode_level_reverse ; call the rev encode function
  add esp, 8 ; clean the stack

  add eax, A_ASCII ; calculate the ascii code of the encoded letter
  mov byte [edi + ecx], al ; save the encoded letter in the encoded text
  add ecx, 1 ; increase the counter
  mov [counter], ecx ; save the counter
  mov eax, [len_plain] ; get the length of the plain text
  sub eax, ecx ; subtract the counter from the length of the plain text
  jnz next_letter ; if not all letters are encoded, jump to next_letter

  mov byte [edi + ecx], 0 ; add the null terminator to the encoded text
  jmp end_encode ; jump over the encode functions

;; encode a letter passing through a rotor/plug board/reflector
;; going in the reverse direction
;; encoded letter is returned in eax
encode_level_reverse:
    push ebp
    mov ebp, esp

    push ecx ; save ecx
    push edx ; save edx
    push ebx ; save ebx
    push ebp ; save ebp
    push esi ; save esi
    push edi ; save edi
    
    mov ecx, [ebp + 8]  ; config
    mov ebx, [ebp + 12] ; input_index
    
    xor eax, eax ; empty eax

    mov dl, byte [ecx + ebx] ; get the input letter from the config matrix
search_again_reverse:
    cmp dl, byte [ecx + LETTERS_COUNT + eax] ; compare the input letter with the output letter
    jz return_value_reverse ; if they are equal, return the output letter index
    add eax, 1 ; else, increase the output letter index and search again
    jmp search_again_reverse
return_value_reverse:
    pop edi ; restore edi
    pop esi ; restore esi
    pop ebp ; restore ebp
    pop ebx ; restore ebx
    pop edx ; restore edx
    pop ecx ; restore ecx
    leave
    ret

;; encode a letter passing through a rotor/plug board/reflector
;; going in the forward direction
;; encoded letter is returned in eax
encode_level_forword:
    push ebp 
    mov ebp, esp

    push ecx ; save ecx
    push edx ; save edx
    push ebx ; save ebx
    push ebp ; save ebp
    push esi ; save esi
    push edi ; save edi
    
    mov ecx, [ebp + 8] ; config
    mov ebx, [ebp + 12] ; input_index
    
    xor eax, eax ; empty eax

    mov dl, byte [ecx + LETTERS_COUNT + ebx] ; get the input letter from the config matrix
search_again_forword:
    cmp dl, byte [ecx + eax] ; compare the input letter with the output letter
    jz return_value_forword ; if they are equal, return the output letter index
    add eax, 1 ; else, increase the output letter index and search again
    jmp search_again_forword
return_value_forword:
    pop edi ; restore edi
    pop esi ; restore esi
    pop ebp ; restore ebp
    pop ebx ; restore ebx
    pop edx ; restore edx
    pop ecx ; restore ecx
    leave
    ret

end_encode:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY