#
# Makefile for intermezzos.
#
# Current targets:
# make (just builds)
# make run (builds and runs)
# make clean
#
default: build

.PHONY: clean

build: build/os.iso

run: build/os.iso
	qemu-system-x86_64 -cdrom build/os.iso

build/os.iso: build/kernel.bin grub.cfg
	mkdir -p build/isofiles/boot/grub
	cp grub.cfg build/isofiles/boot/grub
	cp build/kernel.bin build/isofiles/boot
	grub-mkrescue -o build/os.iso build/isofiles

build/multiboot_header.o: multiboot_header.asm
	mkdir -p build
	nasm -f elf64 multiboot_header.asm -o build/multiboot_header.o

build/boot.o: boot.asm
	mkdir -p build
	nasm -f elf64 boot.asm -o build/boot.o

build/kernel.bin: build/multiboot_header.o build/boot.o linker.ld
	ld -n -o build/kernel.bin -T linker.ld build/multiboot_header.o build/boot.o

clean:
	rm -rf build

