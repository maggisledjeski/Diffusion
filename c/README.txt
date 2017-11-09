README FILE FOR C CODE:

In this repository the file, diffusion.c, contains the code of my project.
This file asks for user input on how to run the program, and uses an if statement to control the Msize (will print "Entered invalid Msize number" if you enter a number outside the bounds (set between 0 and 100, but can be changed at line )), and a switch statement with cases to navigate whether the user 
wants to run a partition or not, leaving the default case as "Invalid input" if the user does not answer the prompt correctly.

In order to run this program correctly, please read the following:

TO RUN WITHOUT A PARTITION:
Compile the code by typing: gcc diffusion.c -lm
Run the code by typing: a.out
The code will prompt you with: "Enter the Msize value (integer): "
Enter a number greater than 0 and less than 100, then press enter.
Then "The Msize you have entered is (whatever number you entered, if valid)" will print on the screen.
If you enter an invalid Msize, "Entered invalid Msize number" is printed to the screen and the program will end.
The code will prompt you with: "Do you want to run this program with a partition? Enter y for partition, or enter n to run without a partition: "
Type: n
Then press the enter key.
You will see a confirmation statement: "This program will run without a partition..."
If you do not enter either y or n, "invalid input" is printed to the screen and the program will end.
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time without a partition." 

TO RUN WITH A PARTITION:
Compile the code by typing: gcc diffusion.c -lm
Run the code by typing: a.out
The code will prompt you with: "Enter the Msize value (integer): "
Enter a number greater than 0 and less than 100, then press enter.
Then "The Msize you have entered is (whatever number you entered, if valid)" will print on the screen.
If you enter an invalid Msize, "Entered invalid Msize number" is printed to the screen and the program will end.
The code will prompt you with: "Do you want to run this program with a partition? Enter y for partition, or enter n to run without a partition: "
Type: y
Then press the enter key.
You will see a confirmation statement: "This program will run with a partition..."
If you do not enter either y or n, "invalid input" is printed to the screen and the program will end.
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time with a partition."
