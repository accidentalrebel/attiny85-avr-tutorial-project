;hello.asm

.include "./tn85def.inc"

	ldi r16,0b00101010
	out DDRB,r16
	out PortB,r16
;; Start:
;; 	rjmp Start
