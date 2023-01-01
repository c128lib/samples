c128lib_BasicUpstart128($1c10)

.label SCREEN_RAM = $0400
.label COMMODORE_PTR = SCREEN_RAM + $3f8

* = $1c10 "Entry"
Entry: {
    jsr c128lib.Kernal.CINT

// Changing border/bg color
    c128lib_SetBorderAndBackgroundColor(BLACK, BLACK)

// Setting up sprite 0
    lda #SPRITES_OFFSET.COMMODORE
    sta COMMODORE_PTR

    lda #RED
    sta c128lib.Vic2.SPRITE_0_COLOR

    lda #BLUE
    sta c128lib.Vic2.SPRITE_COL_0

    lda #DARK_GRAY
    sta c128lib.Vic2.SPRITE_COL_1

    lda #1
    sta c128lib.Vic2.SPRITE_COL_MODE

// Positioning sprite 0
    lda #100
    sta c128lib.Vic2.SHADOW_SPRITE_0_X
    sta c128lib.Vic2.SHADOW_SPRITE_0_Y
    
    lda #1
    sta c128lib.Vic2.SPRITE_ENABLE

    IsReturnPressedAndReleased()

// Moving sprite 0
    c128lib_SpriteMove(0, 4, c128lib.Vic2.SPRITE_MAIN_DIR_RIGHT, $7f00, $0000)

    IsReturnPressedAndReleased()

// Setting up sprite 1
    lda #SPRITES_OFFSET.COMMODORE
    sta COMMODORE_PTR + 1

    lda #YELLOW
    sta c128lib.Vic2.SPRITE_1_COLOR

    lda #3
    sta c128lib.Vic2.SPRITE_COL_MODE

// Positioning sprite 1
    lda #110
    sta c128lib.Vic2.SHADOW_SPRITE_1_X
    sta c128lib.Vic2.SHADOW_SPRITE_1_Y
    
    lda #3
    sta c128lib.Vic2.SPRITE_ENABLE

    IsReturnPressedAndReleased()

// Moving sprite 1
    c128lib_SpriteMove(1, 3, c128lib.Vic2.SPRITE_MAIN_DIR_LEFT, $7f00, $0000)

    rts
}

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

* = $2000 "Sprites"
SPRITES:
.import binary "./assets/sprites.bin"

SPRITES_OFFSET: {
  .label COMMODORE = (SPRITES / 64)
}

#import "./common/lib/common-global.asm"
#import "./common/lib/kernal.asm"
#import "./chipset/lib/cia.asm"
#import "./chipset/lib/vic2.asm"
#import "./chipset/lib/vic2-global.asm"
