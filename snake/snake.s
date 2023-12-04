########################################################################
# COMP1521 21T2 -- Assignment 1 -- Snake!
# <https://www.cse.unsw.edu.au/~cs1521/21T2/assignments/ass1/index.html>
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# For instructions, see: https://www.cse.unsw.edu.au/~cs1521/21T2/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by Bryan Le (z5361001)
# on 05/07/2021
#
# Version 1.0 (2021-06-24): Team COMP1521 <cs1521@cse.unsw.edu.au>
#

	# Requires:
	# - [no external symbols]
	#
	# Provides:
	# - Global variables:
	.globl	symbols
	.globl	grid
	.globl	snake_body_row
	.globl	snake_body_col
	.globl	snake_body_len
	.globl	snake_growth
	.globl	snake_tail

	# - Utility global variables:
	.globl	last_direction
	.globl	rand_seed
	.globl  input_direction__buf

	# - Functions for you to implement
	.globl	main
	.globl	init_snake
	.globl	update_apple
	.globl	move_snake_in_grid
	.globl	move_snake_in_array

	# - Utility functions provided for you
	.globl	set_snake
	.globl  set_snake_grid
	.globl	set_snake_array
	.globl  print_grid
	.globl	input_direction
	.globl	get_d_row
	.globl	get_d_col
	.globl	seed_rng
	.globl	rand_value


########################################################################
# Constant definitions.

N_COLS          = 15
N_ROWS          = 15
MAX_SNAKE_LEN   = N_COLS * N_ROWS

EMPTY           = 0
SNAKE_HEAD      = 1
SNAKE_BODY      = 2
APPLE           = 3

NORTH       = 0
EAST        = 1
SOUTH       = 2
WEST        = 3


########################################################################
# .DATA
	.data

# const char symbols[4] = {'.', '#', 'o', '@'};
symbols:
	.byte	'.', '#', 'o', '@'

	.align 2
# int8_t grid[N_ROWS][N_COLS] = { EMPTY };
grid:
	.space	N_ROWS * N_COLS

	.align 2
# int8_t snake_body_row[MAX_SNAKE_LEN] = { EMPTY };
snake_body_row:
	.space	MAX_SNAKE_LEN

	.align 2
# int8_t snake_body_col[MAX_SNAKE_LEN] = { EMPTY };
snake_body_col:
	.space	MAX_SNAKE_LEN

# int snake_body_len = 0;
snake_body_len:
	.word	0

# int snake_growth = 0;
snake_growth:
	.word	0

# int snake_tail = 0;
snake_tail:
	.word	0

# Game over prompt, for your convenience...
main__game_over:
	.asciiz	"Game over! Your score was "


########################################################################
#
# Your journey begins here, intrepid adventurer!
#
# Implement the following 6 functions, and check these boxes as you
# finish implementing each function
#
#  - [X] main
#  - [X] init_snake
#  - [X] update_apple
#  - [X] update_snake
#  - [X] move_snake_in_grid
#  - [X] move_snake_in_array
#



########################################################################
# .TEXT <main>
	.text
main:

	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    $ra, $s0, $s1
	# Uses:	    $a0, $v0, $s0, $s1, $t0, $t1
	# Clobbers: $a0, $v0, $t0, $t1
	#
	# Locals:
	#   - 'direction' and 'score' 	in $a0.
	#   - 'direction' 		in $s0.
	#   - 'score' 			in $s1.
	#   - 'snake_body_len' 		in $t0.
	#   - '3' 			in $t1.
	#
	# Structure:
	#   main
	#   -> [prologue]
	#   -> body
	#      -> main__body_do_loop
	#      -> main__body_print
	#   -> [epilogue]

	# Code:
main__prologue:
	# set up stack frame
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw 	$s0, 4($sp)
	sw 	$s1,  ($sp)

main__body:
	# Initially, set snake and apple.
	jal	init_snake		# init_snake()
	jal 	update_apple		# update_apple()

main__body_do_loop:
	# If input entered is valid, print grid and move snake.
					# do {
	jal 	print_grid		# print_grid()
	jal	input_direction		# direction = input_direction()
	move 	$s0, $v0
	move	$a0, $s0
	jal 	update_snake		# update_snake(direction)
	bnez 	$v0, main__body_do_loop	# } while (update_snake(direction));
					# goto main__do_loop

