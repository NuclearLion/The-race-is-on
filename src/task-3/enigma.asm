%include "../include/io.mac"

;; defining constants, you can use these as immediate values in your code
LETTERS_COUNT EQU 26

section .data
    extern len_plain
	rotate_line_alphabet TIMES 26 db 0
	rotate_line_link TIMES 26 db 0
	notches dd 0
	cnt dd 0

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


	jmp start_overwrite


end:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY



search_in_rotor:
	push ebp
	mov ebp, esp

	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	mov edi, [ebp + 8] ; 1st col
	mov esi, [ebp + 12] ; 2nd col
	mov ebx, [ebp + 16] ; given index

	xor eax, eax
	xor ecx, ecx
	xor edx, edx

	mov dl, byte [edi + ebx]

iter_col2:
	mov cl, byte [esi + eax]
	cmp dl, cl
	je no_iter_col2

	; inc esi
	inc eax

	jne iter_col2

no_iter_col2:

	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx

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

	

	xor esi, esi
	mov [notches], ecx ; save notches ;TODO ??
	mov esi, eax ; save plain in esi
	mov [cnt], dword 0
	; xor eax, eax
	; xor ecx, ecx
	
iter_plain:
	mov ecx, [notches]
	xor eax, eax

	mov al, byte [ebx + 2] ;TODO
	mov ah, al
	add al, 1

	cmp al, 90
	jle in_range_z1

	sub al, 26

in_range_z1:
	mov byte [ebx + 2], al

	push dword 0
	push edx ; matrix
	push dword 2 ; rotor3
	push dword 1 ; offset
	call rotate_x_positions ; rotate 3rd
	add esp, 16 





	cmp ah, byte [ecx + 2]
	mov ah, byte [ebx + 1] ; key of 2nd rot

	jne no_rotate_rot_0

	; rotate the 2nd rotor
	mov al, ah
	add al, 1

	cmp al, 90 
	jle in_range_z2

	sub al, 26

in_range_z2:
	mov byte [ebx + 1], al

	push dword 0
	push edx
	push dword 1
	push dword 1
	call rotate_x_positions ; rotate the 2nd rotor
	add esp, 16 ; clear stack

no_rotate_rot_0:
	cmp ah, byte [ecx + 1]

	jne no_rotate_rot_1

	; rotate the 2nd key
	add ah, 1
	mov byte [ebx + 1], ah

	push dword 0
	push edx
	push dword 1
	push dword 1
	call rotate_x_positions ; rotate the 2nd rotor
	add esp, 16

	mov al, byte [ebx] ; key of the 1st rot

	add al, 1

	cmp al, 90
	jle in_range_z3

	sub al, 26

in_range_z3:
	mov byte [ebx], al

	push dword 0
	push edx
	push dword 0
	push dword 1
	call rotate_x_positions ; rotate the 1st rot
	add esp, 16

no_rotate_rot_1:
	mov ecx, [cnt]
	xor eax, eax
	add al, byte [esi + ecx] ; current letter from plain
	sub eax, 65 ; get start index

	; PRINTF32 `EAX start index: %d\n\x0`, eax

	; search in the plugboard
	push eax ; given index - param 3
	; xor eax, eax

	mov eax, edx
	add eax, 208 ; 2nd col of plugboard
	push eax ; param 2
	; xor eax, eax

	mov eax, edx
	add eax, 234 ; 1st col of plugboard
	push eax ; param  1
	; xor eax, eax

	call search_in_rotor ; search in the plugboard
	add esp, 12

	; PRINTF32 `eax after plug board: %d\n\x0`, eax

third_rotor_label:
	; search in 3rd rotor
	push eax ;param 3
	; xor eax, eax

	mov eax, edx
	add eax, 104 ; 2nd col of 3rd rotor
	push eax ;param 2
	; xor eax, eax

	mov eax, edx
	add eax, 130 ; 1st col of 3rd rotor
	push eax ;param 1
	; xor eax, eax

	call search_in_rotor ; search in 3rd rotor
	add esp, 12

	; PRINTF32 `eax after 3rd rotor: %d\n\x0`, eax

	; search in the 2nd rotor
	push eax ;param 3
	; xor eax, eax

	mov eax, edx
	add eax, 52 ; 2nd col of 2nd rotor
	push eax;param 2
	; xor eax, eax

	mov eax, edx
	add eax, 78 ; 1st col of 1st rotor
	push eax ;param 1
	; xor eax, eax

	call search_in_rotor ; search in the 2nd rotor
	add esp, 12

	
	; search in the 1st rotor
	push eax ;param 3
	; xor eax, eax

	mov eax, edx
	add eax, 0 ;2nd col of 1st rotor
	push eax ;param 2
	; xor eax, eax

	mov eax, edx ; 1st col of 1st rotor
	add eax, 26
	push eax ;param 1
	; xor eax, eax

	call search_in_rotor ; search in the 1st rotor
	add esp, 12


	; search in the reflector
	push eax ;param 3
	; xor eax, eax

	mov eax, edx
	add eax, 156 ; 2nd col of reflector
	push eax ;param 2
	; xor eax, eax

	mov eax, edx
	add eax, 182 ; 1st col of reflector
	push eax ; param 1
	; xor eax, eax

	call search_in_rotor ; search in the reflector
	add esp, 12


	; search back in the 1st rotor
	push eax ;param 3
	; xor eax, eax

	mov eax, edx
	add eax, 26
	push eax ;2nd col of 1st rotor ; param 2
	; xor eax, eax

	mov eax, edx
	add eax, 0 ; 1st col of 1st rotor
	push eax ; param  1
	; xor eax, eax

	call search_in_rotor ; search back in the 1st rotor
	add esp, 12


	; search back in the 2nd rotor
	push eax ; param 3
	; xor eax, eax

	mov eax, edx
	add eax, 78 ; 2nd col of 2nd rotor
	push eax ;param 2
	; xor eax, eax

	mov eax, edx
	add eax, 52 ; 1st col of 1st rotor
	push eax ;param 1
	; xor eax, eax

	call search_in_rotor ; search back in the 2nd rotor
	add esp, 12


	; search back in 3rd rotor
	push eax ; param 3
	; xor eax, eax

	mov eax, edx
	add eax, 130 ; 2nd col of 3rd rotor
	push eax ;param 2
	; xor eax, eax

	mov eax, edx
	add eax, 104 ; 1st col of 3rd rotor
	push eax ; param 1
	; xor eax, eax

	call search_in_rotor ; search back in 3rd rotor
	add esp, 12


	; search back in the plugboard
	push eax ; given index ; param 1
	; xor eax, eax

	mov eax, edx
	add eax, 234 ; 2nd col of plugboard
	push eax ;param 2
	; xor eax, eax

	mov eax, edx
	add eax, 208 ; 1st col of plugboard
	push eax ; param 1
	; xor eax, eax

	call search_in_rotor ; search back in the plugboard
	add esp, 12	

	; PRINTF32 `final eax: %d\n\x0`, eax

	add eax, 65
	; PRINTF32 `Final letter %c\n\x0`, eax

	mov byte [edi + ecx], al
	inc ecx
	mov [cnt], ecx
	mov eax, [len_plain]

	sub eax, ecx
	jnz iter_plain

	mov byte [edi + ecx], 0

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
