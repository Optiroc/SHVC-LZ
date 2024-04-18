; SHVC-LZSA2
; David Lindecrantz <optiroc@me.com>
;
; LZSA2 decompressor for Super Famicom/Nintendo
;
; Code size
;   Base: 298 bytes
;   LZSA2_OPT_MAPMODE=1 adds 1 byte
;   LZSA2_OPT_RETLEN=1 adds 6 bytes
;   LZSA2_OPT_INLINE=1 adds 58 bytes
;
; Decompression speed (KB/s)
; LZSA2_OPT_INLINE=1
;   Mean      Median    Min       Max
;   144.438   121.212   96.235    349.174
; LZSA2_OPT_INLINE=0
;   Mean      Median    Min       Max
;   135.225   111.927   89.145    340.540

.p816
.smart -
.feature c_comments

LZSA2_OPT_MAPMODE = 0 ; Set to 1 if code will be linked in bank without RAM/MMIO in lower half
LZSA2_OPT_RETLEN  = 1 ; Set to 1 to enable decompressed length in X on return (adds 6 bytes to code size)
LZSA2_OPT_INLINE  = 1 ; Set to 1 to enable code inlining (adds 58 bytes to code size)

.export LZSA2_Decompress

LZSA2_token     = $804370 ; 1 Current token
LZSA2_nibble    = $804371 ; 1 Current nibble
LZSA2_nibrdy    = $804372 ; 1 Nibble ready
LZSA2_match     = $804373 ; 2 Offset
LZSA2_mvn       = $804375 ; 4 Block move (mvn + banks + return)
LZSA2_tmp       = $804379 ; 3 Temporary storage

LZSA2_dma_p     = $804360 ; Literal DMA parameters
LZSA2_dma_bba   = $804361 ; Literal DMA B-bus address
LZSA2_dma_src   = $804362 ; Literal DMA source
LZSA2_dma_len   = $804365 ; Literal DMA length

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

.macro ReadNibble
.if LZSA2_OPT_INLINE = 1
    .a8
    lsr <LZSA2_nibrdy       ; Nibble ready?
    bcs :+
    inc <LZSA2_nibrdy       ; Flag nibble ready
    ReadByte                ; Load and store next nibble
    sta <LZSA2_nibble
    lsr
    lsr
    lsr
    lsr
    bra :++
:   lda <LZSA2_nibble
    and #$0f
:
.else
    jsr GetNibble
.endif
.endmacro


; Decompress LZSA2 block
;
; In (a8i16):
;   x           Source offset
;   y           Destination offset
;   b:a         Destination:Source banks
; Out (a8i16):
;   x           Decompressed length
LZSA2_Decompress:
.if LZSA2_OPT_MAPMODE = 0
    .assert ($40 & ^LZSA2_Decompress = 0), error, "LZSA2_OPT_MAPMODE=0 but code is linked in bank 0x40-0x7D/0xC0-0xFF"
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

    stz <LZSA2_nibrdy       ; Init state

.if LZSA2_OPT_RETLEN = 1
    phy                     ; Push destination offset for decompressed length calculation
.endif

    sta <LZSA2_dma_src+2    ; Source bank -> WRAM data port address
    xba

    sta f:WMADD+2           ; Destination bank -> WRAM data port address, match block move
    sta <LZSA2_mvn+1
    sta <LZSA2_mvn+2

    lda #$54                ; Write MVN and return instructions
    sta <LZSA2_mvn
.if LZSA2_OPT_MAPMODE = 0
    lda #$60                ; RTS
.else
    lda #$6b                ; RTL
.endif
    sta <LZSA2_mvn+$03

    stz <LZSA2_dma_p        ; Set literal copy DMA parameters: CPU->MMIO, auto increment
    lda #<WMDATA
    sta <LZSA2_dma_bba

;
; Get next token from compressed stream
;
ReadToken:
    ReadByte
    sta <LZSA2_token

;
; Decode literal length
;
DecodeLitLen:
    and #%00011000          ; Mask literal type
    beq DecodeMatchOffset   ; No literal
.if LZSA2_OPT_INLINE = 1
    cmp #%00010000
    beq @LitLen2
    bpl @ExtLitLen

