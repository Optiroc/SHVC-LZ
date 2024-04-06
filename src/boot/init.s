; SHVC-Base
; David Lindecrantz <optiroc@me.com>
;
; Shared init code

.include "shvc_cpu.inc"
.include "shvc_mmio.inc"

.p816
.smart -
.feature c_comments

.export ResetMMIO

ResetMMIO:
    php
    phd

    ; Initialize CPU MMIO
    a16i16
    lda #CPU_BASE
    tcd
    lda #$ff00
    sta z:NMITIMEN-CPU_BASE
    stz z:WRMPYA-CPU_BASE
    stz z:WRDIVL-CPU_BASE
    stz z:WRDIVH-CPU_BASE
    stz z:HTIMEL-CPU_BASE
    stz z:VTIMEL-CPU_BASE

    ; Initialize PPU MMIO
    lda #PPU_BASE
    tcd
    lda #$0080
    sta z:INIDISP-PPU_BASE
    stz z:OAMADDL-PPU_BASE
    stz z:BGMODE-PPU_BASE
    stz z:BG1SC-PPU_BASE
    stz z:BG3SC-PPU_BASE
    stz z:BG12NBA-PPU_BASE
    stz z:VMADDL-PPU_BASE
    stz z:W12SEL-PPU_BASE
    stz z:WH0-PPU_BASE
    stz z:WH2-PPU_BASE
    stz z:WBGLOG-PPU_BASE
    stz z:TM-PPU_BASE
    stz z:TMW-PPU_BASE

    a8i8
    sta z:VMAINC-PPU_BASE
    stz z:M7SEL-PPU_BASE
    stz z:CGADD-PPU_BASE
    stz z:WOBJSEL-PPU_BASE

    ; BG HOFS = #$000
    .repeat 4, i
        stz z:BG1HOFS-PPU_BASE+i*2
        stz z:BG1HOFS-PPU_BASE+i*2
    .endrepeat

    ; BG HOFS = #$7ff
    lda #$ff
    ldx #$07
    .repeat 4, i
        sta z:BG1VOFS-PPU_BASE+i*2
        stx z:BG1VOFS-PPU_BASE+i*2
    .endrepeat

    ; M7 matrix = [ 1 0 ] [ 0 1 ]
    lda #$01
    .repeat 4, i
        stz z:M7A-PPU_BASE+i
        sta z:M7A-PPU_BASE+i
    .endrepeat

    stz z:M7X-PPU_BASE
    stz z:M7X-PPU_BASE
    stz z:M7Y-PPU_BASE
    stz z:M7Y-PPU_BASE

    pld
    plp
    rts
