.data
maze: .space 256
visit: .space 256

.macro getindex(%ans, %i, %j)
sll %ans, %i, 3
add %ans, %ans, %j
sll %ans, %ans, 2
.end_macro

.text
####################################
li $s0, 1

li $v0, 5
syscall
move $s1, $v0
li $v0, 5
syscall
move $s2, $v0

li $t0, 0
read_i_begin:
beq $t0, $s1, read_i_end
	li $t1, 0
	read_j_begin:
	beq $t1, $s2, read_j_end
	
	li $v0, 5
	syscall
	getindex($t2, $t0, $t1)
	sw $v0, maze($t2)
	
	addi $t1, $t1, 1
	j read_j_begin
	read_j_end:
addi $t0, $t0, 1
j read_i_begin
read_i_end:

li $v0, 5
syscall
addi $s3, $v0, -1
li $v0, 5
syscall
addi $s4, $v0, -1
li $v0, 5
syscall
addi $s5, $v0, -1
li $v0, 5
syscall
addi $s6, $v0, -1
####################################
move $a0, $s3
move $a1, $s4
jal dfs

move $a0, $s7
li $v0, 1
syscall

li $v0, 10
syscall
####################################
dfs:
move $t8, $a0 # $t8 need
move $t9, $a1 # $t9 need

blt $t8, $0, false
bgt $t8, $s1, false
beq $t8, $s1, false
blt $t9, $0, false
bgt $t9, $s2, false
beq $t9, $s2, false
getindex($t3, $t8, $t9)			# two branches forgotten
lw $t5, maze($t3)
lw $t6, visit($t3)
beq $t5, 1, false
beq $t6, 1, false

bne $t8, $s5, recursion
bne $t9, $s6, recursion
true:
addi $s7, $s7, 1
jr $ra							# forgotten

recursion:
getindex($t0, $t8, $t9) # $t0 need
sw $s0, visit($t0)
##################
sw $ra, 0($sp)
subi $sp, $sp, 4
sw $t8, 0($sp)
subi $sp, $sp, 4
sw $t9, 0($sp)
subi $sp, $sp, 4
sw $t0, 0($sp)
subi $sp, $sp, 4

addi $t1, $t9, 1
move $a0, $t8
move $a1, $t1
jal dfs

addi $sp, $sp, 4
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t9, 0($sp)
addi $sp, $sp, 4
lw $t8, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
####################
sw $ra, 0($sp)
subi $sp, $sp, 4
sw $t8, 0($sp)
subi $sp, $sp, 4
sw $t9, 0($sp)
subi $sp, $sp, 4
sw $t0, 0($sp)
subi $sp, $sp, 4

addi $t1, $t9, -1
move $a0, $t8
move $a1, $t1
jal dfs

addi $sp, $sp, 4
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t9, 0($sp)
addi $sp, $sp, 4
lw $t8, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
################
sw $ra, 0($sp)
subi $sp, $sp, 4
sw $t8, 0($sp)
subi $sp, $sp, 4
sw $t9, 0($sp)
subi $sp, $sp, 4
sw $t0, 0($sp)
subi $sp, $sp, 4

addi $t1, $t8, 1
move $a0, $t1
move $a1, $t9
jal dfs

addi $sp, $sp, 4
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t9, 0($sp)
addi $sp, $sp, 4
lw $t8, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
##################
sw $ra, 0($sp)
subi $sp, $sp, 4
sw $t8, 0($sp)
subi $sp, $sp, 4
sw $t9, 0($sp)
subi $sp, $sp, 4
sw $t0, 0($sp)
subi $sp, $sp, 4

addi $t1, $t8, -1
move $a0, $t1
move $a1, $t9
jal dfs

addi $sp, $sp, 4
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t9, 0($sp)
addi $sp, $sp, 4
lw $t8, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
##################
sw $0, visit($t0)
jr $ra

false:
jr $ra







# $s0 1
# $s1 n
# $s2 m
# $s3 sx-1
# $s4 sy-1
# $s5 ex-1
# $s6 ey-1
# $s7 way