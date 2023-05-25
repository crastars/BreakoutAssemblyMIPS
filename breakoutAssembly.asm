################ CSC258H1F Fall 2022 Assembly Final Project ##################
# This file contains our implementation of Breakout.
#
# Student 1: Razeen Ali
# Student 2: Carina Rastarhuyeva
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       4
# - Unit height in pixels:      4
# - Display width in pixels:    256
# - Display height in pixels:   256
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

.data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:	.word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:	.word 0xffff0004


ROW_SIZE: .word 64 	#row size for reference
COL_SIZE: .word 64	#col size for reference

RED: .word 0xFF0000		#color red for future reference
BLUE: .word 0x0000FF		#color blue for future reference
GREEN: .word 0xFF00FF00 	#color green for future reference
BROWN: .word 0xFFA52A2A 	#color brown for future reference
PINK:  .word 0xFFFFC0CB	#color pink for future reference
YELLOW:	.word 0xFFFF00		#color yellow for future reference
PURPLE:	.word 0xA020F0		#color purple for future reference
MY_PINK: .word 0xF81894
BLACK: .word 0x000000
MY_PINK2: .word 0xF81894


PADDLE_COLOR: .word 0x008080 #color teal for future reference
PREV_PADDLE_COLOR: .word 0 #variable that stores previous color of paddle (for animation)

PADDLE_X: .word 26 #2 to 52 (vals paddle_x can be b/c len is 10)


BALL_COLOR: .word 0x808080 #grey color for ball
PREV_BALL_COLOR: .word 0 #saved prev color for animation

DISPLAY_COLOR: .word 0

ball_x:     .word 32 #2 to 62 (b/c 2pxl width)
ball_y:     .word 31 #2 to 62 (b/c 2 pxl height)

ball_h:		.word 1     #0 is left, 1 is right
ball_v:		.word 0    #1 is down, 0 is up	


KEY_A: .word 0x61 #left
KEY_D: .word 0x64 #right
KEY_Q: .word 0x71 #quit
KEY_P: .word 0x70 #pause
KEY_R: .word 0x72 #retry
#KEY_S: .word 0x73 #un-pause
#KEY_E: .word 0x65 #launch
KEY_T: .word 0x74 #terminate

TIME_LIMIT: .word 60000 #limit in seconds (limit/1000)

NUM_LIVES: .word 3


# freq for twinkle twinkle
MELODY: .word 62, 65, 68, 72, 74, 61, 0
# index for note

