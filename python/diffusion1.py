#!/usr/bin/python
import time

def diffusion():
    #user input for Msize
    msize = int(raw_input("Enter the size of the cube: "))
    print "you entered", msize
    if msize > 0 and msize < 100:
        N=msize     #maxsize integer
        R=float(N)  #maxsize float
        A = [[[0.0 for k in range (N)] for j in range(N)] for i in range(N)]  #sets up the 3d array and sets all values to 0.0

#Python checked on 10/25/17

        #Varibles that are the same for setting up the cube with or without the partition
        A[0][0][0]=1.0e21                       #sets A[0][0][0] to 1.0e21
        D=0.175                                 #diffusion coefficient
        roomD=5.0                               #room size in meters
        speed=250.0                             #speed of gas molecule based on 100 g/mol gas at RT
        timestep=(roomD/speed)/R                #basis for spatial stepsizes with respect to position in seconds
        disblock=roomD/R                        #is the distance between blocks
        DTerm=D*timestep/(disblock*disblock)    #
        time=0.0                                #keeps track of simulation time
        ratio=0.0                               #the ratio of the min concentration/max concentration in A

        validAnswer = "no"                      #used to compare the user input
        while validAnswer == "no":
            var = raw_input("Please enter 'y' for partition, and 'n' to run without a partition: ")
            print "you entered", var            #user input
            if var=="y":    #runs the program with a partition
                print "This program will run with a partition..."
                validAnswer = "yes"     #breaks the while loop
                for i in range(0,N):    #3 for loops set up the wall, and store the value of -1 at these locations
                    for j in range(0,N):
                        for k in range(0,N):
                            if j >= (N/2)-1 and k == (N/2)-1:
                                A[i][j][k] = -1 #wall is equal to -1
                A[0][0][0] = 1.0e21
                while ratio <= .99:
                    for i in range(0,N):
                        for j in range(0,N):
                            for k in range(0,N):
                                if A[i][j][k] != -1:    #checks to make sure that the current block is not a wall
                                    if k+1 < N and k-1 >= 0:
                                        if A[i][j][k+1] != A[i][j][k] and A[i][j][k+1] != -1:
                                            change=(A[i][j][k]-A[i][j][k+1])*DTerm
                                            A[i][j][k]=A[i][j][k]-change
                                            A[i][j][k+1]=A[i][j][k+1]+change
                                        if A[i][j][k-1] != A[i][j][k] and A[i][j][k-1] != -1:
                                            change=(A[i][j][k]-A[i][j][k-1])*DTerm
                                            A[i][j][k]=A[i][j][k]-change
                                            A[i][j][k-1]=A[i][j][k-1]+change
                                    if j+1 < N and j-1 >= 0:
                                        if A[i][j+1][k] != A[i][j][k] and A[i][j+1][k] != -1:
                                            change=(A[i][j][k]-A[i][j+1][k])*DTerm
                                            A[i][j][k]=A[i][j][k]-change
                                            A[i][j+1][k]=A[i][j+1][k]+change
                                        if A[i][j-1][k] != A[i][j][k] and A[i][j-1][k] != -1:
                                            change=(A[i][j][k]-A[i][j-1][k])*DTerm
                                            A[i][j][k]=A[i][j][k]-change
                                            A[i][j-1][k]=A[i][j-1][k]+change
                                    if i+1 < N and i-1 >= 0:
                                        if A[i+1][j][k] != A[i][j][k] and A[i+1][j][k] != -1:
                                            change=(A[i][j][k]-A[i+1][j][k])*DTerm
                                            A[i][j][k]=A[i][j][k]-change
                                            A[i+1][j][k]=A[i+1][j][k]+change
                                        if A[i-1][j][k] != A[i][j][k] and A[i-1][j][k] != -1:
                                            change=(A[i][j][k]-A[i-1][j][k])*DTerm
                                            A[i][j][k]=A[i][j][k]-change
                                            A[i-1][j][k]=A[i-1][j][k]+change
                    time=time+timestep  #increments the simulation time
                    sumval=0.0          #sum of the concentrations of every block in the cube
                    maxval=A[0][0][0]   #block with the highest concentration
                    minval=A[0][0][0]   #block with the smallest concentration
                    for i in range(0,N):
                        for j in range(0,N):
                            for k in range(0,N):
                                if A[i][j][k] != -1:
                                    if maxval<A[i][j][k]:
                                        maxval=A[i][j][k]   #new max if a bigger concentration is found within the cube
                                    if minval>A[i][j][k]:
                                        minval=A[i][j][k]   #new min if a smaller concentration is found within the cube
                                    sumval=sumval+A[i][j][k]

                    ratio=minval/maxval     #calculates the new ratio after each step
                    print time, ratio, sumval
                print "Box equilibrated in ",time," seconds of simulated time with a partition."
            elif var=="n":  #runs the program without a partition
                print "This program will run without a partition..."
                validAnswer = "yes" #breaks the while loop
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
                    time=time+timestep  #increments the simulation time
                    sumval=0.0          #sum of the concentrations of every block in the cube
                    maxval=A[0][0][0]   #block with the highest concentration
                    minval=A[0][0][0]   #block with the smallest concentration
                    for i in range(0,N):
                        for j in range(0,N):
                            for k in range(0,N):
                                if maxval<A[i][j][k]:
                                    maxval=A[i][j][k]   #new max if a bigger concentration is found within the cube
                                if minval>A[i][j][k]:
                                    minval=A[i][j][k]   #new min if a smaller concentration is found within the cube
                                sumval=sumval+A[i][j][k]

                    ratio=minval/maxval #calculates the new ratio after each step
                    print time, ratio, sumval
                print "Box equilibrated in ",time," seconds of simulated time without a partition."
            else:   #will continue to loop until the user enters a valid input
                print "invalid input"
    else:
        print "invalid input"    

#wall time
t0 = time.time()
diffusion() #calls the diffusion method
print "Wall Time: ", time.time() - t0, "seconds"
