%include "../include/io.mac"

;; defining constants, you can use these as immediate values in your code
LETTERS_COUNT EQU 26

section .data
    extern len_plain
	rotate_line_alphabet TIMES 26 db 0
	rotate_line_link TIMES 26 db 0

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

	mov esi, ecx ; move matrix in esi

	cmp ebx, 0
	jg second_rot
	; PRINTF32 `first el: %d\n\x0`, ebx
	
	; 1st rotor is already set
	jmp decide_direction


second_rot:
	cmp ebx, 1
	jg third_rot

	;2nd rotor
	add esi, 52

	jmp decide_direction

third_rot:
	;3rd rotor
	add esi, 104


decide_direction:
	cmp edx, 0
	jg shift_right

	; PRINTF32 `Shift left with EAX: %d\n\x0`, eax

	; can use ebx, ecx and edx
	; eax - x
	
;	A B C D E F G - alh
;	D E F G A B C - link

	xor ebx, ebx ; index in new arrays
	push eax

loop_start_x:
	xor edx, edx
	mov dl, byte [esi + eax]
	mov [rotate_line_alphabet + ebx], dl

	; ----debug----
	; xor edx, edx
	; mov dl, [rotate_line_alphabet + ebx]
	; PRINTF32 `rot_l_alph %d\n\x0`, edx

	; ----debug----

	mov dl, byte [esi + eax + 26]
	mov [rotate_line_link + ebx], dl

	inc ebx
	inc eax

	cmp eax, 26
	jl loop_start_x


	pop eax ; get back the offset
	xor ecx, ecx ; index in esi, but values before x

loop_end_x: ; values from index 0 to index x (without x)
	xor edx, edx
	mov dl, byte [esi + ecx]
	mov [rotate_line_alphabet + ebx], dl

	mov dl, byte [esi + ecx + 26]
	mov [rotate_line_link + ebx], dl

	inc ebx
	inc ecx

	cmp ebx, 26
	jl loop_end_x
	jmp start_overwrite

start_overwrite:

	xor ecx, ecx
loop_overwrite_rotors:
	xor edx, edx

	mov dl, byte [rotate_line_alphabet + ecx]
	mov [esi + ecx], dl

	xor edx, edx
	mov dl, byte [rotate_line_link + ecx]
	mov [esi + 26 + ecx], dl	

	inc ecx
	cmp ecx, 26
	jl loop_overwrite_rotors

	jmp end


shift_right:
	; PRINTF32 `Shift right with EAX: %d\n\x0`, eax
	cmp eax, 0
	je end

	xor ebx, ebx ; index in new array
	push eax
	xor ecx, ecx

loop_last_elem:
	xor edx, edx
	mov dl, byte [esi + ebx]
	mov [rotate_line_alphabet + eax], dl
	

	mov dl, byte [esi + ebx + 26]
	mov [rotate_line_link + eax], dl

	inc ebx
	inc eax

	cmp eax, 26
	jl loop_last_elem

	pop eax
	xor ecx, ecx

loop_first_elem:
	xor edx, edx
	mov dl, byte [esi + ebx]
	mov [rotate_line_alphabet + ecx], dl

	mov dl, byte [esi + ebx + 26]
	mov [rotate_line_link + ecx], dl



	inc ebx
	inc ecx

	cmp ecx, eax
	jl loop_first_elem

; ----debug----
; 	xor edx, edx
; 	xor ecx, ecx
; loop_print_array:
; 	xor edx, edx
; 	; mov dl, byte [rotate_line_alphabet + ecx]
; 	; PRINTF32 `value from array in DX: %d\n\x0`, edx

; 	mov dl, byte [rotate_line_alphabet + ecx]
; 	PRINTF32 `value from array in DX: %d\n\x0`, edx
	

; 	inc ecx
; 	cmp ecx, 26
; 	jl loop_print_array

; 	PRINTF32 `\nPENIISSSSS\n\n\n\x0`, edx

; ----debug----

	jmp start_overwrite


end:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

; search the given index
; get the value/letter at the index
; search on the 2nd col the letter found in the first
; return the index from the 2nd
search_in_rotor:
	push ebp
	mov ebp, esp
	push eax
	push ebx
	; push ecx
	push edx
	push esi
	push edi

	mov eax, [ebp + 8] ; given index
	mov esi, [ebp + 12] ; 1st col
	mov edi, [ebp + 16] ; 2nd col
	; mov ecx, [ebp + 20] ; return index

	mov edx, [esi + eax] ; get in edx the letter at given index

	xor ecx, ecx
	cmp [esi], edx
	je no_iter_col2
iter_col2:
	inc ecx
	inc esi
	cmp [esi], edx
	jne iter_col2
no_iter_col2:



	pop eax
	pop ebx
	; pop ecx
	pop edx
	pop esi
	pop edi
	leave
	ret

apply_enigma:
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	; push edi

	mov eax, [ebp + 8] ; the letter
	mov ebx, [ebp + 12] ; key
    mov ecx, [ebp + 16] ; notches
    mov edx, [ebp + 20] ; config (address of first element in matrix)
    mov edi, [ebp + 24] ; enc

	push [edx + 234] ; 2st col of 
	push [edx + 208] ; 1st col
	push eax
	call search_in_rotor ;search in plugboard

	add esp, 12
	mov eax, ecx ; get new index
	xor ecx, ecx

	push [edx + 130]
	push [edx + 104]
	push eax
	call search_in_rotor ;search in 3rd rotor

	add esp, 12
	mov eax, ecx ; get new index
	xor ecx, ecx

	push [edx + 78]
	push [edx + 52]
	push eax
	call search_in_rotor ;search in 2nd rotor

	add esp, 12
	mov eax, ecx
	xor ecx, ecx

	push [edx + 26]
	push [edx]
	push eax
	call search_in_rotor ;search in 1st rotor

	add esp, 12
	mov eax, ecx
	xor ecx, ecx

	push [edx + 182]
	push [edx + 156]
	push eax
	call search_in_rotor ;search in reflector

	add esp, 12
	mov eax, ecx
	xor ecx, ecx

	push [edx]
	push [edx + 26]
	push eax
	call search_in_rotor ;search back in 1st rotor

	add esp, 12
	mov eax, ecx
	xor ecx, ecx

	push [edx + 52]
	push [edx + 78]
	push eax
	call search_in_rotor ;search back in 2st rotor

	add esp, 12
	mov eax, ecx
	xor ecx, ecx


	push [edx + 104]
	push [edx + 130]
	push eax
	call search_in_rotor ;search back in 3st rotor

	add esp, 12
	mov eax, ecx
	xor ecx, ecx

	
	push [edx + 156]
	push [edx + 182]
	push eax
	call search_in_rotor ;search back in plugboard

	add esp, 12
	mov eax, ecx
	xor ecx, ecx


	pop eax
	pop ebx
	pop ecx
	pop edx
	pop esi
	; pop edi

	popa
	leave
	ret


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



    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY