README FILE FOR LISP CODE:

In this repository the file, diffusion.lisp, contains the code of my project.

This file asks for user input on the size of the room. Then, asks how the user wants to run the program, using three if statements to control whether the user wants to run a partition or not.

In order to run this program correctly, please read the following:

TO RUN WITHOUT A PARTITION:
Compile the code by typing: chmod u+x diffusion.lisp
Run the code by typing: ./diffusion.lisp
*To get wall time: run the code by typing: time ./diffusion.lisp
Code will prompt the user with: "Enter size of cube: "
Type and integer number then hit enter. If an invalid input is entered, the program will end.
Code will prompt the user with: "Enter n to run without a partition, and y to run with a partition: "
Type: n
Then press the enter key.
You will see a confirmation statement: "This program will run without a partition..."
If the user does not enter either y or n, "Invalid input... re-run the program and enter a valid input"
Then the simulated time, the ratio, and the mass consistency are printed to the screen after each step is taken.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time without a partition." 

TO RUN WITH A PARTITION:
Compile the code by typing: chmod u+x diffusion.lisp
Run the code by typing: ./diffusion.lisp
*To get wall time: run the code by typing: time ./diffusion.lisp
Code will prompt the user with: "Enter size of cube: "
Type and integer number then hit enter. If an invalid input is entered, the program will end.
Code will prompt the user with: "Enter n to run without a partition, and y to run with a partition: "
Type: y
Then press the enter key.
You will see a confirmation statement: "This program will run with a partition..."
If the user does not enter either y or n, "Invalid input... re-run the program and enter a valid input"
Then the simulated time, the ratio, and the mass consistency are printed to the screen after each step is taken.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time with a partition."

