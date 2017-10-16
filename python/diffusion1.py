#!/usr/bin/python
N=10
R=float(N)
A = [[[0 for k in range (N)] for j in range(N)] for i in range(N)]
#set all cubes = 0
for i in range(0,N):
    for j in range(0,N):
        for k in range(0,N):
            if i==0 and j==0 and k==0:
                A[0][0][0] = 1.0e21
            else:
                A[i][j][k] = 0

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
                for l in range(0,N):
                    for m in range(0,N):
                        for n in range(0,N):
                            if (i==l and j==m and k==n+1) or (i==l and j==m and k==n-1) or (i==l and j==m+1 and k==n) or (i==l and j==m-1 and k==n) or (i==l+1 and j==m and k==n) or (i==l-1 and j==m and k==n):
                                change=(A[i][j][k]-A[l][m][n])*DTerm
                                A[i][j][k]=A[i][j][k]-change
                                A[l][m][n]=A[l][m][n]+change
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
