package main
// Go code checked on 10/20/17
import "fmt"

func main() {

   fmt.Println("hello irma")

    const N int = 10
    var A[N][N][N]float64
    var i,j,k,l,m,n int
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
    
    x := 10.0 //N but a double
    D := 0.175
    room := 5.0
    speed := 250.0
    timestep := (room/speed)/x
    disblock := room/x
    DTerm := D*timestep/(disblock*disblock)
    time := 0.0
    ratio := 0.0

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
    fmt.Printf("Box equilibrated in %g seconds of simulated time.\n", time)
}
