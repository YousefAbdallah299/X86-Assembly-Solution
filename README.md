# X86-Assembly-Solution
This x86 assembly program computes a mathematical product based on user inputs using double-precision floating-point arithmetic.

## Description

This x86 assembly program calculates a mathematical product based on a user-provided integer input `n`. The program computes the product of terms using the formula:

\[
\prod_{i=1}^{n} \left((n-i+1) + \frac{1}{i}\right)
\]

For example, if the user inputs `n = 3`, the program computes:

\[
((3) + 1/1) \times ((2) + 1/2) \times ((1) + 1/3) = 13.333
\]

The result is displayed to the user. Negative inputs are not allowed, and a warning message is shown if a negative value is entered.

## Features

- Accepts an integer input `n` from the user.
- Computes the product using double-precision floating-point arithmetic.
- Validates input to ensure non-negative integers.
- Displays the computed result or an error message for invalid inputs.

## Usage

1. Clone the repository:
    ```bash
    git clone https://github.com/YousefAbdallah299/x86-product-calculator.git
    cd x86-product-calculator
    ```

2. Assemble and link the program using an assembler like NASM:
    ```bash
    nasm -f elf32 program.asm -o program.o
    ld -m elf_i386 program.o -o program
    ```

3. Run the program:
    ```bash
    ./program
    ```

4. Follow the prompts to input a value for `n` and see the result.

## Example Output

### Input:
```
Please input a number: 3
```

### Output:
```
The program output: 13.333
```

### Negative Input:
```
Please input a number: -1
```

### Output:
```
Cannot calculate for a negative number.
```

## Notes

- The program uses the x86 Floating Point Unit (FPU) for double-precision calculations.
- Ensure that the assembler and linker used are compatible with 32-bit x86 assembly.
