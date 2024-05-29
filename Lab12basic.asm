ORG 0000H
AJMP INITIAL
ORG 0050H


INITIAL:
	MOV TMOD, #00100000B ;Timer1, Mode2 
	MOV TL1, #230
	MOV TH1, #230 ;baud rate=2400
	ORL PCON, #80H ;SMOD=1
	SETB TR1 
	;set baud rate

	CLR SM2
	SETB SM1
	CLR SM0
	SETB REN ;recieve enable
	;serial port mode1
	
	SETB P0.0
LOOP:
	CLR RI
	JNB RI, $
	MOV A, SBUF
	ADD A, #32
	AJMP TRANSMIT
TRANSMIT:
	CLR TI
	MOV SBUF, A
	AJMP LOOP
	END










