.data
matrix: .space 400
core: .space 400

.macro getindex(%ans, %i, %j, %col)
mult %i, %col
mflo %ans
add %ans, %ans, %j
sll %ans, %ans, 2
.end_macro

.text
li $s7, 10

li $v0, 5
syscall
move $s0, $v0
li $v0, 5
syscall
move $s1, $v0
li $v0, 5
syscall
move $s2, $v0
li $v0, 5
syscall
move $s3, $v0
sub $s4, $s0, $s2
addi $s4, $s4, 1
sub $s5, $s1, $s3
addi $s5, $s5, 1



li $t0, 0
read1_i_begin:
beq $t0, $s0, read1_i_end
	li $t1, 0
	read1_j_begin:
	beq $t1, $s1, read1_j_end
	
	getindex($t2, $t0, $t1, $s7)
	li $v0, 5
	syscall
	sw $v0, matrix($t2)
	
	addi $t1, $t1, 1
	j read1_j_begin
	read1_j_end:
addi $t0, $t0, 1
j read1_i_begin
read1_i_end:



li $t0, 0
read2_i_begin:
beq $t0, $s2, read2_i_end
	li $t1, 0
	read2_j_begin:
	beq $t1, $s3, read2_j_end
	
	getindex($t2, $t0, $t1, $s7)
	li $v0, 5
	syscall
	sw $v0, core($t2)
	
	addi $t1, $t1, 1
	j read2_j_begin
	read2_j_end:
addi $t0, $t0, 1
j read2_i_begin
read2_i_end:



li $t0, 0
out_i_begin:
beq $t0, $s4, out_i_end
beq $t0, $0, no_enter
li $a0, 10
li $v0, 11
syscall
no_enter:	
	li $t1, 0
	out_j_begin:
	beq $t1, $s5, out_j_end
	beq $t1, $0, no_space
	li $a0, 32
	li $v0, 11
	syscall
	no_space:
	li $s6, 0
		li $t2, 0
		out_k_begin:
		beq $t2, $s2, out_k_end
			li $t3, 0
			out_l_begin:
			beq $t3, $s3, out_l_end
			
			add $t4, $t0, $t2
			add $t5, $t1, $t3
			getindex($t6, $t4, $t5, $s7)
			getindex($t7, $t2, $t3, $s7)
			lw $t8, matrix($t6)
			lw $t9, core($t7)
			mult $t8, $t9
			mflo $t4
			add $s6, $s6, $t4
			
			addi $t3, $t3, 1
			j out_l_begin
			out_l_end:
		addi $t2, $t2, 1
		j out_k_begin
		out_k_end:
	move $a0, $s6
	li $v0, 1
	syscall
		
	addi $t1, $t1, 1
	j out_j_begin
	out_j_end:
addi $t0, $t0, 1
j out_i_begin
out_i_end:

# $s0 storage m1
# $s1 storage n1
# $s2 storage m2
# $s3 storage n2
# $s4 storage m1-m2+1
# $s5 storage n1-n2+1
# $s6 storage g(i,j) (cyclic)