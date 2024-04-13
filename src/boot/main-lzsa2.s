; SHVC-LZ
; David Lindecrantz <optiroc@me.com>
;
; LZSA2 example usage

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
    ; LZSA2_DecompressBlock requires the following parameters:
    ;   x           Source offset
    ;   y           Destination offset
    ;   b:a         Destination:Source banks
    ldy #.loword(Destination)
    ldx #.loword(Compressed)
    lda #^Destination
    xba
    lda #^Compressed

    jsl LZSA2_DecompressBlock

:   wai
    bra :-

.segment "RODATA"
Compressed:
    .incbin "../../test/data/short.txt.lzsa2"

.segment "BSS7F"
Destination:
    .res $ffff
