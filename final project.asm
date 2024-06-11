 	ORG 0000H
	AJMP START
	ORG 0013H
	AJMP CLICK																																																						   
	ORG 0050H
START:												
	MOV A,#00111011B ;8-bits, 2row display, 5x7									
	CALL COMMAND			
	MOV A,#00001110B ;DDRAM display , cursor display, cursor not blink		
	CALL COMMAND

	SETB EA	;enable all INT
	SETB EX1;enableINT1
	CLR IE1;clear INT1 flag
	SETB PX1;set INT1 priority
	SETB IT1;INT1 falling edge triggered

	MOV R6, #51;score
	
MODESELECT:			
	MOV R3, #10
	MOV A,#00000001B ;clear RAM		
	CALL COMMAND			
	CALL DELAY
	MOV A,#10000000B;set RAM address	
	CALL COMMAND
	MOV R3, #10
	MOV R5, #0;click counter
	MOV DPTR,#STARTTABLE
MODESELECT1:
	CLR A
	MOVC A,@A+DPTR			
	JZ SHOW			 	
	CALL DISPLAY		
	INC DPTR				
	JMP MODESELECT1

SHOW:
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7

    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6

    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5

    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4
	INC R3
	
ROW1:
	MOV P1, #7FH
	CALL DELAY
	MOV A, P1
	ANL A, #0FH
	CJNE A, #0FH, COL1
	
ROW2:
	MOV P1, #0BFH
	CALL DELAY
	MOV A, P1
	ANL A, #0FH
	CJNE A, #0FH, CHEAT

	CJNE R3, #18, SHOW
	AJMP MODESELECT
COL1:
	CJNE A, #0EH, COL2
	MOV A,#00000001B ;clear RAM		
	CALL COMMAND			
	CALL DELAY
	MOV A,#10000000B;set RAM address	
	CALL COMMAND
	MOV DPTR, #EASYTABLE
	MOV R4, #20
	JMP EASY
COL2:
	CJNE A, #0DH, COL3
	MOV A,#00000001B ;clear RAM		
	CALL COMMAND			
	CALL DELAY
	MOV A,#10000000B;set RAM address	
	CALL COMMAND
	MOV DPTR, #MEDIUMTABLE
	MOV R4, #15
	JMP MEDIUM
COL3:
	CJNE A, #0BH, COL4
	MOV A,#00000001B ;clear RAM		
	CALL COMMAND			
	CALL DELAY
	MOV A,#10000000B;set RAM address	
	CALL COMMAND
	MOV DPTR, #HARDTABLE
	MOV R4, #10
	JMP HARD
COL4:
	ACALL DELAY
	CJNE R3, #18, TOSHOW
	AJMP MODESELECT
TOSHOW:
	AJMP SHOW
CHEAT:
	MOV A,#00000001B ;clear RAM		
	CALL COMMAND
	MOV A,#10000000B;set RAM address	
	CALL COMMAND
	MOV DPTR, #CHEATTABLE
	MOV R4, #2
CHEAT1:
	CLR A
	MOVC A,@A+DPTR			
	JZ SHOWSCORE			 	
	CALL DISPLAY		
	INC DPTR				
	JMP CHEAT1	
EASY:	
	CLR A
	MOVC A,@A+DPTR			
	JZ SHOWSCORE			 	
	CALL DISPLAY		
	INC DPTR				
	JMP EASY	
MEDIUM:	
	CLR A
	MOVC A,@A+DPTR			
	JZ SHOWSCORE			 	
	CALL DISPLAY		
	INC DPTR				
	JMP MEDIUM
HARD:	
	CLR A
	MOVC A,@A+DPTR			
	JZ SHOWSCORE			 	
	CALL DISPLAY		
	INC DPTR				
	JMP HARD
SHOWSCORE:
	ACALL LONGDELAY
	MOV A,#00000001B ;clear RAM		
	CALL COMMAND			
	CALL DELAY
	MOV A,#10000000B;set RAM address	
	CALL COMMAND
	MOV DPTR, #0
	MOV DPTR, #SCORETABLE
	PUSH 5
	MOV R5, #0
