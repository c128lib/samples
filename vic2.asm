#importonce 
.segmentdef Vic2 [start=$1c01]
.segment Vic2

c128lib_BasicUpstart128($1c10)

.label SCREEN_RAM = $0400
.label COMMODORE_PTR = SCREEN_RAM + $3f8

.namespace Vic2 {
* = $1c10 "Entry"
Entry: {
    SetupInterrupt()

// Clean screen
    jsr c128lib.Kernal.CINT

// Changing border/bg color
    c128lib_SetBorderAndBackgroundColor(BLACK, BLACK)

// Setting up sprite 0
    lda #SPRITES_OFFSET.COMMODORE
    sta COMMODORE_PTR

    c128lib_SpriteColor(0, RED)

    c128lib_SpriteMultiColor0(BLUE)
    c128lib_SpriteMultiColor1(DARK_GRAY)

    c128lib_SpriteEnableMulticolor(c128lib.Vic2.SPRITE_MASK_0 | c128lib.Vic2.SPRITE_MASK_1)
    
// Positioning sprite 0
    c128lib_SetSpritePositionWithShadow(0, 100, 100)

    c128lib_SpriteEnable(c128lib.Vic2.SPRITE_MASK_0)
        
    IsReturnPressedAndReleased()

// Moving sprite 0
    c128lib_SpriteMove(0, 4, c128lib.Vic2.SPRITE_MAIN_DIR_RIGHT, $7f00, $0000)

    IsReturnPressedAndReleased()

// Setting up sprite 1
    lda #SPRITES_OFFSET.COMMODORE
    sta COMMODORE_PTR + 1

    c128lib_SpriteColor(1, YELLOW)

// Positioning sprite 1
    c128lib_SetSpritePositionWithShadow(1, 110, 110)
    
    c128lib_SpriteEnable(c128lib.Vic2.SPRITE_MASK_1)

    IsReturnPressedAndReleased()

// Moving sprite 1
    c128lib_SpriteMove(1, 3, c128lib.Vic2.SPRITE_MAIN_DIR_LEFT, $7f00, $0000)

    rts
}

CollisionIrq: {
    lda c128lib.Vic2.IRR
    sta c128lib.Vic2.IRR

    lda c128lib.Vic2.SPRITE_2S_COLLISION
    beq !Done+
    inc $d020
  !Done:
    jmp $fa65
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

.macro SetupInterrupt() {
    sei
    lda #$7f
    sta c128lib.Cia.CIA1_IRQ_CONTROL
    lda #<CollisionIrq
    sta $0314
    lda #>CollisionIrq
    sta $0315

    lda #$30
    sta c128lib.Vic2.RASTER
    lda c128lib.Vic2.CONTROL_1
    and #$7f
    sta c128lib.Vic2.CONTROL_1

    lda #$05
    sta c128lib.Vic2.IMR
    sta c128lib.Vic2.IRR
    cli
}

* = $2000 "Sprites"
SPRITES:
.import binary "./assets/sprites.bin"

SPRITES_OFFSET: {
  .label COMMODORE = (SPRITES / 64)
}

}

#import "./common/lib/common-global.asm"
#import "./common/lib/kernal.asm"
#import "./chipset/lib/cia.asm"
#import "./chipset/lib/sprites-global.asm"
#import "./chipset/lib/vic2.asm"
#import "./chipset/lib/vic2-global.asm"