NOTE_INDEX: .word 0
#pixels to paint for game over screen
GAME_OVER_POINTS: .word 15,3,15,4,15,5,15,6,15,7,15,8,15,9,15,10,15,15,15,16,15,17,15,18,15,19,15,20,15,21,15,28,15,34,15,39,15,40,15,41,15,42,15,43,15,44,15,45,16,3,16,15,16,21,16,28,16,29,16,33,16,34,16,39,17,3,17,15,17,21,17,28,17,30,17,32,17,34,17,39,18,3,18,15,18,21,18,28,18,31,18,34,18,39,19,3,19,15,19,16,19,17,19,18,19,19,19,20,19,21,19,28,19,34,19,39,19,40,19,41,19,42,20,3,20,15,20,21,20,28,20,34,20,39,21,3,21,6,21,7,21,8,21,9,21,15,21,21,21,28,21,34,21,39,22,3,22,9,22,15,22,21,22,28,22,34,22,39,23,3,23,9,23,15,23,21,23,28,23,34,23,39,23,40,23,41,23,42,23,43,23,44,23,45,24,3,24,4,24,5,24,6,24,7,24,8,24,9,24,15,24,21,29,14,29,15,29,16,29,17,29,18,29,19,29,20,29,24,29,30,29,34,29,35,29,36,29,37,29,38,29,39,29,43,29,44,29,45,29,46,29,47,29,48,30,14,30,20,30,24,30,30,30,34,30,43,30,48,31,14,31,20,31,24,31,30,31,34,31,43,31,48,32,14,32,20,32,24,32,30,32,34,32,43,32,48,33,14,33,20,33,25,33,29,33,34,33,35,33,36,33,43,33,45,33,46,33,47,34,14,34,20,34,26,34,28,34,34,34,43,34,45,35,14,35,20,35,27,35,34,35,43,35,46,36,14,36,15,36,16,36,17,36,18,36,19,36,20,36,34,36,35,36,36,36,37,36,38,36,39,36,43,36,47,41,28,42,28,43,7,43,8,43,9,43,27,43,28,43,29,44,6,44,9,44,18,44,19,44,20,44,22,44,23,44,24,44,25,44,28,44,35,44,36,44,37,45,6,45,9,45,17,45,22,45,25,45,28,45,34,45,40,45,44,46,6,46,8,46,17,46,22,46,23,46,24,46,25,46,28,46,34,46,41,46,44,47,6,47,8,47,12,47,13,47,17,47,22,47,28,47,34,47,42,47,43,48,6,48,9,48,17,48,22,48,23,48,24,48,28,48,29,48,30,48,31,48,34,48,43,49,6,49,10,49,43,50,43,54,6,54,7,54,8,54,9,54,10,54,18,55,8,55,18,55,54,56,8,56,18,56,40,56,54,57,8,57,12,57,13,57,17,57,18,57,19,57,52,57,53,57,54,57,55,58,8,58,18,58,21,58,22,58,23,58,28,58,29,58,30,58,33,58,34,58,36,58,37,58,44,58,45,58,48,58,49,58,50,58,51,58,54,58,57,58,58,59,8,59,18,59,21,59,24,59,27,59,32,59,35,59,38,59,40,59,43,59,46,59,51,59,54,59,56,59,59,60,8,60,18,60,21,60,22,60,23,60,27,60,32,60,38,60,40,60,43,60,46,60,48,60,49,60,50,60,51,60,54,60,56,60,57,60,58,60,59,61,18,61,21,61,27,61,32,61,38,61,40,61,43,61,46,61,48,61,51,61,54,61,56,62,21,62,22,62,23,62,27,62,48,62,49,62,50,62,51,62,56,62,57,62,58
GAME_OVER_POINTS_NUM: .word 356

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
.text
.globl main


	# Run the Brick Breaker game.
main:

    jal clear_screen
    # Initialize the game
    lw $t0, ADDR_DSPL        # Load the display address into $t0
    lw $t1, ROW_SIZE         # Load the number of rows into $t1
    lw $t2, COL_SIZE         # Load the number of columns into $t2
    
    lw $t3, RED            	# Load the color red into $t3
    jal draw_border_sides     	# Call draw_border_sides function to draw the side walls
    
    lw $t3, BLUE            	# Load the color blue into $t3
    jal draw_ceiling		# Call function to draw the ceiling
    
    jal draw_bricks
    
    jal draw_paddle
    
    jal draw_ball
    jal draw_1heart
    
    j game_loop


draw_1heart:
	lw $t3, MY_PINK
	lw $t0, ADDR_DSPL
	addi $t0, $t0, 15600 #shifts y to rows after paddle
	addi $t0, $t0, 196
	#lw $t2, NUM_LIVES
	lw $t2, NUM_LIVES

draw_heart_loop:
	beq $zero, $t2, draw_heart_done
	sw $t3, 0($t0)
	sw $t3, 8($t0)
	sw $t3, 260($t0)
	addi $t2, $t2, -1
	add $t0, $t0,24

	j draw_heart_loop
	
draw_heart_done:
	jr $ra

draw_border_sides:
	add $t4, $zero, $zero			#initialize counter to keep track of rows
	
draw_border_sides_loop:	
	beq $t4, $t1, border_sides_done		#loop through all rows until reaches row size
	sw $t3 0($t0)				#set 1st col to red (left border, 1st pxl); $t0 - (0,0) at display
	sw $t3 4($t0)				#set 2nd col to red (left border, 2nd pxl)
	sw $t3 248($t0)				#set 2nd last col to red (right border, 1st pxl)
	sw $t3 252($t0)				#set last col to red (right border, 2nd pxl)
	addi $t0, $t0, 256			#go to next row (deals w/ full height of border)
	addi $t4, $t4, 1			#increase row count tracker
	j draw_border_sides_loop		#loop with next row
	
