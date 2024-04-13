; SHVC-CPU
; David Lindecrantz <optiroc@me.com>
;
; CPU macros

.ifndef ::__SHVC_CPU__
::__SHVC_CPU__ = 1

.p816
.smart -
.feature c_comments

/*
 * CPU register widths
 */

.macro a8
    sep #$20
    .a8
.endmacro

.macro i8
    sep #$10
    .i8
.endmacro

.macro a8i8
    sep #$30
    .a8
    .i8
.endmacro

.macro a16
    rep #$20
    .a16
.endmacro

.macro i16
    rep #$10
    .i16
.endmacro

.macro a16i16
    rep #$30
    .a16
    .i16
.endmacro

/*
 * Pseudo instructions
 */

; Branch if greater than
.macro bgt addr
    beq :+
    bge addr
:
.endmac

; Push return address
.macro phr addr
    pea addr - 1
.endmac

; Relative subroutine call
.macro rsc addr
    per * + 4
    bra addr
.endmac

; Relative long subroutine call
.macro rcl addr
    per * + 5
    brl addr
.endmac

 ; Add (without carry)
.macro add op, ix
    .if .blank({ix})
        clc
        adc op
  .else
        clc
        adc op, ix
  .endif
.endmac

; Subtract (without carry)
.macro sub op, ix
    .if .blank({ix})
        sec
        sbc op
    .else
        sec
        sbc op, ix
  .endif
.endmac

.endif; __SHVC_CPU__
