#include <stdio.h>  // Pentru printf, scanf
#include <stdlib.h> // Pentru malloc, free (nu sunt folosite direct in kfib, dar bune de inclus)

// Functia kfib (corespondent 1:1 cu ASM)
// int kfib(int n, int K)
int kfib(int n, int K)
{
    int suma_calculata;
    int i;

    int valoare_curenta_n = n; // Redenumit din registru_n
    int valoare_fixa_k = K;    // Redenumit din registru_k

    if (valoare_curenta_n < valoare_fixa_k)
        goto mai_mic;
    if (valoare_curenta_n == valoare_fixa_k)
        goto egale;

mai_mare:
    suma_calculata = 0;
    i = 1;

for_loop:
    if (i > valoare_fixa_k)
        goto sfarsit_bucla;

    int rezultat_apel_recursiv = kfib(n - i, valoare_fixa_k);
    suma_calculata = suma_calculata + rezultat_apel_recursiv;

    i++;
    goto for_loop;

sfarsit_bucla:
    int valoare_returnata = suma_calculata;
    goto curata_stiva;

mai_mic:
    valoare_returnata = 0;
    goto curata_stiva;

egale:
    valoare_returnata = 1;

curata_stiva:
    return valoare_returnata;
}

int main()
{
    int n;
    int k;
    scanf("%d %d", &n, &k);

    int rezultat = kfib(n, k);
    printf("%d\n", rezultat);

    return 0;
}