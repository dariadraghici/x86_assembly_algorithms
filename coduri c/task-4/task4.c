#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int check_palindrome(const char *sir_verificat, int lungime_sir)
{
    const char *pointer_inceput = sir_verificat;
    int lungime = lungime_sir;

    if (lungime <= 1)
        goto este_palindrom;

    const char *pointer_stanga = pointer_inceput;
    const char *pointer_dreapta = pointer_inceput + lungime - 1;

while_loop:
    char caracter_stanga = *pointer_stanga;
    if (caracter_stanga != *pointer_dreapta)
        goto nu_este_palindrom;
    pointer_stanga++;
    pointer_dreapta--;
    if (pointer_stanga <= pointer_dreapta)
        goto while_loop;

este_palindrom:
    int rezultat_palindrom = 1;
    goto gata;

nu_este_palindrom:
    rezultat_palindrom = 0;

gata:
    return rezultat_palindrom;
}

char *const composite_palindrome(const char *const *const array_subsiruri, const int numar_total_subsiruri)
{
    char *sir_bun = NULL;
    int lungime_sir_bun = 0;
    char *sir_curent_compus = NULL;
    int lungime_curenta_aux = 0;

    sir_bun = NULL;
    lungime_sir_bun = 0;

    int masca_submultime = 1;

genereaza_submultimi:
    int limita_masca = 1;
    limita_masca <<= numar_total_subsiruri;

    if (masca_submultime >= limita_masca)
        goto gata_submultimi;

    int lungime_totala_concatenare = 0;
    int index_subsir = 0;

calcul_lungime:
    if (index_subsir >= numar_total_subsiruri)
        goto lungime_calculata;

    int masca_curenta_bit = masca_submultime;
    int bit_verificat = 1;
    bit_verificat <<= index_subsir;

    if ((masca_curenta_bit & bit_verificat) == 0)
        goto sar_peste;
    const char *subsir_individual = array_subsiruri[index_subsir];

    int lungime_subsir_curent = 0;
calcul_lungime_subsir:
    if (*subsir_individual == 0)
        goto gata_lungime_subsir;
    lungime_subsir_curent++;
    subsir_individual++;
    goto calcul_lungime_subsir;
gata_lungime_subsir:
    lungime_totala_concatenare += lungime_subsir_curent;

sar_peste:
    index_subsir++;
    goto calcul_lungime;

lungime_calculata:
    if (lungime_totala_concatenare < lungime_sir_bun)
        goto urmatoarea_submultime;

    int dimensiune_alocare = lungime_totala_concatenare + 1;
    sir_curent_compus = (char *)malloc(dimensiune_alocare);
    if (sir_curent_compus == NULL)
        return NULL;
    sir_curent_compus[0] = 0;

    index_subsir = 0;

verific_daca_fac_concatenare:
    if (index_subsir >= numar_total_subsiruri)
        goto nu_mai_fac_concatenare;

    masca_curenta_bit = masca_submultime;
    bit_verificat = 1;
    bit_verificat <<= index_subsir;

    if ((masca_curenta_bit & bit_verificat) == 0)
        goto nu_concatena;

concatenare:
    const char *subsir_de_concatenat = array_subsiruri[index_subsir];

    char *pointer_final_curent = sir_curent_compus;
final_subsir_curent:
    if (*pointer_final_curent == 0)
        goto copiez_subsir_i;
    pointer_final_curent++;
    goto final_subsir_curent;

copiez_subsir_i:
    char caracter_copiat = *subsir_de_concatenat;
    *pointer_final_curent = caracter_copiat;
    if (caracter_copiat == 0)
        goto gata_copiere;
    subsir_de_concatenat++;
    pointer_final_curent++;
    goto copiez_subsir_i;
gata_copiere:

nu_concatena:
    index_subsir++;
    goto verific_daca_fac_concatenare;

nu_mai_fac_concatenare:
    int lungime_sir_curent_compus = 0;
    const char *temp_ptr_lungime = sir_curent_compus;
calcul_lungime_curent:
    if (temp_ptr_lungime[lungime_sir_curent_compus] == 0)
        goto lungime_curent_calculata;
    lungime_sir_curent_compus++;
    goto calcul_lungime_curent;
lungime_curent_calculata:
    lungime_curenta_aux = lungime_sir_curent_compus;

    // Apelul la check_palindrome este acum cu const char*
    int este_palindrom = check_palindrome(sir_curent_compus, lungime_sir_curent_compus);

    if (este_palindrom == 0)
        goto nu_e_palindrom;

    if (lungime_curenta_aux < lungime_sir_bun)
        goto nu_e_mai_buna;
    if (lungime_curenta_aux > lungime_sir_bun)
        goto e_mai_buna;

    if (sir_bun == NULL)
        goto e_mai_buna;

fac_comparatia:
    // `strcmp` accepta `const char*`, deci este compatibil
    int comparatie_lexicografica = strcmp(sir_curent_compus, sir_bun);
    if (comparatie_lexicografica >= 0)
        goto nu_e_mai_buna;

e_mai_buna:
    if (sir_bun != NULL)
        free(sir_bun);
nu_trebuie_eliberat:
    sir_bun = sir_curent_compus;
    lungime_sir_bun = lungime_curenta_aux;
    goto urmatoarea_submultime;

nu_e_mai_buna:
nu_e_palindrom:
    free(sir_curent_compus);

urmatoarea_submultime:
    masca_submultime++;
    goto genereaza_submultimi;

gata_submultimi:
    if (sir_bun == NULL)
    {
        sir_bun = (char *)malloc(1);
        if (sir_bun == NULL)
            return NULL;
        sir_bun[0] = 0;
    }
rezultat:
    return sir_bun;
}

int main()
{
    int numar_subsiruri;

    scanf("%d", &numar_subsiruri);

    while (getchar() != '\n')
        ;

    char **subsiruri_input = (char **)malloc(sizeof(char *) * numar_subsiruri);

    for (int i = 0; i < numar_subsiruri; ++i)
    {
        char buffer_linie[256];
        fgets(buffer_linie, sizeof(buffer_linie), stdin);
        buffer_linie[strcspn(buffer_linie, "\n")] = 0;

        subsiruri_input[i] = (char *)malloc(strlen(buffer_linie) + 1);
        strcpy(subsiruri_input[i], buffer_linie);
    }

    char *rezultat_palindrom = composite_palindrome((const char *const *const)subsiruri_input, numar_subsiruri);

    printf("%s\n", rezultat_palindrom);

    free(rezultat_palindrom);

    return 0;
}