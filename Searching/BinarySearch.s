.data
array: .word 1, 24, 56, 78, 90, 323, 4326, 57456, 74554
length: .word 9
errNotFound: .asciiz "Item is not in the array"

.text
main:
  addi $sp, $sp, -4 # Lower Stack Pointer
  sw $ra, 0($sp)    # Store return address into memory
  la $a0, array     # Load array into $a0
  li $a1, 0         # Load 0 into a1
  lw $a2, length    # Load length into $a2
  li $a3, 56        # Load item to search for into $a1
  jal binarySearch  # Binary search the array
  li $t0, -1        # Load not found flag for bne
  bne $v0, $t0, found# If found:
  j notFound        # If not found

found:
  add $a0, $v0, $0  # Move $v1 into $a0
  li $v0, 1         # Load print integer sys
  syscall           # Print the integer
  j exit            # Exit the program


notFound:
  la $a0, errNotFound# Load not found text into $a0
  li $v0, 4          # Load print string syscall
  syscall            # Print the string
  j exit             # Exit the program


exit:
  lw $ra, 0($sp)    # Load the return address
  addi $sp, $sp, 4  # Raise the stack pointer
  jr $ra            # Return


####################################
#          Binary Search           #
####################################
# Input:                           #
# $a0, the array of words          #
# $a1, left index                  #
# $a2, right index                 #
# $a3, item to search for          #
####################################
# Output:                          #
# $v0, index of item (-1 if failed)#
####################################
# Used Registers:                  #
# $t0, Midpoint                    #
# $t1, used in math                #
####################################

binarySearch:
  addi $sp, $sp, -4 # Lower stack pointer
  sw $ra, 0($sp)    # Store return address
  blt $a2, $a1, binaryFailed # If r < l then we failed
  add $t0, $a1, $0  # Move left into t0
  sub $t1, $a2, $a1 # Right - Left
  srl $t1, $t1, 1   # (Right - Left) / 2
  add $t0, $t1, $t0 # left + (right - left) / 2 (MID)
  sll $t1, $t0, 2   # Convert index into word format
  add $t1, $t1, $a0 # Add offset into array
  lw $t1, 0($t1)    # Load array element into memory
  beq $t1, $a3, binaryFound # The element was found
  bgt $t1, $a3, binaryGreater # The element is greater than the pointer
  addi $a1, $t0, 1  # Set left to mid+1
  jal binarySearch  # Search with new variable
  j binaryEnd

binaryFound:
  add $v0, $t0, $0  # Move mid answer into memory
  j binaryEnd       # End

binaryGreater:
  addi $a2, $t0, -1 # Set right to mid-1
  jal binarySearch  # Search with new right
  j binaryEnd

binaryFailed:
  li $v0, -1        # Load failed value
  j binaryEnd       # Load end

binaryEnd:
  lw $ra, 0($sp)    # Load the return
  addi $sp, $sp, 4  # Raise stack poiner
  jr $ra            # Return


####################################
#        End Binary Search         #
####################################
