; Copyrigth (c) 2023, <Dan-Dominic Staicu>

struc proc ; proc_size = 5
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .text
    global sort_procs

sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

	;; Your code starts here
	mov esi, edx ; esi = processes

	mov ecx, eax ; ecx = length
	dec ecx ; ecx = length - 1

	xor eax, eax 
	xor ebx, ebx

	mov eax, -1 ;

for_i: ; for (i = 0; i < n - 1; i++)
	inc eax ;inc after compare bcs i < n - 1
	
	cmp eax, ecx ; eax = i, ecx = n - 1
	jge end ; if i >= n - 1, end

	mov edi, esi ; edi = processes + i

	mov ebx, eax ; ebx = i
	inc ebx ; ebx = j = i + 1

	push eax ; save i

for_j: ; for (j = i + 1; j < n; j++)
	add edi, proc_size ; edi = processes + j

	push ebx ; save j

	xor eax, eax
	xor ebx, ebx

	movzx eax, byte [esi + proc.prio] ; eax = processes[i].prio
	movzx ebx, byte [edi + proc.prio] ; ebx = processes[j].prio
    
	cmp eax, ebx ; if processes[i].prio > processes[j].prio, swap

	jg swap ; if eax > ebx, swap
	jl next_j ; if eax < ebx, continue

	xor eax, eax
	xor ebx, ebx

	mov ax, [esi + proc.time] ; eax = processes[i].time
	mov bx, [edi + proc.time] ; ebx = processes[j].time

	cmp ax, bx ; if processes[i].time > processes[j].time, swap

	jg swap ; if eax > ebx, swap
	jl next_j ; if eax < ebx, continue

	xor eax, eax
	xor ebx, ebx

	mov ax, [esi + proc.pid] ; eax = processes[i].pid
	mov bx, [edi + proc.pid] ; ebx = processes[j].pid

	cmp ax, bx ; if processes[i].pid > processes[j].pid, swap

	jg swap ; if eax > ebx, swap
	jl next_j ; if eax < ebx, continue

next_j: ; j++
	xor ebx, ebx ;
	pop ebx ; ebx = j
	inc ebx ; ebx = j + 1

	cmp ebx, ecx ; if j < n - 1, continue
	jle for_j ; if ebx <= ecx, continue

next_i: ; i++
	xor eax, eax
	pop eax ; eax = i

	add esi, proc_size ; esi = processes + i

	cmp eax, ecx ; if i < n - 1, continue
	jl for_i ; if eax < ecx, continue

end: 
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

swap:
    ; Swap elements from the array given in edx and iterated using esi and edi
    xor eax, eax

    ; Save the values of the first struct (esi) in temporary variables
    push word [esi + proc.pid]    ; Save .pid value of first struct

    mov al, byte [esi + proc.prio]
    push eax    ; Save .prio value of first struct
    push word [esi + proc.time]; Save .time value of first struct

    xor eax, eax

    ; Copy the values of the second struct (edi) to the first struct (esi)
    mov ax, [edi + proc.pid] ; Copy .pid value of second struct to ax
    mov [esi + proc.pid], ax ; Store copied .pid value to first struct

    xor eax, eax

    mov al, byte [edi + proc.prio] ; Copy .prio value of second struct to al
    mov [esi + proc.prio], al ; Store copied .prio value to first struct

    xor eax, eax

    mov ax, [edi + proc.time] ; Copy .time value of second struct to ax
    mov [esi + proc.time], ax ; Store copied .time value to first struct

    ; Restore the values of the first struct (esi) from the temporary variables
    pop word [edi + proc.time] ; Restore .time value of first struct

    xor eax, eax

    pop eax ; Pop dword-sized value from the stack into eax
	mov [edi + proc.prio], al ; Store restored .prio value to first struct

    pop word [edi + proc.pid] ; Restore .pid value of first struct

    ; Continue to the next iteration
    jmp next_j