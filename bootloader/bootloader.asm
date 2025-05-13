org 0x7C00
use16

lbaPacket equ 07E00h
virtual at lbaPacket
lbaPacket.size              : dw              ?
lbaPacket.count             : dw              ?
lbaPacket.offset            : dw              ?
lbaPacket.segment           : dw              ? 
lbaPacket.sector0           : dw              ?
lbaPacket.sector1           : dw              ?
lbaPacket.sector2           : dw              ?
lbaPacket.sector3           : dw              ?
end virtual

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

; конец стека: 0x500
; sp, bp: 0x600

.start:
      cli
      cld
      xor ax, ax
      mov ss, ax 
      mov es, ax
      mov sp, 600h 
      mov bp, 600h
      push cs
      pop ds

.checkDisk:
      mov byte [bootdrv], dl
      cmp dl, byte 080h
      jl .notHDD
.hddFND:
      mov ah, byte 41h 
      mov bx, word 55AAh
      int 13h
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
       mov word [lbaPacket.size], 16
       mov word [lbaPacket.count], 1 
       mov word [lbaPacket.segment], 80h ;0x80:0x00 -> 0x800
       mov word [lbaPacket.offset], 0 
       mov word [lbaPacket.sector0], 0
       mov word [lbaPacket.sector1], 2
       mov word [lbaPacket.sector2], 0 
       mov word [lbaPacket.sector3], 0
       mov ah, 42h 
       mov si, lbaPacket
       int 13h 
       jnc .readERR
.readERR:
      mov si, sectorReadError
      jmp panicfunc
.readSuccess:
      mov bx, [magicBytes]
      mov cx, word [800h] 
      cmp cx, bx
      jne .badMagic
      mov ax, 802h
      jmp ax
.badMagic:
      mov si, notValidMagic
      jmp panicfunc

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
bootdrv:      db 0
magicBytes:  db 0F4h, 1Ch
stage_2_start:    dd 0xFFFFFFFF

; сообщения ошибок
panicPrefix:  db "BOOT PANIC: ",0
lbaNotFound:  db "Hard drive doesnt support LBA packet struct",0 
notHDD    db "Not a valid harddrive",0 
sectorReadError db "Couldn't read sector from drive",0
notValidMagic db "Sector doesnt start with the expected magic bytes",0

; пад и сигнатура для биоса
pad:      db        510      -      ($      -      $$)      dup 0
bootsig:      db 55h,0AAh

