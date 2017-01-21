//Created by Joshua Dow, 10150588, 11/13/2016


//struct point {
//	int x;
//	int y;
//	int z;
// };

//struct sphere {
//	point origin;
//	int radius;
// };

x_offset = 0						//Initializing x offset
y_offset = 4						//Initializing y offset
z_offset = 8						//Initializing z offset
r_offset = 12						//Initializing r offset
sphere_struct_size = 16					//Setting structure size
f_s = 16						//Offset for first
s_s = 32						//Offset for second
true = 1						//Set true to 1
false = 0						//Set false to 0
fmt:	.string "\nInitial sphere values:\n"		//Set string
f_m:	.string "first"
s_m:	.string "second"
fmt1:	.string "\nChanged sphere values:\n"
fmt2:	.string "\nSphere %s values:	(%d, %d, %d)\n"

alloc = -(16 + 2 * sphere_struct_size) & -16		//Set amount of memory for main
	.balign 4					//Aliging bits
	.global main					//Makes main global

main:
	stp x29, x30, [sp, alloc]!			//Allocating memory on stack for pair
	mov x29, sp					//SP now points to FP
	add x8, x29, 16					//Giving x8 the address of x29 with an offset of 16
	bl new_Sphere					//Calling new_Sphere

break1:	ldr w9, [x8, x_offset]				//Initializing first x
	str w9, [sp, f_s + x_offset]			//Storing first x
	ldr w9, [x8, y_offset]				//Initializing first y
	str w9, [sp, f_s + y_offset]			//Storing first y
	ldr w9, [x8, z_offset]				//Initializing first z
	str w9, [sp, f_s + z_offset]			//Storing first z
	ldr w9, [x8, r_offset]				//Initializing first r
	str w9, [sp, f_s + r_offset]			//Storing first r

	mov x8, 0					//Setting x8 to 0
	add x8, x29, 32					//Giving x8 address of x29 with an offset of 16
	bl new_Sphere					//Calling new_Sphere

	ldr w9, [x8, x_offset]				//Initializing second x
	str w9, [sp, s_s + x_offset]			//Storing second x
	ldr w9, [x8, y_offset]				//Initializing second y
	str w9, [sp, s_s + y_offset]			//Storing second y
	ldr w9, [x8, z_offset]				//Initializing second z
	str w9, [sp, s_s + z_offset]			//Storing second z
	ldr w9, [x8, r_offset]				//Initializing second r
	str w9, [sp, s_s + r_offset]			//Storing second r

	adrp x0, fmt					//Putting high order bits in x0
	add x0, x0, :lo12:fmt				//Putting low order bits in x0
	bl printf					//Calling printf()

	adrp x0, f_m					//Putting high order bits in x0
	add x0, x0, :lo12:f_m				//Putting low order bits in x0
	add x1, x29, f_s				//Putting address of first structure in x1
	bl print_Sphere					//Calling print_Sphere()

	adrp x0, s_m					//Putting high order bits in x0
	add x0, x0, :lo12:s_m				//Putting low order bits in x0
	add x1, x29, s_s				//Putting address of second structure in x1
	bl print_Sphere					//Calling print_Sphere()

	add x0, x29, f_s				//Putting address of first structure in x0
	add x1, x29, s_s				//Putting address of second structure in x1
	bl equal					//Call to equals()
	cmp x0, true					//Compare if result is true
	b.ne else					//If false, branch

	add x0, x29, f_s				//Putting address of first structure in x0
	mov w1, -5					//-5 as argument
	mov w2, 3					//3 as argument
	mov w3, 2					//2 as argument
	bl move						//Call to move()

	add x0, x29, s_s				//Putting address of second structure in x0
	mov w1, 8					//8 as argument
	bl expand					//Call to expand()

else:
	adrp x0, fmt1					//Setting high bits in x0
	add x0, x0, :lo12:fmt1				//Setting low bits in x0
	bl printf					//Call to printf()
	adrp x0, f_m					//Setting high bits in x0
	add x0, x0,:lo12:f_m				//Setting low bits in x0
	add x1, x29, f_s				//Setting x1 to address of first structure
	bl print_Sphere					//Call to print_Sphere()

	adrp x0, s_m					//Load high bits in x0
	add x0, x0, :lo12:s_m				//Setting low bits in x0
	add x1, x29, s_s				//Setting x1 as address of second structure
	bl print_Sphere

	ldp x29, x30, [sp], -alloc			//Deallocating memory
	ret						//Return to calling code


sphere_alloc = -(16 + sphere_struct_size) & -16		//Memory for new_Sphere()
new_Sphere:
	stp x29, x30, [sp, sphere_alloc]!		//Allocating memory for new_Sphere()
	mov x29, sp					//Point sp to fp
