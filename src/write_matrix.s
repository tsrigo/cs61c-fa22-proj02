.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue of write_matrix
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)    # s0 is used for file descriptor
    sw s1, 8(sp)    # s1 is used for the pointer to the buffer that malloc yields
    sw s2, 12(sp)   # The number of bytes to read from the file.
    ebreak
    # calculate the number of items
    mul s2, a2, a3
    
    # 1. Open the file with write permissions. The filepath is provided as an argument.

    # prologue of fopen
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    # call fopen
    # needless: mv a0, a0
    li a1, 1       # Permission bits. 0 for read-only, 1 for write-only.
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
    # 2. Write the number of rows and columns to the file.

    # use malloc to get a buffer for row and col
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
    mv s1, a0
    # epilogue of malloc
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
    
    # save the col and row to the allocated buffer
    sw a2, 0(s1)
    sw a3, 4(s1)

    # Write col and row to file.
    # prologue of fwrite
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    # call fwrite
    mv a0, s0   # The file descriptor of the file we want to write to, previously returned by fopen.
    mv a1, s1   # A pointer to a buffer containing what we want to write to the file.
    li a2, 2    # The number of elements to write to the file.
    li a3, 4    # The size of each element. In total, a2 × a3 bytes are written.
    jal fwrite
        # check error
    li t0, 2
    bne a0, t0, fwriteError            
    # epilogue of fwrite
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    ebreak
    # 3. Write the data to the file.

    # prologue of fwrite
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    # call fwrite
    mv a0, s0
    # needless: mv a1, a1
    mv a2, s2
    li a3, 4
    jal fwrite
        # check error
    bne a0, s2, fwriteError
    # epilogue of fwrite
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    ebreak  
    # 4. Close the file.
    addi sp, sp, -4
    sw ra, 0(sp)
    # call fclose
    mv a0, s0
    jal fclose
        # check error
    bne a0, x0, fcloseError
    
    # epilogue of fclose
    lw ra, 0(sp)
    addi sp, sp, 4

    # Epilogue of write_matrix
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

fwriteError:
    li a0, 30
    j exit