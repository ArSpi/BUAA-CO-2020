.data
symbol: .space 28
array: .space 28

.text
li $s7, 1

li $v0, 5
syscall
move $s0, $v0

move $a0, $0
jal fullarray

li $v0, 10
syscall



fullarray:
move $s1, $a0
bgt $s0, $s1, skip
	li $t0, 0
	print_begin:
	beq $t0, $s0, print_end
	
	sll $t4, $t0, 2
	lw $a0, array($t4)
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	
	addi $t0, $t0, 1
	j print_begin
	print_end:
li $a0, 10
li $v0, 11
syscall
jr $ra

skip:
li $t1, 0
for_begin:
beq $t1, $s0, for_end

sll $t4, $t1, 2
lw $t2, symbol($t4)
bne $t2, $0, next

sll $t5, $s1, 2
addi $t3, $t1, 1
sw $t3, array($t5)
sw $s7, symbol($t4)

sw $ra 0($sp)
subi $sp, $sp, 4
sw $s0, 0($sp)
subi $sp, $sp, 4
sw $s1, 0($sp)
subi $sp, $sp, 4
sw $t1, 0($sp)
subi $sp, $sp, 4

addi $a0, $s1, 1
jal fullarray

addi $sp, $sp, 4
lw $t1, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)

sll $t4, $t1, 2
sw $0, symbol($t4)

next:
addi $t1, $t1, 1
j for_begin
for_end:
jr $ra
# $s0 storage n
# $s1 storage index (need stack)
# $ra need stack
# $s7 storage 1