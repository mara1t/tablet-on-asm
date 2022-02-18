.model tiny
.code
org 100h

;-----------------------------------------

VIDEOSEG equ 0b800h


;-----------------------------------------

.getch		macro
			nop

			mov ah, 00h
			int 16h
			nop
			endm

;-----------------------------------------

start:		mov ax, VIDEOSEG
			mov es, ax

			mov di, 82h
			mov bh, [di]
			sub bh, 30h

			;mov ah, 02h
			;mov dl, bh
			;int 21h

			mov ah, bh
			cmp ah, 1
			je one
			
			cmp	ah, 2
			je two

			jmp close_proj

one:
			mov di, offset first_symb
			call tablet_print
			jmp close_proj

two:
			mov di, offset second_symb
			call tablet_print
			jmp close_proj

			
close_proj:
			mov ax, 4c00h
			int 21h


;--------------------------------------------------
;
;es = 0b800h (viedo segment)
;bx = beginning of tablet(left high corner)
;dx = str which contains sembols for tablet
;
;--------------------------------------------------

tablet_print:

			mov bx, VIDEOSEG
			mov es, bx
			mov bx, (4*80d+20d)*2
			mov dl, [di]
			mov byte ptr es:[bx], dl
			add bx, 2
			mov cx, 16d

horizontal:
			mov dl, [di + 4]
			mov byte ptr es:[bx], dl
			mov byte ptr es:[bx + 22 * 80d], dl
			add bx, 2
			loop horizontal


			mov dl, [di + 1]
			mov byte ptr es:[bx], dl
			mov bx, (5*80d+20d)*2
			mov cx, 10d

vertical:		
			mov dl, [di + 5]
			mov byte ptr es:[bx], dl
			mov byte ptr es:[bx + 2 * 17d], dl
			add bx, 160d
			loop vertical 

			mov dl, [di + 2]
			mov byte ptr es:[bx], dl
			mov dl, [di + 3]
			mov byte ptr es:[bx + 2 * 17d], dl
			
			ret
			endp

.data

first_symb		db 0dah, 0bfh, 0c0h, 0d9h, 0c4h, 0b3h
second_symb 	db 0c9h, 0bbh, 0c8h, 0bch, 0cdh, 0bah

			
end start
