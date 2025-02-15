binarysearch

; subtask 2 - bsearch
section .text
    global binary_search
    ;; no extern functions allowed
 ; in edx si ecx se pun primele argumente pt ca e fastcall
binary_search:
    ; create a new stack frame
    enter 0, 0
    push ebx 
    push esi
    push edi

    ; incarc registrii cu argumentele (startul)
    mov esi, [ebp + 8]
    ; incarc registrii cu argumentele (end)
    mov ebx, [ebp + 12]

    xor edi, edi
    xor eax, eax
    mov eax, esi
    push ecx
    push edx
    add eax, ebx
    xor edx, edx
    ; fac impartirea
    mov ecx, 2
    div ecx
    pop edx
    pop ecx
    xor edi, edi
    add edi, eax

    ; eax = buff[mijloc]
    mov eax, [ecx + edi * 4]

    cmp ebx, esi
    jl not_found

    cmp eax, edx
    jne continue
    jmp found

continue:

    jl search_right
    jg search_left

search_right:
    ; caut dreapta
    add edi, 1
    xor esi, esi
    add esi, edi

    push ebx
    push esi
    call binary_search
    pop esi
    pop ebx

    pop edi
    pop esi
    pop ebx
    leave
    ret

search_left:
    ; caut stanga
    sub edi, 1
    xor ebx, ebx
    add ebx, edi

    push ebx
    push esi
    call binary_search
    pop esi
    pop ebx

    pop edi
    pop esi
    pop ebx
    leave
    ret

found:
    ; am gasit si pun in eax pozitia
    mov eax, edi 
    jmp end_recursive

not_found:
    ; nu am gasit
    mov eax, -1

end_recursive:
    ;; restore the preserved registers
    pop edi
    pop esi
    pop ebx
    leave
    ret