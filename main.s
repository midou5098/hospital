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
doc_search_id:
    db "enter the doctor id to look for",10
docsid_len equ $ -doc_search_id
announ_id:
    db "the id : "
    
an_id_len equ $ -announ_id
announ_name:
    db "the name : "
    
an_name_len equ $ -announ_name
announ_age:
    db "the age : "
    
an_age_len equ $ -announ_age
newline     db 10
newline_len equ $ - newline
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

count resb 1

old_size resd 1

itoa_buffer resb 32

itoa_len    resb 1

















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
    cmp al,3
    je .doc_fill
    cmp al,4
    je .doc_fill
    cmp al,5
    je .ssearch_h
    cmp al,6
    je .delete

.ddelete:
    xor rcx, rcx 
    lea rdi,[input]
    call atoi
    mov r12d,eax
    xor rcx,rcx
    jmp .delete
.delete:
    cmp rcx,[vec_len]
    je .not_found
    mov rbx,[vec_data]
    mov rdx,rcx
    imul rdx,doctor_size
    add rbx,rdx
    cmp [rbx+doctor.id],r12d
    mov rdi,rbx
    
    je .delete_mf
    inc rcx
    jmp .delete
.delete_mf:
;so every push saves the state and every pop ressurects it , hmm
    cmp rcx,[vec_len]
    je .ddone
    lea rsi,[rdi+doctor_size]
    mov rax,[vec_len]
    sub rax,rcx
    dec rax
    imul rax,doctor_size
    mov rcx,rax 

    imul rcx,doctor_size
    rep movsb
    

.ddone:
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,doc_del
    mov rdx,doc_del_len
    syscall
    dec qword [vec_len]
    
    mov [mode],0
    jmp .loop










.ssearch_h:
    xor rcx, rcx 
    lea rdi,[input]
    call atoi
    xor rcx,rcx
    jmp .search_h

.search_h:
    cmp rcx,[vec_len]
    je .not_found
    
    mov rbx,[vec_data]
    mov rdx,rcx
    imul rdx,doctor_size
    add rbx,rdx
    cmp [rbx+doctor.id],eax
    je .found
    inc rcx
    jmp .search_h
.not_found:
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,not_found
    mov rdx,not_found_len
    syscall
    mov [mode],0
    jmp .loop
.found:
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,announ_id
    mov rdx,an_id_len
    syscall

    movzx rax,dword[rbx+doctor.id]
    call itoa
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,[itoa_buffer]
    movzx rdx,byte [itoa_len]
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall


    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,announ_name
    mov rdx,an_name_len
    syscall


    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,[rbx+doctor.name]
    mov rdx,64
    syscall


    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall


    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,announ_age
    mov rdx,an_age_len
    syscall


    movzx rax,dword[rbx+doctor.age]
    call itoa
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,[itoa_buffer]
    movzx rdx,byte [itoa_len]
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

    

    mov [mode],0
    jmp .loop



.doc_fill:
    mov al,[counter]
    cmp al,0
    je .cpy_id_doc
    cmp al,1
    je .cpy_name_doc
    cmp al,2
    je .cpy_age_doc






.cpy_id_doc:
    lea rdi,[input]
    call atoi
    mov [tempid],eax;eax is the lower 32 bits , 
    inc byte [counter]
    mov byte [mode],3
    jmp .loop


.cpy_name_doc:
    lea rsi,[input]
    lea rdi,[tempname]
    mov rcx, 64
    rep movsb
    inc byte [counter]
    mov byte [mode],4
    jmp .loop

.cpy_age_doc:
    lea rdi,[input]
    call atoi
    mov [tempage],eax;eax is the lower 32 bits , 
    mov byte [counter],0
    mov rdi ,[tempid]
    lea rsi ,[tempname]
    mov rdx ,[tempage]
    call push_doc
    jmp .set_mode0
    jmp .loop





.menu_handel:
    mov al,[input]
    cmp al,'1'
    je .set_mode1
    
    jmp .loop


.docmenu_handel:
    mov al,[input]
    cmp al,'1'
    je .set_mode2
    cmp al,'2'
    je .set_mode5
    cmp al,'4'
    je .set_mode0
    jmp .loop



    
.set_mode1:
    mov byte [mode],1
    jmp .loop
.set_mode5:
    mov byte [mode],5
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
push_doc:
    push rbp
    mov  rbp, rsp
    mov rax,[vec_cap]
    cmp rax,[vec_len]
    jg .affect
    je .expand
    inc qword [vec_len]
    leave
    ret 


.affect:
    mov rbx,[vec_data]
    mov rax,[vec_len]
    imul rax,doctor_size
    add rbx,rax
    mov eax,[tempid]
    mov [rbx+doctor.id],eax
    lea rsi,[tempname]
    lea rdi,[rbx+doctor.name]
    mov rcx,64
    rep movsb;apparently this is the assembly version of string copy , 1st and second arguments (rsi,rsd)then call with setting rcx to 64 and rep movsb
    mov eax,[tempage]
    mov [rbx+doctor.age],eax
    inc qword [vec_len]
    mov [mode],1
    leave
    ret 

.expand:
    push rbx
    push r12
    mov r12,[vec_data]
    mov rbx , [vec_cap]
    
    
    mov rax,9
    xor rdi,rdi
    mov rsi,[vec_cap]
    shl rsi,1
    imul rsi,doctor_size
    mov rdx,3
    mov r10d,0x22
    mov r8d,-1
    mov r9d,0
    syscall



   
    mov rdi,rax
    mov rsi,r12
    mov rcx,[vec_len]
    imul rcx,doctor_size
    rep movsb

    push rax
    mov rdi,r12
    imul rbx,doctor_size
    mov rsi,rbx
    mov rax,11
    syscall
    pop rax

    mov [vec_data],rax
    shl qword [vec_cap],1
    pop r12
    pop rbx
    jmp .affect



;.copy:
 ;   imul rcx,doctor_size
  ;  lea rsi,[vec_data+rcx]
   ; lea rsd,[rdi+rcx]

























read_input:
    push rbp
    mov rbp,rsp
    mov rax,0
    mov rdi,0
    lea rsi,[input] ;so i need to use lea to pass adresses
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

    cmp al,3
    je .cas3

    cmp al,4
    je .cas4
    cmp al,5
    je .cas5

    

    

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

.cas3:
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,[doc_add_name]
    mov rdx,docnam_menu_len
    syscall
    jmp .end_switch
.cas4:
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,[doc_add_age]
    mov rdx,docage_menu_len
    syscall
    jmp .end_switch
.cas5:
    mov rax,1;a write call
    mov rdi,1; serves as "set mode to std::out as there is also a file mode"
    lea rsi,[doc_search_id]
    mov rdx,docsid_len
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
    add rax,rcx
    inc rdi
    jmp .loop

.done :
    leave 
    ret
    

itoa:
    push rbp
    mov rbp,rsp
    mov rcx,10
.loop:
    xor rdx,rdx
    div rcx
    add dl,'0'
    push rdx
    inc byte [count]
    cmp rax,0
    jne .loop
    mov  al, [count]
    mov  [itoa_len], al
    lea rdi, [itoa_buffer]  
.pop:
    pop rax
    mov [rdi],al
    inc rdi
    dec byte [count]
    jnz .pop
    



.done :
    leave 
    ret




delete:
