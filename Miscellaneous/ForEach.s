# This example will perform foreach element in array, print it.

.data
array: .word 1, 24, 56, 78, 90, 323, 4326, 57456, 74554
length: .word 9

.text
main:
  la $a0, array              # Load array into $a0
  lw $a1, length             # Load length into $a1
  la $a2, print              # Load the address of the print function into $a2
  addi $sp, $sp, -4          # Lower Stack Pointer
  sw $ra, 0($sp)             # Store return address into memory
  jal foreach                # Do for each element $a2
  lw $ra, 0($sp)             # Restore $ra from the stack
  addi $sp, $sp, 4           # Raise the stack pointer

  jr $ra                     # Return


##################################
#             Print              #
##################################
# Input:                         #
# $a0, a word to be printed      #
##################################
# Output:                        #
# $v0, the input $a0             #
# The word printed to the screen #
##################################
# Used Registers:                #
# $s0, clone of a0               #
##################################

print:
  addi $sp, $sp, -4          # Lower the stack pointer
  sw $s0, 0($sp)             # Store $s0 onto the stack
  add $s0, $a0, $0           # Store a0 into s0 temporarily
  li $v0, 1                  # Preset syscall to integer
  syscall                    # Print the integer
  li $v0, 11                 # Load print char
  li $a0, 32                 # Load the proper space
  syscall                    # Print the space
  add $v0, $s0, $0           # Move s0 into v0 so the original list is not modified
  lw $s0, 0($sp)             # Restore $s0 from the stack
  addi $sp, $sp, 4           # Raise the stack pointer
  jr $ra                     # Return
  
##################################
#           End Print            #
##################################



##########################################################################
#                                For Each                                #
##########################################################################
# Input:                                                                 #
# $a0, pointer to the first element of an input array                    #
# $a1, the length of the input array                                     #
# $a2, a pointer to the function to be called for each element in a0     #
##########################################################################
# Output:                                                                #
# Every element in the array is passed to the provided function.         #
# The returned value of that function is stored at the current position  #
# so setting output = input will not modify the list provided.           #
##########################################################################
# Used Registers:                                                        #
# $s0, saved copy of $a0                                                 #
# $s1, saved copy of $a1                                                 #
# $s2, saved copy of $a2                                                 #
# $s3, current index in the list                                         #
# $t0, current shifted list                                              #
# $t1, current index shifted                                             #
##########################################################################

foreach:
  addi $sp, $sp, -20         # Lower the stack pointer
  sw $s0, 0($sp)             # Store $s0 onto the stack
  sw $s1, 4($sp)             # Store $s1 onto the stack
  sw $s2, 8($sp)             # Store $s2 onto the stack
  sw $s3, 12($sp)            # Store $s3 onto the stack
  sw $ra, 16($sp)            # Store $ra onto the stack

  add $s0, $a0, $0           # Save a0 into s0
  add $s1, $a1, $0           # Save a1 into s1
  add $s2, $a2, $0           # save a2 into s2
  li $s3, 0

  jal foreachloop            # Jump to the main loop.

  lw $s0, 0($sp)             # Restore $s0 from the stack
  lw $s1, 4($sp)             # Restore $s1 from the stack
  lw $s2, 8($sp)             # Restore $s2 from the stack
  lw $s3, 12($sp)            # Restore $s3 from the stack
  lw $ra, 16($sp)            # Restore $ra from the stack
  addi $sp, $sp, 20          # Raise the stack pointer
  jr $ra

foreachloop:
  sll $t1, $s3, 2            # Shift index by 2 to get word length
  add $t0, $s0, $t1          # Add the offset to the array
  lw $a0, 0($t0)             # Load the data into register $a0

  addi $sp, $sp, -4          # Lower the stack pointer
  sw $ra, 0($sp)             # Store $ra onto the stack
  jal $s2                    # Jump to function with $a0 = element
  lw $ra, 0($sp)             # Restore $ra from the stack
  addi $sp, $sp, 4           # Raise the stack pointer

  sw $v0, 0($t0)             # Store the output at current index
  addi $s3, $s3, 1           # Increment index by one
  bne $s3, $s1, foreachloop  # If the current index != the length, loop
  jr $ra                     # Return back to main foreach to clean stack

##########################################################################
#                              End For Each                              #
##########################################################################