main__body_print:
	# When game-over is triggered, print game-over message and score. 
	li   	$v0, 5         		# scanf("%d", score);
	syscall
	move 	$s1, $v0		# $s1 = score

	lw 	$t0, snake_body_len	# $t0 = snake_body_len
	li 	$t1, 3			# $t1 = 3
	div 	$s1, $t0, $t1		# score = snake_body_len / 3

	la   	$a0, main__game_over    # printf("Game over! Your score was ");
	li   	$v0, 4
	syscall

	move	$a0, $s1		# printf("%d", score);
	li   	$v0, 1
	syscall

	li 	$a0, '\n'		# printf("%c", '\n');
	li 	$v0, 11
	syscall

main__epilogue:
	# tear down stack frame
	lw 	$s1,  ($sp)
	lw	$s0, 4($sp)
	lw	$ra, 8($sp)
	addiu 	$sp, $sp, 12

	li	$v0, 0
	jr	$ra			# return 0;


########################################################################
# .TEXT <init_snake>
	.text
init_snake:

	# Args:     void
	# Returns:  void
	#
	# Frame:    $ra
	# Uses:     $a0, $a1, $a2, $v0
	# Clobbers: $a0, $a1, $a2, $v0
	#
	# Locals:
	#   - '7' 				in $a0.
	#   - '7','6','5','4' 			in $a1.
	#   - 'SNAKE_HEAD' and 'SNAKE_BODY' 	in $a2.
	#
	# Structure:
	#   init_snake
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

	# Code:
init_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

init_snake__body:
	# Set the snake's initial location
	li 	$a0, 7			
	li 	$a1, 7			
	li 	$a2, SNAKE_HEAD		
	jal 	set_snake		# set_snake(7, 7, SNAKE_HEAD);

	li 	$a0, 7
	li 	$a1, 6
	li 	$a2, SNAKE_BODY
	jal 	set_snake		# set_snake(7, 6, SNAKE_BODY);

	li 	$a0, 7
	li 	$a1, 5
	li 	$a2, SNAKE_BODY
	jal 	set_snake		# set_snake(7, 5, SNAKE_BODY);

	li 	$a0, 7
	li 	$a1, 4
	li 	$a2, SNAKE_BODY
	jal 	set_snake		# set_snake(7, 4, SNAKE_BODY);

init_snake__epilogue:
	# tear down stack frame
	lw	$ra, ($sp)
	addiu 	$sp, $sp, 4

	jr	$ra			# return;


########################################################################
# .TEXT <update_apple>
	.text
update_apple:

	# Args:     void
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1
	# Uses:     $a0, $v0, $s0, $s1, $t0, $t1, $t2
	# Clobbers: $a0, $v0, $t0, $t1
	#
	# Locals:
	#   - 'N_ROWS' and 'N_COLS' 			in $a0.
	#   - 'apple_row' 				in $s0.
	#   - 'apple_col' 				in $s1.
	#   - 'N_COLS' and "&apple"			in $t0.
	#   - 'grid[apple_row][apple_col]' and 'APPLE' 	in $t1.
	#   - 'EMPTY' 					in $t2.
	#
	# Structure:
	#   update_apple
	#   -> [prologue]
	#   -> body
	#      -> update_apple__body_do_loop
	#      -> update_apple__body_do_loop_end
	#   -> [epilogue]

	# Code:
update_apple__prologue:
	# set up stack frame
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1,  ($sp)

update_apple__body_do_loop:
	# Randomise new location for apple.
							# do {
	li 	$a0, N_ROWS				
	jal 	rand_value				# 	      rand_value(N_ROWS);
	move 	$s0, $v0				# apple_row = rand_value(N_ROWS);

	li 	$a0, N_COLS
	jal 	rand_value				#	      rand_value(N_COLS);
	move 	$s1, $v0				# apple_col = rand_value(N_COLS);

	# Finding random new location to place apple.
	li	$t0, N_COLS				
	mul	$t0, $t0, $s0				#         15 * apple_row
	add	$t0, $t0, $s1				#        (15 * apple_row) + apple_col
	lb 	$t1, grid($t0)				#   grid[(15 * apple_row) + apple_col]
							
	li 	$t2, EMPTY		

	bne	$t1, $t2, update_apple__body_do_loop	#  } while (grid[apple_row][apple_col] != EMPTY);
							#  goto update_apple__body_do_loop

