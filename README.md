# SHVC-LZ

A collection of decoders for various modern variants of Lempel-Ziv style compression targeting the Super Famicom/Nintendo system.

Common characteristics:
- Designed for speed over code size.
- Designed to run from ROM – no self-modifying code.
- Full 24-bit addresses for source and destination are freely set at the call site.
- Uses DMA registers for temporary variables allowing for faster access than RAM.
- Uses DMA when copying literal strings.
- The compressed data or the decompression buffer may not cross bank boundaries.

Statistics (speeds in KB/s on a Super Nintendo @ 3.58MHz):
```
LZ4           Mean    Median       Min       Max
  Ratio      2.603     2.308     1.741     7.334
  Speed    205.236   183.023   133.517   402.392

LZSA1         Mean    Median       Min       Max
  Ratio      2.810     2.433     1.891     8.266
  Speed    194.060   172.119   131.160   396.615

LZSA2         Mean    Median       Min       Max
  Ratio      3.040     2.651     2.117     8.551
  Speed    144.438   121.212    96.235   349.174
```
[Full statistics](Statistics.md)

## LZ4

[LZ4](https://lz4.org) aims to achieve extremely fast decompression speeds, with a block format that trades size for simplicity.

[Decompressor source](https://github.com/Optiroc/SHVC-LZ/blob/main/src/shvc-lz4.s)

## LZSA1

[LZSAv1](https://github.com/emmanuel-marty/lzsa) achieves better compression than LZ4 while still being very efficient to decode on 8-bit CPUs.

[Decompressor source](https://github.com/Optiroc/SHVC-LZ/blob/main/src/shvc-lzsa1.s)

## LZSA2

[LZSAv2](https://github.com/emmanuel-marty/lzsa) achieves better compression than LZSAv1 while still being fairly efficient to decode on 8-bit CPUs. Of the decompressors included in this collection it has the largest code size, which is due to the somewhat involved [block format](https://github.com/emmanuel-marty/lzsa/blob/master/BlockFormat_LZSA2.md). 

[Decompressor source](https://github.com/Optiroc/SHVC-LZ/blob/main/src/shvc-lzsa2.s)

Performance compared to the [reference](https://github.com/emmanuel-marty/lzsa/blob/master/asm/65816/decompress_v2.asm) 65816 implementation:
```
Tile data, 1263 -> 4096 bytes
  SHVC-LZSA2 decompressor:
    Master clocks:    419886   0.020s  209.511KB/s
    CPU cycles:        62946
  Reference decompressor:
    Master clocks:   2148992   0.100s   40.936KB/s
    CPU cycles:       276526

Text file, 26582 -> 64115 bytes
  SHVC-LZSA2 decompressor:
    Master clocks:  13022382   0.606s  105.742KB/s
    CPU cycles:      2008232
  Reference decompressor:
    Master clocks:  43206022   2.012s   31.871KB/s
    CPU cycles:      5558506
```

## Future work
- Implement [ZX0](https://github.com/einar-saukas/ZX0) decoder
- Improve test data set
- Include inlining on/off variants in tests and statistics
- Add optional bank crossing ability 

## Dependencies
- [lz4ultra](https://github.com/emmanuel-marty/lz4ultra) compressor by Emmanuel Marty
- [lzsa](https://github.com/emmanuel-marty/lzsa) compressor by Emmanuel Marty
- [salvador](https://github.com/emmanuel-marty/salvador) compressor by Emmanuel Marty
- ca65 and ld65 from the [cc65](https://github.com/cc65/cc65) development package
- [Mesen](https://github.com/SourMesen/Mesen2) by Sour (for running tests and benchmarks)

All dependencies except Mesen are included in this repository.

##
SHVC-LZ is developed by David Lindecrantz and distributed under the terms of the [MIT license](./LICENSE).
