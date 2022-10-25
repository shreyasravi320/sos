; BIOS puts OS at address 0x7c00
org 0x7c00

; any 64-bit cpu needs to be backwards compatible on 16-bit arch
; bits 16 tells the assembler to emit 16-bit code
bits 16


; Macros
%define nl 0x0d, 0x0a

start:
    jmp main


; dump
; print text to the screen
; uses ds:si which points to a string
;
dump:
    ; save regs
    push si
    push ax
    push bx

.loop:
    ; lodsb, lodsw, and lodsd load a byte, word, or double from ds:si to 
    ; al, ax, or eax, then increments si
    lodsb
    or al, al
    jz  .done

    ; print a character
    mov ah, 0x0e        ; 0e is the flag for writing a character from al in TTY mode
    mov bh, 0           ; set page # to 0
    int 0x10            ; interrupt code 10 handles string/char output

    jmp .loop

.done:
    pop bx
    pop ax
    pop si
    ret


main:
    ; setup data segments
    mov ax, 0
    mov ds, ax
    mov es, ax

    ; stack setup
    mov ss, ax
    mov sp, 0x7c00

    ; print greeting
    mov si, greeting
    call dump

    hlt

.halt:
    jmp .halt


greeting: db 'Welcome to SOS!', nl, 0

; allocate 512 bytes of memory (510 bytes + 2 bytes of the 0xaa55 signature)
; $ - $$ gets the difference in bytes from the current line to the start
; of the program
times 510 - ($ - $$) db 0
dw 0xaa55