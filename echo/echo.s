section .bss
  buffer resb 128

section .text
  global _start

_start:
  call _read
  call _write
  call _exit

_read:
  mov eax, 0 ; sys_read
  mov edi, 0 ; stdin
  mov rsi, buffer
  mov edx, 128 ; max read size
  syscall
  ret

_write:
  mov edx, eax ; write size
  mov eax, 1 ; sys_write
  mov edi, 1 ; stdout
  mov rsi, buffer
  syscall
  ret

_exit:
  mov eax, 60
  xor edi, edi
  syscall
