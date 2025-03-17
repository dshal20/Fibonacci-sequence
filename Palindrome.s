.section .data

input_prompt : .asciz "Input a string: "
input_spec : .asciz "%[^\n]"
length_spec : .asciz "String length: %d\n"
palindrome_spec : .asciz "String is a palindrome (T/F): %c\n"

input : .space 8


.section .text

.global main


# program execution begins here
main:
# Assembly palindrome checker
  ldr x0, =input_prompt
  bl printf	

  ldr x0, =input_spec
  ldr x1, =input
  bl scanf

  ldr x2, =input
  mov x3, #0

calc_len_loop:
  ldrb w0, [x2]
  cbz w0, final_length
  add x2, x2, #1
  # moves to the next character
  add x3, x3, #1
  # this updates the counter determining the length of string
  b calc_len_loop

final_length:
  mov x19, x3
  ldr x0, =length_spec
  mov x1, x19
  bl printf

  cmp x19, #1
  ble true 
  # If less than or equal to length of 1, must be palindrome

  ldr x10, =input
  ldr x12, =input
  add x11, x12, x19
  sub x11, x11, #1
  # x10 is start and x11 is end

  lsr x19, x19, #1
  b calculationa_loop

calculationa_loop:
  # ends loop when nothing left
  cbz x19, true

  ldrb w1, [x10]
  ldrb w2, [x11]
  # compare first and last character
  cmp w1, w2
  # use branch not equal and branch to false
  b.ne false
  # now move pointers throughout the string
  add x10, x10, #1
  sub x11, x11, #1
  # sub x19 is used to count backwards until there no letters left to compare
  sub x19, x19, #1
  b calculationa_loop

true:
  mov x1, #'T'
  b final_palindrome

false:
  mov x1, #'F'  
  b final_palindrome

final_palindrome:
  ldr x0, =palindrome_spec
  bl printf



# branch to this label when program completes
exit:
  mov x0, 0
  mov x8, 93
  svc 0
  ret
