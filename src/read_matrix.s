.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    ebreak
    # Prologue of read_matrix
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)    # s0 is used for file descriptor
    sw s1, 8(sp)    # s1 is used for the pointer to the buffer that malloc yields
    sw s2, 12(sp)   # The number of bytes to read from the file.
    # end of prologue

    # 1. Open the file with read permissions.
    
    # prologue of fopen
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    # end of prologue
    # call fopen
    li a1, 0        # Permission bits. 0 for read-only
    jal fopen
        # check error
    li t0, -1
    beq a0, t0, fopenError
        # save result
    mv s0, a0
    # epilogue of fopen
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    ebreak
    # 2. Read the number of rows and columns from the file
    
    # prologue of malloc
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    # call malloc
    li a0, 8
    jal malloc
        # check error
    beq a0, x0, mallocError
        # save result
    add s1, a0, x0
    # epilogue of malloc
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    # prologue of fread
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)    
    sw a1, 8(sp)    
    sw a2, 12(sp)   
    # call fread
    add a0, s0, x0  # The file descriptor of the file we want to read from, previously returned by fopen.
    add a1, s1, x0  # A pointer to the buffer where the read bytes will be stored. 
    li a2, 8        # The number of bytes to read from the file.
    jal fread
        # check error
    li a2, 8
    bne a0, a2, freadError  # If a0 differs from the argument provided in a2, then we should raise an error.
    # epilogue of fread
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    ebreak
    lw t0, 0(s1)
    sw t0, 0(a1)
    lw t1, 4(s1)
    sw t1, 0(a2)
        # caculate the the number of bytes to read from the file.
    mul t0, t0, t1
    slli s2, t0, 2

    ebreak
    # 3. Allocate space on the heap to store the matrix.
    # prologue of malloc
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    # call malloc
    add a0, s2, x0
    jal malloc
        # check error
    beq a0, x0, mallocError
        # save result
    add s1, a0, x0
    # epilogue of malloc
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    ebreak
    # question: should i read the col and row again? —— NO
    # 4. Read the matrix from the file to the memory allocated in the previous step. 
    # prologue of fread
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)

    # call fread
    add a0, s0, x0
    add a1, s1, x0
    add a2, s2, x0
    jal fread
        # check error
    mv a2, s2
    bne a0, a2, freadError
    
    # epilogue of fread
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    ebreak
    # 5. Close the file.
    # prologue of fclose
    addi sp, sp, -8
    sw ra, 0(sp)
    sw a0, 4(sp)

    # call fclose
    add a0, s0, x0
    jal fclose
        # check error
    bne a0, x0, fcloseError
    
    # epilogue of fclose
    lw ra, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8


    mv a0, s1
    # Epilogue of read_matrix
    lw ra, 0(sp)
    lw s0, 4(sp)    # s0 is used for file descriptor
    lw s1, 8(sp)    # s1 is used for the pointer to the buffer that malloc yields
    lw s2, 12(sp)   # The number of bytes to read from the file.
    addi sp, sp, 16

    jr ra

fopenError:
    li a0, 27
    j exit

mallocError:
    li a0, 26
    j exit

freadError:
    li a0, 29
    j exit

fcloseError: 
    li a0, 28
    j exit