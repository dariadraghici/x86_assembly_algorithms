section .text
global sort

; struct node {
;    int val;
;    struct node* next;
; };

; struct node* sort(int n, struct node* node);
sort:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    ; edx = n
    mov edx, [ebp + 8]
    ; vectorul de noduri
    mov esi, [ebp + 12]
    ; primul nod este cel care are val=1
    ; edi este valoarea curenta pe care o caut
    mov edi, 1
    ; ebx = adresa nodului anterior
    mov ebx, 0
    ; parcurg vectorul de noduri cu eax pentru a gasi valorile in ordine (selection sort)
    mov eax, esi
    ; valoare curenta
    mov ecx, 0
caut_nod:
    ; valoarea curenta incepe la 1
    add ecx, 1
    ; i<=n
    cmp ecx, [ebp + 8]
    jg gata
    ; resetez eax la inceputul vectorului
    mov eax, [ebp + 12]
    ; edx = n
    ; il folosesc pe post de contor i
    mov edx, [ebp + 8]

for_i:
    ; compar nodul curent cu valoarea cautata
    cmp dword [eax], ecx
    je nod_gasit
    ; daca nu este trec la urmatorul nod
    add eax, 8
    ; i--
    sub edx, 1
    ; daca am ajuns la finalul vectorului am terminat
    cmp eax, 0
    jne for_i

nod_gasit:
    ; daca ecx este 1 este primul nod
    cmp ecx, 1
    jne leaga_nod
    ; ebx = primul nod
    mov ebx, eax
    ; stochez adresa primului nod pentru a returna la final
    mov [ebp - 4], eax
    jmp caut_nod

leaga_nod:
    ; anterior->next = curent
    mov [ebx + 4], eax
    ; anterior = curent
    mov ebx, eax
    jmp caut_nod

gata:
    ; ultimul nod trebuie sa aiba next = 0
    mov dword [ebx + 4], 0
    ; returnez adresa primului nod
    mov eax, [ebp - 4]

    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret