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
	JNB P2.1, FAST; Se SW1 for precionado, vai para rotina de 1s
	ACALL UPDATE_DISPLAY ; Vai para UPDATE_DISPLAY
	DJNZ R3, SLOW; enquanto R3 !=0, volta para rotina
	ACALL INIT; chama a subrotina INIT 
	SJMP SLOW; volta para o inicio da subrotina
	

FAST:
	ACALL DELAY_1S ; Delay de 1s
	JNB P2.0, SLOW; se SW0 for precionado, vai para rotina de 0.25s
	ACALL UPDATE_DISPLAY ;vai para UPDATE_DISPLAY
	DJNZ R3, FAST; enquanto R3 !=0, volta para rotina
	ACALL INIT; chama a subrotina INIT 
	SJMP FAST; volta para o inicio da subrotina


UPDATE_DISPLAY:
	CLR A ; Limpa o acumulador
	MOVC A,@A+DPTR ; Coloca o valor que está no endereço de memória mostrado
	MOV P1,A ; Atualiza o display com o valor de A
	INC DPTR ; Incrementa DPTR para o próximo dígito na LUT
	RET; retorna para o local em que foi chamada a subrotina


DELAY_1S:
	MOV R2, #4 ;Inicia R2 com o valor 4
DELAY_LOOP_1S:
	ACALL DELAY_250MS ; Chama a subrotina 
	DJNZ R2, DELAY_LOOP_1S ; Enquanto R2 !=0, chama a subrotina
	RET ; retorna ao local da chamada

DELAY_250MS:
	MOV R1, #500 ; Inicia R1 com o valor 500
	ACALL DELAY ; chama a subrotina

DELAY: 
	MOV R0,#250 ; Inicia R0 com 250
	DJNZ R0, $ ; enquanto R0 != 0, fica em loop
	DJNZ R1, DELAY ; Enquanto R1 !=0, chama a subrotina
RET

;define uma nova origem
ORG 0200H
;Coloca os valores de 0 a 9 em hexa
LUT:	DB 0C0h,0F9h,0A4h,0B0h,099h,092h,082h,0F8h,080h,090h,000h
	
END

