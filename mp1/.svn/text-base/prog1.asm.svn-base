;
; The code given to you here implements the histogram calculation that 
; we developed in class.  In programming lab, we will add code that
; prints a number in hexadecimal to the monitor.
;
; Your assignment for this program is to combine these two pieces of 
; code to print the histogram to the monitor.
;
; If you finish your program, 
;    ** commit a working version to your repository  **
;    ** (and make a note of the repository version)! **


	.ORIG	x3000		; starting address is x3000


;
; Count the occurrences of each letter (A to Z) in an ASCII string 
; terminated by a NUL character.  Lower case and upper case should 
; be counted together, and a count also kept of all non-alphabetic 
; characters (not counting the terminal NUL).
;
; The string starts at x4000.
;
; The resulting histogram (which will NOT be initialized in advance) 
; should be stored starting at x3F00, with the non-alphabetic count 
; at x3F00, and the count for each letter in x3F01 (A) through x3F1A (Z).
;
; table of register use in this part of the code
;    R0 holds a pointer to the histogram (x3F00)
;    R1 holds a pointer to the current position in the string
;       and as the loop count during histogram initialization
;    R2 holds the current character being counted
;       and is also used to point to the histogram entry
;    R3 holds the additive inverse of ASCII '@' (xFFC0)
;    R4 holds the difference between ASCII '@' and 'Z' (xFFE6)
;    R5 holds the difference between ASCII '@' and '`' (xFFE0)
;    R6 is used as a temporary register
;

	LD R0,HIST_ADDR      	; point R0 to the start of the histogram
	
	; fill the histogram with zeroes 
	AND R6,R6,#0		; put a zero into R6
	LD R1,NUM_BINS		; initialize loop count to 27
	ADD R2,R0,#0		; copy start of histogram into R2

	; loop to fill histogram starts here
HFLOOP	STR R6,R2,#0		; write a zero into histogram
	ADD R2,R2,#1		; point to next histogram entry
	ADD R1,R1,#-1		; decrement loop count
	BRp HFLOOP		; continue until loop count reaches zero

	; initialize R1, R3, R4, and R5 from memory
	LD R3,NEG_AT		; set R3 to additive inverse of ASCII '@'
	LD R4,AT_MIN_Z		; set R4 to difference between ASCII '@' and 'Z'
	LD R5,AT_MIN_BQ		; set R5 to difference between ASCII '@' and '`'
	LD R1,STR_START		; point R1 to start of string

	; the counting loop starts here
COUNTLOOP
	LDR R2,R1,#0		; read the next character from the string
	BRz PRINT_HIST		; found the end of the string

	ADD R2,R2,R3		; subtract '@' from the character
	BRp AT_LEAST_A		; branch if > '@', i.e., >= 'A'
NON_ALPHA
	LDR R6,R0,#0		; load the non-alpha count
	ADD R6,R6,#1		; add one to it
	STR R6,R0,#0		; store the new non-alpha count
	BRnzp GET_NEXT		; branch to end of conditional structure
AT_LEAST_A
	ADD R6,R2,R4		; compare with 'Z'
	BRp MORE_THAN_Z         ; branch if > 'Z'

; note that we no longer need the current character
; so we can reuse R2 for the pointer to the correct
; histogram entry for incrementing
ALPHA	ADD R2,R2,R0		; point to correct histogram entry
	LDR R6,R2,#0		; load the count
	ADD R6,R6,#1		; add one to it
	STR R6,R2,#0		; store the new count
	BRnzp GET_NEXT		; branch to end of conditional structure

; subtracting as below yields the original character minus '`'
MORE_THAN_Z
	ADD R2,R2,R5		; subtract '`' - '@' from the character
	BRnz NON_ALPHA		; if <= '`', i.e., < 'a', go increment non-alpha
	ADD R6,R2,R4		; compare with 'z'
	BRnz ALPHA		; if <= 'z', go increment alpha count
	BRnzp NON_ALPHA		; otherwise, go increment non-alpha

GET_NEXT
	ADD R1,R1,#1		; point to next character in string
	BRnzp COUNTLOOP		; go to start of counting loop



PRINT_HIST

; you will need to insert your code to print the histogram here

