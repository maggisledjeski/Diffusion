README FILE FOR C CODE:

In this repository the file, diffusion.c, contains the code of my project.
This file asks for user input on how to run the program, and uses a switch statement with cases to navigate the options, leaving the default case as "Invalid input".
In order to run this program correctly, please read the following:

TO RUN WITHOUT A PARTITION:
Compile the code by typing: gcc diffusion.c -lm
Run the code by typing: a.out
The code will prompt you with: "Do you want to run this program with a partition? Enter y for partition, or enter n to run without a partition: "
Type: n
Then press the enter key.
You will see a confirmation statement: "This program will run without a partition..."
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time without a partition." 

TO RUN WITH A PARTITION:
Compile the code by typing: gcc diffusion.c -lm
Run the code by typing: a.out
The code will prompt you with: "Do you want to run this program with a partition? Enter y for partition, or enter n to run without a partition: "
Type: y
Then press the enter key.
You will see a confirmation statement: "This program will run with a partition..."
Then the simulated time will appear on the screen after each step is taken. In order to see the ratio and the mass consistency printed uncomment the lines.
After the ratio has reached 0.99 the program will print: "The box equilibrated in (insert time here), seconds of simulated time with a partition."
