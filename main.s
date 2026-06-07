global _start
bits 64

struc doctor
    .id resd 1
    .name resb 64
    .age resd 1
    alignb 8
endstruc
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

vec_data resq 1
vec_len resq 1
vec_cap resq 1
input resb 256

mode resb 1


tempid resd 1
tempname resb 64
tempage resd 1

counter resb 1;so also , .bss initializes to 0 with every new var created here 
























section .text

_start:
    mov rax,9; this is a call for the mmap, apparently in assembly u do a alert→args→ssycall , interesting
    xor rdi,rdi
    mov rsi,doctor_size*8;her ethe size 
    mov rdx,3 ;i dont actually need it since the data are not that precious but i ll just set it to 3 being read/write
    mov r10d,0x22
    mov r8d,-1
    mov r9d,0
    syscall
    mov qword [vec_data],rax
    mov qword [vec_cap],8
    mov qword [vec_len],0 ; so the [] act like * , without them i d be writing to an daresss
    
    


.loop:
    call _display
    call read_input
    mov al,[mode]
    cmp al,0
    je .menu_handel
    cmp al,1
    je .docmenu_handel
    cmp al,2
    je .doc_fill
    cmp al,4
    je .exit




.doc_fill
    mov al,[counter]
    cmp al,0
    je .cpy_id_doc






.cpy_id_doc:
    lea rsi,[input]
    lea rdi,[input]
    mov rsx,64
    rep movsb





























.menu_handel:
    mov al,[input]
    cmp al,'1'
    je .set_mode1
    jmp .loop


.docmenu_handel:
    mov al,[input]
    cmp al,'1'
    je .set_mode2
    cmp al,'4'
    je .set_mode0
    jmp .loop



    
.set_mode1:
    mov byte [mode],1
    jmp .loop

.set_mode2:
    mov byte [mode],2
    jmp .loop

.set_mode0:
    mov byte [mode],0
    jmp .loop

.exit:
    mov rax,60
    xor rdi,rdi
    syscall

read_input:
    push rbp
    mov rbp,rsp
    mov rax,0
    mov rdi,0
    lea rsi,[input] ,;so i need to use lea to pass adresses
    mov rdx,256
    syscall
    leave
    ret

    




















_display:; apparently this is the equivalent of a switch
    push rbp
    mov  rbp, rsp;and these are called prologue ,gotta be at the top of every fonction
    mov al,[mode]
    
    cmp al,0
    je .cas0

    cmp al,1
    je .cas1

    cmp al,2
    je .cas2

jmp .default


.cas0:
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,[menu]
    mov rdx,menu_len
    syscall
    jmp .end_switch
    

.cas1:
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,[doc_menu]
    mov rdx,doc_menu_len
    syscall
    jmp .end_switch
    

.cas2:
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,[doc_add_id]
    mov rdx,docid_menu_len
    syscall
    jmp .end_switch
    
.default:
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,[menu]
    mov rdx,menu_len
    syscall
    jmp .end_switch
.end_switch:
    leave
    ret








atoi:
    push rbp
    mov rbp,rsp
    xor rax,rax
    xor rcx,rcx
.loop:
    mov cl,[rdi]
    cmp cl,'0'
    jl .done
    cmp cl,'9'
    jg .done
    sub cl,'0'
    imul rax,10
    inc rdi
