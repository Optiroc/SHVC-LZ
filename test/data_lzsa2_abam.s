.export Compressed

.segment "RODATA"
Compressed:
    .incbin "../test_data/abam.txt.lzsa2"
