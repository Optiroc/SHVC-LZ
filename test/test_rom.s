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

Main:
    .a8
    .i16
    nop

Benchmark_START:
    ; Set source/destination
    ldy #.loword(Destination)
    ldx #.loword(Compressed)
    lda #^Destination
    xba
    lda #^Compressed

    jsl LZSA2_DecompressBlock

Benchmark_END:
    nop
Asserts_END:
    nop
Tests_DONE:
    nop
:   nop
    bra :-

.segment "BSS7F"
Destination:
    .res $ffff
