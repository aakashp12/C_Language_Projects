; Assuming user will only enter ' ' 0-9 *+/-

; With INPUT subroutine, we get input from keyboard, and display it on to the screen 
; With EVALUATE subroutine, we take the input and store it on the stack, and also
; Evalute the statement we input, and store the result in R0/ R6
; With PRINT subroutine, we get the result which is stored in R6 and copy it into R0
; And print out the value in R0 in decimal number.
;
; R1 - Used to load starting address of memory block


.ORIG x3000

; your main program should be just a few calls to subroutines, e.g.,
; R1 <- x5000
; JSR INPUT
; JSR EVALUATE
; JSR PRINT

	LD R1, STR_ADDR
	JSR INPUT			; We jump to input and get the whole input
	JSR EVALUATE		; We evaluate what operations need to be done and start to calculate
	JSR PRINT			; We print the result from calculations onto the screen
	LD R6, RESULT		;

HALT

INPUT_R7	.BLKW #1	;
PRINT_R7	.BLKW #1	;		
EVALUATE_R7	.BLKW #1	;
RESULT		.BLKW #1	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; get input from the keyboard and store it in memory per MP2 specifications
; input: R1 - starting address of the memory to store the expression string
; output: input from the keyboard stored in memory starting from the address passed in R1

;	R0 - Holds the input
;	R1 - Holds memory address, they increment
;	R2 - Temp register used to load values, check values
;	R7 - Used to store and load value of PC to return back to main program

INPUT					;
						;
	ST R7, INPUT_R7		; Saved the PC value from where we used JSR INPUT

READ					;
						;
	GETC				; Gets a character
	OUT					; Ouput a character
	
CHECK_FOR_SPACE			; Skip if space
						;
	LD R2, SPACE		; Load the ASCII value of space
	NOT R2, R2			;
	ADD R2, R2, #1		; Make it negative so we can add it with input (R0) to check if we enetered space
	ADD R2, R0, R2		;
	BRz READ			; If space was added, ignore it and move on to next char

CHECK_FOR_NEWL			; Goto IF_NEW if you pressed enter
						;
	LD R2, NEW_LINE		; Check if NEW LINE was used
	NOT R2, R2			;
	ADD R2, R2, #1		; Make it negative so we can add it with input (R0) to check if we entered enter
	ADD R2, R0, R2		;
	BRz IF_NEW			; If NEW LINE stop the program
	LD R2, CHAR_RETURN	; Check if enter key was pressed
	NOT R2, R2			;
	ADD R2, R2, #1		; Make it negative so we can add it with input (R0) to check if we entered enter
	ADD R2, R0, R2		;
	BRz IF_ENTER			; If enter then stop the program
	
CHECK_FOR_NUM			; Goto IF_NUM if its a number, if not number then goes to IF_SIGN
						;
	LD R2, ZERO			; Value of zero loaded
	NOT R2, R2			; Make it negative
	ADD R2, R2, #1		;
	ADD R2, R0, R2		; You only get a decimal number not a hex
	BRzp IF_NUM			; Making sure it's a number		
	BRn  IF_SIGN		; If not a number then we go ahead and evaluate it as a calculatio sign

STR_ADDR        .FILL x5000             
SPACE           .FILL x0020
NEW_LINE        .FILL x000A
CHAR_RETURN     .FILL x000D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; find the real value of operand, or keep the 2's complement ASCII value if operator
; input: R0 holds the input
; output: R0


;	R0 - Holds input
;	R1 - Holds memory address
;	R2 - Temp register used to load values into, check for conditions
;	R7 - Used to store and load value of PC to return back to main program

DECODE					; Here we decode values that we put in as input, also store them into memory

IF_NUM					; If its a number then we change it from hex to normal decimal

	LD R2, ZERO			; Load ASCII value of zero 
	NOT R2, R2			;
	ADD R2, R2, #1		; Made it negative to check if the valu
	ADD R2, R0, R2		;
	STR R2, R1, #0		; Store the value at the memory address saved in R1
	ADD R1, R1, #1		; Increment the memory address
	BRnzp READ			; Go back to getting input
	
	
	
