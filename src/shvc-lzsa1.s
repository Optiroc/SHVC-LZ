; SHVC-LZSA1
; David Lindecrantz <optiroc@me.com>
;
; LZSA1 decompressor for Super Famicom/Nintendo
;
; Code size:
;   Smallest: 211 bytes
;   Return value adds 6 bytes

.p816
.smart -
.feature c_comments

LZSA1_OPT_MAPMODE = 1 ; 0 = Code linked at bank with mode 20 type mapping, 1 = mode 21 type mapping
LZSA1_OPT_RETLEN = 1 ; 1 = Return decompressed length in X (adds 7 bytes to code size)

.export LZSA1_DecompressBlock

LZSA1_token     = $804370 ; 1 Current token
LZSA1_match     = $804371 ; 2 Match offset
LZSA1_mvn       = $804373 ; 4 Match block move (mvn + banks + return)
LZSA1_tmp       = $804377 ; 3 Temporary storage

LZSA1_dma_p     = $804360 ; Literal DMA parameters
LZSA1_dma_bba   = $804361 ; Literal DMA B-bus address
LZSA1_dma_src   = $804362 ; Literal DMA source
LZSA1_dma_len   = $804365 ; Literal DMA length

MDMAEN          = $80420b ; DMA enable
WMDATA          = $802180 ; WRAM data port
WMADD           = $802181 ; WRAM address

.macro readByte
    lda a:0,x
    inx
.endmacro

; Decompress LZSA1 block
;
; In (a8i16):
;   x           Source offset
;   y           Destination offset
;   b:a         Destination:Source banks
; Out (a8i16):
;   x           Decompressed length
LZSA1_DecompressBlock:
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

.if LZSA1_OPT_RETLEN = 1
    phy                     ; Push destination offset for decompressed length calculation
.endif

    sta <LZSA1_dma_src+2    ; Source bank -> WRAM data port address
    xba

    sta f:WMADD+2           ; Destination bank -> WRAM data port address, match block move
    sta <LZSA1_mvn+1
    sta <LZSA1_mvn+2

    lda #$54                ; Write MVN and return instructions
    sta <LZSA1_mvn
    lda #$6b                ; $60 = RTS, $6b = RTL
    sta <LZSA1_mvn+$03

    stz <LZSA1_dma_p        ; Set literal copy DMA parameters: CPU->MMIO, auto increment
    lda #<WMDATA
    sta <LZSA1_dma_bba

;
; Get next token from compressed stream
;
ReadToken:
    readByte
    sta <LZSA1_token

;
; Decode literal length
;
DecodeLitLen:
    and #%01110000          ; Mask literal length
    beq DecodeMatchOffset   ; No literal
    lsr
    lsr
    lsr
    lsr
    cmp #%00000111
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
; Length in A
; Offset in X
;
CopyLiteral:
    .a16
    sta <LZSA1_dma_len      ; Set DMA parameters
    stx <LZSA1_dma_src

    sty <LZSA1_tmp          ; Increment destination offset
    clc
    adc <LZSA1_tmp
    tay

    sep #$20
    .a8
    lda #(1 << 6)
    sta f:MDMAEN
    ldx <LZSA1_dma_src

;
; Decode match offset
;
DecodeMatchOffset:
    .a8
    readByte
    sta <LZSA1_match
    lda #$ff
    bit <LZSA1_token
    bpl @ByteOffset
@WordOffset:
    readByte
@ByteOffset:
    sta <LZSA1_match+1

;
; Decode match length
;
DecodeMatchLen:
    .a8
    lda <LZSA1_token
    and #%00001111          ; Mask match length
    clc
    adc #3
    cmp #18
    bcc @ShortMatchLen
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
; Source offset in LZSA1_match
;
CopyMatch:
    .a16
    dec
    phx                     ; Save stream offset
    pha                     ; Save length

    tya                     ; Match offset -> X
    clc
    adc <LZSA1_match
    tax

    pla                     ; Restore length -> A
    phb
    jsl LZSA1_mvn
    plb

    plx                     ; Restore source offset
    tya
    sta f:WMADD

    sep #$20
    bra ReadToken

;
; Add length bytes from stream to A
;   Enter: C = 1, a8i16
;   Return: a16i16
;
AddLength:
    .a8
    pha
    readByte                ; Read next length byte
    clc
    adc 1,s
    sta 1,s
    pla
    rep #$20
    .a16
    bcs @WordLen
@ByteLen:                   ; Single byte length
    and #$00ff
    rts
@WordLen:                   ; Two or three bytes
    beq :+
    readByte                ; Two
    and #$00ff
    adc #$ff
    rts
:   lda a:0,x               ; Three
    beq @Done
    inx
    inx
    rts
@Done:
    rep #$20
    .a16
    pla                     ; Unwind return address
.if LZSA1_OPT_RETLEN = 1
    tya                     ; End offset in y
    sec
    sbc 1,s                 ; Start offset on stack
    plx                     ; Unwind
    tax
.endif
    sep #$20
    .a8
    plb                     ; Restore DP and DB
    pld
    rtl

LZSA1_DecompressBlock_END: