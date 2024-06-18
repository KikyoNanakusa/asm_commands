section .data
  newline db 0x0A

section .bss
  buffer resb 256

section .text
  global _start

_start:
  call _getcwd
  cmp rax, -1
  je _error
  call _write
  call _write_newline
  call _exit

_getcwd:
  mov rax, 79
  lea rdi, [buffer]
  mov rsi, 256
  syscall
  mov rbx, rax
  ret

_write:
  mov rax, 1
  mov rdi, 1
  lea rsi, buffer
  mov rdx, rbx
  syscall
  ret

_write_newline:
  mov rax, 1
  mov rdi, 1
  lea rsi, [newline]
  mov rdx, 1
  syscall
  ret

_exit:
  mov rax, 60
  xor rdi, rdi
  syscall

_error:
  mov rax, 60
  mov rdi, 1
  syscall
  ret
