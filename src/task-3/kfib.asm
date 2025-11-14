section .text
global kfib

kfib:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    ; suma
    push ebx
    ; i
    push esi
    ; n - i
    push edi
    ; n
    mov eax, [ebp + 8]
    ; K
    mov edx, [ebp + 12]

    cmp eax, edx
    jl mai_mic
    je egale

mai_mare:
    ; suma = 0
    mov ebx, 0
    ; esi = i = 1
    mov esi, 1

for:
    cmp esi, edx
    ; i > K
    jg loop_end

    ; edi = n
    mov edi, [ebp + 8] 
    ; edi = n - i
    sub edi, esi

    ; push K
    push edx
    ; push (n - i)
    push edi
    call kfib
    ; curat stiva
    add esp, 8

    ; suma = suma + kfib(n - i, K)
    add ebx, eax
    ; i++
    add esi, 1

    jmp for

loop_end:
    ; returnez suma
    mov eax, ebx
    jmp curat_stiva

mai_mic:
    ; Kfib = 0
    mov eax, 0
    jmp curat_stiva

egale:
    ; Kfib = 1
    mov eax, 1

curat_stiva:
    pop edi
    pop esi
    pop ebx
    leave
    ret