border_sides_done:
	lw $t0, ADDR_DSPL 			#reset ADDR_DSPL
	jr $ra					#jump back to main - line 74
	
draw_ceiling:
	addi $t4, $t2, -4			# (COl - 4) since we already filled left/right border
	add $t5, $zero, $zero			#initiliaze col count tracker
	addi $t0, $t0, 8			#start drawing from the 8th pixel (where left border ends)

draw_ceiling_loop:
	beq $t5, $t4, ceiling_done		#check if all cols been filled (checks for row limit = $t2-4)
	sw $t3 0($t0)				#draw on the 1st row (width 2)
	sw $t3 256($t0)				#draw on the 2nd row (width 2)
	addi $t0, $t0, 4			#change pointer to next col 
	addi $t5, $t5, 1			#increment col tracker count
	j draw_ceiling_loop			#loop with next col
	
ceiling_done:
	lw $t0, ADDR_DSPL 			#reset ADDR_DSPL
	jr $ra					#jump back to main - line 78
	
# Razeen

draw_bricks:
	addi $sp, $sp, -4	# Move the stack pointer to the next empty location.
	sw $ra, 0($sp)		#save jal pointer for future ref to go back to main
	
	addi $sp, $sp, -4	# Move the stack pointer to the next empty location.
	sw $t0, 0($sp)		#save Address for future ref to go back to main
	
	addi $t0, $t0, 1040	#shift first rec pointer
	add $a0, $t0, $zero	#save initial address to a0
	
	###two copies since the latest one changes each line/ brick
	addi $sp, $sp, -4	# Move the stack pointer to the next empty location.
	sw $a0 0($sp)		#move new position to stack
	
	addi $sp, $sp, -4	# Move the stack pointer to the next empty location.
	sw $a0 0($sp)		#move new position to stack
	
    	li $t6, 3            # Set the loop counter for the number of times to call draw_line_rect

draw_bricks_loop:
    jal draw_line_rect   # Call draw_line_rect subroutine

    addi $t6, $t6, -1    # Decrement the loop counter
    beq $t6, $zero, draw_bricks_done  # If the loop counter is zero, jump to draw_bricks_done

    lw $a0, 0($sp)       # Load the 2nd last stack pointer value into $a0
    addi $a0, $a0, 1024   # Increment the 2nd last stack pointer value by 512
    sw $a0, 0($sp)       # Update the latest stack pointer value

    addi $sp, $sp, -4
    sw $a0, 0($sp)       # Update the latest stack pointer value

    j draw_bricks_loop   # Continue the loop

draw_bricks_done:
    lw $t0, 4($sp)       # Restore the address to $t0
    lw $ra, 8($sp)      # Restore the return address to $ra
    addi $sp, $sp, 12    # Reset the stack pointer
    jr $ra               # Return to the caller

draw_line_rect:
	addi $sp, $sp, -4	# Move the stack pointer to the next empty location.
	sw $ra, 0($sp)		#save jal pointer for future ref to go back to main
    	addi $t9, $zero, 7   # Set $t9 to the number of rects in a line (7)
    	addi $sp, $sp, 4	# Move the stack pointer to the next empty location.

draw_line_rect_loop:
    jal select_color     # Call select_color subroutine
    lw $a0, 0($sp)       # Get initial address from stack and store it in $a0
    jal draw_one_brick   # Call draw_one_brick subroutine to draw a brick

    addi $a0, $a0, 8     # Increment the address by 8 bytes
    sw $a0, 0($sp)       # Move the new position to the stack

    addi $t9, $t9, -1    # Decrement the rect counter
    bne $t9, $zero, draw_line_rect_loop  # If $t9 is not zero, continue the loop

draw_line_end:
	addi $sp, $sp, -4	# Move the stack pointer to the next empty location.
	lw $ra 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