SHOWSCORE1:
	INC R5
	CLR A
	MOVC A,@A+DPTR			
	JZ POPR5			 	
	CJNE R5,#12, SHOWSCORE2
	MOV A, R6
SHOWSCORE2:
	CALL DISPLAY		
	INC DPTR				
	JMP SHOWSCORE1	
POPR5:
	POP 5
PUSHR6:
	PUSH 6
	MOV A, R4
	MOV R6, A
	CJNE R4, #2, RUN
	AJMP CHEATRUN
RUN:
	 CJNE R5, #0, NEXT	;no click
	 MOV R3, #0
	 MOV R2, #0
	 MOV R1, #0
	 MOV R0, #0
	 AJMP RUN1
NEXT:
	 CJNE R5, #1, NEXT1	;click once
	 MOV R2, #0
	 MOV R1, #0
	 MOV R0, #0
	 AJMP RUN2
NEXT1:
	 CJNE R5, #2, NEXT2	;click twice
	 MOV R1, #0
	 MOV R0, #0
	 AJMP RUN3
NEXT2:
	 CJNE R5, #3, NEXT3	;click three times	 
	 MOV R0, #0
	 AJMP RUN4
NEXT3:
	AJMP POPR6		

RUN1:;no click
	MOV R7, #10
LOOP1:
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7
	CJNE R5, #0, RUN


	MOV DPTR, #R2DIGITTABLE
	MOV A, R2
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6


	MOV DPTR, #R1DIGITTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5


	MOV DPTR, #R0DIGITTABLE
	MOV A, R0
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4

RUNDELAY1:
	DJNZ R7, LOOP1
RUNDELAY11:	
	DJNZ R6, RUN1
	MOV A, R4
	MOV R6, A
	INC R3
	INC R2
	INC R1
	INC R0
	CJNE R0, #10, RUN1
	AJMP RUN

RUN2:;click once
	MOV R7, #10
LOOP2:
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7

	MOV DPTR, #R2DIGITTABLE
	MOV A, R2
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6
	CJNE R5, #1, TORUN

	  
	MOV DPTR, #R1DIGITTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5


	MOV DPTR, #R0DIGITTABLE
	MOV A, R0
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4

RUNDELAY2:
	DJNZ R7, LOOP2
RUNDELAY22:	
	DJNZ R6, RUN2
	MOV A, R4
	MOV R6, A
	INC R2
	INC R1
	INC R0	
	CJNE R0, #10, RUN2
	AJMP NEXT	
TORUN:
	AJMP RUN

RUN3:;click twice
	MOV R7, #10
LOOP3:	
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7

	MOV DPTR, #R2DIGITTABLE
	MOV A, R2
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6

	MOV DPTR, #R1DIGITTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5
	CJNE R5, #2, TORUN


	MOV DPTR, #R0DIGITTABLE
	MOV A, R0
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4

RUNDELAY3:
	DJNZ R7, LOOP3
RUNDELAY33:	
	DJNZ R6, RUN3
	MOV A, R4
	MOV R6, A
	INC R1
	INC R0
	CJNE R0, #10, RUN3
	AJMP NEXT1

RUN4:;click three times
	MOV R7, #10
LOOP4:
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7

	MOV DPTR, #R2DIGITTABLE
	MOV A, R2
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6

	MOV DPTR, #R1DIGITTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5

	MOV DPTR, #R0DIGITTABLE
	MOV A, R0
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4
	CJNE R5, #3, TORUN1

RUNDELAY4:
	DJNZ R7, LOOP4
RUNDELAY44:	
	DJNZ R6, RUN4
	MOV A, R4
	MOV R6, A
	INC R0
	CJNE R0, #10, RUN4
	AJMP NEXT2

TORUN1:
	AJMP RUN

POPR6:
	POP 6
RUN5:;click four times
	MOV R7, #255
