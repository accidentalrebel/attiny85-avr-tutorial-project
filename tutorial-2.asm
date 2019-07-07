	.nolist
	.include "./tn85def.inc"
	.list

	;; Declarations
	.def	temp	=r16	; designate worknig register r16 as temp

	;; Start of program
	rjmp 	Init
Init:
	ldi	temp, 0b00000001 
	out 	DDRB, temp	; Set port 0 as output, the rest as input

	ldi	temp, 0b00001001
	out	PORTB, temp	; Set PB3 as input
Main:
	clr	temp
	in	temp, PinB	; Copy state of PinB
	lsr	temp		
	lsr 	temp
	lsr 	temp
	out	PortB, temp	
	rjmp	Main
	
	
