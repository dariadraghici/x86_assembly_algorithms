CC = gcc
CFLAGS = -Wall -Wextra -O2
TARGET = task4

INPUT_DIR = in
OUTPUT_DIR = out

INPUTS = $(wildcard $(INPUT_DIR)/check_palindrome-*.in) \
         $(wildcard $(INPUT_DIR)/composite_palindrome-*.in)

OUTPUTS = $(patsubst $(INPUT_DIR)/%.in,$(OUTPUT_DIR)/%.out,$(INPUTS))

.PHONY: all run clean

all: $(TARGET)

$(TARGET): task4.c
	@$(CC) $(CFLAGS) -o $(TARGET) task4.c
	@chmod +x $(TARGET) # Asigura permisiuni de executare

run: all $(OUTPUTS)

$(OUTPUT_DIR)/%.out: $(INPUT_DIR)/%.in
	@mkdir -p $(OUTPUT_DIR)
	@./$(TARGET) < $< > $@

clean:
	@rm -f $(TARGET)
	@rm -f $(OUTPUT_DIR)/check_palindrome-*.out \
	       $(OUTPUT_DIR)/composite_palindrome-*.out
