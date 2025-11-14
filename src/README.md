Aceasta reprezinta cea de-a treia tema la Iocla
Autor: Drăghici Daria-Ioana 312CC

Aceasta tema consta in 4 task-uri in care il ajutam pe Cosminel, o fire
pasionata de altfel, sa rezolve cateva probleme precum sortare si creare de
legaturi in liste simple inlantuite,

------------------------------------ TASK 1 ------------------------------------

    In acest task, Cosminel vrea sa sorteze un vector de noduri care formeaza o
lista simplu inlantuita nelegata initial. Fiecare nod are un camp val si un
pointer next (initial NULL). El (eu) trebuie sa implementeze functia sort care
sorteaza adresele nodurilor in functie de valoarea val, fara sa modifice ordinea
fizica a vectorului. In final, nodurile trebuie sa fie legate intre ele prin
campul next, in ordine crescatoare.

Rezolvare:
    Am scris un cod care implementeaza un algoritm de sortare a unui vector de
noduri folosind selection sort. Fiecare nod contine o valoare si un pointer catre
urmatorul nod, iar functia sort le reordoneaza astfel incat sa fie in ordine
crescatoare. Codul manipuleaza direct pointerii pentru a lega nodurile intre ele.
    Primul lucru pe care l-am facut a fost sa salvez valorile registrelor ebx,
esi, si edi, pentru a le putea folosi mai tarziu.
    Am trecut la initializarea variabilelor. La inceput, am incarcat valoarea n,
care reprezinta numarul de noduri din lista de noduri. Aceasta este valoarea
care mi-a fost transmisa ca argument (deci in [ebp + 8]) in functia sort. Apoi,
am incarcat adresa primului nod din lista de noduri folosind mov esi, [ebp + 12].
La fel, am setat valoarea edi la 1, ceea ce reprezenta valoarea curenta pe care o
cautam in lista de noduri. Am inceput de la 1 si am folosit acest numar pentru a
cauta nodurile intr-o ordine crescatoare. Registrul ebx l-am initializat cu 0,
iar acesta a fost folosit pentru a stoca adresa nodului anterior, pe care urma
sa-l conectez ulterior la nodul curent.
    Dupa ce am realizat aceste initializari, am inceput bucla principala de
cautare a nodurilor. Am setat eax pentru a pointa catre primul nod din lista
(mov eax, esi). Am folosit registrul ecx pentru a numara iteratiile buclei si am
inceput cu 0 (mov ecx, 0). La fiecare iteratie, am adaugat 1 la ecx, astfel incat
fiecare pas sa reprezinte o cautare a unui nod cu valoarea curenta. Am comparat
contorul cu n, iar daca ecx depasea n, inseamna ca am parcurs toate nodurile si
am ajuns la final, facand un jmp la eticheta gata, care marca sfarsitul sortarii.
    Daca nu am ajuns inca la sfarsitul listei, am citit din nou adresa primului
nod pentru a ma asigura ca bucla continua de la inceputul listei de noduri. Am
setat si contorul edx pentru a fi folosit in bucla interna, care cauta nodul cu
valoarea dorita. In aceasta bucla interna, am comparat valoarea stocata in nodul
curent (la adresa indicata de eax) cu valoarea cautata (stocata in ecx). Daca
gaseam nodul dorit, saream la eticheta nod_gasit. Daca nu, avansam pointerul la
urmatorul nod, presupunand ca fiecare nod ocupa 8 octeti.
    Cand gaseam nodul dorit, verificam daca valoarea cautata era chiar 1 (adica
primul nod). Daca era, salvasem adresa acestuia in registrul ebx si in variabila
locala, pentru a o putea returna mai tarziu. Daca nodul nu era primul, legam nodul
curent la nodul anterior. Practic, am stocat adresa nodului curent in campul next
al nodului anterior. Dupa aceea, actualizam ebx pentru a deveni nodul curent, iar
la urmatoarea iteratie acest nod urma sa fie considerat "nodul anterior".
    La finalul sortarii, am setat campul next al ultimului nod la 0, semnalizand
sfarsitul listei. Am returnat adresa primului nod sortat, pentru a incheia procesul
de sortare. Am curatat stiva si am readus pointerul stivei (esp) la valoarea
initiala salvata in ebp si am terminat.

------------------------------------ TASK 2 ------------------------------------

    In acest task, Cosminel vrea sa prelucreze un text filozofic, separandu-l in