LOOP5:
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7

	MOV DPTR, #R2DIGITTABLE
	MOV A, R2
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6

	MOV DPTR, #R1DIGITTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5

	MOV DPTR, #R0DIGITTABLE
	MOV A, R0
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4

	DJNZ R7, LOOP5
	AJMP SAME

CHEATRUN:
	 CJNE R5, #0, CHEATNEXT	;no click
	 MOV R3, #0
	 MOV R2, #0
	 MOV R1, #0
	 MOV R0, #0
	 AJMP CHEATRUN1
CHEATNEXT:
	 CJNE R5, #1, CHEATNEXT1	;click once
	 MOV R2, #0
	 MOV R1, #0
	 MOV R0, #0
	 AJMP CHEATRUN2
CHEATNEXT1:
	 CJNE R5, #2, CHEATNEXT2	;click twice
	 MOV R1, #0
	 MOV R0, #0
	 AJMP CHEATRUN3
CHEATNEXT2:
	 CJNE R5, #3, CHEATNEXT3	;click three times	 
	 MOV R0, #0
	 AJMP CHEATRUN4
CHEATNEXT3:
	AJMP CHEATPOPR6		

CHEATRUN1:;no click
	MOV R7, #10
CHEATLOOP1:
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7
	CJNE R5, #0, CHEATRUN


	MOV DPTR, #R2DIGITTABLE
	MOV A, R2
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6


	MOV DPTR, #R1DIGITTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5


	MOV DPTR, #R0DIGITTABLE
	MOV A, R0
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4

CHEATRUNDELAY1:
	DJNZ R7, CHEATLOOP1
CHEATRUNDELAY11:	
	DJNZ R6, CHEATRUN1
	MOV A, R4
	MOV R6, A
	INC R3
	INC R2
	INC R1
	INC R0
	CJNE R0, #10, CHEATRUN1
	AJMP CHEATRUN

CHEATRUN2:;click once
	MOV R7, #10
CHEATLOOP2:
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7

	MOV DPTR, #R2DIGITTABLE
	MOV A, R2
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6
	CJNE R5, #1, CHEATTORUN

	  
	MOV DPTR, #R1DIGITTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5


	MOV DPTR, #R0DIGITTABLE
	MOV A, R0
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4

CHEATRUNDELAY2:
	DJNZ R7, CHEATLOOP2
CHEATRUNDELAY22:	
	DJNZ R6, CHEATRUN2
	MOV A, R4
	MOV R6, A
	INC R2
	INC R1
	INC R0	
	CJNE R0, #10, CHEATRUN2
	AJMP CHEATNEXT	
CHEATTORUN:
	AJMP CHEATRUN

CHEATRUN3:;click twice
	MOV R7, #10
CHEATLOOP3:	
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7

	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6

	MOV DPTR, #R1DIGITTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5
	CJNE R5, #2, CHEATTORUN


	MOV DPTR, #R0DIGITTABLE
	MOV A, R0
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4

CHEATRUNDELAY3:
	DJNZ R7, CHEATLOOP3
CHEATRUNDELAY33:	
	DJNZ R6, CHEATRUN3
	MOV A, R4
	MOV R6, A
	INC R1
	INC R0
	CJNE R0, #10, CHEATRUN3
	AJMP CHEATNEXT1

CHEATRUN4:;click three times
	MOV R7, #10
CHEATLOOP4:
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7

	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6

	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5

	MOV DPTR, #R0DIGITTABLE
	MOV A, R0
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4
	CJNE R5, #3, CHEATTORUN1

CHEATRUNDELAY4:
	DJNZ R7, CHEATLOOP4
CHEATRUNDELAY44:	
	DJNZ R6, CHEATRUN4
	MOV A, R4
	MOV R6, A
	INC R0
	CJNE R0, #10, CHEATRUN4
	AJMP CHEATNEXT2

CHEATTORUN1:
	AJMP CHEATRUN

CHEATPOPR6:
	POP 6
CHEATRUN5:;click four times
	MOV R7, #255
