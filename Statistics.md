# SHVC-LZ Statistics
```
LZ4           Mean    Median       Min       Max
  Ratio      2.603     2.308     1.741     7.334
  Speed    203.169   181.089   131.781   400.881

LZSA1         Mean    Median       Min       Max
  Ratio      2.810     2.433     1.891     8.266
  Speed    191.465   169.462   128.906   394.609

LZSA2         Mean    Median       Min       Max
  Ratio      3.040     2.651     2.117     8.551
  Speed    143.313   120.267    95.300   348.218
```
## calgary/obj1
```
LZ4: 12349 -> 21504 bytes (1.741x)
  CPU cycles:      320137
  Master clocks:  2177426
  Time:             0.101 s
  Speed:          212.107 KB/s

LZSA1: 11372 -> 21504 bytes (1.891x)
  CPU cycles:      400578
  Master clocks:  2692526
  Time:             0.125 s
  Speed:          171.529 KB/s

LZSA2: 9988 -> 21504 bytes (2.153x)
  CPU cycles:      588344
  Master clocks:  3840168
  Time:             0.179 s
  Speed:          120.267 KB/s
```
## calgary/paper1
```
LZ4: 23030 -> 53161 bytes (2.308x)
  CPU cycles:     1139926
  Master clocks:  7532558
  Time:             0.351 s
  Speed:          151.576 KB/s

LZSA1: 21848 -> 53161 bytes (2.433x)
  CPU cycles:     1163366
  Master clocks:  7686016
  Time:             0.358 s
  Speed:          148.549 KB/s

LZSA2: 20052 -> 53161 bytes (2.651x)
  CPU cycles:     1546425
  Master clocks: 10042028
  Time:             0.468 s
  Speed:          113.697 KB/s
```
## calgary/paper3
```
LZ4: 22777 -> 46526 bytes (2.043x)
  CPU cycles:     1082498
  Master clocks:  7145356
  Time:             0.333 s
  Speed:          139.846 KB/s

LZSA1: 21787 -> 46526 bytes (2.135x)
  CPU cycles:     1102235
  Master clocks:  7275384
  Time:             0.339 s
  Speed:          137.347 KB/s

LZSA2: 19874 -> 46526 bytes (2.341x)
  CPU cycles:     1493047
  Master clocks:  9678740
  Time:             0.451 s
  Speed:          103.242 KB/s
```
## calgary/paper4
```
LZ4: 7451 -> 13286 bytes (1.783x)
  CPU cycles:      289822
  Master clocks:  1925916
  Time:             0.090 s
  Speed:          148.162 KB/s

LZSA1: 6952 -> 13286 bytes (1.911x)
  CPU cycles:      314838
  Master clocks:  2086908
  Time:             0.097 s
  Speed:          136.732 KB/s

LZSA2: 6222 -> 13286 bytes (2.135x)
  CPU cycles:      455706
  Master clocks:  2953016
  Time:             0.137 s
  Speed:           96.629 KB/s
```
## calgary/paper5
```
LZ4: 6718 -> 11954 bytes (1.779x)
  CPU cycles:      260030
  Master clocks:  1728834
  Time:             0.080 s
  Speed:          148.504 KB/s

LZSA1: 6224 -> 11954 bytes (1.921x)
  CPU cycles:      280727
  Master clocks:  1861664
  Time:             0.087 s
  Speed:          137.908 KB/s

LZSA2: 5581 -> 11954 bytes (2.142x)
  CPU cycles:      403282
  Master clocks:  2615196
  Time:             0.122 s
  Speed:           98.172 KB/s
```
## calgary/paper6
```
LZ4: 17022 -> 38105 bytes (2.239x)
  CPU cycles:      804770
  Master clocks:  5326452
  Time:             0.248 s
  Speed:          153.647 KB/s

LZSA1: 15889 -> 38105 bytes (2.398x)
  CPU cycles:      832386
  Master clocks:  5504916
  Time:             0.256 s
  Speed:          148.666 KB/s

LZSA2: 14464 -> 38105 bytes (2.634x)
  CPU cycles:     1119726
  Master clocks:  7271714
  Time:             0.339 s
  Speed:          112.544 KB/s
```
## calgary/progc
```
LZ4: 17159 -> 39611 bytes (2.308x)
  CPU cycles:      818141
  Master clocks:  5417302
  Time:             0.252 s
  Speed:          157.041 KB/s

LZSA1: 15865 -> 39611 bytes (2.497x)
  CPU cycles:      843687
  Master clocks:  5581748
  Time:             0.260 s
  Speed:          152.414 KB/s

LZSA2: 14492 -> 39611 bytes (2.733x)
  CPU cycles:     1128315
  Master clocks:  7333128
  Time:             0.341 s
  Speed:          116.013 KB/s
```
## calgary/progp
```
LZ4: 14233 -> 49379 bytes (3.469x)
  CPU cycles:      812518
  Master clocks:  5391826
  Time:             0.251 s
  Speed:          196.691 KB/s

LZSA1: 12906 -> 49379 bytes (3.826x)
  CPU cycles:      838480
  Master clocks:  5557732
  Time:             0.259 s
  Speed:          190.820 KB/s

LZSA2: 11899 -> 49379 bytes (4.150x)
  CPU cycles:     1085692
  Master clocks:  7085250
  Time:             0.330 s
  Speed:          149.681 KB/s
```
## canterbury/cp.html
```
LZ4: 10290 -> 24603 bytes (2.391x)
  CPU cycles:      415245
  Master clocks:  2775870
  Time:             0.129 s
  Speed:          190.357 KB/s

LZSA1: 9803 -> 24603 bytes (2.510x)
  CPU cycles:      453782
  Master clocks:  3022008
  Time:             0.141 s
  Speed:          174.852 KB/s

LZSA2: 9007 -> 24603 bytes (2.732x)
  CPU cycles:      656420
  Master clocks:  4273022
  Time:             0.199 s
  Speed:          123.661 KB/s
```
## canterbury/fields.c
```
LZ4: 4204 -> 11150 bytes (2.652x)
  CPU cycles:      202667
  Master clocks:  1345414
  Time:             0.063 s
  Speed:          177.991 KB/s

LZSA1: 3755 -> 11150 bytes (2.969x)
  CPU cycles:      210629
  Master clocks:  1396254
  Time:             0.065 s
  Speed:          171.510 KB/s

LZSA2: 3436 -> 11150 bytes (3.245x)
  CPU cycles:      283402
  Master clocks:  1847532
  Time:             0.086 s
  Speed:          129.617 KB/s
```
## canterbury/grammar.lsp
```
LZ4: 1720 -> 3721 bytes (2.163x)
  CPU cycles:       65744
  Master clocks:   439138
  Time:             0.020 s
  Speed:          181.986 KB/s

LZSA1: 1518 -> 3721 bytes (2.451x)
  CPU cycles:       70809
  Master clocks:   471592
  Time:             0.022 s
  Speed:          169.462 KB/s

LZSA2: 1403 -> 3721 bytes (2.652x)
  CPU cycles:      102822
  Master clocks:   670392
  Time:             0.031 s
  Speed:          119.209 KB/s
```
## canterbury/sum
```
LZ4: 16291 -> 38240 bytes (2.347x)
  CPU cycles:      679152
  Master clocks:  4535300
  Time:             0.211 s
  Speed:          181.089 KB/s

LZSA1: 14362 -> 38240 bytes (2.663x)
  CPU cycles:      780778
  Master clocks:  5188048
  Time:             0.242 s
  Speed:          158.304 KB/s

LZSA2: 12017 -> 38240 bytes (3.182x)
  CPU cycles:      981340
  Master clocks:  6384376
  Time:             0.297 s
  Speed:          128.641 KB/s
```
## canterbury/xargs.1
```
LZ4: 2403 -> 4227 bytes (1.759x)
  CPU cycles:       80800
  Master clocks:   540554
  Time:             0.025 s
  Speed:          167.947 KB/s

LZSA1: 2210 -> 4227 bytes (1.913x)
  CPU cycles:       91884
  Master clocks:   611378
  Time:             0.028 s
  Speed:          148.491 KB/s

LZSA2: 1997 -> 4227 bytes (2.117x)
  CPU cycles:      136123
  Master clocks:   884524
  Time:             0.041 s
  Speed:          102.636 KB/s
```
## map1.bin
```
LZ4: 1117 -> 8192 bytes (7.334x)
  CPU cycles:       98244
  Master clocks:   654614
  Time:             0.030 s
  Speed:          268.772 KB/s

LZSA1: 991 -> 8192 bytes (8.266x)
  CPU cycles:       96178
  Master clocks:   641290
  Time:             0.030 s
  Speed:          274.356 KB/s

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

LZSA1: 422 -> 2048 bytes (4.853x)
  CPU cycles:       16187
  Master clocks:   111466
  Time:             0.005 s
  Speed:          394.609 KB/s

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

LZSA1: 1331 -> 4096 bytes (3.077x)
  CPU cycles:       46487
  Master clocks:   316604
  Time:             0.015 s
  Speed:          277.858 KB/s

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

LZSA1: 3419 -> 8192 bytes (2.396x)
  CPU cycles:       98196
  Master clocks:   670136
  Time:             0.031 s
  Speed:          262.546 KB/s

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

LZSA1: 3742 -> 8192 bytes (2.189x)
  CPU cycles:       78292
  Master clocks:   544532
  Time:             0.025 s
  Speed:          323.106 KB/s

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

LZSA1: 3630 -> 9312 bytes (2.565x)
  CPU cycles:      171704
  Master clocks:  1144750
  Time:             0.053 s
  Speed:          174.707 KB/s

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

LZSA1: 28725 -> 64115 bytes (2.232x)
  CPU cycles:     1512220
  Master clocks:  9971882
  Time:             0.464 s
  Speed:          138.090 KB/s

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

LZSA1: 17214 -> 32893 bytes (1.911x)
  CPU cycles:      830062
  Master clocks:  5480360
  Time:             0.255 s
  Speed:          128.906 KB/s

LZSA2: 15450 -> 32893 bytes (2.129x)
  CPU cycles:     1145133
  Master clocks:  7412916
  Time:             0.345 s
  Speed:           95.300 KB/s
```
