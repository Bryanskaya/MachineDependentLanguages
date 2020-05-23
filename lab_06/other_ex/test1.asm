.286
.model tiny
.code    
org     100h
start:  jmp load
decode  proc
        db 0D4h,10h; ������������� BCD-�����
        add ax,'00'; ���������� ������������� BCD-����� � ASCII-������
        mov word ptr es:[di],0F00h+":"; ��������� - ����������� �����, �����, ������
        mov es:[di+2],ah;������� �� ����� ������ �����
        mov byte ptr es:[di+3],0Fh ;������� ������� (����-����� �� ������ ����)
        mov es:[di+4],al;������� �� ����� ������ �����
        mov byte ptr es:[di+5],0Fh ;������� ������� (����-����� �� ������ ����)
        add di,6
        ret           ; ������� �� ���������
decode  endp          ; ����� ��������� 
clock   proc          ; ��������� ����������� ���������� �� �������
        push es       ; ���������� �������������� ���������
    pusha
        push 0B800h
        pop es
        mov di,-2
    mov al,4
    out 70h,al    
    in al,71h     ; � AL - ����
        call decode
        mov al,2
    out 70h,al
    in al,71h     ; � AL - ������
        call decode
    mov al,0
    out 70h,al
    in al,71h     ; � AL - �������
        call decode
    popa
        pop es        ; �������������� �������������� ���������
        db 0EAh       ; ������ ���� ������� JMP FAR
old_int_1Ch dd ?; ����� ������� ����������� 1Ch ���������� � ������� �� �����������
clock   endp          ; ����� ��������� �����������
load:   mov ax,3      ; ������� � ������ � ������������� ��������� ����� 80�25
    int 10h       ; 0B800h - ������ �������� �����������
    mov ax,351Ch  ; ��������� ������ ������� �����������
        int 21h       ; ���������� �� �������
    mov word ptr old_int_1Ch,bx; ���������� �������� �����������
        mov word ptr old_int_1Ch+2,es; ���������� �������� �����������
        mov ax,251Ch  ; ��������� ������ ������ �����������
        mov dx,offset clock; �������� �������� ������ �����������
        int 21h
        mov ax,3100h  ; ������� DOS ���������� ����������� ���������
        mov dx,(load - start + 10Fh)/16; ����������� ������� ����������� ����� ��������� � ����������
        int 21h
        end start  