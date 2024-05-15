; SHVC-LZ4
; David Lindecrantz <optiroc@me.com>
;
; LZ4 decompressor for Super Famicom/Nintendo
;
; Code size
;   Base: 182 bytes
;   LZ4_OPT_MAPMODE=1 adds 1 byte
;   LZ4_OPT_RETLEN=1 adds 11 bytes
;
; Decompression speed (KB/s)
;   Mean      Median    Min       Max
;   205.236   183.023   133.517   402.392

.p816
.smart -
.feature c_comments

.export LZ4_Decompress, LZ4_Length

LZ4_OPT_MAPMODE = 0 ; Set to 1 if code will be linked in bank without RAM/MMIO in lower half
LZ4_OPT_RETLEN  = 1 ; Set to 1 to enable decompressed length in X on return

LZ4_Length      = $4370 ; Decompressed size
LZ4_token       = $4372 ; 1 Current token
LZ4_match       = $4373 ; 2 Offset
LZ4_mvn         = $4375 ; 4 Block move (mvn + banks + return)
LZ4_tmp         = $4379 ; 2 Temporary storage

LZ4_dma_p       = $4360 ; Literal DMA parameters
LZ4_dma_bba     = $4361 ; Literal DMA B-bus address
LZ4_dma_src     = $4362 ; Literal DMA source
LZ4_dma_len     = $4365 ; Literal DMA length

MDMAEN          = $80420b ; DMA enable
WMDATA          = $802180 ; WRAM data port
WMADD           = $802181 ; WRAM address

.macro ReadByte
    lda a:0,x
    inx
.endmacro

.macro ReadWord
    lda a:0,x
    inx
    inx
.endmacro

; Decompress LZ4 block
;
; In (a8i16):
;   x           Source offset
;   y           Destination offset
;   b:a         Destination:Source banks
;   LZ4_Length  Size of compressed data
; Out (a8i16):
;   x           Decompressed length
LZ4_Decompress:
.if LZ4_OPT_MAPMODE = 0
    .assert ($40 & ^LZ4_Decompress = 0), error, "LZ4_OPT_MAPMODE=0 but code is linked in bank 0x40-0x7D/0xC0-0xFF"
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
    lda #$4300              ; Set direct page at CPU MMIO area
    tcd
    txa                     ; Calculate end offset
    clc
    adc <LZ4_Length
    sta <LZ4_Length
    pla
    sep #$20
    .a8

.if LZ4_OPT_RETLEN = 1
    phy                     ; Push destination offset for decompressed length calculation
.endif

    sta <LZ4_dma_src+2      ; Source bank -> WRAM data port address
    xba

    sta f:WMADD+2           ; Destination bank -> WRAM data port address, match block move
    sta <LZ4_mvn+1
    sta <LZ4_mvn+2

    lda #$54                ; Write MVN and return instructions
    sta <LZ4_mvn
.if LZ4_OPT_MAPMODE = 0
    lda #$60                ; RTS
.else
    lda #$6b                ; RTL
.endif
    sta <LZ4_mvn+$03

    stz <LZ4_dma_p          ; Set literal copy DMA parameters: CPU->MMIO, auto increment
    lda #<WMDATA
    sta <LZ4_dma_bba

;
; Get next token from compressed stream
;
ReadToken:
    ReadByte
    sta <LZ4_token

;
; Decode literal length
;
DecodeLitLen:
    and #$f0
    beq DecodeMatchOffset
    lsr
    lsr
    lsr
    lsr
    cmp #$0f
    bne @ShortLitLen
    pea CopyLiteral-1
    bra AddLength
@ShortLitLen:
    rep #$20
    .a16
    and #$00ff

;
; Copy literal via DMA (CPU bus -> WMDATA)
;
; Length in A, offset in Y, C=0
;
CopyLiteral:
    .a16
    sta <LZ4_dma_len        ; Set DMA parameters
    stx <LZ4_dma_src
    tya
    sta f:WMADD

    adc <LZ4_dma_len        ; Increment destination offset
    tay

    sep #$20
    .a8
    lda #(1 << 6)
    sta f:MDMAEN
    ldx <LZ4_dma_src

;
; Decode match offset
;
DecodeMatchOffset:
    rep #$20
    .a16
    ReadWord
    cpx <LZ4_Length
    beq Done
    sta <LZ4_match

;
; Decode match length
;
DecodeMatchLen:
    sep #$20
    .a8
    lda <LZ4_token
    and #$0f
    cmp #$0f
    bne @ShortMatchLen
    pea CopyMatch-1
    bra AddLength

@ShortMatchLen:
    rep #$20
    .a16
    and #$00ff

;
; Copy match via block move
;
; Length in A
; Source offset in LZ4_match
;
CopyMatch:
    .a16
    inc
    inc
    inc
    phx                     ; Save stream offset
    pha                     ; Save length

    tya                     ; Match offset -> X
    sec
    sbc <LZ4_match
    tax

    pla                     ; Restore length -> A
    phb
.if LZ4_OPT_MAPMODE = 0
    jsr .loword(LZ4_mvn)
.else
    jsl LZ4_mvn
.endif
    plb

    plx                     ; Restore source offset
    sep #$20
    bra ReadToken

;
; Decoding done
;
Done:
    .a8
.if LZ4_OPT_RETLEN = 1
    rep #$20
    sec
    tya
    sbc 1,s                 ; Start offset on stack
    plx                     ; Unwind
    tax
    sep #$20
.endif
    plb                     ; Restore DP and DB
    pld
    rtl

;
; Add length bytes from stream to A
;
AddLength:
    rep #$20
    .a16
    and #$00ff
    pha                     ; Accumulated length at s+1
:   ReadByte                ; Read next length byte
    sta <LZ4_tmp

    and #$00ff              ; Add to length
    clc                     ; Carry is guaranteed to be set
    adc 1,s
    sta 1,s

    sep #$20                ; Check end condition
    .a8
    inc <LZ4_tmp
    rep #$20
    .a16
    beq :-

    pla                     ; Pull summed length, C=0
    rts

LZ4_Decompress_END:
