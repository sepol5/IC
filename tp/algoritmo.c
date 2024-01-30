#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "algoritmo.h"
#include "funcao.h"
#include "utils.h"

#define PROB 0.01
#define TMAX 100
#define TMIN 5

// Gera um vizinho
// Parametros: solucao actual, vizinho, numero de vertices
//swap two vertices
void gera_vizinho(int a[], int b[], int n)
{
    int i, p1, p2;

    for(i=0; i<n; i++)
        b[i]=a[i];
	// Encontra posicao com valor 0
    do
        p1=random_l_h(0, troco/vfacial[i]);
    while(b[p1] != 0);
	// Encontra posicao com valor 0
    do
        p2=random_l_h(0, troco/vfacial[i]);
    while(b[p2] != 1);
	// Troca
    b[p1] = 1;
    b[p2] = 0;
}

// Trepa colinas first-choice
// Parametros: solucao, matriz de adjacencias, numero de vertices e numero de iteracoes
// Devolve o custo da melhor solucao encontrada
int trepa_colinas(int sol[], int *mat, int n, int total)
{
    int *nova_sol, custo, custo_viz, i;

	nova_sol = malloc(sizeof(int)*n);
    if(nova_sol == NULL)
    {
        printf("Erro na alocacao de memoria");
        exit(1);
    }
	// Avalia solucao inicial
    custo = calcula_fit(sol, mat, n, total);
    for(i=0; i<num_iter; i++)
    {
		// Gera vizinho
		gera_vizinho(sol, nova_sol, n);
		gera_vizinho2(sol, nova_sol, n);
		// Avalia vizinho
		custo_viz = calcula_fit(nova_sol, mat, n, total);
		// Aceita vizinho se o custo diminuir (problema de minimizacao)
        if(custo_viz < custo)
        {
			substitui(sol, nova_sol, n);
			custo = custo_viz;
        }
    }
    free(nova_sol);
    return custo;
}

void gera_vizinho2(int a[], int b[], int n)
{
    int i, p1, p2, p3, p4;

    for(i=0; i<n; i++)
        b[i]=a[i];
	// Encontra posicao com valor 0
    do
        p1=random_l_h(0, n-1);
    while(b[p1] != 0);
	// Encontra posicao com valor 0
    do
        p2=random_l_h(0, n-1);
    while(b[p2] != 1);
	// Troca
    b[p1] = 1;
    b[p2] = 0;

   do
        p3=random_l_h(0, n-1);
    while(b[p3] != 0 || p3 == p2);
    //Encontra aleatoriamente a posiçao de um vertice
     do
        p4 = random_l_h(0,n-1);
    while(b[p4] != 1 || p4 == p1);
    //troca os valores dos vertices das posiçoes
    b[p3] = 1;
    b[p4] =0;
}
int trepa_colinasprob(int sol[], int *mat, int vert, int num_iter)
{
    int *nova_sol, custo, custo_viz, i,*best_sol,best_custo;

	best_sol = malloc(sizeof(int)*vert);
	nova_sol = malloc(sizeof(int)*vert);
    if(nova_sol == NULL)
    {
        printf("Erro na alocacao de memoria");
        exit(1);
    }
	// Avalia solucao inicial
    custo = calcula_fit(sol, mat, vert);
    best_custo = custo;
    substitui(best_sol,sol,vert);
    for(i=0; i<num_iter; i++)
    {
		// Gera vizinho
		gera_vizinho(sol, nova_sol, vert);
		gera_vizinho2(sol, nova_sol, vert);
		// Avalia vizinho
		custo_viz = calcula_fit(nova_sol, mat, vert);
		// Aceita vizinho se o custo diminuir (problema de minimizacao)
        if(custo_viz < custo)
        {
			substitui(sol, nova_sol, vert);
			custo = custo_viz;
        }
        else
        {
            if(rand_01() < PROB)
            {
                substitui(sol, nova_sol, vert);
                custo = custo_viz;
            }

        }
        if(custo_viz<best_custo)
        {
            best_custo = custo_viz;
            substitui(best_sol,nova_sol,vert);
        }
        if(custo_viz<=best_custo)
        {
            best_custo = custo_viz;
            substitui(best_sol,nova_sol,vert);
        }
        else
        {
            if(rand_01() < PROB)
            {
                substitui(sol, nova_sol, vert);
                custo = custo_viz;
            }

        }
        substitui(sol,best_sol,vert);
    }
    free(nova_sol);
    return custo;
}

int recristalizacao(int sol[], int *mat, int vert, int num_iter)
{
    int *nova_sol, custo, custo_viz, i, *best_sol, best_custo;
    float t = TMAX ,decrementoT;

    //CALCULO DA DECREMENTAÇAO DE t PARA ir de tmax a tmin en num_iter
    decrementoT = (TMAX - TMIN) / num_iter;

	best_sol = malloc(sizeof(int)*vert);
	nova_sol = malloc(sizeof(int)*vert);
    if(nova_sol == NULL || best_sol == NULL)
    {
        printf("Erro na alocacao de memoria");
        exit(1);
    }
	// Avalia solucao inicial
    custo = calcula_fit(sol, mat, vert);
    best_custo = custo;
    substitui(best_sol,sol,vert);
    for(i=0; i<num_iter; i++)
    {
		// Gera vizinho
		gera_vizinho(sol, nova_sol, vert);
		// Avalia vizinho
		custo_viz = calcula_fit(nova_sol, mat, vert);
		// Aceita vizinho se o custo diminuir (problema de minimizacao)
        if(custo_viz < best_custo)
        {
			substitui(sol, nova_sol, vert);
			custo = custo_viz;
        }
        else
        {
            if(rand_01() < exp((custo-custo_viz)/t))
            {
                substitui(sol, nova_sol, vert);
                custo = custo_viz;
            }
            t = t -decrementoT;
            substitui(sol,best_sol,vert);


        }

        if(custo_viz<=best_custo)
        {
            best_custo = custo_viz;
            substitui(best_sol,nova_sol,vert);
        }
        else
        {
            if(rand_01() < exp((custo-custo_viz)/t))
            {
                substitui(sol, nova_sol, vert);
                custo = custo_viz;
            }

        }
        t = t -decrementoT;
        substitui(sol,best_sol,vert);
    }

    free(nova_sol);
    return custo;
}

