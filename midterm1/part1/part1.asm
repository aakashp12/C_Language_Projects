
; R0 - INPUT
; R1 - USED FOR OUTS LOOP
; R2 - TEMP REGISTER USED TO LOAD VALUES AND CHECK VALULES
; R3 - USED IN PUSH AND POP
; R4 - USED IN PUSH AND POP
; R5 - USED TO CHECK CONDITIONS
; R6 - NOT USED
; R7 - STORE ADDRESS FOR RESULT
;
;

.ORIG x3000

; main code goes here

	JSR IS_BALANCED	; Jump
	LD R0, RESULT	; I have stored the result of the program in RESULT, check there
    HALT


; IS_BALANCED subroutine implementation goes here

IS_BALANCED
	ST R7, MAIN_R7	; STORE THE RETURN ADDRESS SO WE CAN RETURN TO MAIN PROGRAM
	AND R0, R0, #0	; CLEAR R0 AND R1 FOR USE
	AND R1, R1, #0	;
	
GETS
	JSR GET			;	MAKES A CALL TO GETS WHICH GETS THE INPUT
	JSR OUTS		;	MAKES A CALL TO OUTS WHICH OUTPUTS THE INPUT, THEY ARE IMPLIMENTED ALL THE WAY DOWN

	LD R2, ASCII_ENTER	; LOAD THE ASCII ENTER VALUE 
	NOT R2, R2		;
	ADD R2, R2, #1	;
	ADD R2, R0, R2	; IF 0 THEN ENTER WAS PRESSED
	BRz PRESSED_ENTER
	
IF_OPEN_PAR
	LD R2, ASCII_OPEN	; LOAD THE ASCII ( AND CHECK IF IT WAS PRESSED IF SO THEN PUSH IT TO STACK
	NOT R2, R2		;
	ADD R2, R2, #1	;
	ADD R2, R0, R2	; IF 0 THEN ( WAS PRESSED
	BRz	OPEN_PAR	;
	
IF_CLOSE_PAR
	LD R2, ASCII_CLOSE	; LOAD THE ASCII ) AND CHECK IF IT WAS PRESSED IF SO THEN POP AND CHECK
	NOT R2, R2		;
	ADD R2, R2, #1	;
	ADD R2, R0, R2	; IF 0 THEN ) WAS PRESSED
	BRz CLOSE_PAR	;
	
	
OPEN_PAR
	JSR PUSH		;	PUSH IT TO STACK
	BRnzp GETS		;	GET ANOTHER VALUE

CLOSE_PAR			;	
	JSR POP			;	POP A VALUE FROM STACK AND SEE IF IT WAS (
	LD R2, ASCII_OPEN	;
	NOT R2, R2		;
	ADD R2, R2, #1	;
	ADD R2, R0, R2	;	IF IT WAS ( THEN WE HAVE A COMPLETE MATCH
	BRz MATCH		;
	
NOT_MATCH
	AND R0, R0, #0	;	IF NOT A MATCH WE RETURN 0 AND END PROGRAM
	ST R0, RESULT	;
	LD R7, MAIN_R7	; Return to main program
    RET

MATCH
	AND R0, R0, #0	; MATCH RETURN RESULT AS 1
	ADD R0, R0, #1	;
	ST R0, RESULT	; 
	BRnzp GETS		; GO GET MORE VALUES
	
PRESSED_ENTER
	JSR POP			; IF R5 IS 1 THEN ITS EMPTY
	ADD R5, R5, #0	;
	BRp ENT_MATCH		; IF EMPTY RETURN 1
	BRnz NOT_MATCH	; IF NOT EMPTY RETURN 0
	
GET
	ST R7, GETS_R7	; THIS IS THE IMPLIMENTED VERSION OF GETC
	LDI R0, KBSR	;
	BRzp GETS		;
	LDI R0, KBDR	;
	LD R7, GETS_R7	;
	RET
	
OUTS
	ST R7, OUTS_R7	; IMPLEMENTEE VERSION OF OUT
	LDI R1, DSR		;
	BRzp OUTS		;
	STI R0, DDR		;
	LD R7, OUTS_R7	;
	RET

ENT_MATCH
	AND R0, R0, #0	; THIS IS ENTER MATCH
	ADD R0, R0, #1	; IF WE HAS A COMPLETE PAIR SO FAR WE STORE 1 IN R0 AND SAVE IT
	ST R0, RESULT	; 
	LD R7, MAIN_R7	; RETURN TO MAIN PROGRAM AND CALL IT DONE
	RET
	

ASCII_ENTER .FILL xD
ASCII_OPEN .FILL x28  ; ASCII value for '('
ASCII_CLOSE .FILL x29  ; ASCII value for ')'

KBSR .FILL xFE00
KBDR .FILL xFE02
DSR  .FILL xFE04
DDR  .FILL xFE06

MAIN_R7	.BLKW #1	;
RESULT  .BLKW #1	;
GETS_R7	.BLKW #1	;
OUTS_R7 .BLKW #1	;


; Do Not Write Below This Line!
; ----------------------------------

; PUSH onto the stack 
; IN: R0
; OUT: R5 (0-success, 1-fail/overflow)
; Used registers: R3: STACK_END R4: STACK_TOP
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


; POP from the stack
; OUT: R0, R5 (0-success, 1-fail/underflow)
; Used registers: R3 STACK_START R4 STACK_TOP
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


