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
    # Prologue
    ble a1, x0, error
    addi t1, x0, 0      # t1: count the location of the array.
    addi t4, x0, -2048 # t4, temporary max value
loop_start:
    bge t1, a1, loop_end# if t1 >= array.length, goto loop_end.

loop_continue:
    slli t2, t1, 2      # t2: offset of the array, because of type of int we use slli.
    addi t1, t1, 1      # update the conter.
    add t0, t2, a0      # t0: address of a[a1 + t1].
    lw t3, 0(t0)        # t3: content of a[a1 + t1].
    ble t3, t4, loop_start  # if a[a1+t1] < tep_max, continue
    addi t4, t3, 0
    addi a0, t1, -1     # answer of index
    bge x0, x0, loop_start
loop_end:
    # Epilogue

    jr ra

error:
    li a0, 36
    j exit