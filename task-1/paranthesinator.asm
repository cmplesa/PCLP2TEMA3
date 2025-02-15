; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .data

section .text
global check_parantheses
check_parantheses:
    ; Inițializează cadru de stivă
    push ebp
    mov ebp, esp
    ; Rezervă spațiu pe stivă
    sub esp, 1024               

    ; Ia adresa stringului de la argumente
    mov edi, [ebp + 8]         
    ; Inițializează contorii
    xor edx, edx                
    xor ecx, ecx

check_loop:
    ; Încarcă caracterul curent
    mov al, [edi + ecx]              
    ; Verifică dacă este sfârșitul stringului
    cmp al, 0                   
    je end_check   

    ; Verifică dacă caracterul este '('
    cmp al, 40
    je push_open
    ; Verifică dacă caracterul este '['
    cmp al, 91
    je push_open
    ; Verifică dacă caracterul este '{'
    cmp al, 123
    je push_open

    ; Verifică dacă caracterul este ')'
    cmp al, 41
    je pop_rotund
    ; Verifică dacă caracterul este ']'
    cmp al, 93
    je pop_patrat
    ; Verifică dacă caracterul este '}'
    cmp al, 125
    je pop_acolada

    ; Mergi la următorul caracter
    jmp next_char

push_open:
    ; Pune paranteza deschisă pe stivă
    mov [esp + edx], al         
    ; Incrementeză indexul stivei
    add edx, 1                    
    ; Mergi la următorul caracter
    jmp next_char

pop_rotund:
    ; Decrementeză indexul stivei
    sub edx, 1                    
    ; Verifică dacă indexul este negativ, neconcordant
    js mismatch                 
    ; Verifică dacă vârful stivei este '('
    cmp byte [esp + edx], 40
    jne mismatch                
    ; Mergi la următorul caracter
    jmp next_char

pop_patrat:
    ; Decrementeză indexul stivei
    sub edx, 1                     
    ; Verifică dacă indexul este negativ, neconcordant
    js mismatch                 
    ; Verifică dacă vârful stivei este '['
    cmp byte [esp + edx], 91
    jne mismatch                
    ; Mergi la următorul caracter
    jmp next_char

pop_acolada:
    ; Decrementeză indexul stivei
    sub edx, 1                    
    ; Verifică dacă indexul este negativ, neconcordant
    js mismatch                 
    ; Verifică dacă vârful stivei este '{'
    cmp byte [esp + edx], 123
    jne mismatch                
    ; Mergi la următorul caracter
    jmp next_char

next_char:
    ; Mergi la următorul caracter
    add ecx, 1                    
    ; Continuă bucla de verificare
    jmp check_loop

end_check:
    ; Verifică dacă stiva este goală
    cmp edx, 0                  
    ; Dacă da, parantezele sunt echilibrate
    je balanced                 
    ; Altfel, există o neconcordantă
    jmp mismatch

balanced:
    ; Returnează 0 pentru echilibrat
    xor eax, eax                 
    ; Termină funcția
    jmp end_func

mismatch:
    ; Setează flag de eroare
    xor eax, eax
    ; Returnează 1 pentru neconcordantă     
    add eax, 1              
    ; Termină funcția
    jmp end_func               

end_func:
    ; Restaurează cadru de stivă și întoarce
    leave
    ret
