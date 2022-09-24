.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    ble a1, x0, error3
    ble a2, x0, error3
    ble a4, x0, error3
    ble a5, x0, error3
    bne a2, a4, error3

    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    addi t1, x0, 0  # t1: counter of row of m0

    ebreak
outer_loop_start:
    mul t3, t1, a2  
    slli t3, t3, 2
    add t3, a0, t3  # t3: the first element's address of the number t1 row of m0

    addi t2, x0, 0  # t2: counter of column of m1; Here also init the inner loop
inner_loop_start:
    slli t4, t2, 2  
    add t4, a3, t4  # t4: the first element's address of the number t2 column of m2

    addi sp, sp, -44
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)

    sw t1, 28(sp)
    sw t2, 32(sp)
    sw t3, 36(sp)
    sw t4, 40(sp)

    addi a0, t3, 0
    addi a1, t4, 0
    # addi a2, a2, 0: a2 needn't be changed 
    addi a3, x0, 1
    addi a4, a5, 0
    jal dot  
    
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)

    lw t1, 28(sp)
    lw t2, 32(sp)
    lw t3, 36(sp)

    mul t4, t1, a5
    add t4, t4, t2
    slli t4, t4, 2
    add t4, t4, a6
    sw a0, 0(t4)

    lw t4, 40(sp)
    lw a0, 0(sp)
    addi sp, sp, 44
    
inner_loop_end:
    addi t2, t2, 1
    blt t2, a5, inner_loop_start


outer_loop_end:
    addi t1, t1, 1  # update t1
    blt t1, a1, outer_loop_start
    # Epilogue

    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

dot:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)    # Always save the value of ra at the start of a function 
                    # and restore it at the end of a function.
    ble a2, x0, error1
    ble a3, x0, error2
    ble a4, x0, error2

    addi t1, x0, 0
    addi t6, x0, 0
    ebreak
loop_start:
    bge t1, a2, loop_end

    mul t2, t1, a3
    slli t2, t2, 2
    add t0, t2, a0
    lw t3, 0(t0)

    mul t4, t1, a4
    slli t4, t4, 2
    add t0, t4, a1
    lw t4, 0(t0)

    mul t5, t3, t4
    add t6, t6, t5

    addi t1, t1, 1  
    bge x0, x0, loop_start

loop_end:
    add a0, x0, t6
    lw ra, 0(sp)
    addi sp, sp, 4
    # Epilogue
    jr ra

error1:
    li a0, 36
    j exit
error2:
    li a0, 37
    j exit
error3:
    li a0, 38
    j exit