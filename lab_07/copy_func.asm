.686
.MODEL FLAT, C
.STACK
.CODE

copy_str PROC C from:dword, to:dword, len:dword
	pushad
	pushfd

	mov		ESI, from 
	mov		EDI, to

	cmp		EDI, ESI
	ja		reverse
	jmp		classic

	reverse:
		add		ESI, len
		dec		ESI
		add		EDI, len
		dec		EDI
		std

	classic:
		mov		ECX, len
		rep		movsb

	popfd
	popad
	ret
copy_str ENDP
END
