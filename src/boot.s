; SHVC-Base
; David Lindecrantz <optiroc@me.com>
;
; Shared init code

.include "shvc_cpu.inc"
.include "shvc_mmio.inc"

.p816
.smart -
.feature c_comments

.autoimport +
.export Boot, EmptyHandler

; Entry point
Boot:
    .a8             ; At reset M and X = 1
    .i8

    sei             ; Disable interrupts
    clc             ; Enter native mode
    xce

    jml @fast       ; Jump to fast mirror
@fast:

    lda #MEM_358_MHZ
    sta MEMSEL

    ldx #3          ; Wait for 3 frames
@wait_vbl:
:   lda HVBJOY      ; If currently in vblank, wait until flag is down
    bmi :-
:   lda HVBJOY      ; Wait until vblank flag is up
    bpl :-
    dex
    bne @wait_vbl

    a16i16
    ldx #$1fff      ; Set stack at $1fff
    txs
    lda #$0000      ; Set direct page at $0000
    tcd

    a8
    lda #$80        ; Set DB to $80
    pha
    plb

    jsr ResetMMIO
    jml Main

; Unused handlers
EmptyHandler:
    rti
