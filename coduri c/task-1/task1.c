#include <stdio.h>
#include <stdlib.h>

struct node
{
    int val;
    struct node *next;
};

struct node *sort(int n, struct node *head)
{
    struct node *nod_anterior;
    struct node *cap_lista_initiala;
    struct node *nod_curent;
    int valoare_curenta_cautare;
    int contor_n;

    struct node *adresa_primului_nod = NULL;

    contor_n = n;
    cap_lista_initiala = head;
    nod_anterior = NULL;

    nod_curent = cap_lista_initiala;
    valoare_curenta_cautare = 0;

caut_nod:
    valoare_curenta_cautare++;
    if (valoare_curenta_cautare > n)
        goto gata;
    for (nod_curent = head, contor_n = n; contor_n > 0; contor_n--)
    {
        if (nod_curent->val == valoare_curenta_cautare)
            goto nod_gasit;
        nod_curent = (struct node *)((char *)nod_curent + sizeof(struct node));
    }

nod_gasit:
    if (valoare_curenta_cautare != 1)
        goto leaga_nod;
    nod_anterior = nod_curent;
    adresa_primului_nod = nod_curent;
    goto caut_nod;

leaga_nod:
    nod_anterior->next = nod_curent;
    nod_anterior = nod_curent;
    goto caut_nod;

gata:
    if (nod_anterior != NULL)
        nod_anterior->next = NULL;
    nod_curent = adresa_primului_nod;

    return nod_curent;
}

void print_list(struct node *head)
{
    struct node *current = head;
    while (current != NULL)
    {
        printf("%d ", current->val);
        current = current->next;
    }
    printf("\n");
}

int main()
{
    int n;
    scanf("%d", &n);
    struct node *array_noduri = (struct node *)malloc(sizeof(struct node) * n);

    for (int i = 0; i < n; ++i)
    {
        if (scanf("%d", &array_noduri[i].val) != 1)
        {
            free(array_noduri);
            return 1;
        }
        array_noduri[i].next = NULL;
    }

    struct node *cap_array = &array_noduri[0];

    struct node *cap_sortat = sort(n, cap_array);

    print_list(cap_sortat);

    free(array_noduri);

    return 0;
}