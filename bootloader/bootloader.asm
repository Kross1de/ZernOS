use16

mov ah, 0Eh
mov bx, 03h
mov al, 'h'
int 10h

zavis:
      jmp zavis