CHEATLOOP5:
	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    CLR  P3.7
	SETB P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.7

	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	CLR P3.6
	SETB P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.6

	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	CLR P3.5
	SETB P3.4
	ACALL SHORTDELAY
	SETB P3.5

	MOV DPTR, #R3DIGITTABLE
	MOV A, R3
	MOVC A, @A+DPTR
	MOV P0, A
    SETB  P3.7
	SETB P3.6
	SETB P3.5
	CLR P3.4
	ACALL SHORTDELAY
	SETB P3.4

	DJNZ R7, CHEATLOOP5
SAME:
	CJNE R4, #2, SAME1
	AJMP JUDGINGMODE

SAME1:
	MOV DPTR, #R3DIGITTABLE
	MOV A,R3
	MOVC A, @A+DPTR
	MOV R5, A

	MOV DPTR, #R2DIGITTABLE
	MOV A, R2
	MOVC A, @A+DPTR
	CJNE A, 5, LOSEORNOT

	MOV DPTR, #R1DIGITTABLE
	MOV A, R1
	MOVC A, @A+DPTR
	CJNE A, 5, LOSEORNOT

	MOV DPTR, #R0DIGITTABLE
	MOV A, R0
	MOVC A, @A+DPTR
	CJNE A, 5, LOSEORNOT

JUDGINGMODE:
	CJNE R4, #20, NOTEASY
	AJMP PLUS1
NOTEASY:
	CJNE R4, #15, NOTMEDIUM
	AJMP PLUS2
NOTMEDIUM:
	CJNE R4, #10, NOTHARD
	AJMP PLUS3
NOTHARD:
	AJMP PLUS1

PLUS1:
	INC R6
	CJNE R4, #20, STOPCHEATING
PLUS11:
	ACALL LONGDELAY
	CJNE R6, #58, CONTINUE
	AJMP WIN
PLUS2:
	MOV A, #2
	ADD A, R6
	MOV R6, A
	CJNE R6, #58, WINORNOT
	AJMP WIN
WINORNOT:
	CJNE R6, #59, CONTINUE
	AJMP WIN
PLUS3:
	MOV A, #3
	ADD A, R6
	MOV R6, A
	CJNE R6, #58, WINORNOT1
	AJMP WIN
WINORNOT1:
	CJNE R6, #59, WINORNOT2
	AJMP WIN
WINORNOT2:
	CJNE R6, #60, CONTINUE
	AJMP WIN
LOSEORNOT:
	DEC R6
	CJNE R6, #48, MINUS
	AJMP LOSE
MINUS:	
	MOV A,#00000001B ;clear RAM		
	ACALL COMMAND			
	ACALL DELAY
	MOV A,#10000000B;set RAM address	
	ACALL COMMAND
	MOV DPTR, #MINUS1TABLE
SHOWMINUS1:
	CLR A
	MOVC A,@A+DPTR			
	JZ BACK			 	
	ACALL DISPLAY		
	INC DPTR				
	JMP SHOWMINUS1
STOPCHEATING:
	MOV A,#00000001B ;clear RAM		
	ACALL COMMAND			
	ACALL DELAY
	MOV A,#10000000B;set RAM address	
	ACALL COMMAND
	MOV DPTR, #STOPCHEATINGTABLE				
STOPCHEATING1:
	CLR A
	MOVC A,@A+DPTR			
	JZ PLUS11			 	
	ACALL DISPLAY		
	INC DPTR				
	JMP STOPCHEATING1

CONTINUE:
	CJNE R4, #20, CONTINUE1
	AJMP SHOWPLUS1
CONTINUE1:
	CJNE R4, #2, SHOWPLUS2
SHOWPLUS1:	
	MOV A,#00000001B ;clear RAM		
	ACALL COMMAND			
	ACALL DELAY
	MOV A,#10000000B;set RAM address	
	ACALL COMMAND
	MOV DPTR, #PLUS1TABLE
SHOWPLUS11:
	CLR A
	MOVC A,@A+DPTR			
	JZ BACK			 	
	ACALL DISPLAY		
	INC DPTR				
	JMP SHOWPLUS11
