; Copyrigth (c) 2023, <Dan-Dominic Staicu>

struc avg
	.quo resw 1 ; quotient
	.remain resw 1 ; remainder
endstruc

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0

section .text
    global run_procs

run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY
   
    ;; Your code starts here

	mov esi, ecx ; processes
	mov edi, eax ; proc_avg
	mov ecx, ebx ; length

loop_procs: ; loop through all processes
	xor eax, eax
	xor edx, edx

	movzx eax, byte [esi + proc.prio] ; priority of current struc
	movzx edx, word [esi + proc.time] ; time of current element

	dec eax ; decrement prio to get index in result array

	add dword [prio_result + eax * 4], dword 1 ; inc cnt strucs with same prio
	add dword [time_result + eax * 4], edx ; add time to total time
	
	add esi, proc_size ; next process

	loop loop_procs ; loop until all processes are done

	mov ecx, 5 ; length of result arrays

	xor eax, eax 
	xor ebx, ebx

	xor edx, edx ; index in result array

set_results:
	push edx ; save index

	xor eax, eax 
	xor ebx, ebx

	mov eax, dword [time_result + edx * 4] ; total time
	mov ebx, dword [prio_result + edx * 4] ; cnt of strucs with same prio

	xor edx, edx ; clear edx before div

	cmp ebx, 0 ; check if no strucs with same prio
	je no_div ; if so, jump to no_div because of div by 0

	div ebx ; eax = total time / cnt of strucs with same prio

	mov [edi + avg.quo], ax ; save result
	mov [edi + avg.remain], dx ; save remainder

next_step:
	xor edx, edx
	pop edx ; restore index
	inc edx ; inc index

	add edi, avg_size ; next avg struct

	loop set_results ; loop until all results are set
	
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

no_div: ; no strucs with same prio
	mov [edi + avg.quo], word 0 ; set result to 0
	mov [edi + avg.remain], word 0 ; set remainder to 0

	jmp next_step ; jump back to next step