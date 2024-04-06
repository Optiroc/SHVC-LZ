; SHVC-LZSA2
; David Lindecrantz <optiroc@me.com>
;
; Text file, 15450 -> 32893 bytes

; SHVC-LZSA2/ROM decompressor:
;   Master clocks:   8045294   0.375s  87.809kbps
;   CPU cycles:      1258137

; Reference decompressor:
;   Master clocks:  23351204   1.087s  30.253kbps
;   CPU cycles:      3005557

.export Compressed

.segment "RODATA"
Compressed:
    .incbin "../test_data/2889.txt.lzsa2"
