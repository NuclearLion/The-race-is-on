%include "../include/io.mac"

section .data

section .text
    global bonus
	extern printf

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

upper_left:
	push eax
	push ebx

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

	cmp ax, 32
	jl second_esi_ul

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add [esi], ebx
	xor ecx, ecx

	jmp no_place_ul

second_esi_ul:
	sub ax, 32

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add esi, 4

	add [esi], ebx

	sub esi,4
	xor ecx, ecx
	
no_place_ul:
	pop ebx
	pop eax

upper_right:
	push eax
	push ebx

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

	cmp ax, 32
	jl second_esi_ur

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add [esi], ebx
	xor ecx, ecx

	jmp no_place_ur

second_esi_ur:
	sub ax, 32

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add esi, 4

	add [esi], ebx

	sub esi,4
	xor ecx, ecx
	
no_place_ur:
	pop ebx
	pop eax

lower_left:
	push eax
	push ebx

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

	cmp ax, 32
	jl second_esi_ll

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add [esi], ebx
	xor ecx, ecx

	jmp no_place_ll

second_esi_ll:
	sub ax, 32

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add esi, 4

	add [esi], ebx

	sub esi,4
	xor ecx, ecx

no_place_ll:
	pop ebx
	pop eax


lower_right:
	push eax
	push ebx

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


	cmp ax, 32
	jl second_esi_lr

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add [esi], ebx
	xor ecx, ecx

	jmp no_place_lr

second_esi_lr:
	sub ax, 32

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	add esi, 4

	add [esi], ebx

	sub esi,4
	xor ecx, ecx


no_place_lr:
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