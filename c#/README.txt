README FILE FOR C# CODE:

In this repository the file, diffusion.cs, contains the code of my project.
This file asks for user input on how to run the program, and uses an if statement to control the Msize (will print "Entered invalid input" if you enter 
a number outside the bounds (set between 0 and 100, but can be changed at line )), with a while and an if statement which navigates the user to the partition code or the non-partition code until they have entered the correct input.

In order to run this program correctly, please read the following:

TO RUN WITHOUT A PARTITION:
Compile the code by typing: mcs diffusion.cs
Run the code by typing: mono diffusion.exe
The code will prompt you with: "Enter the size of the box: "
Enter a number greater than 0 and less than 100, then press enter.
Then "The Msize is (whatever number you entered)" will print on the screen.
If you enter an invalid Msize, "Entered an invalid input" is printed to the screen and the program will end.
The code will prompt you with: "To run program with partition, enter 1, to run without a partition enter 2: "
Type: 2
Then press the enter key.
You will see a confirmation statement: "This program will run without a partition..."
If the user does not enter either 1 or 2, "To run program with partition, enter 1, to run without a partition enter 2:" will print until the user enters a correct input.
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time without a partition." 

TO RUN WITH A PARTITION:
Compile the code by typing: mcs diffusion.cs
Run the code by typing: mono diffusion.exe
The code will prompt you with: "Enter the size of the box: "
Enter a number greater than 0 and less than 100, then press enter.
Then "The Msize is (whatever number you entered)" will print on the screen.
If you enter an invalid Msize, "Entered an invalid input" is printed to the screen and the program will end.
The code will prompt you with: "To run program with partition, enter 1, to run without a partition enter 2: "
Type: 1
Then press the enter key.
You will see a confirmation statement: "This program will run with a partition..."
If the user does not enter either 1 or 2, "To run program with partition, enter 1, to run without a partition enter 2:" will print until the user enters a correct input.
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time with a partition."

