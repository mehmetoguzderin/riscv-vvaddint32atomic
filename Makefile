all: main.out main-mt.out

main.out: main.cpp Makefile vvaddint32atomic.s
	./riscv/toolchain/bin/clang++ -std=c++20 -march=rv64gcv vvaddint32atomic.s main.cpp -o main.out
	./riscv/toolchain/bin/spike --isa=rv64gcv -p1 ./riscv/toolchain/riscv64-unknown-elf/bin/pk main.out 5 4 3 2 1

main-mt.out: main-mt.c main-mt.S Makefile vvaddint32atomic.s
	./riscv/toolchain/bin/riscv64-unknown-elf-gcc -march=rv64gcv -mabi=lp64 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -DENTROPY=0x74a5ebf -std=gnu99 -O3 -I./third_party/riscv-tests/env/v -I./third_party/riscv-tests/isa/macros/scalar -T./third_party/riscv-tests/env/v/link.ld ./third_party/riscv-tests/env/v/entry.S ./third_party/riscv-tests/env/v/string.c ./main-mt.S ./main-mt.c ./vvaddint32atomic.s -o main-mt.out
	./riscv/toolchain/bin/spike --isa=rv64gcv -p256 ./main-mt.out
