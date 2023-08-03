# Matlab
MATLAB (an abbreviation of "MATrix LABoratory") is a proprietary multi-paradigm programming language and numeric computing environment developed by MathWorks. MATLAB allows matrix manipulations, plotting of functions and data, implementation of algorithms, creation of user interfaces, and interfacing with programs written in other languages.

## History
MATLAB was invented by mathematician and computer programmer Cleve Moler. The idea for MATLAB was based on his 1960s PhD thesis. Moler became a math professor at the University of New Mexico and started developing MATLAB for his students as a hobby. He developed MATLAB's initial linear algebra programming in 1967 with his one-time thesis advisor, George Forsythe. This was followed by Fortran code for linear equations in 1971.

In the beginning (before version 1.0) MATLAB "was not a programming language; it was a simple interactive matrix calculator. There were no programs, no toolboxes, no graphics. And no ODEs or FFTs."

The first early version of MATLAB was completed in the late 1970s. The software was disclosed to the public for the first time in February 1979 at the Naval Postgraduate School in California. Early versions of MATLAB were simple matrix calculators with 71 pre-built functions. At the time, MATLAB was distributed for free to universities. Moler would leave copies at universities he visited and the software developed a strong following in the math departments of university campuses. 

In the 1980s, Cleve Moler met John N. Little. They decided to reprogram MATLAB in C and market it for the IBM desktops that were replacing mainframe computers at the time. John Little and programmer Steve Bangert re-programmed MATLAB in C, created the MATLAB programming language, and developed features for toolboxes.

## Commercial development
MATLAB was first released as a commercial product in 1984 at the Automatic Control Conference in Las Vegas. MathWorks, Inc. was founded to develop the software and the MATLAB programming language was released. The first MATLAB sale was the following year, when Nick Trefethen from the Massachusetts Institute of Technology bought ten copies.

By the end of the 1980s, several hundred copies of MATLAB had been sold to universities for student use. The software was popularized largely thanks to toolboxes created by experts in various fields for performing specialized mathematical tasks. Many of the toolboxes were developed as a result of Stanford students that used MATLAB in academia, then brought the software with them to the private sector.

Over time, MATLAB was re-written for early operating systems created by Digital Equipment Corporation, VAX, Sun Microsystems, and for Unix PCs. Version 3 was released in 1987. The first MATLAB compiler was developed by Stephen C. Johnson in the 1990s.

In 2000, MathWorks added a Fortran-based library for linear algebra in MATLAB 6, replacing the software's original LINPACK and EISPACK subroutines that were in C. MATLAB's Parallel Computing Toolbox was released at the 2004 Supercomputing Conference and support for graphics processing units (GPUs) was added to it in 2010.

## Recent history
Some especially large changes to the software were made with version 8 in 2012. The user interface was reworked and Simulink's functionality was expanded. By 2016, MATLAB had introduced several technical and user interface improvements, including the MATLAB Live Editor notebook, and other features.

# Syntax
The MATLAB application is built around the MATLAB programming language. Common usage of the MATLAB application involves using the "Command Window" as an interactive mathematical shell or executing text files containing MATLAB code.

## Hello, World! example
A example of "Hello, world!" exists in MATLAB.
```
disp('Hello, world!')
```
It displays like so:
```
Hello, world!
```

## Variables
Variables are defined using the assignment operator, =. MATLAB is a weakly typed programming language because types are implicitly converted. It is an inferred typed language because variables can be assigned without declaring their type, except if they are to be treated as symbolic objects, and that their type can change. Values can come from constants, from computation involving values of other variables, or from the output of a function. For example:
```
>> x = 17
x =
 17

>> x = 'hat'
x =
hat

>> x = [3*4, pi/2]
x =
   12.0000    1.5708

>> y = 3*sin(x)
y =
   -1.6097    3.0000
```

##Vectors and matrices
A simple array is defined using the colon syntax: initial :increment: terminator. For instance:
```
>> array = 1:2:9
array =
 1 3 5 7 9
```
defines a variable named ```array``` (or assigns a new value to an existing variable with the name ```array```) which is an array consisting of the values 1, 3, 5, 7, and 9. That is, the array starts at 1 (the initial value), increments with each step from the previous value by 2 (the increment value), and stops once it reaches (or is about to exceed) 9 (the terminator value).

The increment value can actually be left out of this syntax (along with one of the colons), to use a default value of 1.
```
>> ari = 1:5
ari =
 1 2 3 4 5
```
assigns to the variable named ari an array with the values 1, 2, 3, 4, and 5, since the default value of 1 is used as the increment.

Indexing is one-based, which is the usual convention for matrices in mathematics, unlike zero-based indexing commonly used in other programming languages such as C, C++, and Java.

Matrices can be defined by separating the elements of a row with blank space or comma and using a semicolon to separate the rows. The list of elements should be surrounded by square brackets []. Parentheses () are used to access elements and subarrays (they are also used to denote a function argument list).
```
>> A = [16, 3, 2, 13  ; 5, 10, 11, 8 ; 9, 6, 7, 12 ; 4, 15, 14, 1]
A =
 16  3  2 13
  5 10 11  8
  9  6  7 12
  4 15 14  1

>> A(2,3)
ans =
 11
```
Sets of indices can be specified by expressions such as ```2:4```, which evaluates to ```[2, 3, 4]```. For example, a submatrix taken from rows 2 through 4 and columns 3 through 4 can be written as:
```
>> A(2:4,3:4)
ans =
 11 8
 7 12
 14 1
```
A square identity matrix of size n can be generated using the function ```eye```, and matrices of any size with zeros or ones can be generated with the functions ```zeros``` and ```ones```, respectively.
```
>> eye(3,3)
ans =
 1 0 0
 0 1 0
 0 0 1

>> zeros(2,3)
ans =
 0 0 0
 0 0 0

>> ones(2,3)
ans =
 1 1 1
 1 1 1
```
Transposing a vector or a matrix is done either by the function ```transpose``` or by adding dot-prime after the matrix (without the dot, prime will perform conjugate transpose for complex arrays):
```
>> A = [1 ; 2],  B = A.', C = transpose(A)
A =
     1
     2
B =
     1     2
C =
     1     2

>> D = [0, 3 ; 1, 5], D.'
D =
     0     3
     1     5
ans =
     0     1
     3     5
```
Most functions accept arrays as input and operate element-wise on each element. For example, ```mod(2*J,n)``` will multiply every element in J by 2, and then reduce each element modulo n. MATLAB does include standard for and while loops, but (as in other similar applications such as APL and R), using the vectorized notation is encouraged and is often faster to execute. The following code, excerpted from the function magic.m, creates a magic square M for odd values of n (MATLAB function ```meshgrid``` is used here to generate square matrices I and J containing ```1:n```):
```
[J,I] = meshgrid(1:n);
A = mod(I + J - (n + 3) / 2, n);
B = mod(I + 2 * J - 2, n);
M = n * A + B + 1;
```

