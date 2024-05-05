; SHVC-ZX0
; David Lindecrantz <optiroc@me.com>
;
; ZX0 decompressor for Super Famicom/Nintendo
;
; Code size
;   Base: 185 bytes
;   ZX0_OPT_MAPMODE=1 adds 1 byte
;   ZX0_OPT_RETLEN=1 adds 10 bytes
;   ZX0_OPT_INLINE=1 adds 29 bytes
;
; Decompression speed (KB/s)
; ZX0_OPT_INLINE=1
;   Mean      Median    Min       Max
;   97.231    80.881    59.540    266.756
; ZX0_OPT_INLINE=0
;   Mean      Median    Min       Max
;   94.704    78.322    57.422    261.990

.p816
.smart -
.feature c_comments

.export ZX0_Decompress

ZX0_OPT_MAPMODE = 0 ; Set to 1 if code will be linked in bank without RAM/MMIO in lower half
ZX0_OPT_RETLEN  = 1 ; Set to 1 to enable decompressed length in X on return
ZX0_OPT_INLINE  = 1 ; Set to 1 to enable code inlining

ZX0_length      = $4370 ; 2 Length
ZX0_offset      = $4372 ; 2 Offset
ZX0_mvn         = $4374 ; 4 Block move (mvn + banks + return)
ZX0_tmp         = $4378 ; 2 Temporary storage

ZX0_dma_p       = $4360 ; Literal DMA parameters
ZX0_dma_bba     = $4361 ; Literal DMA B-bus address
ZX0_dma_src     = $4362 ; Literal DMA source
ZX0_dma_len     = $4365 ; Literal DMA length

MDMAEN          = $80420b ; DMA enable
WMDATA          = $802180 ; WRAM data port
WMADD           = $802181 ; WRAM address

.macro ReadByte
    lda a:0,x
    inx
.endmacro

; Decompress ZX0 block
;
; In (a8i16):
;   x           Source offset
;   y           Destination offset
;   b:a         Destination:Source banks
; Out (a8i16):
;   x           Decompressed length
ZX0_Decompress:
.if ZX0_OPT_MAPMODE = 0
    .assert ($40 & ^ZX0_Decompress = 0), error, "ZX0_OPT_MAPMODE=0 but code is linked in bank 0x40-0x7D/0xC0-0xFF"
.endif

    .a8
    .i16

Setup:
    phd                     ; Save DP and DB
    phb
    pha                     ; Source bank -> DB
    plb

    rep #$20
    .a16
    pha
    tya
    sta f:WMADD             ; Destination offset -> WRAM data port address
    lda #$4300              ; Set direct page at CPU MMIO area
    tcd
    pla
    stz <ZX0_offset         ; Set initial offset
    dec <ZX0_offset
    sep #$20
    .a8

.if ZX0_OPT_RETLEN = 1
    phy                     ; Push destination offset for decompressed length calculation
.endif

    sta <ZX0_dma_src+2      ; Source bank -> WRAM data port address
    xba

    sta f:WMADD+2           ; Destination bank -> WRAM data port address and block move
    sta <ZX0_mvn+1
    sta <ZX0_mvn+2

    lda #$54                ; Write MVN and return instructions
    sta <ZX0_mvn
.if ZX0_OPT_MAPMODE = 0
    lda #$60                ; RTS
.else
    lda #$6b                ; RTL
.endif
    sta <ZX0_mvn+$03

    stz <ZX0_dma_p          ; Set literal copy DMA parameters: CPU->MMIO, auto increment
    lda #$80                ; WMDATA and initialized empty bit buffer
    sta <ZX0_dma_bba

;
; Decode literal
;
DecodeLiteral:
    .a8
    jsr DecodeGammaLength

