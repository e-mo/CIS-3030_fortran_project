# Fortran for Modern Application Development
Evan Morse  
2025-04-03  
CIS-3030   
___
    
## Introduction

```.f90
program hello
  print *, 'Hello, World!'
end program hello
```
***Fortran*** is a compiled, imperative programming language that was developed by IBM and first used in 1957. It was designed to be a high-level alternative to machine language with a focus on features supporting heavy scientific and numerical computing. Starting with the original in 1957 (FORTRAN 1957), twelve official standards have been released for the Fortran language with the most recent having been released in 2023 (Fortran 23).

At the time of this writing, Fortran is primarily used in legacy code bases that use Fortran 90 (1991) or earlier. However,  Fortran continues to grow and modernize with each update to the standard, and it remains the dominant language in several academic domains (like atmospheric simulations) due to being one of the only major languages ever developed specifically for scientific numerical computing.  

In this study, we highlight some of the modern features and strengths of the Fortran language as well as perform some pointed comparisons between Fortran and C to highlight and clarify certain features and syntax. We then present a prototype of a simple desktop application developed using Fortran and discuss our findings and experience with the language.
___
## Background

When Fortran was developed in the 1950's, the computing landscape was very different than it is today. Computers were primarily large, room-sized machines used for large scale calculations and data-processing, and programs were primarily written in machine code or a device specific assembly language. *Automatic programming* was the emerging buzzword for programming languages which used a *pseudocode* that could be translate into multiple machine code instructions to make programming a faster and less error-prone endeavor. However, these *automatic programming* languages were costly to use since they could slow down the machine by a factor of five or ten.

### FORTRAN 1957

Fortran was proposed by John Backus at IBM in 1953 to address what he felt was an economic need for a practical *automatic programming* system that produced acceptably efficient code. Backus was ultimately granted a team and the first version of Fortran was developed internally at IBM starting in late 1953 and releasing in 1957 . An overview of the key features of this initial version of Fortran (FORTRAN 1957) is as follows:  
- **Fixed-Layout Structure**  
    Adhered to a strict fixed-layout format to support the use of punch-cards as a program storage medium.
- **I/0 Operations**  
    Supported basic input/output operations to read/write data. The language also provided syntax for formatted text which allowed for cleaner program output.
- **DO Loops**  
    Introduced a simple loop construct for executing a code block multiple times (one execution minimum).
- **GOTO Statements**  
    Provided user the ability to redirect program execution to a specific line for control flow.
- **IF Statements**  
    Execution of a code block based on a conditional check.
- **Data Types**  
    - INTEGER: whole numbers   
	- REAL: single-precision floating point
	- DOUBLE: double-precision floating point
	- CHARACTER: strings of textual characters
	- COMPLEX: complex numbers (includes imaginary component)
	- LOGICAL: boolean values (true/false)
- **Implicit/Explicit Typing**  
    Variable type could either be declared explicitly or inferred by the compiler based on the first character of the variable name. Variables starting with I, J, K, L, M, or N were implicitly INTEGER while all other letters implied REAL.
- **Functions/Subroutines**  
    Supported the use of functions and subroutines to promote the creation of modular or reusable code. Functions differed slightly from subroutines in that functions were pure (arguments immutable) and provided a return value, while subroutines could mutate arguments but provided no return value.
- **Array Handling**  
    Supported the creation of arrays which are collections of data stored in contiguous memory.
- **Logical Expressions**
    Expressions evaluated using logical operators (AND, OR, NOT).
- **Arithmetic Expressions**  
    Could handle complex mathematical expressions which respected operator precedence. The language also provided a collection of built in mathematical functions like SIN, COS, and SQRT.
- **Compiler Efficiency**  
    FORTRAN 1957's primary design effort was placed in creating a lean and efficient **optimizing** compiler. This was likely the language's greatest success as it proved that a high-level *automatic programming* language could be used to produce performant machine code. 

Below is an example of a simple FORTRAN 1957 program which accepts a radius from the user, uses it to calculate the circumference of a circle, and prints the formatted result to console:
```.f90
      C CIRCUMFERENCE OF A CIRCLE
      REAL RADIUS, CIRCUM, PI
      PI = 3.14159

      PRINT 10
10    FORMAT(' ENTER RADIUS: ')

      READ 20, RADIUS
20    FORMAT(F10.2)

      CIRCUM = 2.0 * PI * RADIUS

      PRINT 30, CIRCUM
30    FORMAT(' CIRCUMFERENCE = ', F10.4)

      STOP
      END
```

Note: lines that start with `C` are ignored by the FORTRAN 1957 compiler as comments.

### Fortran 90 and Beyond
Fortran 90 (1991) is a notable milestone in the Fortran development timeline. First, note the modern name change from **FORTRAN** to **Fortran**. Fortran 90 was the beginning of the modernization of Fortran, and from Fortran 90 (1991) through Fortran 23 (2023) a great number of syntactic improvements and modern general-purpose programming features were added, greatly expanding the capabilities of the Fortran language. Despite this, Fortran has maintained nearly 100% backwards compatibility and legacy support, and most modern compilers can compile FORTRAN 1957 code without issue.  This has empowered old Fortran code bases to remain relevant and expandable with modern features without breaking existing code.

#### Modern Syntax
Fortran belongs to a small family of popular programming languages that were developed before the C programming language, and for this reason has a rather unique syntax.

######  Variable Declaration
```
<variable_type> :: <variable_name>, <variable_name>, ...
```

Where `<variable_type>` is one of the built in types (integer, real, complex, character, or logical), and `<variable_name>` must start with a letter and may use letters, numbers, and underscores. 

Below is an example of variable declaration and assignment in Fortran followed by a comparative example in C:
```.f90
! fortran_variables.f90

program variables
    ! Always use implicit none. This tells compiler that all variables
    ! must be explicitly typed and no type inference will be performed. 
    ! Implicit typing in modern Fortran is considered a code smell.
    implicit none

    ! Variable declaration
    integer :: amount
    real :: pi, e
    complex :: frequency
    character :: initial
    logical :: is_okay

    ! Variable assignment
    ! Standard variable assignment must occur after declaration.
    ! integer :: amount = 10 <- valid code but has a special meaning
    amount = 10
    pi = 3.1415927
    frequency = (1.0, -0.5)
    initial = 'A'
    is_okay = .false. ! .true. or .false.

end program variables

```
```C
// c_variables.c

// C has no built-in boolean (logical) type
#include <stdbool.h>

// C has no built-in complex type
typedef struct _complex_s {
	double real;
	double imaginary;
} complex;

int main() {
	// Standard declaration and assignment can be done in one line
	int amount = 10;
	double pi = 3.1415927, e;
	complex frequency = {.real = 1.0, .imaginary = -0.5};
	char initial = 'A';
	bool is_okay = false;
	
	return 0;
}
```


######  Type Precision 
######  Array Notation

#### Modern Features

###### Modules
Fortran 90 introduced the concept of **Modules** which allow the programmer to encapsulate procedures and data for reuse. Here is an example of a module which contains a function definition and code to import that module and call the function:
```.f90
! math_utils module definition with contained function definition
module math_utils
implicit none

  
  
contains
  function square(x)
    real :: square, x
    square = x * x
  end function
  
end module math_utils
```
```.f90
! declaring use of math_utils module and calling square function
use math_utils
print *, square(4.0)
```