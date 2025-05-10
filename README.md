# **Modern Fortran**
Evan Morse  
2025-04-03  
CIS-3030   
___
    
## **<ins>Introduction</ins>**

```fortran
program hello
  print *, 'Hello, World!'
end program hello
```
***Fortran*** is a compiled, imperative programming language that was developed by IBM and first used in 1957. It was designed to be a high-level alternative to machine language with a focus on features supporting heavy scientific and numerical computing. Starting with the original in 1957 (FORTRAN 1957), twelve official standards have been released for the Fortran language with the most recent having been released in 2023 (Fortran 23).

At the time of this writing, Fortran is primarily used in legacy code bases that use Fortran 90 (1991) or earlier. However,  Fortran continues to grow and modernize with each update to the standard, and it remains the dominant language in several academic domains (like atmospheric simulations) due to being one of the only major languages ever developed specifically for scientific numerical computing.  

In this study, we highlight some of the modern features and strengths of the Fortran language as well as perform some pointed comparisons between Fortran and C to highlight and clarify certain features and syntax. We ultimately present a prototype of a basic entity-component-system (ECS) in both Fortran and c to explore the performance difference between each with maximum compiler optimizations applied. Our hope is to demonstrate that Fortran in 2025 is a capable multi-paradigm general purpose language with modern features while staying true to its roots as a computational powerhouse with a compiler specialized in optimizing batch mathematical operations.
## **<ins>Background</ins>**

When Fortran was developed in the 1950's, the computing landscape was very different than it is today. Computers were primarily large, room-sized machines used for large scale calculations and data-processing, and programs were primarily written in machine code or a device specific assembly language. *Automatic programming* was the emerging buzzword for programming languages which used a *pseudocode* that could be translate into multiple machine code instructions to make programming a faster and less error-prone endeavor. However, these *automatic programming* languages were costly to use since they could slow down the machine by a factor of five or ten.

### _**<ins>FORTRAN 1957</ins>**_

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
```fortran
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

### _**<ins>Fortran 90 and Beyond</ins>**_
Fortran 90 (1991) is a notable milestone in the Fortran development timeline. First, note the modern name change from **FORTRAN** to **Fortran**. Fortran 90 was the beginning of the modernization of Fortran, and from Fortran 90 (1991) through Fortran 23 (2023) a great number of syntactic improvements and modern general-purpose programming features were added, greatly expanding the capabilities of the Fortran language. Despite this, Fortran has maintained nearly 100% backwards compatibility and legacy support, and most modern compilers can compile FORTRAN 1957 code without issue.  This has empowered old Fortran code bases to remain relevant and expandable with modern features without breaking existing code.

___

### _**<ins>Modern Syntax</ins>**_
Fortran belongs to a small family of popular programming languages that were developed before the C programming language, and for this reason has a rather unique syntax. Below are descriptions and examples of some of the core constructs of the Fortran language and their modern syntax.

######  *Variable Declaration*
```
<variable_type> :: <variable_name>, <variable_name>, ...
```

Where `<variable_type>` is one of the built in types (integer, real, complex, character, or logical), and `<variable_name>` must start with a letter and may use letters, numbers, and underscores. 

Below is an example of variable declaration and assignment in Fortran followed by a comparative example in C:
```fortran
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

###### *Arithmetic Operations*
Fortran's standard set of arithmetic operations are as follows:  

| Operator | Description |
| --- | --- | 
| \** | Exponentiation |
| \* | Multiplication |
| / | Division |
| + | Addition |
| - | Subtraction |

```fortran
implicit none
real :: a, b, add, sub, mult, div, power

a = 10.0
b = 3.0

! Perform arithmetic operations
add   = a + b       ! Addition
sub   = a - b       ! Subtraction
mult  = a * b       ! Multiplication
div   = a / b       ! Division
power = a ** b      ! Exponentiation
```
Note: a lack of the common % (modulus) operator, which instead is performed using the MOD intrinsic function.

###### *Functions and Subroutines*
Functions and subroutines are both core constructs for encapsulating reusable code. However, they differ in a few key ways. 

