#include <stdio.h>
#include <stdlib.h>
#include <math.h>
// C Checked on 10/20/17
//
// YOU really should look into the fmax and fmin function to simplify and speed up your program


double findRatio(double ***A, int N);

int main(int argc, char** argv)
{
    const int N = 10;
    const float x = 10.0;
    int i,j,k,l,m,n;
    float change;
    int fc = 10;
    float*** A = malloc(N*sizeof(float***));

    for(i=0;i<N;i++)
    {
        A[i] = malloc(N*sizeof(float*));
        for(j=0;j<N;j++)
        {
            A[i][j] = malloc(N*sizeof(float));
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
                    A[i][j][k] = 0.0;
                }
            }
        }
    }
    
    float D = 0.175;
    float room = 5.0;
    float speed = 250.0;
    float timestep = (room/speed)/x;
    float disblock = room/x;
    float DTerm = D*timestep/(disblock*disblock);
    float time = 0.0;
    float ratio = 0.0;

    while(ratio < 0.99)
    {
        time = time + timestep;
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
                } 
            }
        }//end of for loops
        
        float sumval = 0.0;
        float max = A[0][0][0];
        float min = A[0][0][0];
    
        for(i=0;i<N;i++)
        {
            for(j=0;j<N;j++)
            {
                for(k=0;k<N;k++)
                {
                    max = fmax(max,A[i][j][k]);
                    min = fmin(min,A[i][j][k]);
//                    if(max < A[i][j][k])
//                    {
//                        max = A[i][j][k];
//                    }
//                    if(min > A[i][j][k])
//                    {
//                        min = A[i][j][k];
//                    }
                    sumval += A[i][j][k];
                }
            }
        }
        ratio = min/max;

        printf("time=%f",time);
        printf(" ratio=%f\n",ratio);
        printf(" sumval=%f\n",sumval);
    }
    printf("The box equilibrated in %f, seconds of simulated time.",time);
    free(A);
}

double findRatio(double ***A, int N)
{
    int i,j,k;
    double max = A[0][0][0];
    double min = A[0][0][0];
    double ratio = min/max;
    printf("%f\n",max);
    for(i=0;i<N;i++)
    {
        for(j=0;j<N;j++)
        {
            for(k=0;k<N;k++)
            {
                if(max < A[i][j][k]) 
                {
                    max = A[i][j][k];
                }
                if(min > A[i][j][k])
                {
                    min = A[i][j][k];
                }
            }
        }
    }
    ratio = min/max;
    //printf("%f\n",ratio);
    return ratio;
}
