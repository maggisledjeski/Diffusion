PROGRAM diffusion

! Code checked on 10/25/17

USE diffusion_mod   !defines a cube in the diffusion_mod.f90 module
real (kind=4)::cubesum
integer::mem_stat,s
character(LEN=1)::answer
s=1 !to test if the user input a valid input
do while (s==1) 
    print*,"To run with a partition type 'Y' then press enter. To run without a partion type 'N' then press enter"
    read*,answer
    if ((answer.eq.'Y').or.(answer.eq.'N')) then
        if (answer.eq.'Y') then
            print*,"This program will run with a partition..."
            s=0 !set s to 0 to confirm that the user entered a valid input and will end the while loop after the partition code has completed running
            print*,"How big is the cube?"   !asks user for the Msize number and stores it in mdim
            read*,mdim
            print*,"Valid mdim number"
            call partition  !calls the partition subroutine
            cubesum=sum(cube)
            !print*,cubesum
            deallocate(cube,STAT=mem_stat)
            if(mem_stat/=0)STOP "ERROR DEALLOCATING ARRAY"
        else
            print*,"This program will run without a parition..."
            s=0 !set s to 0 to confirm that the user entered a valid input and will end the while loop after the non-partition code has completed running
            print*,"How big is the cube?"   !asks user for the Msize number and stores it in mdim
            read*,mdim
!            do while (s==0)
!                if (mdim <= 100) then
                    print*,"Valid mdim number"
                    call fill_cube  !calls the non-partition subroutine
                    cubesum=sum(cube)
             !       print*,cubesum
                    deallocate(cube,STAT=mem_stat)
                    if(mem_stat/=0)STOP "ERROR DEALLOCATING ARRAY"
!                else
!                    print*,"Invalid mdim number"
!                    s=1
!                end if
!            end do
        s=0
        end if
    end if
end do

END PROGRAM diffusion

SUBROUTINE fill_cube    !***starts non-partition code***

USE diffusion_mod   !uses diffusion_mod.f90 to define a cube
integer::mem_stat
real::D,roomD,speed,timestep,disblock,DTerm,time,ratio,change,sumval,maxelement,minelement
D=0.175                                 !diffusion coefficient
roomD=5                                 !room dimension is 5 meters
speed=250.0                             !speed of gas molecule based on 100 g/mol gas at RT
timestep=(roomD/speed)/mdim             !basis for spatial stepsizes with respect to position in seconds
disblock=roomD/mdim                     !is the distance between blocks
DTerm=D*timestep/(disblock*disblock)    !
time=0.0                                !tracks the simulated time
ratio=0.0                               !the ratio of the min concentration/the max concentration

allocate(cube(mdim,mdim,mdim),STAT=mem_stat)    !Allocating space for a size  mdimXmdimXmdim
if(mem_stat/=0)STOP "MEMORY ALLOCATION ERROR"

!initializes the initial values of the cube as 0.0
do i=1,mdim
    do j=1,mdim
        do k=1,mdim
            cube(i,j,k)=0.0
        end do
    end do
end do

cube(1,1,1)=1.0e21  !sets the cube at (1,1,1) to the initial concentration of 1.0e21

