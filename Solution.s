.intel_syntax noprefix

.section .data

# We'll utilise those values for perpoes in our formula-generating logic....
n : .int 0
temp_n : .int 0 

inputf: .asciz "%d"
requestInputMsg : .asciz "Please, input a number : "
negativityWarnMsg: .asciz "Can't calculate a negative number..."
outputf: .asciz "The program output : %f"


# single term indicate to one single term of the wanted full formula ...
single_term : .double 0.0

# the fraction part of single term 
fraction : .double 1.0
fraction_denominator : .double 1.0

# We'll utilise those values for perpoes in our formula-generating logic....
float_n : .double 0.0
one : .double 1.0
zero : .double 0.0

# output 
full_formula : .double 1.0


.section .text
.global _main
_main:

    # Print a message to request an input from the user.
    push OFFSET requestInputMsg # push to stack the first parameter to scanf
    call _printf
    add ESP, 4 # Adds the size of offeset (4 bytes) to ESP register .

    # Takes an input 
    push OFFSET n
    push OFFSET inputf # push to stack the first parameter to scanf
    call _scanf # call scanf, it will use the two parameters on the top of the stack in the reverse order

    # If n (user's input) is greater than zero then generate the wanted formula ...
    mov EAX, [n]
    cmp EAX, 0
    jg chk_positivity
    jmp chk_positivity_end_if

chk_positivity:
    # loop from n => 0
    mov ECX, n 
loop1:

    # Make single term = 0 , to construct a new single term
    fld QWORD PTR single_term # push single_term to the floating point stack
    fmul QWORD PTR zero   # pop the floating point stack top (single_term), multiply single_term by zero, and push the result (0)
    fstp QWORD PTR single_term # Store (0) in variable single_term

    # build one single term e.g ((n) + 1/1))

    # Convert the current counter value (ECX's value => (n - i)) into float and save it in float_n
    mov temp_n, ECX # Move the value of 'EXC' into temp_n
    fild DWORD PTR temp_n   # Convert the integer in temp_n to double-precision float
    fstp QWORD PTR float_n  # Store the floating point stack top in float_n


    # single term += ecx => (n - i) 
    fld QWORD PTR single_term # push single_term to the floating point stack
    fadd QWORD PTR float_n # pop the floating point stack top (0), add it to single term, and push the result ((n-i))
    fstp QWORD PTR single_term # Store the intermediate result in memory (pop the value from the FPU stack)

    # generate the fraction part by divide one by fraction denominatoir.
    fld QWORD PTR one # push 1 to the floating point stack
    fdiv QWORD PTR fraction_denominator # pop the floating point stack top (1), divide it over fraction_denominator and push the result (1/fraction_denominator)
    fstp QWORD PTR fraction # Store the intermediate result in memory (pop the value from the FPU stack)


    # single term += fraction 
    fld QWORD PTR single_term # push single_term to the floating point stack
    fadd QWORD PTR fraction # pop the floating point stack top (1/fraction_denominator), add it to single_term, and push the result ((n-i)+(1/r))
    fstp QWORD PTR single_term # Store the intermediate result in memory (pop the value from the FPU stack)

    # single term (after operation done above)>> ( ecx + (1 / denminator)) e.g((n) + 1/1))
    # add one to fraction denominatior
    fld QWORD PTR fraction_denominator # push fraction_denominator to the floating point stack
    fadd QWORD PTR one # pop the floating point stack top (1), add it to fraction_denominator, and push the result (1/ fraction denominator)
    fstp QWORD PTR fraction_denominator # store


    # update full_formula(output)
    # full_formula *= single_term
    fld QWORD PTR full_formula  # load full_formula into stack
    fmul QWORD PTR single_term  # Multiply full_formula by (n-i + 1/r) (full_formula * (n-i + 1/r)) and store in st(0)
    fstp QWORD PTR full_formula # update the full_formula

    loop loop1 # ecx -=1 , then goto loop1 only if ecx is not zero
chk_positivity_end_if:

    # check if n (user's input) is greater than or equal to zero 

    mov EAX, [n]
    cmp EAX, -1
    jg chk_non_negativity_label # jump to chk_non_negativiy_label if n is greater than -1 (n is not negative).
    
    # in case of n <= -1 , in other words (n is a negative number).
    # program prints a message to warn user of his negative input.
    
    push OFFSET negativityWarnMsg # push to stack the first parameter to printf
    call _printf
    add ESP, 4  # pop the parameter
    
    jmp chk_non_negativity_end_if 
    
chk_non_negativity_label:    
    # in case of n > 0 , in other words (n is a non-negative number).
    # program prints full_formula 
    
    # output the full_formula
    push [full_formula + 4] # push to stack the high 32-bits of the second parameter to printf (the double at label full_formula)
    push full_formula # push to stack the low 32-bits of the second parameter to printf (the double at label full_formula)
    push OFFSET outputf # push to stack the first parameter to printf
    call _printf # pop the two parameters
    add ESP, 4 + 8  # Adds the size of offeset (4 bytes) + size of double (8 bytes ) to ESP register .
    
chk_non_negativity_end_if:
    ret # end the main function
