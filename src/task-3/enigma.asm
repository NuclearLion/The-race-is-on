; Copyrigth (c) 2023, <Dan-Dominic Staicu>
%include "../include/io.mac"


;; defining constants, you can use these as immediate values in your code
LETTERS_COUNT EQU 26

section .data
    extern len_plain
	rotate_line_alphabet TIMES 26 db 0
	rotate_line_link TIMES 26 db 0
	notches dd 0
	current_index dd 0

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

	cmp ebx, 0 ; check which rotor is given
	jg second_rot ; 2nd rotor

	; 1st rotor is already set
	jmp decide_direction ; decide direction


second_rot:
	cmp ebx, 1 ; check which rotor is given
	jg third_rot ; 3rd rotor

	;2nd rotor
	add esi, 52 ; move to 2nd rotor

	jmp decide_direction ; decide direction

third_rot:
	;3rd rotor
	add esi, 104 ; move to 3rd rotor


decide_direction:
	cmp edx, 0 ; check direction
	jg shift_right

	cmp eax, 0 ; check if x is 0
	je end ; if yes, end because nothing to rotate

; example:
;	A B C D E F G - alh
;	D E F G A B C - link

	xor ebx, ebx ; index in new arrays
	push eax ; save x

loop_start_x: ; values from index x to index 25
	xor edx, edx
	mov dl, byte [esi + eax] ; get the letter from 1st col
	mov [rotate_line_alphabet + ebx], dl ; save it in new array

	mov dl, byte [esi + eax + 26] ; get the letter from 2nd col
	mov [rotate_line_link + ebx], dl ; save it in new array

	inc ebx ; increment index in new array
	inc eax ; increment index in old array

	cmp eax, 26 ; check if we reached the end
	jl loop_start_x


	pop eax ; get back the offset
	xor ecx, ecx ; index in esi, but values before x

loop_end_x: ; values from index 0 to index x (without x)
	xor edx, edx
	mov dl, byte [esi + ecx] ; get the letter from 1st col
	mov [rotate_line_alphabet + ebx], dl ; save it in new array

	mov dl, byte [esi + ecx + 26] ; get the letter from 2nd col
	mov [rotate_line_link + ebx], dl ; save it in new array

	inc ebx ; increment index in new array
	inc ecx ; increment index in old array

	cmp ebx, 26 ; check if we reached the end
	jl loop_end_x ; if not, continue
	jmp start_overwrite ; overwrite the old array with the new one

start_overwrite:

	xor ecx, ecx ; index in esi, but values after x
loop_overwrite_rotors:
	xor edx, edx

	mov dl, byte [rotate_line_alphabet + ecx] ; get the letter from 1st col
	mov [esi + ecx], dl ; save it in new array

	xor edx, edx
	mov dl, byte [rotate_line_link + ecx] ; get the letter from 2nd col
	mov [esi + 26 + ecx], dl ; save it in new array

	inc ecx ; increment index in old array
	cmp ecx, 26 ; check if we reached the end
	jl loop_overwrite_rotors ; if not, continue

	jmp end ; end of function


shift_right:
	cmp eax, 0
	je end

	xor ebx, ebx ; index in new array
	push eax ; save x
	xor ecx, ecx ; index in esi, but values after x

loop_last_elem: ; values from index x to index 25
	xor edx, edx
	mov dl, byte [esi + ebx] ; get the letter from 1st col
	mov [rotate_line_alphabet + eax], dl ; save it in new array
	

	mov dl, byte [esi + ebx + 26] ; get the letter from 2nd col
	mov [rotate_line_link + eax], dl ; save it in new array

	inc ebx ; increment index in new array
	inc eax ; increment index in old array

	cmp eax, 26 ; check if we reached the end
	jl loop_last_elem ;	if not, continue

	pop eax ; get back the offset
	xor ecx, ecx ; index in esi, but values before x

loop_first_elem: ; values from index 0 to index x (without x)
	xor edx, edx
	mov dl, byte [esi + ebx] ; get the letter from 1st col
	mov [rotate_line_alphabet + ecx], dl ; save it in new array

	mov dl, byte [esi + ebx + 26] ; get the letter from 2nd col
	mov [rotate_line_link + ecx], dl ; save it in new array

	inc ebx ; increment index in new array
	inc ecx ; increment index in old array

	cmp ecx, eax ; check if we reached the end
	jl loop_first_elem ; if not, continue

	jmp start_overwrite ; overwrite the old array with the new on

end: ; end of function rotate_x_positions
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY



search_in_rotor: ; search for a letter in a rotor
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

	xor eax, eax ; index in 2nd col
	xor ecx, ecx ; index in 1st col
	xor edx, edx ; value from 1st col

	mov dl, byte [edi + ebx] ; get the letter from 1st col

iter_col2:
	xor ecx, ecx
	mov cl, byte [esi + eax] ; get the letter from 2nd col
	cmp dl, cl ; compare the letters
	je no_iter_col2 ; if equal, return

	inc eax ; increment index

	jne iter_col2 ; if not equal, continue

no_iter_col2: ; if equal, return
; 	cmp eax, 26 ;TODO
; 	jl end_search_in_rotor

; 	xor eax, eax
; end_search_in_rotor:
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
	mov [notches], ecx ; save notches 
	mov esi, eax ; save plain in esi
	mov [current_index], dword 0 ; save current index in a global variable
	xor eax, eax
	xor ecx, ecx
	
