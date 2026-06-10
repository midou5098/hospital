# Hospital Management System

![Assembly](https://img.shields.io/badge/x86--64-Assembly-7c3aed?style=for-the-badge)
![NASM](https://img.shields.io/badge/NASM-ELF64-2563eb?style=for-the-badge)
![Linux](https://img.shields.io/badge/Linux-syscalls-111827?style=for-the-badge&logo=linux&logoColor=white)
![Runtime](https://img.shields.io/badge/no%20libc-raw%20_start-ef4444?style=for-the-badge)

A terminal hospital-management prototype written directly in **64-bit Linux assembly**. No C runtime, no standard library, no framework layer: just `_start`, NASM structs, manually managed memory, and Linux syscalls.

This is the low-level assembly version of the hospital project. It models doctors, nurses, and patients through a menu-driven console interface while showing how dynamic data structures, input parsing, output formatting, and CRUD-style flows work close to the machine.

## What It Does

```text
Boot
  -> allocate doctor vector with mmap
  -> allocate nurse vector with mmap
  -> allocate patient vector with mmap
  -> enter menu loop
  -> route input through mode-based handlers
```

The program currently supports separate in-memory record lists for:

| Module | Stored fields | Supported actions |
| --- | --- | --- |
| Doctors | `id`, `name`, `age` | add, search, delete |
| Nurses | `id`, `name`, `career` | add, search, delete |
| Patients | `id`, `name`, `disease` | add, search, delete |

All records live in memory for the current process. When the program exits, the data is gone.

## Feature Highlights

- **Raw `_start` entry point** with no libc startup code.
- **Direct Linux syscalls** for `read`, `write`, `mmap`, `munmap`, and `exit`.
- **NASM `struc` records** for doctor, nurse, and patient layouts.
- **Three independent dynamic vectors** backed by `mmap`.
- **Automatic vector growth** by allocating a larger block, copying existing records, and releasing the old mapping.
- **Menu-state machine** using the `mode` byte to route between menus, prompts, inserts, searches, and deletes.
- **Manual integer conversion** with custom `atoi` and `itoa` routines.
- **Record deletion by compaction** using `rep movsb` to shift later records over the deleted slot.
- **Search-by-ID flow** that prints the matching record fields directly to stdout.

## Menu Map

Top-level menu:

```text
<=================hospital menu===============>
1) doctors
2) nurses
3) patients
4) exit
```

Each department has the same interaction pattern:

```text
1) add record
2) search record
3) delete record
4) return to main menu
```

Example doctor flow:

```text
Main menu -> doctors -> add doctor
  -> enter id
  -> enter name
  -> enter age
  -> record is pushed into the doctor vector
```

## Tech Stack

| Layer | Choice |
| --- | --- |
| Language | NASM-style x86-64 assembly |
| Target | Linux x86-64 |
| Object format | ELF64 |
| Linker | `ld` from binutils |
| Runtime | Direct kernel syscalls |
| Storage | Process memory only |

## Project Structure

```text
.
|-- main.s      # Assembly source: structs, menus, syscalls, vectors, CRUD logic
|-- main.o      # Existing ELF64 relocatable object
|-- main        # Existing statically linked executable
`-- README.md   # Project documentation
```

## Build

Install the tools:

```bash
sudo apt update
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

Then type a menu number and press Enter.

Quick exit:

```text
4
```

## Source Tour

`main.s` is organized around the usual assembly sections:

| Section | Role |
| --- | --- |
| `.rodata` | Menu text, prompts, labels, status messages, newline data |
| `.bss` | Vector pointers, lengths, capacities, input buffer, temp records, mode byte |
| `.text` | `_start`, menu loop, handlers, push/search/delete routines, conversions |

Key routines and labels:

| Routine / label | Purpose |
| --- | --- |
| `_start` | Allocates vectors and enters the main loop |
| `_display` | Prints the active menu or prompt based on `mode` |
| `read_input` | Reads up to 256 bytes from stdin |
| `push_doc` | Appends a doctor record, expanding capacity when needed |
| `push_nur` | Appends a nurse record, expanding capacity when needed |
| `push_pat` | Appends a patient record, expanding capacity when needed |
| `.ssearch_h`, `.ssearch_hn`, `.ssearch_hp` | Search doctors, nurses, and patients by ID |
| `.ddelete`, `.ddeleten`, `.ddeletep` | Delete doctors, nurses, and patients by ID |
| `atoi` | Parses an unsigned decimal number from the input buffer |
| `itoa` | Converts an integer to printable ASCII digits |

## Memory Model

Each record type has its own vector metadata:

| Record type | Data pointer | Length | Capacity |
| --- | --- | --- | --- |
| Doctor | `vec_data` | `vec_len` | `vec_cap` |
| Nurse | `nur_vec_data` | `nur_vec_len` | `nur_vec_cap` |
| Patient | `pat_vec_data` | `pat_vec_len` | `pat_vec_cap` |

Initial capacity is `8` records per vector. When a vector is full, the program:

1. Calls `mmap` for a new block with double capacity.
2. Copies the existing records with `rep movsb`.
3. Calls `munmap` on the previous block.
4. Updates the vector pointer and capacity.
5. Writes the new record into the expanded block.

## Syscalls Used

| Syscall | Number | Use |
| --- | ---: | --- |
| `read` | `0` | Read user input from stdin |
| `write` | `1` | Print menus, prompts, and record fields |
| `mmap` | `9` | Allocate vector storage |
| `munmap` | `11` | Release old vector storage after expansion |
| `exit` | `60` | Terminate the process |

## Current Limitations

- Data is not saved to disk.
- Input parsing is intentionally simple and reads raw bytes from stdin.
- Names and text fields are copied as fixed 64-byte buffers.
- The interface is terminal-only.
- The project targets Linux x86-64 only.

## Why This Project Is Interesting

This project is a compact practice ground for real systems concepts:

- Building data structures without a runtime.
- Understanding Linux syscall calling conventions.
- Managing memory manually with `mmap` and `munmap`.
- Writing state machines with jumps and labels.
- Converting between ASCII input and integer values.
- Handling record insertion, lookup, and deletion at byte level.

## Status

The executable and object file are already present in the repository, but rebuilding from `main.s` is the recommended way to test changes. The project is best treated as an educational low-level prototype rather than a production hospital system.
