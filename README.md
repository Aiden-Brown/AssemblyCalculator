# AssemblyCalculator
A repository to store my progress with the production of a calculator built in Assembly

## Project Details
### Why Use Assembly? 

This project was inspired by a range of different videos and a movie. The first being a video essay on the development of Roller Coaster Tycoon, built mostly out of Assembly by one man named Chris Sawyer. This led to a rabbit hole of videos on assembly, what it is, what it was used for and some of the benefits of understanding how to code in it. This exploratory video watching lasted about a fortnight where I learnt a bit about low level programming and how useful it can be to understand. 

I also recently watched the movie Hidden Figures. A movie released in 2016 focussing on Katherine Goble, who was an incredible mathematician, and how she contributed to launch the atlas mission when the IBM 7090 failed to do so. However what caught my eye moreso was Dorothy Vaughan who learnt to program in Fortran and became a leading expert with the language. It was cool to think about how she would've felt after the mistreatment she received (or at least the perceived mistreatment in the movie) and then suddenly beoming one of the staples wihtin the NASA community through the understanding brought by knowing Fortran. 

While I don't plan on building a technical master piece like Chris did or become a world leading expert like Dorothy. I would like to explore how one of the first programming languages was used to create the future we have today 

### Goals to Achieve
In this project I want to build a calculator that performs at least the basics found in any calculator application. That being addition, subtraction, multiplication and division. At first this will only allowing 2 numbers to be used as input (e.g. 1+2, 2-4 etc) and would be expanded later in development. 

Once this is complete I would like to branch out to start developing some more complicated methods such as powers, square roots and allowing more than 2 numbers of input. Once I have achieved this I would like to workout order of operations. This would cover the basic functions I would like then I'd like to move onto getting a GUI of the program working.

### Timeline
This project I'm aiming to have completed over my summer break before Semester 1 starts next year (18-11-2024 to 24-02-2025). Before Christmas I would like to have the 4 basic arithmatic operations down. Following this period I would like to have the powers, square roots and multiple number inputs sorted by early to mid Jan. Then in the final stretch get the order of operations and the GUI completed before university recommences.

During this time I will be working full time so will be spending approx. 10-15 hours a week. The only exception being over the 2 Christmas and New Years weeks I expect I won't have as much work so will be able to up development time before I return to full time hours.

## Tasks

- [ ] Create addition capabilities
- [ ] Create subtraction capabilities
- [ ] Create Multiplication capabilities
- [ ] Create division capabilities
- [ ] Allow ability to create powers of numbers
- [ ] Square Roots
- [ ] Allow more than 2 numbers for input
- [ ] Create Order of Operations
- [ ] Create interactable calculator GUI 

### Note:
As more ideas come to mind and I'm ahead of schedule tasks may be added to the list, but if I'm behind schedule I will not remove some tasks.

# Development Environment
This will be developed in a Ubuntu Machine running using WSL. I was just looking for something simple to use, I was planning on using VMware Workstation Personal as work uses VMware however there were a lot of loop holes to jump through to find the right one and the process started to become a long one so using WSL was easy, simple and fit the requirements of the project.

# Commands to run
To run the project you will need to do the following (assuming you are connected to the Linux machine you have running):

- sudo apt-get update -y
- sudo apt-get install -y nasm

This allows you to download an assembler that works on Linux machines. From what I could read this doesn't work for all Linux machines and is dependent on the Linux OS you have downloaded.

You can check if they have downloaded correctly by typing "nasm -v" and "ld -v" to check if the Assembler downloaded and if the linker was downloaded as well. If there are no errors then you are winning and can continue.

To then get a program to run the next thing that you need to do is Assemble the code, then link the generated object file to an executable one and run it. To do this you need to do the following (Using HelloWorld.asm as an example):

- nasm -f elf32 -o HelloWorld.o HelloWorld.asm

This is telling the assembler to create an object file called HelloWorld.o from HelloWorld.asm. The name of the .o file can be anything you want and doesn't have to match the asm files name. Next you need to link this newly created object file to an executable file. 

- ld -m elf_i386 -o HelloWorld HelloWorld.o

This allows the file to be converted into an executable for the user to be able to run and test the code. Again the name of the executable does not need to be the same. To run the executable you just need to do this:

- ./HelloWorld

and there's the project running.