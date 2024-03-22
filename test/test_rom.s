; SHVC-LZSA2
; David Lindecrantz <optiroc@me.com>
;
; Test!

.include "shvc_cpu.inc"
.include "shvc_mmio.inc"

.p816
.smart -
.feature c_comments

.import Compressed, LZSA2_DecompressBlock
.export Main

Destination = $7f0000

Main:
    .a8
    .i16
    nop

Test_START:
    ; Set source/destination
    ldy #.loword(Destination)
    ldx #.loword(Compressed)
    lda #^Destination
    xba
    lda #^Compressed

    jsl LZSA2_DecompressBlock

Test_END:
    nop
:   nop
    bra :-
