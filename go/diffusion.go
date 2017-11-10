package main
// Go code checked on 10/20/17
import (
    "fmt"
    "strings"
    "time"
)
//function to run diffusion
func diffusion() {
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
    time := 0.0                             //tracks simulated time
    ratio := 0.0                            //the ratio of the min concentration/the max concentration

    //User input: enter yes in order to run the program with a partition. The default case will run without a partition.
    fmt.Print("To run program with a partition please enter 'yes', to run without a partition please enter 'no': ")
    var input string
    var lowerinput string
    fmt.Scanln(&input)
    lowerinput = strings.ToLower(input) //changes the input to lower case
    fmt.Println(strings.ToLower(input))
    
    switch lowerinput {
        case "yes":
            //***start of partition code***
            fmt.Println("This program will run with a partition...")

            //initializes the initial values of the cube as well as the walls
            for i=0; i < N; i++ {
                for j=0; j<N; j++ {
                    for k=0; k<N; k++ {
                        if i==0 && j==0 && k==0 {
                            A[0][0][0] = 1.0e21
                        } 
                        if j>=(N/2)-1 && k==(N/2)-1 {
                            A[i][j][k] = -1       //-1 is the value of a wall
                        } else {
                            A[i][j][k] = 0.0
                        }
                    }
                }
            }
            A[0][0][0] = 1.0e21     //initializes the first cube to 1.0e21
            
            //Goes through each block of two versions of the room (original[i][j][k]) and new([l][n][m])) and compares the concentration (ratio) 
            //of every block next to it as long as the current block is not a wall. Also, the if statement containing all of the cases has an extra 
            //case to check if that specific block next to the current is not a wall ex. A[l][m][n+1]!=-1. The change (change of concentration) 
            //between the ratios is subtracted from the original and added to the new, in order to show the concentration of the gas changes 
            //as simulated time continues.

            for ratio<0.99 {
                time = time + timestep  //increments the simulated time
                for i=0; i<N; i++ {
                    for j=0; j<N; j++ {
                        for k=0; k<N; k++ {
                            for l=0; l<N; l++ {
                                for m=0; m<N; m++ {
                                    for n=0; n<N; n++ {
                                        if A[l][m][n] != -1 {   //checks that the current block is not a wall
                                            if((i==l)&&(j==m)&&(k==n+1)&&(A[l][m][n+1]!=-1))||((i==l)&&(j==m)&&(k==n-1)&&(A[l][m][n-1]!=-1))||((i==l)&&(j==m+1)&&(k==n)&&(A[l][m+1][n]!=-1))||((i==l)&&(j==m-1)&&(k==n)&&(A[l][m-1][n]!=-1))||((i==l+1)&&(j==m)&&(k==n)&&(A[l+1][m][n]!=-1))||((i==l-1)&&(j==m)&&(k==n)&&(A[l-1][m][n]!=-1)) {
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
                } 

                //Check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes outside the cube.
                //Determines the new ratio after every step: divides the new min by the new max.
                sumval := 0.0         //sum of the concentrations of every block in the cube
                max := A[0][0][0]     //block with the highest concentration
                min := A[0][0][0]     //block with the lowest concentration

                for i=0; i<N; i++ {
                    for j=0; j<N; j++ {
                        for k=0; k<N; k++ {
                            if A[i][j][k] != -1 {
                                if max < A[i][j][k] {
                                    max = A[i][j][k]    //new max if a bigger concentration is found within the cube
                                }
                                if min > A[i][j][k] {
                                    min = A[i][j][k]    //new min if a smaller concentration is found within the cube
                                }
                                sumval += A[i][j][k]    //adds the sum of every block in the cube
                            }
                        }
                    }
                }
                ratio = min/max     //calculates the updated ratio for every step

                fmt.Printf("%g %g %g\n", time, ratio, sumval)
            }
            fmt.Printf("Box equilibrated in %g seconds of simulated time with a partition.\n", time)
        //***end of partition code***

        //***start of non-partition code***
        case "no":
            fmt.Println("This program will run without a partition...")
    
            //initializes the first cube to 1.0e21 and the others to 0.0
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
    
            //Goes through each block of two versions of the room (original[i][j][k]) and new([l][n][m]))and compares the concentration (ratio)
            //of every block next to it. The change (change of concentration) between the ratios is subtracted from the original and added to the new,
            //in order to show the concentration of the gas changes as simulated time continues.

            for ratio<0.99 {
                time = time + timestep  //increments the simulated time
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

                //Check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes outside the cube.
                //Determines the new ratio after every step: divides the new min by the new max.
                sumval := 0.0         //sum of the concentrations of every block in the cube
                max := A[0][0][0]     //block with the highest concentration
                min := A[0][0][0]     //block with the lowest concentration

                for i=0; i<N; i++ {
                    for j=0; j<N; j++ {
                        for k=0; k<N; k++ {
                            if max < A[i][j][k] {
                                max = A[i][j][k]    //new max if a bigger concentration is found within the cube
                            }
                            if min > A[i][j][k] {
                                min = A[i][j][k]    //new min if a smaller concentration is found within the cube
                            }
                            sumval += A[i][j][k]    //adds the sum of every block in the cube
                        }
                    }
                }
                ratio = min/max     //calculates the updated ratio for every step

                fmt.Printf("%g %g %g\n", time, ratio, sumval)
            } 
            fmt.Printf("Box equilibrated in %g seconds of simulated time without a partition.\n", time)
            //***end of non-partition code***

        //if invalid input is entered
        default:
            fmt.Printf("Entered an invalid input")
    }    
}
//function to track the wall time of the diffusion function
func main() {
    start := time.Now()
    diffusion()
    end := time.Now()
    fmt.Printf("Wall Time:  %v\n", end.Sub(start))
  }
