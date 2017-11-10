using System;

// Csharp checked on 10/20/17

public class Diffusion
{
    static public void Main()
    {
        int msize;
        Console.WriteLine("Enter the size of the box: ");
        msize = Convert.ToInt32(Console.ReadLine());
        Console.WriteLine("The Msize is: " + msize);
        if(msize > 0 && msize <100)
        {
        //Varibles that are the same for setting up the cube with or without the partition
        int N = msize;                               //maxsize
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
        double time = 0.0;                              //tracks the simulated time
        double ratio = 0.0;                             //the ratio of the min concentration/the max concentration

        Console.WriteLine("Attempting to allocate " + (N*N*N) + " Doubles");
        
        //User input: enter 1 to run with a partition, enter 2 to run without
        bool validAnswer = false; //used for choosing if the user wants a partition
        int p;
        
        while (!validAnswer) 
        {
            Console.WriteLine("To run program with partition, enter 1, to run without a partition enter 2: ");
            validAnswer = int.TryParse(Console.ReadLine(), out p); 
            if(p==1 || p==2)
            {
                if(p==2)
                {   //***start non-partition code***
                    Console.WriteLine("Running program without a partition...");
                    //set 3d array to 0.0 except for first cube which is set to 1.0e21
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
                    
                    //Goes through each block and compares the concentration (ratio) of every block next to it.
                    //The change (change of concentration) between the ratios is subtracted from the original and added to the new,
                    //in order to show the concentration of the gas changes as simulated time continues.
                    while(ratio < 0.99)
                    {
                        for(i=0;i<N;i++)
                        {
                            for(j=0;j<N;j++)
                            {
                                for(k=0;k<N;k++)
                                {
                                    if(k+1 < N)
                                    {
                                                change=(A[i,j,k]-A[i,j,k+1])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i,j,k+1]=A[i,j,k+1]+change;
                                    }
                                    if(k-1 >= 0)
                                    {
                                                change=(A[i,j,k]-A[i,j,k-1])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i,j,k-1]=A[i,j,k-1]+change;
                                    }
                                    if(j+1 < N)
                                    {
                                                change=(A[i,j,k]-A[i,j+1,k])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i,j+1,k]=A[i,j+1,k]+change;
                                    }
                                    if(j-1 >= 0)
                                    {
                                                change=(A[i,j,k]-A[i,j-1,k])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i,j-1,k]=A[i,j-1,k]+change;
                                    }
                                    if(i+1 < N)
                                    {
                                                change=(A[i,j,k]-A[i+1,j,k])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i+1,j,k]=A[i+1,j,k]+change;
                                    }
                                    if(i-1 >= 0)
                                    {
                                                change=(A[i,j,k]-A[i-1,j,k])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i-1,j,k]=A[i-1,j,k]+change;
                                    }
                                }
                            }
                        }
                        time = time + timestep; //increments simulated time
                        //Check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes 
                        //outside the cube. Determines the new ratio after every step: divides the new min by the new max.
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
                                    sumval += A[i,j,k]; //adds the sum of every block in the cube
                                }
                            }
                        }
                        ratio = min/max;    //calculates the updated ratio for every step
                        Console.WriteLine(time + " " + ratio + " " + sumval);
                    }
                    Console.WriteLine("Box equilibrated in " + time + " seconds of simulated time without a partition.");
                }   //***end non-partition code***
                else if(p==1)
                {   //***start partition code***
                    Console.WriteLine("Running program with a partition...");
                    //set 3d array to 0.0 and set up the walls=-1
                    for(i=0;i<N;i++)
                    {
                        for(j=0;j<N;j++)
                        {
                            for(k=0;k<N;k++)
                            {
                                if((j >= (N/2)-1) && (k == (N/2)-1))
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
                    A[0,0,0] = 1.0e21;  //initializes the first cube to 1.0e21
            
                    //Goes through each block and compares the concentration (ratio) of every block next to it as long as the current block is not a wall.
                    //Also, the if statements check that a specific block next to the current is not a wall ex. A[i,j,k+1]!=-1.
                    //The change (change of concentration) between the ratios is subtracted from the original and added to the new, in order
                    //to show the concentration of the gas changes as simulated time continues.                    
                    
                    while(ratio <= .99)
                    {
                        for(i=0;i<N;i++)
                        {
                            for(j=0;j<N;j++)
                            {
                                for(k=0;k<N;k++)
                                {
                                    if(A[i,j,k] != -1)    //checks to make sure that the current block is not a wall
                                    {
                                        if(k+1 < N && k-1 >= 0)
                                        {
                                            if(A[i,j,k+1] != A[i,j,k] && A[i,j,k+1] != -1)
                                            {
                                                change=(A[i,j,k]-A[i,j,k+1])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i,j,k+1]=A[i,j,k+1]+change;
                                            }
                                            if(A[i,j,k-1] != A[i,j,k] && A[i,j,k-1] != -1)
                                            {
                                                change=(A[i,j,k]-A[i,j,k-1])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i,j,k-1]=A[i,j,k-1]+change;
                                            }
                                        }
                                        
                                        if(j+1 < N && j-1 >= 0)
                                        {
                                            if(A[i,j+1,k] != A[i,j,k] && A[i,j+1,k] != -1)
                                            {
                                                change=(A[i,j,k]-A[i,j+1,k])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i,j+1,k]=A[i,j+1,k]+change;
                                            }
                                            if(A[i,j-1,k] != A[i,j,k] && A[i,j-1,k] != -1)
                                            {
                                                change=(A[i,j,k]-A[i,j-1,k])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i,j-1,k]=A[i,j-1,k]+change;
                                            }
                                        }   
                                        if(i+1 < N && i-1 >= 0)
                                        {
                                            if(A[i+1,j,k] != A[i,j,k] && A[i+1,j,k] != -1)
                                            {
                                                change=(A[i,j,k]-A[i+1,j,k])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i+1,j,k]=A[i+1,j,k]+change;
                                            }
                                            if(A[i-1,j,k] != A[i,j,k] && A[i-1,j,k] != -1)
                                            {
                                                change=(A[i,j,k]-A[i-1,j,k])*DTerm;
                                                A[i,j,k]=A[i,j,k]-change;
                                                A[i-1,j,k]=A[i-1,j,k]+change;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    
                        time = time + timestep; //increments the wall time
                        
                        //Check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes
                        //outside the cube. Determines the new ratio after every step: divides the new min by the new max.
                        double sumval = 0.0;    //sum of the concentrations of every block in the cube
                        double max = A[0,0,0];  //block with the highest concentration
                        double min = A[0,0,0];  //block with the lowest concentration
                    
                        for(i=0;i<N;i++)
                        {
                            for(j=0;j<N;j++)
                            {
                                for(k=0;k<N;k++)
                                {
                                    if(A[i,j,k] != wall)    //checks to make sure the current block is not a wall
                                    {
                                        if(max < A[i,j,k])
                                        {
                                            max = A[i,j,k]; //new max if a bigger concentration is found within the cube
                                        }
                                        if(min > A[i,j,k])
                                        {
                                            min = A[i,j,k]; //new min if a smaller concentration is found within the cube
                                        }
                                        sumval += A[i,j,k]; //adds the sum of every block in the cube
                                    }
                                }
                            }
                        }
                
                        ratio = min/max;    //calculates the updated ratio for every step
                        Console.WriteLine(time + " " + ratio + " " + sumval);
                    }
               
                Console.WriteLine("Box equilibrated in " + time + " seconds of simulated time with a partition.");
                }
            }   //***ends partition code***
            else
            {
                validAnswer=false;
            }
        }
    }
    else
    {
        Console.WriteLine("Entered an invalid input");
    }
    }
}
