%include "../include/io.mac"

    ;;
    ;;   TODO: Declare 'avg' struct to match its C counterpart
    ;;

struc avg
	.quo resw 1
	.remain resw 1
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
	extern printf

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

	mov esi, ecx
	mov edi, eax
	mov ecx, ebx



loop_procs:
	xor eax, eax
	xor edx, edx

	movzx eax, byte [esi + proc.prio] ; priority of current struc
	movzx edx, word [esi + proc.time] ; time of current element

	dec eax

	; PRINTF32 `proc.prio: %d\n\x0`, eax
	; PRINTF32 `proc.time: %d\n\x0`, edx

	add dword [prio_result + eax * 4], dword 1 ; inc count of strucs with same prio
	add dword [time_result + eax * 4], edx
	
	add esi, proc_size

	loop loop_procs



;;----print results------

; mov ecx, 5


;;----print results------

	mov ecx, 5

	xor eax, eax 
	xor ebx, ebx

	xor edx, edx ; index in result array

set_results:
	; PRINTF32 `EDX(index): %d\n\x0`, edx
	push edx

	xor eax, eax 
	xor ebx, ebx

	mov eax, dword [time_result+ edx * 4]
	mov ebx, dword [prio_result + edx * 4]

	xor edx, edx

	cmp ebx, 0
	je no_div

	div ebx


	mov [edi + avg.quo], ax
	mov [edi + avg.remain], dx

next_step:
	xor edx, edx

	pop edx
	inc edx

	add edi, avg_size

	loop set_results
	
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

no_div:
	; PRINTF32 `DIV BY 0\n\x0`

	mov [edi + avg.quo], word 0
	mov [edi + avg.remain], word 0

	jmp next_step