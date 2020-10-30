.data
matrix: .space 256
visit: .space 32

.macro getindex(%ans, %i, %j)
sll %ans, %i, 3
add %ans, %ans, %j
sll %ans, %ans, 2
.end_macro

.text
li $s7, 1

li $v0, 5
syscall
move $s0, $v0
li $v0, 5
syscall
move $s1, $v0

li $t0, 0
read_begin:
beq $t0, $s1, read_end

li $v0, 5
syscall
move $t1, $v0
li $v0, 5
syscall
move $t2, $v0
beq $t1, $t2, skip_read
getindex($t3, $t1, $t2)
getindex($t4, $t2, $t1)
sw $s7, matrix($t3)
sw $s7, matrix($t4)
skip_read:
addi $t0, $t0, 1
j read_begin
read_end:

bne $s0, $s7, search
li $s5, 1
j output
search:
li $s2, 1
li $s3, 1
li $s4, 1
sw $s7, visit+4
move $a0, $s3
move $a1, $s4
jal findroad
move $s5, $v0

output:
move $a0, $s5
li $v0, 1
syscall

li $v0, 10
syscall

findroad:
move $s3, $a0
move $s4, $a1
bne $s2, $s0, recursion
getindex($t3, $s3, $s7)
lw $t4, matrix($t3)
bne $t4, $s7, return_0
li $v0, 1
jr $ra
return_0:
li $v0, 0
jr $ra
recursion:
li $s6, 0
for_begin:
addi $t9, $s0, 1
beq $s4, $t9, for_end
getindex($t3, $s3, $s4)
lw $t4, matrix($t3)
bne $t4, $s7, next_cycle
sll $t3, $s4, 2
lw $t4, visit($t3)
bne $t4, $0, next_cycle

sll $t3, $s4, 2
sw $s7, visit($t3)
sw $ra, 0($sp)
subi $sp, $sp, 4
sw $s3, 0($sp)
subi $sp, $sp, 4
sw $s4, 0($sp)
subi $sp, $sp, 4
addi $s2, $s2, 1

move $a0, $s4
move $a1, $s7
jal findroad
move $s6, $v0

subi $s2, $s2, 1
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $ra, 0($sp)
sll $t3, $s4, 2
sw $0, visit($t3)

beq $s6, $s7, for_end
next_cycle:
addi $s4, $s4, 1
j for_begin
for_end:
move $v0, $s6
jr $ra

# $s0 storage n
# $s1 storage m
# $s2 storage len_chain
# $s3 current_point
# $s4 next_probe_point
# $s5 final_result
# $s6 findroad_result
# $s7 constant:1
# $t0 a normal cyclic variable
# $t1 read integer1
# $t2 read integer2