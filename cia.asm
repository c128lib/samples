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
    jsr c128lib.Kernal.PLOT

// Print string at current cursor position
    ldx #0
  !:
    lda Joy1, x
    jsr c128lib.Kernal.BSOUT
    inx
    cpx #Joy1Length
    bne !-

// Set cursor on (0, 6)
    clc
    ldx #6
    ldy #0
    jsr c128lib.Kernal.PLOT

// Print string at current cursor position
    ldx #0
  !:
    lda Joy2, x
    jsr c128lib.Kernal.BSOUT
    inx
    cpx #Joy2Length
    bne !-

  Loop:
    c128lib_GetFirePressedPort1()
    ConvertAccumulatorInZeroOrOneChar()
    sta $400 + c128lib_getTextOffset(27, 5)

    c128lib_GetFirePressedPort2()
    ConvertAccumulatorInZeroOrOneChar()
    sta $400 + c128lib_getTextOffset(27, 6)
    
    jmp Loop
}

Joy1: .text "JOYSTICK 1 (0 IS PRESSED): "
.label Joy1Length = $1B;
Joy2: .text "JOYSTICK 2 (0 IS PRESSED): "
.label Joy2Length = $1B;

.macro ConvertAccumulatorInZeroOrOneChar() {
    clc
    beq !Zero+
    adc #33
    jmp !Print+
  !Zero:
    adc #48

  !Print:
}

#import "./common/lib/common-global.asm"
#import "./common/lib/kernal.asm"
#import "./chipset/lib/cia-global.asm"
#import "./chipset/lib/vic2-global.asm"
