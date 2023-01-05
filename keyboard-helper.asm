#importonce 

* = * "DetectKeyPressed"
DetectKeyPressed: {
    sei
    lda #%11111111
    sta c128lib.Cia.CIA1_DATA_DIR_A
    lda #%00000000
    sta c128lib.Cia.CIA1_DATA_DIR_B

    lda MaskOnPortA
    sta c128lib.Cia.CIA1_DATA_PORT_A
    lda c128lib.Cia.CIA1_DATA_PORT_B
    and MaskOnPortB
    beq Pressed
    lda #$00
    jmp !+
  Pressed:
    lda #$01
  !:
    cli
    rts

  MaskOnPortA:    .byte $00
  MaskOnPortB:    .byte $00
}

ReturnPressed: .byte $00

.macro IsReturnPressed() {
    lda #%11111110
    sta DetectKeyPressed.MaskOnPortA
    lda #%00000010
    sta DetectKeyPressed.MaskOnPortB
    jsr DetectKeyPressed
    sta ReturnPressed
}

.macro IsReturnPressedAndReleased() {
  !:
    IsReturnPressed()
    beq !-
  !:
    jsr DetectKeyPressed
    bne !-
}

#import "./chipset/lib/cia.asm"