IF_SIGN					; We negate the sign value
						;
	NOT R0, R0			;
	ADD R0, R0, #1		;
	STR R0, R1, #0		; Store the negative value of sign in memory
	ADD R1, R1, #1		; Increment the memory address
	BRnzp READ			; Go back to getting input
	
	

IF_NEW					; If its new line char then we halt/stop the program
						;
	LD R2, NEW_LINE		;
	NOT R2, R2			;
	ADD R2, R2, #1		;
	STR R2, R1, #0		; Store the ENTER key value into memory
	LD R7, INPUT_R7		;
	RET					; END reading inputs
	
IF_ENTER				; If its enter then we halt/stop the program
	LD R2, CHAR_RETURN	;
	NOT R2, R2			;
	ADD R2, R2, #1		;
	STR R2, R1, #0		; Store the ENTER key value into memory
	LD R7, INPUT_R7		;
	RET					; END reading inputs


ZERO    .FILL x0030
MULT	.FILL x002A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Your code from Lab 4 that prints value stored in register R0 in decimal format
; input: R0 - holds the input
; output: signed decimal value printed on the display
;
;	R0 - Input for PRINT subroutine
;	R1 - Used to load in the ZERO OFFSET and operate with it to get decimal values
;	R2 - Holds the negative value of denominator, in this case its -10
;	R3 - Value from R0 is copied into R3 for divison
;	R4 - Holds the value of 10, for division 
;	R5 - Temp register to load in values, and also a checker to cehck for conditions
;	R6 - NOT USED
;	R7 - NOT USED
;

PRINT					; The result will be printed as decimal value
						;
	ST R7, PRINT_R7		;
	ADD R0, R6, #0		; R0 <- R6, previously we saved our result into R6
	AND R5, R5, #0		; Clear R5

STEP_1					; 
						;
	AND R4, R4, #0		; Clear r4
	ADD R4, R4, #10		; R4 <- #10
	ADD R3, R0, #0		; R3 <- R0
	BRn NEG_DIV			; If the value in R3 is negative we flag it
	BRp DIV_HERE		; If the value in R3 is positive, go ahead with division
			
DIV_HERE				;
						;
	JSR DIVIDE_1		; Jump to divide
	LD R0, REMAINDER	; Load the remainder we saved in memory, so we can push to stack
	JSR PUSH			; PUSH to stack
	BRnzp STEP_2		; 

NEG_DIV					;
						;
	NOT R3, R3			; NOT R3 to make it into positive value
	ADD R3, R3, #1		;	
	AND R5, R5, #0		; Clear R5
	ADD R5, R5, #-1		; Flag that we have a negative value
	ST R5, NEG_VALUE	; Store the flagfed value
	BRnzp DIV_HERE		; Continue to do normal division
	

STEP_2					;
						;
	LD R0, QUOTIENT		; Load the quotient 
	BRnp STEP_1			; If the quotient isn't 0 then keep dividing
			
STEP_3					;
						;
	LD R5, NEG_VALUE	; We load the flag
	BRn LOAD_NEG		; If negative then we display a negative sign onto the display
	JSR POP				; POP a value from stack
	ADD R5, R5, #0		; Checking for underflow
	BRp DONE			; If there's no underflow then continue
	LD R1, ZERO_OFFSET	; Load ZERO OFFSET
	ADD R0, R1, R0		; Get the correct value of decimal number
	OUT					; Display it onto the display
	BRnzp STEP_3		; Continue the loop until stack is underflow
	
LOAD_NEG				;
						;
	LD R0, NEGATIVE		; Output a negative sign
	OUT					;
	AND R5, R5, #0		; Clear R5 so we dont mess it up with underflow stack
	
NEG_PRINT				;
	JSR POP				; Same as positive print but for negative numbers
	ADD R5, R5, #0		;
	BRp DONE			;
	LD R1, ZERO_OFFSET	;
	ADD R0, R1, R0		;
	OUT					;
	BRnzp NEG_PRINT		;
	
DONE 					;
	LD R7, PRINT_R7		;
	HALT				;
	
DIVIDE_1				; Treating the values to be positive, divide by 10 to get decimal values
						;
	AND R5, R5, #0		; 
	AND R0, R0, #0		;

