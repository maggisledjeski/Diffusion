package main
// Go code checked on 10/20/17
import (
    "fmt"
    "strings"
)

func main() {
    const N int = 10
    var A[N][N][N]float64
    var i,j,k,l,m,n int

    x := 10.0 //N but a double
    D := 0.175
    room := 5.0
    speed := 250.0
    timestep := (room/speed)/x
    disblock := room/x
    DTerm := D*timestep/(disblock*disblock)
    time := 0.0
    ratio := 0.0

    fmt.Print("To run program with a partition please enter 'yes'")
    var input string
    var lowerinput string
    fmt.Scanln(&input)
    lowerinput = strings.ToLower(input)
    fmt.Println(strings.ToLower(input))
    switch lowerinput {
        case "yes":
            fmt.Println("will run with a partition...")
            for i=0; i < N; i++ {
                for j=0; j<N; j++ {
                    for k=0; k<N; k++ {
                        if i==0 && j==0 && k==0 {
                            A[0][0][0] = 1.0e21
                        } 
                        if j>=N/2 && k==N/2 {
                            A[i][j][k] = -100
                        } else {
                            A[i][j][k] = 0.0
                        }
                    }
                }
            }
//            for i=0; i < N; i++ {
//                for j=0; j<N; j++ {
//                    for k=0; k<N; k++ {
//                        fmt.Print(A[i][j][k] );
//                    }
//                    fmt.Println();
//                }
//                fmt.Println();
//            }
        default:
            fmt.Println("will run without a partition...")
    
//    const N int = 10
//    var A[N][N][N]float64
//    var i,j,k,l,m,n int
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
    
//    x := 10.0 //N but a double
//    D := 0.175
//    room := 5.0
//    speed := 250.0
//    timestep := (room/speed)/x
//    disblock := room/x
//    DTerm := D*timestep/(disblock*disblock)
//    time := 0.0
//    ratio := 0.0

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

        sumval := 0.0
        max := A[0][0][0]
        min := A[0][0][0]

        for i=0; i<N; i++ {
            for j=0; j<N; j++ {
                for k=0; k<N; k++ {
                    if max < A[i][j][k] {
                        max = A[i][j][k]
                    }
                    if min > A[i][j][k] {
                        min = A[i][j][k]
                    }
                    sumval += A[i][j][k]
                }
            }
        }
        ratio = min/max
        fmt.Printf("%g %g %g\n", time, ratio,sumval)
    } 
    fmt.Printf("Box equilibrated in %g seconds of simulated time without a partition.\n", time)
    }
}