cuvinte folosind anumite delimitatoare, pentru a le sorta ulterior. Trebuie sa
implementezi doua functii: get_words si sort. unctia get_words  trebuie sa
analizeze textul si sa extraga cuvintele, folosind delimitatori precum: spatiu,
virgula, punct si newline. Dupa extragerea cuvintelor, ele vor fi stocate in
vectorul words, iar numarul total de cuvinte trebuie actualizat in number_of_words.
Functia sort trebuie sa sorteze cuvintele folosind functia qsort, mai intai dupa
lungimea acestora si, in caz de egalitate, in ordine lexicografica.

Rezolvare:
    In acest cod, am implementat trei functii principale pentru a rezolva cerinta.
Am folosit functia comparator pentru a permite functiei qsort sa compare doua 
cuvinte (doua adrese de cuvinte) si sa le ordoneze in functie de lungimea lor.
Daca doua cuvinte au aceeasi lungime, atunci le compar lexicografic. Incep prin
a salva registorii ebx, esi, si edi pe stiva. Adresele celor doua cuvinte de
comparat sunt stocate in registoarele esi si edi.
    Dupa aceea, am calculat lungimea fiecarui cuvant. Pentru cuvantul a, am
folosit un contor (eax) care parcurge fiecare caracter al cuvantului pana la
caracterul null (0). Analog si pentru cuvantul b. Astfel, am obtinut lungimile
celor doua cuvinte, pe care le-am comparat.
    Daca lungimea cuvantului a este mai mica decat lungimea cuvantului b, am
returnat -1, ceea ce inseamna ca a va fi plasat inaintea lui b in sortare. Daca
lungimea cuvantului a este mai mare, am returnat 1, astfel incat cuvantul b sa
fie plasat inaintea lui a. Daca lungimile sunt egale, am apelat functia strcmp
pentru a compara cele doua cuvinte lexicografic. Daca rezultatul acestei comparari
este pozitiv sau negativ, am returnat 1 sau -1, iar daca sunt egale, nu am facut
nicio schimbare.
    In functia sort am apelat functia qsort, care sorteaza vectorul de cuvinte.
Aici, pregatit parametrii necesari pentru qsort. In primul rand, am pregatit
parametrii pentru apelul functiei qsort: am dat push pe stiva functiei de
comparare (comparator), dimensiunea fiecarui cuvant (size), numarul de cuvinte
(number_of_words), si vectorul de cuvinte (words). Aceste informatii sunt
esentiale pentru functionarea corecta a qsort. Am apelat functia qsort, am
curatat stiva si am terminat functia sort.
    Functia get_words este folosita pentru a separa un text intr-un vector de
cuvinte, folosind delimitatori precum spatiu, virgula, punct si newline (\n).
Aceasta functie salveaza cuvintele intr-un vector de stringuri si returneaza
numarul total de cuvinte gasite. In primul rand, am creat un cadru de stiva
pentru a proteja registrele si pentru a putea lucra cu variabile locale.
Am inceput parcurgerea textului caracter cu caracter. La fiecare inceput de
cuvant, am salvat adresa cuvantului curent in vectorul words, iar la finalul
fiecarui cuvant, am marcat acel loc si am trecut la urmatorul cuvant.
    Am cautat finalul fiecarui cuvant, utilizand delimitatori (spatiu, virgula,
punct, newline). Atunci cand intalneam un astfel de caracter, marca finalul
cuvantului curent si treceam la urmatorul cuvant.
    Functia verifica_delimitator este folosita pentru a verifica daca un caracter
este un delimitator valid. Daca nu era un delimitator, continuam sa parcurgem
cuvantul. De asemenea, am sarit peste orice delimitatoare consecutive pentru a
evita problemele legate de multiple spatii sau virgule. Dupa ce toate cuvintele
au fost extrase din text, am returnat numarul total de cuvinte gasite.

------------------------------------ TASK 3 ------------------------------------
    Cosminel este de asemenea si un mare fan al sirului lui Fibonacci :). El vrea
sa implementez (eu) un sir KFib, o versiune extinsa a sirului lui Fibonacci, unde
fiecare termen este suma ultimilor K termeni anteriori, recursiv.

Rezolvare:
    Am inceput algoritmul salvand trei registre de uz general – ebx, esi si edi.
Dupa aceea, am citit parametrii functiei, astfel [ebp + 8] contine primul
parametru, adica n, iar [ebp + 12] il contine pe al doilea, K. Am extras valorile
si le-am pus in registre: n in eax, pentru ca in mod traditional eax este folosit
pentru a intoarce rezultatul unei functii, iar K in edx.
    Apoi am trecut la compararea acestor doua valori. Daca n este mai mic decat K,
