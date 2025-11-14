CC = gcc
CFLAGS = -Wall -Wextra -O2
TARGET = task2

INPUT_DIR = in
OUTPUT_DIR = out

INPUTS = $(wildcard $(INPUT_DIR)/operatii-0*.in)
OUTPUTS = $(patsubst $(INPUT_DIR)/operatii-0%.in,$(OUTPUT_DIR)/operatii-0%.out,$(INPUTS))

all: $(TARGET)

$(TARGET): task2.c
	$(CC) $(CFLAGS) -o $(TARGET) task2.c

run: all $(OUTPUTS)

$(OUTPUT_DIR)/operatii-0%.out: $(INPUT_DIR)/operatii-0%.in
	@mkdir -p $(OUTPUT_DIR)
	./$(TARGET) < $< > $@

clean:
	rm -f $(TARGET) $(OUTPUT_DIR)/operatii-0*.out