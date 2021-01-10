//Yen Pham
	.data
	.type	v, %object
	.type	i, %object
	.type	n, %object
	.size	v, 6
	.size   n, 1
	.size	i, 1
n:
	.xword 6
v:
	.xword	57, 61, 25, 7, 39, 18    // 64-bit values
i:
	.xword 0

	.text
	.global	main
	.global find_smallest_index
	.global find_largest_index
	.global find_sum
	.arch armv8-a+fp+simd
	.type find_smallest_index, %function
	.type find_largest_index, %function
	.type find_sum, %function
	.type	main, %function

find_sum:
	lsl			X11, X4, #3         // temp X11 = i*8
	add			X11, X11, X0         // get address of array[i]
	ldur		X10, [X11, #0]       // load value of array[i] to X6
	add			X2, X2, X10         // sum = sum + array[i]
	add			X4, X4, #1         // increment i to 1
	sub			X5, X1, X4         // compare i and n
	cbnz		X5, find_sum       // if i < n, continue the loop
	br			X30                // return back to caller

find_largest_index:
	lsl			X11, X4, #3         // temp X11 = i*8
	add			X11, X11, X0         // get address of array[i]
	ldur		X10, [X11, #0]       // load value of array[i] into X10
	cmp			X10, X2             // compare array[i] and largest number
	b.gt		swap_largest       // if array[i] > largest, go to swap function
	add			X4, X4, #1         // increment index to 1
	sub			X5, X1, X4         // if i < n
	cbnz		X5, find_largest_index   // loop if i < n
	br			X30                // else, go back to caller

swap_largest:
	add			X2, X10, #0         // swap largest = array[i]
	add			X3, X4, #0         // largest index = i
	add			X4, X4, #1         // increment i to 1
	sub			X5, X1, X4         // if i < n
	cbnz		X5, find_largest_index   // go back to loop


find_smallest_index:
	lsl			X11, X4, #3         // temp X11 = i*8
	add			X11, X11, X0         // get address of array[i]
	ldur		X10, [X11, #0]       // load the value of array[i] into X10
	cmp			X10, X2             // if smallest > array[i], go to swap function
	b.lt		swap_smallest      // call swap_smallest function
	add			X4, X4, #1         // increment index to 1
	sub			X5, X1, X4         // compare i to n
	cbnz		X5, find_smallest_index  // if i < n, go back to the loop
	br			X30                // go back to the function which calls it

swap_smallest:
	add			X2, X10, #0         //swap
	add			X3, X4, #0         //save smallest index
	add			X4, X4, #1         //increment index i
	sub			X5, X1, X4         //compare i to n
	cbnz		X5, find_smallest_index  //if i < n, continue the loop


find_values:
        //add parameters needed
	sub			SP, SP, #16	//make stack for X30 and X0
	stur		X30, [SP, #8] //store X30 in stack
	stur		X0, [SP, #0] //store X0 in stack
	sub			X4, X4, X4 //reset i
	bl			find_smallest_index //call smallest index function
	add			X8, X3, #0 	// copy its index to required registers
	sub			X4, X4, X4 //reset i
	bl			find_largest_index //call largest index function
	add			X7, X3, #0	     // copy its index to required registers
	sub			X4, X4, X4      // initialize i to 0
	sub			X2, X2, X2      // reset X2 to 0
	bl			find_sum		//call function to calculate sum
	add			X6, X2, #0		//copy sum to X6
	ldur 		X0, [SP, #0] //load X0
	ldur		X30, [SP, #8] //load X30
	add			SP, SP, #16 //return the stack
	br			X30 //go back to the main function


main:
	adrp		X0, v           	// Load the array address to X0
	add			X0, X0, :lo12:v
	adrp		X1, n           	// address of n
	add			X1, X1, :lo12:n
	adrp		X3, i           	// address of i
	add			X3, X3, :lo12:i

	ldur		X2, [X0, #0] 	// X2 = a[0], for smallest, largest and sum
	ldur		X1, [X1, #0] 	// X1 = n
	ldur		X3, [X3, #0]    // X3 = index of smallest or largest

	bl			find_values	// call find_values

exit: