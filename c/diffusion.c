#include <stdio.h>
#include <stdlib.h>
#include <math.h>
// C Checked on 10/20/17
//
// YOU really should look into the fmax and fmin function to simplify and speed up your program


int main(int argc, char** argv)
{
    //Varibles that are the same for setting up the cube with or without the partition
    const int N = 10;                               //maxsize
    const float x = 10.0;                           //maxsize in a float
    int i,j,k,l,m,n;
    float*** A = malloc(N*sizeof(float***));        //the multidimensional array
    float D = 0.175;                                //diffusion coeficient
    float room = 5.0;                               //room dimension is 5 meters
    float speed = 250.0;                            //speed of gas molecule based on 100 g/mol gas at RT
    float timestep = (room/speed)/x;                //basis for spatial stepsizes with respect to position in seconds
    float disblock = room/x;                        //is the distance between blocks
    float DTerm = D*timestep/(disblock*disblock);   //
    float time = 0.0;                               //tracks the simulated time
    float ratio = 0.0;                              //the ratio of the min concentration/the max concentration
    float change;                                   //is the change of concentrations between blocks

    //get user input do run the program with a partition or not
    char type;
    printf("Do you want to run this program with a partition?\n");
    printf("Enter y for partition, or enter n to run without a partition:\n");
    scanf("%c", &type);
    switch (type)
    {
        case 'y':
            printf("This program will run with a partition...\n");
            //Allocating the space for the 3d array
            for(i=0;i<N;i++)
            {
                A[i] = malloc(N*sizeof(float*));
                for(j=0;j<N;j++)
                {
                    A[i][j] = malloc(N*sizeof(float));
                }
            }
            printf("allocated done");
            for(i=0;i<N;i++)
            {
                for(j=0;j<N;j++)
                {
                    for(k=0;k<N;k++)
                    {
                        if(j>=(N/2)-1 && k==(N/2)-1)
                        {
                            A[i][j][k] = -1;
                        }
                        else
                        {
                            A[i][j][k] = 0.0;
                        }
                    }
                }
            }
            A[0][0][0] = 1.0e21;
            
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
                                        if(A[l][m][n] != -1)
                                        {
                                            if(((i==l)&&(j==m)&&(k==n+1)&&(A[l][m][n+1]!=-1))||((i==l)&&(j==m)&&(k==n-1)&&(A[l][m][n-1]!=-1))||((i==l)&&(j==m+1)&&(k==n)&&(A[l][m+1][n]!=-1))||((i==l)&&(j==m-1)&&(k==n)&&(A[l][m-1][n]!=-1))||((i==l+1)&&(j==m)&&(k==n)&&(A[l+1][m][n]!=-1))||((i==l-1)&&(j==m)&&(k==n)&&(A[l-1][m][n]!=-1)))
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
                    }
                }
                float sumval = 0.0;         //sum of the concentrations of every block in the cube
                float max = A[0][0][0];     //block with the highest concentration
                float min = A[0][0][0];     //block with the lowest concentration

                for(i=0;i<N;i++)
                {
                    for(j=0;j<N;j++)
                    {
                        for(k=0;k<N;k++)
                        {
                            if(A[l][m][n] != -1)
                            {
                                max = fmax(max,A[i][j][k]);     //fmax returns the bigger concentratio and sets it as the max value
                                min = fmin(min,A[i][j][k]);     //fmin returns the smaller concentratio and sets it as the min value
                                sumval += A[i][j][k];
                            }
                        }
                    }
                }

                ratio = min/max;

                printf("time=%f",time);
                printf(" ratio=%f",ratio);
                printf(" sumval=%f\n",sumval);
            }
            printf("The box equilibrated in %f, seconds of simulated time with a partition.",time);
            free(A);
            break;
        case 'n':
            printf("This program will run without a partition...\n");
            //Allocating the space for the 3d array
            for(i=0;i<N;i++)
            {
                A[i] = malloc(N*sizeof(float*));
                for(j=0;j<N;j++)
                {
                    A[i][j] = malloc(N*sizeof(float));
                }
            }
            
            //set 3d array to 0 except for first cube which is set to 1.0e21
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
            
            //goes through each block of two versions (original(i,j,k) and new(l,n,m)) and compares the concentration (ratio) of every block next to it
            //the change (change of concentration) between the ratios is subtracted from the original and added to the new, in order to show the concentration
            //of the gas changes as time continues
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
                }
                
                //check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes outside the cube
                //determines the new ratio after 1 step: divides the new min by the new max
                float sumval = 0.0;         //sum of the concentrations of every block in the cube
                float max = A[0][0][0];     //block with the highest concentration
                float min = A[0][0][0];     //block with the lowest concentration

                for(i=0;i<N;i++)
                {
                    for(j=0;j<N;j++)
                    {
                        for(k=0;k<N;k++)
                        {
                            max = fmax(max,A[i][j][k]);     //fmax returns the bigger concentratio and sets it as the max value
                            min = fmin(min,A[i][j][k]);     //fmin returns the smaller concentratio and sets it as the min value
                            sumval += A[i][j][k];
                        }
                    }
                }
                
                ratio = min/max;

                printf("time=%f",time);
                printf(" ratio=%f",ratio);
                printf(" sumval=%f\n",sumval);
            }
            printf("The box equilibrated in %f, seconds of simulated time without a partition.",time);
            free(A);
            break;
        default:
            printf("invalid input\n");
    }
}
