section .data
  ; db means Define Byte
  newline db 0xA ; newline code

section .text
  global _start

_start:
  ; mov rsi, [rsp+8] ; argv[0]
  mov rsi, [rsp+16] ; argv[1]
  call _print
  call _exit

_print:
  mov rdx, 0
print_loop:
  cmp byte [rsi+rdx], 0
  je print_end
  inc rdx
  jmp print_loop

print_end:
  ; rsiには既にargv[1]のアドレスが入っている
  ; rdxにはprint_loopでnull文字までの長さが入っている 
  mov rax, 1 ; sys_write
  mov rdi, 1 ; stdout
  syscall

  ; 改行文字を出力
  call _print_EOL

  ret

_print_EOL:
  mov rax, 1
  mov rdi, 1
  mov rsi, newline
  mov rdx, 1
  syscall
  ret

_exit:
  mov rax, 60
  xor rdi, rdi
  syscall
