; BIOS puts OS at address 0x7c00
org 0x7c00

; any 64-bit cpu needs to be backwards compatible on 16-bit arch
; bits 16 tells the assembler to emit 16-bit code
bits 16

; Macros
%define nl 0x0d, 0x0a


; FAT12 headers: reference BPB table @ https://wiki.osdev.org/FAT 
jmp short start
nop

bpb_oem:                    db 'MSWIN4.1'
bpb_bytes_per_sector:       dw 0x0200
bpb_sectors_per_cluster:    db 1
bpb_reserved_sectors:       dw 1 
bpb_fat_count:              db 2
bpb_dir_entries_count:      dw 0xe0
bpb_total_sectors:          dw 2880         ; 2880 sectors * 512 bytes = 1.44 MiB
bpb_media_descriptor_type:  db 0xf0         ; 0xf0 = 3.5 inch floppy
bpb_sectors_per_fat:        dw 9
bpb_sectors_per_track:      dw 18
bpb_heads:                  dw 2
bpb_hidden_sectors:         dd 0
bpb_large_sector_count:     dd 0

; EBR headers: reference EBR table @ https://wiki.osdev.org/FAT
ebr_drive_number:           db 0            ; 0x00 for floppy, 0x80 for hdd
                            db 0            ; reserved
ebr_signature:              db 0x29
ebr_volume_id:              db 0xef, 0xbe, 0xad, 0xde 
ebr_volume_label:           db 'shreyasravi'
ebr_system_id:              db 'FAT12   '

; end of headers
; start of code

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


greeting: db "Welcome to SOS!", nl, 0

; allocate 512 bytes of memory (510 bytes + 2 bytes of the 0xaa55 signature)
; $ - $$ gets the difference in bytes from the current line to the start
; of the program
times 510 - ($ - $$) db 0
dw 0xaa55