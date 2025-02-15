; qsort

; subtask 1 - qsort

section .text
    global quick_sort
    ;; no extern functions allowed

quick_sort:
    ; create the new stack frame
    enter 0, 0
    ; create the new stack frame
    enter 0, 0
    push ebx
    push esi
    push edi

    mov esi, dword [ebp + 0xC] 
    mov eax, dword [ebp + 0x10] 
    mov ebx, dword [ebp + 0x14]
    ; calculam pivotul
    mov edi, dword [esi + ebx * 4] 
    mov ecx, eax
    mov edx, eax

    cmp eax, ebx 
    jge finish_qsort

    push eax 

for:
    ; comapr elementul elementul de la indexul din edx cu pivotul
    mov eax, dword [esi + edx * 4]
    cmp edi, eax
    jle if

    push edi
    mov edi , dword [esi + ecx * 0x4]
    mov dword [esi + edx * 0x4], edi
    mov dword [esi + ecx * 0x4], eax
    pop edi
    ; incrementez ecx pentru a urmari poz curenta in partea stângă a array-ului pe care îl sortați
    add ecx, 1

if:
    ; Incrementarea pointerului din partea dreaptă
    add edx, 1
    cmp ebx, edx
    jge for

    mov eax, dword [esi + ecx * 0x4]
    mov dword [esi + ebx * 0x4], eax
    mov dword [esi + ecx * 0x4], edi
    push ecx
    pop edx

end_partition:
    pop eax

    ; pregatesc args pentru apelul recursiv
    sub edx, 1 
    push edx 
    push eax 
    push esi 
    call quick_sort
    add esp, 0xC

    push ebx
    ; pregatesc args pentru apelul recursiv
    add edx, 1
    push edx 
    push esi

    call quick_sort
    add esp, 0xC
    jmp finish_qsort


finish_qsort:
    pop edi
    pop esi
    pop ebx
    pop ebp

    leave
    ret