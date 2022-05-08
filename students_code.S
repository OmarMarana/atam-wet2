.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss
.lcomm path, 1024

.section .text
read_input:
  pushq %rbp
  movq %rsp, %rbp
  
  mov path, %rdi
  call get_path

  mov path, %rdi
  mov $2, %rax
  mov $0, %rsi
  syscall # open_path

  mov %rax, %rdi 
  sub $0x8, %rsp
  lea -8(%rbp,,), %rsi
  mov $0, %rax
  mov $8, %rdx
  syscall # read_file
  mov $0, %rdx
  mov $0, %rcx
  loop: 
    lea (%rsi, %rcx, 1), %rbx
    cmp $0xa, (%rbx)
    je exit
    inc %rcx

  exit:
    mov $0x0, (%rbx)

  ret

hamming_weight:
  ret

negate_first_k:
  ret

bring_balance_to_the_word:
  ret
