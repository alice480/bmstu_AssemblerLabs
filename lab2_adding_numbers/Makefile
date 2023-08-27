all:
	nasm -f elf64 calculating.asm -l .lst
	ld -o calculating calculating.o

clear:
	rm -f *.o calculating
