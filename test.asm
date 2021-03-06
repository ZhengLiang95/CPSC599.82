;Test programs CPSC 599.82

;	when run this program 

;	1.		Flash the screen by changing the Screen and border color register
;	2.		Print out "HELLO WORLD!" on the screen
;	3.		Get input characters from the keyboard and output on the screen
;	4.		Print character "X" at a user specified position (enter x then y)
;	5.		Output one note continuously
;	6.		Beep intermidently up a scale (pause between each note)
;	7.		Test gravity effect, have one ascii character fall at one constant speed until it 'hits' a floor
;	8.		Accelerating gravity effect
;	9.		Move ascii character around randomly (smooth discrete movement along coordinate grids)
;	0.		Move ascii character around with w, a, s and d keys
;	11 		Allow user to input the correspondent test case






;=============================    TO DO    =============================
;Fix test 4
;Implement test 8
;Fix test9 - Random is not good enough
;Fix test0 - 1. W key is not working
;			 2. S key is working incorrectly over line 12



;==============================================================
;Start of the test programs
	processor 6502	;pseudo code for dasm to indicate
	org	$1100		;Start point of this program in the memory (4352 in decimal)

testSelect	
	jsr $e55f		; clear screen, then prompt user
	lda	#'E
	jsr	$ffd2
	lda	#'N
	jsr	$ffd2
	lda	#'T
	jsr	$ffd2
	lda	#'E
	jsr	$ffd2
	lda	#'R
	jsr	$ffd2
	lda	#' 	
	jsr	$ffd2
	lda	#'A	
	jsr	$ffd2
	lda	#' 
	jsr	$ffd2
	lda	#'T
	jsr $ffd2
	lda	#'E	
	jsr	$ffd2
	lda	#'S
	jsr	$ffd2
	lda	#'T
	jsr	$ffd2
	lda	#' 
	jsr	$ffd2
	lda	#'N
	jsr	$ffd2
	lda	#'U
	jsr	$ffd2
	lda	#'M
	jsr	$ffd2
	lda	#'B	
	jsr	$ffd2
	lda	#'E	
	jsr	$ffd2
	lda	#'R
	jsr	$ffd2
	lda	#' 
	jsr	$ffd2
	lda	#' 
	jsr	$ffd2
	lda	#' 
	jsr	$ffd2
	lda	#'(
	jsr	$ffd2
	lda	#'0	
	jsr	$ffd2
	lda	#'-	
	jsr	$ffd2
	lda	#'9
	jsr	$ffd2
	lda	#')
	jsr	$ffd2
	
getTest:
	lda #0
	jsr	$ffe4		;accept user input for test number 
	cmp #0
	beq getTest		;loop back up, user hasn't entered a test yet
	
	jsr	$ffd2		; print out what the user entered
	
	tax				;user entered number is in x now
	jmp test9		;test 9 will compare x to test # to see if it should execute, pass execution on if not

;============================================================
;Test9
;Move ascii character horizontally across screen when user presses 'N' key

test9:
    cpx #$39        ;check if user entered 9
    bne test8
    jsr $e55f        ; clear screen

test9etKeyInput:
    lda #0
    jsr    $ffe4        ;accept user input for test number 
    cmp #'N            ;Next step
    bne test9etKeyInput

    dec $D3            ; erase the character
    lda #' 
    jsr $ffd2
    lda #'X            ; print the character
    jsr $ffd2
    jmp test9etKeyInput

;============================================================
;Test8
;Accelerated gravity effect (use stack to store velocity?)
test8:
	cpx #$38		;check if user entered 8
	bne test7
	jsr $e55f		; clear screen
	lda #1
	pha				;push 1 (velocity) to stack
	lda #10							
	sta $D3							; D3 = 10 = middle of the screen
	lda #'D							; print letter D
	jsr $ffd2
	jmp test8loop					;go to test8loop
test8waitLoop:							;a waitLoop of 500ms
	inx
	cpx $50
	bne test8waitLoop
	iny
	cpy $4
	bne	test8waitLoop
	tax
test8loop:
	dec $D3				
	lda #'				;erase what has just been printed
	jsr $ffd2
	pla					;get velocity off stack
	asl					;double velocity value 
	pha					;store velocity on stack
	cmp #16				;compare velocity with 16
	beq donetest8		;branch plus (when x is bigger than 20)
	pla					;pull accumulator from stack (get velocity)
moveDownLoop:
	tax					;remaining velocity (for this move) now in x
	lda #21				
	adc $D1				;add 21 into D1 to go to the next line
	sta $D1				;store it into D1
	txa					;velocity back in a
	sbc #1
	cmp #0				; while still more lines to descend
	bne moveDownLoop
	
	lda #'D				;print D again
	jsr $ffd2
	ldx #0
	ldy #0
	jmp test8waitLoop		;go to 500ms waitLoop
