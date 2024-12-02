COMPILER = gcc
CFLAGS = -Wall -pedantic -std=c99 -g

MEMTESTER = valgrind
MEMFLAGS = --leak-check=full --show-leak-kinds=all

bin/main: ./src/main.c ./src/refmem.h ./src/refmem.c | ./bin/
	$(COMPILER) $(CFLAGS) -o ./bin/main ./src/main.c ./src/refmem.c

memtest: ./bin/main
	$(MEMTESTER) $(MEMFLAGS) ./bin/main

cache_test: ./bin/main
	valgrind --tool=cachegrind ./bin/main

memory_usage_test: ./bin/main
	valgrind --tool=massif ./bin/main

profile: ./bin/main
	valgrind --tool=callgrind ./bin/main

.DEFAULT_GOAL := run
run: ./bin/main
	./bin/main

%/:
	mkdir -p $@

clean:
	rm -rf bin
	rm -rf cachegrind.out.*
	rm -rf massif.out.*
	rm -rf callgrind.out.*