trebuie sa returnez 0. Daca n era egal cu K trebuie sa returnez 1, iar daca n este
mai mare strict decat k, trebuie sa trec la logica recursiva.
    Pentru asta am initializat suma cu 0 in ebx, iar in esi am inceput de la
i = 1. Scopul meu era sa adun recursiv termenii anteriori, de la n - 1 pana la
n - K. Asa am intrat intr-o bucla for, in care i mergea de la 1 pana la K. 
Daca i ajunge sa fie mai mare decat K, ies din bucla, pentru ca mi-am adunat deja
toti termenii necesari.
    In interiorul buclei, pentru fiecare valoare a lui i, am calculat n - i. Am
pus aceasta valoare pe stiva impreuna cu K, iar apoi am apelat functia kfib
recursiv. Imediat dupa apel, am curatat stiva, si am adunat in ebx valoarea
returnata de apelul recursiv. Apoi am incrementat i si m-am intors la inceputul
buclei.
    Dupa ce am terminat toate iteratiile, am pus suma finala in eax si am curatat
stiva si am ajuns la finalul functiei

------------------------------------ TASK 4 ------------------------------------
    In acest task, Cosminel este pasionat de palindroame. El are un vector de N
cuvinte. Trebuie sa gaseasca cel mai lung palindrom care poate fi format prin
concatenarea unui subsir (o selectie ordonata, dar nu neaparat consecutiva) de
cuvinte din vector. Daca exista doua palindroame cu aceeasi lungime maxima, el
(eu) il alege pe cel care este mai mic lexicografic (adica ordonat alfabetic
dupa un criteriu standard).
    Task-ul este format deopotriva din 2 subtaskuri. Primul consta in
implementarea unei functii care verifica daca un sir este palindrom, iar al
doilea in implementarea unei functii care gaseste cel mai lung palindrom obtinut
prin concatenarea unui subsir de cuvinte, iar in caz de egalitate il alege pe
cel lexicografic minim

Subtaskul 1:
Functia check_palindrome:
    Am inceput aceasta functie prin a prelua parametrii: primul parametru, un
pointer catre sir, l-am pus in registrul esi, iar al doilea parametru, lungimea
sirului, l-am pus in ecx. Am comparat lungimea sirului cu 1 si, daca sirul are
lungimea 0 sau 1, am sarit direct la eticheta care indica faptul ca sirul este
palindrom. In continuare, am pus in edi pointerul la inceputul sirului
(mov edi, esi) si am calculat adresa ultimului caracter, pe care am pus-o in
edx. Apoi, am intrat intr-un ciclu while in care am comparat caracterele de la
pozitiile corespunzatoare din stanga si dreapta. Daca aceste caractere erau
diferite, am sarit la eticheta care semnala ca sirul nu este palindrom. In
interiorul ciclului, am mutat pointerul stang spre dreapta si pointerul drept
spre stanga, testand apoi daca cei doi pointeri s-au intersectat sau au trecut
unul de celalalt; daca nu, ciclul continua. La finalul buclei, daca nu am gasit
nicio diferenta, am setat rezultatul in eax la 1 (adevarat) si am sarit la
sfarsitul functiei pentru a returna. In schimb, in cazul in care caracterele
nu corespundeau, am sarit la eticheta nu_este_palindrom unde am setat rezultatul
in eax la 0 (fals). Astfel, am ajuns la finalul functiei, returnand rezultatul.

Substataskul 2:
Functia composite_palindrome:
    In aceasta functie am inceput prin a salva registrele ebx, esi si edi, apoi
am alocat spatiu pentru patru variabile locale, cate 4 bytes fiecare. Am
initializat variabila sir_bun cu NULL si lungime_sir_bun cu 0. De asemenea,
am initializat masca pentru submultimi cu valoarea 1.
    La eticheta genereaza_submultimi, am pus valoarea 1 in registrul eax si
numarul total de subsiruri in registrul cl. Am calculat limita maxima a mastii
prin deplasare la stanga cu numarul de subsiruri (1 << numar_de_subsiruri) si am
comparat masca curenta cu aceasta limita. Daca masca a depasit limita, am sarit
la finalul functiei. In continuare, am initializat variabila lungime_totala cu 0
si indexul i cu 0.
    In cadrul etichetei calcul_lungime, am comparat indexul i cu numarul de
