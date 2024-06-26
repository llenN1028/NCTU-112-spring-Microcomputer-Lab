ORG 0000H
AJMP START
ORG 0050H

TABLE:
	DB 098H  ;9
	DB 080H 
	DB 0F8H 
	DB 082H 
    DB 092H 
	DB 099H 
	DB 0B0H 
	DB 0A4H 
	DB 0F9H 
	DB 0C0H  ;0
START:
	MOV R0, #77H
	MOV DPTR, #TABLE
	MOV R4, #9
	MOV R3, #9
	MOV R2, #9
	MOV R1, #0
	AJMP OUTPUT

MAIN:
	MOV R0, #77H
	MOV R4, #0
	MOV R3, #0
	MOV R2, #0
	MOV R1, #0	

OUTPUT:	
	MOV R7, #30
OUTPUT1:
	MOV A, R4
	MOVC A, @A+DPTR
	MOV P1, A
	MOV A, R0
	MOV P0, A
	RR A
	MOV R0, A
	ACALL DELAY
	MOV P0, #0FFH

	MOV A, R3
	MOVC A, @A+DPTR
	MOV P1, A
	MOV A, R0
	MOV P0, A
	RR A
	MOV R0, A
	ACALL DELAY
	MOV P0, #0FFH

	MOV A, R2
	MOVC A, @A+DPTR
	MOV P1, A
	MOV A, R0
	MOV P0, A
	RR A
	MOV R0, A
	ACALL DELAY
	MOV P0, #0FFH

	MOV A, R1
	MOVC A, @A+DPTR
	MOV P1, A
	MOV A, R0
	MOV P0, A
	RR A
	MOV R0, A
    ACALL DELAY
	MOV P0, #0FFH
	
	DJNZ R7, OUTPUT1
COUNT:
	INC R1
	CJNE R1, #10, OUTPUT
	
	MOV R1, #0
	INC R2
	CJNE R2, #10, OUTPUT

	MOV R2, #0
	INC R3
	CJNE R3, #10, OUTPUT

	MOV R3, #0
	INC R4
	CJNE R4, #10, OUTPUT
	AJMP MAIN

DELAY:
	PUSH 2
	PUSH 3
	MOV R2, #10
DELAY1:
	MOV R3, #100
DELAY2:
	DJNZ R3, DELAY2
	DJNZ R2, DELAY1
	POP 3
	POP 2
	RET
