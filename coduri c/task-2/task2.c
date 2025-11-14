#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int comparator(const void *a, const void *b)
{
    char *pointer_cuvant_1;
    char *pointer_cuvant_2;
    int valoare_auxiliara;
    char *iterator_caracter;

    pointer_cuvant_1 = *(char **)a;
    pointer_cuvant_2 = *(char **)b;

    valoare_auxiliara = 0;
    iterator_caracter = pointer_cuvant_1;
calcul_lungime1:
    if (*iterator_caracter == 0)
        goto calcul_lungime1_gata;
    valoare_auxiliara++;
    iterator_caracter++;
    goto calcul_lungime1;
calcul_lungime1_gata:
    int lungime_primul_cuvant = valoare_auxiliara;

    valoare_auxiliara = 0;
    iterator_caracter = pointer_cuvant_2;
calcul_lungime2:
    if (*iterator_caracter == 0)
        goto calcul_lungime2_gata;
    valoare_auxiliara++;
    iterator_caracter++;
    goto calcul_lungime2;
calcul_lungime2_gata:
    int lungime_al_doilea_cuvant = valoare_auxiliara;

    if (lungime_primul_cuvant < lungime_al_doilea_cuvant)
        goto mai_mic;
    if (lungime_primul_cuvant > lungime_al_doilea_cuvant)
        goto mai_mare;
egale:
    valoare_auxiliara = strcmp(pointer_cuvant_1, pointer_cuvant_2);
    goto final;
mai_mic:
    valoare_auxiliara = -1;
    goto final;
mai_mare:
    valoare_auxiliara = 1;
final:
    return valoare_auxiliara;
}

void sort(char **words, int number_of_words, int size)
{
    qsort(words, number_of_words, size, comparator);
}


int verifica_delimitator(char caracter_testat)
{
    if (caracter_testat == ' ')
        goto da;
    if (caracter_testat == ',')
        goto da;
    if (caracter_testat == '.')
        goto da;
    if (caracter_testat == '\n')
        goto da;
    return 1;
da:
    return 0;
}

int get_words(char *s, char **words, int number_of_words)
{
    char *pointer_curent_sursa = s;
    char **destinatie_cuvinte = words;
    int numar_cuvinte_permise = number_of_words;
    int contor_cuvinte_extrase = 0;

inceputul_cuvantului:
    if (contor_cuvinte_extrase >= numar_cuvinte_permise)
        goto gata;
    destinatie_cuvinte[contor_cuvinte_extrase] = pointer_curent_sursa;

    contor_cuvinte_extrase++;
    if (contor_cuvinte_extrase >= numar_cuvinte_permise)
        goto gata;

caut_finalul_cuvantului:
    pointer_curent_sursa++;
    char caracter_citit = *pointer_curent_sursa;

    if (caracter_citit == 0)
        goto gata;

    if (verifica_delimitator(caracter_citit) != 0)
        goto caut_finalul_cuvantului;

    *pointer_curent_sursa = 0;
    pointer_curent_sursa++;

salt_peste_delimitatori:
    caracter_citit = *pointer_curent_sursa;

    if (verifica_delimitator(caracter_citit) != 0)
        goto inceputul_cuvantului;

    pointer_curent_sursa++;
    goto salt_peste_delimitatori;

gata:
    return contor_cuvinte_extrase;
}

int main()
{
    int n;

    while (getchar() != '\n')
        ;

    scanf("%d", &n);
    char buffer_intrare[1000];
    char **cuvinte;
    cuvinte = (char **)malloc(sizeof(char *) * n);
    fgets(buffer_intrare, sizeof(buffer_intrare), stdin);
    buffer_intrare[strcspn(buffer_intrare, "\n")] = 0;
    int cuvinte_gasite_efectiv = get_words(buffer_intrare, cuvinte, n);
    sort(cuvinte, cuvinte_gasite_efectiv, sizeof(char *));

    for (int i = 0; i < cuvinte_gasite_efectiv; ++i)
        printf("%s\n", cuvinte[i]);

    return 0;
}