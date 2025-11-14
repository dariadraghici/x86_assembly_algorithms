CC = gcc
CFLAGS = -Wall -Wextra -O2
TARGET = task1

INPUT_DIR = in
OUTPUT_DIR = out

INPUTS = $(wildcard $(INPUT_DIR)/sortari-0*.in)
OUTPUTS = $(patsubst $(INPUT_DIR)/sortari-0%.in,$(OUTPUT_DIR)/sortari-0%.out,$(INPUTS))

all: $(TARGET)

$(TARGET): task1.c
	$(CC) $(CFLAGS) -o $(TARGET) task1.c

# Rule to process all input files
run: all $(OUTPUTS)

# Rule to produce each output file from corresponding input file
$(OUTPUT_DIR)/sortari-0%.out: $(INPUT_DIR)/sortari-0%.in
	@mkdir -p $(OUTPUT_DIR)
	./$(TARGET) < $< > $@

clean:
	rm -f $(TARGET) $(OUTPUT_DIR)/sortari-0*.out