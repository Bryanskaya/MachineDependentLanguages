;; Лабораторная работа №6. 

;; Отобразить текущее время в правом верхнем углу
;; Высвечивать последнюю нажатую клавишу раз в секунду

;;;
CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG
	org 	100h						; Оставляем память под PSP
main:
	jmp init							; При запуске проги сразу прыгаем к инициализации
	ptr_1C		db 4 dup (?)			; Указатель на старое прерывание таймера 1C
	time_str	db '00:00:00'			; Строка времени
	
	; Это вообще ***, попробую объяснить
	; Первое - маска для AND, с помощью неё и TEST из AL вытаскивается информация клавише
	; Второе - подпись символа
	key_mask	db  10000000b, 	'I',	; Insert
					01000000b, 	'^',	; Caps lock
					00001000b,	'A',	; Alt
					00000100b, 	'C',	; Ctrl
					00000010b,	'S',	; Left Shift
					00000001b,	's'		; Right Shift

write_time proc
	; На входе приходит AL. В первых 4 битах одно число, во вторых 4 битах - второе число. Их надо разъединить
	mov 	AH, AL				; Копия в AH
	
	and		AL, 00001111b		; Отсекаем из AL первое число
	add		AL, '0'
	
	shr		AH, 1				; Сдвигом на 4 бита вправо отсекаем из AH второе число
	shr		AH, 1
	shr		AH, 1
	shr		AH, 1
	add		AH, '0'
	
	; Итог - в AH и AL лежит по числу. Заносим их в строку
	mov		time_str[BX], AH	
	mov		time_str[BX+1], AL
	ret
write_time endp

key_pixel proc
	mov 	DH, 00000000b
	mov		DL, ' '
	mov 	DS:[(160-7)*2][DI], DX	; Сначала на этом месте экрана рисуем чёрным
	
	test	AL, key_mask[DI]		; С помощью нужной маски узнаём нажата ли текущая клавиша
	jz		exit					; Если TEST = 0, то нужный бит не активирован, выходим из процесса
	
	mov 	DH, 00011010b			; Если TEST != 0, то нужный бит активирован.
	mov		DL, key_mask[DI+1]		; Рисуем на экране эту клавишу
	mov 	DS:[(160-7)*2][DI], DX
	
	exit:
	ret
key_pixel endp

show_time proc
	pushf							; Заносим в стек текущие флаги
									; ВАЖНО: делать popf не надо, это сделает iret
	call	dword ptr ptr_1C		; Вызываем старое прерывание, которое мы заменили
	
	push 	AX						; Заносим в стек всё то, что мы используем тут
	push 	BX						; Чтобы не поломать всё то, что было в вызвавшей проге
	push 	CX
	push 	DX
	;
	push	DS
	push	DI
	
	mov 	AH, 2					; Команда таймера для получения времени Часы:Мин:Сек в СH, CL, DH
	int		1Ah						; Прерывание таймера
	mov 	BX, 0
	
	; Часы							; Заполняем строку time_str через функцию write_time и СH, CL, DH
	mov		AL, CH
	call	write_time
	add 	BX, 3
	; Минуты
	mov		AL, CL
	call	write_time
	add 	BX, 3
	; Секунды
	mov		AL, DH
	call	write_time
	
	
	mov		AX, 0B800h				; Ставим DS на место 0B800h (адрес видеопамяти)
	mov		DS, AX
	mov		DI, (80-8)*2			; Ставим начальное смещение вывода на 8 (это длина time_str) влево от конца строки 
									; Длина всей строки видеопамяти = 80. 
									; Умножаем на 2, т.к. каждая ячейча видеопамяти занимает 2 байта
	mov		BX, 0
	mov		CX, 8					; Выводим time_str на экран
	time_loop:
		mov 	AH, 00001111b		; b - битовый формат записи числа. 
									; Первые 4 бита - 0000 (чёрный), последние 4 бита - 1111 (белый)
		mov		AL, time_str[BX]	; В качестве символа записываем очередной символ time_str
		mov		DS:[DI], AX			; Помещаем это всё на экран
		add DI, 2					; Смещаемся на 2 байта вперёд (см. строку 87)
		inc BX
	loop time_loop
	
	
	mov AH, 02h						; Считываем в AL коды нажатых служебных клавиш 
	int 16h							; Подробнее https://life-prog.ru/1_47082_prerivanie-int-h.html
	mov CX, 6
	mov DI, 0
	key_loop:
		call key_pixel				; Вывод кодов на экран
		add DI, 2
	loop key_loop
	
	pop		DI
	pop		DS
	;
	pop		DX
	pop		CX
	pop		BX
	pop		AX						; Возвращаем все запомненные регистры на место
	iret							; Выходим из процесса
show_time endp

init: 
	mov ax,3      ; стираем с экрана и устанавливаем текстовый режим 80х25
    int 10h
	
	
	
	mov 	AX, 351Ch				; Получаем в BX, ES 4байтный адрес стандартного прерывания 1C (прерывание таймера)
	int 	21h
	mov		word ptr ptr_1C, BX		; Запомнием этот адрес в ptr_1C
	mov		word ptr ptr_1C + 2, ES
	
	mov     AX,  251Ch
	mov     DX,  offset show_time	; Записываем вместо обычного прерывания 1С наш процесс
	int     21h

	mov     AX,  3100h				; Выходим из проги, оставляем в памяти всё до метки init
	mov     DX, (init - main + 100h) / 10h + 1
	int     21h
CSEG ENDS
END main