SHOWPLUS2:
	CJNE R4, #15, SHOWPLUS3	
	MOV A,#00000001B ;clear RAM		
	ACALL COMMAND			
	ACALL DELAY
	MOV A,#10000000B;set RAM address	
	ACALL COMMAND
	MOV DPTR, #PLUS2TABLE
SHOWPLUS21:
	CLR A
	MOVC A,@A+DPTR			
	JZ BACK			 	
	ACALL DISPLAY		
	INC DPTR				
	JMP SHOWPLUS21
SHOWPLUS3:
	MOV A,#00000001B ;clear RAM		
	ACALL COMMAND			
	ACALL DELAY
	MOV A,#10000000B;set RAM address	
	ACALL COMMAND
	MOV DPTR, #PLUS3TABLE
SHOWPLUS31:
	CLR A
	MOVC A,@A+DPTR			
	JZ BACK			 	
	ACALL DISPLAY		
	INC DPTR				
	JMP SHOWPLUS31	
BACK:
	ACALL LONGDELAY	
	LJMP MODESELECT

WIN:
	ACALL LONGDELAY
	MOV A,#00000001B ;clear RAM		
	ACALL COMMAND			
	ACALL DELAY
	MOV A,#10000000B;set RAM address	
	ACALL COMMAND
	MOV DPTR, #WINTABLE
WIN1:
	ACALL DELAY
	ACALL DELAY
	CLR A
	MOVC A,@A+DPTR			
	JZ WIN2			 	
	ACALL DISPLAY		
	INC DPTR				
	JMP WIN1
WIN2:
	ACALL LONGDELAY
	MOV A,#00000001B ;clear RAM		
	ACALL COMMAND			
	ACALL DELAY
	MOV A,#10000000B;set RAM address	
	ACALL COMMAND
	MOV DPTR, #RESETTABLE
WIN3:
	CLR A
	MOVC A,@A+DPTR			
	JZ PRESSRESET			 	
	ACALL DISPLAY		
	INC DPTR				
	JMP WIN3

PRESSRESET:
	MOV P1, #7FH
	ACALL DELAY
	MOV A, P1
	ANL A, #0FH
	CJNE A, #0FH, PRESSRESET1
	
	AJMP PRESSRESET
PRESSRESET1:
	CJNE A, #07H, PRESSRESET
	AJMP RESET

RESET:
	LJMP START

LOSE:
	ACALL LONGDELAY
	MOV A,#00000001B ;clear RAM		
	ACALL COMMAND			
	ACALL DELAY
	MOV A,#10000000B;set RAM address	
	ACALL COMMAND
	MOV DPTR, #LOSETABLE
LOSE1:
	ACALL DELAY
	ACALL DELAY
	CLR A
	MOVC A,@A+DPTR			
	JZ LOSE2			 	
	ACALL DISPLAY		
	INC DPTR				
	JMP LOSE1
LOSE2:
	ACALL LONGDELAY
	MOV A,#00000001B ;clear RAM		
	ACALL COMMAND			
	ACALL DELAY
	MOV A,#10000000B;set RAM address	
	ACALL COMMAND
	MOV DPTR, #YOUSUCKTABLE
LOSE3:
	CLR A
	MOVC A,@A+DPTR			
	JZ LOSE4			 	
	ACALL DISPLAY		
	INC DPTR				
	JMP LOSE3
LOSE4:
	ACALL LONGDELAY
	MOV A,#00000001B ;clear RAM		
	ACALL COMMAND			
	ACALL DELAY
	MOV A,#10000000B;set RAM address	
	ACALL COMMAND
	MOV DPTR, #RESETTABLE
LOSE5:
	CLR A
	MOVC A,@A+DPTR			
	JZ PRESSRESET2			 	
	ACALL DISPLAY		
	INC DPTR				
	JMP LOSE5
PRESSRESET2:
	MOV P1, #7FH
	ACALL DELAY
	MOV A, P1
	ANL A, #0FH
	CJNE A, #0FH, PRESSRESET3
	
	AJMP PRESSRESET2
PRESSRESET3:
	CJNE A, #07H, PRESSRESET2
	AJMP RESET	