update_apple__body_do_loop_end:
	# Replace random new location with apple.
	li 	$t1, APPLE				
	sb 	$t1, grid($t0)				#   grid[apple_row][apple_col] = APPLE;

update_apple__epilogue:
	# tear down stack frame
	lw 	$s1,  ($sp)
	lw 	$s0, 4($sp)
	lw	$ra, 8($sp)
	addiu 	$sp, $sp, 12

	jr	$ra					# return;



########################################################################
# .TEXT <update_snake>
	.text
update_snake:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: bool
	#
	# Frame:    $ra, $s0, $s1, $s2, $s3, $s4
	# Uses:     $a0, $a1, $v0, $s0, $s1, $s2, $s3, $s4, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8
	# Clobbers: $a0, $v0, $t0, $t1, $t2, $t3, $t4, $t7, $t8
	#
	# Locals:
	#   - 'direction' and 'new_head_row' 			in $a0.
	#   - 'new_head_col'      	     			in $a1.
	#   - 'd_row' 	     		     			in $s0.
	#   - 'd_col'        		     			in $s1.
	#   - 'new_head_row' 		     			in $s2.
	#   - 'new_head_col' 		     			in $s3.
	#   - 'apple'        		     			in $s4.
#   - 'snake_body_row' and 'N_ROWS'  				in $t0.
#   - 'snake_body_col' and 'N_COLS'  				in $t1.
	#   - 'N_COLS' and "&grid[head_row][head_col]"	 	in $t2.
	#   - 'grid[head_row][head_col]' and 'SNAKE_BODY'    	in $t3.
	#   - 'N_COLS' and "&grid[new_head_row][new_head_col]" 	in $t4.
	#   - 'grid[new_head_row][new_head_col]' 		in $t5.
	#   - 'APPLE'			     			in $t6.
	#   - 'snake_body_len' and 'snake_tail'		     	in $t7.
	#   - 'snake_growth'		     			in $t8.
	#
	# Structure:
	#   update_snake
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]
	#      -> update_snake__return_true_epilogue
	#      -> update_snake__return_false_epilogue

	# Code:
update_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -24
	sw	$ra, 20($sp)
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2,  8($sp)
	sw	$s3,  4($sp)
	sw	$s4,   ($sp)

update_snake__body:
	# Argument of the function is already 'direction' so no need to pass into $a registers.
	# Get direction from input.
	jal 	get_d_row					# 	      get_d_row(direction)
	move 	$s0, $v0					# int d_row = get_d_row(direction)

	jal	get_d_col					# 	      get_d_col(direction);
	move 	$s1, $v0					# int d_col = get_d_col(direction);

	lb 	$t0, snake_body_row				# int head_row = snake_body_row[0];
	lb 	$t1, snake_body_col				# int head_col = snake_body_col[0];

	# When snake moved, replace old head with SNAKE_BODY
	li	$t2, N_COLS					
	mul	$t2, $t2, $t0					#         15 * head_row
	add	$t2, $t2, $t1					#        (15 * head_row) + head_col
	lb 	$t3, grid($t2)					#   grid[(15 * head_row) + head_col]
	li 	$t3, SNAKE_BODY
	sb 	$t3, grid($t2)					#   grid[head_row][head_col] = SNAKE_BODY;
	
	# Calculate new head. 
	add	$s2, $t0, $s0					# int new_head_row = head_row + d_row;
	add 	$s3, $t1, $s1					# int new_head_col = head_col + d_col;

	# Trigger game-over when snake goes off the edges of the grid.
	li 	$t0, N_ROWS					
	li 	$t1, N_COLS					
	bltz	$s2, update_snake__return_false_epilogue	# if (new_head_row < 0)       return false;
	bge	$s2, $t0, update_snake__return_false_epilogue	# if (new_head_row >= N_ROWS) return false;
	bltz	$s3, update_snake__return_false_epilogue	# if (new_head_col < 0)       return false;
	bge	$s3, $t1, update_snake__return_false_epilogue	# if (new_head_col >= N_COLS) return false;

	# Accessing grid for snake eating apple.
	li 	$t4, N_COLS					
	mul	$t4, $t4, $s2					#         15 * new_head_row
	add	$t4, $t4, $s3					#        (15 * new_head_row) + new_head_col
	lb 	$t5, grid($t4)					#   grid[(15 * new_head_row) + new_head_col]
	li 	$t6, APPLE					
	seq 	$s4, $t5, $t6					# apple = (grid[new_head_row][new_head_col] == APPLE);
	# If the index in grid is APPLE, then comparison is true and returns 1. Therefore, apple = 1.

	lw 	$t7, snake_body_len				# $t7 = snake_body_len
	sub 	$t7, $t7, 1					
	sw 	$t7, snake_tail					# snake_tail = snake_body_len - 1

	# If snake eats itself, trigger game-over.
	move 	$a0, $s2		
	move 	$a1, $s3
	jal 	move_snake_in_grid				# move_snake_in_grid(new_head_row, new_head_col)
	beqz	$v0, update_snake__return_false_epilogue	# if (! move_snake_in_grid(new_head_row, new_head_col)) {
								# return false.
	jal 	move_snake_in_array 				# move_snake_in_array(new_head_row, new_head_col);
	
	# When apple is consumed, snake grows by 3 and apple is placed in a new randomised location.
	beqz	$s4, update_snake__return_true_epilogue		# if (apple) {
	lw 	$t8, snake_growth				
	addi 	$t8, $t8, 3					
	sw	$t8, snake_growth				# snake_growth += 3;
	jal 	update_apple					# update_apple();