;
; Copy literal via DMA (CPU bus -> WMDATA)
;
; Length in ZX0_length
;
CopyLiteral:
    .a8
    pha                     ; Save bit buffer
    rep #$20
    .a16
    lda <ZX0_length
    sta <ZX0_dma_len        ; Set DMA parameters
    stx <ZX0_dma_src

    sty <ZX0_tmp            ; Increment destination offset
    clc
    adc <ZX0_tmp
    tay

    sep #$20
    .a8
    lda #(1 << 6)
    sta f:MDMAEN
    ldx <ZX0_dma_src        ; Read new source offset
    pla                     ; Restore bit buffer

    asl                     ; Type 0 or 1 match?
    bcs DecodeMatchNew

;
; Decode match with current offset
;
DecodeMatchReuse:
    .a8
    jsr DecodeGammaLength
    pha                     ; Save bit buffer
    rep #$20
    .a16
    dec <ZX0_length
    bra CopyMatch

;
; Decode match with new offset
;
DecodeMatchNew:
    .a8
    stz <ZX0_length
    dec <ZX0_length
    dec <ZX0_length
    jsr DecodeGamma         ; Get offset MSB
    pha                     ; Save bit buffer
    lda <ZX0_length
    inc
    beq Done
    xba
    ReadByte
    rep #$20
    .a16
    ror                     ; Shift offset, LSb into C
    sta <ZX0_offset
    stz <ZX0_length
    inc <ZX0_length
    sep #$20
    .a8
    pla                     ; Restore bit buffer
    jsr GammaCheckBit       ; Get match length (first N-bit in C)
    pha                     ; Save bit buffer
    rep #$20

;
; Copy match via block move
;
; Length in ZX0_length
; Source offset in ZX0_offset
;
CopyMatch:
    .a16
    phx                     ; Save stream offset
    tya                     ; Match offset -> X
    clc
    adc <ZX0_offset
    tax
    lda <ZX0_length         ; Length -> A

    phb
.if ZX0_OPT_MAPMODE = 0
    jsr .loword(ZX0_mvn)
.else
    jsl ZX0_mvn
.endif
    plb

    plx                     ; Restore source offset
    tya
    sta f:WMADD

    sep #$20
    .a8
    pla                     ; Restore bit buffer
    asl                     ; New match or literal?
    bcs DecodeMatchNew
    bra DecodeLiteral

;
; Decode next Elias gamma number
;   a           Current bit buffer
; Out:
;   a           Current bit buffer
;   ZX0_length  Number-1
;
DecodeGammaLength:
    .a8
    stz <ZX0_length
    stz <ZX0_length+1
    inc <ZX0_length
DecodeGamma:
    asl                     ; Get next bit
    beq GammaFillBuffer
GammaCheckBit:              ; Check N-bit
    bcs GammaDone
GammaAddBit:                ; N-bit 0: Shift in next bit
    asl
    rol <ZX0_length
    rol <ZX0_length+1
.if ZX0_OPT_INLINE = 0
    bra DecodeGamma
.else
    asl                     ; Get next bit
    beq GammaFillBuffer
    bcs GammaDone
    asl
    rol <ZX0_length
    rol <ZX0_length+1
    asl                     ; Get next bit
    beq GammaFillBuffer
    bcs GammaDone
    asl
    rol <ZX0_length
    rol <ZX0_length+1
    asl                     ; Get next bit
    beq GammaFillBuffer
    bcs GammaDone
    asl
    rol <ZX0_length
    rol <ZX0_length+1
    asl                     ; Last bit, fall through
.endif
GammaFillBuffer:
    ReadByte                ; C=1 (previous end marker shifted out)
    rol                     ; Shift out first bit, shift in new end marker
    bcc GammaAddBit
GammaDone:
    rts                     ; N-bit 1: Done

;
; Decoding done
;
Done:
    .a8
    pla                     ; Unwind bit buffer
.if ZX0_OPT_RETLEN = 1
    rep #$20
    .a16
    tya                     ; End offset in y
    sbc 1,s                 ; Start offset on stack (C=1)
    plx                     ; Unwind start offset
    tax                     ; Result -> X
    sep #$20
    .a8
.endif
    plb                     ; Restore DP and DB
    pld
    rtl

ZX0_Decompress_END:
