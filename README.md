# SOS

## An attempt at writing an operating system. Everything I learn will be documented below

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