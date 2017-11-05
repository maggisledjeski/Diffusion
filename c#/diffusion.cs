using System;

// Csharp checked on 10/20/17

public class Diffusion
{
    static public void Main()
    {
        //Varibles that are the same for setting up the cube with or without the partition
        const int N = 10;                               //maxsize
        double[,,] A = new double[N,N,N];               //cube declaration of size NxNxN
        int i,j,k,l,m,n;
        int wall = -1;                                  //the value/concentration of a wall block
        double change;                                  //is the change of concentrations between blocks
        double D = 0.175;                               //diffusion coefficient 
        double room = 5;                                //room dimension is 5 meters
        double speed = 250.0;                           //speed of gas molecule based on 100 g/mol gas at RT
        double timestep = (room/speed)/N;               //basis for spatial stepsizes with respect to position in seconds
        double disblock = room/N;                       //is the distance between blocks
        double DTerm = D*timestep/(disblock*disblock);  //
        double time = 0.0;
        double ratio = 0.0;

        Console.WriteLine("Attempting to allocate " + (N*N*N) + " Doubles");
        
        //User input: enter 1 to run with a partition, enter 2 to run without
        bool validAnswer = false; //used for choosing if the user wants a partition
        int p;
        
        while (!validAnswer) 
        {
            Console.WriteLine("To run program with partition, enter 1, otherwise enter 2: ");
            validAnswer = int.TryParse(Console.ReadLine(), out p); 
            if(p==1 || p==2)
            {
                if(p==2)
                {
                    Console.WriteLine("Running program without a partition...");
                    for(i=0;i<N;i++)
                    {
                        for(j=0;j<N;j++)
                        {
                            for(k=0;k<N;k++)
                            {
                                if(i==0 && j==0 && k==0)
                                {
                                    A[0,0,0] = 1.0e21;
                                }
                                else
                                {
                                    A[i,j,k] = 0.0;
                                }
                            }
                        }
                    }
                    
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
                                                    change = (A[i,j,k]-A[l,m,n])*DTerm;
                                                    A[i,j,k] = A[i,j,k] - change;
                                                    A[l,m,n] = A[l,m,n] + change;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        double sumval = 0.0;    //sum of the concentrations of every block in the cube
                        double max = A[0,0,0];  //block with the highest concentration
                        double min = A[0,0,0];  //block with the lowest concentration

                        for(i=0;i<N;i++)
                        {
                            for(j=0;j<N;j++)
                            {
                                for(k=0;k<N;k++)
                                {
                                    if(max < A[i,j,k])
                                    {
                                        max = A[i,j,k]; //new max if a bigger concentration is found within the cube
                                    }
                                    if(min > A[i,j,k])
                                    {
                                        min = A[i,j,k]; //new min if a smaller concentration is found within the cube
                                    }
                                    sumval += A[i,j,k];
                                }
                            }
                        }
                        ratio = min/max;
                        Console.WriteLine(time + " " + ratio + " " + sumval);
                    }
                    Console.WriteLine("Box equilibrated in " + time + " seconds of simulated time without a partition.");
                }
                else
                {
                    Console.WriteLine("Running program with a partition...");
                    for(i=0;i<N;i++)
                    {
                        for(j=0;j<N;j++)
                        {
                            for(k=0;k<N;k++)
                            {
                                if(j/2 >= (N/2)-1 && k/2 == (N/2)-1)
                                {
                                    A[i,j,k] = wall;
                                }
                                else
                                {
                                    A[i,j,k] = 0.0;
                                }
                                //if(i==0 && j==0 && k==0)
                                ///{
                                  ///  A[0,0,0] = 1.0e21;
                                //}
                            }
                        }
                    }
                    A[0,0,0] = 1.0e21;
                    Console.WriteLine("Running program with a partition...");
                    ratio = 0.0;
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
                                                if(A[l,m,n] != wall)
                                                {
                                                    if(((i==l)&&(j==m)&&(k==n+1)&&(A[l,m,n+1]!=wall))||((i==l)&&(j==m)&&(k==n-1)&&(A[l,m,n-1]!=wall))||((i==l)&&(j==m+1)&&(k==n)&&(A[l,m+1,n]!=wall))||((i==l)&&(j==m-1)&&(k==n)&&(A[l,m-1,n]!=wall))||((i==l+1)&&(j==m)&&(k==n)&&(A[l+1,m,n]!=wall))||((i==l-1)&&(j==m)&&(k==n)&&(A[l-1,m,n]!=wall)))
                                                    {   
                                                        change = (A[i,j,k]-A[l,m,n])*DTerm;
                                                        A[i,j,k] = A[i,j,k] - change;
                                                        A[l,m,n] = A[l,m,n] + change;
                                                        //Console.Write(ratio);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Console.WriteLine("Running program with a partition...");
                    double sumval = 0.0;    //sum of the concentrations of every block in the cube
                    double max = A[0,0,0];  //block with the highest concentration
                    double min = A[0,0,0];  //block with the lowest concentration
                    
                    for(i=0;i<N;i++)
                    {
                        for(j=0;j<N;j++)
                        {
                            for(k=0;k<N;k++)
                            {
                                if(A[i,j,k] != wall)
                                {
                                    if(max < A[i,j,k])
                                    {
                                        max = A[i,j,k]; //new max if a bigger concentration is found within the cube
                                    }
                                    if(min > A[i,j,k])
                                    {
                                        min = A[i,j,k]; //new min if a smaller concentration is found within the cube
                                    }
                                    sumval += A[i,j,k];
                                }
                            }
                        }
                    }
                    ratio = min/max;
                    Console.WriteLine(time + " " + ratio + " " + sumval);
                }
                Console.WriteLine("Box equilibrated in " + time + " seconds of simulated time with a partition.");
            }
            else
            {
                validAnswer=false;
            }
        }
    }
}
 /*       //initalizing the inital value and the walls in the cube
        //Partition:
        for(i=0;i<N;i++)
        {
            for(j=0;j<N;j++)
            {
                for(k=0;k<N;k++)
                {
                    if(i==0 && j==0 && k==0)
                    {
                        A[0,0,0] = 1.0e21;
                    }
                    else if(j/2 >= (N/2)-1 && k/2 == (N/2)-1)
                    {
                        A[i,j,k] = wall;
                    }
                    else
                    {
                        A[i,j,k] = 0.0;
                    }
                }
            }
        }
        goto Start;

        //initializing the initial value in the cube     
        notPartition:
        for(i=0;i<N;i++)
        {
            for(j=0;j<N;j++)
            {
                for(k=0;k<N;k++)
                {
                    if(i==0 && j==0 && k==0)
                    {
                        A[0,0,0] = 1.0e21;
                    }
                    else
                    {
                        A[i,j,k] = 0.0;
                    }
                }
            }
        }
        
        Start:
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
                                    if(A[l,m,n] != wall)
                                    {
                                        
                                        if(((i==l)&&(j==m)&&(k==n+1)&&(A[l,m,n+1]!=wall))||((i==l)&&(j==m)&&(k==n-1)&&(A[l,m,n-1]!=wall))||((i==l)&&(j==m+1)&&(k==n)&&(A[l,m+1,n]!=wall))||((i==l)&&(j==m-1)&&(k==n)&&(A[l,m-1,n]!=wall))||((i==l+1)&&(j==m)&&(k==n)&&(A[l+1,m,n]!=wall))||((i==l-1)&&(j==m)&&(k==n)&&(A[l-1,m,n]!=wall)))
                                        {
                                            change = (A[i,j,k]-A[l,m,n])*DTerm;
                                            A[i,j,k] = A[i,j,k] - change;
                                            A[l,m,n] = A[l,m,n] + change;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } //end of for loops
            //isWall:
            //check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes outside the cube
            //determines the new ratio after 1 step: divides the new min by the new max
            double sumval = 0.0;    //sum of the concentrations of every block in the cube
            double max = A[0,0,0];  //block with the highest concentration
            double min = A[0,0,0];  //block with the lowest concentration
            
            for(i=0;i<N;i++)
            {
                for(j=0;j<N;j++)
                {
                    for(k=0;k<N;k++)
                    {
                        if(A[i,j,k] != wall)
                        {
                            if(max < A[i,j,k])
                            {
                                max = A[i,j,k]; //new max if a bigger concentration is found within the cube
                            }
                            if(min > A[i,j,k])
                            {
                                min = A[i,j,k]; //new min if a smaller concentration is found within the cube
                            }
                            sumval += A[i,j,k];
                        }
                    }
                }
            }
            ratio = min/max;
            Console.WriteLine(time + " " + ratio + " " + sumval);
 //           isWall:

       } //end of while loop
        Console.WriteLine("Box equilibrated in " + time + " seconds of simulated time.");*/
  //  }
//}

