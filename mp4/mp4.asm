;
; In this MP we were trying to implement the run-time stack in LC3
; The code given to us already called the function FOO!1, however, it wasn't ready 
; For us to use yet, I allocated memory for Return value, Return Address, Frame pointer
; And for local variables. Once I did that, I went on to retrive the X and Y values stored 
; In FOO1's activation record. ONCE i got the values, i went on to make a for loop, which 
; Was easy, just had to implement conditon codes. Inside the For loop, i called for FOO2
; Once I jumped too FOO2, i created the activation record for it. So i allocated memory for
; Value of Y and TOTAL, Return Value, Return ADDR, Frame PTR,  and one local variable.
; I performed the given addition in FOO2, then I stored the value in Return Value memory location
; Annd upon return I stored the return value in local variable of FOO1 (TOTAL), and then I poped the 
; Return value, and arguments from FOO2 stack. And i kept performing this same loop until our condtion's 
; Were met. Returning from FOO1 to MAIN, I had to destory FOO1's local variable, Frame PTR, Return ADDR.
; I stored TOTAL into Return Value memory locaiton. So once you return to MAIN, R6 is pointing at Return Value
; Then the code already written takes care of the rest. 
;

.ORIG x3000

;;R5 - frame pointer
;;R6 - stack pointer

;;MAIN - DO NOT CHANGE ANY CODE HERE
  LD R6, STACK
  LD R5, STACK

  ADD R6, R6, #-2 ; make space for local variables

  ; fake scanf("%d %d", &x, &y); 
  LD R0, X_VAL
  STR R0, R5, #0 ; x <- 5
  LD R0, Y_VAL
  STR R0, R5, #-1 ; y <- 4
  
;;CALL FOO1 SUBROUTINE - DO NOT CHANGE ANY CODE HERE

  ADD R6, R6, #-1
  ADD R3, R5, #-1
  STR R3, R6, #0   ; push address of y on to run-time stack

  ADD R6, R6, #-1
  STR R5, R6, #0   ; push address of x on to run-time stack

  JSR FOO1

;;STACK TEAR-DOWN FOR FOO1 - DO NOT CHANGE ANY CODE HERE
  LDR R0, R6, #0
  ST R0, Z_VAL     ; fake printf("z = %d\n", z);
  ADD R6, R6, #3   ; pop retval and parameters from the stack
 
;;“return 0“ - DO NOT CHANGE ANY CODE HERE
  ADD R6, R6, #3
HALT

STACK .FILL x4000

X_VAL .FILL x5
Y_VAL .FILL x4
Z_VAL .BLKW #1



;;;;;;;;;;;;;;;;;;;;;;;; FOO1 ;;;;;;;;;;;;;;;;;;;;;;;;; 
;;IMPLEMENT ME: FOO1 SUBROUTINE

;
;	R0 - Temp register/ holder of TOTAL
;	R1 - Holds value of Y
;	R2 - Holds value of X
;	R3 - Not used
;	R4 - Not used
;	R5 - Used for frame pointer
;	R6 - Used for stack top pointer
;	R7 - Used for return address
;

FOO1

;;;;;;;  BOOK KEEPING	;;;;;;;
	ADD R6, R6, #-1		; make space for return value
RETURN_VAL
	AND R0, R0, #0		; load it intially with 0
	STR R0, R6, #0		;
RETURN_ADDRS
	ADD R6, R6, #-1		; make space for return address
	STR R7, R6, #0		; store the return address to this call in run time stack
FRME_PTR	
	ADD R6, R6, #-1		; make space for caller'S frame pointer
	STR R5, R6, #0		; value of R5 onto stack
;;;;;;;  BOOK KEEPING	;;;;;;;
	
;;;;;;;  LOCAL VARS		;;;;;;;
LOCAL_VAR
	ADD R5, R6, #-1		; R5 < R6 - 1
	ADD R6, R6, #-1		; space for temp variable total
	STR R0, R6, #0		; load it initially with 0
;;;;;;; LOCAL VARS      ;;;;;;;

;;;;;;; GETTINNG X & Y  ;;;;;;;
GET_VALS
	LDR R1, R6, #5		; 
	LDR R1, R1, #0		; load value of Y into R1
	
	LDR R2, R6, #4		;
	LDR R2, R2, #0		; load value of X into R2
