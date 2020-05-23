EXTRN number:				word
EXTRN print_form_8: 		near

PUBLIC string_8

DataSeg SEGMENT
	string_8	DB 7 DUP (0), '$'
DataSeg ENDS

CodeSeg SEGMENT PARA PUBLIC 'CODE'
move_to_form_8 proc
	push DS
	assume DS:DataSeg
	mov AX, DataSeg
	mov DS, AX
	
	mov AX, SEG number
	mov ES, AX
	mov AX, ES:number
	
	mov DI, 6
	mov CX, 6
	move:
		mov DX, AX
		and DX, 7
		
		shr AX, 1
		shr AX, 1
		shr AX, 1
		
		call transf_to_sym
		
		mov string_8[DI], DL
		
		dec DI
	LOOP move
		
	call print_form_8
	
	pop DS
	ret
move_to_form_8 endp

transf_to_sym proc
	add DL, '0'
	ret
transf_to_sym endp

CodeSeg ENDS
END