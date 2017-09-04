; Programming Lab 2 
; assignment: develop a code to print a value stored in a register 
;             as a hexadecimal number to the monitor
; algorithm: turnin each group of four bits into a digit
;            calculate the corresponding ASCII character;
;            print the character to the monitor
;
;	R0- Used for checking/conditions
;	R1- Bit counter
;	R2-	Load value into it
;	R3- Multiplied values go here
;	R4- NOT USED
;	R5- Load values that you wanna print here
;	R6- Digit counter
;	R7- NOT USED

		.ORIG x3000

		AND R0, R0, #0				; Clear R0
		AND R1, R1, #0				; Clear R1
		AND R3, R3, #0				; Clear R3

DIGIT_COUNTER
		ADD R6, R6, #1				; Add one to Digit Counter
		ADD R0, R6, #-4				; R0 is a checker
		BRp STOP					; -3, -2, -1, 0.When positive we know we accesed all the digits
		
BIT_COUNTER
		ADD R0, R1, #-4				; R0 is a checker, R1 is bit counter
		BRzp PRINT					; Once we read 4 bits, we go to print the value
		ADD R3, R3, R3				; R3 is used to transfer values, here we shift it
		ADD R5, R5, #0				; Just a check to see if we can add 1 or 0 to R3
		BRzp SHIFT					; Jump to shift
		ADD R3, R3, #1				; Add '1' to R3 if the left most bit(R5) is '1'
SHIFT
		ADD R5, R5, R5				; Multiply R5 by itself to Shift the values down
		ADD R1, R1, #1				; Add 1 to the bit counter
		BRnzp BIT_COUNTER			; Jump back to bit counter
		
PRINT
		ADD R0, R3, #-9				; Add '-9' to current value in R3
		BRnz PRINT_NUM				; If number stored in R0 is negative or zero then its a digit
		BRp  PRINT_DIG				; otherwise it has to be a letter
		
PRINT_NUM
		LD R2, ASCII_0				; load R2 with '0'
		ADD R0, R2, R3				; 
		OUT							; Print the correct number
		AND R1, R1, #0				; Clear R1 for counter
		AND R3, R3, #0				; Clear R3 for next bit
		BRnzp DIGIT_COUNTER			;
	
PRINT_DIG
		LD R2, ASCII_A				; Load R2 with 'A'
		ADD R0, R2, #-10			;
		ADD R0, R0, R3				;
		OUT							; Print the correct alphabet
		AND R1, R1, #0				; Clear R1 for counter
		AND R3, R3, #0				; Clear R3 for next bit
		BRnzp DIGIT_COUNTER			;


; stop the computer
STOP HALT

; program data section starts here

ASCII_A .FILL x41
ASCII_0 .FILL x30


.END

