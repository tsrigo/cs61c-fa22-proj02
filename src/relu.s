.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)    # Always save the value of ra at the start of a function 
                    # and restore it at the end of a function.
    ebreak
    ble a1, x0, error
    addi t1, x0, 0      # t1: count the location of the array.
loop_start:
    bge t1, a1, loop_end# if t1 >= array.length, goto loop_end.

loop_continue:
    slli t2, t1, 2      # t2: offset of the array, because of type of int we use slli with 2.
    addi t1, t1, 1      # update the conter.
    add t0, t2, a0      # t0: address of a[a1 + t1].
    lw t3, 0(t0)        # t3: content of a[a1 + t1].
    bge t3, x0, loop_start # if a[a1 + t1] >= 0, loop again
    sw x0, 0(t0)           # else it should be assigned the 0
    bge x0, x0, loop_start # loop again
loop_end:

    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

error:
    li a0 36
    j exit