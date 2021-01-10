//Yen Pham
//yhp0005
//11290771

    .data
	.type	a, %object
	.type	i, %object
	.type	n, %object
	.size	a, 6
	.size   n, 1
	.size   i, 1
n:
  .xword 6
a:
  .xword	35, 47, 12, 9 , 18, 26       // 64-bit values
i:
  .xword 0


	.text
	.global	main
	.global find_smallest
	.global find_largest
	.global find_sum
	.arch armv8-a+fp+simd
	.type find_smallest, %function
	.type find_largest, %function
	.type find_sum, %function
	.type	main, %function

find_sum:
	// X0 contains address of a; X1 contains n,
	//X2 will contain sum returned
	lsl			X7, X4, #3         // temp X7 = i*8
	add			X7, X7, X0         // get address of array[i]
	ldur		X6, [X7, #0]       // load value of array[i] to X6
	add			X2, X2, X6         // sum = sum + array[i]
	add			X4, X4, #1         // increment i to 1
	sub			X5, X1, X4         // compare i and n
	cbnz		X5, find_sum       // if i < n, continue the loop
	br			X30                // return back to caller

find_largest:
	// X0 contains address of a; X1 contains n,
	//X2 will contain largest value returned
	// X3 will contain the index of largest value returned
	lsl			X7, X4, #3         // temp X7 = i*8
	add			X7, X7, X0         // get address of array[i]
	ldur		X6, [X7, #0]       // load value of array[i] into X6
	cmp			X6, X2             // compare array[i] and largest number
	b.gt		swap_largest       // if array[i] > largest, go to swap function
	add			X4, X4, #1         // increment index to 1
	sub			X5, X1, X4         // if i < n
	cbnz		X5, find_largest   // loop if i < n
	br			X30                // else, go back to caller

swap_largest:
	add			X2, X6, #0         // swap largest = array[i]
	add			X3, X4, #0         // largest index = i
	add			X4, X4, #1         // increment i to 1
	sub			X5, X1, X4         // if i < n
	cbnz		X5, find_largest   // go back to loop


find_smallest:
	// X0 contains address of a; X1 contains n,
	// X2 will contain smallest value returned
	// X3 will contain the index of smallest value returned
	// X0 contains address of a; X1 contains n,
	//X2 will contain largest value returned
	// X3 will contain the index of largest value returned
	lsl			X7, X4, #3         // temp X7 = i*8
	add			X7, X7, X0         // get address of array[i]
	ldur		X6, [X7, #0]       // load the value of array[i] into X6
	cmp			X6, X2             // if smallest > array[i], go to swap function
	b.lt		swap_smallest      // call swap_smallest function
	add			X4, X4, #1         // increment index to 1
	sub			X5, X1, X4         // compare i to n
	cbnz		X5, find_smallest  // if i < n, go back to the loop
	br			X30                // go back to the function which calls it

swap_smallest:
	add			X2, X6, #0         //swap
	add			X3, X4, #0         //save smallest index
	add			X4, X4, #1         //increment index i
	sub			X5, X1, X4         //compare i to n
	cbnz		X5, find_smallest  //if i < n, continue the loop


main:
	adrp		X0, a           	// Load the array address to X0
	add			X0, X0, :lo12:a
	adrp		X1, n           	// Load address of n to X1
	add			X1, X1, :lo12:n
	adrp		X3, i           	// Load address of index to X3
	add			X3, X3, :lo12:i

	ldur		X2, [X0, #0] 	// X2 = a[0], for smallest, largest and sum
	ldur		X1, [X1, #0] 	// X1 = n
	ldur		X3, [X3, #0]    // X3 = index of smallest or largest
	sub			X4, X4, X4      // initialize i to 0

	bl			find_smallest	// call find_smallest
	add			X10, X3, #0 	// copy its index to required registers
	add			X12, X2, #0     // copy smallest to required registers

	sub			X4, X4, X4      // initialize i to 0
	ldur		X2, [X0, #0] 	// X2 = a[0], for smallest, largest and sum
	bl			find_largest 	// call find_largest
	add			X11, X3, #0	     // copy its index to required registers
	add			X13, X2, #0      // copy largest to required registers

	sub			X4, X4, X4      // initialize i to 0
	sub			X2, X2, X2      // reset X2 to 0
	bl			find_sum		// call find_sum
	add			X14, X2, #0     // copy sum to required registers

exit:

