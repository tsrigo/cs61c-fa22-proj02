.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
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