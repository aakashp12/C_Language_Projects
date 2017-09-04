
.ORIG x3000

; main code goes here

; IMPLEMENT ME!
    ; setup arguments and
    ; call COMPUTE_PRIMES
	
	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0
	
	LD R0, P	; R0 <- P
	LDR R0, R0, #0	;
	LD R1, Q	; R1 <- Q
	LDR R1, R1, #0
	LD R2, R	; STARTING MEMORY ADDRESS
	
	JSR COMPUTE_PRIMES		;
			
    HALT

P .FILL x4000
Q .FILL x4001
R .FILL x4002


; COMPUTE_PRIMES subroutine implementation 
; IN: R0 <- P, R1 <- Q, ([P, Q] interval), R2 <- address
; OUR: R6 <- count
;
COMPUTE_PRIMES

     ST R0, CP_SaveR0
     ST R1, CP_SaveR1
     ST R2, CP_SaveR2
     ST R3, CP_SaveR3
     ST R5, CP_SaveR5
     ST R7, CP_SaveR7

    ; clear counter 
    AND R6, R6, #0

    ; invert Q
    NOT R1, R1
    ADD R1, R1, #1 ; R1 <- -Q

LOOP1 ; from P to Q
    ; check if all processed
    ADD R3, R0, R1
    BRp DONE1

    ; call IS_PRIME for R0
    JSR IS_PRIME

    ; check the outcome
    ADD R5, R5, #0
    BRz NONPRIME

    ; prime, so store it in memory and count
    STR R0, R2, #0
    ADD R2, R2, #1
    ADD R6, R6, #1 ; increment counter

NONPRIME
    ; move on
    ADD R0, R0, #1
    BR LOOP1

DONE1
     LD R0, CP_SaveR0
     LD R1, CP_SaveR1
     LD R2, CP_SaveR2
     LD R3, CP_SaveR3
     LD R5, CP_SaveR5
     LD R7, CP_SaveR7

    RET

CP_SaveR0 .BLKW #1
CP_SaveR1 .BLKW #1
CP_SaveR2 .BLKW #1
CP_SaveR3 .BLKW #1
CP_SaveR5 .BLKW #1
CP_SaveR7 .BLKW #1


; IS_PRIME subroutine implementation goes here

IS_PRIME

; IMPLEMENT ME! 
;
; R0 - INPUT
; R1 - HAS THE VALUE OF INPUT TO BE USED IN SUBROUTINE DIVIDE
; R2 - USED AS DENOMIATOR VALUE
; R3 - HAS REMAINDER IN IT
; R4 - USED AS A CHECKER
; R5 - HOLDS THE VALUE OF -2 TO CHECK IF WE REACHED THE LOWEST DENOMINATOR VALUE
; R6 - NOT USED
; R7 - HOLDS THE RETURN ADDRESS TO JSR CALLS
;

     ST R1, IP_SaveR1
     ST R2, IP_SaveR2
     ST R3, IP_SaveR3
     
	AND R5, R5, #0

	ST R7, PRIME_R7 ; ADDRESS TO GO BACK ( RET)
	ADD R0, R0, #0  ; THIS IS THE INPUT WE GET FROM COMPUTE_PRIMES
	ST R0, PRIME_R0	; STORE IT IN CASE IT CHANGES

CHECK_2
	ADD R5, R5, #-2	; IF ITS 2 THEN WE RETURN R5 AS 1
	ADD R5, R5, R0	;
	BRz RET_2		; RETURN THE CORRECT VALUES FOR 2
	
CHECK_3
	ADD R5, R5, #-3	;
	ADD R5, R5, R0	;
	BRz RET_3		; IF 3, RETURN CORRET VALUES FOR THREE
	
OTHER_NUMS
	AND R2, R2, #0
	AND R5, R5, #0	;	
	ADD R1, R0, #0	; DIVIDE USES R1 AS NUMERATOR
	ADD R2, R2, #2	; NEED TO GET A VALUE FOR N/2
	JSR DIVIDE		;
	ADD R2, R0, #0	; WE GET THE N/2 BACK
	ADD R5, R5, #2	;
	NOT R5, R5
	ADD R5, R5, #1	; R5 <- -2
	
	