- **Functions: **   
    Unlike with FORTRAN 1957, modern Fortran compilers no longer enforce that functions are pure, though it is still considered best practice to declare your inputs as immutable (see function example below). Functions have a return value, and thus **can be used within an expression** because a function call ultimately resolves to a value.    
 
    Below is an example of a pure function that accepts a radius and returns the area of a circle and a comparative example in C.  

```fortran
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
```c
#define PI (3.14159)
double circle_area(const double radius) {
  // Note that C has no exponentiation operator
  double area = PI * (radius * radius);
  
  return area;
}
```

>	Note: C uses the 'const' keyword to declare inputs as immutable, but due to C's type casting system there is no compile or runtime guarantee that the 'const' keyword will be respected. Fortran, on the other hand, is purely statically typed and there is no method like C's type casting to bypass the immutability declaration of the input. 

- **Subroutines:**   
    Subroutines primarily differ from functions in that they have no return value, and thus **cannot be used within an expression** because a subroutine call does not resolve to a value. For this reason, subroutines are best used when you want to modify input variables or perform actions like printing to a console where a return value is not wanted.    

    Below is an example of a subroutine that, as our function does, calculates the area of a circle. However, the calculated area is instead returned through mutating an input variable. A comparative C example has also been provided.
```fortran
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

######  *Type Precision* 
Modern Fortran uses the selected_real_kind intrinsic function to define kind parameters that specify the desired precision and range for real numbers. This method promotes portability across different systems and compilers.  
  
```fortran
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
```c
// precision_example.c
#include <stdio.h>

