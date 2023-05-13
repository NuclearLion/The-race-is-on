%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
   
    ;; Your code starts here


string_loop:
	mov al, [esi]

	add al, dl

	; check if the letter in al is smaller than 'Z'
	cmp al, 90

	jle smaller

	; if not, map it in A - Z
	sub al, 90
	add al, 64

; if it is / after mapping
smaller:
	; move the new letter in edi for output 
	mov byte [edi], al
	inc edi
	inc esi

	loop string_loop

    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
