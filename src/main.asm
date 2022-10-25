;; BIOS puts OS at address 0x7c00
org 0x7c00

;; any 64-bit cpu needs to be backwards compatible on 16-bit arch
;; bits 16 tells the assembler to emit 16-bit code
bits 16

main:
    hlt

.halt:
    jmp .halt

;; allocate 512 bytes of memory (510 bytes + 2 bytes of the 0xaa55 signature)
;; $ - $$ gets the difference in bytes from the current line to the start
;; of the program
times 510 - ($ - $$) db 0
dw 0aa55h