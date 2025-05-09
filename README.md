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
Fortran belongs to a small family of popular programming languages that were developed before the C programming language, and for this reason has a rather unique syntax. Below are descriptions and examples of some of the core constructs of the Fortran language and their modern syntax.

######  Variable Declaration
```
<variable_type> :: <variable_name>, <variable_name>, ...
```

Where `<variable_type>` is one of the built in types (integer, real, complex, character, or logical), and `<variable_name>` must start with a letter and may use letters, numbers, and underscores. 

Below is an example of variable declaration and assignment in Fortran followed by a comparative example in C:
```.f90
! fortran_variables.f90

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

// Standard declaration and assignment can be done in one line
int amount = 10;
double pi = 3.1415927, e;
complex frequency = {.real = 1.0, .imaginary = -0.5};
char initial = 'A';
bool is_okay = false;
```

###### Arithmetic Operations
>Fortran's standard set of arithmetic operations are as follows:  
>
>| Operator | Description |
>| --- | --- | 
>| \** | Exponentiation |
>| \* | Multiplication |
>| / | Division |
>| + | Addition |
>| - | Subtraction |
>
>***Example:*** 
>```.f90
>implicit none
>real :: a, b, add, sub, mult, div, power
>
>a = 10.0
>b = 3.0
>
>! Perform arithmetic operations
>add   = a + b       ! Addition
>sub   = a - b       ! Subtraction
>mult  = a * b       ! Multiplication
>div   = a / b       ! Division
>power = a ** b      ! Exponentiation
>```
>Note: a lack of the common % (modulus) operator, which instead is performed using the MOD intrinsic function.

###### Functions and Subroutines
Functions and subroutines are both core constructs for encapsulating reusable code. However, they differ in a few key ways. 

- **Functions: **   
    Unlike with FORTRAN 1957, modern Fortran compilers no longer enforce that functions are pure, though it is still considered best practice to declare your inputs as immutable (see function example below). Functions have a return value, and thus **can be used within an expression** because a function call ultimately resolves to a value. Below is an example of a pure function that accepts a radius and returns the area of a circle and a comparative example in C.

```.f90
! Function declaration
function circle_area(radius) result(area)
  ! intent(in) declares the input variable 'radius' as an immutable input
  ! If this were omitted, radius would be mutable within the function (not pure)
  real, intent(in) :: radius
  real :: area ! Declared as the output variable above with result(area)
  ! The parameter attribute declares pi as a symbolic constant rather than a variable
  ! Compare to #define pi (3.14159) in C
  real, parameter :: pi = 3.14159

  area = pi * radius**2
end function circle_area

! Usage
real :: radius, area
radius = 5.0

! Use the function in an expression to assign return to 'area'
area = circle_area(radius)
```
```C
#define PI (3.14159)
double circle_area(const double radius) {
  // Note that C has no exponentiation operator
  double area = PI * (radius * radius);
  
  return area;
}
```
C uses the 'const' keyword to declare inputs as immutable, but due to C's type casting system there is no compile or runtime guarantee that the 'const' keyword will be respected. Fortran, on the other hand, is purely statically typed and there is no method like C's type casting to bypass the immutability declaration of the input. 

- **Subroutines:**   
    Subroutines primarily differ from functions in that they have no return value, and thus **cannot be used within an expression** because a subroutine call does not resolve to a value. For this reason, subroutines are best used when you want to modify input variables or perform actions like printing to a console where a return value is not wanted.   

    Below is an example of a subroutine that, as our function does, calculates the area of a circle. However, the calculated area is instead returned through mutating an input variable. A comparative C example has also been provided.
```.f90
subroutine circle_area(radius, area)
  ! Inputs declared with intent(in) are also immutable in subroutines 
  real, intent(in) :: radius
  ! Output variables declared with intent(out) are write only
  real, intent(out) :: area
  real, parameter :: pi = 3.14159

  area = pi * radius**2
end subroutine circle_area


! Usage
real :: radius, area
radius = 5.0

! Subroutines must be called
call circle_area(radius, area) ! Will assign circle area to area variable

```
```C
#define PI (3.14159)

// C has no concept of subroutines and instead uses void as a return type when
// no return is expected, and parameters can be passed as pointers to allow the
// function to modify them.
void circle_area(cont double radius, double *area) {
	*area = PI * (radius * radius);
}
```

######  Type Precision 
Modern Fortran uses the selected_real_kind intrinsic function to define kind parameters that specify the desired precision and range for real numbers. This method promotes portability across different systems and compilers.  
  
***Example:*** 
```.f90
! precision_example.f90
program precision_example
    implicit none
	! This selects a kind perameter for the real type requesting 15 decimal digits
	! of precision and an exponent range up to 10^307
    integer, parameter :: dp = selected_real_kind(p=15, r=307)
    real(kind=dp) :: high_precision_value
	
	! Note: ariable name when selecting kind also becomes a literal type suffix 
    high_precision_value = 3.141592653589793238_dp
    print *, "High precision value: ", high_precision_value
end program precision_example

```


######  Array Notation

#### Modern Features

###### Modules
Fortran 90 introduced the concept of ***Modules***, which allow the programmer to encapsulate variables, functions, and subroutines for reuse. Modules promote code organization, namespace separation, and safer dependency management. This is different than C where declaration and definition are split between .c and .h files, and code is shared by including the interface in the .h file. 

***Example:***
```.f90
! constants_module.f90
module constants
    implicit none
    real, parameter :: pi = 3.14159
    real, parameter :: e  = 2.71828
contains
    subroutine print_constants()
        print *, "Pi = ", pi
        print *, "e  = ", e
    end subroutine print_constants
end module constants

! main_program.f90
program main
    use constants
    implicit none

    call print_constants()
end program main
```
