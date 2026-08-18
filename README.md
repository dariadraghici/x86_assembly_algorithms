# x86 Assembly Algorithms: Sorting, String Operations, Recursion and Backtracking

This repository contains four standalone x86 (32 bit, NASM syntax) assembly routines that implement classic algorithmic problems using low level stack management, manual pointer arithmetic, and direct interaction with the C standard library through the `cdecl` calling convention. Each routine is written to be called from C code, receiving its arguments through the stack and returning results in `eax`.

## Overview

The project is organized as four independent exercises, each solved entirely in x86 assembly and designed to be linked against a C driver program that provides input data and validates the output. The routines cover:

* Reconstructing an ordered singly linked list from an unordered array of nodes
* Tokenizing a string into words and sorting them with a custom comparator through the C library `qsort`
* Computing a generalized Fibonacci sequence with a configurable number of preceding terms
* Enumerating subsets of strings to find the longest, lexicographically smallest palindrome obtainable by concatenation

All four files follow the same low level conventions: explicit stack frame setup with `push ebp` / `mov ebp, esp` or the `enter` instruction, callee saved register preservation for `ebx`, `esi`, and `edi`, and manual cleanup of the stack after each call to an external function.

## Technical Environment

* Architecture: x86, 32 bit (IA-32)
* Assembler syntax: NASM
* Calling convention: cdecl (arguments pushed right to left, caller cleans the stack, return value in `eax`)
* External dependencies: the C standard library functions `qsort`, `strcmp`, `malloc`, and `free`
* Register usage: `eax`, `ebx`, `ecx`, `edx` as general purpose and accumulator registers; `esi` and `edi` for pointer traversal; `ebp` and `esp` for stack frame management

## Project Structure

```
sortari.asm                  Task 1: linked list reconstruction (selection sort by value)
operatii.asm                 Task 2: word tokenization and qsort based sorting
kfib.asm                     Task 3: recursive K step Fibonacci sequence
composite_palindrome.asm     Task 4: palindrome check and subset based composite palindrome search
```

## Task 1: Linked List Sorting

**File:** `sortari.asm`
**Exported symbol:** `sort`
**Signature:** `struct node* sort(int n, struct node* node)`

### Problem

The input is an array of `n` nodes, each represented as an 8 byte structure containing an integer value and a next pointer (`{ int val; struct node* next; }`). The values are guaranteed to form a permutation of `1..n`, but the nodes are not stored in value order within the array. The function must return a pointer to the head of a singly linked list in which the nodes are chained in increasing order of their value field, without allocating any new memory.

### Approach

The algorithm performs a selection style search directly on the array:

1. An outer counter (`ecx`) iterates over every target value from 1 to n.
2. For each target value, the array is scanned linearly (inner loop, `for_i`) until the node whose `val` field equals the current target is located.
3. When the correct node is found, it is appended to the result list. The first node found (target value 1) is stored separately as the head of the list and kept as a running pointer to the previous node (`ebx`).
4. Every subsequent node found is linked by writing its address into the `next` field (offset `+4`) of the previously linked node.
5. Once all n values have been located and linked, the `next` field of the final node is explicitly set to null to terminate the list.
6. The address of the head node is returned in `eax`.

This is effectively an O(n squared) selection sort adapted to build a linked structure in place, since the array itself is never physically reordered. Each node's position in the output list is determined purely by rewriting the `next` pointers, and the node storage itself is reused rather than copied.

## Task 2: Word Extraction and Sorting

**File:** `operatii.asm`
**Exported symbols:** `sort`, `get_words`
**Internal helper:** `comparator`, `verifica_delimitator`

### Problem

Given a raw input string, split it into individual words separated by spaces, commas, periods, or newlines, then sort the resulting words first by length and, for words of equal length, lexicographically.

### `get_words(char *s, char **words, int number_of_words)`

This routine performs in place tokenization of the source string:

