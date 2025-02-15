%include "../include/io.mac"

; The `expand` function returns an address to the following type of data
; structure.
struc neighbours_t
    .num_neighs resd 1  ; The number of neighbours returned.
    .neighs resd 1      ; Address of the vector containing the `num_neighs` neighbours.
                        ; A neighbour is represented by an unsigned int (dword).
endstruc
section .bss
; Vector for keeping track of visited nodes.
visited resd 10000
global visited

section .data
; Format string for printf.
fmt_str db "%u", 10, 0

section .text
global dfs
extern printf

; C function signiture:
;   void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
; where:
; - node -> the id of the source node for dfs.
; - expand -> pointer to a function that takes a node id and returns a structure
; populated with the neighbours of the node (see struc neighbours_t above).
;
; note: uint32_t is an unsigned int, stored on 4 bytes (dword).
dfs:
    ; Salvarea valorii vechiului pointer de bază
    push ebp
    ; Setarea noului pointer de bază la vârful stivei
    push esp
    pop ebp
    ; Salvarea registrelor
    push edi
    push esi
    push ebx
    ; Alocarea a 16 bytes de spațiu local pe stivă
    sub esp, 16

    ; Mutarea argumentelor pe stivă pentru acces mai ușor
    push ebp
    ; adăugarea a 8 pentru a ajunge la al doilea argument
    add ebp, 8
    ; Încărcarea primului argument (indexul nodului) în ebx
    mov ebx, dword [ebp]
    ; adăugarea a 4 pentru a ajunge la al doilea argument
    add ebp, 4
    ; Încărcarea celui de-al doilea argument (pointerul funcției expand) în edi
    mov edi, dword [ebp]
    pop ebp
    ; Marcarea nodului ca vizitat în array-ul de vizitați
    mov dword [visited + ebx * 4], 1

    ; Afișarea indexului nodului curent
    push ebx
    push fmt_str
    call printf
    ; Curățarea stivei după apelul printf
    add esp, 8

    ; Pregătirea indexului nodului pentru apelul funcției
    mov [esp], ebx
    xor ebx, ebx
    ; Apelul funcției expand
    call edi

    ; Verificarea numărului de vecini
    mov ecx, dword [eax] 
    mov esi, eax
    ; Verificarea dacă numărul de vecini este diferit de zero
    cmp ecx, 0
    jl for_loop
    jg for_loop
    ; Dacă nu are vecini, se termină funcția
    jmp end

init:
    ; Incrementarea indexului vecinului
    add ebx, 1
    ; Verificarea dacă toți vecinii au fost procesați
    cmp dword [esi], ebx
    jl end
    je end

for_loop:
    ; Extrage informațiile despre vecin din array-ul de vecini
    mov eax, dword [esi + 4]
    ; Încărcarea vecinului în ecx
    mov ecx, dword [eax + ebx * 4]
    ; Verificarea dacă vecinul a fost vizitat
    mov eax, dword [visited + ecx * 4]
    ; compararea cu 0
    cmp eax, 0
    jl init
    jg init

    ; Prepararea pentru apelul recursiv
    add ebx, 1
    ; Salvarea valorilor pe stivă
    mov dword [esp + 4], edi
    mov dword [esp], ecx
    ; Apelul recursiv al funcției dfs
    call dfs
    ; Verificarea dacă mai sunt vecini de procesat
    cmp dword [esi], ebx
    ja for_loop

end:
    ; Restaurarea spațiului local pe stivă
    add esp, 16

    ; Restaurarea registrelor
    pop ebx
    pop esi
    pop edi

    ; Încheierea funcției și revenirea la caller
    leave
    ret