README FILE FOR GO CODE:

In this repository the file, diffusion.go, contains the code of my project.
This program's main function contains the code to time the diffusion function, which contains the diffusion code. The diffusion method asks for user input on
how to run the program, using a switch statement with cases to navigate whether the user wants to run a partition or not,
leaving the default case as "Entered an invalid input" if the user does not answer the prompt correctly.
If one wanted to change the size of the room, go to lines 11 and 15 and change N and x. Make sure that x is a double or an error will be printed, and the 
program will stop.
 
In order to run this program correctly, please read the following:

TO RUN WITHOUT A PARTITION:
Compile and run the code by typing: go run diffusion.go
The code will prompt you with: "To run program with a partition please enter 'yes', to run without a partition please enter 'no':"
Type: no
Then press the enter key.
You will see a confirmation statement: "This program will run without a partition..."
If you do not enter either yes or no, "Entered an invalid input" is printed to the screen and the program will end.
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time without a partition." 

TO RUN WITH A PARTITION:
Compile and run the code by typing: go run diffusion.go
The code will prompt you with: "To run program with a partition please enter 'yes', to run without a partition please enter 'no':"
Type: yes
Then press the enter key.
You will see a confirmation statement: "This program will run with a partition..."
If you do not enter either yes or no, "Entered an invalid input" is printed to the screen and the program will end.
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time with a partition."

