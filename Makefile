#   make elf   - скомпилировать Си-версию в build/lab1.elf
#   make dump  - получить дамп-файл build/lab1.dump
#   make all   - elf + dump
#   make host  - собрать и запустить Си-версию
#   make clean - удалить результаты сборки
TOOLCHAIN ?= $(HOME)/riscv-tools/riscv32-unknown-elf/bin
CC        := $(TOOLCHAIN)/riscv32-unknown-elf-gcc
OBJDUMP   := $(TOOLCHAIN)/riscv32-unknown-elf-objdump
HOSTCC    := cc

MARCH     := rv32i
MABI      := ilp32

CFLAGS    := -march=$(MARCH) -mabi=$(MABI) -O0
SRC_C     := src/main.c
ELF       := build/lab1.elf
DUMP      := build/lab1.dump

.PHONY: all elf dump host clean

all: elf dump

elf: $(ELF)

$(ELF): $(SRC_C) | build
	$(CC) $(CFLAGS) $(SRC_C) -o $@
	@$(OBJDUMP) -f $@ | sed -n '3p'

dump: $(DUMP)

$(DUMP): $(ELF)
	$(OBJDUMP) -D $(ELF) > $@
	@echo "дамп-файл готов: $@"

host: | build
	$(HOSTCC) -O0 $(SRC_C) -o build/lab1_host
	@./build/lab1_host | tee build/host_output.txt

build:
	mkdir -p build

clean:
	rm -rf build
