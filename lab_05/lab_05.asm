;Осуществлять ввод 16-разрядного числа и вывод его в знаковом и беззнаковом
;представлении. Взаимодействие с пользователем на основе меню. 
;Программа должна содержать не менее 4-х модулей. 
;Главный модуль должен обеспечивать вывод меню, а также
;содержать массив указателей на подпрограммы, выполняющие действия,
;соответствующие пунктам меню. Вызов необходимой
;функции требуется осуществлять с помощью адресации по массиву индексом
;выбранного пункта меню.

;Вводимое число: знаковое в 2 сс
;1 выводимое:    беззнаковое в 8 сс
;2 выводимое:    знаковое в 16 сс

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