update_snake__return_true_epilogue:
	# tear down stack frame
	lw	$s4,   ($sp)
	lw	$s3,  4($sp)
	lw	$s2,  8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	lw	$ra, 20($sp)
	addiu 	$sp, $sp, 24

	li	$v0, 1
	jr	$ra						# return true;

update_snake__return_false_epilogue:
	# tear down stack frame
	lw	$s4,   ($sp)
	lw	$s3,  4($sp)
	lw	$s2,  8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	lw	$ra, 20($sp)
	addiu 	$sp, $sp, 24

	li	$v0, 0
	jr	$ra						# return false;


########################################################################
# .TEXT <move_snake_in_grid>
	.text
move_snake_in_grid:

	# Args:
	#   - $a0: new_head_row
	#   - $a1: new_head_col
	# Returns:
	#   - $v0: bool
	#
	# Frame:    $ra, $s0, $s1
	# Uses:     $a0, $a1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8 
	# Clobbers: $a0, $a1, $t0, $t1, $t2, $t6, $t7
	#
	# Locals:
	#   - 'new_head_row' 					 	in $a0.
	#   - 'new_head_col' 					 	in $a1.
	#   - 'snake_growth' 					 	in $t0.
	#   - 'snake_tail' 					 	in $t1.
	#   - 'snake_body_len' 					 	in $t2.
	#   - 'tail' 						 	in $t3.
	#   - 'tail_row' 					 	in $t4.
	#   - 'tail_col' 					 	in $t5
	#   - 'N_COLS' and "&grid[new_head_row][new_head_col]"
	#      and "&grid[tail_row][tail_col]" 		 		in $t6.
	#   - 'grid[tail_row][tail_col]' and 'EMPTY' and 
	#     'grid[new_head_row][new_head_col] and 'SNAKE_HEAD' 	in $t7.
	#   - 'SNAKE_BODY' 					 	in $t8.
	#
	# Structure:
	#   move_snake_in_grid
	#   -> [prologue]
	#   -> body
	#      -> move_snake_in_grid__body_snake_growth_else
	#      -> move_snake_in_grid__body_snake_growth_else_end
	#   -> [epilogue]
	#      -> move_snake_in_grid__epilogue_return_true
	#      -> move_snake_in_grid__epilogue_return_false

	# Code:
move_snake_in_grid__prologue:
	# set up stack frame
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

