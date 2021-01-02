.data
matrix1: .space 256
matrix2: .space 256
ans: .space 256

.macro getindex(%ans, %i, %j)
sll %ans, %i, 3
add %ans, %ans, %j
sll %ans, %ans, 2
.end_macro

.text
li $v0, 5
syscall
move $s0, $v0

li $t0, 0
read1_i_begin:
beq $t0, $s0, read1_i_end
	li $t1, 0
	read1_j_begin:
	beq $t1, $s0, read1_j_end
	
	li $v0, 5
	syscall
	move $t3, $v0
	getindex($t2, $t0, $t1)
	sw $t3, matrix1($t2)
	
	addi $t1, $t1, 1
	j read1_j_begin
	read1_j_end:
addi $t0, $t0, 1
j read1_i_begin
read1_i_end:

li $t0, 0
read2_i_begin:
beq $t0, $s0, read2_i_end
	li $t1, 0
	read2_j_begin:
	beq $t1, $s0, read2_j_end
	
	li $v0, 5
	syscall
	move $t3, $v0
	getindex($t2, $t0, $t1)
	sw $t3, matrix2($t2)
	
	addi $t1, $t1, 1
	j read2_j_begin
	read2_j_end:
addi $t0, $t0, 1
j read2_i_begin
read2_i_end:

li $t0, 0
mul_i_begin:
beq $t0, $s0, mul_i_end
	li $t1, 0
	mul_j_begin:
	beq $t1, $s0, mul_j_end
		li $s1, 0
		li $s2, 0
		getindex($s1, $t0, $t1)
		
		li $t2, 0
		mul_k_begin:
		beq $t2, $s0, mul_k_end
		
		getindex($t3, $t0, $t2)
		getindex($t4, $t2, $t1)
		lw $t5, matrix1($t3)
		lw $t6, matrix2($t4)
		mult $t5, $t6
		mflo $t7
		add $s2, $s2, $t7
		
		addi $t2, $t2, 1
		j mul_k_begin
		mul_k_end:
		
		sw $s2, ans($s1)
	
	addi $t1, $t1, 1
	j mul_j_begin
	mul_j_end:
addi $t0, $t0, 1
j mul_i_begin
mul_i_end:

li $t0, 0
output_i_begin:
beq $t0, $s0, output_i_end
	li $t1, 0
	output_j_begin:
	beq $t1, $s0, output_j_end
	
	getindex($t2, $t0, $t1)
	lw $a0, ans($t2)
	li $v0, 1
	syscall
	
	li $a0, 32
	li $v0, 11
	syscall
	
	addi $t1, $t1, 1
	j output_j_begin
	output_j_end:
	
	
	li $a0, 10
	li $v0, 11
	syscall

	
addi $t0, $t0, 1
j output_i_begin
output_i_end:

li $v0, 10
syscall

# $s0 storage n
# $s1 storage index of input (cyclic)
# $s2 storage value of input (cyclic)
