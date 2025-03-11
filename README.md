# SimLan Interpreter in Prolog

This repository contains an interpreter for the SimLan programming language, written in Prolog. SimLan is a simple assembly-like langauge.

## Description

SimLan is a simple language designed to perform operations like adding integers, assigning values to registers, conditional jumps, and printing values. The interpreter simulates CPU register operations (with 32 registers) and executes commands like `put`, `add`, `prn`, `jmpe`, `jmpu`, and `halt`.

### SimLan Commands

Here is an overview of the available SimLan commands:

- **put**: Assigns a constant integer to a register.  
  Example: `put 24,r5` assigns the value `24` to register `r5`.

- **add**: Adds the contents of two registers and stores the result in the second register.  
  Example: `add r1,r4` adds the contents of `r1` to `r4` and stores the result in `r4`.

- **prn**: Prints the contents of a specified register.  
  Example: `prn r10` prints the contents of `r10`.

- **jmpe**: Jumps to a specified line number if the contents of two registers are equal.  
  Example: `jmpe r1,r6,14` jumps to line `14` if the values in registers `r1` and `r6` are equal.

- **jmpu**: Unconditionally jumps to a specified line number.  
  Example: `jmpu 34` jumps to line `34` unconditionally.

- **halt**: Terminates the program. The program stops when this command is encountered.

### Example Program

This is a sample SimLan program that prints the integers from 0 to 9:

```
1) put 1,r5
2) put 0,r1
3) put 10,r2
4) jmpe r1,r2,8
5) prn r1
6) add r5,r1
7) jmpu 4
8) halt
```

### How It Works

1. The interpreter reads a SimLan program file line by line.
2. It simulates CPU register operations, executing commands such as assignments, additions, and conditional jumps.
3. The program halts when the `halt` command is encountered.

---

## Installation

1. Download and install SWI-Prolog from the official website:  
   [https://www.swi-prolog.org/Download](https://www.swi-prolog.org/Download)

2. Ensure that the `interpreter.pl` file is in the same folder as your SimLan program file (e.g., `program.sla`).

3. Consult the `interpreter.pl` file using SWI-Prolog:
   - Open the SWI-Prolog application.
   - Load the interpreter by running the command:  
     `consult('interpreter.pl').`

4. To run your SimLan program, use the `init_prog("simlancodeFileName").` command in the Prolog console, replacing `"simlancodeFileName"` with the name of your SimLan file (e.g., `"program.sla"`).

   Example usage:
   ```
   init_prog("program.sla").
   ```

   The interpreter will:
   - Print the SimLan code in the Prolog console.
   - Execute the program and display the output.

---

## Usage

1. Write your SimLan program in a text file (e.g., `program.sla`).
2. Place the `interpreter.pl` file in the same folder as your SimLan program.
3. Open SWI-Prolog and consult the `interpreter.pl` file.
4. Run your program using the following command:
   ```
   init_prog("program.sla").
   ```

---