move_snake_in_grid__body:
	# Grow the snake.
	lw 	$t0, snake_growth				
	blez	$t0, move_snake_in_grid__body_snake_growth_else		# if (snake_growth <= 0) goto move_snake_in_grid__body_growth_else
								
	lw 	$t1, snake_tail					
	addi 	$t1, $t1, 1
	sw 	$t1, snake_tail						# snake_tail++;

	lw	$t2, snake_body_len
	addi 	$t2, $t2, 1
	sw 	$t2, snake_body_len					# snake_body_len++;

	addi	$t0, $t0, -1
	sw	$t0, snake_growth					# snake_growth--;

	j 	move_snake_in_grid__body_snake_growth_else_end	
move_snake_in_grid__body_snake_growth_else:
	# If snake is not growing but moved then replace old tail with EMPTY.
	lw 	$t1, snake_tail				       		
	move	$t3, $t1						# int tail = snake_tail
	lb 	$t4, snake_body_row($t3)				# int tail_row = snake_body_row[tail];
	lb 	$t5, snake_body_col($t3)				# int tail_col = snake_body_col[tail];

	li	$t6, N_COLS						#          15 * tail_row
	mul	$t6, $t6, $t4						#         (15 * tail_row) + tail_col
	add	$t6, $t6, $t5						#    grid[(15 * tail_row) + tail_col]	
	lb 	$t7, grid($t6)
	li 	$t7, EMPTY		
	sb 	$t7, grid($t6)						#    grid[tail_row][tail_col] = EMPTY;

move_snake_in_grid__body_snake_growth_else_end:
	# If the new head is the same as snake's body, then snake has eaten itself and trigger game-over.
	li	$t6, N_COLS						#          15 * new_head_row
	mul	$t6, $t6, $a0						#         (15 * new_head_row) + new_head_col
	add	$t6, $t6, $a1						#    grid[(15 * new_head_row) + new_head_col]		
	lb 	$t7, grid($t6)
	li 	$t8, SNAKE_BODY					

	beq 	$t7, $t8, move_snake_in_grid__epilogue_return_false	# if(grid[(15 * new_head_row) + new_head_col] == SNAKE_BODY) {
									# goto move_snake_in_grid__epilogue_false
	# When moved, insert a new head for the snake.
	li 	$t7, SNAKE_HEAD
	sb 	$t7, grid($t6)						#    grid[(15 * new_head_row) + new_head_col] = SNAKE_HEAD

move_snake_in_grid__epilogue_return_true:
	# tear down stack frame
	lw	$ra, ($sp)
	addiu 	$sp, $sp, 4

	li	$v0, 1
	jr	$ra							# return true;

move_snake_in_grid__epilogue_return_false:
	# tear down stack frame
	lw	$ra, ($sp)
	addiu 	$sp, $sp, 4

	li 	$v0, 0							# return false;
	jr 	$ra


########################################################################
# .TEXT <move_snake_in_array>
	.text
move_snake_in_array:

	# Arguments:
	#   - $a0: int new_head_row
	#   - $a1: int new_head_col
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1, $s2
	# Uses:     $a0, $a1, $a2, $v0, $s0, $s1, $s2, $t0, $t1, $t2, $t3
	# Clobbers: $a0, $a1, $a2
	#
	# Locals:
	#   - 'new_head_row' and 'snake_body_row[i - 1]' in $a0.
	#   - 'new_head_col' and 'snake_body_col[i - 1]' in $a1.
	#   - 'i' and '0' 				 in $a2.
	#   - 'new_head_row' 				 in $s0.
	#   - 'new_head_col' 				 in $s1.
	#   - 'i' 					 in $s2.
	#   - 'snake_tail' 				 in $t0.
	#   - 'i - 1' 					 in $t1.
	#   - 'snake_body_row(i - 1)' 			 in $t2.
	#   - 'snake_body_col(i - 1)' 			 in $t3.
	# Structure:
	#   move_snake_in_array
	#   -> [prologue]
	#   -> body
	#      -> move_snake_in_array_for_loop
	#      -> move_snake_in_array__body_set_snake_array_call2
	#   -> [epilogue]

	# Code:
move_snake_in_array__prologue:
	# set up stack frame
	addiu	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw 	$s0,  8($sp)
	sw 	$s1,  4($sp)
	sw	$s2,   ($sp)

move_snake_in_array__body:
	move 	$s0, $a0						# new_head_row
	move 	$s1, $a1						# new_head_col

