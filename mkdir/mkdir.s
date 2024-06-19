section .data
	arg_err_msg db 'Usage: mkdir <directory_name>', 0xA, 0 
	; $は命令実行時のアドレスを示す
	; $ - arg_err_megは事実上arg_err_msgの長さとなる
	arg_err_msg_len equ $ - arg_err_msg             ; エラーメッセージの長さ

section .text
	global _start

_start:
	call _check_argc
	mov rdi, [rsp+16]
	call _mkdir
	call _exit

; argcが2であるかどうかをtest
_check_argc:
	mov rsi, [rsp+8]
	cmp rsi, 2
	jne _arg_error

_mkdir:
	mov rax, 83
	mov rsi, 755o
	syscall
	ret

_arg_error:
	call _write_arg_error_msg
	call _exit_error1

_write_arg_error_msg:
	mov rax, 1
	mov rdi, 1
	lea rsi, [arg_err_msg]
	mov rdx, arg_err_msg_len
	syscall
	ret

_exit_error1:
	mov rax, 60
	mov rdi, 1
	syscall
	ret

_exit:
	mov rax, 60
	xor rdi, rdi
	syscall
	ret