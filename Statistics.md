# SHVC-LZ Statistics

```
LZ4           Mean    Median       Min       Max
  Ratio      3.210     2.330     1.831     7.334
  Speed    257.450   277.310   131.781   400.881

LZSA2         Mean    Median       Min       Max
  Ratio      3.622     2.662     2.129     8.551
  Speed    186.946   188.834    95.300   348.218
```
## map1.bin
```
LZ4: 1117 -> 8192 bytes (7.334x)
  CPU cycles:       98244
  Master clocks:   654614
  Time:             0.030 s
  Speed:          268.772 KB/s

LZSA2: 958 -> 8192 bytes (8.551x)
  CPU cycles:      115602
  Master clocks:   763744
  Time:             0.036 s
  Speed:          230.367 KB/s
```
## tile1.bin
```
LZ4: 434 -> 2048 bytes (4.719x)
  CPU cycles:       15916
  Master clocks:   109722
  Time:             0.005 s
  Speed:          400.881 KB/s

LZSA2: 411 -> 2048 bytes (4.983x)
  CPU cycles:       18527
  Master clocks:   126316
  Time:             0.006 s
  Speed:          348.218 KB/s
```
## tile2.bin
```
LZ4: 1425 -> 4096 bytes (2.874x)
  CPU cycles:       43468
  Master clocks:   297146
  Time:             0.014 s
  Speed:          296.053 KB/s

LZSA2: 1263 -> 4096 bytes (3.243x)
  CPU cycles:       62946
  Master clocks:   419886
  Time:             0.020 s
  Speed:          209.511 KB/s
```
## tile3.bin
```
LZ4: 3537 -> 8192 bytes (2.316x)
  CPU cycles:       89674
  Master clocks:   615506
  Time:             0.029 s
  Speed:          285.849 KB/s

LZSA2: 3200 -> 8192 bytes (2.560x)
  CPU cycles:      141788
  Master clocks:   943106
  Time:             0.044 s
  Speed:          186.556 KB/s
```
## tile4.bin
```
LZ4: 3852 -> 8192 bytes (2.127x)
  CPU cycles:       71590
  Master clocks:   501578
  Time:             0.023 s
  Speed:          350.777 KB/s

LZSA2: 3516 -> 8192 bytes (2.330x)
  CPU cycles:      137972
  Master clocks:   920616
  Time:             0.043 s
  Speed:          191.113 KB/s
```
## vram1.bin
```
LZ4: 3972 -> 9312 bytes (2.344x)
  CPU cycles:      159155
  Master clocks:  1064326
  Time:             0.050 s
  Speed:          187.909 KB/s

LZSA2: 3369 -> 9312 bytes (2.764x)
  CPU cycles:      237492
  Master clocks:  1553212
  Time:             0.072 s
  Speed:          128.763 KB/s
```
## abam.txt
```
LZ4: 29987 -> 64115 bytes (2.138x)
  CPU cycles:     1519169
  Master clocks: 10008886
  Time:             0.466 s
  Speed:          137.579 KB/s

LZSA2: 26582 -> 64115 bytes (2.412x)
  CPU cycles:     2008232
  Master clocks: 13022382
  Time:             0.606 s
  Speed:          105.742 KB/s
```
## 2889.txt
```
LZ4: 17963 -> 32893 bytes (1.831x)
  CPU cycles:      811905
  Master clocks:  5360814
  Time:             0.250 s
  Speed:          131.781 KB/s

LZSA2: 15450 -> 32893 bytes (2.129x)
  CPU cycles:     1145133
  Master clocks:  7412916
  Time:             0.345 s
  Speed:           95.300 KB/s
```