move_snake_in_array_for_loop:
	# Updates records of entire snake body when head has been moved to new location.
	lw 	$t0, snake_tail						#         snake_tail
	move 	$s2, $t0						# int i = snake_tail
	blt	$s2, 1, move_snake_in_array__body_set_snake_array_call2 # for(i < 1) {
									# goto move_snake_in_array__body_set_snake_array_call2

	sub 	$t1, $s2, 1						#  			 i - 1
	lb	$t2, snake_body_row($t1)				# int x = snake_body_row(i - 1)
	lb 	$t3, snake_body_col($t1)				# int y = snake_body_row(i - 1)

	move	$a0, $t2						# Move the variables into
	move	$a1, $t3						# arguments for the function call.
	move	$a2, $s2
	jal 	set_snake_array						# set_snake_array(snake_body_row[i - 1], snake_body_col[i - 1], i);
	addi 	$s2, $s2, -1						
	sw 	$s2, snake_tail						# i--;
	j 	move_snake_in_array_for_loop				# goto move_snake_in_array_for_loop

move_snake_in_array__body_set_snake_array_call2:
	move 	$a0, $s0						# Move the arguments in $s registers 
	move 	$a1, $s1						# into $a registers for the function call.
	li 	$a2, 0
	jal 	set_snake_array						# set_snake_array(new_head_row, new_head_col, 0);

move_snake_in_array__epilogue:
	# tear down stack frame
	lw 	$s2,   ($sp)
	lw	$s1,  4($sp)
	lw 	$s0,  8($sp)
	lw	$ra, 12($sp)
	addiu 	$sp, $sp, 16

	jr	$ra							# return;


########################################################################
####                                                                ####
####        STOP HERE ... YOU HAVE COMPLETED THE ASSIGNMENT!        ####
####                                                                ####
########################################################################

##
## The following is various utility functions provided for you.
##
## You don't need to modify any of the following.  But you may find it
## useful to read through --- you'll be calling some of these functions
## from your code.
##

	.data

last_direction:
	.word	EAST

rand_seed:
	.word	0

input_direction__invalid_direction:
	.asciiz	"invalid direction: "

input_direction__bonk:
	.asciiz	"bonk! cannot turn around 180 degrees\n"

	.align	2
input_direction__buf:
	.space	2



########################################################################
# .TEXT <set_snake>
	.text
set_snake:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int body_piece
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1
	# Uses:     $a0, $a1, $a2, $t0, $s0, $s1
	# Clobbers: $t0
	#
	# Locals:
	#   - `int row` in $s0
	#   - `int col` in $s1
	#
	# Structure:
	#   set_snake
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

	# Code:
set_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1,  ($sp)

set_snake__body:
	move	$s0, $a0		# $s0 = row
	move	$s1, $a1		# $s1 = col

	jal	set_snake_grid		# set_snake_grid(row, col, body_piece);

	move	$a0, $s0
	move	$a1, $s1
	lw	$a2, snake_body_len
	jal	set_snake_array		# set_snake_array(row, col, snake_body_len);

	lw	$t0, snake_body_len
	addiu	$t0, $t0, 1
	sw	$t0, snake_body_len	# snake_body_len++;

set_snake__epilogue:
	# tear down stack frame
	lw	$s1,  ($sp)
	lw	$s0, 4($sp)
	lw	$ra, 8($sp)
	addiu 	$sp, $sp, 12

	jr	$ra			# return;



########################################################################
# .TEXT <set_snake_grid>
	.text
set_snake_grid:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int body_piece
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0, $a1, $a2, $t0
	# Clobbers: $t0
	#
	# Locals:   None
	#
	# Structure:
	#   set_snake
	#   -> body

	# Code:
	li	$t0, N_COLS
	mul	$t0, $t0, $a0		#  15 * row
	add	$t0, $t0, $a1		# (15 * row) + col
	sb	$a2, grid($t0)		# grid[row][col] = body_piece;

	jr	$ra			# return;



########################################################################
# .TEXT <set_snake_array>
	.text
set_snake_array:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int nth_body_piece
	# Returns:  void
	#
	# Frame:    Nonee
	# Uses:     $a0, $a1, $a2
	# Clobbers: None
	#
	# Locals:   None
	#
	# Structure:
	#   set_snake_array
	#   -> body

	# Code:
	sb	$a0, snake_body_row($a2)	# snake_body_row[nth_body_piece] = row;
	sb	$a1, snake_body_col($a2)	# snake_body_col[nth_body_piece] = col;

	jr	$ra				# return;



