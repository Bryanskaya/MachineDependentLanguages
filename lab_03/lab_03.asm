StkSeg SEGMENT PARA STACK 'STACK'
	DB 100h DUP (?)
StkSeg ENDS

DataSeg SEGMENT
	string 			DB 100h DUP ('$')
	message_invite	DB 13, 10, 'Input string:   $'
	message_out		DB 13, 10, 'First 10 signs: $'
	marker 			DB '$'
	empty_string 	DB 13, 10, '$'
DataSeg ENDS

CodeSeg SEGMENT PARA 'CODE'
	ASSUME CS:CodeSeg, DS:DataSeg
main:
	mov AX, DataSeg
	mov DS, AX
	
	mov DX, OFFSET message_invite
	mov AH, 9
	int 21h
	
	mov DX, OFFSET 	string
	mov AH, 0Ah
	int 21h

	mov DX, OFFSET message_out
	mov AH, 9
	int 21h
	
	mov string[10 + 2], '$'
	
	mov DX, OFFSET marker
	mov AH, 9h
	int 21h
	mov DX, OFFSET string
	add DX, 2
	int 21h
	mov DX, OFFSET empty_string
	mov AH, 9h
	int 21h
	
	mov AH,4Ch
	int 21h
CodeSeg ENDS
END main