; do not forget to write a brief description of the approach/algorithm
; for your implementation, list registers used in this part of the code,
; and provide sufficient comments

		AND R0, R0, #0				;R0 - Used to store loop counter, also a temp register to check conditions or copy values over for OUT
		AND R1, R1, #0				;R1	- 4 bit counter
		AND R2, R2, #0				;R2 - Used to contain values we loaded from memory address from x3F00 to x3F1A
		AND R3, R3, #0				;R3 - Used to store transfered shifted values 
		AND R4, R4, #0				;R4 - Contains memory address, gets incrimented
		AND R5, R5, #0				;R5 - Used to load values for character, gets incrimented 
		AND R6, R6, #0				;R6 - 4 digit counter
		
		LD R4, HIST_ADDR			; Contains the address of histogram
		LD R0, NUM_BIN				; Contains the value of 26
		ST R0, SAVE_R0				; Saves R0, so we know exactly where we left off in the count later on
		LDR R2, R4, #0				; Contains the value of occurances
		LD R5, AT					; Load the value of '@' so we can print accordingly
		ST R5, SAVE_R5				; Saving R5, so we know which character we left off at
		ADD R0, R5, #0				;
		OUT							; Print '@'
		LD R5, ASCII_SPACE			;
		ADD R0, R5, #0				;
		OUT							; Print ' '
		BRnzp DIGIT_COUNTER			;

NEXT	
		LD R5, ASCII_NL				; Load '\n' newline
		ADD R0, R5, #0				;
		OUT							; Print the newline char
		LD R0, SAVE_R0				; Load the previous number such as 26, so we know we have to do the loop 26 more times
		ADD R4, R4, #1				; Add one to the memory address
		LDR R2, R4, #0				; Load the value stored at the memory address
		ADD R0, R0, #-1				; Decrement the loop counter
		BRn DONE					; If you get a negative number then you are done, had problems keeping this at nz so changed to n
		ST R0, SAVE_R0				; Store R0, so we can use R0 as a checker later on
		AND R6, R6, #0				; Clear R6
		LD R5, SAVE_R5				; Load the previous character printed such as '@' or 'D'
		ADD R5, R5, #1				; Add one to the character hex so get the char we have to print
		ST R5, SAVE_R5				; Save the value so we can use it again and increment it when loop comes here
		ADD R0, R5, #0				; Copy the value over to print
		OUT							; Print the new character
		LD R5, ASCII_SPACE			; Load ' '
		ADD R0, R5, #0				; Copy
		OUT							; Print
		
		
DIGIT_COUNTER
		ADD R6, R6, #1				; Add one to Digit Counter
		ADD R0, R6, #-4				; R0 is a checker
		BRp NEXT					; -3, -2, -1, 0.When positive we know we accesed all the digits

		
BIT_COUNTER
		ADD R0, R1, #-4				; R0 is a checker, R1 is bit counter
		BRzp PRINT					; Once we read 4 bits, we go to print the value
		ADD R3, R3, R3				; R3 is used to transfer values, here we shift it
		ADD R2, R2, #0				; Just a check to see if we can add 1 or 0 to R3
		BRzp SHIFT					; Jump to shift
		ADD R3, R3, #1				; Add '1' to R3 if the left most bit(R2) is '1'
SHIFT
		ADD R2, R2, R2				; Multiply R2 by itself to Shift the values down
		ADD R1, R1, #1				; Add 1 to the bit counter
		BRnzp BIT_COUNTER			; Jump back to bit counter
		
PRINT
		ADD R0, R3, #-9				; Add '-9' to current value in R3
		BRnz PRINT_NUM				; If number stored in R0 is negative or zero then its a digit
		BRp  PRINT_DIG				; otherwise it has to be a letter
		
PRINT_NUM
		LD R5, ASCII_0				; load R5 with '0'
		ADD R0, R5, R3				; 
		OUT							; Print the correct number
		AND R1, R1, #0				; Clear R1 for counter
		AND R3, R3, #0				; Clear R3 for next bit
		BRnzp DIGIT_COUNTER			;
	
PRINT_DIG
		LD R5, ASCII_A				; Load R5 with 'A'
		ADD R0, R5, #-10			;
		ADD R0, R0, R3				;
		OUT							; Print the correct alphabet
		AND R1, R1, #0				; Clear R1 for counter
		AND R3, R3, #0				; Clear R3 for next bit
		BRnzp DIGIT_COUNTER			;

		


DONE	HALT			; done


; the data needed by the program
NUM_BINS	.FILL #27				; 27 loop iterations
NEG_AT		.FILL xFFC0				; the additive inverse of ASCII '@'
AT_MIN_Z	.FILL xFFE6				; the difference between ASCII '@' and 'Z'
AT_MIN_BQ	.FILL xFFE0				; the difference between ASCII '@' and '`'
HIST_ADDR	.FILL x3F00 			; histogram starting address
STR_START	.FILL x4000	; string starting address
ASCII_A 	.FILL x41
ASCII_0 	.FILL x30
ASCII_SPACE .FILL x20
ASCII_NL	.FILL x0A
AT			.FILL x40
SAVE_R0		.BLKW #1
SAVE_R5		.BLKW #1
NUM_BIN		.FILL #26


; for testing, you can use the lines below to include the string in this
; program...
; STR_START	.FILL STRING	; string starting address
; STRING		.STRINGZ "This is a test of the counting frequency code.  AbCd...WxYz."



	; the directive below tells the assembler that the program is done
	; (so do not write any code below it!)

	.END
