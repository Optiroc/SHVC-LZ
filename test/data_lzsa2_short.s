.export Compressed

.segment "RODATA"
Compressed:
    .incbin "../test_data/short.txt.lzsa2"
