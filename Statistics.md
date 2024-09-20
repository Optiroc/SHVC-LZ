# SHVC-LZ Statistics
```
LZ4           Mean    Median       Min       Max
  Ratio      2.603     2.308     1.741     7.334
  Speed    209.377   186.633   137.775   403.959

LZSA1         Mean    Median       Min       Max
  Ratio      2.810     2.433     1.891     8.266
  Speed    199.492   177.663   135.193   402.384

LZSA2         Mean    Median       Min       Max
  Ratio      3.040     2.651     2.117     8.551
  Speed    144.596   121.368    96.250   349.974

ZX0           Mean    Median       Min       Max
  Ratio      3.217     2.718     2.176     9.799
  Speed    100.045    83.592    61.838   270.151
```
## calgary/obj1
```
LZ4: 12349 -> 21504 bytes (1.741x)
  CPU cycles:      311651
  Master clocks:  2119818
  Time:             0.099 s
  Speed:          217.871 KB/s

LZSA1: 11372 -> 21504 bytes (1.891x)
  CPU cycles:      383965
  Master clocks:  2580378
  Time:             0.120 s
  Speed:          178.984 KB/s

LZSA2: 9988 -> 21504 bytes (2.153x)
  CPU cycles:      584368
  Master clocks:  3805352
  Time:             0.177 s
  Speed:          121.368 KB/s

ZX0: 9597 -> 21504 bytes (2.241x)
  CPU cycles:      872726
  Master clocks:  5679330
  Time:             0.264 s
  Speed:           81.321 KB/s
```
## calgary/paper1
```
LZ4: 23030 -> 53161 bytes (2.308x)
  CPU cycles:     1093114
  Master clocks:  7220558
  Time:             0.336 s
  Speed:          158.125 KB/s

LZSA1: 21848 -> 53161 bytes (2.433x)
  CPU cycles:     1110220
  Master clocks:  7332290
  Time:             0.341 s
  Speed:          155.716 KB/s

LZSA2: 20052 -> 53161 bytes (2.651x)
  CPU cycles:     1536866
  Master clocks:  9955532
  Time:             0.464 s
  Speed:          114.685 KB/s

ZX0: 19937 -> 53161 bytes (2.666x)
  CPU cycles:     2353331
  Master clocks: 15125852
  Time:             0.704 s
  Speed:           75.484 KB/s
```
## calgary/paper3
```
LZ4: 22777 -> 46526 bytes (2.043x)
  CPU cycles:     1035970
  Master clocks:  6835046
  Time:             0.318 s
  Speed:          146.195 KB/s

LZSA1: 21787 -> 46526 bytes (2.135x)
  CPU cycles:     1050967
  Master clocks:  6934908
  Time:             0.323 s
  Speed:          144.090 KB/s

LZSA2: 19874 -> 46526 bytes (2.341x)
  CPU cycles:     1483696
  Master clocks:  9593252
  Time:             0.447 s
  Speed:          104.162 KB/s

ZX0: 19656 -> 46526 bytes (2.367x)
  CPU cycles:     2316672
  Master clocks: 14866858
  Time:             0.692 s
  Speed:           67.213 KB/s
```
## calgary/paper4
```
LZ4: 7451 -> 13286 bytes (1.783x)
  CPU cycles:      278370
  Master clocks:  1849196
  Time:             0.086 s
  Speed:          154.309 KB/s

LZSA1: 6952 -> 13286 bytes (1.911x)
  CPU cycles:      300514
  Master clocks:  1991446
  Time:             0.093 s
  Speed:          143.286 KB/s

LZSA2: 6222 -> 13286 bytes (2.135x)
  CPU cycles:      451687
  Master clocks:  2919826
  Time:             0.136 s
  Speed:           97.727 KB/s

ZX0: 5873 -> 13286 bytes (2.262x)
  CPU cycles:      675100
  Master clocks:  4345118
  Time:             0.202 s
  Speed:           65.671 KB/s
```
## calgary/paper5
```
LZ4: 6718 -> 11954 bytes (1.779x)
  CPU cycles:      250036
  Master clocks:  1661810
  Time:             0.077 s
  Speed:          154.494 KB/s

LZSA1: 6224 -> 11954 bytes (1.921x)
  CPU cycles:      267960
  Master clocks:  1776626
  Time:             0.083 s
  Speed:          144.509 KB/s

LZSA2: 5581 -> 11954 bytes (2.142x)
  CPU cycles:      399616
  Master clocks:  2585144
  Time:             0.120 s
  Speed:           99.313 KB/s

ZX0: 5265 -> 11954 bytes (2.270x)
  CPU cycles:      593950
  Master clocks:  3826278
  Time:             0.178 s
  Speed:           67.099 KB/s
```
## calgary/paper6
```
LZ4: 17022 -> 38105 bytes (2.239x)
  CPU cycles:      772814
  Master clocks:  5113082
  Time:             0.238 s
  Speed:          160.058 KB/s

LZSA1: 15889 -> 38105 bytes (2.398x)
  CPU cycles:      794646
  Master clocks:  5253972
  Time:             0.245 s
  Speed:          155.766 KB/s

LZSA2: 14464 -> 38105 bytes (2.634x)
  CPU cycles:     1112108
  Master clocks:  7204812
  Time:             0.335 s
  Speed:          113.590 KB/s

ZX0: 14022 -> 38105 bytes (2.718x)
  CPU cycles:     1662302
  Master clocks: 10696790
  Time:             0.498 s
  Speed:           76.508 KB/s
```
## calgary/progc
```
LZ4: 17159 -> 39611 bytes (2.308x)
  CPU cycles:      786113
  Master clocks:  5203554
  Time:             0.242 s
  Speed:          163.491 KB/s

LZSA1: 15865 -> 39611 bytes (2.497x)
  CPU cycles:      804527
  Master clocks:  5320554
  Time:             0.248 s
  Speed:          159.896 KB/s

LZSA2: 14492 -> 39611 bytes (2.733x)
  CPU cycles:     1120409
  Master clocks:  7264618
  Time:             0.338 s
  Speed:          117.107 KB/s

ZX0: 14093 -> 39611 bytes (2.811x)
  CPU cycles:     1660528
  Master clocks: 10692896
  Time:             0.498 s
  Speed:           79.561 KB/s
```
## calgary/progp
```
LZ4: 14233 -> 49379 bytes (3.469x)
  CPU cycles:      784600
  Master clocks:  5205962
  Time:             0.242 s
  Speed:          203.714 KB/s

LZSA1: 12906 -> 49379 bytes (3.826x)
  CPU cycles:      803111
  Master clocks:  5321706
  Time:             0.248 s
  Speed:          199.283 KB/s

LZSA2: 11899 -> 49379 bytes (4.150x)
  CPU cycles:     1079410
  Master clocks:  7029666
  Time:             0.327 s
  Speed:          150.864 KB/s

ZX0: 11561 -> 49379 bytes (4.271x)
  CPU cycles:     1480161
  Master clocks:  9570042
  Time:             0.446 s
  Speed:          110.817 KB/s
```
## canterbury/cp.html
```
LZ4: 10290 -> 24603 bytes (2.391x)
  CPU cycles:      401851
  Master clocks:  2686134
  Time:             0.125 s
  Speed:          196.716 KB/s

LZSA1: 9803 -> 24603 bytes (2.510x)
  CPU cycles:      434010
  Master clocks:  2889214
  Time:             0.135 s
  Speed:          182.889 KB/s

LZSA2: 9007 -> 24603 bytes (2.732x)
  CPU cycles:      651410
  Master clocks:  4231202
  Time:             0.197 s
  Speed:          124.883 KB/s

ZX0: 8567 -> 24603 bytes (2.872x)
  CPU cycles:      979953
  Master clocks:  6321270
  Time:             0.294 s
  Speed:           83.592 KB/s
```
## canterbury/fields.c
```
LZ4: 4204 -> 11150 bytes (2.652x)
  CPU cycles:      195143
  Master clocks:  1295284
  Time:             0.060 s
  Speed:          184.880 KB/s

LZSA1: 3755 -> 11150 bytes (2.969x)
  CPU cycles:      200794
  Master clocks:  1330530
  Time:             0.062 s
  Speed:          179.982 KB/s

LZSA2: 3436 -> 11150 bytes (3.245x)
  CPU cycles:      281140
  Master clocks:  1828964
  Time:             0.085 s
  Speed:          130.933 KB/s

ZX0: 3214 -> 11150 bytes (3.469x)
  CPU cycles:      383640
  Master clocks:  2479710
  Time:             0.115 s
  Speed:           96.572 KB/s
```
## canterbury/grammar.lsp
```
LZ4: 1720 -> 3721 bytes (2.163x)
  CPU cycles:       63428
  Master clocks:   423714
  Time:             0.020 s
  Speed:          188.611 KB/s

LZSA1: 1518 -> 3721 bytes (2.451x)
  CPU cycles:       67537
  Master clocks:   449824
  Time:             0.021 s
  Speed:          177.663 KB/s

LZSA2: 1403 -> 3721 bytes (2.652x)
  CPU cycles:      101881
  Master clocks:   662892
  Time:             0.031 s
  Speed:          120.558 KB/s

ZX0: 1304 -> 3721 bytes (2.854x)
  CPU cycles:      142962
  Master clocks:   925570
  Time:             0.043 s
  Speed:           86.343 KB/s
```
## canterbury/sum
```
LZ4: 16291 -> 38240 bytes (2.347x)
  CPU cycles:      659164
  Master clocks:  4400564
  Time:             0.205 s
  Speed:          186.633 KB/s

LZSA1: 14362 -> 38240 bytes (2.663x)
  CPU cycles:      750240
  Master clocks:  4985208
  Time:             0.232 s
  Speed:          164.746 KB/s

LZSA2: 12017 -> 38240 bytes (3.182x)
  CPU cycles:      978170
  Master clocks:  6347634
  Time:             0.296 s
  Speed:          129.385 KB/s

ZX0: 11416 -> 38240 bytes (3.350x)
  CPU cycles:     1354418
  Master clocks:  8810148
  Time:             0.410 s
  Speed:           93.221 KB/s
```
## canterbury/xargs.1
```
LZ4: 2403 -> 4227 bytes (1.759x)
  CPU cycles:       77810
  Master clocks:   520380
  Time:             0.024 s
  Speed:          174.458 KB/s

LZSA1: 2210 -> 4227 bytes (1.913x)
  CPU cycles:       87587
  Master clocks:   582790
  Time:             0.027 s
  Speed:          155.776 KB/s

LZSA2: 1997 -> 4227 bytes (2.117x)
  CPU cycles:      134847
  Master clocks:   874166
  Time:             0.041 s
  Speed:          103.853 KB/s

ZX0: 1842 -> 4227 bytes (2.295x)
  CPU cycles:      199501
  Master clocks:  1288322
  Time:             0.060 s
  Speed:           70.467 KB/s
```
## map1.bin
```
LZ4: 1117 -> 8192 bytes (7.334x)
  CPU cycles:       95652
  Master clocks:   637586
  Time:             0.030 s
  Speed:          275.950 KB/s

LZSA1: 991 -> 8192 bytes (8.266x)
  CPU cycles:       92510
  Master clocks:   616502
  Time:             0.029 s
  Speed:          285.387 KB/s

LZSA2: 958 -> 8192 bytes (8.551x)
  CPU cycles:      114977
  Master clocks:   758744
  Time:             0.035 s
  Speed:          231.886 KB/s

ZX0: 836 -> 8192 bytes (9.799x)
  CPU cycles:      143697
  Master clocks:   938634
  Time:             0.044 s
  Speed:          187.445 KB/s
```
## tile1.bin
```
LZ4: 434 -> 2048 bytes (4.719x)
  CPU cycles:       15794
  Master clocks:   108886
  Time:             0.005 s
  Speed:          403.959 KB/s

LZSA1: 422 -> 2048 bytes (4.853x)
  CPU cycles:       15875
  Master clocks:   109312
  Time:             0.005 s
  Speed:          402.384 KB/s

LZSA2: 411 -> 2048 bytes (4.983x)
  CPU cycles:       18442
  Master clocks:   125682
  Time:             0.006 s
  Speed:          349.974 KB/s

ZX0: 397 -> 2048 bytes (5.159x)
  CPU cycles:       24301
  Master clocks:   162818
  Time:             0.008 s
  Speed:          270.151 KB/s
```
## tile2.bin
```
LZ4: 1425 -> 4096 bytes (2.874x)
  CPU cycles:       42644
  Master clocks:   291594
  Time:             0.014 s
  Speed:          301.690 KB/s

LZSA1: 1331 -> 4096 bytes (3.077x)
  CPU cycles:       44826
  Master clocks:   305308
  Time:             0.014 s
  Speed:          288.138 KB/s

LZSA2: 1263 -> 4096 bytes (3.243x)
  CPU cycles:       62494
  Master clocks:   416388
  Time:             0.019 s
  Speed:          211.271 KB/s

ZX0: 1171 -> 4096 bytes (3.498x)
  CPU cycles:      100889
  Master clocks:   663314
  Time:             0.031 s
  Speed:          132.623 KB/s
```
## tile3.bin
```
LZ4: 3537 -> 8192 bytes (2.316x)
  CPU cycles:       87598
  Master clocks:   601484
  Time:             0.028 s
  Speed:          292.513 KB/s

LZSA1: 3419 -> 8192 bytes (2.396x)
  CPU cycles:       94334
  Master clocks:   643888
  Time:             0.030 s
  Speed:          273.249 KB/s

LZSA2: 3200 -> 8192 bytes (2.560x)
  CPU cycles:      140391
  Master clocks:   932520
  Time:             0.043 s
  Speed:          188.673 KB/s

ZX0: 3046 -> 8192 bytes (2.689x)
  CPU cycles:      229099
  Master clocks:  1500244
  Time:             0.070 s
  Speed:          117.275 KB/s
```
## tile4.bin
```
LZ4: 3852 -> 8192 bytes (2.127x)
  CPU cycles:       70188
  Master clocks:   492106
  Time:             0.023 s
  Speed:          357.528 KB/s

LZSA1: 3742 -> 8192 bytes (2.189x)
  CPU cycles:       75402
  Master clocks:   524856
  Time:             0.024 s
  Speed:          335.219 KB/s

LZSA2: 3516 -> 8192 bytes (2.330x)
  CPU cycles:      136577
  Master clocks:   910112
  Time:             0.042 s
  Speed:          193.319 KB/s

ZX0: 3393 -> 8192 bytes (2.414x)
  CPU cycles:      222732
  Master clocks:  1463188
  Time:             0.068 s
  Speed:          120.246 KB/s
```
## vram1.bin
```
LZ4: 3972 -> 9312 bytes (2.344x)
  CPU cycles:      154227
  Master clocks:  1031154
  Time:             0.048 s
  Speed:          193.954 KB/s

LZSA1: 3630 -> 9312 bytes (2.565x)
  CPU cycles:      164571
  Master clocks:  1097002
  Time:             0.051 s
  Speed:          182.312 KB/s

LZSA2: 3369 -> 9312 bytes (2.764x)
  CPU cycles:      235478
  Master clocks:  1537000
  Time:             0.072 s
  Speed:          130.121 KB/s

ZX0: 3121 -> 9312 bytes (2.984x)
  CPU cycles:      340929
  Master clocks:  2212936
  Time:             0.103 s
  Speed:           90.376 KB/s
```
## abam.txt
```
LZ4: 29987 -> 64115 bytes (2.138x)
  CPU cycles:     1452293
  Master clocks:  9563618
  Time:             0.445 s
  Speed:          143.985 KB/s

LZSA1: 28725 -> 64115 bytes (2.232x)
  CPU cycles:     1441910
  Master clocks:  9505308
  Time:             0.443 s
  Speed:          144.868 KB/s

LZSA2: 26582 -> 64115 bytes (2.412x)
  CPU cycles:     1997392
  Master clocks: 12917854
  Time:             0.601 s
  Speed:          106.598 KB/s

ZX0: 26776 -> 64115 bytes (2.394x)
  CPU cycles:     3199008
  Master clocks: 20514878
  Time:             0.955 s
  Speed:           67.123 KB/s
```
## 2889.txt
```
LZ4: 17963 -> 32893 bytes (1.831x)
  CPU cycles:      776969
  Master clocks:  5127582
  Time:             0.239 s
  Speed:          137.775 KB/s

LZSA1: 17214 -> 32893 bytes (1.911x)
  CPU cycles:      791642
  Master clocks:  5225490
  Time:             0.243 s
  Speed:          135.193 KB/s

LZSA2: 15450 -> 32893 bytes (2.129x)
  CPU cycles:     1136840
  Master clocks:  7339782
  Time:             0.342 s
  Speed:           96.250 KB/s

ZX0: 15115 -> 32893 bytes (2.176x)
  CPU cycles:     1780785
  Master clocks: 11424154
  Time:             0.532 s
  Speed:           61.838 KB/s
```
