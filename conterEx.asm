ORG 00h

SELECT: 
	SetB P0.7 ; chip selection
	SetB P3.3 ; select display
	SetB P3.4 ; select display
	MOV R3, #00Ah ; inicia R3 com o valor 10
	MOV DPTR,#LUT ; Inicia DPTR com o endereço do primeiro elemento na LUT

MAIN:
	JNB P2.0, SLOW ; Se SW0 precionado, ir para rotina de 0.25s
	JNB P2.1, FAST ; se SW1 precionado, ir para rotina de 1s
	SJMP MAIN

INIT: 
	MOV R3, #00Ah ; inicia R3 com o valor 10
	MOV DPTR,#LUT ; Inicia DPTR com o endereço do primeiro elemento na LUT
	RET

SLOW:
	ACALL DELAY_250MS ; Delay de 0.25s
	JNB P2.1, FAST
	ACALL UPDATE_DISPLAY ; Vai para UPDATE_DISPLAY
	DJNZ R3, SLOW
	ACALL INIT
	SJMP SLOW
	

FAST:
	ACALL DELAY_1S ; Delay de 1s
	JNB P2.0, SLOW
	ACALL UPDATE_DISPLAY ;vai para UPDATE_DISPLAY
	DJNZ R3, FAST
	ACALL INIT
	SJMP FAST


UPDATE_DISPLAY:
	CLR A ; Limpa o acumulador
	MOVC A,@A+DPTR ; Coloca o valor que está no endereço de memória mostrado
	MOV P1,A ; Atualiza o display com o valor de A
	INC DPTR ; Incrementa DPTR para o próximo dígito na LUT
	RET


DELAY_1S:
	MOV R2, #4 ;Inicia R2 com o valor 4
DELAY_LOOP_1S:
	ACALL DELAY_250MS ; Chama a subrotina 
	DJNZ R2, DELAY_LOOP_1S ; Enquanto R2 !=0, chama a subrotina
	RET ; retorna ao local da chamada

DELAY_250MS:
	MOV R1, #500 ; Inicia R1 com o valor 500
	ACALL DELAY_LOOP_25 ; chama a subrotina

DELAY_LOOP_25: 
	MOV R0,#250 ; Inicia R0 com 250
	DJNZ R0, $ ; enquanto R0 != 0, fica em loop
	DJNZ R1, DELAY_LOOP_25 ; Enquanto R1 !=0, chama a subrotina
RET

ORG 0200H
;Coloca os valores de 0 a 9 em hexa
LUT:	DB 0C0h,0F9h,0A4h,0B0h,099h,092h,082h,0F8h,080h,090h,000h
	
END

