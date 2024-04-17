; SHVC-LZ4
; David Lindecrantz <optiroc@me.com>
;
; LZ4 decompressor for Super Famicom/Nintendo
;
; Code size
;   Base: 183 bytes
;   LZ4_OPT_MAPMODE=1 adds 1 byte
;   LZ4_OPT_RETLEN=1 adds 11 bytes
;
; Decompression speed (KB/s)
;   Mean      Median    Min       Max
;   205.236   183.023   133.517   402.392

.p816
.smart -
.feature c_comments

.export LZ4_DecompressBlock, LZ4_Length, LZ4_Length_w

LZ4_OPT_MAPMODE = 0 ; Set to 1 if code will be linked in bank without RAM/MMIO in lower half
LZ4_OPT_RETLEN  = 1 ; Set to 1 to enable decompressed length in X on return

LZ4_Length      = $804370 ; Decompressed size
LZ4_Length_w    = $4370
LZ4_token       = $804372 ; 1 Current token
LZ4_match       = $804373 ; 2 Match offset
LZ4_mvn         = $804375 ; 4 Match block move (mvn + banks + return)
LZ4_tmp         = $804379 ; Temporary storage

LZ4_dma_p       = $804360 ; Literal DMA parameters
LZ4_dma_bba     = $804361 ; Literal DMA B-bus address
LZ4_dma_src     = $804362 ; Literal DMA source
LZ4_dma_len     = $804365 ; Literal DMA length

MDMAEN          = $80420b ; DMA enable
WMDATA          = $802180 ; WRAM data port
WMADD           = $802181 ; WRAM address

.macro readByte
    lda a:0,x
    inx
.endmacro

.macro readWord
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
LZ4_DecompressBlock:
.if LZ4_OPT_MAPMODE = 0
    .assert ($40 & ^LZ4_DecompressBlock = 0), error, "LZ4_OPT_MAPMODE=0 but code is linked in bank 0x40-0x7D/0xC0-0xFF"
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
    readByte
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

    sty <LZ4_tmp            ; Increment destination offset
    adc <LZ4_tmp
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
    readWord
    sta <LZ4_match
    cpx <LZ4_Length
    beq Done

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
    tya
    sta f:WMADD

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
:   readByte                ; Read next length byte
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

LZ4_DecompressBlock_END:
