.data
factorial: .space 1000
carry: .space 1000

.text
li $s1, 1
li $s7, 1						# forgotten
li $s6, 1000000
sw $s7, factorial+0
li $v0, 5
syscall
move $s0, $v0

addi $s5, $s0, 1

li $t0, 1
for_i_begin:
beq $t0, $s5, for_i_end
	li $t2, 0
	for_k_begin:
	beq $t2, $s1, for_k_end
	sll $t3, $t2, 2
	sw $0, carry($t3)
	addi $t2, $t2, 1
	j for_k_begin
	for_k_end:
	
	li $t1, 0
	for_j_begin:
	beq $t1, $s1, for_j_end
	sll $t3, $t1, 2
	lw $t4, factorial($t3)
	mult $t4, $t0
	mflo $t4
	lw $t5, carry($t3)
	add $t4, $t4, $t5
	sw $t4, factorial($t3)
	bgt $s6, $t4, next1
	addi $t6, $t1, 1
	sll $t6, $t6, 2
	div $t4, $s6
	mflo $t7
	sw $t7, carry($t6)
	mfhi $t8
	sw $t8, factorial($t3)
	next1:
	sll $t3, $s1, 2
	lw $t4, carry($t3)
	bgt $t4, $0, next2
	next3:
	addi $t1, $t1, 1
	j for_j_begin
	for_j_end:
addi $t0, $t0, 1
j for_i_begin
for_i_end:
#################
addi $t3, $s1, -1
sll $t3, $t3, 2
lw $t4, factorial($t3)
move $a0, $t4
li $v0, 1
syscall

addi $t0, $s1, -2
for_begin:
beq $t0, -1, for_end

sll $t3, $t0, 2
lw $t4, factorial($t3)				# all $t3 change into $t4
bgt $t4, 9, two_num
	li $t1, 0
	zero5_begin:
	beq $t1, 5, zero5_end
	li $a0, 48
	li $v0, 11
	syscall
	addi $t1, $t1, 1
	j zero5_begin
	zero5_end:
j next
two_num:
bgt $t4, 99, three_num
	li $t1, 0
	zero4_begin:
	beq $t1, 4, zero4_end
	li $a0, 48
	li $v0, 11
	syscall
	addi $t1, $t1, 1
	j zero4_begin
	zero4_end:
j next
three_num:
bgt $t4, 999, four_num
	li $t1, 0
	zero3_begin:
	beq $t1, 3, zero3_end
	li $a0, 48
	li $v0, 11
	syscall
	addi $t1, $t1, 1
	j zero3_begin
	zero3_end:
j next
four_num:
bgt $t4, 9999, five_num
	li $t1, 0
	zero2_begin:
	beq $t1, 2, zero2_end
	li $a0, 48
	li $v0, 11
	syscall
	addi $t1, $t1, 1
	j zero2_begin
	zero2_end:
j next
five_num:
bgt $t4, 99999, six_num
	li $t1, 0
	zero1_begin:
	beq $t1, 1, zero1_end
	li $a0, 48
	li $v0, 11
	syscall
	addi $t1, $t1, 1
	j zero1_begin
	zero1_end:
j next
six_num:
next:
move $a0, $t4
li $v0, 1							# 5 change into 1
syscall

addi $t0, $t0, -1					# 1 change into -1
j for_begin
for_end:

li $v0, 10
syscall
###################
next2:
addi $s1, $s1, 1
j next3

# $s0 n
# $s1 digit
# $s6 1000000
# $s7 1
# $t0 i
# $t1 j
# $t2 k