;;;;;;; GETTINNG X & Y  ;;;;;;;
	
;;;;;;;;; ARGS FOR FOO2	;;;;;;;;;;;
PUSH_Y
	ADD R6, R6, #-1		; start activation record for FOO2
	STR R1, R6, #0		; push Y value into stack
PUSH_TOTAL	
	ADD R6, R6, #-1		; 
	STR R0, R6, #0		; push TOTAL value into stack
;;;;;;;;; ARGS FOR FOO2   ;;;;;;;;;
	
FOR_LOOP
	ADD R2, R2, #0		;
	BRnz RETURN			; return if X value is 0 OR -
	JSR FOO2			; MAKE CALL HERE TO GOTO FOO2
	
;;;;;;;	RETURN OF FOO2	;;;;;;;
	LDR R0, R6, #0		; R0 = TOTAL <- RETURN VALUE( CURRENT_TOTAL)
	STR R0, R5, #0		; TOTAL <- R0
	ADD R6, R6, #1		;
;;;;;;; RETURN OF F002  ;;;;;;;
	STR R0, R6, #0		;

	ADD R2, R2, #-1		;
	STR R2, R5, #8		; 	
	BRnzp FOR_LOOP		;	

RETURN 
	ADD R6, R6, #2		;
	STR R0, R5, #3		; return value stored
	
	ADD R6, R6, #1		; the local var of current_total is gone
	LDR R5, R6, #0		; pop the frame pointer
	ADD R6, R6, #1		;
	LDR R7, R6, #0 		; load R7 with return address
	ADD R6, R6, #1		;
RET
;;;;;;;;;;;;;;;;;;;;;;; FINISH FOO1 ;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;; FOO2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;IMPLEMENT ME: FOO2 SUBROUTINE

;
;	R0 - Temp register/ holder of CURRENT_TOTAL
;	R1 - Holds value of Y
;	R2 - Not used
;	R3 - Holds value of TOTAL passed from FOO1
;	R4 - Not used
;	R5 - Used for frame pointer
;	R6 - Used for stack top pointer
;	R7 - Used for return address
;

FOO2

	ADD R6, R6, #0		;
;;;;;;;  BOOK KEEPING	;;;;;;;
RETURN_VALUE	
	ADD R6, R6, #-1		; make space for return value
	AND R0, R0, #0		;
	STR R0, R6, #0		; initially load with 0
RETURN_ADDR	
	ADD R6, R6, #-1		; make space for return address
	STR R7, R6, #0		; store the return address to this call in run time stack
FRAME_PTR	
	ADD R6, R6, #-1		; make space for caller'S frame pointer
	STR R5, R6, #0		; value of R5 onto stack
;;;;;;;  BOOK KEEPING	;;;;;;;
	
;;;;;;;  LOCAL VARS		;;;;;;;
LOCAL_VARS
	ADD R5, R6, #-1		; R5 < R6 - 1
	ADD R6, R6, #-1		; space for temp variable current_total
	STR R0, R6, #0		; load it initially with 0
;;;;;;; LOCAL VARS      ;;;;;;;

;;;;;;; GET VALUES 		;;;;;;;
GET_VALUES
	LDR R0, R6, #0		; load value of CURRENT_TOTAL
	
	LDR R1, R6, #5		; load value of Y
	
	LDR R3, R6, #4		; load value of TOTAL
;;;;;;; GET VALUES 		;;;;;;;
ADDITION
	ADD R0, R1, R3		; current_total = total + Y

;;;;;;; RETURN TO FOO1  ;;;;;;;
RETURN_TO_FOO1
	STR R0, R5, #3		; return value stored
	
	ADD R6, R6, #1		; the local var of current_total is gone
	LDR R5, R6, #0		; pop the frame pointer
	ADD R6, R6, #1		;
	LDR R7, R6, #0		; pop the return address
	ADD R6, R6, #1		;
RET
;;;;;;;;;;;;;;;;;;;;;;; FINISH FOO2 ;;;;;;;;;;;;;;;;;;;;;;;

.END

