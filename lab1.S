 .data
 .type v, %object
 .type n, %object
 .size v, 6
 .size n, 1

v:
 .xword 42,51,3,29,65,17  // define the array elements
n:
 .xword 6                      // define the array size or n

 .text
 .global main
 .arch armv8-a+fp+simd
 .type main, %function
 .type largest, %function
 .type smallest, %function

largest:
	mov			X11, X2                      // move X2 value into X11
	add			X3, X3, #1                  // i = i + 1
	add			X0, X0, #8                  // get address of next array element
	sub			X5, X4, X3                  // check if i < n
	cbnz		X5, loop                    // if i < n repeat the loop

smallest:
	mov			X12, X2                      // move X2 value into X12
	add			X3, X3, #1                  // i = i + 1
	add			X0, X0, #8                  // get address of next array element
	sub			X5, X4, X3                  // check if i < n
	cbnz		X5, loop                    // if i < n repeat the loop

main:

	adrp		X0, v                       // get the address of array v
	add			X0, X0, :lo12:v
	adrp		X4, n                       // get the address of n
	add			X4, X4, :lo12:n
	ldur		X4, [X4, #0]                // load n into X4
	sub			X3, X3, X3                  // initialize i to zero
	sub			X10, X10, X10               // initialize X10 (sum) to zero
	sub			X13, X13, X13               // initialize X10 (sum) to zero
	ldur		X11, [X0, #0]               // load v[0] into X11
	ldur		X12, [X0, #0]               // load v[0] into X11

loop:
	ldur		X2, [X0, #0]                // load v[i] into X2
	add			X10, X10, X2                // sum = sum + v[i]
	cmp			X2, X11                      // compare X2 and X11
	b.gt		largest                     // if X11 is larger than X2 go to largest function
	cmp			X2, X12                     // compare X2 and X12
	b.lt		smallest                    // if X12 is smaller than X2 go to smallest function
	add			X3, X3, #1                  // i = i + 1
	add			X0, X0, #8                  // get address of next array element
	sub			X5, X4, X3                  // check if i < n
	cbnz		X5, loop                    // if i < n repeat the loop

	sub			X13, X11, X12                // X13 = X11 - X12
exit:
