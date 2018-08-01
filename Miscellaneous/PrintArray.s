.data
array: .word 1, 24, 56, 78, 90, 323, 4326, 57456, 74554
length: .word 9

.text
main:
  addi $sp, $sp, -4             # Lower Stack Pointer
  sw $ra, 0($sp)                # Store return address into memory
  la $a0, array                 # Load array into $a0
  lw $a1, length                # Load length into $a1
  jal printArray                # Binary search the array
  lw $ra, 0($sp)                # Restore return address
  jr $ra                        # Return


######################################
#            Print Array             #
######################################
# Input:                             #
# $a0, the non-empty input array     #
# $a1, the length of the input array #
######################################
# Output:                            #
# The array is printed with syscalls #
######################################
# Used Registers:                    #
# $s0, saved copy of $a0             #
# $t0, current index counter         #
# $t1, the shifted array             #
######################################

printArray:
  addi $sp, $sp, -4             # Decrease stack pointer
  sw $s0, 0($sp)                # store $s0 into the stack
  add $s0, $a0, $0              # Move $a0 into $s0
  li $t0, 0                     # Set current index to 0
  j printArrayLoop              # Begin the loop


printArrayLoop:
  sll $t1, $t0, 2               # Shift array by 2 to get word length
  add $t1, $t1, $s0             # Offset the array by $t1
  lw $a0, 0($t1)                # Load the element at pos $t0
  li $v0, 1                     # Preset syscall to integer
  syscall                       # Print the integer
  li $v0, 11                    # Load print char
  li $a0, 32                    # Load the proper space
  syscall                       # Print the space
  addi $t0, $t0, 1              # Increment the index
  bne $a1, $t0, printArrayLoop  # If the current index != the length, loop
  li $a0, 10                    # Load newline
  syscall                       # Print newline
  lw $s0, 0($sp)                # Restore $s0
  addi $sp, $sp, 4              # Raise the stack pointer
  jr $ra                        # Return

######################################
#          End Print Array           #
######################################
