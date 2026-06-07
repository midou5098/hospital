# Hospital Management System - x86-64 Assembly

A terminal-based hospital management prototype written in 64-bit Linux assembly. This repository is the assembly version of the hospital project and is separate from the C++/Qt remake.

## Overview

The program demonstrates low-level Linux system programming concepts while modeling the beginning of a hospital management menu system. It uses direct syscalls for output, input, memory allocation, and process exit.

## Current Features

- Raw `_start` entry point without the C runtime.
- Linux syscall usage for:
  - `mmap` memory allocation.
  - `read` from standard input.
  - `write` to standard output.
  - `exit` process termination.
- Menu-driven terminal interface.
- Separate menu text for doctors, nurses, and patients.
- Assembly `struc` definition for a `doctor` record.
- Dynamically allocated doctor-vector storage using `mmap`.
- Basic mode switching between the main menu and doctor menu.

## Tech Stack

- NASM-style x86-64 assembly
- Linux syscalls
- ELF64 executable output

## Project Structure

```text
.
|-- main.s   # Assembly source
|-- main.o   # Existing assembled object file
`-- main     # Existing statically linked executable
```

## Build

Install NASM and binutils:

```bash
sudo apt install nasm binutils
```

Assemble and link:

```bash
nasm -f elf64 main.s -o main.o
ld main.o -o main
```

## Run

```bash
./main
```

## Menu Flow

The program starts by allocating memory for a small vector of doctor records. It then enters a loop that displays the active menu and reads user input.

Current top-level menu:

```text
1) doctors
2) nurses
3) patients
4) exit
```

Selecting `1` switches into the doctors menu. Selecting `4` exits the program through syscall `60`.

## Implementation Notes

The source is organized into three major assembly sections:

| Section | Purpose |
| --- | --- |
| `.rodata` | Static menu strings and prompt text. |
| `.bss` | Runtime storage for vector metadata, input buffer, and mode. |
| `.text` | Program entry point, input routine, display routine, and menu logic. |

The vector metadata is represented by:

- `vec_data`: pointer returned by `mmap`.
- `vec_len`: current number of records.
- `vec_cap`: allocated record capacity.

## Current Limitations

- Doctor add/search/delete flows are not fully implemented yet.
- Nurse and patient flows are menu placeholders.
- Input parsing currently reads raw bytes and checks the first character.
- There is no persistence to disk.
- The program targets Linux x86-64 only.

## Learning Goals

This repo is useful for practicing:

- Assembly program structure.
- Linux syscall conventions.
- Manual memory allocation.
- Terminal I/O without libc.
- Building simple data structures at a low level.
