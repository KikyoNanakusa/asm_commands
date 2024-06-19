section .data
	flags dq 0x41 ; O_WRONLY | O_CREAT
	mode dq 0o666 ; permission
	usage db "Usage: touch <file>", 0xA, 0x00
	usage_len equ $ - usage

section .text
	global _start

_start:
	call _check_argc
	mov rdi, [rsp+16]
	call _touch
	call _exit

_check_argc:
	; call命令を挟むためスタック上でのargcの位置がずれる
	; 具体的にはリターンポインタ分の8バイト分
	mov rsi, [rsp+8]
	cmp rsi, 2
	jne _print_usage
	ret

_print_usage:
	mov rax, 1
	mov rdi, 1
	lea rsi, [usage]
	mov rdx, usage_len
	syscall
	
	mov rax, 60
	mov rdi, 1
	syscall
	ret

_touch:
	mov rax, 0x2
	mov rsi, [rel flags]
	mov rdx, [rel mode]
	syscall

	; error handling
	cmp rax, 0
	js _error

	; close file
	mov rdi, rax
	call _close
	ret


_error:
	mov rax, 60
	mov rdi, 1
	syscall
	ret

_close:
	mov rax, 3
	syscall
	ret

_exit:
	mov rax, 60
	xor rdi, rdi
	syscall
	ret