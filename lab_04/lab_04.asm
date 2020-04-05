; Тип матрицы: прямоугольная, цифровая
; Задание: чётные элементы увеличить на 1, нечётные - уменьшить на 1.
; Вывести только последние цифры новых значений

StkSeg SEGMENT PARA STACK 'STACK'
	DB 100h DUP (?)
StkSeg ENDS

DataSeg SEGMENT
	inv_input_num_str	DB 13, 10, 'Input number of strings (0 < num < 10): $'
	inv_input_num_col 	DB 13, 10, 'Input number of columns (0 < num < 10): $'
	inv_input_elem	 	DB 13, 10, 'Input elements (0 <= elem <= 9): $'
	empty_string 		DB 13, 10, '$'
	error_info			DB 13, 10, 'INCORRECT INPUT$'
	result				DB 13, 10, 'Changed matrix:$'
	
	matr				DB 9 DUP (9 DUP (?))
	num_str	LABEL byte	
						DB 0
	num_col	LABEL byte
						DB 0
	temp	LABEL byte
						DB 0
DataSeg ENDS

CodeSeg SEGMENT PARA 'CODE'
	ASSUME CS:CodeSeg, DS:DataSeg
check_number:
	cmp AL, 1
	jb error_msg
	cmp AL, 9
	ja error_msg
	ret
check_element:
	cmp AL, 0
	jb error_msg
	cmp AL, 9
	ja error_msg
	ret
error_msg:
	call move_new_line 
    mov DX, OFFSET error_info
    call output_msg 
	call move_new_line
    call exit
output_msg:
	mov AH, 9
	int 21h
	ret
move_new_line:
	mov DX, OFFSET empty_string
	call output_msg
	ret
input_number:
	mov AH, 01h
	int 21h
	sub AL, '0'
	ret
print_space:
	mov AH, 02h
	mov DL, ' '
	int 21h
	ret
print_element:
	mov AH, 02h
	add DL, '0'
	int 21h
	ret
print_matrix:
	mov CX, 0
	mov DI, 0
	mov CL, num_str
	mov temp, CL
	print_str:
		mov SI, DI
		mov CL, num_col
		print_elem:
			mov DL, matr[SI]
			call print_element
			call print_space
			inc SI
		LOOP print_elem
		call move_new_line	
		
		add DI, 9
		mov CL, temp
		dec temp
	LOOP print_str
	ret
is_even:
	inc AL
	jmp return_label
is_odd:
	dec AL
	jmp return_label
main:
	mov AX, DataSeg
	mov DS, AX
	
	mov DX, OFFSET inv_input_num_str
	call output_msg
	
	call input_number
	call check_number
	mov num_str, AL
	
	mov DX, OFFSET inv_input_num_col
	call output_msg
	
	call input_number
	call check_number
	mov num_col, AL
	
	mov DX, OFFSET inv_input_elem
	call output_msg
	
	mov DX, OFFSET empty_string
	call output_msg
	
	mov CX, 0
	mov DI, 0
	mov CL, num_str
	mov temp, CL
	in1:
		mov SI, DI
		mov CL, num_col
		in2:
			call input_number
			call check_element
			mov matr[SI], AL
			inc SI
			
			call print_space
		LOOP in2
		call move_new_line	
		
		add DI, 9
		mov CL, temp
		dec temp
	LOOP in1
	
	mov CX, 0
	mov DI, 0
	mov CL, num_str
	mov temp, CL
	pr1:
		mov SI, DI
		mov CL, num_col
		pr2:
			mov AL, matr[SI]
			test AL, 1
			jz is_even
			jnz is_odd
return_label:			
			mov matr[SI], AL
			inc SI
		LOOP pr2
		add DI, 9
		mov CL, temp
		dec temp
	LOOP pr1
	
	mov DX, OFFSET result
	call output_msg
	mov DX, OFFSET empty_string
	call output_msg
	
	call print_matrix
	
exit:
	mov AH,4Ch
	int 21h
CodeSeg ENDS
END main