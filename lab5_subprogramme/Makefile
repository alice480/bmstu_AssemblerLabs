all: nasm
	g++ -no-pie processing.o lab5.cpp -o result

nasm:
	nasm -f elf64 processing.asm -l .lst

asembler:
	nasm -f elf64 processing.asm -l .lst
	ld -o processing processing.o

cpp:
	g++ -o lab5.o lab5.cpp

clear:
	rm -f *.o part_* processing result
	
dump:
	objdump -D result