subsiruri pentru a verifica daca am terminat de parcurs toate subsirurile. Daca
am terminat, am sarit la eticheta de dupa calculul lungimii. Daca nu, am copiat
masca in eax si am pus 1 in edx pentru testarea unui bit. Am salvat temporar
lungimea totala si am pus indexul curent in ecx. Am calculat 1 << i pentru a
verifica daca bitul corespunzator din masca este setat. Daca bitul nu este setat,
am sarit peste calculul pentru subsirul curent.
    Daca bitul este setat, am pus adresa vectorului de subsiruri in edi si am
accesat subsirul de la indexul i. Am initializat lungimea subsirului cu 0 si, in
eticheta calcul_lungime_subsir, am verificat daca am ajuns la terminatorul null
al subsirului. Daca da, am terminat calculul. Altfel, am marit lungimea
subsirului si am trecut la caracterul urmator, repetand pana la terminator.
    Dupa ce am calculat lungimea subsirului, am adaugat aceasta lungime la
lungimea totala. Am crescut indexul i si am continuat procesul de calcul al 
lungimii totale pentru toata masca.
    La eticheta lungime_calculata, am comparat lungimea totala cu lungimea celui
mai bun sir gasit pana acum. Daca lungimea totala este mai mica, am sarit la
urmatoarea submultime. In caz contrar, am adaugat 1 pentru terminatorul null si
am pus dimensiunea necesara pe stiva pentru a aloca memorie pentru concatenare.
Am apelat o functie pentru alocare si am curatat stiva dupa apel. Am salvat
pointerul alocat in variabila curent si am pus terminatorul null la inceputul
zonei alocate. Am initializat indexul i cu 0 pentru procesul de concatenare.
    In eticheta verific_daca_fac_concatenare, am comparat i cu numarul total de
subsiruri si, daca am terminat, am iesit din procesul de concatenare. Daca nu,
am pus masca curenta in eax, am pus 1 in edx si am calculat bitul corespunzator
pentru indexul i. Am verificat daca bitul este setat si, daca nu este, am sarit
la urmatorul subsir fara sa il concatenam.
    Daca bitul este setat, la eticheta concatenare, am pus adresa vectorului de
subsiruri in edi si am accesat subsirul curent. Am salvat registrele pentru
apeluri ulterioare si am pus pointerul subsirului in esi si pointerul curent de
concatenare in edi.
    In eticheta final_subsir_curent, am verificat daca am ajuns la terminatorul
subsirului curent. Daca nu, am copiat caracterul curent in sirul concatenat si
am mutat pointerii inainte, repetand pana cand am copiat tot subsirul. Dupa ce
am terminat copierea, am restaurat registrele edi si esi. Daca bitul nu era setat,
am sarit la eticheta nu_concatena unde am trecut la urmatorul subsir si am
continuat verificarea.
    Cand am terminat concatenarea pentru masca curenta, am pus pe stiva indexul
curent si pointerul la sirul concatenat, am initializat lungimea curenta cu 0 si
am inceput sa calculez lungimea sirului concatenat in calcul_lungime_curent. Am
parcurs sirul pana la terminator si am incrementat lungimea. Dupa ce am calculat
lungimea sirului concatenat, am pus lungimea si pointerul pe stiva si am apelat
functia check_palindrome pentru a verifica daca sirul este palindrom. Am curatat
stiva dupa apel si am verificat rezultatul. Daca sirul nu era palindrom, am sarit
la urmatoarea submultime. Daca era palindrom, am comparat lungimea cu lungimea
celui mai lung palindrom gasit pana atunci si, daca lungimea nu era mai mare, am
trecut la urmatoarea submultime.
    Daca noul sir palindrom este mai lung, am verificat daca exista deja un sir
salvat anterior. Daca da, am eliberat memoria ocupata de sirul vechi, curatand
stiva dupa apelul de eliberare. Apoi, am salvat pointerul catre noul sir
palindrom in eax, am actualizat variabila cu sirul cel mai bun si am actualizat
si lungimea maxima.
    La eticheta urmatoarea_submultime, am copiat masca submultimii curente, am
incrementat masca pentru urmatoarea submultime si am reluat procesul de generare
si procesare a submultimilor. In final, la eticheta gata_submultimi, am pus
pointerul catre cel mai lung palindrom gasit in eax pentru returnare, am eliberat
spatiul alocat pentru variabilele locale si am restaurat registrele salvate
(edi, esi, ebx) si am terminat functia.