EXTRN number:				word
EXTRN print_form_16: 		near

PUBLIC string_16

DataSeg SEGMENT
	string_16	DB 6 DUP (0), '$'
DataSeg ENDS

CodeSeg SEGMENT PARA PUBLIC 'CODE'
move_to_form_16 proc
	push DS
	assume DS:DataSeg
	mov AX, DataSeg
	mov DS, AX
	
	mov AX, SEG number
	mov ES, AX
	mov AX, ES:number
	
	mov string_16[0], '+'
	
	cmp AX, 0
	jge continue
	mov string_16[0], '-'
	neg AX
	
continue:
	mov DI, 4
	mov CX, 4
	move:
		mov DX, AX
		and DX, 15
		
		shr AX, 1
		shr AX, 1
		shr AX, 1
		shr AX, 1
		
		call transf_to_sym_16
		
		mov string_16[DI], DL
		
		dec DI
	LOOP move
		
	call print_form_16
	
	pop DS
	ret
move_to_form_16 endp

transf_to_sym_16 proc
	cmp DL, 10
	jb less_10
	jge more_9
less_10:
	add DL, '0'
	ret
more_9:
	add DL, 'A' - 10
	ret
transf_to_sym_16 endp

CodeSeg ENDS
END