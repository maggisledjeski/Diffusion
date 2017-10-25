#!/usr/bin/python
N=10
R=float(N)
A = [[[0 for k in range (N)] for j in range(N)] for i in range(N)]

#Python checked on 10/25/17

A[0][0][0]=1.0e21
D=0.175
roomD=5
speed=250.0
timestep=(roomD/speed)/R
disblock=roomD/R
DTerm=D*timestep/(disblock*disblock)
time=0.0
ratio=0.0

while ratio <= .99:
    for i in range(0,N):
        for j in range(0,N):
            for k in range(0,N):
                if k+1 < N and k-1 >= 0:
                    if A[i][j][k+1] != A[i][j][k]:
                        change=(A[i][j][k]-A[i][j][k+1])*DTerm
                        A[i][j][k]=A[i][j][k]-change
                        A[i][j][k+1]=A[i][j][k+1]+change
                    if A[i][j][k-1] != A[i][j][k]:
                        change=(A[i][j][k]-A[i][j][k-1])*DTerm
                        A[i][j][k]=A[i][j][k]-change
                        A[i][j][k-1]=A[i][j][k-1]+change
                if j+1 < N and j-1 >= 0:
                    if A[i][j+1][k] != A[i][j][k]:
                        change=(A[i][j][k]-A[i][j+1][k])*DTerm
                        A[i][j][k]=A[i][j][k]-change
                        A[i][j+1][k]=A[i][j+1][k]+change
                    if A[i][j-1][k] != A[i][j][k]:
                        change=(A[i][j][k]-A[i][j-1][k])*DTerm
                        A[i][j][k]=A[i][j][k]-change
                        A[i][j-1][k]=A[i][j-1][k]+change
                if i+1 < N and i-1 >= 0:
                    if A[i+1][j][k] != A[i][j][k]:
                        change=(A[i][j][k]-A[i+1][j][k])*DTerm
                        A[i][j][k]=A[i][j][k]-change
                        A[i+1][j][k]=A[i+1][j][k]+change
                    if A[i-1][j][k] != A[i][j][k]:
                        change=(A[i][j][k]-A[i-1][j][k])*DTerm
                        A[i][j][k]=A[i][j][k]-change
                        A[i-1][j][k]=A[i-1][j][k]+change
    time=time+timestep
    sumval=0.0
    maxval=A[0][0][0]
    minval=A[0][0][0]
    for i in range(0,N):
        for j in range(0,N):
            for k in range(0,N):
                if maxval<A[i][j][k]:
                    maxval=A[i][j][k]
                if minval>A[i][j][k]:
                    minval=A[i][j][k]
                sumval=sumval+A[i][j][k]

    ratio=minval/maxval
    print time, ratio, sumval
print "Box equilibrated in ",time," seconds of simulated time."
