PROGRAM diffusion

USE diffusion_mod
real (kind=4)::cubesum
integer::mem_stat

print*,"How big is the cube?"
read*,mdim

call fill_cube
cubesum=sum(cube)

print*,cubesum

deallocate(cube,STAT=mem_stat)
if(mem_stat/=0)STOP "ERROR DEALLOCATING ARRAY"

END PROGRAM diffusion

SUBROUTINE fill_cube

USE diffusion_mod
integer::mem_stat

allocate(cube(mdim,mdim,mdim),STAT=mem_stat)
if(mem_stat/=0)STOP "MEMORY ALLOCATION ERROR"

forall(i=1:mdim,j=1:mdim,k=1:mdim)cube(i,j,k)=1.0

END SUBROUTINE fill_cube

