; SHVC-LZSA2
; David Lindecrantz <optiroc@me.com>
;
; LZSA2 decompressor: SNES specific fast variant
; Code size: xx bytes
; Decompression speed: 100-110 KB/s

.p816
.smart -
.feature c_comments

LZSA2_OPT_MAPMODE = 0 ; 0 = Code linked at bank with mode 20 type mapping
LZSA2_OPT_INLINE = 1 ; 1 = Inline functions

.export LZSA2_DecompressBlock

.define LZSA2_token     $804370 ; 1 Current token
.define LZSA2_nibble    $804371 ; 1 Current nibble
.define LZSA2_nibrdy    $804372 ; 1 Nibble ready
.define LZSA2_match     $804373 ; 2 Previous match offset
.define LZSA2_mvn       $804375 ; 4 Match block move (mvn + banks + return)
.define LZSA2_tmp       $804379 ; 3 Temporary variables

.define LZSA2_dma_p     $804360 ; Literal DMA parameters
.define LZSA2_dma_bba   $804361 ; Literal DMA B-bus address
.define LZSA2_dma_src   $804362 ; Literal DMA source
.define LZSA2_dma_len   $804365 ; Literal DMA length

.define MDMAEN          $80420b ; DMA enable
.define WMDATA          $802180 ; WRAM data port
.define WMADD           $802181 ; WRAM address

.macro readByte
    lda a:0,x
    inx
.endmacro

.macro readWord
    lda a:0,x
    inx
    inx
.endmacro

.macro readNibble
.if LZSA2_OPT_INLINE = 1
    .a8
    lsr <LZSA2_nibrdy       ; Nibble ready?
    bcs :+
    inc <LZSA2_nibrdy       ; Flag nibble ready
    readByte                ; Load and store next nibble
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
; Parameters (a8i16):
;   x           Source offset
;   y           Destination offset
;   b:a         Destination:Source banks
; Returns (a8i16):
;   x           Decompressed length
LZSA2_DecompressBlock:
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
    phy                     ; Push destination offset for decompressed length calculation

    sta <LZSA2_dma_src+2    ; Source bank -> WRAM data port address
    xba

    sta f:WMADD+2           ; Destination bank -> WRAM data port address, match block move
    sta <LZSA2_mvn+1
    sta <LZSA2_mvn+2

    lda #$54                ; Write MVN and return instructions
    sta <LZSA2_mvn
    lda #$6b                ; $60 = RTS, $6b = RTL
    sta <LZSA2_mvn+$03

    stz <LZSA2_dma_p        ; Set literal copy DMA parameters: CPU->MMIO, auto increment
    lda #<WMDATA
    sta <LZSA2_dma_bba

;
; Get next token from compressed stream
;
ReadToken:
    readByte
    sta <LZSA2_token

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
    readNibble
    cmp #$0f
    bne @LitLenNibble

    readByte                ; Long literal, read next byte
    cmp #$ef
    beq @LitLenWord

@LitLenByte:                ; Literal length: Byte + nibble value + 3
    clc
    adc #(15 + 3)
    rep #$20
    .a16
    and #$00ff
    bra CopyLiteral

@LitLenWord:                ; Literal length: Next word
    rep #$20
    .a16
    readWord
    bra CopyLiteral

@LitLenNibble:              ; Literal length: Nibble value + 3
    .a8
    clc
    adc #3
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
    sta <LZSA2_dma_len      ; Set DMA parameters
    stx <LZSA2_dma_src

    sty <LZSA2_tmp          ; Increment source offset
    clc
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
    readNibble
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
    lda <LZSA2_match
    bra DecodeMatchLen

; 10Z 13-bit offset:
; Read a nibble for offset bits 9-12 and use the inverted bit Z for bit 8 of the offset, then read a byte for offset bits 0-7.
; Set bits 13-15 of the offset to 1. Subtract 512 from the offset to get the final value.
@MatchOffset10Z:
    .a8
    asl                     ; Shift Z to C
    php
    readNibble
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
    .a8
    readNibble
    cmp #$0f
    bne @MatchLenNibble
    readByte                ; Long match, read next byte
    cmp #$e8
    bcc @MatchLenByte
    beq Done

@MatchLenWord:              ; Match length: Next word
    rep #$20
    .a16
    readWord
    dec
    bra CopyMatch

@MatchLenByte:              ; Match length: Byte + nibble value + 2
    .a8
    clc
    adc #(7 + 15 + 2 - 1)
    rep #$20
    .a16
    and #$00ff
    bra CopyMatch

@MatchLenNibble:            ; Match length: Nibble value + 2
    .a8
    clc
    adc #(7 + 2 - 1)
    rep #$20
    .a16
    and #$001f

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
    jsl LZSA2_mvn
    plb

    plx                     ; Restore source offset
    tya
    sta f:WMADD

    sep #$20
    jmp ReadToken

;
; Decompression done
;
Done:
    rep #$20
    .a16
    tya                     ; Calculate decompressed size
    sec
    sbc 1,s                 ; Start offset on stack
    plx                     ; Unwind
    tax
    sep #$20
    .a8
    plb                     ; Restore DP and DB
    pld
    rtl

.if LZSA2_OPT_INLINE = 0
;
; Get next nibble
;
GetNibble:
    .a8
    lsr <LZSA2_nibrdy       ; Nibble ready?
    bcs @NibbleReady
    inc <LZSA2_nibrdy       ; Flag nibble ready
    readByte                ; Load and store next nibble
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

LZSA2_DecompressBlock_END:
