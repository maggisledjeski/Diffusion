#!/usr/bin/python
def Cma(*list):
    length = len(list)
    sorted(list, reverse=True)
#    print list[0]
    return list[0]

def Cmi(*list):
    length = len(list)
#    print list[length-1]
    return list[length-1]

tacc=0
Lroom=5
Msize=10.0
urms=250.0
D=0.175
elementList = []
tstep=(Lroom/urms)/Msize
h=Lroom/Msize
fc=10 #sets the first cube to 100

N=10
L = []
A = [[[0 for n in range (N)] for m in range(N)] for l in range(N)]
#set all cubes = 0
for l in range(0,N):
    for m in range(0,N):
        for n in range(0,N):
            if l==0 and m==0 and n==0:
                A[0][0][0] = 10
            else:
                A[l][m][n] = 0
            L.append(A[l][m][n])
#            print "A[%d][%d][%d] = %d" % (i, j, k, A[i][j][k])
ma = Cma(*L)
mi = Cmi(*L)
x = mi/float(ma)
print "Cmax =", ma
print "Cmin =", mi
print "Cmin/Cmax =", x

while x <= .99:
    tacc = tacc + tstep
    #keeps position in the room
    for l in range(0,N):
        for m in range(0,N):
            for n in range(0,N):
                #access each volume cube from here
                #print A[0][0][0]
                i=l
                j=m
                k=n
                for i in range(i,N):
                    for j in range(j,N):
                        for k in range(k,N):
                            if i > 0 and j > 0:
                                A[i][j][k] = A[i-1][j-1][k]-2
                            elif j > 0:
                                A[i][j][k] = A[i][j-1][k]-1
                            elif i > 0:
                                A[i][j][k] = A[i-1][j][k]-1
                            else:
                                A[i][j][k] = i*N*N-j*N-k-1+fc
                                A[i][j][k] = A[i][j][k]+1
                        elementList.append(A[i][j][k])
                print "A[%d][%d][%d] = %d" % (i, j, k, A[i][j][k])
                ma = Cma(*elementList)
                mi = Cmi(*elementList)
                x = mi/float(ma)
                print "Cmax =", ma
                print "Cmin =", mi
                print "Cmin/Cmax =", x
                elementList = []
    #ma = Cma(*elementList)
    #mi = Cmi(*elementList)
    #x = mi/float(ma)
    #print x
