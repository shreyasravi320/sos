# SOS

## An attempt at writing a 64-bit operating system. Everything I learn will be documented below

### Computer Startup Phase
BIOS
1. Loaded from ROM to RAM
2. Executes code
3. Searches for an OS
4. Loads and runs OS when found

### Legacy booting vs EFI
In Legacy booting, the BIOS loads each device's first sector of memory and 
searches for an 0xAA55 signature
If/when it finds the signature, it starts running code

In EFI, the BIOS looks at special EFI partitions, so the OS needs to be 
compiled as an EFI program. This seems more complicated so we'll stick with
legacy booting

### Reference memory

Memory segmentation is of the form `segment:offset`, where both `segment` and
`offset` are 16-bit values. Memory is segmented in the following pattern:

```
0     16    32
--------------------------------------
|          Segment                   |
|            #1                      |
--------------------------------------
      --------------------------------------
      |           Segment                  |
      |             #2                     |
      --------------------------------------
            --------------------------------------
            |            Segment                 |
            |              #3                    |
            --------------------------------------
```

So the real address can be computed by `segment * 16 + offset`. There are
also multiple ways of writing the same real address, as
`0x0000:0x5555 == 0x1000:0x1555`

### Registers for segments
CS = current code segment
DS = data segment
SS = stack segment
ES, FS, GS = extra segments