DIVISION_1				; -D 

	NOT R2, R4			;
	ADD R2, R2, #1		;
	
DIV_LOOP_1 				; While R >= D
						;
	ADD R5, R3, R2		;
	BRn DONE_SAVE			;
	ADD R0, R0, #1		;
	ADD R3, R3, R2		;
	BRnzp DIV_LOOP_1	;
						;
	HALT				;
	
DONE_SAVE				;
						;
	ADD R1, R3, #0		; REMAINDER
	ST R0, QUOTIENT		;
	ST R1, REMAINDER	;

DIV_POS					;
	RET					;


NEG_VALUE	.BLKW #1	;
REMAINDER 	.BLKW #1	;
QUOTIENT	.BLKW #1	;
NUM_1		.FILL #-109	;
NEGATIVE	.FILL x2D	;
ZERO_OFFSET	.FILL X30	;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R1 - start address of the expression string
; output: R0 - the numerical value of the end result
;
;	R0 - Holds the output from stack
;	R1 - Holder of memory address
;	R2 - Holder of values stored in memory address that was recently accessed
;	R3 - Hold values that were once input, now in stack, later used for arithmetic
;	R4 - Hold values that were once input, now in stack, later used for arithmetic
;	R5 - Temp register to load in values, also check for underflow
;	R6 - Had final Result
;	R7 - Store the return PC after done evaluating
;

EVALUATE
; your code goes here
	
	ST R7, EVALUATE_R7	; Saved PC so we can ret to main program	
	LD R1, STR_ADDR		; Loaded the start address of the values stored in memory

NEXT_VAL				; Loading values into a register
						;
	LDR R2, R1, #0		; Loading value from memory address to a register

NEWL_CHECKER			; Goto IF_NEW if you pressed enter
	LD R3, NEW_LINE		;
	ADD R3, R2, R3		;
	BRz FALSE_NL		;
	LD R3, CHAR_RETURN	;
	ADD R3, R2, R3		;
	BRz FALSE_NL		;

NUM_CHECKER				; If it's operand(number) then goes to TRUE_NUM
	LD R3, ZERO			;
	ADD R4, R3, R2		; Adding the ZERO offset to value in memory
	NOT R3, R3			; 
	ADD R3, R3, #1		; Negative zero
	ADD R3, R4, R3		;
	BRzp TRUE_NUM		; 
	BRn  FALSE_SIGN		;
	
FALSE_NL				; False branch of not new line branch check
						;
	JSR POP				; You pop the value you have in stack
	ADD R5, R5, #0		; Check for underflow
	BRp IS_UNDERFLOW	; If underflow then we print error message
	BRz RESULT_PRINT	; If not underflow then we print out the result
						
RESULT_PRINT
	ADD R6, R0, #0		; R6 <- R0
	ST R6, RESULT		;
	LD R7, EVALUATE_R7	; Load R7 with the return PC
	RET					; Return to main program
	HALT				;
	

TRUE_NUM				; The value was an operand so we push value into stack
						;
	ADD R0, R2, #0		;
	JSR PUSH			;
	ADD R1, R1, #1		; Increment the value of memory address
	BRnzp NEXT_VAL		; Go fetch new value 
	
	
FALSE_SIGN				; The value was an operator so we no pop two values 
						;
	JSR POP				; Poped the value from stack
	ADD R4, R0, #0		; Copy value from R0 into R4
	ADD R5, R5, #0		; Check for underflow
	BRp	IS_UNDERFLOW	; We have to take care of underflow
	JSR POP				; Poped the value from stack
	ADD R5, R5, #0		; Check for underflow
	BRp	IS_UNDERFLOW	; We have to take care of underflow
	ADD R3, R0, #0		; Copy value from R0 into R3
	
