using System;

public class Diffusion
{
    static public void Main()
    {
        const int N = 10;
        double[,,] A = new double[N,N,N];
        int i,j,k,l,m,n;
        double change;
        Console.WriteLine("Attempting to allocate " + (N*N*N) + " Doubles");
        for(int a = 0;a < N; a++)
        {
            for(int b = 0;b < N; b++)
            {
                for(int c = 0;c < N; c++)
                {
                    A[a,b,c]=a*N*N+b*N+c+1;
                }
            }
        }
        
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

        double D = 0.175;
        double room = 5;
        double speed = 250.0;
        double timestep = (room/speed)/N;
        double disblock = room/N;
        double DTerm = D*timestep/(disblock*disblock);
//        int pass = 0;
        double time = 0.0;
//        double Cmin;
//        double Cmax;
        double ratio = 0.0;

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
            } //end of for loops

            double sumval = 0.0;
            double max = A[0,0,0];
            double min = A[0,0,0];

            for(i=0;i<N;i++)
            {
                for(j=0;j<N;j++)
                {
                    for(k=0;k<N;k++)
                    {
                        if(max < A[i,j,k])
                        {
                            max = A[i,j,k];
                        }
                        if(min > A[i,j,k])
                        {
                            min = A[i,j,k];
                        }
                        sumval += A[i,j,k];
                    }
                }
            }
            ratio = min/max;

            Console.WriteLine(time + " " + ratio + " " + sumval);

        } //end of while loop
        Console.WriteLine("Box equilibrated in " + time + " seconds of simulated time.");
    }
}

