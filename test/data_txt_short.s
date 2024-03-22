; SHVC-LZSA2
; David Lindecrantz <optiroc@me.com>
;
; Very short text, 42 -> 51 bytes

.export Compressed

.segment "RODATA"
Compressed:
    .incbin "../data/short.txt.lzsa2"
