CC=gcc
CFLAGS=-g -Wall 

all: part2

part2: main.o ppmio.o image.o
	$(CC) $(CFLAGS) main.o ppmio.o image.o -o part2

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

ppmio.o: ppmio.c
	$(CC) $(CFLAGS) -c ppmio.c

image.o: image.c
	$(CC) $(CFLAGS) -c image.c

clean:
	rm -f *.o part2

