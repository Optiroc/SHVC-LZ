# SHVC-LZ Statistics
```
LZ4           Mean    Median       Min       Max
  Ratio      2.603     2.308     1.741     7.334
  Speed    205.245   183.024   133.518   402.480

LZSA1         Mean    Median       Min       Max
  Ratio      2.810     2.433     1.891     8.266
  Speed    194.060   172.119   131.160   396.615

LZSA2         Mean    Median       Min       Max
  Ratio      3.040     2.651     2.117     8.551
  Speed    144.438   121.212    96.235   349.174

ZX0           Mean    Median       Min       Max
  Ratio      3.217     2.718     2.176     9.799
  Speed     92.579    76.333    55.811   258.012
```
## calgary/obj1
```
LZ4: 12349 -> 21504 bytes (1.741x)
  CPU cycles:      317199
  Master clocks:  2154108
  Time:             0.100 s
  Speed:          214.403 KB/s

LZSA1: 11372 -> 21504 bytes (1.891x)
  CPU cycles:      394188
  Master clocks:  2646080
  Time:             0.123 s
  Speed:          174.540 KB/s

LZSA2: 9988 -> 21504 bytes (2.153x)
  CPU cycles:      585168
  Master clocks:  3810250
  Time:             0.177 s
  Speed:          121.212 KB/s

ZX0: 9597 -> 21504 bytes (2.241x)
  CPU cycles:      937782
  Master clocks:  6110886
  Time:             0.285 s
  Speed:           75.578 KB/s
```
## calgary/paper1
```
LZ4: 23030 -> 53161 bytes (2.308x)
  CPU cycles:     1128482
  Master clocks:  7439350
  Time:             0.346 s
  Speed:          153.475 KB/s

LZSA1: 21848 -> 53161 bytes (2.433x)
  CPU cycles:     1147396
  Master clocks:  7564624
  Time:             0.352 s
  Speed:          150.933 KB/s

LZSA2: 20052 -> 53161 bytes (2.651x)
  CPU cycles:     1537208
  Master clocks:  9957682
  Time:             0.464 s
  Speed:          114.661 KB/s

ZX0: 19937 -> 53161 bytes (2.666x)
  CPU cycles:     2598897
  Master clocks: 16714538
  Time:             0.778 s
  Speed:           68.309 KB/s
```
## calgary/paper3
```
LZ4: 22777 -> 46526 bytes (2.043x)
  CPU cycles:     1071346
  Master clocks:  7053702
  Time:             0.328 s
  Speed:          141.663 KB/s

LZSA1: 21787 -> 46526 bytes (2.135x)
  CPU cycles:     1086463
  Master clocks:  7155778
  Time:             0.333 s
  Speed:          139.643 KB/s

LZSA2: 19874 -> 46526 bytes (2.341x)
  CPU cycles:     1483910
  Master clocks:  9594508
  Time:             0.447 s
  Speed:          104.148 KB/s

ZX0: 19656 -> 46526 bytes (2.367x)
  CPU cycles:     2565652
  Master clocks: 16478002
  Time:             0.767 s
  Speed:           60.642 KB/s
```
## calgary/paper4
```
LZ4: 7451 -> 13286 bytes (1.783x)
  CPU cycles:      286878
  Master clocks:  1901796
  Time:             0.089 s
  Speed:          150.041 KB/s

LZSA1: 6952 -> 13286 bytes (1.911x)
  CPU cycles:      310002
  Master clocks:  2050556
  Time:             0.095 s
  Speed:          139.156 KB/s

LZSA2: 6222 -> 13286 bytes (2.135x)
  CPU cycles:      451845
  Master clocks:  2920772
  Time:             0.136 s
  Speed:           97.696 KB/s

ZX0: 5873 -> 13286 bytes (2.262x)
  CPU cycles:      740027
  Master clocks:  4769218
  Time:             0.222 s
  Speed:           59.831 KB/s
```
## calgary/paper5
```
LZ4: 6718 -> 11954 bytes (1.779x)
  CPU cycles:      257416
  Master clocks:  1707370
  Time:             0.079 s
  Speed:          150.371 KB/s

LZSA1: 6224 -> 11954 bytes (1.921x)
  CPU cycles:      276407
  Master clocks:  1829232
  Time:             0.085 s
  Speed:          140.354 KB/s

LZSA2: 5581 -> 11954 bytes (2.142x)
  CPU cycles:      399810
  Master clocks:  2586272
  Time:             0.120 s
  Speed:           99.270 KB/s

ZX0: 5265 -> 11954 bytes (2.270x)
  CPU cycles:      649532
  Master clocks:  4190016
  Time:             0.195 s
  Speed:           61.274 KB/s
```
## calgary/paper6
```
LZ4: 17022 -> 38105 bytes (2.239x)
  CPU cycles:      796782
  Master clocks:  5261322
  Time:             0.245 s
  Speed:          155.549 KB/s

LZSA1: 15889 -> 38105 bytes (2.398x)
  CPU cycles:      820732
  Master clocks:  5416896
  Time:             0.252 s
  Speed:          151.081 KB/s

LZSA2: 14464 -> 38105 bytes (2.634x)
  CPU cycles:     1112438
  Master clocks:  7206842
  Time:             0.336 s
  Speed:          113.558 KB/s

ZX0: 14022 -> 38105 bytes (2.718x)
  CPU cycles:     1829398
  Master clocks: 11780834
  Time:             0.549 s
  Speed:           69.468 KB/s
```
## calgary/progc
```
LZ4: 17159 -> 39611 bytes (2.308x)
  CPU cycles:      809993
  Master clocks:  5351266
  Time:             0.249 s
  Speed:          158.978 KB/s

LZSA1: 15865 -> 39611 bytes (2.497x)
  CPU cycles:      832175
  Master clocks:  5494288
  Time:             0.256 s
  Speed:          154.840 KB/s

LZSA2: 14492 -> 39611 bytes (2.733x)
  CPU cycles:     1120797
  Master clocks:  7267076
  Time:             0.338 s
  Speed:          117.067 KB/s

ZX0: 14093 -> 39611 bytes (2.811x)
  CPU cycles:     1825152
  Master clocks: 11761212
  Time:             0.548 s
  Speed:           72.334 KB/s
```
## calgary/progp
```
LZ4: 14233 -> 49379 bytes (3.469x)
  CPU cycles:      805296
  Master clocks:  5333826
  Time:             0.248 s
  Speed:          198.830 KB/s

LZSA1: 12906 -> 49379 bytes (3.826x)
  CPU cycles:      828784
  Master clocks:  5483764
  Time:             0.255 s
  Speed:          193.394 KB/s

LZSA2: 11899 -> 49379 bytes (4.150x)
  CPU cycles:     1079668
  Master clocks:  7031324
  Time:             0.327 s
  Speed:          150.829 KB/s

ZX0: 11561 -> 49379 bytes (4.271x)
  CPU cycles:     1615556
  Master clocks: 10448186
  Time:             0.486 s
  Speed:          101.503 KB/s
```
## canterbury/cp.html
```
LZ4: 10290 -> 24603 bytes (2.391x)
  CPU cycles:      411339
  Master clocks:  2744830
  Time:             0.128 s
  Speed:          192.509 KB/s

LZSA1: 9803 -> 24603 bytes (2.510x)
  CPU cycles:      447674
  Master clocks:  2976372
  Time:             0.139 s
  Speed:          177.533 KB/s

LZSA2: 9007 -> 24603 bytes (2.732x)
  CPU cycles:      651824
  Master clocks:  4233730
  Time:             0.197 s
  Speed:          124.808 KB/s

ZX0: 8567 -> 24603 bytes (2.872x)
  CPU cycles:     1072247
  Master clocks:  6922386
  Time:             0.322 s
  Speed:           76.333 KB/s
```
## canterbury/fields.c
```
LZ4: 4204 -> 11150 bytes (2.652x)
  CPU cycles:      200707
  Master clocks:  1329652
  Time:             0.062 s
  Speed:          180.101 KB/s

LZSA1: 3755 -> 11150 bytes (2.969x)
  CPU cycles:      207985
  Master clocks:  1376058
  Time:             0.064 s
  Speed:          174.027 KB/s

LZSA2: 3436 -> 11150 bytes (3.245x)
  CPU cycles:      281280
  Master clocks:  1829852
  Time:             0.085 s
  Speed:          130.869 KB/s

ZX0: 3214 -> 11150 bytes (3.469x)
  CPU cycles:      417894
  Master clocks:  2703194
  Time:             0.126 s
  Speed:           88.588 KB/s
```
## canterbury/grammar.lsp
```
LZ4: 1720 -> 3721 bytes (2.163x)
  CPU cycles:       65112
  Master clocks:   434130
  Time:             0.020 s
  Speed:          184.085 KB/s

LZSA1: 1518 -> 3721 bytes (2.451x)
  CPU cycles:       69837
  Master clocks:   464312
  Time:             0.022 s
  Speed:          172.119 KB/s

LZSA2: 1403 -> 3721 bytes (2.652x)
  CPU cycles:      101975
  Master clocks:   663468
  Time:             0.031 s
  Speed:          120.453 KB/s

ZX0: 1304 -> 3721 bytes (2.854x)
  CPU cycles:      154639
  Master clocks:  1002644
  Time:             0.047 s
  Speed:           79.706 KB/s
```
## canterbury/sum
```
LZ4: 16291 -> 38240 bytes (2.347x)
  CPU cycles:      673212
  Master clocks:  4487348
  Time:             0.209 s
  Speed:          183.024 KB/s

LZSA1: 14362 -> 38240 bytes (2.663x)
  CPU cycles:      768990
  Master clocks:  5103202
  Time:             0.238 s
  Speed:          160.936 KB/s

LZSA2: 12017 -> 38240 bytes (3.182x)
  CPU cycles:      978614
  Master clocks:  6350434
  Time:             0.296 s
  Speed:          129.328 KB/s

ZX0: 11416 -> 38240 bytes (3.350x)
  CPU cycles:     1454177
  Master clocks:  9468200
  Time:             0.441 s
  Speed:           86.742 KB/s
```
## canterbury/xargs.1
```
LZ4: 2403 -> 4227 bytes (1.759x)
  CPU cycles:       79994
  Master clocks:   533906
  Time:             0.025 s
  Speed:          170.038 KB/s

LZSA1: 2210 -> 4227 bytes (1.913x)
  CPU cycles:       90500
  Master clocks:   601204
  Time:             0.028 s
  Speed:          151.004 KB/s

LZSA2: 1997 -> 4227 bytes (2.117x)
  CPU cycles:      134947
  Master clocks:   874830
  Time:             0.041 s
  Speed:          103.774 KB/s

ZX0: 1842 -> 4227 bytes (2.295x)
  CPU cycles:      216788
  Master clocks:  1402098
  Time:             0.065 s
  Speed:           64.749 KB/s
```
## map1.bin
```
LZ4: 1117 -> 8192 bytes (7.334x)
  CPU cycles:       97504
  Master clocks:   649010
  Time:             0.030 s
  Speed:          271.093 KB/s

LZSA1: 991 -> 8192 bytes (8.266x)
  CPU cycles:       95548
  Master clocks:   636298
  Time:             0.030 s
  Speed:          276.508 KB/s

LZSA2: 958 -> 8192 bytes (8.551x)
  CPU cycles:      115031
  Master clocks:   759106
  Time:             0.035 s
  Speed:          231.775 KB/s

ZX0: 836 -> 8192 bytes (9.799x)
  CPU cycles:      154311
  Master clocks:  1007224
  Time:             0.047 s
  Speed:          174.680 KB/s
```
## tile1.bin
```
LZ4: 434 -> 2048 bytes (4.719x)
  CPU cycles:       15862
  Master clocks:   109286
  Time:             0.005 s
  Speed:          402.480 KB/s

LZSA1: 422 -> 2048 bytes (4.853x)
  CPU cycles:       16107
  Master clocks:   110902
  Time:             0.005 s
  Speed:          396.615 KB/s

LZSA2: 411 -> 2048 bytes (4.983x)
  CPU cycles:       18482
  Master clocks:   125970
  Time:             0.006 s
  Speed:          349.174 KB/s

ZX0: 397 -> 2048 bytes (5.159x)
  CPU cycles:       25481
  Master clocks:   170478
  Time:             0.008 s
  Speed:          258.012 KB/s
```
## tile2.bin
```
LZ4: 1425 -> 4096 bytes (2.874x)
  CPU cycles:       43164
  Master clocks:   294798
  Time:             0.014 s
  Speed:          298.411 KB/s

LZSA1: 1331 -> 4096 bytes (3.077x)
  CPU cycles:       45995
  Master clocks:   313100
  Time:             0.015 s
  Speed:          280.967 KB/s

LZSA2: 1263 -> 4096 bytes (3.243x)
  CPU cycles:       62658
  Master clocks:   417428
  Time:             0.019 s
  Speed:          210.745 KB/s

ZX0: 1171 -> 4096 bytes (3.498x)
  CPU cycles:      107175
  Master clocks:   705014
  Time:             0.033 s
  Speed:          124.779 KB/s
```
## tile3.bin
```
LZ4: 3537 -> 8192 bytes (2.316x)
  CPU cycles:       88934
  Master clocks:   609708
  Time:             0.028 s
  Speed:          288.567 KB/s

LZSA1: 3419 -> 8192 bytes (2.396x)
  CPU cycles:       97052
  Master clocks:   661746
  Time:             0.031 s
  Speed:          265.875 KB/s

LZSA2: 3200 -> 8192 bytes (2.560x)
  CPU cycles:      140751
  Master clocks:   934768
  Time:             0.044 s
  Speed:          188.220 KB/s

ZX0: 3046 -> 8192 bytes (2.689x)
  CPU cycles:      245622
  Master clocks:  1609232
  Time:             0.075 s
  Speed:          109.333 KB/s
```
## tile4.bin
```
LZ4: 3852 -> 8192 bytes (2.127x)
  CPU cycles:       71064
  Master clocks:   497516
  Time:             0.023 s
  Speed:          353.640 KB/s

LZSA1: 3742 -> 8192 bytes (2.189x)
  CPU cycles:       77460
  Master clocks:   538476
  Time:             0.025 s
  Speed:          326.740 KB/s

LZSA2: 3516 -> 8192 bytes (2.330x)
  CPU cycles:      136961
  Master clocks:   912418
  Time:             0.042 s
  Speed:          192.830 KB/s

ZX0: 3393 -> 8192 bytes (2.414x)
  CPU cycles:      237992
  Master clocks:  1564620
  Time:             0.073 s
  Speed:          112.450 KB/s
```
## vram1.bin
```
LZ4: 3972 -> 9312 bytes (2.344x)
  CPU cycles:      157711
  Master clocks:  1052642
  Time:             0.049 s
  Speed:          189.995 KB/s

LZSA1: 3630 -> 9312 bytes (2.565x)
  CPU cycles:      169286
  Master clocks:  1126986
  Time:             0.052 s
  Speed:          177.461 KB/s

LZSA2: 3369 -> 9312 bytes (2.764x)
  CPU cycles:      235812
  Master clocks:  1539072
  Time:             0.072 s
  Speed:          129.946 KB/s

ZX0: 3121 -> 9312 bytes (2.984x)
  CPU cycles:      368250
  Master clocks:  2392428
  Time:             0.111 s
  Speed:           83.596 KB/s
```
## abam.txt
```
LZ4: 29987 -> 64115 bytes (2.138x)
  CPU cycles:     1503465
  Master clocks:  9879750
  Time:             0.460 s
  Speed:          139.378 KB/s

LZSA1: 28725 -> 64115 bytes (2.232x)
  CPU cycles:     1490962
  Master clocks:  9809718
  Time:             0.457 s
  Speed:          140.373 KB/s

LZSA2: 26582 -> 64115 bytes (2.412x)
  CPU cycles:     1997546
  Master clocks: 12918798
  Time:             0.602 s
  Speed:          106.590 KB/s

ZX0: 26776 -> 64115 bytes (2.394x)
  CPU cycles:     3550561
  Master clocks: 22786472
  Time:             1.061 s
  Speed:           60.431 KB/s
```
## 2889.txt
```
LZ4: 17963 -> 32893 bytes (1.831x)
  CPU cycles:      803437
  Master clocks:  5291062
  Time:             0.246 s
  Speed:          133.518 KB/s

LZSA1: 17214 -> 32893 bytes (1.911x)
  CPU cycles:      817570
  Master clocks:  5386176
  Time:             0.251 s
  Speed:          131.160 KB/s

LZSA2: 15450 -> 32893 bytes (2.129x)
  CPU cycles:     1137010
  Master clocks:  7340886
  Time:             0.342 s
  Speed:           96.235 KB/s

ZX0: 15115 -> 32893 bytes (2.176x)
  CPU cycles:     1971096
  Master clocks: 12657856
  Time:             0.589 s
  Speed:           55.811 KB/s
```
