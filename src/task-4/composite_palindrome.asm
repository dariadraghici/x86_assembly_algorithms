section .text
global check_palindrome
global composite_palindrome
extern malloc, strcmp, free

check_palindrome:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    ; str
    mov esi, [ebp+8]
    ; len
    mov ecx, [ebp+12]
    ; daca sirul este null sau doar un caracter atunci e palindrom
    cmp ecx, 1
    jle este_palindrom
    ; pointer la inceputul sirului
    mov edi, esi
    ; pointer la sfarsitul sirului
    lea edx, [esi + ecx - 1]
while:
    ; caracterul din stanga
    mov al, [edi]
    ; compar cu caracterul din dreapta
    cmp al, [edx]
    jne nu_este_palindrom
    ; umratorul caracter din stanga
    add edi, 1
    ; urmatorul caracter din dreapta (cel anterior)
    sub edx, 1
    ; daca s au intersectat sau stanga > dreapta este palindrom
    cmp edi, edx
    jle while
este_palindrom:
    ; daca este returnez 1
    mov eax, 1
    jmp gata
nu_este_palindrom:
    ; daca nu este returnez 0
    mov eax, 0
gata:
    leave
    ret



composite_palindrome:
    ; create a new stack frame
    enter 0, 0
    push ebx
    push esi
    push edi
    ; aloc saptiu pentru 4 variabile locale: sir_bun, lungime_sir_bun, curent, aux
    sub esp, 16
    ; initializez sir_bun cu NULL
    mov dword [ebp - 4], 0
    ; lungime_sir_bun = 0
    mov dword [ebp - 8], 0
    ; initializez o masca de biti cu 1 pentru a genera toate submultimile
    mov ebx, 1
genereaza_submultimi:
    ; caluculez 1 << numar_de_subsiruri
    mov eax, 1
    ; shl/shr se uita strict la byte-ul de jos al registrului ecx (8-bit Low)
    mov cl, [ebp + 12]
    ; eax = 1 << numar_de_subsiruri
    shl eax, cl
    ; compar masca curent cu limita maxima
    cmp ebx, eax 
    jge gata_submultimi
    ; lungimea_totala (pentru concatenare)
    mov ecx, 0
    ; i = 0
    mov esi, 0
calcul_lungime:
    ; compar i cu numar_de_subsiruri
    cmp esi, [ebp + 12]
    jge lungime_calculata
    mov eax, ebx
    ; initializez masca edx cu 1
    mov edx, 1
    ; salvez lungimea_totala
    push ecx
    ; ecx = i
    mov ecx, esi
    ; edx = 1 << i
    shl edx, cl
    pop ecx
    ; verific daca bitul i este setat
    and eax, edx
    ; daca nu e setat trec la urmatorul
    cmp eax, 0
    je sar_peste
    ; vectorul de subsiruri
    mov edi, [ebp + 8]
    ; subsir[i]
    mov edi, [edi + esi*4]
    ; lungime_subsir[i]=0
    mov eax, 0
calcul_lungime_subsir:
    ; daca am ajuns la NULL am terminat de calculat lungimea subsirului i
    cmp byte [edi], 0
    je gata_lungime_subsir
    ; lungime_subsir[i]++
    add eax, 1
    ; urmatorul caracter
    add edi, 1
    jmp calcul_lungime_subsir
gata_lungime_subsir:
    ; lungime_totala = lungime_totala + lungime_subsir[i]
    add ecx, eax
sar_peste:
    ; i++
    add esi, 1
    jmp calcul_lungime
lungime_calculata:
    ; compar lungime_totala cu lungime_sir_bun
    cmp ecx, [ebp - 8]
    ; daca e mai mica nu mai calculez
    jl urmatoarea_submultime
    ; lungime_totala = lungime_totala + 1 (pentru terminatorul null)
    lea eax, [ecx + 1]
    ; aloc spatiu pentru sirul bun
    push eax
    call malloc
    ; curat stiva
    add esp, 4
    ; curent
    mov [ebp - 12], eax
    ; initializez terminatorul null
    mov byte [eax], 0
    ; i = 0
    mov esi, 0
