; SHVC-LZSA2
; David Lindecrantz <optiroc@me.com>
;
; LZSA2 example usage

.p816
.smart -
.feature c_comments

.autoimport
.export Main

Main:
:   wai             ; Wait indefinitely
    bra :-          ; (only wake up in NMI)
