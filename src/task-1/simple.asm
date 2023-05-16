; Copyrigth (c) 2023, <Dan-Dominic Staicu>

section .text
    global simple

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


string_loop: ; loop for the length of the string
	mov al, [esi] ; move the letter in al

	add al, dl ; add the step to the letter

	; check if the letter in al is smaller than 'Z'
	cmp al, 90

	jle smaller ; if it is, move it in edi for output

	; if not, map it in A - Z
	sub al, 90
	add al, 64

; if it is / after mapping
smaller:
	; move the new letter in edi for output 
	mov byte [edi], al ; move the letter in edi for output
	inc edi ; move to the next letter in edi
	inc esi ; move to the next letter in esi

	loop string_loop ; loop for the length of the string

    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