iter_plain:
	mov ecx, [notches] ; get notches at the beginning of the loop every time
	xor eax, eax

	mov al, byte [ebx + 2] ; get 3rd rotor key
	mov ah, al ; save 3rd rotor key
	add al, 1 ; increment 3rd rotor key

	cmp al, 90 ; check if 3rd rotor key is in range
	jle in_range_z1

	sub al, 26 ; if not, substract 26

in_range_z1: ; 3rd rotor key is in range 
	mov byte [ebx + 2], al ; save new 3rd rotor key

	push dword 0
	push edx ; matrix
	push dword 2 ; rotor3
	push dword 1 ; offset
	call rotate_x_positions ; rotate 3rd
	add esp, 16 

	cmp ah, byte [ecx + 2] ; check if 3rd rotor is in notch position
	mov ah, byte [ebx + 1] ; key of 2nd rot

	jne no_rotate_rot_2

	; rotate the 2nd rotor
	mov al, ah
	add al, 1

	cmp al, 90 
	jle in_range_z2

	sub al, 26

in_range_z2: ; 2nd rotor key is in range
	mov byte [ebx + 1], al

	push dword 0
	push edx
	push dword 1
	push dword 1
	call rotate_x_positions ; rotate the 2nd rotor
	add esp, 16 ; clear stack

no_rotate_rot_2: ; no rotate 2nd rot
	cmp ah, byte [ecx + 1] ; check if 2nd rotor is in notch position

	jne no_rotate_rot_1 ; no rotate 1st rot

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

in_range_z3: ; check if 1st rotor is in notch position
	mov byte [ebx], al

	push dword 0
	push edx
	push dword 0
	push dword 1
	call rotate_x_positions ; rotate the 1st rot
	add esp, 16

no_rotate_rot_1: ; no rotate 1st rot
	mov ecx, [current_index] ; get current_index
	xor eax, eax
	add al, byte [esi + ecx] ; current letter from plain
	sub eax, 65 ; get start index

	; search in the plugboard
	push eax ; given index - param 3

	mov eax, edx
	add eax, 208 ; 2nd col of plugboard
	push eax ; param 2

	mov eax, edx
	add eax, 234 ; 1st col of plugboard
	push eax ; param  1

	call search_in_rotor ; search in the plugboard
	add esp, 12


	; search in 3rd rotor
	push eax ;param 3

	mov eax, edx
	add eax, 104 ; 2nd col of 3rd rotor
	push eax ;param 2

	mov eax, edx
	add eax, 130 ; 1st col of 3rd rotor
	push eax ;param 1

	call search_in_rotor ; search in 3rd rotor
	add esp, 12


	; search in the 2nd rotor
	push eax ;param 3

	mov eax, edx
	add eax, 52 ; 2nd col of 2nd rotor
	push eax;param 2

	mov eax, edx
	add eax, 78 ; 1st col of 1st rotor
	push eax ;param 1

	call search_in_rotor ; search in the 2nd rotor
	add esp, 12

	
	; search in the 1st rotor
	push eax ;param 3

	mov eax, edx 
	; will imagine here was add eax, 0 ;2nd col of 1st rotor
	push eax ;param 2

	mov eax, edx 
	add eax, 26 ; 1st col of 1st rotor
	push eax ;param 1

	call search_in_rotor ; search in the 1st rotor
	add esp, 12


	; search in the reflector
	push eax ;param 3

	mov eax, edx
	add eax, 156 ; 2nd col of reflector
	push eax ;param 2

	mov eax, edx
	add eax, 182 ; 1st col of reflector
	push eax ; param 1

	call search_in_rotor ; search in the reflector
	add esp, 12


	; search back in the 1st rotor
	push eax ;param 3

	mov eax, edx
	add eax, 26
	push eax ;2nd col of 1st rotor ; param 2

	mov eax, edx
	; will imagine here was add eax, 0 ; 1st col of 1st rotor
	push eax ; param  1

	call search_in_rotor ; search back in the 1st rotor
	add esp, 12


	; search back in the 2nd rotor
	push eax ; param 3

	mov eax, edx
	add eax, 78 ; 2nd col of 2nd rotor
	push eax ;param 2

	mov eax, edx
	add eax, 52 ; 1st col of 1st rotor
	push eax ;param 1

	call search_in_rotor ; search back in the 2nd rotor
	add esp, 12


	; search back in 3rd rotor
	push eax ; param 3

	mov eax, edx
	add eax, 130 ; 2nd col of 3rd rotor
	push eax ;param 2

	mov eax, edx
	add eax, 104 ; 1st col of 3rd rotor
	push eax ; param 1

	call search_in_rotor ; search back in 3rd rotor
	add esp, 12


	; search back in the plugboard
	push eax ; given index ; param 1
	
	mov eax, edx
	add eax, 234 ; 2nd col of plugboard
	push eax ;param 2

	mov eax, edx
	add eax, 208 ; 1st col of plugboard
	push eax ; param 1

	call search_in_rotor ; search back in the plugboard
	add esp, 12	


	add eax, 65 ; get the letter

	mov byte [edi + ecx], al ; save the current letter
	inc ecx ; increment the index
	mov [current_index], ecx ; save the current index
	mov eax, [len_plain] ; get the length of the plain text

	sub eax, ecx ; check if we have iterated over the whole plain text
	
	cmp eax, 0 ; if we have, jump to the end
	jne iter_plain ; if not, iterate again

	mov byte [edi + ecx], 0 ; terminate the string

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
