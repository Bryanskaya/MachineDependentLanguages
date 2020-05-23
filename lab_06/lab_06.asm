CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG
	org 	100h
	
main:
	jmp 	init	
	ptr_1C 				DD ?
	output_str_time 	DB '00:00:00'
	output_str_data		DB '00.00.00'
	
	key_code			DB 00000001b, 'Right Shift',
						   00000010b, ' Left Shift',
						   00000100b, '       Ctrl',
						   00001000b, '        Alt',
						   00100000b, '   Num Lock',
						   01000000b, '  Caps Lock',
						   10000000b, '     Insert'
	
output_time proc
	mov AH, AL
	
	and AL, 0Fh
	add AL, '0'
	
	shr AH, 1
	shr AH, 1
	shr AH, 1
	shr AH, 1
	add AH, '0'
	
	mov output_str_time[BX], AH
	mov output_str_time[BX + 1], AL
	ret
output_time endp

output_data proc
	mov AH, AL
	
	and AL, 0Fh
	add AL, '0'
	
	shr AH, 1
	shr AH, 1
	shr AH, 1
	shr AH, 1
	add AH, '0'
	
	mov output_str_data[BX], AH
	mov output_str_data[BX + 1], AL
	ret
output_data endp

current_time proc
	mov 	AH, 2
	int		1Ah
	
	mov		AL, CH
	mov		BX, 0
	call	output_time
	
	mov		AL, CL
	add		BX, 3
	call	output_time
	
	mov		AL, DH
	add		BX, 3
	call	output_time
	
	mov 	AX, 0B800h
	mov 	DS, AX
	mov		DI, (80-8)*2
	
	mov 	BX, 0
	mov 	CX, 8
	output:
		mov 	AH, 00011111b
		
		mov 	AL, output_str_time[BX]
		mov 	DS:[DI], AX
		add 	DI, 2
		inc 	BX
	loop output
	ret
current_time endp

current_data proc
	mov 	AH, 4
	int		1Ah
	
	mov		AL, DL
	mov		BX, 0
	call	output_data
	
	mov		AL, DH
	add		BX, 3
	call	output_data
	
	mov		AL, CL
	add		BX, 3
	call	output_data
	
	mov 	AX, 0B800h
	mov 	DS, AX
	mov		DI, (80 * 2 - 8) * 2
	
	mov 	BX, 0
	mov 	CX, 8
	output:
		mov 	AH, 00011111b
		
		mov 	AL, output_str_data[BX]
		mov 	DS:[DI], AX
		add 	DI, 2
		inc 	BX
	loop output
	ret
current_data endp

show_key proc
	push 	CX
	push 	SI
	push 	DI
	
	mov 	DH, 00000000b
	mov		DL, ' '
	mov 	CX, 11
	fill_black:
		mov 	DS:[(80 * 3 - 12)*2][DI], DX
		add 	DI, 2
	loop fill_black
	
	test	AL, key_code[SI]
	jz		exit
	
	pop 	DI
	push 	DI
	
	mov 	DH, 00011111b
	mov 	CX, 11
	output:
		mov		DL, key_code[SI+1]
		mov 	DS:[(80 * 3 - 12)*2][DI], DX
		inc 	SI
		add 	DI, 2
	loop output
	
exit:
	pop 	DI
	pop 	SI
	pop 	CX
	ret
show_key endp

current_info proc
	pushf
	call	dword ptr ptr_1C
	
	push 	AX
	push 	BX
	push 	CX
	push 	DX
	
	push	DS
	push	DI
	
	call 	current_time
	call 	current_data
	
	mov 	AH, 02h
	int 	16h
	
	mov 	CX, 7
	mov 	SI, 0
	mov		DI, 0
	output_key:
		call 	show_key
		add 	SI, 12
		add		DI, 80*2
	loop output_key
	
	pop		DI
	pop		DS
	
	pop		DX
	pop		CX
	pop		BX
	pop		AX
	iret
current_info endp
	
init:
	mov		AX, 3
    int 	10h
	
	mov 	AX, 351Ch
	int 	21h
	
	mov		word ptr ptr_1C, BX
	mov		word ptr ptr_1C + 2, ES
	
	mov     AX,  251Ch
	mov     DX,  offset current_info
	int     21h
	
	mov     AX,  3100h
	mov     DX, (init - main + 100h) / 10h + 1
	int     21h
	
CSEG ENDS
END main