CHECKING_SIGN			;
						;
	LD R5, MULT_SIGN	; Load value of * and add it with negative value of sign
	ADD R5, R2, R5		; If the sum is 0  then its *
	BRz MULTIPLY		; So we jump to MULTIPLY subroutine
	
	LD R5, ADD_SIGN		; Load value of + and add it with negative value of sign
	ADD R5, R2, R5		; If the sum is 0  then its +
	BRz PLUS			; So we jump to PLUS subroutine
	
	LD R5, SUB_SIGN		; Load value of * and add it with negative value of sign
	ADD R5, R2, R5		; If the sum is 0  then its -
	BRz MINUS			; So we jump to MINUS subroutine
	
	LD R5, DIV_SIGN		; Load value of * and add it with negative value of sign
	ADD R5, R2, R5		; If the sum is 0  then its /
	BRz DIVIDE			; So we jump to DIVIDE subroutine

IS_UNDERFLOW			; Underflow occured
	JSR PUSH			; If there was only one number then push it back in memory
	LEA R0, INVALID		; Load R0 with string

	PUTS				; Display the string on display
	HALT				; End program

MULT_SIGN	.FILL x2A	;
ADD_SIGN	.FILL x2B	;
SUB_SIGN	.FILL x2D	;
DIV_SIGN	.FILL x2F	;
INVALID		.STRINGZ "Invalid Expression"
NEXT_VAL_R7	.BLKW #1	;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R3, R4
; out: R0

PLUS					; Your code goes here
						;
	ADD R0, R3, R4		; Adding R3 + R4 -> R0
	JSR PUSH			;
	ADD R1, R1, #1		; Increment the memory address
	JSR NEXT_VAL		;

PLUS_R7		.BLKW #1	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R3, R4
; out: R0

MINUS					; Your code goes here
						;
	NOT R4, R4			; Making the value in R4 negative
	ADD R4, R4, #1		; 
	ADD R0, R3, R4		; Subtracting R3 - R4 -> R0
	JSR PUSH			;
	ADD R1, R1, #1		; Increment the memory address
	JSR NEXT_VAL		;
					
MINUS_R7	.BLKW #1	;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R3, R4
; out: R0 = R3 x R4

MULTIPLY				; your code goes here
						;
	AND R0, R0, #0		; Clear R0
	AND R5, R5, #0		; Clear R5
	AND R6, R6, #0		; Clear R6
	
CHECK_1					; Checking if the first number is negative 
	ADD R3, R3, #0		; If negative flag it
	BRn FLAG_1			;
	
CHECK_2					; Checking if the second number is negative 
	ADD R4, R4, #0		; If negative flag it
	BRn FLAG_2			;
	BRzp LOOP			; Otherwise goto multiplication loop
	
FLAG_1					; We flag the value here
						; 
	ADD R5, R5, #1		; Add 1 to R5 to indicate the flag
	NOT R3, R3			; Make the first value positive
	ADD R3, R3, #1		;
	ST R5, M_1			; Store the value in R5
	BRnzp CHECK_2		; We go back to check if second value is negative, we do NOT want to keep going down
	
FLAG_2					; We flag the value here
						;
	ADD R6, R6, #1		; Same as flagging in R5, but we use register R6
	NOT R4, R4			; Make value positive
	ADD R4, R4, #1		;
	ST R6, M_2			; Here we can continue to the loop
						
LOOP					;
	ADD R0, R0, R3   	; R0 <- R3, copying R3 into R0
	ADD R4, R4, #-1 	; Once you add the value into R0, you subtract the other operand
	BRp LOOP        	; If the second number is still positive then go ahead LOOP
	
CHECK_MULT_SIGN			; We have done the multiplcation now we check if flagged any values
						;
	AND R4, R4, #0		; Clear R4, becuase we'll need it for addition
	LD R5, M_1			; Restore the value of flag
	LD R6, M_2			; 
	
	NOT R5, R5			; Make R5 -> -R5
	ADD R5, R5, #1		;
	ADD R4, R5, R6		; Add the two flagged values
	BRz MUL_POS			; If zero means we have a positive value, becuase 0 + 0 = 0 = 1 - 1
	BRnp MUL_NEG		; If -1 or 1 means we had one of negative value, so we modify the outcome of multiplicaiton
		
MUL_POS					;	
	JSR PUSH			; Push the number in R0 onto the stack once done multiplying
	ADD R1, R1, #1		; Increment the memory address
	JSR NEXT_VAL		; 