CLICK:
	INC R5
	RETI

COMMAND:	      
	MOV P2,A			
	ORL P3,#00000100B	;E=1 R/W=0 RS=0
	CALL DELAY			
	ANL P3,#11111000B	;E=0 R/W=0 RS=0		
	CALL DELAY
	RET
DISPLAY:		
	MOV P2,A			
	ORL P3,#00000101B	;E=1 R/W=0 RS=1
	CALL DELAY
	ANL P3,#11111000B	;E=0 R/W=0 RS=0
	CALL DELAY
	RET


LONGDELAY:
	PUSH 0
	PUSH 1
	PUSH 2

	MOV R0, #30
LONGDELAY1:
	MOV R1, #255
LONGDELAY2:
	MOV R2, #255
LONGDELAY3:
	DJNZ R2, LONGDELAY3
	DJNZ R1, LONGDELAY2
	DJNZ R0, LONGDELAY1
	
	POP 2
	POP 1
	POP 0
	
	RET

DELAY:
	PUSH 0
	PUSH 1

	MOV R0, #255
DELAY1:
	MOV R1, #255
DELAY2:
	DJNZ R1,DELAY2
	DJNZ R0,DELAY1
	
	POP 1
	POP 0
	RET

SHORTDELAY:
	PUSH 0
	PUSH 1

	MOV R0, #50
SHORTDELAY1:
	MOV R1, #50
SHORTDELAY2:
	DJNZ R1,SHORTDELAY2
	DJNZ R0,SHORTDELAY1
	
	POP 1
	POP 0
	RET

STARTTABLE:
	DB '   MODE SELECT',0
CHEATTABLE:
	DB '   CHEAT MODE',0
STOPCHEATINGTABLE:
	DB'  STOP CHEATING',0
EASYTABLE:
	DB '   EASY MODE',0
MEDIUMTABLE:
	DB '   MEDIUM MODE',0
HARDTABLE:
	DB '   HARD MODE',0				
SCORETABLE:
	DB 	'     SCORE: ',0
WINTABLE:
	DB '    YOU WIN!!',0
YOUSUCKTABLE:
	DB '    YOU SUCK!',0
RESETTABLE:
	DB '  PRESS RESET',0
LOSETABLE:
	DB '    YOU LOSE!!',0
PLUS1TABLE:
	DB '       +1',0
PLUS2TABLE:
	DB '       +2',0
PLUS3TABLE:
	DB '       +3',0
MINUS1TABLE:
	DB '       -1',0
R3DIGITTABLE:
	DB 11000000B ;0
	DB 10010010B ;5
	DB 10011000B ;9
	DB 10100100B ;2
	DB 11111001B ;1
	DB 10110000B ;3
	DB 10011001B ;4
	DB 11111000B ;7
	DB 10000010B ;6	
	DB 10000000B ;8
	
	DB 11111110B
	DB 11111101B
	DB 11111011B
	DB 11110111B
	DB 11101111B
	DB 11011111B
	DB 10111111B
	DB 01111111B
	
R2DIGITTABLE:
	DB 11000000B ;0	
	DB 10110000B ;3
	DB 10000010B ;6
	DB 10011001B ;4
	DB 10011000B ;9
	DB 11111001B ;1	
	DB 11111000B ;7
	DB 10000000B ;8
	DB 10010010B ;5
	DB 10100100B ;2

R1DIGITTABLE:
	DB 10010010B ;5
	DB 11111001B ;1
	DB 10000000B ;8
	DB 10110000B ;3
	DB 11000000B ;0
	DB 10011000B ;9
	DB 10011001B ;4
	DB 10100100B ;2
	DB 10000010B ;6
	DB 11111000B ;7
	

R0DIGITTABLE:
	DB 11000000B ;0
	DB 10011001B ;4
	DB 11111001B ;1
	DB 10010010B ;5
	DB 10110000B ;3
	DB 10011000B ;9
	DB 10100100B ;2
	DB 10000000B ;8
	DB 11111000B ;7
	DB 10000010B ;6
	
	
 	END



