#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    const int N = 3;
    int i,j,k;
    int fc = 10;
    double*** A = malloc(N*sizeof(double**));

    for(i=0;i<N;i++)
    {
        A[i] = malloc(N*sizeof(double*));
        for(j=0;j<N;j++)
        {
            A[i][j] = malloc(N*sizeof(double));
        }
    }
    //set 3d array to 0 except for first cube
    for(i=0;i<N;i++)
    {
        for(j=0;j<N;j++)
        {
            for(k=0;k<N;k++)
            {
                if(i==0 && j==0 && k==0)
                {
                    A[0][0][0] = fc;
                }
                else
                {
                    A[i][j][k] = 0;
                }
            }
        }
    }

    for(i=0;i<N;i++)
    {
        for(j=0;j<N;j++)
        {
            for(k=0;k<N;k++)
            {
                if(i>0 && j>0)
                {
                    A[i][j][k] = A[i-1][j-1][k]-2;
                }
                else if(j > 0)
                {
                    A[i][j][k] = A[i][j-1][k]-1;
                }
                else if(i > 0)
                {
                    A[i][j][k] = A[i-1][j][k]-1;
                }
                else
                {
                    A[i][j][k] = i*N*N-j*N-k-1.0+fc;
                    A[i][j][k] = A[i][j][k]+1.0;
                }
                printf("%f\t",A[i][j][k]);
            }
            printf("\n");
        }
        printf("\n");
    }

    printf("The last element is %f\n",A[N-1][N-1][N-1]);

//    int tacc = 0;
//    double Msize = 10.0;
//    double Lroom = 5.0;
//    double h = Lroom/Msize;
//    double tstep = (Lroom/urms)/Msize;
//    double Cmin;
//    double Cmax;
//    while(Cmin/Cmax <= 0.99)
//    {
//        tacc = tacc + tstep

    free(A);
}