select_color:
    li $v0, 42              # Syscall for random int range
    li $a0, 0               # Seed value for the random number generator (set any value)
    li $a1, 5               # Upper bound for random number generation (exclusive)
    syscall                 # Generate random number in the range [0, 2)

    li $t0, 0             # Temporary register for comparison
    beq $a0, $t0, set_green # If random number is 1, set green
    li $t0, 1               # Temporary register for comparison
    beq $a0, $t0, set_brown # If random number is 2, set brown
    li $t0, 2               # Temporary register for comparison
    beq $a0, $t0, set_pink  # If random number is 3, set pink
    li $t0, 3               # Temporary register for comparison
    beq $a0, $t0, set_yellow  # If random number is 3, set yellow
    li $t0, 4               # Temporary register for comparison
    beq $a0, $t0, set_purple  # If random number is 3, set purple

set_green:
    lw $a3, GREEN           # Load the color green into $a3
    j exit_color_selection

set_brown:
    lw $a3, BROWN           # Load the color brown into $a3
    j exit_color_selection
set_yellow:
    lw $a3, YELLOW           # Load the color brown into $a3
    j exit_color_selection
set_purple:
    lw $a3, PURPLE           # Load the color brown into $a3
    j exit_color_selection

set_pink:
    lw $a3, PINK            # Load the color pink into $a3

exit_color_selection:
    jr $ra
    	
draw_one_brick:
    lw $a0, 0($sp)           # Get initial address from stack and store it in $a0
    addi $t8, $zero, 6       # Set how long one brick is; 6px

one_brick_loop:

    beq $t8, $zero, brick_done  # Check if the brick has been drawn
    sw $a3, 0($a0)           # Draw the brick at the current address
    sw $a3, 256($a0)         # Draw the brick at the address 256 bytes below
    addi $a0, $a0, 4         # Increment the address by 4 bytes
    addi $t8, $t8, -1        # Decrement the brick counter
    j one_brick_loop         # Continue drawing the brick

brick_done:
    jr $ra

#Carina

draw_paddle:
    lw $t0, ADDR_DSPL		# Load the display address into $t0

    lw $t1, PADDLE_X		# Add 7680 and (next line) 4 times PADDLE_X value to get the initial "middle" point based on paddle
    sll $t1, $t1, 2 		# Multiply PADDLE_X by 2^2=4
    add $t0, $t0, $t1		# Updating display pointer
    addi $t0, $t0, 14592 	# To get the bottom (y-shift) 256x57
    
    lw $t2, PADDLE_COLOR 	# Set paddle color to teal
    addi $t8, $zero, 10       	# Set how long paddle is; 6px
    
draw_paddle_loop:
	beq $t8, $zero, paddle_done	# Check if the paddle has been drawn (until len of 6px is reached)
   	sw $t2, 0($t0)           	# Draw the paddle at the current address starting from relative 0
    	sw $t2, 256($t0)         	# Draw the paddle at the address 256 bytes below b/c width 2
    	addi $t0, $t0, 4         	# Increment the address by 4 bytes b/c every pixel is 4
    	addi $t8, $t8, -1        	# Decrement the paddle counter
    	j draw_paddle_loop        	# Continue drawing the paddle

paddle_done:
    jr $ra	#jump back to main - line 82


draw_ball:
    lw $t0, ADDR_DSPL  # Load the display address into $t0

    # Calculate the pixel address based on ball_x and ball_y
    add $t1, $t0, $zero   # Copy the display address to $t1
    lw $t2, ball_x        # Load ball_x into $t2 - initially 31
    lw $t3, ball_y        # Load ball_y into $t3 - initially 31
    sll $t2, $t2, 2       # Multiply ball_x by 4 to get the offset in pixels
    sll $t3, $t3, 8       # Multiply ball_y by 256 to get the offset in pixels
    add $t1, $t1, $t2     # Add the x offset to the display address
    add $t1, $t1, $t3     # Add the y offset to the display address
