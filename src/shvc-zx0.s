; SHVC-ZX0
; David Lindecrantz <optiroc@me.com>
;
; ZX0 decompressor for Super Famicom/Nintendo
;
; Code size
;   Base: 190 bytes
;   ZX0_OPT_MAPMODE=1 adds 1 byte
;   ZX0_OPT_RETLEN=1 adds 8 bytes
;
; Decompression speed (KB/s)
;   Mean      Median    Min       Max
;   92.579    76.333    55.811    258.012

.p816
.smart -
.feature c_comments

.export ZX0_Decompress

ZX0_OPT_MAPMODE = 0 ; Set to 1 if code will be linked in bank without RAM/MMIO in lower half
ZX0_OPT_RETLEN  = 1 ; Set to 1 to enable decompressed length in X on return

ZX0_length      = $804370 ; 2 Length
ZX0_offset      = $804372 ; 2 Offset
ZX0_mvn         = $804374 ; 4 Block move (mvn + banks + return)
ZX0_tmp         = $804378 ; Temporary storage

ZX0_dma_p       = $804360 ; Literal DMA parameters
ZX0_dma_bba     = $804361 ; Literal DMA B-bus address
ZX0_dma_src     = $804362 ; Literal DMA source
ZX0_dma_len     = $804365 ; Literal DMA length

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

    sta f:WMADD+2           ; Destination bank -> WRAM data port address, match block move
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
    lda #<WMDATA
    sta <ZX0_dma_bba

    lda #%10000000          ; Initialize bit buffer (end marker at msb, 0 = first command)

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

;
; Type 0 or 1 match?
;
    ;jsr GetEliasBit
    asl
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

    rep #$20
    .a16
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

    asl                     ; Next command literal or match?
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
    bne GammaCheckBit
    ReadByte                ; Get new byte
    sec                     ; Shift out first bit, shift in end marker
    rol
GammaCheckBit:              ; Check N-bit
    bcc @AddBit
    rts                     ; N-bit 1: Done
@AddBit:                    ; N-bit 0: Shift in next bit
    asl
    rol <ZX0_length
    rol <ZX0_length+1
    bra DecodeGamma

Done:
    .a8
    pla                     ; Unwind bit buffer
.if ZX0_OPT_RETLEN = 1
    rep #$20
    .a16
    tya                     ; End offset in y
    sbc 1,s                 ; Start offset on stack (C=1)
    plx                     ; Unwind
    tax
.endif
    sep #$20
    .a8
    plb                     ; Restore DP and DB
    pld
    rtl

ZX0_Decompress_END:
