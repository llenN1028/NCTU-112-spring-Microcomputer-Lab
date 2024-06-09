ORG 0000H
JMP INITIAL
ORG 0003H
JMP INTERRUPT
ORG 0050H

TABLE:
/*blank*/
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH

/*blank*/
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH

/*blank*/
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH

/*別*/
DB 0FFH,0FFH
DB 0FFH,07FH
DB 001H,0BFH
DB 0BBH,0C7H
DB 03BH,0F8H
DB 0BBH,0BDH
DB 0BBH,03DH
DB 0BBH,0BDH
DB 001H,0C1H
DB 0FBH,0FDH
DB 0FFH,0FFH
DB 007H,0D8H
DB 0F7H,0BFH
DB 0FFH,03FH
DB 001H,080H
DB 0FDH,0FFH
/*當*/
DB 0FFH,0FFH
DB 0BFH,0FFH
DB 0C7H,0FFH
DB 0EDH,003H
DB 0EBH,0ABH
DB 027H,0AAH
DB 0AFH,0AAH
DB 0AFH,0AAH
DB 0A1H,082H
DB 0ADH,0AAH
DB 0AFH,0AAH
DB 027H,0AAH
DB 0E9H,0ABH
DB 0ADH,003H
DB 0C7H,0FFH
DB 0EFH,0FFH
/*我*/
DB 0FFH,0FFH
DB 0BFH,0F7H
DB 0B7H,0A7H
DB 0B7H,0B7H
DB 0B7H,037H
DB 003H,080H
DB 0BBH,0FBH
DB 0BBH,0FBH
DB 0BFH,07DH
DB 0BFH,0BFH
DB 001H,0D8H
DB 0BDH,0E7H
DB 0BFH,0DBH
DB 0BBH,0BCH
DB 0B7H,07EH
DB 0A7H,00FH

/*blank*/
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH

/*blank*/
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH

/*blank*/
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH
DB 0FFH,0FFH

INITIAL:
	SETB IT0
	MOV IP, #00000001B
	MOV IE, #10000001B
	MOV R1, #192
START:
	MOV P0, #0
	MOV P1, #0FFH
	JMP START
INTERRUPT:
	MOV R0, #0
	MOV DPTR, #TABLE
	MOV P0, #0FFH
	MOV P1, #0
LEDSHOW:
	CALL READBYTE
	MOV P2, A
	CALL READBYTE
	MOV 0C0H, A
	CALL DELAY
	CJNE R0, #96, LEDSHOW
	DEC R1
	DEC R1
	MOV A, #0FFH
	MOV P2, A
	MOV 0C0H, #0FFH
	CJNE R1, #0, RETURN
	MOV R1, #192
RETURN:
	RETI
READBYTE:
	MOV A, R0
	ADD A, R1
	MOVC A, @A+DPTR
	INC R0
	RET			

DELAY:
	MOV R7, #10
DELAY1:
	MOV R6, #40
DELAY2:
	DJNZ R6, DELAY2
	DJNZ R7, DELAY1
	RET
	END