last_checks:
  ###check top left corner
      # Get the pixel at that location
    lw $t5, 0($t1)
    sw $t5, DISPLAY_COLOR


    li $t6, 0xFFA52A2A  # BROWN
    beq $t5, $t6, skip_break
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Check if the display color was in the specified list
    li $t6, 0xFF00FF00  # GREEN
    beq $t5, $t6, toggle_ball_direction


    li $t6, 0xFFFFC0CB  # PINK
    beq $t5, $t6, toggle_ball_direction

    li $t6, 0xFFFFFF00  # YELLOW
    beq $t5, $t6, toggle_ball_direction

    li $t6, 0xFFA020F0  # PURPLE
    beq $t5, $t6, toggle_ball_direction



  
toggle_ball_done:
    # Draw the ball
    lw $t9, BALL_COLOR    
    sw $t9, 0($t1)     # Set the color of the pixel to gray
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra  

skip_break:

    addi $sp, $sp, -4
    sw $ra, 0($sp)


    lw $t4, ball_v
    xori $t4, $t4, 1
    sw $t4, ball_v
    
    jal update_ball_x
    jal update_ball_y
    jal make_beep1
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra   

toggle_ball_direction:
    lw $t4, ball_v
    xori $t4, $t4, 1
    sw $t4, ball_v
    lw $t4, ball_h
    xori $t4, $t4, 1
    sw $t4, ball_h
    jal make_beep1
    j toggle_ball_done

############################################
###MAIN GAME FUNCTION
game_loop:

    # Read the keyboard input
    jal delay
    jal detect_walls
    jal detect_paddle
    #jal detect_brick
    jal move_ball
    lw $t1, ADDR_KBRD
    lw $t2, 0($t1)
    beq $t2, $zero, game_loop # If no key is pressed, keep looping

    # Check for key 'a' press - move paddle left
    lw $t3, KEY_A
    beq $t2, $t3, check_paddle_left_bound

    # Check for key 'd' press - move paddle right
    lw $t3, KEY_D
    beq $t2, $t3, check_paddle_right_bound

    # Check for key 'q' press - end game 
    lw $t3, KEY_Q
    beq $t2, $t3, END
	
    # Check for key 'p' press - pause game 
    lw $t3, KEY_P
    beq $t2, $t3, pause
    # If no relevant key is pressed, loop
    j game_loop

############################################

make_beep1:
   
       # Load the melody and note index
    la $t9, MELODY
    lw $t8, NOTE_INDEX
    sll $t7, $t8, 2     # Multiply note index by 4 to get the offset in bytes
    add $t9, $t9, $t7   # Add the offset to the melody address

    lw $a0, 0($t9)      # Load the pitch from the melody at the current note index
    beqz $a0, reset_index # If the pitch is 0, reset the note index

    # Increment the note index
    addi $t8, $t8, 1
    sw $t8, NOTE_INDEX
   
    li $v0, 31

    #li $a0, 60     # the pitch 
    li $a1, 100    # timing
    li $a2, 0      # Iinstrument
    li $a3, 100    # vol

    syscall

    jr $ra

reset_index:
	li $t6, 0
	sw $t6, NOTE_INDEX
	jr $ra

check_paddle_left_bound:
    lw $t1, PADDLE_X
    li $t2, 2
    bne $t1, $t2, move_paddle_left
    j game_loop

check_paddle_right_bound:
    lw $t1, PADDLE_X
    li $t2, 52
    bne $t1, $t2, move_paddle_right
    j game_loop

	
detect_paddle:

    addi $sp, $sp, -4
    sw $ra, 0($sp)
    # Check if ball_y is equal to 57
    lw $t0, ball_y
    li $t1, 56
    bne $t0, $t1, exit_detect_paddles

    # Check if ball_x is between paddle_x and paddle_x + 10
    lw $t2, ball_x
    lw $t3, PADDLE_X
    slt $t4, $t2, $t3          # Check if ball_x < paddle_x
    bne $t4, $zero, exit_detect_paddles

    addi $t3, $t3, 10          # Calculate paddle_x + 10
    slt $t4, $t3, $t2          # Check if ball_x > paddle_x + 10
    bne $t4, $zero, exit_detect_paddles

   jal make_beep1
    # If ball_x is between paddle_x and paddle_x + 10 and ball_y = 57, set ball_v to 0
    li $t5, 0
    sw $t5, ball_v

