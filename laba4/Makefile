all:
	nasm -f elf64 matrix.asm -l .lst
	ld -o matrix matrix.o

clear:
	rm -f *.o matrix
