.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss
.lcomm path, 1024

.section .text
read_input:
  pushq %rbp
  movq %rsp, %rbp
  pushq %rdi
  
  mov $path, %rdi
  call get_path

  mov $path, %rdi
  mov $2, %rax
  mov $0, %rsi
  syscall # open_path

  mov %rax, %rdi
  pushq %rdi
  sub $0x8, %rsp
  lea -8(%rbp,,), %rsi
  movq %rsi, %r8 # r8 is the base of the null ter string
  mov $0, %rax
  mov $1, %rdx
  loop:
    syscall # read_file
    movb (%rsi), %r11b
    cmpb $0xa, %r11b
    je end_read
    inc %rsi
    jmp loop
  
end_read:
  mov 0x0, (%rsi)
  mov %r8, %rdi

  call atam_atol

  mov %rax, %rdx
  mov $0, %rax
  addq $8, %rsp
  popq %rdi
  popq %rsi

  syscall # as omar said it will continue from where it got

  mov %rdx, %rax   
  cdq
  mov $8, %r11d      # ##################################
  div %r11d        # check for silly scummy bugs here
                        # ##################################

  mov $3, %rax
  syscall # close file

  leave
  ret

//  mov %rax, %rdi 
//  sub $0x8, %rsp
// lea -8(%rbp,,), %rsi
//  mov $0, %rax
  ; mov $8, %rdx
  ; syscall # read_file

//  mov $0, %rcx

//  loop: 
//    lea (%rsi, %rcx, 1), %rbx
//    cmpb $0xa, (%rbx)
//    je exit
//    inc %rcx
//    jmp loop

//  exit:
//    mov $0x0, (%rbx)
//    mov %rsi, %rdi
//    call atam_atol



hamming_weight:
  ret

negate_first_k:
  ret

bring_balance_to_the_word:
  ret
