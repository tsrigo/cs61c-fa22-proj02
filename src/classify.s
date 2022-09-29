.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    # check arg
    li t0 5
    bne a0, t0, argError

    ebreak
    # Prologue of classify
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)        # will be used for the address of row and col
    sw s1, 8(sp)        # will be used for a1
    sw s2, 12(sp)       # will be used for a2
    sw s3, 16(sp)       # will be used for the return address of h
    sw s4, 20(sp)       # will be used for the return address of o
    sw s5, 24(sp)       # will be used for the result of classification
    sw s6, 28(sp)       # A pointer to the matrix m0 in memory.
    sw s7, 32(sp)       # A pointer to the matrix m1 in memory.
    sw s8, 36(sp)       # A pointer to the input matrix in memory.
 
    mv s2, a2
    mv s1, a1

    ebreak##* 1. Read three matrices
    #* 1.0 allocate space for the pointer arguments row and col for 3 matrixs
    # call malloc
    li a0, 24           #! Wrong: li a0, 6
    jal malloc
    # check error
    beq a0, x0, mallocError
    # save result
    mv s0, a0
    
    #* 1.1 read matrix m0
    lw a0, 4(s1)        #! Wrong: addi a0, s1, 4
    addi a1, s0, 0      # save the row of m0 in s0[0]
    addi a2, s0, 4      # save the col of m0 in s0[1]
    jal read_matrix
    mv s6, a0            
    #* 1.2 Read pretrained m1
    lw a0, 8(s1)
    addi a1, s0, 8      # save the row of m1 in s0[2]
    addi a2, s0, 12     # save the col of m1 in s0[3]
    jal read_matrix
    mv s7, a0 
    #* 1.3 Read input matrix
    lw a0, 12(s1)
    addi a1, s0, 16     # save the row of input matrix in s0[4]
    addi a2, s0, 20     # save the col of input matrix in s0[5]
    jal read_matrix
    mv s8, a0 

    ebreak##* 2. Compute h = matmul(m0, input)
    #* 2.1 malloc space for h
    lw t0, 0(s0)    # rows
    lw t1, 20(s0)   # cols
    mul a0, t0, t1
    slli a0, a0, 2  # since the unit of malloc is byte, so you should multiply a0 by 4
    jal malloc
    mv s3, a0       # save the return address of h
    #* 2.2 call matmul
    mv a0, s6       # A pointer to the start of the first matrix m0
    lw a1, 0(s0)    # rows
    lw a2, 4(s0)    # cols
    mv a3, s8       # A pointer to the start of the input matrix
    lw a4, 16(s0)   # rows
    lw a5, 20(s0)   # cols
    mv a6, s3       # A pointer to the start h.
    jal matmul      # return none

    ebreak##* 3. Compute h = relu(h)
    #* 3.1 call relu
    mv a0, s3       # A pointer to the start of the integer array.
    lw t0, 0(s0)    # rows
    lw t1, 20(s0)   # cols
    mul a1, t0, t1  # The number of integers in the array h.
    jal relu

    ebreak##* 4. Compute o = matmul(m1, h) and write the resulting matrix to the output file.
    #* 4.1 Compute o = matmul(m1, h)
    #* 4.1.1 malloc space for o
    lw t0, 8(s0)
    lw t1, 20(s0)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    mv s4, a0       #  save the return address of o
    #* 4.1.1 call matmul
    mv a0, s7       # A pointer to the start of m1.
    lw a1, 8(s0)
    lw a2, 12(s0)
    mv a3, s3       # A pointer to the start of h.
    lw a4, 0(s0)
    lw a5, 20(s0)
    mv a6, s4       # A pointer to the start of o.
    jal matmul
    #* 4.2 write the resulting matrix to the output file.
    #* 4.2.1 call write_matrix
    lw a0, 16(s1)   # A pointer to the filename string.
    mv a1, s4       # A pointer to the matrix in memory (stored as an integer array).
    lw a2, 8(s0)    # The number of rows in the matrix o.
    lw a3, 20(s0)   # The number of columns in the matrix o.
    jal write_matrix

    ebreak##* 5. Compute and return argmax(o)
    #* 5.1 call argmax
    mv a0, s4
    lw t0, 8(s0) 
    lw t1, 20(s0)
    mul a1, t0, t1
    jal argmax
    mv s5, a0       # save the result of classification

    ebreak##* 6. If enabled, print argmax(o) and newline
    #* 6.1 check and branch
    bne s2, x0, end
    #* 6.2 print out argmax(o) and a newline character
    #* 6.2.1 call print_int to print argmax(o)
    mv a0, s5
    jal print_int
    #* 6.2.2 call print_chac to print newline
    li a0, '\n'
    jal print_char

    ebreak##* 7. Free any data allocated with malloc.
    mv a0, s0
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free

end:
    # put the return value in a0
    mv a0, s5
    # Epilogue of classify
    
    lw ra, 0(sp)
    lw s0, 4(sp)        # will be used for the address of row and col
    lw s1, 8(sp)        # will be used for a1
    lw s2, 12(sp)       # will be used for a2
    lw s3, 16(sp)       # will be used for the return address of h
    lw s4, 20(sp)       # will be used for the return address of o
    lw s5, 24(sp)       # will be used for the result of classification
    lw s6, 28(sp)       # A pointer to the matrix m0 in memory.
    lw s7, 32(sp)       # A pointer to the matrix m1 in memory.
    lw s8, 36(sp)       # A pointer to the input matrix in memory.
    addi sp, sp, 40
    
    jr ra

mallocError:
    li a0, 26
    j exit

argError:
    li a0, 31
    j exit