donetest8:
	jmp donetest8	;is an infinite loop. Will be reached when user selected test is complete



;============================================================
;Test7
;Test gravity effect, have one ascii character fall at one constant speed until it 'hits' a floor
test7:
	cpx #$37		;check if user entered 7
	sec
	bne tenthLoop
runtest7:
	jsr $e55f		; clear screen
	ldx #0							;x = 0
	lda #9							
	sta $D3							; D3 = 9 = middle of the screen
	lda #'D							; print letter D
	jsr $ffd2
	jmp test7loop					;go to test7loop
waitLoop:							;a waitLoop of 500ms	
	iny
	cpy $00
	bne waitLoop
	ldy $0
secondLoop:
	iny
	cpy $200
	bne	secondLoop
	ldy $0
thirdLoop:
	iny
	cpy $200
	bne thirdLoop
	ldy $0
fourthLoop:
	iny
	cpy $200
	bne fourthLoop
	ldy $0
fifthLoop:
	iny 
	cpy $200
	bne fifthLoop
		
sixthLoop:							;a waitLoop of 500ms	
	iny
	cpy $00
	bne sixthLoop
	ldy $0
seventhLoop:
	iny
	cpy $200
	bne	seventhLoop
	ldy $0
eigthLoop:
	iny
	cpy $200
	bne eigthLoop
	ldy $0
ninthLoop:
	iny
	cpy $200
	bne ninthLoop
	clc
	ldy $0

tenthLoop:
	bcs test6
	iny 
	cpy $200
	bne tenthLoop
	
	
eleventhLoop:							;a waitLoop of 500ms	
	iny
	cpy $200
	bne eleventhLoop
	ldy $0
twelfthLoop:
	iny
	cpy $200
	bne	twelfthLoop
	ldy $0
thirteenthLoop:
	iny
	cpy $200
	bne thirteenthLoop
	ldy $0
fourteenthLoop:
	iny
	cpy $200
	bne fourteenthLoop
	ldy $0
fifteenthLoop:
	iny 
	cpy $200
	bne fifteenthLoop
	ldy $0	
sixteenthLoop:							;a waitLoop of 500ms	
	iny
	cpy $00
	bne sixteenthLoop
	ldy $0
seventeenthLoop:
	iny
	cpy $200
	bne	seventeenthLoop
	ldy $0
eigteenthLoop:
	iny
	cpy $200
	bne eigteenthLoop
	ldy $0
ninteenthLoop:
	iny
	cpy $200
	bne ninteenthLoop
	ldy $0
twentiethLoop:
	iny 
	cpy $200
	bne twentiethLoop
	
	
test7loop:
	inx
	cpx #13				;compare x with 13, aka falling down 13 lines
	beq donetest7
	dec $D3				
	lda #'				;erase what has just been printed
	jsr $ffd2
	lda #21				
	adc $D1				;add 21 into D1 to go to the next line
	sta $D1				;store it into D1
	lda #'D				;print D again
	jsr $ffd2
	ldy #0
	jmp waitLoop		;go to 500ms waitLoop
donetest7:
	jmp donetest7	;is an infinite loop. Will be reached when user selected test is complete


;============================================================
;Test6
;Beep intermidently up a scale (pause between each note)
;tests timing and use of different musical notes
test6:
	cpx #$36		;check if user entered 6
	bne test5
	lda #15
	sta $900e		;set volume
	lda #135
	sta $900c
	jmp test6Note
test6waitLoop:							;a waitLoop of 500ms
	inx
	cpx $200
	bne test6waitLoop
	iny
test6waitLoop2:
	cpy $4
	bne	test6waitLoop
test6Note:
	ldx #0			;counter (0-200)
	ldy #0			;counter (0-20, resets x for each increment)
	lda $900c
	cmp #159
	beq add4
	cmp #183
	beq add8
	cmp #191
	beq add4
	cmp #195
	beq reset135
	adc #12
	sta $900c
	jmp test6waitLoop
add4:
	adc #4
	sta $900c
	jmp test6waitLoop
add8:
	adc #8
	sta $900c
	jmp test6waitLoop
add12:
	adc #12
	sta $900c
	jmp test6waitLoop
reset135:
	lda #135
	sta $900c
	jmp test6waitLoop



;============================================================
;Test5
;Output one note continuously
test5:
	cpx #$35		;check if user entered 5
	bne test4
	lda #15		;volume set to level 15 (volume is in 0-15)
	sta	$900e	;memory location of volume
	lda	#201	;Represents a D note
	sta	$900c	;high speaker
	jmp	test5


