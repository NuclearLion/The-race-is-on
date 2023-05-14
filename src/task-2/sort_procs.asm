%include "../include/io.mac"

struc proc ; proc_size = 5
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .text
    global sort_procs
	extern printf

sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

	;; Your code starts here
	mov esi, edx

	mov ecx, eax
	dec ecx

	xor eax, eax
	xor ebx, ebx

	mov eax, -1

for_i:
	inc eax ;inc after compare bcs i < n - 1
	
	; cmp eax, ecx
	; jge end
	cmp eax, ecx
	jge end

	; PRINTF32 `i= %d\n\x0`, eax

	mov edi, esi

	mov ebx, eax
	inc ebx

	push eax

for_j:
	; PRINTF32 `j= %d\n\x0`, ebx
	add edi, proc_size

	push ebx

	xor eax, eax
	xor ebx, ebx

	movzx eax, byte [esi + proc.prio]
	movzx ebx, byte [edi + proc.prio]

	; PRINTF32 `proc prio EAX: %d\n\x0`, eax
	; PRINTF32 `proc prio EBX: %d\n\x0`, ebx
    
	cmp eax, ebx

	jg swap
	jl next_j

	xor eax, eax
	xor ebx, ebx

	mov ax, [esi + proc.time]
	mov bx, [edi + proc.time]

	; PRINTF32 `proc time EAX: %d\n\x0`, eax
	; PRINTF32 `proc time EBX: %d\n\x0`, ebx

	cmp ax, bx

	jg swap
	jl next_j

	xor eax, eax
	xor ebx, ebx

	mov ax, [esi + proc.pid]
	mov bx, [edi + proc.pid]

	; PRINTF32 `proc pid EAX: %d\n\x0`, eax
	; PRINTF32 `proc pid EBX: %d\n\x0`, ebx

	cmp ax, bx

	jg swap
	jl next_j

back:
	; PRINTF32 `after SWAP pid esi: %d\n\x0`, [esi + proc.pid]
	; PRINTF32 `after SWAP pid edi: %d\n\x0`, [edi + proc.pid]
next_j:
	xor ebx, ebx
	pop ebx
	inc ebx

	cmp ebx, ecx
	jle for_j

next_i:
	xor eax, eax
	pop eax

	add esi, proc_size

	cmp eax, ecx
	jl for_i

end:

    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

swap:
    ; Swap elements from the array given in edx and iterated using esi and edi
    ; PRINTF32 `IN SWAP\n\x0`
    xor eax, eax

    ; Save the values of the first struct (esi) in temporary variables
    push word [esi + proc.pid]    ; Save .pid value of first struct

    mov al, byte [esi + proc.prio]
    push eax    ; Save .prio value of first struct
    push word [esi + proc.time]   ; Save .time value of first struct

    xor eax, eax

    ; Copy the values of the second struct (edi) to the first struct (esi)
    mov ax, [edi + proc.pid]      ; Copy .pid value of second struct to ax
    mov [esi + proc.pid], ax      ; Store copied .pid value to first struct

    xor eax, eax

    mov al, byte [edi + proc.prio] ; Copy .prio value of second struct to al
    mov [esi + proc.prio], al     ; Store copied .prio value to first struct

    xor eax, eax

    mov ax, [edi + proc.time]     ; Copy .time value of second struct to ax
    mov [esi + proc.time], ax     ; Store copied .time value to first struct

    ; Restore the values of the first struct (esi) from the temporary variables
    pop word [edi + proc.time]    ; Restore .time value of first struct

    xor eax, eax

    pop eax                       ; Pop dword-sized value from the stack into eax
	mov [edi + proc.prio], al     ; Store restored .prio value to first struct

    pop word [edi + proc.pid]     ; Restore .pid value of first struct

    ; Continue to the next iteration
    jmp back