* It walks the string character by character using `esi` as the read cursor.
* Each time a new word begins, its starting address is stored in the `words` output array.
* The routine scans forward until it encounters a delimiter (space, comma, period, or newline) or the string terminator, then overwrites the delimiter byte with a null terminator, effectively splitting the original buffer in place without allocating additional memory.
* Consecutive delimiters are skipped in a dedicated loop (`.skip_delimiters`) so that empty tokens are never produced.
* The function returns the number of words actually found in `eax`.

The delimiter check is factored into a small helper routine, `verifica_delimitator`, which compares the character in `al` against the four recognized delimiters and returns via the zero flag, allowing the caller to branch on `je` / `jne` immediately after the call.

### `sort(char **words, int number_of_words, int size)`

Rather than reimplementing a sorting algorithm from scratch, this function delegates to the C standard library `qsort`, following the standard cdecl argument pushing order (arguments pushed right to left: comparator, size, count, base pointer). This demonstrates direct interoperation between hand written assembly and the C runtime.

### `comparator(const void *a, const void *b)`

The comparator implements the ordering rule required by the sort:

1. It dereferences both `void*` parameters (which point to `char*` entries inside the `words` array) to obtain the two word pointers.
2. It computes the length of each word independently by scanning for the null terminator.
3. If the lengths differ, the shorter word is ordered first (returns -1 or 1 accordingly).
4. If the lengths are equal, the comparator falls back to `strcmp` to obtain standard lexicographic ordering.

This mirrors a typical two key comparator pattern (primary key: length, secondary key: lexicographic order) implemented directly at the register level.

## Task 3: K Step Fibonacci

**File:** `kfib.asm`
**Exported symbol:** `kfib`
**Signature:** `int kfib(int n, int K)`

### Problem

Compute a generalized Fibonacci style sequence where, instead of always summing the previous two terms, each term is the sum of the K immediately preceding terms:

* `kfib(n, K) = 0` for `n < K`
* `kfib(n, K) = 1` for `n == K`
* `kfib(n, K) = sum of kfib(n - i, K) for i = 1 .. K` for `n > K`

### Approach

The function is implemented as a direct recursive translation of the mathematical definition:

* The base cases (`n < K` and `n == K`) are handled immediately by comparing `eax` (holding n) against `edx` (holding K).
* In the general case, a loop iterates `i` from 1 to K. On each iteration it computes `n - i`, pushes the two arguments `(n - i, K)` onto the stack in cdecl order, and issues a recursive `call kfib`.
* Each recursive result is accumulated into `ebx`, which acts as the running sum across the K recursive calls.
* After every call the stack is cleaned up with `add esp, 8`, matching the two pushed dword arguments.
* The accumulated sum is moved into `eax` before returning.

Because the routine calls itself recursively, it relies on a fully self contained stack frame (`enter 0, 0` and callee saved `ebx`, `esi`, `edi`) so that each active call maintains its own independent copies of `n`, `K`, the loop index, and the running sum, correctly supporting the exponential recursion tree inherent to this definition.

## Task 4: Composite Palindrome

**File:** `composite_palindrome.asm`
**Exported symbols:** `check_palindrome`, `composite_palindrome`

### Subtask 1: `check_palindrome(char *str, int len)`

A straightforward two pointer palindrome check:

* One pointer (`edi`) starts at the beginning of the string, the other (`edx`) starts at the last character (computed as `str + len - 1`).
* The loop compares the characters at both pointers, advancing `edi` forward and `edx` backward on each iteration.
* If a mismatch is found the function returns 0 immediately; if the pointers meet or cross without a mismatch, the string is a palindrome and the function returns 1.
* Strings of length 0 or 1 are treated as palindromes by definition and short circuit before the comparison loop.

### Subtask 2: `composite_palindrome(char **strings, int count)`

Given an array of `count` strings, the goal is to find the longest palindrome that can be formed by concatenating some subset of those strings, in their original order, and to return the lexicographically smallest such palindrome when multiple subsets of the maximal length exist.

