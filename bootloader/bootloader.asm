org 0x7C00
use16

macro print msg {
      if ~ msg eq si
            push si
            mov si,msg
            end if
            call print_string
            if ~ msg eq si
                  pop si
                  end if
}

mov si, hello
call panicfunc

zavis:
      jmp zavis

panicfunc:
      print panicPrefix
      print si
      xor ax, ax
      int 16h
      jmp far 0FFFFh:0

;как использовать:
; mov si,какойто кал или строка как тут 'hello'
; call print_string
print_string:
      lodsb     ; загружает si в al (так как DF == 0) si++
      or al, al ; если al == 0
      jz .tyda ; уходем
      mov ah, byte 0Eh  ; устанавливаем INT10,E прерывание 
      mov bx, word 03h 
      int 10h   ; вызываем прерывание
      jmp print_string
.tyda:
      ret

panicPrefix:  db "BOOT PANIC: ",0
hello:   db "privet zagryschik",0
cr:   db 13h,0

pad:      db        510      -      ($      -      $$)      dup 0
bootsig:      db 55h,0AAh