!Goes through each block of two versions of the room (original(i,j,k) and new(l,m,n)) and compares the concentration (ratio)
!of every block next to it. The change (change of concentration) between the ratios is subtracted from the original and added to the new, in
!order to show the concentration of the gas changes as simulated time continues.
do while (ratio<0.99)
    do i=1,mdim
        do j=1,mdim
            do k=1,mdim
                if((k+1 .lt. mdim) .and.( cube(k+1,j,i) .ne. cube(k,j,i))) then
                    change=(cube(k,j,i)-cube(k+1,j,i))*DTerm
                    cube(k,j,i)=cube(k,j,i)-change
                    cube(k+1,j,i)=cube(k+1,j,i)+change
                end if
                if((k-1 .ge. 0) .and.( cube(k-1,j,i) .ne. cube(k,j,i))) then
                    change=(cube(k,j,i)-cube(k-1,j,i))*DTerm
                    cube(k,j,i)=cube(k,j,i)-change
                    cube(k-1,j,i)=cube(k-1,j,i)+change
                end if
                if((j+1 .lt. mdim) .and.( cube(k,j+1,i) .ne. cube(k,j,i))) then
                    change=(cube(k,j,i)-cube(k,j+1,i))*DTerm
                    cube(k,j,i)=cube(k,j,i)-change
                    cube(k,j+1,i)=cube(k,j+1,i)+change
                end if
                if((j-1 .ge. 0) .and.( cube(k,j-1,i) .ne. cube(k,j,i))) then
                    change=(cube(k,j,i)-cube(k,j-1,i))*DTerm
                    cube(k,j,i)=cube(k,j,i)-change
                    cube(k,j-1,i)=cube(k,j-1,i)+change
                end if
                if((i+1 .lt. mdim) .and. (cube(k,j,i+1) .ne. cube(k,j,i))) then
                    change=(cube(k,j,i)-cube(k,j,i+1))*DTerm
                    cube(k,j,i)=cube(k,j,i)-change
                    cube(k,j,i+1)=cube(k,j,i+1)+change
                end if
                if((i-1 .ge. 0) .and.( cube(k,j,i-1) .ne. cube(k,j,i))) then
                    change=(cube(k,j,i)-cube(k,j,i-1))*DTerm
                    cube(k,j,i)=cube(k,j,i)-change
                    cube(k,j,i-1)=cube(k,j,i-1)+change
                end if

!                do l=1,mdim
!                    do m=1,mdim
!                        do n=1,mdim
!                            if (((i.eq.l).and.(j.eq.m).and.(k.eq.n-1)).or.((i.eq.l).and.(j.eq.m).and.(k.eq.n+1))&
!                                .or.((i.eq.l).and.(j.eq.m+1).and.(k.eq.n)).or.((i.eq.l).and.(j.eq.m-1).and.(k.eq.n))&
!                                .or.((i.eq.l+1).and.(j.eq.m).and.(k.eq.n)).or.((i.eq.l-1).and.(j.eq.m).and.(k.eq.n))) then
!                                change=(cube(k,j,i)-cube(n,m,l))*DTerm
!                                cube(k,j,i)=cube(k,j,i)-change
!                                cube(n,m,l)=cube(n,m,l)+change
!                            end if
!                        end do
!                    end do
!                end do
            end do
        end do
    end do
    
    time=time+timestep  !increments the simulated time
    
    !Check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes outside the cube.
    !Determines the new ratio after every step: divides the new min by the new max.
    sumval=0.0              !sets the sumval to 0.0
    maxelement=cube(1,1,1)  !sets the max concentration to the concentration in cube(1,1,1)
    minelement=cube(1,1,1)  !sets the min concentration to the concentration in cube(1,1,1)
    do i=1,mdim
        do j=1,mdim
            do k=1,mdim
                if (maxelement<cube(k,j,i)) then
                    maxelement=cube(k,j,i)          !new max if a bigger concentration is found within the cube
                end if
                if (minelement>cube(k,j,i)) then
                    minelement=cube(k,j,i)          !new min if a smaller concentration is found within the cube
                end if
                sumval=sumval+cube(k,j,i)           !adds the sum of every block in the cube
            end do
        end do
    end do
    ratio=minelement/maxelement !the ratio of the min concentration/max concentration
    print *,time," ",ratio," ",sumval

end do
    
print *,"Box equilibrated in ",time," seconds of simulated time without a partition."

END SUBROUTINE fill_cube    !***end of non-partition code***

SUBROUTINE partition    !***start of partition code***

USE diffusion_mod   !uses diffusion_mod.f90 to define a cube
integer::mem_stat
real::D,roomD,speed,timestep,disblock,DTerm,time,ratio,change,sumval,maxelement,minelement
D=0.175                                 !diffusion coefficient
roomD=5                                 !room dimension is 5 meters
speed=250.0                             !speed of gas molecule based on 100 g/mol gas at RT
timestep=(roomD/speed)/mdim             !basis for spatial stepsizes with respect to position in seconds
disblock=roomD/mdim                     !is the distance between blocks
DTerm=D*timestep/(disblock*disblock)    !
time=0.0                                !tracks the simulated time
ratio=0.0                               !the ratio of the min concentration/the max concentration

