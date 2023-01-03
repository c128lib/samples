#importonce 
.segmentdef Cia [start=$1c01]
.segment Cia

c128lib_BasicUpstart128($1c10)

* = $1c10 "Entry"
Entry: {
  // Clean screen
    jsr c128lib.Kernal.CINT

// Set cursor on (0, 5)
    clc
    ldx #5
    ldy #0
    jsr $fff0

// Print string at current cursor position
    ldx #0
  !:
    lda Joy1, x
    jsr $FFD2
    inx
    cpx #$1B
    bne !-

// Set cursor on (0, 6)
    clc
    ldx #6
    ldy #0
    jsr $fff0

// Print string at current cursor position
    ldx #0
  !:
    lda Joy2, x
    jsr $FFD2
    inx
    cpx #$1B
    bne !-

  Loop:
    c128lib_GetFirePressedPort1()
    clc
    beq !Zero+
    adc #33
    jmp !Print+
  !Zero:
    adc #48

  !Print:
    sta $04E3

    c128lib_GetFirePressedPort2()
    clc
    beq !Zero+
    adc #33
    jmp !Print+
  !Zero:
    adc #48

  !Print:
    sta $050B
    
    jmp Loop
}

Joy1: .text "JOYSTICK 1 (0 IS PRESSED): "
Joy2: .text "JOYSTICK 2 (0 IS PRESSED): "

#import "./common/lib/common-global.asm"
#import "./common/lib/kernal.asm"
#import "./chipset/lib/cia-global.asm"