########################################################################
# .TEXT <print_grid>
	.text
print_grid:

	# Args:     void
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $v0, $a0, $t0, $t1, $t2
	# Clobbers: $v0, $a0, $t0, $t1, $t2
	#
	# Locals:
	#   - `int i` in $t0
	#   - `int j` in $t1
	#   - `char symbol` in $t2
	#
	# Structure:
	#   print_grid
	#   -> for_i_cond
	#     -> for_j_cond
	#     -> for_j_end
	#   -> for_i_end

	# Code:
	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# putchar('\n');

	li	$t0, 0			# int i = 0;

print_grid__for_i_cond:
	bge	$t0, N_ROWS, print_grid__for_i_end	# while (i < N_ROWS)

	li	$t1, 0			# int j = 0;

print_grid__for_j_cond:
	bge	$t1, N_COLS, print_grid__for_j_end	# while (j < N_COLS)

	li	$t2, N_COLS
	mul	$t2, $t2, $t0		#                             15 * i
	add	$t2, $t2, $t1		#                            (15 * i) + j
	lb	$t2, grid($t2)		#                       grid[(15 * i) + j]
	lb	$t2, symbols($t2)	# char symbol = symbols[grid[(15 * i) + j]]

	li	$v0, 11			# syscall 11: print_character
	move	$a0, $t2
	syscall				# putchar(symbol);

	addiu	$t1, $t1, 1		# j++;

	j	print_grid__for_j_cond

print_grid__for_j_end:

	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# putchar('\n');

	addiu	$t0, $t0, 1		# i++;

	j	print_grid__for_i_cond

print_grid__for_i_end:
	jr	$ra			# return;



########################################################################
# .TEXT <input_direction>
	.text
input_direction:

	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0, $a1, $t0, $t1
	# Clobbers: $v0, $a0, $a1, $t0, $t1
	#
	# Locals:
	#   - `int direction` in $t0
	#
	# Structure:
	#   input_direction
	#   -> input_direction__do
	#     -> input_direction__switch
	#       -> input_direction__switch_w
	#       -> input_direction__switch_a
	#       -> input_direction__switch_s
	#       -> input_direction__switch_d
	#       -> input_direction__switch_newline
	#       -> input_direction__switch_null
	#       -> input_direction__switch_eot
	#       -> input_direction__switch_default
	#     -> input_direction__switch_post
	#     -> input_direction__bonk_branch
	#   -> input_direction__while

	# Code:
input_direction__do:
	li	$v0, 8			# syscall 8: read_string
	la	$a0, input_direction__buf
	li	$a1, 2
	syscall				# direction = getchar()

	lb	$t0, input_direction__buf

input_direction__switch:
	beq	$t0, 'w',  input_direction__switch_w	# case 'w':
	beq	$t0, 'a',  input_direction__switch_a	# case 'a':
	beq	$t0, 's',  input_direction__switch_s	# case 's':
	beq	$t0, 'd',  input_direction__switch_d	# case 'd':
	beq	$t0, '\n', input_direction__switch_newline	# case '\n':
	beq	$t0, 0,    input_direction__switch_null	# case '\0':
	beq	$t0, 4,    input_direction__switch_eot	# case '\004':
	j	input_direction__switch_default		# default:

input_direction__switch_w:
	li	$t0, NORTH			# direction = NORTH;
	j	input_direction__switch_post	# break;

input_direction__switch_a:
	li	$t0, WEST			# direction = WEST;
	j	input_direction__switch_post	# break;

input_direction__switch_s:
	li	$t0, SOUTH			# direction = SOUTH;
	j	input_direction__switch_post	# break;

input_direction__switch_d:
	li	$t0, EAST			# direction = EAST;
	j	input_direction__switch_post	# break;

input_direction__switch_newline:
	j	input_direction__do		# continue;

input_direction__switch_null:
input_direction__switch_eot:
	li	$v0, 17			# syscall 17: exit2
	li	$a0, 0
	syscall				# exit(0);

