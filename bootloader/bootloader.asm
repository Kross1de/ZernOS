use16

mov ah, 0Eh
mov bx, 03h
mov al, 'h'
int 10h
mov al, 'e'
int 10h
mov al, 'l'
int 10h
int 10h
mov al, 'o'
int 10h
zavis:
      jmp zavis

pad:      db        510      -      ($      -      $$)      dup 0
bootsig:      db 55h,0AAh
