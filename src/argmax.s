.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    ebreak# Prologue
    addi sp, sp, -4
    sw ra, 0(sp)    # Always save the value of ra at the start of a function 
                    # and restore it at the end of a function.
    ble a1, x0, error
    addi t1, x0, 0      # t1: count the location of the array.
    addi t4, x0, -2048  # t4, temporary max value
    li t5, 0
loop_start:

loop_continue:
    slli t2, t1, 2      # t2: offset of the array, because of type of int we use slli.
    add t0, t2, a0      # t0: address of a[a1 + t1].
    lw t3, 0(t0)        # t3: content of a[a1 + t1].
    ble t3, t4, loop_end  # if a[a1+t1] < tep_max, continue
    addi t4, t3, 0
    mv t5, t1           # answer of index
loop_end:
    addi t1, t1, 1      # update the counter.
    blt t1, a1, loop_start  # if t1 < array.length, goto loop_end.
    # Epilogue
    mv a0, t5
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

error:
    li a0, 36
    j exit