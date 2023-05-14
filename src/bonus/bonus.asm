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

	; esi the number
	; ecx n-th bit

	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	; PRINTF32 `EBX for or: %d\n\x0`, ebx

	cmp ebx, 2147483648 ;2^31
	jg second_esi_ul

	add [esi], ebx
	xor ecx, ecx
	; PRINTF32 `in 1st ul \n\x0`
	jmp no_place_ul

second_esi_ul:
	; PRINTF32 `in 2nd ul \n\x0`
	add esi, 4

	add [esi], ebx
	sub esi, 4
	xor ecx, ecx
	; mov ecx, [esi]

	; PRINTF32 `ECX from ESI: %d\n\x0`, ecx

	; xor ecx, ecx
	
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


	; mov dword [esi], dword 1
	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	; PRINTF32 `EBX for or: %d\n\x0`, ebx

	cmp ebx, 2147483648 ;2^31
	jg second_esi_ur

	; PRINTF32 `in 1st ur \n\x0`
	add [esi], ebx
	xor ecx, ecx

	jmp no_place_ur

second_esi_ur:
; PRINTF32 `in 2nd ur \n\x0`
	add esi, 4
	add [esi], ebx
	sub esi, 4
	xor ecx, ecx

	; mov ecx, [esi]

	; PRINTF32 `ECX from ESI: %d\n\x0`, ecx

	; xor ecx, ecx

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


	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	; PRINTF32 `EBX for or: %d\n\x0`, ebx

	cmp ebx, 2147483648 ;2^31
	jl second_esi_ll


	add [esi], ebx
	xor ecx, ecx

	jmp no_place_ll

second_esi_ll:
	add esi, 4
	add [esi], ebx
	xor ecx, ecx
	sub esi, 4

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


	mov ecx, eax
	mov ebx, 1

	shl ebx, cl

	; PRINTF32 `EBX for or: %d\n\x0`, ebx

	cmp ebx, 2147483648 ;2^31
	jl second_esi_lr


	add [esi], ebx
	xor ecx, ecx

	jmp no_place_lr

second_esi_lr:
	add esi, 4
	add [esi], ebx
	xor ecx, ecx
	sub esi, 4


no_place_lr:
	pop ebx
	pop eax

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY