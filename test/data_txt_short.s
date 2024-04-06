; SHVC-LZSA2
; David Lindecrantz <optiroc@me.com>
;
; Very short text, 42 -> 51 bytes

.export Compressed

.segment "RODATA"
Compressed:
    .incbin "../test_data/short.txt.lzsa2"
