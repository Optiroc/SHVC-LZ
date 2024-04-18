; SHVC-LZ
; David Lindecrantz <optiroc@me.com>
;
; SHVC-ZX0 example usage

.p816
.smart -
.feature c_comments

.autoimport
.export Main

Main:
    .a8
    .i16

    ; Set source/destination
    ;
    ; ZX0_Decompress requires the following parameters:
    ;   x           Source offset
    ;   y           Destination offset
    ;   b:a         Destination:Source banks
    ldy #.loword(Destination)
    ldx #.loword(Compressed)
    lda #^Destination
    xba
    lda #^Compressed

    jsl ZX0_Decompress

:   wai
    bra :-

.segment "RODATA"
Compressed:
    .incbin "../../test/data/short.txt.zx0"
Compressed_END:
Compressed_Length = Compressed_END - Compressed

.segment "BSS7F"
Destination:
    .res $ffff