break2:
	mov w0, 0					//Initialzing argument to 0
	str w0, [x29, 16 + x_offset]			//Setting sphere.origin.x to 0
	str w0, [x29, 16 + y_offset]			//Setting sphere.origin.y to 0
	str w0, [x29, 16 + z_offset]			//Setting sphere.origin.z to 0
	mov w0, 1					//Initializing argument to 1
	str w0, [x29, 16 + r_offset]			//Setting sphere.radius to 1
break3:
	ldr w0, [x29, 16 + x_offset]			//Loading value of sphere.origin.x
	str w0, [x8, x_offset]				//Storing to return
	ldr w0, [x29, 16 + y_offset]			//Loading value of sphere.origin.y
	str w0, [x8, y_offset]				//Storing to return
	ldr w0, [x29, 16 + z_offset]			//Loading value of sphere.origin.z
	str w0, [x8, z_offset]				//Storing to return
	ldr w0, [x29, 16 + r_offset]			//Loading value of sphere.radius
	str w0, [x8, r_offset]				//Storing to return
break4:
	ldp x29, x30, [sp], -sphere_alloc		//Deallocating memory
	ret						//Return to calling code


print_Sphere:
	stp x29, x30, [sp, -16]!			//Allocating memory for print_Sphere()
	mov x29, sp					//Point sp to fp
	mov x1, x0					//Mov value of x0 into x1
	ldr w2, [x1, x_offset]				//Loading sphere.origin.x as arg
	ldr w3, [x1, y_offset]				//Loading sphere.origin.y as arg
	ldr w4, [x1, z_offset]				//Loading sphere.origin.z as arg
	ldr w5, [x1, r_offset]				//Loading sphere.radius as arg

	adrp x0, fmt2					//Setting high bits in x0
	add x0, x0, :lo12:fmt2				//Setting low bits in x0
	bl printf					//Call to printf()

	ldp x29, x30, [sp], 16				//Deallocating memory
	ret						//Return to calling code

eq_alloc = -(16 + 4) & -16				//Memory to allocate for equal()
equal:
	stp x29, x30, [sp, eq_alloc]!			//Allocating memory for equal()
	mov x29, sp					//Point sp to fp
	ldr w11, [x0, x_offset]				//Loading value of first.origin.x
	ldr w12, [x1, x_offset]				//Loading value of second.origin.x
	cmp w11, w12					//Compare two values
	b.ne end					//If not equal, jump to end
	ldr w11, [x0, y_offset]				//Loading value of first.origin.y
	ldr w12, [x1, y_offset]				//Loading value of second.origin.y
	cmp w11, w12					//Compare two values
	b.ne end					//If not equal, jump to end
	ldr w11, [x0, z_offset]				//Loading value of first.origin.z
	ldr w12, [x1, z_offset]				//Loading value of second.origin.z
	cmp w11, w12					//Compare two values
	b.ne end					//If not equal, jump to end
	ldr w11, [x0, r_offset]				//Loading value of first.radius
	ldr w12, [x1, r_offset]				//Loading value of second.radius
	cmp w11, w12					//Compare two values
	b.ne end					//If not equal, jump to end
	mov w0, true					//If all conditions true, set return to true
	b return					//Jump to return label
end:
	mov w0, false					//If any condition failes, set return to false
return:
	ldp x29, x30, [sp], -eq_alloc			//Deallocate memory
	ret						//Return to calling code


move:
	stp x29, x30, [sp, -16]!			//Allocate memory for move()
	mov x29, sp					//Point sp to fp

	ldr w9, [x0, x_offset]				//Load value of first.origin.x
	add w9, w9, w1					//Add deltaX
	str w9, [x0, x_offset]				//Store value of first.origin.x
	ldr w9, [x0, y_offset]				//Load value of first.origin.y
	add w9, w9, w2					//Add deltaY
	str w9, [x0, y_offset]				//Store value of first.origin.y
	ldr w9, [x0, z_offset]				//Load value of first.origin.z
	add w9, w9, w3					//Add deltaZ
	str w9, [x0, z_offset]				//Store value of first.origin.z

	ldp x29, x30, [sp], 16				//Deallocate memory
	ret						//Return to calling code

expand:
	stp x29, x30, [sp, -16]!			//Allocate memory for expand
	mov x29, sp					//Point sp to fp
	ldr w9, [x0, r_offset]				//Load second.radius
	mul w9, w9, w1					//Multiply by factor
	str w9, [x0, r_offset]				//Store second.radius
	ldp x29, x30, [sp], 16				//Deallocate memory
	ret						//Return to calling code
