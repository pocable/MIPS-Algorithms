.data
array: .word 4554, 241, 23254, 5536, 758, 920, 32223, 4326, 1, 74554
length: .word 9

.text
main:
  addi $sp, $sp, -4                 # Lower Stack Pointer
  sw $ra, 0($sp)                    # Store return address into memory
  la $a0, array                     # Load array into $a0
  lw $a1, length                    # Load length into $a1
  jal bubbleSort                    # Binary search the array
  la $a0, array                     # Reload $a0
  lw $a1, length                    # Reload length
  jal printArray                    # Print the array
  lw $ra, 0($sp)                    # Restore $sp
  addi $sp, $sp, 4                  # Raise the stack
  jr $ra                            # Return


#############################################
#                Bubble Sort                #
#############################################
# Input:                                    #
# $a0, the array                            #
# $a1, the length of the array              #
#############################################
# Output:                                   #
# The array sorted at the location provided #
#############################################
# Used Registers:                           #
# $s0, the array                            #
# $s1, represents i                         #
# $s2, represents j                         #
# $s3, represents n-1                       #
# $s4, represents (n-1)-i                   #
# $a0, shifted array by j                   #
# $a1, shifted array by j+1                 #
# $t0, value loaded from $a0                #
# $t1, value loaded from $a1                #
#############################################

bubbleSort:
  addi $sp, $sp, -24                # Lower stack pointer
  sw $s0, 0($sp)                    # Store $s0 into stack
  sw $s1, 4($sp)                    # Store $s1 into stack
  sw $s2, 8($sp)                    # Store $s2 into stack
  sw $s3, 12($sp)                   # Store $s3 into stack
  sw $s4, 16($sp)                   # Store $s4 into stack
  sw $ra, 20($sp)                   # Store $ra into the stack
  add $s0, $a0, $0                  # Move $a0 into $s0
  li $s1, 0                         # Set i = 0
  li $s2, 0                         # Set j = 0
  addi $s3, $a1, -1                 # Store n-1 into $s3
  j bubbleSortOuter                 # Run the outer loop


bubbleSortOuter:
  bge $s1, $s3, bubbleSortEnd       # If i >= n-1, we are done
  sub $s4, $s3, $s1                 # $(n-1)-i = (n-1)-i
  jal bubbleSortInner               # Run the inner loop
  addi $s1, $s1, 1                  # i++
  li $s2, 0                         # Set j = 0
  j bubbleSortOuter                 # Loop outer loop


bubbleSortInner:
  sll $a0, $s2, 2                   # j shifted left by 2
  add $a0, $a0, $s0                 # Shift the array by j
  lw $t0, 0($a0)                    # Load the value at A[j]
  lw $t1, 4($a0)                    # Load the value at A[j+1]
  ble $t0, $t1, bubbleSortInnerEnd  # If A[j] <= A[j+1], we end
  addi $sp, $sp, -4                 # Lower stack
  sw $ra, 0($sp)                    # Store return address
  addi $a1, $a0, 4                  # Store A[j+1] into array for swap
  jal swap                          # Swap the elements
  lw $ra, 0($sp)                    # Return return address
  addi $sp, $sp, 4                  # Raise stack
  j bubbleSortInnerEnd              # End loop


bubbleSortInnerEnd:
  addi $s2, $s2, 1                  # Add one to j
  blt $s2, $s4, bubbleSortInner     # If j < n - i - 1, continue
  jr $ra                            # Return

bubbleSortEnd:
  lw $s0, 0($sp)                    # Restore $s0
  lw $s1, 4($sp)                    # Restore $s1
  lw $s2, 8($sp)                    # Restore $s2
  lw $s3, 12($sp)                   # Restore $s3
  lw $s4, 16($sp)                   # Restore $s4
  lw $ra, 20($sp)                   # Restore $ra
  addi $sp, $sp, 24                 # Increase stack
  jr $ra                            # Return

#############################################
#              End Bubble Sort              #
#############################################


#######################################
#                Swap                 #
#######################################
# Input:                              #
# $a0, the first index shifted array  #
# $a1, the second index shifted array #
#######################################
# Output:                             #
# The items swapped in the array      #
#######################################
# Used Registers:                     #
# $t0, the first element              #
# $t1, the second element             #
#######################################

swap:
  lw $t0, 0($a0)                    # Load A into $t0
  lw $t1, 0($a1)                    # Load B into $t1
  sw $t1, 0($a0)                    # Store B into $a0
  sw $t0, 0($a1)                    # Store A into $a1
  jr $ra                            # Return

#######################################
#              End Swap               #
#######################################


##################################################
#   Print Array (SEE MISCELLANEOUS ALGORITHMS)   #
##################################################
# Input:                                         #
# $a0, the non-empty input array                 #
# $a1, the length of the input array             #
##################################################
# Output:                                        #
# The array is printed with syscalls             #
##################################################
# Used Registers:                                #
# $s0, saved copy of $a0                         #
# $t0, current index counter                     #
# $t1, the shifted array                         #
##################################################


printArray:
  addi $sp, $sp, -4                 # Decrease stack pointer
  sw $s0, 0($sp)                    # store $s0 into the stack
  add $s0, $a0, $0                  # Move $a0 into $s0
  li $t0, 0                         # Set current index to 0
  j printArrayLoop                  # Begin the loop


printArrayLoop:
  sll $t1, $t0, 2                   # Shift array by 2 to get word length
  add $t1, $t1, $s0                 # Offset the array by $t1
  lw $a0, 0($t1)                    # Load the element at pos $t0
  li $v0, 1                         # Preset syscall to integer
  syscall                           # Print the integer
  li $v0, 11                        # Load print char
  li $a0, 32                        # Load the proper space
  syscall                           # Print the space
  addi $t0, $t0, 1                  # Increment the index
  bne $a1, $t0, printArrayLoop      # If the current index != the length, loop
  li $a0, 10                        # Load newline
  syscall                           # Print newline
  lw $s0, 0($sp)                    # Restore $s0
  addi $sp, $sp, 4                  # Raise the stack pointer
  jr $ra                            # Return

##################################################
# End Print Array (SEE MISCELLANEOUS ALGORITHMS) #
##################################################
