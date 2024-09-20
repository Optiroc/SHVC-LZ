# SHVC-LZ

A collection of decoders for various modern variants of Lempel-Ziv style compression targeting the Super Famicom/Nintendo system. Written for the [ca65 assembler](https://cc65.github.io/doc/ca65.html), but should be easy to port to other assemblers.

Common characteristics:
- Designed for speed over code size
- Designed to run from ROM – no self-modifying code
- Full 24-bit addresses for source and destination can be freely set at the call site
- Uses DMA registers for temporary variables allowing for faster access than RAM
- Uses DMA to copy literal strings
- The compressed data or the decompression buffer may not cross bank boundaries

Statistics (speeds in KB/s on a Super Nintendo @ 3.58MHz):
```
LZ4           Mean    Median       Min       Max
  Ratio      2.603     2.308     1.741     7.334
  Speed    209.377   186.633   137.775   403.959

LZSA1         Mean    Median       Min       Max
  Ratio      2.810     2.433     1.891     8.266
  Speed    200.319   178.357   135.252   404.598

LZSA2         Mean    Median       Min       Max
  Ratio      3.040     2.651     2.117     8.551
  Speed    144.596   121.368    96.250   349.974

ZX0           Mean    Median       Min       Max
  Ratio      3.217     2.718     2.176     9.799
  Speed    100.045    83.592    61.838   270.151
```
[Full statistics](Statistics.md)

## LZ4

[LZ4](https://lz4.org) aims to achieve extremely fast decompression speeds, with a block format that trades size for simplicity.

[Decompressor source](https://github.com/Optiroc/SHVC-LZ/blob/main/src/shvc-lz4.s)

## LZSA1

[LZSAv1](https://github.com/emmanuel-marty/lzsa) achieves better compression than LZ4 while still being almost as efficient to decode on 8-bit CPUs.

An excellent choice if you want fast decompression.

[Decompressor source](https://github.com/Optiroc/SHVC-LZ/blob/main/src/shvc-lzsa1.s)

## LZSA2

[LZSAv2](https://github.com/emmanuel-marty/lzsa) achieves better compression than LZSAv1 while still being fairly efficient to decode on 8-bit CPUs. Of the decompressors included in this collection it has the largest code size, which is due to the somewhat involved [block format](https://github.com/emmanuel-marty/lzsa/blob/master/BlockFormat_LZSA2.md).

Between the faster decompression of LZSA1 and the better compression ratio of ZX0, there is little reason to choose this algorithm.

[Decompressor source](https://github.com/Optiroc/SHVC-LZ/blob/main/src/shvc-lzsa2.s)

## ZX0

[ZX0](https://github.com/einar-saukas/ZX0) has the best compression ratio of the schemes included in this collection, which is achieved by encoding the length/match tokens in an [interlaced](https://github.com/einar-saukas/Zeta-Xi-Code?tab=readme-ov-file#factor-r) [Elias gamma coded](https://en.wikipedia.org/wiki/Elias_gamma_coding) bit stream. The bit twiddling involved accounts for the slower speed compared to the pure byte aligned (nibble in the case of LZSA2) accesses needed by the other decompressors.

That said it is still quite fast, and should be the clear choice if good compression ratio is the priority. It also has the smallest code size of the included decompressors.

[Decompressor source](https://github.com/Optiroc/SHVC-LZ/blob/main/src/shvc-zx0.s)

## Future work
- Improve test data set
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
