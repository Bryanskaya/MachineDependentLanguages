;������������ ���� 16-���������� ����� � ����� ��� � �������� � �����������
;�������������. �������������� � ������������� �� ������ ����. 
;��������� ������ ��������� �� ����� 4-� �������. 
;������� ������ ������ ������������ ����� ����, � �����
;��������� ������ ���������� �� ������������, ����������� ��������,
;��������������� ������� ����. ����� �����������
;������� ��������� ������������ � ������� ��������� �� ������� ��������
;���������� ������ ����.

;�������� �����: �������� � 2 ��
;1 ���������:    ����������� � 8 ��
;2 ���������:    �������� � 16 ��

EXTRN input_data: 	  	near
EXTRN move_to_form_8: 	near
EXTRN move_to_form_16: 	near
EXTRN output_msg: 	  	near
EXTRN input_command:  	near
EXTRN check_command:  	near

PUBLIC buf
PUBLIC number
PUBLIC exit

StkSeg SEGMENT PARA STACK 'STACK'
	DB 100h DUP (?)
StkSeg ENDS

DataSeg SEGMENT	PUBLIC	
	buf 				DB 100h DUP ('$')
	menu				DB 13, 10, 13, 10, ' MENU:'
						DB 13, 10, ' 1. Input new number'
						DB 13, 10, ' 2. Unsigned 8 n/s'
						DB 13, 10, ' 3. Signed  16 n/s'
						DB 13, 10, ' 0. Exit'
						DB 13, 10, 13, 10, ' Your choice: $'
	proc_arr 			DW exit, input_data, move_to_form_8, move_to_form_16
	number				DW 0
DataSeg ENDS

CodeSeg SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:CodeSeg, DS:DataSeg
	
main:
	mov AX, DataSeg
	mov DS, AX
	
	call input_data
	
	menu_proc:
		mov DX, OFFSET menu
		call output_msg
		
		call input_command
		call check_command
		
		shl AX, 1
		mov BX, AX
		call proc_arr[BX]
		
		mov CX, 2
	LOOP menu_proc

exit:
	mov AH,4Ch
	int 21h
CodeSeg ENDS
END main