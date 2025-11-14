CC = gcc
CFLAGS = -Wall -Wextra -O2
TARGET = task3

INPUT_DIR = in
OUTPUT_DIR = out

INPUTS = $(wildcard $(INPUT_DIR)/kfib-*.in)
OUTPUTS = $(patsubst $(INPUT_DIR)/kfib-%.in,$(OUTPUT_DIR)/kfib-%.out,$(INPUTS))

all: $(TARGET)

$(TARGET): task3.c
	$(CC) $(CFLAGS) -o $(TARGET) task3.c

run: all $(OUTPUTS)

$(OUTPUT_DIR)/kfib-%.out: $(INPUT_DIR)/kfib-%.in
	@mkdir -p $(OUTPUT_DIR)
	./$(TARGET) < $< > $@

clean:
	rm -f $(TARGET) $(OUTPUT_DIR)/kfib-*.out