exit_detect_paddles:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


detect_walls:
    # Check if ball_x is less than 3
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, ball_x
    li $t1, 3
    slt $t2, $t0, $t1		#check if ball_x is less than 3
    bne $t2, $zero, change_ball_h_to_1		#change ball_h if condition matches

    # Check if ball_x is greater than 62
    li $t1, 59
    slt $t2, $t1, $t0
    bne $t2, $zero, change_ball_h_to_0

check_ball_y:
    # Check if ball_y is less than 3
    lw $t0, ball_y
    li $t1, 3
    slt $t2, $t0, $t1
    bne $t2, $zero, change_ball_v_to_1

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

change_ball_h_to_1:
    li $t3, 1
    sw $t3, ball_h
    jal make_beep1
    j check_ball_y

change_ball_h_to_0:
    li $t3, 0
    sw $t3, ball_h
    jal make_beep1
    j check_ball_y

change_ball_v_to_1:
    li $t3, 1
    sw $t3, ball_v
    jal make_beep1
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
change_ball_v_to_0:
    li $t3, 0
    sw $t3, ball_v
    jr $ra

move_paddle_left:
    jal erase_paddle
    lw $t1, PADDLE_X
    subi $t1, $t1, 2
    sw $t1, PADDLE_X

    jal draw_paddle
    j game_loop

move_paddle_right:
    jal erase_paddle
    lw $t1, PADDLE_X
    addi $t1, $t1, 2
    sw $t1, PADDLE_X

    jal draw_paddle
    j game_loop


### Erase and redraw ball in location, check game over as well
move_ball:
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	
	jal erase_ball
	
	jal update_ball_x
	jal update_ball_y
	
	#check if ball reaches bottom of the screen
	addi $t9, $zero, 62
	lw $t8, ball_y
	bgt $t8, $t9, decrement_lives
	
	jal draw_ball
	
	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	jr $ra   

###update_ball_x, decrement_ball_x
###load ball_h and ball_x and use it to determine new x-pos
update_ball_x:
    lw $t2, ball_h
    lw $t5, ball_x
    beq $t2, 0, decrement_ball_x
    addi $t5, $t5, 1
    sw $t5, ball_x
    jr $ra

decrement_ball_x:
    subi $t5, $t5, 1
    sw $t5, ball_x
    jr $ra

###update_ball_y, decrement_ball_y
###load ball_v and ball_y and use it to determine new y-pos
update_ball_y:
    lw $t2, ball_v
    lw $t5, ball_y
    beq $t2, 0, decrement_ball_y
    addi $t5, $t5, 1
    sw $t5, ball_y
    jr $ra

decrement_ball_y:
    subi $t5, $t5, 1
    sw $t5, ball_y
    jr $ra
    
###Paint the paddle black - used to simulate movement
erase_paddle:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t5, PADDLE_COLOR        
    sw $t5, PREV_PADDLE_COLOR   

    li $t5, 0                   
    sw $t5, PADDLE_COLOR

    jal draw_paddle             

    lw $t5, PREV_PADDLE_COLOR   
    sw $t5, PADDLE_COLOR        


    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra                      

###Paint the ball black- used to simulate movement
erase_ball:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    lw $t5, BALL_COLOR
    sw $t5, PREV_BALL_COLOR

    li $t5, 0
    sw $t5, BALL_COLOR

    jal draw_ball

    lw $t5, PREV_BALL_COLOR
    sw $t5, BALL_COLOR

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra                      

###pause, pause_done
###Keeps looping infinitely doing nothing but checking if A or D is pressed,
###if so, it resumes the game
pause:
    lw $t1, ADDR_KBRD
    lw $t2, 0($t1)
    lw $t3, KEY_A
    lw $t4, KEY_D
    beq $t2, $t3, pause_done
    beq $t2, $t4, pause_done
    j pause
	
	
pause_done:
	j game_loop

