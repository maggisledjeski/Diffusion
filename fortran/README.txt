README FILE FOR FORTRAN CODE:

In this repository the file, diffusion.f90 and diffusion_mod.f90, contains the code of my project.
This file asks for user input on how to run the program, using a subroutine for a partition and one without a partition. Users navigate this by using an 
if statement whether the user wants to run a partition or not. Before the user is transferred to the subroutine, they are asked for the size of the room, and
it is stored in the variable mdim.

In order to run this program correctly, please read the following:

TO RUN WITHOUT A PARTITION:
Compile the code by typing: gfortran diffusion_mod.f90 diffusion.f90
Run the code by typing: a.out
*To get wall time: run the code by typing: time ./a.out
Code will prompt you with: "To run this program with a partition type 'Y' then press enter. To run this program without a partion type 'N' then press enter"
Type: N
Then press the enter key.
You will see a confirmation statement: "This program will run without a partition..."
If you do not enter either Y or N, "Entered an invalid input" is printed to the screen and the program will end.
The user will be prompted with, "How big is the cube?"
Type and integer number then hit enter. If an invalid input is entered, the program will end.
Then the simulated time, the ratio, and the mass consistency are printed to the screen after each step is taken.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time without a partition." 

TO RUN WITH A PARTITION:
Compile the code by typing: gfortran diffusion_mod.f90 diffusion.f90
Run the code by typing: a.out
*To get wall time: run the code by typing: time ./a.out
Code will prompt you with: "To run this program with a partition type 'Y' then press enter. To run this program without a partion type 'N' then press enter"
Type: Y
Then press the enter key.
You will see a confirmation statement: "This program will run with a partition..."
If you do not enter either Y or N, "Entered an invalid input" is printed to the screen and the program will end.
The user will be prompted with, "How big is the cube?"
Type and integer number then hit enter. If an invalid input is entered, the program will end.
Then the simulated time, the ratio, and the mass consistency are printed to the screen after each step is taken.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time with a partition."