int main() {
    double high_precision_value = 3.141592653589793238;
    printf("High precision value: %.17f\n", high_precision_value);
    return 0;
}
```


######  *Arrays*
Fortran and C differ significantly in their approaches to array handling, impacting performance and code clarity. This is one of Fortran's primary strengths as it allows the Fortran compiler to apply aggressive CPU cache performance optimizations that are simply not possible in most other languages.  
<br>

***Indexing and Memory Layout***
- ***Fortran*** 
	Arrays are 1-based by default and stored in column-major order, meaning elements of a column are contiguous in memory.

- ***C***
	Arrays are 0-based and stored in row-major order, with elements of a row being contiguous.
<br>

***Syntax and Semantics***

Fortran treats arrays as first-class citizens, allowing for operations on entire arrays without explicit loops. 
For example:
```fortran
real :: a(3), b(3)
a = [1.0, 2.0, 3.0]
b = a * 2.0  ! Element-wise multiplication
```
```c
double a[3] = {1.0, 2.0, 3.0};
double b[3];
# An explicit loop is required
for (int i = 0; i < 3; i++) {
    b[i] = a[i] * 2.0;
}
```    
<br>  

***Multidimensional Arrays***  

Fortran provides a standard syntax for creating and operating on multidimensional arrays. In C, multidimensional arrays are declared as arrays of arrays.
```fortran
! 2 x 3 array declaration
real :: matrix(2,3)
! Initialization
matrix = reshape([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape(matrix))
```
```c
# 2 x 3 array declaration with initializer list
double matrix[2][3] = {{1.0, 2.0, 3.0},
                       {4.0, 5.0, 6.0}};

```
<br>

***Performance Implications***

Fortran's array handling allows compilers to optimize code effectively, especially for numerical computations. The language's strict aliasing rules and array semantics enable better vectorization and parallelization.

In contrast, C's flexibility with pointers, along with the way it structures arrays in memory, can hinder such optimizations due to potential aliasing issues.

___

### _**<ins>Modern Features</ins>**_

###### *Modules*
Fortran 90 introduced the concept of ***Modules***, which allow the programmer to encapsulate variables, functions, and subroutines for reuse. Modules promote code organization, namespace separation, and safer dependency management. This is different than C where declaration and definition are split between .c and .h files, and code is shared by including the interface in the .h file. 

```fortran
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

###### *Interfaces*

Interfaces provide a mechanism to define explicit contracts for procedures (functions and subroutines). They are particularly useful when:

- Calling external procedures not defined within the same module.
- Overloading procedures with the same name but different argument lists.
- Ensuring type safety and argument consistency across different program units.

An interface block specifies the procedure's name, return type (for functions), and the types and intents of its arguments. Suppose we have an external function compute_area defined in another file or module. To use it safely, we can declare an interface as follows:

```fortran
! main_program.f90
program main
  implicit none
  real :: radius, area

  interface
    function compute_area(r) result(a)
      real, intent(in) :: r
      real :: a
    end function compute_area
  end interface

  radius = 5.0
  area = compute_area(radius)
  print *, "Area:", area
end program main
```

###### *Pointers and Dynamic Allocation*
In Fortran, pointers are more than just memory addresses; they carry additional information such as type, rank, and bounds. This design provides a safer and more abstracted approach to pointer usage.

- **Association with Targets:**
	Pointers must be associated with variables declared with the **target** attribute.
- **Dnamic Allocation:**
	Pointers can be dynamically allocated using the allocate statement.
- **Safe Deallocation:** 
	Memory can be safely deallocated using the deallocate statement.
```fortran
program pointer_example
    implicit none
    integer, target :: var = 10
    integer, pointer :: ptr

	! Note expressive pointer assignment
    ptr => var
    print *, "Value through pointer:", ptr

    ! Dynamic allocation
    allocate(ptr)
    ptr = 20
    print *, "New value after allocation:", ptr

    deallocate(ptr)
end program pointer_example
```

___

## **<ins>Prototype</ins>**
The ultimate goal of this study was to produce a prototype or artifact of a piece of software in Fortran which demonstrates the strengths of modern Fortran in comparison to a mirrored prototype developed in C. We first built the C prototype, and then mirrored the implementation in Fortran, keeping mind to write our code in an idiomatic "Fortran way" instead of directly translating program structure.

#### ECS

The prototypes developed are of a simple ECS (entity-component-system). While many of the implementation details of an ECS are unimportant to this study, it is the underlying design of such a system that made it a desirable test framework. ECS systems rely heavily on the use of parallel arrays to increase CPU performance over large sets of data, an arena where Fortran and the Fortran compiler excel. ECS has been gaining popularity in recent years as data-oriented design principles have pushed out OOP design principles as the standard in many performance critical domains like super-computing, databases, and graphics processing (particularly high-performance game engines). We wanted to explore if Fortran is still a viable option for building new performant software in 2025.

#### Program Structure

The basic structure of the prototype:
- Allocate an array of 1,000,000 (one million) entities with IDs 0-999,999.
- Allocate two arrays large enough to hold 1,000,000 (one million) components.
- Register all IDs with both component arrays, create a randomly generated component for each ID.
- Create a process which takes both component array and applies an expensive mathematical operation to them both in parallel, storing the results in a third array of equal size.
- Run this process 10,000 times and time the execution.
- Display data on total process time and average iteration time.

Both Fortran and C promote an imperative style of programming, and both provide similar structures for code organization. As is such, the ultimate structure of the two prototypes was very similar, with the exception that the Fortran code was broken out into multiple files simply to explore to systems around importing external interfaces. Neither code base felt more "readable" than the other, and the logical flow of the two prototypes is nearly identical.

Here's an example from each prototype showing the allocation of the entities and component arrays, and then registers every entity with both component arrays.
```fortran
  ! Variables
  integer, allocatable :: entity_ids(:)
  ! External packed arrays declared as POINTER
  type(component), pointer :: comp1(:), comp2(:)
  ! ECS component-array wrappers
  type(component_array), target :: comp_array_1, comp_array_2
  ! Temporary helper component
  type(component) :: temp_comp

  call random_seed()
  
  ! Allocation of entity arrray
  ! Error check on allocation excluded for brevity
  allocate(entity_ids(num_entities))

  ! Generate reversed IDs
  forall (i = 1:num_entities)
    entity_ids(i) = num_entities - i
  end forall

  ! Allocate the packed buffers
  allocate(comp1(num_entities), comp2(num_entities))

  ! Initialize component-array wrappers with external buffers
  call init_component_array(comp_array_1, num_entities, comp1)
  call init_component_array(comp_array_2, num_entities, comp2)

  ! Register entities into comp arrays 
  temp_comp = component(0, 0, 0)
  do i = 1, num_entities
    call register_id(comp_array_1, entity_ids(i)+1, temp_comp)
    call register_id(comp_array_2, entity_ids(i)+1, temp_comp)
  end do

```
```c

// Allocate an array of entities
struct entity *entities = malloc(NUM_ENTITIES * sizeof (*entities));
for (int i = 0; i < NUM_ENTITIES; i++)
	entities[i].id = NUM_ENTITIES - i - 1;

// Allocate all arrays that will be operated on at the same time
// This is what could be called an "archetype" in an ECS
struct component *comps_1 = malloc(NUM_ENTITIES * (sizeof *comps_1));
if (comps_1 == NULL)
	return 1;
struct component *comps_2 = malloc(NUM_ENTITIES * (sizeof *comps_2));
if (comps_2 == NULL)
	return 1;
uint *results = malloc(NUM_ENTITIES * (sizeof *results));
if (results == NULL)
	return 1;


// Give our component arrays to their wrapper objects for management
struct component_array comp_array_1;
if (ca_init(&comp_array_1, comps_1, NUM_ENTITIES) != success_CA_INIT)
	return 1;

struct component_array comp_array_2;
if (ca_init(&comp_array_2, comps_2, NUM_ENTITIES) != success_CA_INIT)
	return 1;

// Register all entities with both component_arrays
// Initial component value
struct component temp_comp = {0, 0, 0};
for (int i = 0; i < NUM_ENTITIES; i++) {
	ca_register_id(&comp_array_1, entities[i].id, temp_comp);
	ca_register_id(&comp_array_2, entities[i].id, temp_comp);
}

```
>Note: the primary structural difference between these two samples is that Fortran expects all variable declarations before anything else in the body of a function, including main. 

<br>

#### Profiling the Prototypes

As stated before, the prototypes were constructed to run a computationally heavy mathematical process on two million data components, and then run that process ten thousand times. Below is an example of actual results printed by the tests:
```
Running C implementation...
              entities: 1000000
            iterations: 10000
    total process time: 16.57 s
average iteration time: 01.66 ms

Running FORTRAN implementation...
              entities: 1000000
            iterations: 10000
    total process time: 10.85 s
average iteration time: 01.09 ms
```
Both compilations were performed with maximum optimization flags applied. The results varied between tests, but the Fortran implementation consistently outperformed the C implementation by and average of 48%.

#### Considering the Results of the Study
The original hypothesis of the project was that Fortran would outperform C. Despite this hypothesis, we were surprised by the 48% speedup result. This was the moment where it became clear how some of the design decisions of the language, coupled with nearly seventy years of compiler development, are what have enabled Fortran to remain best in class for large data systems.

Beyond this however, the ease of working with the language coupled with these results perhaps suggests that perhaps Fortran could be used effectively for a wider degree of applications, and nothing about our experience led us to believe that Fortran, at its core, is any less capable of general purpose programming than C, and Fortran's inter-operational ability with C libraries means that Fortran already possesses the tool set of both languages.

Our greatest takeaway from the study was that Fortran is a strong example of how age and maturity can be the greatest strengths of a programming language, and that in 2025 at 68 years old, Fortran is still worth considering for developing new software.

###### References

Backus, J. (1978). The history of FORTRAN I, II, and III. IBM Corporation. Retrieved May 9, 2025, from http://www.cs.toronto.edu/~bor/199y08/backus-fortran-copy.pdf

Oracle. (n.d.). Why Fortran is still used. Oracle Help Center. Retrieved May 9, 2025, from https://docs.oracle.com/cd/E19957-01/805-4939/z400073c4a74/index.html

Zhou, Y. (2023, December 18). Is Fortran a dead language? CPUFUN. Retrieved May 9, 2025, from https://cpufun.substack.com/p/is-fortran-a-dead-language

Zakkak, F., & Humer, C. (2023, March 14). Fortran support in LLVM Flang: Status update and roadmap. LLVM Project Blog. Retrieved May 9, 2025, from https://blog.llvm.org/posts/2023/03/14/flang-update-roadmap/