input_direction__switch_default:
	li	$v0, 4			# syscall 4: print_string
	la	$a0, input_direction__invalid_direction
	syscall				# printf("invalid direction: ");

	li	$v0, 11			# syscall 11: print_character
	move	$a0, $t0
	syscall				# printf("%c", direction);

	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# printf("\n");

	j	input_direction__do	# continue;

input_direction__switch_post:
	blt	$t0, 0, input_direction__bonk_branch	# if (0 <= direction ...
	bgt	$t0, 3, input_direction__bonk_branch	# ... && direction <= 3 ...

	lw	$t1, last_direction	#     last_direction
	sub	$t1, $t1, $t0		#     last_direction - direction
	abs	$t1, $t1		# abs(last_direction - direction)
	beq	$t1, 2, input_direction__bonk_branch	# ... && abs(last_direction - direction) != 2)

	sw	$t0, last_direction	# last_direction = direction;

	move	$v0, $t0
	jr	$ra			# return direction;

input_direction__bonk_branch:
	li	$v0, 4			# syscall 4: print_string
	la	$a0, input_direction__bonk
	syscall				# printf("bonk! cannot turn around 180 degrees\n");

input_direction__while:
	j	input_direction__do	# while (true);



########################################################################
# .TEXT <get_d_row>
	.text
get_d_row:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0
	# Clobbers: $v0
	#
	# Locals:   None
	#
	# Structure:
	#   get_d_row
	#   -> get_d_row__south:
	#   -> get_d_row__north:
	#   -> get_d_row__else:

	# Code:
	beq	$a0, SOUTH, get_d_row__south	# if (direction == SOUTH)
	beq	$a0, NORTH, get_d_row__north	# else if (direction == NORTH)
	j	get_d_row__else			# else

get_d_row__south:
	li	$v0, 1
	jr	$ra				# return 1;

get_d_row__north:
	li	$v0, -1
	jr	$ra				# return -1;

get_d_row__else:
	li	$v0, 0
	jr	$ra				# return 0;



########################################################################
# .TEXT <get_d_col>
	.text
get_d_col:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0
	# Clobbers: $v0
	#
	# Locals:   None
	#
	# Structure:
	#   get_d_col
	#   -> get_d_col__east:
	#   -> get_d_col__west:
	#   -> get_d_col__else:

	# Code:
	beq	$a0, EAST, get_d_col__east	# if (direction == EAST)
	beq	$a0, WEST, get_d_col__west	# else if (direction == WEST)
	j	get_d_col__else			# else

get_d_col__east:
	li	$v0, 1
	jr	$ra				# return 1;

get_d_col__west:
	li	$v0, -1
	jr	$ra				# return -1;

get_d_col__else:
	li	$v0, 0
	jr	$ra				# return 0;



########################################################################
# .TEXT <seed_rng>
	.text
seed_rng:

	# Args:
	#   - $a0: unsigned int seed
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0
	# Clobbers: None
	#
	# Locals:   None
	#
	# Structure:
	#   seed_rng
	#   -> body

	# Code:
	sw	$a0, rand_seed		# rand_seed = seed;

	jr	$ra			# return;



########################################################################
# .TEXT <rand_value>
	.text
rand_value:

	# Args:
	#   - $a0: unsigned int n
	# Returns:
	#   - $v0: unsigned int
	#
	# Frame:    None
	# Uses:     $v0, $a0, $t0, $t1
	# Clobbers: $v0, $t0, $t1
	#
	# Locals:
	#   - `unsigned int rand_seed` cached in $t0
	#
	# Structure:
	#   rand_value
	#   -> body

	# Code:
	lw	$t0, rand_seed		#  rand_seed

	li	$t1, 1103515245
	mul	$t0, $t0, $t1		#  rand_seed * 1103515245

	addiu	$t0, $t0, 12345		#  rand_seed * 1103515245 + 12345

	li	$t1, 0x7FFFFFFF
	and	$t0, $t0, $t1		# (rand_seed * 1103515245 + 12345) & 0x7FFFFFFF

	sw	$t0, rand_seed		# rand_seed = (rand_seed * 1103515245 + 12345) & 0x7FFFFFFF;

	rem	$v0, $t0, $a0
	jr	$ra			# return rand_seed % n;

