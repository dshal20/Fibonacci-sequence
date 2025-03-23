.section .data

input_prompt  :   .asciz  "Please enter a number betwen 1 and 10 \n"
input_spec  :   .asciz  "%d"
fib      :   .asciz  "%d\n"
oob_mess	 : .asciz "Input is out of bounds \n"
 
.section .text

.global main

main:
	sub sp, sp, #16
	# Allocate 16 bytes of stack space
	
	# Prompt the user for input
	ldr x0, =input_prompt
  	bl printf

	# Read the user's input (integer) into the stack location
	ldr x0, =input_spec
	mov x1, sp 
  	bl scanf

	# Load the input value into w0
	ldr w0, [sp]
	
 	# Check if input > 10
	cmp w0, 10
  	bgt BaseCaseError      
	
	# Check if input < 1
	cmp w0, 1
  	blt BaseCaseError         

	# Call Fibonacci function
	bl Fibonacci

	# Free the 16 bytes of stack space used in main
	add sp, sp, #16
	
	# Print the result returned by Fibonacci (in w0)
	mov x1, x0               
  	ldr x0, =fib    
  	bl printf

	b exit
		
Fibonacci:

	# Allocate 16 bytes for local use
	sub sp, sp, #16 
	# Save return address (LR)
	str x30, [sp, 8]
	# Save function argument
	str w0, [sp, 4]

	# Base case: if n == 1 => Fib(n) = 0
	cmp w0, 1
	beq BaseCase0

	# Base case: if n == 2 => Fib(n) = 1
	cmp w0, 2
	beq BaseCase1

  # Recursive case: Fib(n) = Fib(n-1) + Fib(n-2)

	# Compute Fib(n-1)
	sub w0, w0, #1
	bl Fibonacci
	str w0, [sp]

	# Compute Fib(n-2)
	ldr w0, [sp, 4]
	sub w0, w0, #2
	bl Fibonacci

	# Add Fib(n-1) + Fib(n-2)
	ldr w1, [sp]
	add w0, w0, w1
	b FinalResult

# Print out-of-bounds error message and exit
BaseCaseError:
	ldr x0, =oob_mess
  	bl printf
  	b exit

# Fib(2) = 1
BaseCase1:
	mov w0, 1
	b FinalResult

# Fib(1) = 0
BaseCase0:
	mov w0, 0
	b FinalResult

FinalResult:
	ldr x30, [sp, 8]
	add sp, sp, #16
	ret

# Program exit
exit:
	mov x0, 0
	mov x8, 93
	svc 0
	ret


