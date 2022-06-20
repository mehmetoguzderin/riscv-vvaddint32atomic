all: a.out

a.out: main.cpp Makefile vvaddint32atomic.s
	./riscv/toolchain/bin/clang++ -std=c++20 -march=rv64gcv vvaddint32atomic.s main.cpp -o main.out
	./riscv/toolchain/bin/spike --isa=rv64gcv -p1 ./riscv/toolchain/riscv64-unknown-elf/bin/pk main.out 5 4 3 2 1