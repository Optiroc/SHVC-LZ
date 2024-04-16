; SHVC-LZ
; David Lindecrantz <optiroc@me.com>
;
; LZSA1 example usage

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
    ; LZSA1_DecompressBlock requires the following parameters:
    ;   x           Source offset
    ;   y           Destination offset
    ;   b:a         Destination:Source banks
    ldy #.loword(Destination)
    ldx #.loword(Compressed)
    lda #^Destination
    xba
    lda #^Compressed

    jsl LZSA1_DecompressBlock

:   wai
    bra :-

.segment "RODATA"
Compressed:
    .incbin "../../test/data/short.txt.lzsa1"

.segment "BSS7F"
Destination:
    .res $ffff