MUL_NEG					; Change the R0 -> -R0
						;
	NOT R0, R0			;
	ADD R0, R0, #1		;
	JSR PUSH			; PUSH the negative multiplied value into stack
	JSR NEXT_VAL		; Go get the next value

M_1		.BLKW #1		;
M_2		.BLKW #1		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R3, R4
; out: R0 - quotient (R0 = R3 / R4), R1 - remainder 

DIVIDE
; your code goes here
	ST R1, DIV_R1		; Store R1 becuase it'll be changed in this operation
	
	AND R5, R5, #0		; Clear R5
	AND R6, R6, #0		; Clear R6
	AND R0, R0, #0		; Clear R0
	
CHECK_N					; Checking the NUMERATOR to see if its negative
						; If its negative we flag it
	ADD R3, R3, #0		; 
	BRn FLAG_N			;
	
CHECK_D					; Checking the DENOMINATOR to see if its negative
						; If it is negative we flag it
	ADD R4, R4, #0		;
	BRn	FLAG_D			;
	BRzp DIVISION		;
	
FLAG_N					; If NUMERATOR is negative, we change it postive number and flag it
	ADD R5, R5, #1		; Change it to postive and perfom normal division and at the end we store it as negative quotient
	NOT R3, R3			;
	ADD R3, R3, #1		;
	ST R5, F_N			;
	BRnzp CHECK_D
	
FLAG_D					; If DENOMINATOR is negative, we change it to positive number 
	ADD R6, R6, #1		; Perform normal division and at change it to negative quotient
	NOT R4, R4			;
	ADD R4, R4, #1		;
	ST R6, F_D			;

DIVISION				; -D 
						;
	NOT R2, R4			;
	ADD R2, R2, #1		;
	
DIV_LOOP 				; While R >= D
						;
	ADD R5, R3, R2		; This is the important loop
	BRn DONE_2			; We do the division here
	ADD R0, R0, #1		; To divide we basically subtract the denominator and add 1 to R0, if it succeds
	ADD R3, R3, R2		; This way we get the quotient
	BRnzp DIV_LOOP		;
	
DONE_2					;
						;
	ADD R1, R3, #0		; REMAINDER
	LD R5, F_N			;
	LD R6, F_D			;
	
CHECK_FOR_POS_NEG		; Here we check if flagged a negative value
						; If we did flag then we pick it up here and perfom a check for it
	AND R4, R4, #0		; If one of the value was negative, then we change the quotient to negative
	NOT R5, R5			; Otherwise we leave it as is
	ADD R5, R5, #1		;
						;
	ADD R4, R5, R6		;
	BRz SAVE_POS		;
	BRnp SAVE_NEG		;
	
SAVE_POS				; Since the N and D were postivie, we store then into memory and PUSH quotient to stack
						;
	ST R0, QUOTIENT		;
	ST R1, REMAINDER	;
	JSR PUSH			;
	BRnzp NEXT_VAL_TIME ;
	
SAVE_NEG				;
						;
	NOT R0, R0			;
	ADD R0, R0, #1		;
	NOT R1, R1			;
	ADD R1, R1, #1		;
	ST R0, QUOTIENT		;
	ST R1, REMAINDER	; Make the quotient negative, store in memory, and push to stack.
	JSR PUSH			;
	BRnzp NEXT_VAL_TIME ;
	
	
NEXT_VAL_TIME			;
						;
	LD R1, DIV_R1		;
	ADD R1, R1, #1		; Increment the memory address
	JSR NEXT_VAL		;

DIV_R1	.BLKW #1		;
F_N		.BLKW #1		;
F_D		.BLKW #1		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IN: R0
; OUT: R5 (0-success, 1-fail/overflow)
; R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	; save R3
	ST R4, PUSH_SaveR4	; save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		; stack is full
	STR R0, R4, #0		; no overflow, store value in the stack
	ADD R4, R4, #-1		; move top of the stack
	ST R4, STACK_TOP	; store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET

PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


; OUT: R0, R5 (0-success, 1-fail/underflow)
; R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	; save R3
	ST R4, POP_SaveR4	; save R3
	AND R5, R5, #0		; clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET

POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;

STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;


.END
