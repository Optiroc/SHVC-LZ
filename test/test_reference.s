; SHVC-LZSA2
; David Lindecrantz <optiroc@me.com>
;
; Reference decompressor benchmark

.include "shvc_cpu.inc"
.include "shvc_mmio.inc"

.p816
.smart -
.feature c_comments

.autoimport +

; Silence "Address size mismatch, exported as 'zeropage', import as 'absolute'" nonsense
.importzp DECOMPRESS_LZSA2_SIZE
.import Compressed, LZSA2_DecompressBlock
.export Main, Scratchpad

Destination = $7f0000

Main:
    .a8
    .i16

    ; Copy decompressor to RAM
    ldx #(DECOMPRESS_LZSA2_SIZE + 1)
:   lda ROM_DECOMPRESS_LZSA2-1,x
    sta BSS_DECOMPRESS_LZSA2-1,x
    dex
    bne :-

Test_START:

    ; Set source/destination
    ldx #.loword(Compressed)
    stx LZSA_SRC_LO
    lda #^Compressed
    sta LZSA_SRC_BANK

    ldx #.loword(Destination)
    stx LZSA_DST_LO
    lda #^Destination
    sta LZSA_DST_BANK

    jsl BSS_DECOMPRESS_LZSA2

Test_END:
    nop
:   nop
    bra :-

.segment "ZEROPAGE"
Scratchpad:
    .res $10