The algorithm performs an exhaustive search over the power set of the input strings using bitmask enumeration:

1. **Subset enumeration.** A mask (`ebx`) is incremented from 1 to `2^count - 1`, so that every non empty subset of the `count` strings is visited exactly once. Bit `i` of the mask indicates whether string `i` participates in the current subset.

2. **Length precomputation.** For each mask, the routine first computes the total length of the concatenation that the subset would produce, without yet allocating or building it, by summing the lengths of all strings whose corresponding bit is set. This total is compared against the best length found so far (stored at `[ebp - 8]`); if it is smaller, the entire candidate is skipped immediately, avoiding unnecessary allocation and string work for subsets that could not possibly improve on the current best.

3. **Concatenation.** If the subset's total length is competitive, memory is allocated with `malloc` for the concatenated string plus a null terminator. The routine then iterates over the mask a second time, appending every selected string to the newly allocated buffer through manual byte by byte copying.

4. **Palindrome test and comparison.** The freshly built candidate string is passed to `check_palindrome`. If it is a palindrome, its length is compared against the best result so far:
   * If it is strictly longer, it immediately becomes the new best answer.
   * If it has equal length, `strcmp` is used to decide whether the new candidate is lexicographically smaller than the current best; if so, it replaces it.
   * If the candidate is not competitive, or is not a palindrome at all, its memory is freed immediately to avoid leaking the temporary allocation.

5. **Memory management.** Whenever a new candidate replaces the previous best, the previous best string's memory is released with `free` before the pointer is overwritten, ensuring that only one best so far allocation is alive at any point during the search.

6. **Fallback case.** If no subset produces a palindrome at all, the function allocates and returns an empty string (a single null byte) rather than a null pointer, guaranteeing a well defined, always freeable result.

This is a brute force combinatorial search with complexity proportional to `2^count` multiplied by the average cost of length computation, concatenation, and palindrome verification, which is acceptable given the small expected bound on `count`. The design deliberately checks the length bound before performing any allocation or string construction work, which prunes a significant fraction of unproductive subsets early.

## Calling Convention and Stack Discipline

All four files respect the cdecl convention used by the C driver programs that invoke them:

* Arguments are read from positive offsets relative to `ebp` (`[ebp + 8]`, `[ebp + 12]`, and so on), consistent with the caller having pushed them in reverse order before the `call` instruction.
* Every function preserves `ebx`, `esi`, and `edi` by pushing them on entry and popping them in reverse order before returning, since these registers are callee saved under cdecl.
* Local variables that do not fit in registers are placed below `ebp` on the stack (for example `[ebp - 4]`, `[ebp - 8]` in `sortari.asm` and `composite_palindrome.asm`), with `esp` adjusted accordingly via explicit `sub esp, N` or the `enter N, 0` instruction.
* After every call to an external function (`qsort`, `strcmp`, `malloc`, `free`, or a recursive call to `kfib`), the caller restores the stack pointer with an explicit `add esp, N` matching the total size of the pushed arguments, since cdecl places stack cleanup responsibility on the caller.
* Return values are consistently placed in `eax` before the epilogue (`leave` or the manual `mov esp, ebp` / `pop ebp` sequence) and the final `ret`.

## Build and Test

These files are designed to be assembled with NASM and linked against a C test harness that supplies the driver `main` function, sample inputs, and expected outputs.

Typical assembly and linking commands:

```
nasm -f elf32 sortari.asm -o sortari.o
nasm -f elf32 operatii.asm -o operatii.o
nasm -f elf32 kfib.asm -o kfib.o
nasm -f elf32 composite_palindrome.asm -o composite_palindrome.o
gcc -m32 main.c sortari.o operatii.o kfib.o composite_palindrome.o -o test_binary
```

Adjust object file names and the driver source according to the actual test harness used for grading.