allocate(cube(mdim,mdim,mdim),STAT=mem_stat)    !Allocating space for a size  mdimXmdimXmdim
if(mem_stat/=0)STOP "MEMORY ALLOCATION ERROR"
!initializes the initial values of the cube as well as the walls
do i=1,mdim
    do j=1,mdim
        do k=1,mdim
            if (j.ge.(mdim/2) .and. k.eq.(mdim/2)) then 
                cube(i,j,k)=-1        !-1 dipicts a wall in the room
            else
                cube(i,j,k)=0.0
            end if
        end do
    end do
end do

cube(1,1,1)=1.0e21  !sets the cube at (1,1,1) to the initial concentration of 1.0e21

!Goes through each block of two versions of the room (original(i,j,k) and new(l,m,n)) and compares the concentration (ratio) 
!of every block next to it as long as the current block is not a wall. Also, the if statement containing all of the cases has an extra 
!case to check if that specific block next to the current is not a wall ex. A[l][m][n+1]!=-1. The change (change of concentration) 
!between the ratios is subtracted from the original and added to the new, in order to show the concentration of the gas changes 
!as simulated time continues.

do while (ratio<0.99)
    do i=1,mdim
        do j=1,mdim
            do k=1,mdim
                do l=1,mdim
                    do m=1,mdim
                        do n=1,mdim
                            if (cube(n,m,l) .ne. -1) then
                                if (((i.eq.l).and.(j.eq.m).and.(k.eq.n-1).and.(cube(n-1,m,l).ne.-1)).or.&
                                    ((i.eq.l).and.(j.eq.m).and.(k.eq.n+1).and.(cube(n+1,m,l).ne.-1)).or.&
                                    ((i.eq.l).and.(j.eq.m+1).and.(k.eq.n).and.(cube(n,m+1,l).ne.-1)).or.&
                                    ((i.eq.l).and.(j.eq.m-1).and.(k.eq.n).and.(cube(n,m-1,l).ne.-1)).or.&
                                    ((i.eq.l+1).and.(j.eq.m).and.(k.eq.n).and.(cube(n,m,l+1).ne.-1)).or.&
                                    ((i.eq.l-1).and.(j.eq.m).and.(k.eq.n).and.(cube(n,m,l-1).ne.-1))) then
                                        change=(cube(k,j,i)-cube(n,m,l))*DTerm
                                        cube(k,j,i)=cube(k,j,i)-change
                                        cube(n,m,l)=cube(n,m,l)+change
                                end if
                            end if
                        end do
                    end do
                end do
            end do
        end do
    end do

    time=time+timestep  !increments the simulated time

    !Check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes outside the cube.
    !Determines the new ratio after every step: divides the new min by the new max.
    sumval=0.0                  !sets the sumval to 0.0
    maxelement=cube(1,1,1)      !sets the max concentration to the concentration in cube(1,1,1)
    minelement=cube(1,1,1)      !sets the min concentration to the concentration in cube(1,1,1)
    do i=1,mdim
        do j=1,mdim
            do k=1,mdim
                if (cube(k,j,i).ne.-1) then
                    if (maxelement<cube(k,j,i)) then
                        maxelement=cube(k,j,i)          !new max if a bigger concentration is found within the cube
                    end if
                    if (minelement>cube(k,j,i)) then
                        minelement=cube(k,j,i)          !new min if a smaller concentration is found within the cube
                    end if
                    sumval=sumval+cube(k,j,i)           !adds the sum of every block in the cube
                end if
            end do
        end do
    end do
    ratio=minelement/maxelement !the ratio of the min concentration/max concentration
    print *,time," ",ratio," ",sumval

end do

print *,"Box equilibrated in ",time," seconds of simulated time with the partition."

END SUBROUTINE partition    !***end of partition code***
