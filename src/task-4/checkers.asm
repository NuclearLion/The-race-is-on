; Copyrigth (c) 2023, <Dan-Dominic Staicu>

section .data

section .text
	global checkers

checkers:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

	mov esi, ecx ;save table
	xor ecx, ecx

;address = base_address + (row_index * number_of_columns + column_index)

upper_left: ; corner in a direction where the piece can go
	push eax ;save x
	push ebx ;save y
	push esi ;save table

	inc eax ;x++
	dec ebx ;y--

	;check if x and y are in bounds
	cmp eax, 0 ;x < 0
	jl no_place_ul

	cmp eax, 7 ;x > 7
	jg no_place_ul

	cmp ebx, 0 ;y < 0
	jl no_place_ul

	cmp ebx, 7 ;y > 7
	jg no_place_ul

	mov dx, 8 ;dx = 8 number of columns
	mul dx ;eax = eax * dx

	add ax, bx ;(row_index * number_of_columns + column_index)

	add esi, eax ;address = base_address + (row_index * number_of_columns + column_index)

	mov dword [esi], dword 1 ;set the value to 1

no_place_ul: ;out of bounds or placed succesfully
	pop esi ;restore table
	pop ebx ;restore y
	pop eax ;restore x


upper_right: ; corner in a direction where the piece can go
	push eax
	push ebx
	push esi

	inc eax ;x++
	inc ebx ;y++

	;check if x and y are in bounds
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

	add esi, eax

	mov dword [esi], dword 1

no_place_ur: ;out of bounds or placed succesfully
	
	pop esi
	pop ebx
	pop eax

lower_left: ; corner in a direction where the piece can go
	push eax
	push ebx
	push esi

	dec eax ;x--
	dec ebx ;y--

	;check if x and y are in bounds
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

	add esi, eax

	mov dword [esi], dword 1

no_place_ll: ;out of bounds or placed succesfully
	pop esi
	pop ebx
	pop eax


lower_right: ; corner in a direction where the piece can go
	push eax
	push ebx
	push esi

	dec eax ;x--
	inc ebx ;y++

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

	add esi, eax

	mov dword [esi], dword 1


no_place_lr: ;out of bounds or placed succesfully
	pop esi
	pop ebx
	pop eax

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