;==============================================================
;Test 4
;Print character "X" at a user specified position (enter x, press "Enter" key, then enter y)
test4:
	cpx #$34		;check if user entered 4
	bne test3
	jsr $e55f	; clear screen
	lda #$0
	sta $D3
getx:
	lda #$0		; reset accumulator
	jsr	$ffcf;	; get user to enter a character
	cmp $00		; if no character (x position) has been entered
	beq getx
	sed			;set decimal flag
	sbc #$29	; decrement user ascii character by $30 => user entered 5 then A now stores 5, user entered 2 then A now stores 2 etc...
	;adc	$D3			; $D3 is cursor position on line
	sta $D3
	
	lda #$40
	jsr	$ffd2	;have to print out character at x value on current line in order to allow user to enter second input
gety:
	lda #$0		; reset accumulator
	jsr	$ffcf;	; get user to enter a character
	cmp $00		; if no character (x position) has been entered
	beq gety
	sed			
	sbc #$29	; decrement user ascii character by $30 => user entered 5 then A now stores 5, user entered 2 then A now stores 2 etc...
	tax			; transfer registers A to X in order to decrement in addlines loop
	lda $D3		
	sbc #$2		;Subract by 2 to accomodate for printed character and shifted cursor
addlines:
	sed
	adc	$D5		; $D5 is current line length, adding it is equivalent to creating another line
;	sbc #$2
	dex
	sta $D3
	bne addlines
	;sbc $D3
	
linesadded:
	;adc	$D3		; $D3 is cursor position on line
	
;	lda $D5		; current line length
	;
	lda #$40
	jsr	$ffd2
	jmp	donetest4
donetest4:
	jmp donetest4	;is an infinite loop. Will be reached when user selected test is complete


;=============================================================
;Test 3
;Get input characters from the keyboard and output on the screen
test3:
	cpx #$33		;check if user entered 3
	bne test2
	jsr $e55f	; clear screen
mylabel:
	jsr	$ffe4	;could change to $ffcf, but got problem when press enter key
	jsr	$ffd2
	jmp	mylabel

;==============================================================
;Test 2
;Print out "HELLO WORLD!" on the screen
;test display
;CHROUT $ffd2, Output character to channel
test2:
	cpx #$32		;check if user entered 2
	bne test1
	jsr	$e55f
	lda	#'H	;H
	jsr	$ffd2
	lda	#'E	;E
	jsr	$ffd2
	lda	#'L	;L
	jsr	$ffd2
	lda	#'L	;L
	jsr	$ffd2
	lda	#'O	;O
	jsr	$ffd2
	lda	#' 	;space
	jsr	$ffd2
	lda	#'W	;W
	jsr	$ffd2
	lda	#'O	;O
	jsr	$ffd2
	lda	#'R	;R
	jsr	$ffd2
	lda	#'L	;L
	jsr	$ffd2
	lda	#'D	;D
	jsr	$ffd2
	lda	#'!	;!
	jsr	$ffd2
	jmp	donetest2
donetest2:
	jmp donetest2	;is an infinite loop. Will be reached when user selected test is complete

;=====================================================
;Test 1
;Flash the screen by changing the Screen and border color register
test1:
	cpx #$31		;check if user entered 1
	bne test0
	inc	$900f
	jmp	test1

;============================================================
;Test0
;Move ascii character around with w, a, s and d keys
;simulate player movement
test0:
	jsr $e55f						; clear screen
	ldx #9							;x = 9
	ldy #0							;y = 0
	lda #9					
	sta $D3							; D3 = 9 = middle of the screen, where D3 is the cursor of the line
	lda #'X							; print letter D
	jsr $ffd2

getKeyInput:
	lda #0
	jsr	$ffe4		;accept user input for test number 

	cmp #'W			; Branch to the coressponding key
	beq wKey
	cmp #'A
	beq aKey
	cmp #'S
	beq sKey
	cmp #'D
	beq dKey
	bne getKeyInput	;Invalid input

wKey:
	dec $D3			; erase the character
	lda #' 
	jsr $ffd2
	;sed
	lda $D1				;D5 is current line length
	sbc $D5			;subtract line length from position to go up one line 
	sta $D1				;store it into D1
	lda #'X
	jsr $ffd2
	jmp getKeyInput
aKey:
	dec $D3
	lda #' 
	jsr $ffd2
	dec $D3
	dec $D3
	lda #'X
	jsr $ffd2
	jmp getKeyInput
sKey:
	dec $D3			; erase the character
	lda #' 
	jsr $ffd2
	lda #21				
	adc $D1				;add 21 into D1 to go to the next line
	sta $D1				;store it into D1
	lda #'X
	jsr $ffd2
	jmp getKeyInput
dKey:
	dec $D3			; erase the character
	lda #' 
	jsr $ffd2		
	lda #'X			; print the character
	jsr $ffd2
	jmp getKeyInput
