; Assuming user will only enter ' ' 0-9 *+/-
;
;
;
.ORIG x3000
; Your code goes here  
;
;	R0- Holds the value of key press
;	R1- Used to load in different values, and then transfer values into R2
;	R2- Used to put values into it to store values at x5000 and upward
	
	LD R2, STR_ADDR  

READ
	GETC
	OUT
	
CHECK_FOR_SPACE		;Skip if space
	LD R1, SPACE
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R0, R1
	BRz READ

CHECK_FOR_NEWL		;Goto IF_NEW if you pressed enter
	LD R1, CHAR_RETURN
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R0, R1
	BRz IF_NEW
	
CHECK_FOR_NUM		;Goto IF_NUM if its a number, if not number then goes to IF_SIGN
	LD R1, ZERO
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R0, R1
	BRzp IF_NUM
	BRn  IF_SIGN
	    


HALT
        
STR_ADDR        .FILL x5000             
SPACE           .FILL x0020
NEW_LINE        .FILL x000A
CHAR_RETURN     .FILL x000D



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine: DECODE
; input: R0 holds the input
; output: R0 holds numerical value or negation of the ascii value
;   find the numerical value of if input is an operand, 
;   or find the negation of the ascii value if the input is an operator

DECODE

; Your code goes here

IF_NUM			;If its a number then we change it from hex to normal decimal
	LD R1, ZERO
	NOT R1, R1
	ADD R1, R1, #1
	ADD R1, R0, R1
	STR R1, R2, #0
	ADD R2, R2, #1
	BRnzp READ
	
	
	
IF_SIGN			;We negate the sign value
	NOT R0, R0
	ADD R0, R0, #1
	STR R0, R2, #0
	ADD R2, R2, #1
	BRnzp READ
	
	

IF_NEW			;If its new line char then we halt/stop the program
	LD R1, CHAR_RETURN
	NOT R1, R1
	ADD R1, R1, #1
	STR R1, R2, #0
	HALT


ZERO    .FILL x0030
MULT	.FILL x002A



.END

