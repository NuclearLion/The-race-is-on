; Copyrigth (c) 2023, <Dan-Dominic Staicu>

section .data

section .text
    global bonus

bonus:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; board

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

	mov esi, ecx
	xor ecx, ecx

;address = base_address + (row_index * number_of_columns + column_index)

upper_left: ; corner in a direction where the piece can go
	push eax ; save initial x
	push ebx ; save initial y

	inc eax ; x++
	dec ebx ; y--

	; check if x or y are out of bounds
	cmp eax, 0 ; x < 0
	jl no_place_ul

	cmp eax, 7 ; x > 7
	jg no_place_ul

	cmp ebx, 0 ; y < 0
	jl no_place_ul

	cmp ebx, 7 ; y > 7
	jg no_place_ul

	mov dx, 8 ; dx = 8 number of columns
	mul dx ; eax = eax * dx

	add ax, bx ;(row_index * number_of_columns + column_index)

	cmp ax, 32 ; check if the piece is in the first or second register
	jl second_esi_ul ; if it is in the second register, add 4 to the address

	mov ecx, eax ;save in ecx the number of shifts
	mov ebx, 1
	shl ebx, cl ; ebx = 1 << ecx

	add [esi], ebx ; add the piece to the board
	xor ecx, ecx ; clear ecx

	jmp no_place_ul ; jump to the end of the function

second_esi_ul: ; if the piece is in the second register
	sub ax, 32 ; subtract 32 from the address to get the correct address

	mov ecx, eax ; save in ecx the number of shifts
	mov ebx, 1 
	shl ebx, cl ; ebx = 1 << ecx

	add esi, 4 ; add 4 to the address to get the correct address

	add [esi], ebx ; add the piece to the board	

	sub esi, 4 ; subtract 4 from the address to get the correct address
	xor ecx, ecx
	
no_place_ul: ; piece can't go in the upper left or end of upper left corner
	pop ebx
	pop eax

upper_right: ; corner in a direction where the piece can go
	push eax
	push ebx

	inc eax ; x++
	inc ebx ; y++

	; check if x or y are out of bounds
	cmp eax, 0
	jl no_place_ur

	cmp eax, 7
	jg no_place_ur

	cmp ebx, 0
	jl no_place_ur

	cmp ebx, 7
	jg no_place_ur

	mov dx, 8
	mul dx

	add ax, bx

	cmp ax, 32 ; check if the piece is in the first or second register
	jl second_esi_ur

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add [esi], ebx
	xor ecx, ecx

	jmp no_place_ur

second_esi_ur: ; if the piece is in the second register
	sub ax, 32

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add esi, 4

	add [esi], ebx

	sub esi, 4
	xor ecx, ecx
	
no_place_ur: ; piece can't go in the upper right or end of upper right corner
	pop ebx
	pop eax

lower_left: ; corner in a direction where the piece can go
	push eax
	push ebx

	dec eax ; x--
	dec ebx ; y--

	; check if x or y are out of bounds
	cmp eax, 0
	jl no_place_ll

	cmp eax, 7
	jg no_place_ll

	cmp ebx, 0
	jl no_place_ll

	cmp ebx, 7
	jg no_place_ll

	mov dx, 8
	mul dx

	add ax, bx

	cmp ax, 32
	jl second_esi_ll

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add [esi], ebx
	xor ecx, ecx

	jmp no_place_ll

second_esi_ll: ; if the piece is in the second register
	sub ax, 32

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add esi, 4

	add [esi], ebx

	sub esi,4
	xor ecx, ecx

no_place_ll: ; piece can't go in the lower left or end of lower left corner
	pop ebx
	pop eax


lower_right: ; corner in a direction where the piece can go
	push eax
	push ebx

	dec eax ; x--
	inc ebx ; y++

	; check if x or y are out of bounds
	cmp eax, 0
	jl no_place_lr

	cmp eax, 7
	jg no_place_lr

	cmp ebx, 0
	jl no_place_lr

	cmp ebx, 7
	jg no_place_lr

	mov dx, 8
	mul dx

	add ax, bx


	cmp ax, 32 ; check if the piece is in the first or second register
	jl second_esi_lr

	mov ecx, eax
	mov ebx, 1
	shl ebx, cl

	add [esi], ebx
	xor ecx, ecx

	jmp no_place_lr ; jump to the end of the function

second_esi_lr: ; if the piece is in the second register
	sub ax, 32

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add esi, 4

	add [esi], ebx

	sub esi, 4
	xor ecx, ecx

no_place_lr: ; piece can't go in the lower right or end of lower right corner
	pop ebx
	pop eax

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY







;100000000000000000000000000000
;536870912

; 00100000
; 00000000
; 00000000
; 00000000