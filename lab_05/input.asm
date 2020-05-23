EXTRN output_msg: 			near
EXTRN error_msg:  			near
EXTRN error_msg_plus_minus: near
EXTRN exit: 	  			near
EXTRN buf: 	  	  			byte
EXTRN number:				word

DataSeg SEGMENT
	inv_input_number    DB 13, 10, 13, 10, ' Input number (signed 2 n/s, +/- important): $'
DataSeg ENDS

CodeSeg SEGMENT PARA PUBLIC 'CODE'	
base_2	DW 2
input_data proc
	push DS
	assume DS:DataSeg
	mov AX, DataSeg
	mov DS, AX
	
	mov DX, OFFSET inv_input_number
	call output_msg
	
	mov AX, SEG buf
	mov DS, AX
	
	call input_number
	
	mov AX, SEG buf
	mov ES, AX
	
	call check_length_number
	call check_number
	call move_to_signes
	
	pop DS
	ret
input_data endp

input_number proc
	mov DX, OFFSET buf
	mov AH, 0Ah
	int 21h
	ret
input_number endp

input_command proc
	mov AH, 01h
	int 21h
	sub AL, '0'
	
	mov AH, 0
	ret
input_command endp

check_command proc
	cmp AL, 0
	jb error_msg
	cmp AL, 3
	ja error_msg
	ret
check_command endp

check_length_number proc
	cmp ES:buf[1], 2
	jb error_msg
	cmp ES:buf[1], 16
	ja error_msg
	ret  
check_length_number endp

check_number proc
	cmp ES:buf[2], '+'
	je check_signes
	cmp ES:buf[2], '-'
	jne error_msg_plus_minus

check_signes:	
	mov DI, 3
	mov CH, 0
	mov CL, ES:buf[1]
	dec CL
	check_sign:
		cmp ES:buf[DI], '1'
		je continue
		cmp ES:buf[DI], '0'
		jne error_msg	
	continue:
		inc DI
	LOOP check_sign
	ret
check_number endp

move_to_signes proc
	mov DI, 3
	mov CH, 0
	mov CL, ES:buf[1]
	dec CL
	mov AX, 0
	
	move:
		shl AX, 1
		
		mov BL, ES:buf[DI]
		sub BL, '0'
		add AL, BL
		
		inc DI
	LOOP move
	
	mov ES:number, AX
	
	cmp ES:buf[2], '-'
	jne continue
	neg ES:number

continue:
	ret
move_to_signes endp

CodeSeg ENDS
END