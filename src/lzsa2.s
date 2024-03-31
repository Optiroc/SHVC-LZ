; SHVC-LZSA2
; David Lindecrantz <optiroc@me.com>
;
; LZSA2 decompressor

.p816
.smart -
.feature c_comments

; TODO
; - Try source offset always in 16-bit x, dest in Y; minimize accumulator width toggling
; - Check bank if mvn jump can be short
; - Option to inline nibble access

; LZSA2_opt_dma_scratchpad
; - Document speed diff

; LZSA2_OPT_DMA_SCRATCHPAD
; Use SNES DMA registers at $4370-$4377 as scratchpad for MVN instructions.
;
; 0 - Do not use DMA registers as scratchpad (direct page usage = $12 bytes)
; 1 - Use DMA registers as scratchpad (no direct page usage)
LZSA2_OPT_DMA_SCRATCHPAD = 1 ; Use DMA registers as scratchpad for MVN instructions

.export LZSA2_DecompressBlock

; Scratchpad
.if LZSA2_OPT_DMA_SCRATCHPAD = 1
    .define LZSA2_token     $804360 ; Current token
    .define LZSA2_nibble    $804361 ; Current nibble
    .define LZSA2_nibrdy    $804362 ; Nibble ready
    .define LZSA2_match     $804363 ; Previous match offset
    .define LZSA2_source    $804365 ; Source (indirect long)
    .define LZSA2_dest      $804368 ; Destination (indirect long)
    .define LZSA2_mvl       $804370 ; Literal block move (mvn + banks + return)
    .define LZSA2_mvm       $804374 ; Match block move (mvn + banks + return)
.else
    .importzp Scratchpad
    .define LZSA2_token     Scratchpad+$00 ; Current token
    .define LZSA2_nibble    Scratchpad+$01 ; Current nibble
    .define LZSA2_nibrdy    Scratchpad+$02 ; Nibble ready
    .define LZSA2_match     Scratchpad+$03 ; Previous match offset
    .define LZSA2_source    Scratchpad+$05 ; Source (indirect long)
    .define LZSA2_dest      Scratchpad+$08 ; Destination (indirect long)
    .define LZSA2_mvl       Scratchpad+$0b ; Literal block move (mvn + banks + return)
    .define LZSA2_mvm       Scratchpad+$0f ; Match block move (mvn + banks + return)
.endif

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
.if LZSA2_OPT_DMA_SCRATCHPAD = 1
    phd
    rep #$20
    .a16
    pha
    lda #$4300              ; Set direct page at CPU MMIO area
    tcd
    pla
    sep #$20
    .a8
.endif

    phy                     ; Push destination offset for decompressed length calculation

    stz <LZSA2_nibrdy
    stx <LZSA2_source+$00   ; Write source for indirect and block move addressing
    sta <LZSA2_source+$02
    sta <LZSA2_mvl+$02

    xba                     ; Write destination for indirect and block move addressing
    sty <LZSA2_dest+$00
    sta <LZSA2_dest+$02
    sta <LZSA2_mvl+$01
    sta <LZSA2_mvm+$01
    sta <LZSA2_mvm+$02

    lda #$54                ; Write MVN and return instructions
    sta <LZSA2_mvl+$00
    sta <LZSA2_mvm+$00
    lda #$6b                ; $60 = RTS, $6b = RTL
    sta <LZSA2_mvl+$03
    sta <LZSA2_mvm+$03

ReadToken:
    lda [<LZSA2_source]     ; Read token byte
    sta <LZSA2_token
    rep #$20
    .a16
    inc <LZSA2_source       ; Increment source pointer
    sep #$20
    .a8

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
    .a8
    lda [<LZSA2_source]
    sta [<LZSA2_dest]
    rep #$20
    .a16
    inc <LZSA2_source
    inc <LZSA2_dest
    sep #$20
    bra DecodeMatchOffset

@LitLen2:                   ; Copy 2 literals
    rep #$20
    .a16
    lda [<LZSA2_source]
    sta [<LZSA2_dest]
    inc <LZSA2_source
    inc <LZSA2_dest
    inc <LZSA2_source
    inc <LZSA2_dest
    sep #$20
    bra DecodeMatchOffset

@ExtLitLen:
    .a8
    jsr GetNibble
    cmp #$0f
    bne @LitLenNibble

    lda [<LZSA2_source]     ; Long literal, read next byte
    cmp #$ef
    beq @LitLenWord

