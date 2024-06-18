section .data
    newline db 0xA
    err_msg db 'Error opening file', 0xA

section .bss
    buffer resb 4096

section .text
    global _start

_start:
    mov rdi, [rsp + 16]
    call _open
    cmp rax, 0
    js _open_error
    mov rbx, rax ; Save file descriptor in rbx
    jmp read_loop

_open:
    mov eax, 2 ; sys_open
    mov rsi, 0 ; O_RDONLY
    syscall
    ret

_read:
    mov eax, 0 ; sys_read
    mov rdi, rbx ; Use saved file descriptor from rbx
    mov rsi, buffer
    mov rdx, 4096
    syscall
    ret

_write:
    mov eax, 1 ; sys_write
    mov rdi, 1 ; stdout
    mov rsi, buffer
    syscall
    ret

_write_EOL:
    mov eax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall 
    ret

_close:
    mov eax, 3 ; sys_close
    mov rdi, rbx ; 
    syscall
    jmp _exit

_exit:
    mov eax, 60 ; sys_exit
    xor rdi, rdi
    syscall

read_loop:
    call _read
    test rax, rax
    jz end_read
    mov rdx, rax ; byte length
    call _write
    jmp read_loop

end_read:
    ; call _write_EOL
    call _close
    jmp _exit

_open_error:
  mov rsi, err_msg
  mov rdi, 1
  mov rdx, 19
  mov eax, 1 ; sys_write
  syscall
  jmp _exit_error

_exit_error:
  mov eax, 60 ; sys_exit
  mov rdi, 1
  syscall
