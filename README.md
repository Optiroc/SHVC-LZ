# SHVC-LZSA2

An [LZSAv2](https://github.com/emmanuel-marty/lzsa) decompressor for the 65816 CPU. Specifically targeting SFC/SNES, but should work on other systems.

Performance compared to the [reference](https://github.com/emmanuel-marty/lzsa/blob/master/asm/65816/decompress_v2.asm) 65816 implementation:
```
Text file, 26582 -> 64115 bytes
  SHVC-LZSA2/ROM decompressor:
    Master clocks:  13951884   0.650s  98.697KB/s
    CPU cycles:      2178471
  Reference decompressor:
    Master clocks:  43206022   2.012s  31.871KB/s
    CPU cycles:      5558506
```

## TODO
Add more tests and benchmarks.

## Dependencies
- [LZSA](https://github.com/emmanuel-marty/lzsa) compressor (included in repo)
- ca65 and ld65 from the [cc65](https://github.com/cc65/cc65) development package (included in repo)