@LitLen1:                   ; Copy 1 literal
    ReadByte
    sta f:WMDATA
    iny
    bra DecodeMatchOffset

@LitLen2:                   ; Copy 2 literals
    ReadByte
    sta f:WMDATA
    ReadByte
    sta f:WMDATA
    iny
    iny
    bra DecodeMatchOffset

@ExtLitLen:
    phy
    ldy #0
    jsr GetExtLen
    ply
.else
    ; LZSA2_OPT_INLINE = 0
    cmp #%00011000
    beq @ExtLitLen
@ShortLitLen:
    lsr
    lsr
    lsr
    rep #$20
    .a16
    and #$00ff
    bra CopyLiteral
@ExtLitLen:
    phy
    ldy #0
    jsr GetExtLen
    ply
.endif

;
; Copy literal via DMA (CPU bus -> WMDATA)
;
; Length in A, offset in X, C=0
;
CopyLiteral:
    .a16
    sta <LZSA2_dma_len      ; Set DMA parameters
    stx <LZSA2_dma_src

    sty <LZSA2_tmp          ; Increment destination offset
    adc <LZSA2_tmp
    tay

    sep #$20
    .a8
    lda #(1 << 6)
    sta f:MDMAEN
    ldx <LZSA2_dma_src

;
; Decode match offset
;
DecodeMatchOffset:
    .a8
    lda <LZSA2_token
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
    ReadNibble
    plp
    rol                     ; Shift nibble, Z to bit 0
    eor #%11100001
    xba
    lda #$ff
    xba
    bra DecodeMatchLen

; 01Z 9-bit offset:
; Read a byte for offset bits 0-7 and use the inverted bit Z for bit 8 of the offset.
; Set bits 9-15 of the offset to 1.
@MatchOffset01Z:
    .a8
    asl                     ; Shift Z to C
    php
    ReadByte
    xba
    plp
    lda #$00
    rol
    eor #$ff
    xba
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
    ReadWord
    xba
    bra DecodeMatchLen

; 111 Repeat previous offset
@MatchOffset111:
    rep #$20
    .a16
    lda <LZSA2_match
    bra DecodeMatchLen

; 10Z 13-bit offset:
; Read a nibble for offset bits 9-12 and use the inverted bit Z for bit 8 of the offset, then read a byte for offset bits 0-7.
; Set bits 13-15 of the offset to 1. Subtract 512 from the offset to get the final value.
@MatchOffset10Z:
    .a8
    asl                     ; Shift Z to C
    php
    ReadNibble
    plp
    rol                     ; Shift nibble, Z into bit 0, C = 0
    eor #%11100001
    dec
    dec
    xba
    ReadByte

;
; Decode match length
;
DecodeMatchLen:             ; Match offset in A
    rep #$20
    .a16
    sta <LZSA2_match        ; Store match offset
    sep #$20
    .a8
    lda <LZSA2_token
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
; Source offset in LZSA2_match
;
CopyMatch:
    .a16
    phx                     ; Save stream offset
    pha                     ; Save length

    tya                     ; Match offset -> X
    clc
    adc <LZSA2_match
    tax

    pla                     ; Restore length -> A
    phb
.if LZSA2_OPT_MAPMODE = 0
    jsr .loword(LZSA2_mvn)
.else
    jsl LZSA2_mvn
.endif
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
    ReadNibble
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
    ReadByte
    adc ByteLenAdd,y
    bcc @ByteReady
    beq @Done

@LenWord:
    rep #$20
    .a16
    ReadWord
    rts

@Done:
    rep #$20
    .a16
    pla                     ; Unwind pushed Y -> A
    pla
.if LZSA2_OPT_RETLEN = 1
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

.if LZSA2_OPT_INLINE = 0
GetNibble:
    .a8
    lsr <LZSA2_nibrdy       ; Nibble ready?
    bcs @NibbleReady
    inc <LZSA2_nibrdy       ; Flag nibble ready
    ReadByte                ; Load and store next nibble
    sta <LZSA2_nibble
    lsr
    lsr
    lsr
    lsr
    rts
@NibbleReady:
    lda <LZSA2_nibble
    and #$0f
    rts
.endif

LZSA2_Decompress_END:
