# Fortran for Modern Application Development
Evan Morse  
2025-04-03  
CIS-3030   
___
    
## Introduction
```fortran
program hello
  print *, 'Hello, World!'
end program hello
```
***Fortran*** is a compiled, imperative programming language that was developed by IBM and first used in 1957. It was designed to be a high-level alternative to machine language with a focus on features supporting heavy scientific and numerical computing. Starting with the original in 1957, twelve official standards have been released for the Fortran language with the most recent having been released in 2023.

At the time of this writing, Fortran is primarily used in legacy code bases that use Fortran 90 (1991) or earlier. However,  Fortran continues to grow and modernize with each update to the standard, and it remains the dominant language in several academic domains (like atmospheric simulations) due to being one of the only major languages ever developed specifically for scientific numerical computing.  

In this study, we highlight some of the modern features and strengths of the Fortran language as well as perform some pointed comparisons between Fortran and C to highlight and clarify certain features and syntax. We then present a prototype of a simple desktop application developed using Fortran and discuss our findings and experience with the language.
___
## Background
When Fortran was developed in the 1950s, the computing landscape was very different than it is today. Computers were primarily large, room-sized machines used for large scale calculations and data-processing, and programming was almost entirely done using machine code or a device specific assembly language. *Automatic programming* was the emerging buzzword for programming languages which used a *pseudocode* that could be translate into multiple machine code instructions to make programming a faster and less error-prone endeavor. However, these *automatic programming* languages were costly to use since they could slow down the machine by a factor of five or ten.
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




