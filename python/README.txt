README FILE FOR PYTHON CODE:

In this repository the file, diffusion1.py, contains the code of my project.
This file asks for user input on the size of the cube, and uses an if statement to control the Msize (will print "invalid input" if you enter 
a number outside the bounds (set between 0 and 100, but can be changed at line )), with a while and an if statement which navigates the user to the partition code or the non-partition code until they have entered the correct input and "invalid input" is printed on the screen.

In order to run this program correctly, please read the following:

TO RUN WITHOUT A PARTITION:
Compile the code by typing: chmod u+x diffusion1.py
Run the code by typing: ./diffusion1.py
The code will prompt you with: "Enter the size of the cube: "
Enter a number greater than 0 and less than 100, then press enter.
Then "The Msize is (whatever number you entered)" will print on the screen.
If you enter an invalid Msize, "invalid input" is printed to the screen and the program will end.
The code will prompt you with: "Please enter 'y' for partion, and 'n' to run without a partition: "
Type: n
Then press the enter key.
You will see a confirmation statement: "This program will run without a partition..."
If the user does not enter either y or n, "Please enter 'y' for partion, and 'n' to run without a partition:" will print until the user enters a correct input.
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time without a partition." 

TO RUN WITH A PARTITION:
Compile the code by typing: chmod u+x diffusion1.py
Run the code by typing: ./diffusion1.py
The code will prompt you with: "Enter the size of the cube: "
Enter a number greater than 0 and less than 100, then press enter.
Then "The Msize is (whatever number you entered)" will print on the screen.
If you enter an invalid Msize, "invalid input" is printed to the screen and the program will end.
The code will prompt you with: "Please enter 'y' for partion, and 'n' to run without a partition: "
Type: y
Then press the enter key.
You will see a confirmation statement: "This program will run with a partition..."
If the user does not enter either y or n, "Please enter 'y' for partion, and 'n' to run without a partition:" will print until the user enters a correct input.
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time with a partition."
