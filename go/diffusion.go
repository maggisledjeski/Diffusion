package main
// Go code checked on 10/20/17
import (
    "fmt"
    "strings"
)

func main() {
    //Varibles that are the same for setting up the cube with or without the partition
    const N int = 10                        //maxsize
    var A[N][N][N]float64                   //cube declaration of size NxNxN
    var i,j,k,l,m,n int

    x := 10.0                               //N but a double
    D := 0.175                              //diffusion coefficient
    room := 5.0                             //room dimension is 5 meters
    speed := 250.0                          //speed of gas molecule based on 100 g/mol gas at RT
    timestep := (room/speed)/x              //basis for spatial stepsizes with respect to position in seconds
    disblock := room/x                      //is the distance between blocks
    DTerm := D*timestep/(disblock*disblock) //
    time := 0.0
    ratio := 0.0

    //User input: enter yes in order to run the program with a partition. The default case will run without a partition.
    fmt.Print("To run program with a partition please enter 'yes': ")
    var input string
    var lowerinput string
    fmt.Scanln(&input)
    lowerinput = strings.ToLower(input) //changes the input to lower case
    fmt.Println(strings.ToLower(input))
    switch lowerinput {
        case "yes":
            //the program will run with a partition
            fmt.Println("will run with a partition...")

            //initializes the initial values of the cube as well as the walls
            for i=0; i < N; i++ {
                for j=0; j<N; j++ {
                    for k=0; k<N; k++ {
                        if i==0 && j==0 && k==0 {
                            A[0][0][0] = 1.0e21
                        } 
                        if j>=N/2 && k==N/2 {
                            A[i][j][k] = -100       //-100 is the value of a wall
                        } else {
                            A[i][j][k] = 0.0
                        }
                    }
                }
            }
//            to print
//            for i=0; i < N; i++ {
//                for j=0; j<N; j++ {
//                    for k=0; k<N; k++ {
//                        fmt.Print(A[i][j][k] );
//                    }
//                    fmt.Println();
//                }
//                fmt.Println();
//            }
            
            for ratio<0.99 {
                time = time + timestep
                for i=0; i<N; i++ {
                    for j=0; j<N; j++ {
                        for k=0; k<N; k++ {
                            for l=0; l<N; l++ {
                                for m=0; m<N; m++ {
                                    for n=0; n<N; n++ {
                                        if A[l][m][n] != -100 {
                                            if((i==l)&&(j==m)&&(k==n+1)&&(A[l][m][n+1]!=-100))||((i==l)&&(j==m)&&(k==n-1)&&(A[l][m][n-1]!=-100))||((i==l)&&(j==m+1)&&(k==n)&&(A[l][m+1][n]!=-100))||((i==l)&&(j==m-1)&&(k==n)&&(A[l][m-1][n]!=-100))||((i==l+1)&&(j==m)&&(k==n)&&(A[l+1][m][n]!=-100))||((i==l-1)&&(j==m)&&(k==n)&&(A[l-1][m][n]!=-100)) {
                                                change := (A[i][j][k]-A[l][m][n])*DTerm;
                                                A[i][j][k] = A[i][j][k] - change;
                                                A[l][m][n] = A[l][m][n] + change;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }   //end of fors
                
                sumval := 0.0
                max := A[0][0][0]
                min := A[0][0][0]

                for i=0; i<N; i++ {
                    for j=0; j<N; j++ {
                        for k=0; k<N; k++ {
                            if A[i][j][k] != -100 {
                                if max < A[i][j][k] {
                                    max = A[i][j][k]    //new max if a bigger concentration is found within the cube
                                }
                                if min > A[i][j][k] {
                                    min = A[i][j][k]    //new min if a smaller concentration is found within the cube
                                }
                                sumval += A[i][j][k]
                            }
                        }
                    }
                }
                ratio = min/max
                fmt.Printf("%g %g %g\n", time, ratio, sumval)
            }
            fmt.Printf("Box equilibrated in %g seconds of simulated time with a partition.\n", time)
        //end of partition code
        default:
            //the program will run without a partition
            fmt.Println("will run without a partition...")
    
            //initializes the initial values of the cube
            for i=0; i < N; i++ {
                for j=0; j<N; j++ {
                    for k=0; k<N; k++ {
                        if i==0 && j==0 && k==0 {
                            A[0][0][0] = 1.0e21
                        } else {
                            A[i][j][k] = 0.0
                        }
                    }
                }
            }
    
            //goes through each block of two versions (original(i,j,k) and new(l,n,m)) and compares the concentration (ratio) of every block next to it
            //the change (change of concentration) between the ratios is subtracted from the original and added to the new, in order to show the concentration
            //of the gas changes as time continues

            for ratio<0.99 {
                time = time + timestep
                for i=0; i<N; i++ {
                    for j=0; j<N; j++ {
                        for k=0; k<N; k++ {
                            for l=0; l<N; l++ {                    
                                for m=0; m<N; m++ {
                                    for n=0; n<N; n++ {
                                        if ((i==l)&&(j==m)&&(k==n+1))||((i==l)&&(j==m)&&(k==n-1))||((i==l)&&(j==m+1)&&(k==n))||((i==l)&&(j==m-1)&&(k==n))||((i==l+1)&&(j==m)&&(k==n))||((i==l-1)&&(j==m)&&(k==n)) {
                                            change := (A[i][j][k]-A[l][m][n])*DTerm
                                            A[i][j][k] = A[i][j][k] - change
                                            A[l][m][n] = A[l][m][n] + change
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                //check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes outside the cube
                //determines the new ratio after 1 step: divides the new min by the new max

                sumval := 0.0
                max := A[0][0][0]
                min := A[0][0][0]

                for i=0; i<N; i++ {
                    for j=0; j<N; j++ {
                        for k=0; k<N; k++ {
                            if max < A[i][j][k] {
                                max = A[i][j][k]    //new max if a bigger concentration is found within the cube
                            }
                            if min > A[i][j][k] {
                                min = A[i][j][k]    //new min if a smaller concentration is found within the cube
                            }
                            sumval += A[i][j][k]
                        }
                    }
                }
                ratio = min/max
                fmt.Printf("%g %g %g\n", time, ratio, sumval)
            } 
            fmt.Printf("Box equilibrated in %g seconds of simulated time without a partition.\n", time)
    }
}
