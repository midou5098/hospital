global _start
bits 64
section .rodata
menu:
    db "<=================hospital menu===============>",10
    db "1) doctors" ,10
    db "2) nurses",10
    db "3) patients",10
    db "4)exit",10
menu_len equ $ -menu
doc_menu:
    db "<=================doctors menu===============>", 10
    db "1) add doctor" ,10
    db "2) search doctor",10
    db "3) delete doctor",10
    db "4)exit",10
doc_menu_len equ $ -doc_menu
nur_menu:
    db "<=================hospital menu===============>", 10
    db "1) add nurse" ,10
    db "2) search nurse",10
    db "3) elete nurse",10
    db "4)exit",10
nur_menu_len equ $ -nur_menu
pat_menu:
    db "<=================hospital menu===============>", 10
    db "1) add patient" ,10
    db "2) search patient",10
    db "3) delete patient",10
    db "4)exit",10
pat_menu_len equ $ -pat_menu

doc_add_id:
    db "enter the id ",10
    
docid_menu_len equ $ -doc_add_id

doc_add_name:
    db "enter the name ",10
    
docnam_menu_len equ $ -doc_add_name
doc_add_age:
    db "enter the age ",10
    
docage_menu_len equ $ -doc_add_age



section .bss

vec_data 

struc doctor
    .id resd 4
    .name resb 64
    .age resd 4




























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