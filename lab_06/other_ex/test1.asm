.286
.model tiny
.code    
org     100h
start:  jmp load
decode  proc
        db 0D4h,10h; распаковываем BCD-число
        add ax,'00'; превращаем неупакованное BCD-число в ASCII-символ
        mov word ptr es:[di],0F00h+":"; двоеточие - разделитель часов, минут, секунд
        mov es:[di+2],ah;выводим на экран первую цифру
        mov byte ptr es:[di+3],0Fh ;атрибут символа (€рко-белый на черном фоне)
        mov es:[di+4],al;выводим на экран вторую цифру
        mov byte ptr es:[di+5],0Fh ;атрибут символа (€рко-белый на черном фоне)
        add di,6
        ret           ; возврат из процедуры
decode  endp          ; конец процедуры 
clock   proc          ; процедура обработчика прерываний от таймера
        push es       ; сохранение модифицируемых регистров
    pusha
        push 0B800h
        pop es
        mov di,-2
    mov al,4
    out 70h,al    
    in al,71h     ; в AL - часы
        call decode
        mov al,2
    out 70h,al
    in al,71h     ; в AL - минуты
        call decode
    mov al,0
    out 70h,al
    in al,71h     ; в AL - секунды
        call decode
    popa
        pop es        ; восстановление модифицируемых регистров
        db 0EAh       ; начало кода команды JMP FAR
old_int_1Ch dd ?; вызов старого обработчика 1Ch прерываний и возврат из обработчика
clock   endp          ; конец процедуры обработчика
load:   mov ax,3      ; стираем с экрана и устанавливаем текстовый режим 80х25
    int 10h       ; 0B800h - начало сегмента видеобуфера
    mov ax,351Ch  ; получение адреса старого обработчика
        int 21h       ; прерываний от таймера
    mov word ptr old_int_1Ch,bx; сохранение смещени€ обработчика
        mov word ptr old_int_1Ch+2,es; сохранение сегмента обработчика
        mov ax,251Ch  ; установка адреса нашего обработчика
        mov dx,offset clock; указание смещени€ нашего обработчика
        int 21h
        mov ax,3100h  ; функци€ DOS завершени€ резидентной программы
        mov dx,(load - start + 10Fh)/16; определение размера резидентной части программы в параграфах
        int 21h
        end start  