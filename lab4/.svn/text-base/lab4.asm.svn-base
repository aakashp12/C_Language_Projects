; Print signed decimal value
;
; This program loads in value from memory(NUM_1) into R0 and jumps to PRINT subroutine
; In the PRINT subroutine we check if the value in R0 is negative or positive
; If the value is negative we change it to postive and flag it and continue to
; Divide normallly, The program has 3 steps it takes to output a decimal value
; First step divides the value by 10, and brings back the remaninder and quotient
; In step 2, if the quotient isn't 0 then we re-do the first step, the remainder gets stored in stack
; Finally in step 3 we start to output values by poping the values we stored in stack
; We add the ZERO OFFSET and OUT the value, and we get our decimal values 
; Thats the whole program. :)

;	R0 - Input for PRINT subroutine
;	R1 - Used to load in the ZERO OFFSET and operate with it to get decimal values
;	R2 - Holds the negative value of denominator, in this case its -10
;	R3 - Value from R0 is copied into R3 for divison
;	R4 - Holds the value of 10, for division 
;	R5 - Temp register to load in values, and also a checker to cehck for conditions
;	R6 - NOT USED
;	R7 - NOT USED


.ORIG x3000

	LD R0, NUM_1		; Load value from memory
	JSR PRINT			; Jump to PRINT subroutine

HALT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine should print value stored in register R0 in decimal format
; input: R0 - holds the input
; output: signed decimal value printed on the display

PRINT
; add your code here
	AND R5, R5, #0		; Clear R5 for future use

STEP_1
	AND R4, R4, #0		; Clear r4
	ADD R4, R4, #10		; R4 <- #10
	ADD R3, R0, #0		; R3 <- R0
	BRn NEG_DIV			; If the value in R3 is negative we flag it
	BRp DIV_HERE		; If the value in R3 is positive, go ahead with division
	
DIV_HERE				
	JSR DIVIDE			; Jump to divide
	LD R0, REMAINDER	; Load the remainder we saved in memory, so we can push to stack
	JSR PUSH			; PUSH to stack
	BRnzp STEP_2		; 

NEG_DIV
	NOT R3, R3			; NOT R3 to make it into positive value
	ADD R3, R3, #1		;	
	AND R5, R5, #0		; Clear R5
	ADD R5, R5, #-1		; Flag that we have a negative value
	ST R5, NEG_VALUE	; Store the flagfed value
	BRnzp DIV_HERE		; Continue to do normal division
	

STEP_2
	LD R0, QUOTIENT		; Load the quotient 
	BRnp STEP_1			; If the quotient isn't 0 then keep dividing
	
STEP_3
	LD R5, NEG_VALUE	; We load the flag
	BRn LOAD_NEG		; If negative then we display a negative sign onto the display
	JSR POP				; POP a value from stack
	ADD R5, R5, #0		; Checking for underflow
	BRp DONE			; If there's no underflow then continue
	LD R1, ZERO_OFFSET	; Load ZERO OFFSET
	ADD R0, R1, R0		; Get the correct value of decimal number
	OUT					; Display it onto the display
	BRnzp STEP_3		; Continue the loop until stack is underflow
	
LOAD_NEG
	LD R0, NEGATIVE		; Output a negative sign
	OUT					;
	AND R5, R5, #0		; Clear R5 so we dont mess it up with underflow stack
	
NEG_PRINT	
	JSR POP				; Same as positive print but for negative numbers
	ADD R5, R5, #0
	BRp DONE
	LD R1, ZERO_OFFSET
	ADD R0, R1, R0
	OUT
	BRnzp NEG_PRINT
	
DONE HALT
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R3, R4
; out: R0 - quotient (R0 = R3 / R4), R1 - remainder 
DIVIDE
; your code goes here
	AND R5, R5, #0
	AND R0, R0, #0

DIVISION
	
	; -D 
	NOT R2, R4
	ADD R2, R2, #1
	
DIV_LOOP 		; While R >= D
	ADD R5, R3, R2
	BRn DONE_2
	ADD R0, R0, #1
	ADD R3, R3, R2
	BRnzp DIV_LOOP
	
DONE_1
	HALT
	
DONE_2
	ADD R1, R3, #0		; REMAINDER
	ST R0, QUOTIENT
	ST R1, REMAINDER

DIV_POS
	RET

	
	

; ======== PUSH/POP subroutines 

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
NEG_VALUE	.BLKW #1	;
REMAINDER 	.BLKW #1	;
QUOTIENT	.BLKW #1	;

STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;
NUM_1		.FILL #-999	;
NEGATIVE	.FILL x2D	;
ZERO_OFFSET	.FILL X30	;



.END
