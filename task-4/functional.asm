; Interpretează ca cod pe 64 de biți
[bits 64]

; nu uitați să scrieți în feedback că doreați
; assembly pe 64 de biți

section .text
global map
global reduce

map:
    ; Setează cadrul stivei
    enter   0, 0          

    push    rdi
    pop     r8
    push    rbx
    xor     rbx, rbx
loop_start:
    ; Compară contorul cu dimensiunea array-ului
    cmp     rbx, rdx                 
    ; Dacă contorul >= dimensiunea, termină bucla
    jge     loop_end                 

    ; Încarcă elementul curent al array-ului
    mov     rdi, qword [rsi] 
    ; Apelează pointer-ul funcției
    call    rcx
    add     rsi, 8                     
    ; Stochează rezultatul înapoi în array
    mov     qword [r8 + rbx*8], rax   
    ; Incrementează contorul
    inc     rbx                       
    ; Sare înapoi la începutul buclei
    jmp     loop_start                

loop_end:
    pop     rbx
    leave                        
    ret                           

; int reduce(int *dst, int *src, int n, int acc_init, int(*f)(int, int));
; int f(int acc, int curr_elem);
reduce:
    ; Setează cadrul stivei
    enter   0, 0                  
    ; Mută argumentele funcției în registre
    push    rsi
    pop     r12
    push    rdx
    pop     r10

reduce_loop:
    ; Verifică dacă mai sunt elemente rămase
    cmp     r10, 0                
    ; Dacă nu mai sunt elemente, ieși din buclă
    je      reduce_exit           
    mov     rdi, rcx             
    ; Încarcă elementul curent al array-ului
    mov     rsi, qword [r12]      
    ; Apelează pointer-ul funcției
    call    r8                 
    ; Treci la următorul element din array-ul sursă
    add     r12, 8               
    push    rax
    ; Actualizează acumularea cu rezultatul apelului funcției
    pop     rcx                   
    ; Decrementează contorul
    dec     r10                   
    ; Sare înapoi la începutul buclei
    jmp     reduce_loop           

reduce_exit:
    leave                         
    ret                           
