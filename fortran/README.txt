README FILE FOR FORTRAN CODE:

In this repository the file, diffusion.f90 and diffusion_mod.f90, contains the code of my project.
This file asks for user input on how to run the program, using a subroutine for a partition and one without a partition. Users navigate this by using an if staatement whether the user wants to run a partition or not.

In order to run this program correctly, please read the following:

TO RUN WITHOUT A PARTITION:
Compile the code by typing: gfortran diffusion_mod.f90 diffusion.f90
Run the code by typing: a.out
Code will prompt you with: "To run this program with a partition type 'Y' then press enter. To run this program without a partion type 'N' then press enter"
Type: N
Then press the enter key.
You will see a confirmation statement: "This program will run without a partition..."
If you do not enter either Y or N, "Entered an invalid input" is printed to the screen and the program will end.
The user will be prompted with, "How big is the cube?"
Type and integer number then hit enter.
"Valid input entered" will be printed to the screen
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time without a partition." 

TO RUN WITH A PARTITION:
Compile the code by typing: gfortran diffusion_mod.f90 diffusion.f90
Run the code by typing: a.out
Code will prompt you with: "To run this program with a partition type 'Y' then press enter. To run this program without a partion type 'N' then press enter"
Type: Y
Then press the enter key.
You will see a confirmation statement: "This program will run with a partition..."
If you do not enter either Y or N, "Entered an invalid input" is printed to the screen and the program will end.
The user will be prompted with, "How big is the cube?"
Type and integer number then hit enter.
"Valid input entered" will be printed to the screen
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time with a partition."

