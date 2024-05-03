; SHVC-LZ
; David Lindecrantz <optiroc@me.com>
;
; ZX0 test runner

.include "shvc_cpu.inc"
.include "shvc_mmio.inc"

.p816
.smart -
.feature c_comments

.import Compressed, ZX0_Decompress
.export Main

DESTINATION_PADDING = $36

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

    jsl ZX0_Decompress

Benchmark_END:
    nop
Asserts_END:
    nop
Tests_DONE:
    nop
:   nop
    bra :-

.segment "BSS7F"
Padding:
    .res DESTINATION_PADDING
Destination:
    .res $ffff - DESTINATION_PADDING
