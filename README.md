# SHVC-LZ

A collection of decoders for various modern variants of Lempel-Ziv style compression targeting the Super Famicom/Nintendo system.

Common characteristics:
- Full 24-bit addresses for source and destination are freely set at the call site.
- Designed to run from ROM – no self-modifying code.
- Uses DMA registers for temporary variables allowing for faster access than RAM.
- Uses DMA when copying literal strings.
- The compressed data or the decompression buffer may not cross bank boundaries.

# LZSA2

[LZSAv2](https://github.com/emmanuel-marty/lzsa) achieves better compression than LZ4 while still being fairly efficient to decode on 8-bit CPUs.

Performance compared to the [reference](https://github.com/emmanuel-marty/lzsa/blob/master/asm/65816/decompress_v2.asm) 65816 implementation:
```
Text file, 26582 -> 64115 bytes
  SHVC-LZSA2 decompressor:
    Master clocks:  13022382   0.606s  105.742KB/s
    CPU cycles:      2008232
  Reference decompressor:
    Master clocks:  43206022   2.012s  31.871KB/s
    CPU cycles:      5558506

Tile data, 1263 -> 4096 bytes
  SHVC-LZSA2 decompressor:
    Master clocks:    419886   0.012s  209.511KB/s
    CPU cycles:        62946
  Reference decompressor:
    Master clocks:   2148992   0.100s  40.936KB/s
    CPU cycles:       276526

Map data, 958 -> 8192 bytes
  SHVC-LZSA2 decompressor:
    Master clocks:    763744   0.036s  230.367KB/s
    CPU cycles:        62946
  Reference decompressor:
    Master clocks:   4063014   0.189s  43.303KB/s
    CPU cycles:       521874
```

## Future work
- Implement [LZSAv1](https://github.com/emmanuel-marty/lzsa) decoder.
- Implement [ZX0](https://github.com/einar-saukas/ZX0) decoder.

## Dependencies
- [lz4ultra](https://github.com/emmanuel-marty/lz4ultra) compressor by Emmanuel Marty
- [lzsa](https://github.com/emmanuel-marty/lzsa) compressor by Emmanuel Marty
- ca65 and ld65 from the [cc65](https://github.com/cc65/cc65) development package
- [Mesen](https://github.com/SourMesen/Mesen2) by Sour (to run tests and benchmarks)

All dependencies except Mesen are included in the repo.
