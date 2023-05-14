
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

	mov esi, ecx
	xor ecx, ecx

;address = base_address + (row_index * number_of_columns + column_index)

upper_left:
	push eax
	push ebx
	push esi

	inc eax
	dec ebx

	cmp eax, 0
	jl no_place_ul

	cmp eax, 7
	jg no_place_ul

	cmp ebx, 0
	jl no_place_ul

	cmp ebx, 7
	jg no_place_ul

	mov dx, 8
	mul dx

	add ax, bx

	add esi, eax

	mov dword [esi], dword 1

	
no_place_ul:
	pop esi
	pop ebx
	pop eax


upper_right:
	push eax
	push ebx
	push esi

	inc eax
	inc ebx

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

no_place_ur:
	
	pop esi
	pop ebx
	pop eax

lower_left:
	push eax
	push ebx
	push esi

	dec eax
	dec ebx

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

no_place_ll:
	pop esi
	pop ebx
	pop eax


lower_right:
	push eax
	push ebx
	push esi

	dec eax
	inc ebx

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


no_place_lr:
	pop esi
	pop ebx
	pop eax

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