@LitLenByte:                ; Literal length: Byte + nibble value + 3
    .a8
    clc
    adc #(15 + 3 - 1)
    rep #$20
    .a16
    inc <LZSA2_source
    and #$00ff
    bra @CopyLiteral

@LitLenWord:                ; Literal length: Next word
    rep #$20
    .a16
    inc <LZSA2_source
    lda [<LZSA2_source]
    inc <LZSA2_source
    bra @CopyLiteral

@LitLenNibble:              ; Literal length: Nibble value + 3
    .a8
    clc
    adc #(3 - 1)
    rep #$20
    .a16
    and #$00ff

@CopyLiteral:               ; Length in A
    .a16
    ldx <LZSA2_source       ; 4
    ldy <LZSA2_dest         ; 4
    phb                     ; 3
    jsl LZSA2_mvl           ; 8 -> 7 * len + 6
    plb                     ; 4 25
    stx <LZSA2_source       ; 4
    sty <LZSA2_dest         ; 4
    sep #$20                ; 3
    .a8                     ; = 40 (overhead) + 7 * len

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
    jsr GetNibble
    plp
    rol                     ; Shift nibble, Z into bit 0
    eor #%11100001
    xba
    lda #$ff
    xba
    rep #$20
    .a16
    bra DecodeMatchLen

; 01Z 9-bit offset:
; Read a byte for offset bits 0-7 and use the inverted bit Z for bit 8 of the offset.
; Set bits 9-15 of the offset to 1.
@MatchOffset01Z:
    .a8
    asl                     ; Shift Z to C
    php
    lda [<LZSA2_source]
    xba
    plp
    lda #$00
    rol
    eor #$ff
    xba
    rep #$20
    .a16
    inc <LZSA2_source
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
    lda [<LZSA2_source]
    inc <LZSA2_source
    inc <LZSA2_source
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
    jsr GetNibble
    plp
    rol                     ; Shift nibble, Z into bit 0, C = 0
    eor #%11100001
    dec
    dec
    xba
    lda [<LZSA2_source]
    rep #$20
    .a16
    inc <LZSA2_source

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
    bra @CopyMatch

@ExtMatchLen:
    .a8
    jsr GetNibble
    cmp #$0f
    bne @MatchLenNibble
    lda [<LZSA2_source]     ; Long match, read next byte
    cmp #$e8
    bcc @MatchLenByte
    beq Done

@MatchLenWord:              ; Match length: Next word
    rep #$20
    .a16
    inc <LZSA2_source
    lda [<LZSA2_source]
    inc <LZSA2_source
    bra @CopyMatch

@MatchLenByte:              ; Match length: Byte + nibble value + 2
    .a8
    clc
    adc #(7 + 15 + 2 - 1)
    rep #$20
    .a16
    and #$00ff
    inc <LZSA2_source
    bra @CopyMatch

@MatchLenNibble:            ; Match length: Nibble value + 2
    .a8
    clc
    adc #(7 + 2 - 1)
    rep #$20
    .a16
    and #$001f

@CopyMatch:                 ; Length in A, offset in LZSA2_match
    .a16
    tay
    lda <LZSA2_dest
    clc
    adc <LZSA2_match
    tax
    tya
    ldy <LZSA2_dest
    phb
    jsl LZSA2_mvm
    plb
    sty <LZSA2_dest
    sep #$20
    jmp ReadToken

Done:
    rep #$20
    .a16
    lda <LZSA2_dest         ; Calculate decompressed size
    sec
    sbc 1,s                 ; Start offset on stack
    plx                     ; Unwind
    tax
    sep #$20
    .a8
.if LZSA2_OPT_DMA_SCRATCHPAD = 1
    pld
.endif
    rtl

;
; Get next nibble
;
GetNibble:
    .a8
    lsr <LZSA2_nibrdy       ; Nibble ready?
    bcs @NibbleReady
    inc <LZSA2_nibrdy       ; Flag nibble ready
    lda [<LZSA2_source]     ; Load and store next nibble
    sta <LZSA2_nibble
    lsr
    lsr
    lsr
    lsr
    rep #$20                ; Increment source pointer
    .a16
    inc <LZSA2_source
    sep #$20
    .a8
    rts
@NibbleReady:
    lda <LZSA2_nibble
    and #$0f
    rts

LZSA2_DecompressBlock_END:
