#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    const int N = 10;
    int i,j,k,l,m,n;
    double change;
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
                    A[0][0][0] = 1.0e21;
                }
                else
                {
                    A[i][j][k] = 0;
                }
            }
        }
    }
    
    double D = 0.175;
    double room = 5;
    double speed = 250.0;
    double timestep = (room/speed)/N;
    double disblock = room/N;
    double DTerm = D*timestep/(disblock*disblock);
    int pass = 0;
    double time = 0.0;
    double Cmin;
    double Cmax;
    double ratio = 0.0;

    while(ratio < 0.99)
    {
        for(i=0;i<N;i++)
        {
            for(j=0;j<N;j++)
            {
                for(k=0;k<N;k++)
                {
                    for(l=0;l<N;l++)
                    {
                        for(m=0;m<N;m++)
                        {
                            for(n=0;n<N;n++)
                            {
                                if(((i==l)&&(j==m)&&(k==n+1))||((i==l)&&(j==m)&&(k==n-1))||((i==l)&&(j==m+1)&&(k==n))||((i==l)&&(j==m-1)&&(k==n))||((i==l+1)&&(j==m)&&(k==n))||((i==l-1)&&(j==m)&&(k==n)))
                                {
                                    change = (A[i][j][k]-A[l][m][n])*DTerm;
                                    A[i][j][k] = A[i][j][k] - change;
                                    A[l][m][n] = A[l][m][n] + change;
                                }
                            }
                        }
                    }
//                if(i>0 && j>0)
//                {
//                    A[i][j][k] = A[i-1][j-1][k]-2;
//                }
//                else if(j > 0)
//                {
//                    A[i][j][k] = A[i][j-1][k]-1;
//                }
//               else if(i > 0)
//                {
//                    A[i][j][k] = A[i-1][j][k]-1;
//                }
//                else
//                {
//                    A[i][j][k] = i*N*N-j*N-k-1.0+fc;
//                    A[i][j][k] = A[i][j][k]+1.0;
//                }
//                printf("%f\t",A[i][j][k]);
                }
                printf("\n");
            }
            printf("\n");
        }
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

