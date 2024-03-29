#include <stdio.h>
#include <stdlib.h>
#include <math.h>
//for wall clock
#include <time.h>
#include <sys/time.h>
// C Checked on 10/20/17
//
// YOU really should look into the fmax and fmin function to simplify and speed up your program


int main(int argc, char** argv)
{
    //set up clock
    struct timeval tval_before, tval_after, tval_result;
    gettimeofday(&tval_before, NULL);

    int Msize;  //user input of msize
    printf("Enter the Msize value (integer): \n");
    scanf(" %d", &Msize);
    
    //***can change the range of valid numbers that the 3d array can be here***
    if(Msize > 0 && Msize < 100)    
    { 
    printf("The Msize you have entered is %d",Msize);
    //Varibles that are the same for setting up the cube with or without the partition
    const int N = Msize;                            //maxsize
    const float x = (float) Msize;                  //maxsize in a float
    int i,j,k,l,m,n;                                
    float*** A = malloc(N*sizeof(float**));         //the multidimensional array
    float D = 0.175;                                //diffusion coeficient
    float room = 5.0;                               //room dimension is 5 meters
    float speed = 250.0;                            //speed of gas molecule based on 100 g/mol gas at RT
    float timestep = (room/speed)/x;                //basis for spatial stepsizes with respect to position in seconds
    float disblock = room/x;                        //is the distance between blocks
    float DTerm = D*timestep/(disblock*disblock);   //
    float time = 0.0;                               //tracks the simulated time
    float ratio = 0.0;                              //the ratio of the min concentration/the max concentration
    float change;                                   //is the change of concentrations between blocks

    //Allocating the space for the 3d array
    for(i=0;i<N;i++)
    {
        A[i] = malloc(N*sizeof(float*));
        for(j=0;j<N;j++)
        {
            A[i][j] = malloc(N*sizeof(float));
        }
    }
    
    //get user input do run the program with a partition or not
    char type;
    printf("Do you want to run this program with a partition?\n");
    printf("Enter y for partition, or enter n to run without a partition:\n");
    scanf(" %c", &type);
    switch(type)
    {
        //***start of partition code***
        case 'y':
            printf("This program will run with a partition...\n");
            
            //set 3d array to 0.0 and set up the walls=-1
            for(i=0;i<N;i++)
            {
                for(j=0;j<N;j++)
                {
                    for(k=0;k<N;k++)
                    {
                        if(j>=(N/2)-1 && k==(N/2)-1)
                        {
                            A[i][j][k] = -1;    //initializes walls to equal -1
                        }
                        else
                        {
                            A[i][j][k] = 0.0;
                        }
                    }
                }
            }

            A[0][0][0] = 1.0e21;    //initializes the first cube to 1.0e21
            
            //Goes through each block and compares the concentration (ratio) of every block next to it as long as the current block is not a wall.
            //Also, the if statements check that a specific block next to the current is not a wall ex. A[i,j,k+1]!=-1.
            //The change (change of concentration) between the ratios is subtracted from the original and added to the new, in order
            //to show the concentration of the gas changes as simulated time continues.
            while(ratio < 0.99)
            {
                time = time + timestep;     //increments the simulation time
                for(i=0;i<N;i++)
                {
                    for(j=0;j<N;j++)
                    {
                        for(k=0;k<N;k++)
                        {
                            if(A[i][j][k] != -1)    //checks to make sure that the current block is not a wall
                            {
                                    if(k+1 < N && A[i][j][k+1] != -1) 
                                    {
                                            change=(A[i][j][k]-A[i][j][k+1])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i][j][k+1]=A[i][j][k+1]+change;
                                    }
                                    if(k-1 >= 0 && A[i][j][k-1] != -1) 
                                    {
                                            change=(A[i][j][k]-A[i][j][k-1])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i][j][k-1]=A[i][j][k-1]+change;
                                    }
                                    if(j+1 < N && A[i][j+1][k] != -1) 
                                    {
                                            change=(A[i][j][k]-A[i][j+1][k])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i][j+1][k]=A[i][j+1][k]+change;
                                    }
                                    if(j-1 >= 0 && A[i][j-1][k] != -1) 
                                    {
                                            change=(A[i][j][k]-A[i][j-1][k])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i][j-1][k]=A[i][j-1][k]+change;
                                    }
                                    if(i+1 < N && A[i+1][j][k] != -1) 
                                    {
                                            change=(A[i][j][k]-A[i+1][j][k])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i+1][j][k]=A[i+1][j][k]+change;
                                    }
                                    if(i-1 >= 0 && A[i-1][j][k] != -1) 
                                    {
                                            change=(A[i][j][k]-A[i-1][j][k])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i-1][j][k]=A[i-1][j][k]+change;
                                    }
                            }
                        }
                    }
                }
                
                //Check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes outside the cube.
                //Determines the new ratio after every step: divides the new min by the new max.
                float sumval = 0.0;         //sum of the concentrations of every block in the cube
                float max = A[0][0][0];     //block with the highest concentration
                float min = A[0][0][0];     //block with the lowest concentration
                
                for(i=0;i<N;i++)
                {
                    for(j=0;j<N;j++)
                    {
                        for(k=0;k<N;k++)
                        {
                            if(A[i][j][k] != -1)
                            {
                                max = fmax(max, A[i][j][k]);     //fmax returns the bigger concentratio and sets it as the max value
                                min = fmin(min, A[i][j][k]);     //fmin returns the smaller concentratio and sets it as the min value
                                sumval += A[i][j][k];            //adds the sum of every block in the cube
                            }
                        }
                    }
                }
                ratio = min/max;    //calculates the updated ratio for every step

                printf("%f",time);
                printf(" %f",ratio);
                printf(" %f\n",sumval);
            }
            printf("The box equilibrated in %f, seconds of simulated time with a partition.\n",time);
            free(A);
            break;
            //***end of partition code***

            //***start of non-partition code***
        case 'n':
            printf("This program will run without a partition...\n");            
            
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
            
            //Goes through each block and compares the concentration (ratio) of every block next to it.
            //The change (change of concentration) between the ratios is subtracted from the original and added to the new,
            //in order to show the concentration of the gas changes as simulated time continues.
            while(ratio < 0.99)
            {
                time = time + timestep; //increments the simulated time
                for(i=0;i<N;i++)
                {
                    for(j=0;j<N;j++)
                    {
                        for(k=0;k<N;k++)
                        {
                            if(k+1 < N && A[i][j][k+1] != A[i][j][k])
                            {
                                change=(A[i][j][k]-A[i][j][k+1])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i][j][k+1]=A[i][j][k+1]+change;
                            }
                            if(k-1 >= 0 && A[i][j][k-1] != A[i][j][k])
                            {
                                change=(A[i][j][k]-A[i][j][k-1])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i][j][k-1]=A[i][j][k-1]+change;
                            }
                            if(j+1 < N && A[i][j+1][k] != A[i][j][k])
                            {
                                change=(A[i][j][k]-A[i][j+1][k])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i][j+1][k]=A[i][j+1][k]+change;
                            }
                            if(j-1 >= 0 && A[i][j-1][k] != A[i][j][k])
                            {
                                change=(A[i][j][k]-A[i][j-1][k])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i][j-1][k]=A[i][j-1][k]+change;
                            }
                            if(i+1 < N && A[i+1][j][k] != A[i][j][k])
                            {
                                change=(A[i][j][k]-A[i+1][j][k])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i+1][j][k]=A[i+1][j][k]+change;
                            }
                            if(i-1 >= 0 && A[i-1][j][k] !=  A[i][j][k])
                            {
                                change=(A[i][j][k]-A[i-1][j][k])*DTerm;
                                            A[i][j][k]=A[i][j][k]-change;
                                            A[i-1][j][k]=A[i-1][j][k]+change;
                            }
                        }
                    }
                }
                
                //Check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes outside the cube.
                //Determines the new ratio after every step: divides the new min by the new max.
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
                            sumval += A[i][j][k];           //adds the sum of every block in the cube
                        }
                    }
                }
                
                ratio = min/max;    //calculates the updated ratio for every step

                printf("%f",time);
                printf(" %f",ratio);
                printf(" %f\n",sumval);
            }
            printf("The box equilibrated in %f, seconds of simulated time without a partition.\n",time);
            free(A);
            break;
            //***end of non-partition code***

        //if user enters invalid input for partition
        default:
            printf("invalid input\n");
    }
    
    }//user enters invalid Msize number
    else
    {
        printf("Entered invalid Msize number\n");
    }
    gettimeofday(&tval_after, NULL);
    timersub(&tval_after, &tval_before, &tval_result);
    printf("Time elapsed: %ld.%06ld seconds\n", (long int)tval_result.tv_sec, (long int)tval_result.tv_usec);
}
