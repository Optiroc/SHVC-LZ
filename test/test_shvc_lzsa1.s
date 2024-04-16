; SHVC-LZ
; David Lindecrantz <optiroc@me.com>
;
; LZSA1 test runner

.include "shvc_cpu.inc"
.include "shvc_mmio.inc"

.p816
.smart -
.feature c_comments

.import Compressed, LZSA1_DecompressBlock
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

    jsl LZSA1_DecompressBlock

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
