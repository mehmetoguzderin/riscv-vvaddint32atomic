all: main.out main-mt.out

main.out: main.cpp Makefile vvaddint32atomic.s
	./riscv/toolchain/bin/clang++ -std=c++20 -march=rv64gcv vvaddint32atomic.s main.cpp -o main.out
	./riscv/toolchain/bin/spike --isa=rv64gcv -p1 ./riscv/toolchain/riscv64-unknown-elf/bin/pk main.out 5 4 3 2 1

main-mt.out: main-mt.c Makefile vvaddint32atomic.s
	./riscv/toolchain/bin/riscv64-unknown-elf-gcc -march=rv64gcv -I third_party/riscv-tests/env -I third_party/riscv-tests/benchmarks/common -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O3 -ffast-math -fno-common -fno-builtin-printf -fno-tree-loop-distribute-patterns ./main-mt.c vvaddint32atomic.s third_party/riscv-tests/benchmarks/common/syscalls.c third_party/riscv-tests/benchmarks/common/crt.S -static -nostdlib -nostartfiles -lm -lgcc -T third_party/riscv-tests/benchmarks/common/test.ld -o main-mt.out
	./riscv/toolchain/bin/spike --isa=rv64gcv -p1 ./main-mt.out
