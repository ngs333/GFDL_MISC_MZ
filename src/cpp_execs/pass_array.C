#include <stdio.h>
#include <stdlib.h>

#define NJDEF 5

/***
 * Lessons: 
 * 1) C arrays are really one dimensional
 * 2) If you try to use them as 2D (or ND) arrays, the
 *    sizes of the inner (rightmost) arrays(s) need to be known
 *    at compile time. So in the function declaration below
 *    "int A[][NJKDEF]" compiles but "int A[][NJ]" does not.
 ****/

int one_index(int i, int j, int NI){
    return ( j * NI + i);
}

void init_array(const int NJ, const int NI, int A[][NJDEF])
{
    for (int i = 0; i < NI; i++){
        for (int j = 0; j < NJ; j++){
            A[i][j] = one_index(i, j, NI);
        }
    }
}


void print_array(const int NJ, const int NI, int A[][NJDEF]){
    printf("\nArray:\n");
    for (int j = 0; j < NJ; j++){//printing one row at a time
        for (int i = 0; i < NI; i++){
            printf("%d ", A[i][j]);
        }
        printf("\n");
    }
}


int main(){
    const int NI = 4; // number of columns
    const int NJ = 5; // number of rows
  
    int (*A)[NJDEF] = (int(*)[NJ])malloc(NJ * NI * sizeof(int));
    init_array(NJ, NI, A);
    print_array(NJ, NI, A);
 
    return 0;
}