//Yen Pham
		.data
		.type	n, %object
		.size   n, 1
n:		.xword 5			// define input n

		.text
		.global main
		.global get_sum
		.arch armv8-a+fp+simd
		.type main, %function
		.type get_sum %function
get_sum:
	SUB	SP, SP, #16 //push 2 values, n and return address
	STUR X30, [SP, #8] //push return address in laink reg onto stack
	STUR X0, [SP, #0] //push argument n onto stack
	SUB X5, X0, #1 //check if n = 1, if not return 1
	CBNZ X5, L1 // go to L1
	SUB X1, X1, X1 //set X1 = 0
	ADD X1, X1, #1 //return 1
	ADD SP, SP, #16 //pop two values on stack but do not restore them
	BR X30 //return

L1: SUB X0, X0, #1 //if n>1, compute n-1 in X0 - new argument to recursive call
	BL get_sum //recursivly call get_sum with n-1 as an argument
	LDUR X0, [SP, #0] //restore previous argument n
	LDUR X30, [SP, #8] //restore previous return address
	ADD SP, SP, #16 //adjust stack pointer
	ADD X1, X0, X1 //return n + get_sum(n-1) - this is result passed back to caller
	BR X30

main:		ADRP X0, n            		// get the address of array v
		ADD X0, X0, :lo12:n
		LDUR X0, [X0, #0]    		// load n into X0
		BL get_sum				// call get_sum with n
exit: