; SHVC-LZSA2
; David Lindecrantz <optiroc@me.com>
;
; Text file, 26582 -> 64115 bytes

; SHVC-LZSA2/ROM decompressor:
;   Master clocks:  13951884   0.650s  98.697kbps
;   CPU cycles:      2178471

; Reference decompressor:
;   Master clocks:  43206022   2.012s  31.871kbps
;   CPU cycles:      5558506

.export Compressed

.segment "RODATA"
Compressed:
    .incbin "../data/abam.txt.lzsa2"
