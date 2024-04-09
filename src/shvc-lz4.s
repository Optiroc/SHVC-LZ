; SHVC-LZ4
; David Lindecrantz <optiroc@me.com>
;
; LZ4 decompressor for Super Famicom/Nintendo
; Code size: ? to ? bytes
; Decompression speed: ? KB/s

.p816
.smart -
.feature c_comments

LZ4_OPT_INLINE = 1 ; 1 = Inline functions (adds ? bytes to code size)
LZ4_OPT_MAPMODE = 1 ; 0 = Code linked at bank with mode 20 type mapping, 1 = mode 21 type mapping
LZ4_OPT_RETLEN = 1 ; 1 = Return decompressed length in X (adds ? bytes to code size)

.export LZ4_DecompressBlock

.define LZ4_token     $804370 ; 1 Current token
.define LZ4_nibble    $804371 ; 1 Current nibble
.define LZ4_nibrdy    $804372 ; 1 Nibble ready
.define LZ4_match     $804373 ; 2 Previous match offset
.define LZ4_mvn       $804375 ; 4 Match block move (mvn + banks + return)
.define LZ4_tmp       $804379 ; 3 Temporary storage

.define LZ4_dma_p     $804360 ; Literal DMA parameters
.define LZ4_dma_bba   $804361 ; Literal DMA B-bus address
.define LZ4_dma_src   $804362 ; Literal DMA source
.define LZ4_dma_len   $804365 ; Literal DMA length

.define MDMAEN        $80420b ; DMA enable
.define WMDATA        $802180 ; WRAM data port
.define WMADD         $802181 ; WRAM address

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
; Out (a8i16):
;   x           Decompressed length
LZ4_DecompressBlock:
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

    stz <LZ4_nibrdy         ; Init state

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
    lda #$6b                ; $60 = RTS, $6b = RTL
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
    and #%00011000          ; Mask literal type
    beq DecodeMatchOffset   ; No literal
    cmp #%00010000
    beq @LitLen2
    bpl @ExtLitLen

@LitLen1:                   ; Copy 1 literal
    readByte
    sta f:WMDATA
    iny
    bra DecodeMatchOffset

@LitLen2:                   ; Copy 2 literals
    readByte
    sta f:WMDATA
    readByte
    sta f:WMDATA
    iny
    iny
    bra DecodeMatchOffset

@ExtLitLen:
    phy
    ldy #0
    jsr GetExtLen
    ply

;
; Copy literal via DMA (CPU bus -> WMDATA)
;
; Length in A
; Offset in X
;
CopyLiteral:
    .a16
    sta <LZ4_dma_len      ; Set DMA parameters
    stx <LZ4_dma_src

    sty <LZ4_tmp          ; Increment destination offset
    clc
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
    .a8
    lda <LZ4_token
    asl                     ; Shift X to C
    bcs @LongMatchOffset
    asl                     ; Shift Y to C
    bcs @MatchOffset01Z

; 00Z 5-bit offset:
; - Read a nibble for offset bits 1-4 and use the inverted bit Z of the token as bit 0 of the offset.
; - Set bits 5-15 of the offset to 1.
@MatchOffset00Z:
    .a8
    asl                     ; Shift Z to C
    php
    ;readNibble
    plp
    rol                     ; Shift nibble, Z into bit 0
    eor #%11100001
    xba
    lda #$ff
    xba
    rep #$20
    bra DecodeMatchLen

; 01Z 9-bit offset:
; Read a byte for offset bits 0-7 and use the inverted bit Z for bit 8 of the offset.
; Set bits 9-15 of the offset to 1.
@MatchOffset01Z:
    .a8
    asl                     ; Shift Z to C
    php
    readByte
    xba
    plp
    lda #$00
    rol
    eor #$ff
    xba
    rep #$20
    bra DecodeMatchLen

@LongMatchOffset:
    .a8
    asl                     ; Shift Y to C, Z to N
    bcc @MatchOffset10Z
    bmi @MatchOffset111

; 110 16-bit offset:
; Read a byte for offset bits 8-15, then another byte for offset bits 0-7.
@MatchOffset110:
    rep #$20
    .a16
    readWord
    xba
    bra DecodeMatchLen

; 111 Repeat previous offset
@MatchOffset111:
    rep #$20
    .a16
    lda <LZ4_match
    bra DecodeMatchLen

; 10Z 13-bit offset:
; Read a nibble for offset bits 9-12 and use the inverted bit Z for bit 8 of the offset, then read a byte for offset bits 0-7.
; Set bits 13-15 of the offset to 1. Subtract 512 from the offset to get the final value.
@MatchOffset10Z:
    .a8
    asl                     ; Shift Z to C
    php
    ;readNibble
    plp
    rol                     ; Shift nibble, Z into bit 0, C = 0
    eor #%11100001
    dec
    dec
    xba
    readByte
    rep #$20
    .a16

;
; Decode match length
;
DecodeMatchLen:             ; Match offset in A
    .a16
    sta <LZ4_match        ; Store match offset
    sep #$20
    .a8
    lda <LZ4_token
    and #%00000111          ; Mask match length
    cmp #%00000111
    beq @ExtMatchLen

@TokenMatchLen:
    inc
    rep #$20
    .a16
    and #$0f
    bra CopyMatch

@ExtMatchLen:
    phy
    ldy #1
    jsr GetExtLen
    dec
    ply

;
; Copy match via block move
;
; Length in A
; Source offset in LZ4_match
;
CopyMatch:
    .a16
    phx                     ; Save stream offset
    pha                     ; Save length

    tya                     ; Match offset -> X
    clc
    adc <LZ4_match
    tax

    pla                     ; Restore length -> A
    phb
    jsl LZ4_mvn
    plb

    plx                     ; Restore source offset
    tya
    sta f:WMADD

    sep #$20
    jmp ReadToken

;
; Get extended length
;
; Length type in Y: 0 = Literal, 1 = Match
;
GetExtLen:
    .a8
    ;readNibble
    cmp #$0f
    bcs @LenByte

@LenNibble:
    adc NibbleLenAdd,y
@ByteReady:
    rep #$20
    .a16
    and #$00ff
    rts

@LenByte:
    readByte
    adc ByteLenAdd,y
    bcc @ByteReady
    beq @Done

@LenWord:
    rep #$20
    .a16
    readWord
    rts

@Done:
    rep #$20
    .a16
    pla                     ; Unwind pushed Y -> A
    pla
.if LZ4_OPT_RETLEN = 1
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

NibbleLenAdd:
    .byte 3, 9
ByteLenAdd:
    .byte 17, 23

LZ4_DecompressBlock_END:
