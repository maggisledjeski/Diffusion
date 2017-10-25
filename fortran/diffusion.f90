PROGRAM diffusion

! Code checked on 10/25/17

USE diffusion_mod
real (kind=4)::cubesum
integer::mem_stat

print*,"How big is the cube?"
read*,mdim
!mdim=10
call fill_cube
cubesum=sum(cube)

print*,cubesum

deallocate(cube,STAT=mem_stat)
if(mem_stat/=0)STOP "ERROR DEALLOCATING ARRAY"

END PROGRAM diffusion

SUBROUTINE fill_cube

USE diffusion_mod
integer::mem_stat
real::D,roomD,speed,timestep,disblock,DTerm,time,ratio,change,sumval,maxelement,minelement
D=0.175
roomD=5
speed=250.0
timestep=(roomD/speed)/mdim
disblock=roomD/mdim
DTerm=D*timestep/(disblock*disblock)
time=0.0
ratio=0.0

allocate(cube(mdim,mdim,mdim),STAT=mem_stat)
if(mem_stat/=0)STOP "MEMORY ALLOCATION ERROR"

do i=1,mdim
    do j=1,mdim
        do k=1,mdim
            cube(i,j,k)=0.0
        end do
    end do
end do

cube(1,1,1)=1.0e21
do while (ratio<0.99)
    do i=1,mdim
        do j=1,mdim
            do k=1,mdim
                do l=1,mdim
                    do m=1,mdim
                        do n=1,mdim
                            if (((i.eq.l).and.(j.eq.m).and.(k.eq.n-1)).or.((i.eq.l).and.(j.eq.m).and.(k.eq.n+1))&
                                .or.((i.eq.l).and.(j.eq.m+1).and.(k.eq.n)).or.((i.eq.l).and.(j.eq.m-1).and.(k.eq.n))&
                                .or.((i.eq.l+1).and.(j.eq.m).and.(k.eq.n)).or.((i.eq.l-1).and.(j.eq.m).and.(k.eq.n))) then
                                change=(cube(k,j,i)-cube(n,m,l))*DTerm
                                cube(k,j,i)=cube(k,j,i)-change
                                cube(n,m,l)=cube(n,m,l)+change
                            end if
                        end do
                    end do
                end do
            end do
        end do
    end do
    
    time=time+timestep
    sumval=0.0
    maxelement=cube(1,1,1)
    minelement=cube(1,1,1)
    do i=1,mdim
        do j=1,mdim
            do k=1,mdim
                if (maxelement<cube(k,j,i)) then
                    maxelement=cube(k,j,i)
                end if
                if (minelement>cube(k,j,i)) then
                    minelement=cube(k,j,i)
                end if
                sumval=sumval+cube(k,j,i)
            end do
        end do
    end do
    ratio=minelement/maxelement
    print *,time," ",ratio," ",sumval

end do
    
print *,"Box equilibrated in ",time," seconds of simulated time."

END SUBROUTINE fill_cube

