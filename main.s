global _start
bits 64
section .rodata
string:
    db "sup bitch(in assembly)\n"
section .text
_start:
    mov rax,1
    mov rdi,1
    lea rsi, [string]
    mov rdx ,22
    syscall

    mov rax,60
    mov rdi,0
    syscall