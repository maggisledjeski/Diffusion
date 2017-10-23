PROGRAM diffusion

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

!cube(0,0,0)=1000000000000000000000_real64
cube(0,0,0)=1.0e21!1.0*10.0**21!1.0e21
cube(mdim,mdim,mdim)=10
!print *, cube(mdim,mdim,mdim)
do while (ratio<0.99)
    do i=1,mdim
!        if ((i.eq.l .and. j.eq.m .and. k.eq.n-1).or.(i.eq.l .and. j.eq.m .and. k.eq.n+1)&
!            .or.(i.eq.l .and. j.eq.m+1 .and. k.eq.n).or.(i.eq.l .and. j.eq.m-1 .and. k.eq.n)&
!            .or.(i.eq.l+1 .and. j.eq.m .and. k.eq.n).or.(i.eq.l-1 .and. j.eq.m .and. k.eq.n)) then
!            change=(cube(i,j,k)-cube(l,m,n))*DTerm
!            cube(i,j,k)=cube(i,j,k)-change
!            cube(l,m,n)=cube(l,m,n)+change
!        end if
        do j=1,mdim
            do k=1,mdim
                do l=1,mdim
                    do m=1,mdim
                        do n=1,mdim
                            if ((i.eq.l .and. j.eq.m .and. k.eq.n-1).or.(i.eq.l .and. j.eq.m .and. k.eq.n+1)&
                                .or.(i.eq.l .and. j.eq.m+1 .and. k.eq.n).or.(i.eq.l .and. j.eq.m-1 .and. k.eq.n)&
                                .or.(i.eq.l+1 .and. j.eq.m .and. k.eq.n).or.(i.eq.l-1 .and. j.eq.m .and. k.eq.n)) then
                                change=(cube(i,j,k)-cube(l,m,n))*DTerm
                                cube(i,j,k)=cube(i,j,k)-change
                                cube(l,m,n)=cube(l,m,n)+change
                            end if
                        end do
                    end do
                end do
            end do
!            if ((i.eq.l .and. j.eq.m .and. k.eq.n-1).or.(i.eq.l .and. j.eq.m .and. k.eq.n+1)&
!                .or.(i.eq.l .and. j.eq.m+1 .and. k.eq.n).or.(i.eq.l .and. j.eq.m-1 .and. k.eq.n)&
!                .or.(i.eq.l+1 .and. j.eq.m .and. k.eq.n).or.(i.eq.l-1 .and. j.eq.m .and. k.eq.n)) then
!                change=(cube(i,j,k)-cube(l,m,n))*DTerm
!                cube(i,j,k)=cube(i,j,k)-change
!                cube(l,m,n)=cube(l,m,n)+change
!            end if
        end do
    end do
    
    time=time+timestep
    sumval=0.0
    maxelement=cube(0,0,0)!maxval(cube)
    minelement=cube(0,0,0)!minval(cube)
    do i=1,mdim
!        if (maxelement<cube(i,j,k)) then!sumval=sumval+cube(i,j,k)
!            maxelement=cube(i,j,k)
!        end if
!        if (minelement>cube(i,j,k)) then
!            minelement=cube(i,j,k)
!        end if
        do j=1,mdim
            do k=1,mdim
                if (maxelement<cube(i,j,k)) then!sumval=sumval+cube(i,j,k)
                    maxelement=cube(i,j,k)
                end if
                if (minelement>cube(i,j,k)) then
                    minelement=cube(i,j,k)
                end if
                !sumval=sumval+cube(i,j,k)
            end do
        end do
!        if (maxelement<cube(i,j,k)) then!sumval=sumval+cube(i,j,k)
!            maxelement=cube(i,j,k)
!        end if
!        if (minelement>cube(i,j,k)) then
!            minelement=cube(i,j,k)
!        end if
    end do
    sumval=sum(cube)
    ratio=minelement/maxelement
    print *,time," ",ratio," ",sumval

end do
    
print *,"Box equilibrated in ",time," seconds of simulated time."

!forall(i=1:mdim,j=1:mdim,k=1:mdim)cube(i,j,k)=1.0

END SUBROUTINE fill_cube

