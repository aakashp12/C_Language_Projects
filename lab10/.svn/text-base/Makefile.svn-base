CC=gcc
CFLAGS=-g -Wall -std=c99 -m32 -lm

all: records

records: 
	$(CC) $(CFLAGS) -o records fileio.c
	
clean:
	rm -f fileio.o records
