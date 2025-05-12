org 0x7C00
use16

start:
      mov si, hello
      call print
      mov si, cr
      call print
      jmp start

zavis:
      jmp zavis

;как использовать:
; mov si,какойто кал или строка как тут 'hello'
; call print
print:
      lodsb     ; загружает si в al (так как DF == 0) si++
      or al, al ; если al == 0
      jz .tyda ; уходем
      mov ah, byte 0Eh  ; устанавливаем INT10,E прерывание 
      mov bx, word 03h 
      int 10h   ; вызываем прерывание
      jmp print
.tyda:
      ret

hello:   db "privet zagryschik",0
cr:   db 13h,0

pad:      db        510      -      ($      -      $$)      dup 0
bootsig:      db 55h,0AAh
