.data

matrix: .space 10000

space: .asciiz" "
enter: .asciiz"\n"

.macro getindex(%ans, %i, %j, %column)
	mult %i, %column
	mflo %ans
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro

.text

################
# input matrix #
################

li $v0, 5							# $s0 = row
syscall
move $s0, $v0

li $v0, 5							# $s1 = column
syscall
move $s1, $v0

li $t0, 0							# i = 0
input_i_begin:
beq $t0, $s0, input_i_end
	
	li $t1, 0						# j = 0
	input_j_begin:
	beq $t1, $s1, input_j_end
	
	li $v0, 5						# $t2 = integer
	syscall
	move $t2, $v0
	
	getindex($t3, $t0, $t1, $s1)	# save integer to matrix[i * column + j]
	sw $t2 matrix($t3)
	
	addi $t1, $t1, 1				# j ++
	j input_j_begin
	
	input_j_end:
	
	
addi $t0, $t0, 1					# i ++
j input_i_begin

input_i_end:

###################################################################
# output nonzero matrix and its row and column with reverse order #
###################################################################

move $t0, $s0
output_i_begin:
beq $t0, $0, output_i_end

	move $t1, $s1
	output_j_begin:
	beq $t1, $0, output_j_end
	
	addi $t2, $t0, -1
	addi $t3, $t1, -1
	getindex($t4, $t2, $t3, $s1)
	lw $t5 matrix($t4)
	
	beq $t5, $0, skip
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $t5
	syscall
	
	la $a0, enter
	li $v0, 4
	syscall
	
	skip:
	
	addi $t1, $t1, -1
	j output_j_begin
	output_j_end:

addi $t0, $t0, -1
j output_i_begin
output_i_end:

li $v0, 10
syscall


