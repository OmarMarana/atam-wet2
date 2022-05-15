.global read_input
# , hamming_weight, negate_first_k, bring_balance_to_the_word,
.section .bss
.lcomm path, 1024

.section .text

read_input:
  pushq %rbp
  movq %rsp, %rbp
  pushq %rdi
  
  leaq path(%rip), %rdi
  call get_path
  leaq path(%rip), %rdi
  mov $2, %rax
  mov $0, %rsi
  syscall # open_path

  mov %rax, %rdi
  pushq %rdi
  sub $0x8, %rsp
  mov %rsp, %rsi
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

  syscall # read the requested n bytes

  mov $3, %rax
  syscall # close file
  mov %rdx, %rax   
  cdq
  mov $8, %r11d 
  div %r11d 

exit:
  leave
  ret

hamming_weight:
  # rdi is &codewordi
  # rsi is len
  pushq %rbp
  movq %rsp, %rbp
  pushq %rbx
  xor %rcx, %rcx
  mov $1, %rax
  xor %r9, %r9
  loop_1:
    cmp %rcx, %rsi
    je end_hamming_weight
    leaq (%rdi, %rcx, 8), %rbx
    xor %r8, %r8
    inc %rcx
    jmp loop_2

  loop_2:
    cmp $64, %r8
    je loop_1
    mov %rax, %r10
    and (%rbx), %r10
    inc %r8
    sal $1, %rax
    cmp $1, %r10
    je add
    jmp loop_2

  add:
    inc %r9
    jmp loop_2

  end_hamming_weight:
    pop %rbx
    mov %r9, %rax
    leave
    ret

negate_first_k:
  # rdi is codeword
  # rsi is k
  pushq %rbp
  movq %rsp, %rbp
  
  xor %rcx, %rcx
  cmp %rcx, %rsi
  je end_negate_first_k
  inc %rcx
  mov $1, %rax
  xor %rax, %rdi
  loop_negate_first_k:
    cmp %rsi, %rcx
    je end_negate_first_k
    sal $1, %rax
    xor %rax, %rdi
    inc %rcx
    jmp loop_negate_first_k

  end_negate_first_k:
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
  loop_bring_balance_to_the_word:
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