###Control speed of game, and keep track of time limit
delay:
    #give a 50ms delay each game loop	
    li $v0, 32
    li $a0, 50
    syscall

    #Subtract the delay amount each time from TIME_LIMIT,
    #till it reaches 0>, if so end the game
    
    lw $t1, TIME_LIMIT
    sub $t1, $t1, $a0
    blez $t1, END
    sw $t1, TIME_LIMIT
    jr $ra
    

ABSOLUTE_RESET:
    #save $ra on stack	
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    #erase the ball and paddle
    jal erase_paddle
    jal erase_ball
    
    ###  Set
    ###  Paddle_x, ball_x, ball_y, ball_v, ball_h and TIME_LIMIT to initial values
    ###
    li $t1, 52
    sw $t1, PADDLE_X

    li $t1, 32
    sw $t1, ball_x

    li $t1, 31
    sw $t1, ball_y

    li $t1, 1
    sw $t1, ball_h

    li $t1, 0
    sw $t1, ball_v

    li $t1, 60000
    sw $t1, TIME_LIMIT
    
    li $t1, 3
    sw $t1, NUM_LIVES
    
    #bring $ra back and return to caller
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra 

###clear_screen, clear_screen_loop, clear_screen_done
###Paints the entire screen black
clear_screen:
    lw $t0, ADDR_DSPL     # load original display address
    li $t1, 0x00000000    # load color black
    li $t2, 0             # initialize counter

clear_screen_loop:
    li $t3, 4100  # number of pixels to redraw black 
    beq $t2, $t3, clear_screen_done         # if coloring done, finish

    sw $t1, 0($t0)        # set color to black

    addi $t0, $t0, 4      # go to next pixel
    addi $t2, $t2, 1      # increment counter

    j clear_screen_loop   # loop coloring

clear_screen_done:
    jr $ra  

###game_over_paint, game_over_paint_loop, paint_done:
###Loads the pixel locations needed to color white, and colors all of them
game_over_paint:
	la $t4, GAME_OVER_POINTS  	
    	lw $t5, GAME_OVER_POINTS_NUM
    	
game_over_paint_loop:
    beqz $t5, paint_done  

    lw $t0, ADDR_DSPL     

    #load y,x and calculate pixel offset
    lw $t2, 0($t4)        
    lw $t3, 4($t4)        
	
    sll $t2, $t2, 8       
    sll $t3, $t3, 2       
    # add offset to original display
    add $t1, $t0, $t2     
    add $t1, $t1, $t3     
    #paint the pixel white
    li $t6, 0xFFFFFFFF    
    sw $t6, 0($t1)        
    #go to next y,x location
    addi $t4, $t4, 8
    addi $t5, $t5, -1

    j game_over_paint_loop

#go back to caller
paint_done:
    jr $ra  

decrement_lives:

    lw $t9, NUM_LIVES
    beq $t9, $zero, END
    subi $t9, $t9, 1
    li $t8, 0
    sw $t8, MY_PINK
    jal draw_1heart   # Call the draw_1heart function
    lw $t8, MY_PINK2
    sw $t8, MY_PINK     # Store the value 0xF81894 in the memory location pointed by MY_PINK
    sw $t9, NUM_LIVES  # Store the updated value of NUM_LIVES back to memory
    
reset_ball_loc:
    li $t7, 31
    li $t6, 30
    sw $t7, ball_x
    sw $t6, ball_y
    jal draw_1heart
    j game_loop        # Jump to the game_loop

### Goes to Game Over and waits for Key Press
END:

    jal clear_screen
    jal game_over_paint
    lw $t1, ADDR_KBRD

wait_for_r:

    #if T pressed, Terminate Program
    lw $t2, KEY_T
    lw $t3, 0($t1)
    beq $t2, $t3, QUIT_PROGRAM
    
    #if R pressed, Reset entire Game
    lw $t2, KEY_R
    lw $t3, 0($t1)
    bne $t3, $t2, wait_for_r
 	
    jal ABSOLUTE_RESET
    j main
    
###Terminates Program
QUIT_PROGRAM:
    li $v0, 10 
    syscall
