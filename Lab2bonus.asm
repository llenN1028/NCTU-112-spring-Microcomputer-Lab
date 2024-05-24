ORG 0000H
AJMP MAIN
ORG 0080H


  
MAIN:
  MOV R2, #01111111B
  MOV R1, #11111110B
LOOP:  
  MOV A, R1
  XRL A, R2
  CPL A
  MOV P1, A
  MOV A, R1
  RL A
  MOV R1, A
  
  MOV A, R2
  RR A
  MOV R2, A
  
  ACALL DELAY
  JMP LOOP
DELAY:
  MOV R5, P0
  INC R5
DELAY1:
  MOV R6, #0AFH
DELAY2:
  MOV R7, #0FFH
DELAY3:
  DJNZ R7, DELAY3
  DJNZ R6, DELAY2
  DJNZ R5, DELAY1
  RET
  END                      