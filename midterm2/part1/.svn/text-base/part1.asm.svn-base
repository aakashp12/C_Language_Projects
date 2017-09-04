.ORIG x3000

;int main()
;{
;    int a, b=5;
;    int array[5] = { 5, 4, 3, 2, 1 };
;
;    a = function(array, &b);
;
;    printf("a=%d, b=%d\n", a, b);
;
;    return 0;
;}
MAIN
    ; setup stack
    LD R5, STACKTOP   ; R5 - frame pointer for main()
    LD R6, STACKTOP   ; R6 - ToS pointer
    ADD R6 , R6 , #1  ; stack is initially empty

    ; allocate and initalize local variables
    ADD R6, R6, #-1  ; push a

    ADD R6, R6, #-1  ; push b

    AND R0, R0, #0   ; b = 5;
    ADD R0, R0, #5
    STR R0, R6, #0

    ADD R6, R6, #-5  ; push array

    AND R0, R0, #0
    ADD R0, R0, #5   ; array[0]=5
    STR R0, R6, #0
    ADD R0, R0, #-1   ; array[1]=4
    STR R0, R6, #1
    ADD R0, R0, #-1   ; array[2]=3
    STR R0, R6, #2
    ADD R0, R0, #-1   ; array[3]=2
    STR R0, R6, #3
    ADD R0, R0, #-1   ; array[4]=1
    STR R0, R6, #4

    ; call subroutine

    ; IMPLEMENT THIS: push &b onto the stack 
    AND R1, R1, #0		; CLEAR R1
    ADD R1, R6, #5		; R1 <- ADDR OF B
    ADD R6, R6, #-1		;
    STR R1, R6, #0		; stored the address of b into stack

    ; IMPLEMENT THIS: push array base address onto the stack 
    
    ADD R1, R6, #1		; R1 <- ADDR OF ARRAY[0]
    ADD R6, R6, #-1		;
    STR R1, R6, #0		; PASSED THE ADDR OF ARRAY[0]

    ; call subroutine
    JSR FUNCTION

    ; get return value
    LDR R0, R6, #0
    ADD R6, R6, #1 ; pop return value
    STR R0, R5, #0 ; a = return value

    ; ignore printf("a=%d, b=%d\n", a, b);

    ; free stack
    ADD R6, R6, #2 ; pop arguments
    ADD R6, R6, #7 ; pop local variables

HALT           ; return

STACKTOP .FILL x30FF


;int function(int array[], int *n)
;{
;    /* terminal case */
;    if (*n == 0) return 0;
;
;    /* reduction case */
;    *n = *n - 1;
;    return array[*n] + function(array, n);
;}
FUNCTION
; R0 - used to load values
; R1 - used to load values
; R2 -  not used
; R3 - Not used
;
    ; IMPLEMENT THIS: push bookkeeping info onto the stack

	ADD R6, R6, #-1		; SPACE FOR RET VAL
	
	ADD R6, R6, #-1		; SPACE FOR RET ADDR
	STR R7, R6, #0		; SAVE RET ADDR
	
	ADD R6, R6, #-1		; SPACE FOR FRAME POINTER
	STR R5, R6, #0		; SAVE FRAME POINTER
	
    ; setup frame pointer
    ADD R5, R6, #-1		; points at local var

TERMINAL_CASE
    ;    /* terminal case */
    ;    if (*n == 0) return 0;
    
    LDR R0, R5, #5
    LDR R1, R0, #0
    BRp REDUCTION_CASE
    ; return 0
    AND R0, R0, #0
    STR R0, R5, #3
    BR DOWN

REDUCTION_CASE
    ;    /* reduction case */
    ; IMPLEMENT THIS: *n = *n - 1;
	
	LDR R0, R5, #5		;
	LDR R1, R0, #0		; GET VALUE OF n
	ADD R1, R1, #-1		; n -1
	STR R1, R0, #0		; STORE IT BACK
	
    ;    return array[*n] + function(array, n);
    ; IMPLEMENT THIS: R0 <- array[*n]

	LDR R1, R5, #4		; ADDR OF ARRAY[0]
	LDR R0, R5, #5		; GET n
	LDR R0, R0, #0		; GET n
	ADD R1, R1, R0		; ADDR OF ARRAY[0] + n
	LDR R0, R1, #0		; R0 <- ARRAY[*n]

    ; temporary store array[*n] (R0) on the stack
    STR R0, R5, #3   ; save array[*n] in temp storage

    ; setup function call
    LDR R0, R5, #5
    ADD R6, R6, #-1
    STR R0, R6, #0

    LDR R0, R5, #4
    ADD R6, R6, #-1
    STR R0, R6, #0

    JSR FUNCTION

    ; IMPLEMENT THIS: get return value 
                     ; R0 <- function(array, n)
                     ; pop return value and 2 function arguments
   
    LDR R0, R6, #0	; GET RET VAL
   	ADD R6, R6, #1	; POP RET VAL
   	
   	ADD R6, R6, #2	; POP FUNCTION ARGUMENTS 
                     

    LDR R1, R5, #3   ; read array[*n] from temp storage

    ADD R0, R0, R1   ; R0 <- array[*n] + function(array, n)
    STR R0, R5, #3   ; store return value  

DOWN
    ; restore R5/R7 and return
    LDR R5, R6, #0
    ADD R6, R6, #1 ; pop R5
    LDR R7, R6, #0
    ADD R6, R6, #1 ; pop R7
RET


.END