verific_daca_fac_concatenare:
    ; daca i >= numar_de_subsiruri am terminat concatenarea
    cmp esi, [ebp + 12]
    jge nu_mai_fac_concatenare
    ; eax = masca curenta
    mov eax, ebx
    ; initializez masca edx cu 1
    mov edx, 1
    ; salvez lungime_totala
    push ecx
    ; ecx = i
    mov ecx, esi
    ; edx = 1 << i
    shl edx, cl
    ; restaurez lungime_totala
    pop ecx
    ; verific daca bitul i este setat
    and eax, edx
    ; daca nu e setat trec la urmatorul
    cmp eax, 0
    je nu_concatena
concatenare:
    ; vectorul de subsiruri
    mov edi, [ebp + 8]
    ; subsir[i]
    mov eax, [edi + esi*4]
    ; concatenare subsir[i] si curent
    push esi
    push edi
    ; esi = subsir[i]
    mov esi, eax
    ; edi = curent
    mov edi, [ebp - 12]
final_subsir_curent:
    ; daca am ajuns la terminatorul null
    cmp byte [edi], 0
    ; copiez subsir[i] in curent
    je copiez_subsir_i
    ; urmatorul caracter
    add edi, 1
    jmp final_subsir_curent
copiez_subsir_i:
    ; caracterul din subsir[i]
    mov al, [esi]
    ; pun la finalul curentului
    mov [edi], al
    ; compar cu null
    cmp al, 0
    je gata_copiere
    ; urmatorul caracter din subsir[i]
    add esi, 1
    ; urmatorul caracter din curent
    add edi, 1
    jmp copiez_subsir_i
gata_copiere:
    ; este concatenat
    pop edi
    pop esi
nu_concatena:
    ; i++
    add esi, 1
    jmp verific_daca_fac_concatenare
nu_mai_fac_concatenare:
    push esi
    ; curent
    mov esi, [ebp - 12]
    ; lungime_curent
    mov eax, 0
calcul_lungime_curent:
    ; daca e null am terminat de calculat
    cmp byte [esi + eax], 0
    je lungime_curent_calculata
    ; lungime_curent++
    add eax, 1
    jmp calcul_lungime_curent
lungime_curent_calculata:
    ; aux = lungime_curent
    mov [ebp - 16], eax
    ; lungime_curent
    push eax
    ; curent
    push dword [ebp - 12]
    call check_palindrome
    ; curat stiva
    add esp, 8
    ; verific daca e palindrom
    cmp eax, 0
    je nu_e_palindrom
    ; lungime_curent
    mov eax, [ebp - 16]
    ; verific daca e mai mare decat lungime_sir_bun
    cmp eax, [ebp - 8]
    jl nu_e_mai_buna
    jg e_mai_buna
    ; daca n a mai fost niciun sir_bun pana acum
    cmp dword [ebp - 4], 0
    je e_mai_buna
fac_comparatia:
    ; compar curent cu sir_bun
    push dword [ebp - 4]
    ; curent
    push dword [ebp - 12]
    call strcmp
    ; curat stiva
    add esp, 8
    ; daca sunt egale sau sir_bun e mai bun decat curent
    cmp eax, 0
    jge nu_e_mai_buna
e_mai_buna:
    ; compar sir_bun cu NULL
    cmp dword [ebp - 4], 0
    je nu_trebuie_eliberat
    ; sir_bun
    push dword [ebp - 4]
    call free
    ; curat stiva
    add esp, 4
nu_trebuie_eliberat:
    ; eax = curent
    mov eax, [ebp - 12]
    ; sir bun = curent
    mov [ebp - 4], eax
    ; eax = lungime_curent
    mov eax, [ebp - 16]
    ; lungime_sir_bun = lungime_curent
    mov [ebp - 8], eax
    jmp urmatoarea_submultime
nu_e_mai_buna:
nu_e_palindrom:
    ; eliberez memoria pentru curent
    push dword [ebp - 12]
    call free
    ; curat stiva
    add esp, 4
urmatoarea_submultime:
    ; masca curenta + 1
    add ebx, 1
    jmp genereaza_submultimi
gata_submultimi:
    ; compar sir_bun cu NULL
    cmp dword [ebp - 4], 0
    jne rezultat
    ; aloc spatiu pentru terminatorul null
    push 1
    call malloc
    ; curat stiva
    add esp, 4
    ; null
    mov byte [eax], 0
    ; pun null la final
    mov [ebp - 4], eax
rezultat:
    ; eax = sir bun
    mov eax, [ebp - 4]
    ; eliberez memoria alocata pentru cele 4 variabile locale
    add esp, 16
    pop edi
    pop esi
    pop ebx
    leave
    ret