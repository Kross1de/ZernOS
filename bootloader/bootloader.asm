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

.start:
      mov byte [bootdrv], dl
      cmp dl, byte 080h
      jl .notHDD
.hddFND:
;AH       41h = номер функции для проверки расширениях[8];
;DL       индекс диска
;BX       55AAh
      mov ah, byte 41h 
      mov bx, word 55AAh
      int 13h
;CF       установить при отсутствии, отчистить при наличии
;BX       AA55h
;CX       bit1: доступ к устройству с использованием структуры пакета
      jc .notLBA
      cmp bx,0AA55h
      jne .notLBA
      test cl, byte 1 
      jnz .LBAok
.notLBA:
      mov si, lbaNotFound
      jmp panicfunc
.notHDD:
      mov si, notHDD
      jmp panicfunc
.LBAok:
       

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

; переменные
bootdrv      db 0

; сообщения ошибок
panicPrefix:  db "BOOT PANIC: ",0
lbaNotFound:  db "Hard drive doesnt support LBA packet struct",0 
notHDD    db "Not a valid harddrive",0

; пад и сигнатура для биоса
pad:      db        510      -      ($      -      $$)      dup 0
bootsig:      db 55h,0AAh
