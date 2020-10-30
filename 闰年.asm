li $v0, 5				# $v0 = 5
syscall					# read integer year
move $s0, $v0			# $s0 = year
li $s1, 4
li $s2, 100
li $s3, 400

div $s0, $s1				# year divided by 4
mfhi $t0				# take the remainer to $t0
bne $t0, $0, not_leap	# if remainer is not equal to 0, then year is not leap year

div $s0, $s2			# year divided by 100
mfhi $t0				# take the remainer to $t0
beq $t0, $0, next		# equal to 0, so jump to judge with 400
j leap_year				# not equal to 0, so year is a leap year

next:
div $s0, $s3
mfhi $t0
beq $t0, $0, leap_year
j not_leap

not_leap:
li $a0, 0
li $v0, 1
syscall
j done

leap_year:
li $a0, 1
li $v0, 1
syscall
j done

done:
li $v0, 10
syscall
