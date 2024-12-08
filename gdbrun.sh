#!/bin/bash
nasm -f elf -o calculator.o calculator.asm
ld -m elf_i386 -o calc calculator.o
gdb calc