DIV_LOOP
	JSR DIVIDE		; DIVIDE NUMBER IN QUESTION WITH A NUMBER LIKE 2, 3, 4, 5, 6 ... N/2 TO CHECK IF PRIME
	ADD R3, R3, #0	; CHECK IF REMAINDER IS 0, IF REMAINDER 0 THEN 'N' GOT DIVIDED COMPLETELY
	BRz GO_BACK		;
	ADD R2, R2, #-1	; DECREMENT R2, TILL WE REACH TWO
	ADD R4, R2, R5	;
	BRzp DIV_LOOP	;
	
GO_BACK_PRIME
	AND R5, R5, #0	; GO BACK TO COMPUTER PRIME, WITH R5 AS 1 SO WE FLAG IT AS PRIME AND STORE IT
	ADD R5, R5, #1	;
	LD R1, IP_SaveR1
    LD R2, IP_SaveR2
    LD R3, IP_SaveR3
    LD R0, PRIME_R0	;
    AND R4, R4, #0
	LD R7, PRIME_R7	;
	RET

	

GO_BACK
	AND R5, R5, #0	; GO BACK TO COMPUTE PRIME, WITH R5 AS 0 SO WE FLAG IT AS NON PRIME AND DONT STORE IT
    LD R1, IP_SaveR1
    LD R2, IP_SaveR2
    LD R3, IP_SaveR3
    LD R0, PRIME_R0	;
	LD R7, PRIME_R7	;
    RET

RET_2
	AND R5, R5, #0	; GO BACK TO COMPUTER PRIME, WITH R5 AS 1 SO WE FLAG IT AS PRIME AND STORE IT
	ADD R5, R5, #1	;
	LD R1, IP_SaveR1
    LD R2, IP_SaveR2
    LD R3, IP_SaveR3
    LD R0, PRIME_R0	;
    AND R4, R4, #0
	LD R7, PRIME_R7	;
	RET
RET_3
	AND R5, R5, #0	; GO BACK TO COMPUTER PRIME, WITH R5 AS 1 SO WE FLAG IT AS PRIME AND STORE IT
	ADD R5, R5, #1	;
	LD R1, IP_SaveR1
    LD R2, IP_SaveR2
    LD R3, IP_SaveR3
    LD R0, PRIME_R0	;
    AND R4, R4, #0
	LD R7, PRIME_R7	;
	RET
	
PRIME_R0	.BLKW #1	;
PRIME_R7	.BLKW #1	;

IP_SaveR1 .BLKW #1
IP_SaveR2 .BLKW #1
IP_SaveR3 .BLKW #1
IP_SaveR7 .BLKW #1
; Do Not Write Below This Line!
; ----------------------------------

; DIVIDE - divides R1 by R2 and returns R0 and R3
; IN:  R1: numerator (dividend, N)
;      R2: denominator (divisor, D)
;      (R1 and R2 must be strictly > 0)
; OUT: R0: quotient, Q (Q = N / D)
;      R3: remainder, R 
;
DIVIDE

     AND R0, R0, #0 ; intialize quotient, Q <- 0
     ADD R3, R1, #0 ; initialize remainder, R <- N

     ST R5, DIV_SaveR5
     ST R6, DIV_SaveR6

     ; precompute -D
     NOT R6, R2
     ADD R6, R6, #1   ; R6 <- D

; while R >= D
LOOP ADD R5, R3, R6  ; R - D
     BRn DONE
     ADD R0, R0, #1 ; Q <- Q + 1
     ADD R3, R3, R6 ; R <- R - D
     BR LOOP

DONE 
     LD R5, DIV_SaveR5
     LD R6, DIV_SaveR6

    RET

; data
DIV_SaveR5 .BLKW #1
DIV_SaveR6 .BLKW #1

.END


