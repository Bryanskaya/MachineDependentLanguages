EXTRN string_8:  byte
EXTRN string_16: byte
EXTRN exit: 	 near

DataSeg SEGMENT
	empty_string	DB 13, 10, '$'
	error_info_1	DB 13, 10, ' INCORRECT INPUT$'
	error_info_2	DB 13, 10, ' INCORRECT INPUT (no +/-)$'
	form_8			DB 13, 10, ' Unsigned 8 n/s form: $'
	form_16			DB 13, 10, ' Signed  16 n/s form: $'
DataSeg ENDS

CodeSeg SEGMENT PARA PUBLIC 'CODE'
output_msg proc
	mov AH, 9
	int 21h
	ret
output_msg endp

output_char proc
	mov AH, 02h
	int 21h
	ret
output_char endp

error_msg proc 
	assume DS:DataSeg
	mov AX, DataSeg
	mov DS, AX
	
	mov DX, OFFSET empty_string
	call output_msg
	
    mov DX, OFFSET error_info_1
    call output_msg 
	
	mov DX, OFFSET empty_string
	call output_msg
	
    call exit
error_msg endp

error_msg_plus_minus proc 
	assume DS:DataSeg
	mov AX, DataSeg
	mov DS, AX
	
	mov DX, OFFSET empty_string
	call output_msg
	
    mov DX, OFFSET error_info_2
    call output_msg 
	
	mov DX, OFFSET empty_string
	call output_msg
	
    call exit
error_msg_plus_minus endp

print_form_8 proc
	mov AX, DataSeg
	mov DS, AX
	
	mov DX, OFFSET empty_string
	call output_msg
	
	mov DX, OFFSET form_8
	call output_msg
	
	mov AX, SEG string_8
	mov DS, AX
	mov DX, OFFSET string_8
	
	mov SI, 1
	mov CX, 5
out_1:
	mov DL, [SI]
	cmp DL, '0'
	je ignore
	
out_2:
	cmp CX, 0
	je break
	call output_char
	inc SI
	dec CX
	mov DL, [SI]
	jmp out_2
	
ignore:
	inc SI
LOOP out_1
break:
	mov DL, [SI]
	call output_char
	ret
print_form_8 endp

print_form_16 proc
	mov AX, DataSeg
	mov DS, AX
	
	mov DX, OFFSET empty_string
	call output_msg
	
	mov DX, OFFSET form_16
	call output_msg
	
	mov AX, SEG string_16
	mov DS, AX
	mov DX, OFFSET string_16
	
	mov SI, 0
	mov DL, [SI]
	call output_char
	mov CX, 3;4
	inc SI
out_1:
	mov DL, [SI]
	cmp DL, '0'
	je ignore
	
out_2:
	cmp CX, 0
	je break
	call output_char
	inc SI
	dec CX
	mov DL, [SI]
	jmp out_2
	
ignore:
	inc SI
LOOP out_1
break:
	mov DL, [SI]
	call output_char
	ret
print_form_16 endp
CodeSeg ENDS
END