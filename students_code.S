.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss
.lcomm path, 1024

.section .text

read_input:
  pushq %rbp
  movq %rsp, %rbp
  pushq %rdi
  
  leaq (path), %rdi
  call get_path

  leaq (path), %rdi
  mov $2, %rax
  mov $0, %rsi
  syscall # open_path

  mov %rax, %rdi
  pushq %rdi
  sub $0x8, %rsp
  mov %rbp, %rsi
  sub $8, %rsi
  movq %rsi, %r8 # r8 is the base of the null ter string
  mov $0, %rax
  mov $1, %rdx

  loop:
    syscall # read_file
    mov $0, %rax
    movb (%rsi, %rax), %r11b
    cmpb $0xa, %r11b
    je end_read
    inc %rsi
    jmp loop
  
end_read:
  cmp %rsi, %r8
  je exit
  movb $0x0, (%rsi)
  mov %r8, %rdi

  call atam_atol

  cmp $0, %rax
  je exit

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

exit:
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
  # rdi is &codewordi
  # rsi is len
  pushq %rbp
  movq %rsp, %rbp
  xor %rcx, %rcx
  add $1, %rax
  add $2, %rbx
  xor %r9, %r9
  loop_1:
    cmp %rcx, %rsi
    jae end
    leaq(%rdi, %rcx, 8), %rdx
    xor %r8, %r8
    inc %rcx
    jmp loop_2

  loop_2:
    cmp $8, %r8
    jae loop_1
    mov %rax, %r10
    xor %rdx, %r10
    And %rax, %r10
    inc %r8
    cmp $0, %r10
    jb add
    mul %rbx
    jmp loop_2

  add:
    inc %r9
    mul %rbx
    jmp loop_2

  end:
    leave
    ret

negate_first_k:
  # rdi is codeword
  # rsi is k
  pushq %rbp
  movq %rsp, %rbp
  xor %rcx, %rcx
  cmp %rcx, %rsi
  jae end
  inc %rcx
  mov $1, %rax
  mov $2, %rbx
  xor %rax, %rdi
  inc %rcx
  loop:
    cmp %rcx, %rsi
    jae end
    mul %rbx
    xor %rax, %rdi
    inc %rcx
    ja loop

  end:
    mov %rdi, %rax
    leave
    ret

bring_balance_to_the_word:
  # rdi is &codeword
  # rsi is len
  pushq %rbp
  movq %rsp, %rbp
  mov %rsi, %rax
  xor %rcx, %rcx
  xor %rdx, %rdx
  mov $2, %rbx
  div %rbx
  mov %rax, %rsi  # rsi /= 2
  loop:
    cmp %rcx, %rsi
    jae end
    call hamming_weight
    cmp %rax, %rsi
    je end
    inc %rcx
    call negate_first_k

  end:
    mov %rcx, %rax
    leave
    ret