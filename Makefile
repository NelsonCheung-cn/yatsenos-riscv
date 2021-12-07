VPATH = driver include kernel

PREFIX = riscv64-unknown-linux-gnu
CXX = $(PREFIX)-g++
INCLUDE = include
CXX_FLAGS = -c -g -Wall -nostdlib -O0 -I$(INCLUDE) -fno-builtin -ffreestanding -fno-pic -mcmodel=medany


AS = $(PREFIX)-as
LD = $(PREFIX)-ld

TARGET = kernel.elf
OBJ = start.o
OBJ += driver.o uart.o init.o asm_utils.o interrupt.o clint.o timer.o utils.o

$(TARGET) : $(OBJ)
	$(LD) $^ -Ttext 0x80000000 -e _start -o $@
	# $(LD) $^ -T kernel.ld -e _start -o $@

utils.o: utils.cpp utils.h
	$(CXX) $(CXX_FLAGS) $< -o $@
	
timer.o: timer.cpp timer.h
	$(CXX) $(CXX_FLAGS) $< -o $@

clint.o: clint.cpp clint.h
	$(CXX) $(CXX_FLAGS) $< -o $@

interrupt.o: interrupt.cpp interrupt.h
	$(CXX) $(CXX_FLAGS) $< -o $@

asm_utils.o: asm_utils.s
	$(AS) -g $< -o $@

driver.o : driver.cpp driver.h
	$(CXX) $(CXX_FLAGS) $< -o $@

uart.o : uart.cpp uart.h
	$(CXX) $(CXX_FLAGS) $< -o $@

init.o : init.cpp
	$(CXX) $(CXX_FLAGS) $< -o $@

start.o : start.s 
	$(AS) -g $< -o $@

debug : $(TARGET)
	qemu-system-riscv64 -machine virt -kernel $(TARGET) -bios none -nographic -s -S

run : $(TARGET)
	qemu-system-riscv64 -machine virt -kernel $(TARGET) -bios none -nographic

clean :
	rm -fr *.o *.elf