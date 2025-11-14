section .text
global sort
global get_words
extern qsort
extern strcmp

; int comparator(const void *a, const void *b)
comparator:
    push ebx
    push esi
    push edi
    ; a
    mov esi, [esp + 16]
    ; *a
    mov esi, [esi]
    ; b
    mov edi, [esp + 20]
    ; *b
    mov edi, [edi]

    ; i = 0
    mov eax, 0
    ; a[0]
    mov ebx, esi
calcul_lungime1:
    ; daca e null am ajuns la finalul cuvantului
    cmp byte [ebx], 0
    je calcul_lungime1_gata
    ; i++
    add eax, 1
    ; urmatorul caracter
    add ebx, 1
    jmp calcul_lungime1
calcul_lungime1_gata:
    ; i = lungimea primului cuvant
    push eax
    ; i = 0
    mov eax, 0
    ; a[0]
    mov ebx, edi
calcul_lungime2:
    ; daca e null am ajuns la finalul cuvantului
    cmp byte [ebx], 0
    je calcul_lungime2_gata
    ; i++
    add eax, 1
    ; urmatorul caracter
    add ebx, 1
    jmp calcul_lungime2
calcul_lungime2_gata:
    ; lungimea primului cuvant
    pop ebx
    ; compar lungimile
    cmp ebx, eax
    jl mai_mic
    jg mai_mare
egale:
    push edi
    push esi
    call strcmp
    ; curat stiva
    add esp, 8
    jmp final
mai_mic:
    ; returneaza -1
    mov eax, -1
    jmp final
mai_mare:
    ; returneaza 1
    mov eax, 1
final:
    pop edi
    pop esi
    pop ebx
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    ; void qsort(void base[.size * .n], size_t n, size_t size, typeof(int (const void [.size], const void [.size])) *compar);
    ; functia de comparare
    push comparator
    ; size
    push dword [ebp+16]
    ; n = number_of_words
    push dword [ebp+12]
    ; base = vectorul words
    push dword [ebp+8]
    call qsort
    ; curat stiva
    add esp, 16
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    push ebx
    push esi
    push edi
    ; s
    mov esi, [ebp + 8]
    ; words
    mov edi, [ebp + 12]
    ; number_of_words
    mov ecx, [ebp + 16]
    ; i (numarul de cuvinte)
    mov ebx, 0
inceputul_cuvantului:
    ; inceputul cuvantului
    mov [edi + ebx*4], esi
    ; i++
    add ebx, 1
    ; i>= number_of_words
    cmp ebx, ecx
    jge gata
caut_finalul_cuvantului:
    ; urmatorul caracter
    add esi, 1
    mov al, [esi]
    ; daca e null am ajuns la finalul sirului
    cmp al, 0
    je gata
    call verifica_delimitator
    jne caut_finalul_cuvantului
    ; marchez finalul cuvantului
    mov byte [esi], 0
    ; urmatprul caracter
    add esi, 1
    ; trec la urmatorul cuvant sarind peste delimitator
.skip_delimiters:
    mov al, [esi]
    call verifica_delimitator
    jne inceputul_cuvantului
    ; in caz de sunt mai multe spatii/ virgule
    add esi, 1
    jmp .skip_delimiters
gata:
    ; numarul de cuvinte
    mov eax, ebx
    pop edi
    pop esi
    pop ebx
    leave
    ret
; functie auxiliara pentru a testa daca este delimitator
verifica_delimitator:
    cmp al, ' '
    je .yes
    cmp al, ','
    je .yes
    cmp al, '.'
    je .yes
    cmp al, '\n'
    je .yes
.yes:
    ret