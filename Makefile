ASM=nasm
SRC=src
BUILD=build

# Floppy
floppy: $(BUILD)/floppy.img
$(BUILD)/floppy.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD)/floppy.img bs=512 count=2880
	mkfs.fat -F12 $(BUILD)/floppy.img
	dd if=$(BUILD)/boot.bin of=$(BUILD)/floppy.img conv=notrunc
	mcopy -i $(BUILD)/floppy.img $(BUILD)/kernel.bin "::kernel.bin"

# Bootloader
bootloader: $(BUILD)/boot.bin
$(BUILD)/boot.bin:
	$(ASM) $(SRC)/bootloader/boot.asm -f bin -o $(BUILD)/boot.bin

# Kernel
kernel: $(BUILD)/kernel.bin
$(BUILD)/kernel.bin:
	$(ASM) $(SRC)/kernel/main.asm -f bin -o $(BUILD)/kernel.bin

run:
	qemu-system-x86_64 -fda $(BUILD)/floppy.img

clean:
	rm $(BUILD)/floppy.img $(BUILD)/kernel.bin $(BUILD)/boot.bin