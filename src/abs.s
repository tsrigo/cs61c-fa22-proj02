.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
#   a0 (int*) is a pointer to the input integer
# Returns:
#   None
# =================================================================
abs:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)    # Always save the value of ra at the start of a function 
                    # and restore it at the end of a function.
    # PASTE HERE

    # Load number from memory
    ebreak
    lw t0 0(a0)
    bge t0, zero, done

    # Negate a0
    sub t0, x0, t0

    # Store number back to memory
    sw t0 0(a0)

    done:
    ret   
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
