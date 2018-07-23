.data
array: .word 1, 24, 56, 78, 90, 100, 323, 4326, 57456, 74554
length: .word 10
errNotFound: .asciiz "Item is not in the array"

.text
main:
  addi $sp, $sp, -4           # Lower Stack Pointer
  sw $ra, 0($sp)              # Store return address into memory
  la $a0, array               # Load array into $a0
  li $a1, 78                  # Load item to search for
  lw $a2, length              # Load length into $a2
  jal linearSearch            # Linear search the array
  li $t0, -1                  # Load not found flag for bne
  bne $v0, $t0, found         # If found:
  j notFound                  # If not found

found:
  add $a0, $v0, $0            # Move $v1 into $a0
  li $v0, 1                   # Load print integer sys
  syscall                     # Print the integer
  j exit                      # Exit the program


notFound:
  la $a0, errNotFound         # Load not found text into $a0
  li $v0, 4                   # Load print string syscall
  syscall                     # Print the string
  j exit                      # Exit the program


exit:
  lw $ra, 0($sp)              # Load the return address
  addi $sp, $sp, 4            # Raise the stack pointer
  jr $ra                      # Return



########################################
#           Linear Search              #
########################################
# Input:                               #
# $a0, the array                       #
# $a1, the element to search for       #
# $a2, the length of the array         #
########################################
# Output:                              #
# $v0, index of item (-1 if it failed) #
########################################
# Used Registers:                      #
# $t0, the current index               #
# $t1, the current item                #
########################################

linearSearch:
  li $t0, 0                   # Load 0 into the index
  j linearLoop                # Loop

linearLoop:
  bge $t0, $a2, linearFailed  # If $t0 > $a2, we are outside the array
  lw $t1, 0($a0)              # Load the element into t1
  beq $t1, $a1, linearFound   # Found the element
  addi $a0, $a0, 4            # Add 4 (1 word index) to the array
  addi $t0, $t0, 1            # Add one to the index
  j linearLoop

linearFound:
  add $v0, $t0, $0            # Move $t0 into $v0
  jr $ra                      # Return

linearFailed:
  li $v0, -1                  # Load failed search
  jr $ra                      # Return

########################################
#          End Linear Search           #
########################################
