; 一応作ってみたが、アセンブラから親であるシェルのディレクトリを変更することはできない

section .data
  usage_msg db "Usage: cd <directory>", 0xA, 0
  usage_msg_len equ $ - usage_msg
  error_msg db "Error: Directory not found", 0xA, 0
  error_msg_len equ $ - error_msg

section .text
  global _start

_start:
  call _check_argc
  mov rdi, [rsp + 16]
  call _change_dir
  call _exit_success

_change_dir:
  mov rax, 80
  syscall
  test rax, rax
  jnz _print_chdir_error
  ret

_print_chdir_error:
  mov rax, 1
  mov rdi, 1
  mov rsi, error_msg
  mov rdx, error_msg_len
  syscall
  call _exit_error1

_check_argc:
  mov rsi, [rsp + 8]
  cmp rsi, 2
  jne _print_usage
  ret

_print_usage:
  mov rax, 1
  mov rdi, 1
  mov rsi, usage_msg
  mov rdx, usage_msg_len
  syscall
  call _exit_error1

_exit_error1:
  mov rax, 60
  mov rdi, 1
  syscall

_exit_success:
  mov rax, 60
  xor rdi, rdi
  syscall
