.data
str: .space 20

.text
li $v0, 5
syscall
move $s0, $v0

li $t0, 0
read_begin:
beq $t0, $s0, read_end

li $v0, 12
syscall
sb $v0, str($t0)

addi $t0, $t0, 1
j read_begin
read_end:

li $t0, 0
judge_begin:
beq $t0, $s0, judge_end

sub $t1, $s0, $t0
subi $t1, $t1, 1
lb $t2, str($t0)
lb $t3, str($t1)
bne $t2, $t3, output0

addi $t0, $t0, 1
j judge_begin
judge_end:

li $a0, 1
li $v0, 1
syscall
li $v0, 10
syscall

output0:
li $a0, 0
li $v0, 1
syscall
li $v0, 10
syscall


# $s0 storage n
# $s1 storage judge_result