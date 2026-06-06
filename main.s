global _start
bits 64
section .rodata
menu:
    db "<=================hospital menu===============>" 10
    db "1) doctors" ,10
    db "2) nurses",10
    db "3) patients",10
    db "4)exit",10
menu_len equ $ -menu
doc_menu:
    db "<=================doctors menu===============>" 10
    db "1) add doctor" ,10
    db "2) search doctor",10
    db "3) delete doctor",10
    db "4)exit",10
menu_len equ $ -menu
menu:
    db "<=================hospital menu===============>" 10
    db "1) add nurse" ,10
    db "2) search nurse",10
    db "3) elete nurse",10
    db "4)exit",10
menu_len equ $ -menu
menu:
    db "<=================hospital menu===============>" 10
    db "1) add patient" ,10
    db "2) search patient",10
    db "3) delete patient",10
    db "4)exit",10
menu_len equ $ -menu


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