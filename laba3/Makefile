all:
	nasm -f elf64 branching.asm -l .lst
	ld -o branching branching.o

clear:
	rm -f *.asm *.o
