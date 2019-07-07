	.nolist
	.include "./tn85def.inc"
	.list

	; Declarations =====

	.def temp = r16
	.def overflows = r17

	.org 0x0000  	; Memory location of reset handler
	rjmp Reset     	; Jmp to reset function
	.org OVF0addr
	rjmp overflow_handler	; memory location of Timer0 overflow handler (On ATTiny85 it's on 0005)

Reset:
	ldi temp, (1<<DDB4) | (1<<DDB3) ; set pins 3 and 4 as output
	out DDRB, temp
	
	ldi temp, (1<<CS02) | (0<<CS01) | (1<<CS00)
	out TCCR0B, temp 	; set the Clock Selector Bits CS00, CS01, CS02 to 101. Ticks at (CPU freq/1024)
	ldi temp, (1<<TOIE0)
	out TIMSK, temp	 	; set the Timer Overflow Interrupt Enable (TOIE0) bit. We using OUT instead of STS

	sei			; enable global interrupts -- equivalent to "sbi SREG, I"	
	
	clr temp
	out TCNT0, temp       ; initialize the Timer/Counter to 0


	;======================
	; Main body of program:

blink:
	sbi PORTB, 3	; turn on LED on PB4
	rcall delay     ; delay will be 1/2 second
	cbi PORTB, 3    ; turn off LED on PB4
	rcall delay     ; delay will be 1/2 second
	rjmp blink      ; loop back to the start
	
delay:	
	clr overflows   ; set overflows to 0
sec_count:
	cpi overflows,15   ; compare number of overflows and 30
	brne sec_count	   ; branch to back to sec_count if not equla
	ret		   ; if 30 overflows have occured return to blink

overflow_handler:
	sbi PORTB, 4

	inc overflows   ; add 1 to the overflows variable
	cpi overflows,30	; compare with 61
	brne PC+2	; Program Counter + 2 (skip next line) if not equal
	clr overflows	; if 61 overflows occured reset the counter to zero
	reti		; return from interrupt

exit:
	;; 8MHz / 1024 = 7812
	;; 7812 / 256 = 30
	
	;; 1MHz / 1024 = 976
	;; 976 / 256 max = 3
	;; 
