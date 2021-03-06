;This is the test program for the CPSC 599.82
;Test1 is flashing the screen with changing the Screen and border color register
;Test2 is print out "HELLO WORLD!" on the screen
;Test3 is created by mistake. It was originally get keyboard input and print it on the screen but it prints out grids


;==============================================================
;Start of the test programs
	processor	6502 ;pseudo code for dasm to indicate
	org	$1100        ;Start point of this program in the memory (4352 in decimal)

;START WHICH TEST? (Just for now, there is another way to switch the routines)
	jmp	test5

;============================================================
;Test5 - *** didn't work
;Trying to output some sound
test5:
	lda	#$F			;volume level 15
	lda	$900e		;
	sta	$900e
	lda	200
	lda	$900b
	sta	$900b
	jmp	test5


;=============================================================
;Test 4
;This one is the correct version of test3
;Which get the input from the keyboard and output on the screen
test4:
	jsr	$ffe4	;could change to $ffcf, but got problem when press enter key
	jsr	$ffd2
	jmp	test4

;==============================================================
;Test 3
;This one is trying to print character "X"
;GETIN, $ffe4 - Get character from keyboar queue(keyboard buffer)
test3:
	jsr $e55f	;clear screen
	jsr $ffc9	;
	lda $D5		; current line length
	adc	$D3		; $D3 is cursor position on line
	sta $D3
	lda #$40
	jsr	$ffd2
	
	
	jmp	donetest

;==============================================================
;Test 2
;This one prints "HELLO WORLD!" on the screen
;CHROUT $ffd2, Output character to channel
test2:
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
	jmp	donetest

;=====================================================
;Test 1
;This one flashing the screen by
;changing the Screen and border color register
test1:
	inc	$900f
	jmp	test1

donetest:
	jmp donetest