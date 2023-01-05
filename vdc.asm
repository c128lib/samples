#importonce 
.segmentdef Vdc [start=$1c01]
.segment Vdc

c128lib_BasicUpstart128($1c10)

.namespace Vdc {
* = $1c10 "Entry"
Entry: {
// Clean screen
    jsr c128lib.Kernal.CINT

    c128lib_Go80()

// Set cursor on (0, 2)
    clc
    ldx #2
    ldy #0
    jsr c128lib.Kernal.PLOT

// Print string at current cursor position
    ldx #0
  !:
    lda SampleString, x
    jsr c128lib.Kernal.BSOUT
    inx
    cpx #SampleStringLength
    bne !-

    IsReturnPressedAndReleased()

    c128lib_SetBackgroundForegroundColor(c128lib.Vdc.VDC_DARK_CYAN, c128lib.Vdc.VDC_LIGHT_CYAN);

// Set cursor on (0, 5)
    clc
    ldx #5
    ldy #0
    jsr c128lib.Kernal.PLOT

// Print string at current cursor position
    ldx #0
  !:
    lda SampleString2, x
    jsr c128lib.Kernal.BSOUT
    inx
    cpx #SampleString2Length
    bne !-

    IsReturnPressedAndReleased()

    c128lib_SetBackgroundForegroundColor(c128lib.Vdc.VDC_DARK_RED, c128lib.Vdc.VDC_LIGHT_RED);

// Set cursor on (0, 8)
    clc
    ldx #8
    ldy #0
    jsr c128lib.Kernal.PLOT

// Print string at current cursor position
    ldx #0
  !:
    lda SampleString3, x
    jsr c128lib.Kernal.BSOUT
    inx
    cpx #SampleString3Length
    bne !-

    IsReturnPressedAndReleased()

// Now let the user choose his favourite color
  UserSelect:
    clc
    ldx #11
    ldy #0
    jsr c128lib.Kernal.PLOT

// Print string at current cursor position
    ldx #0
  !:
    lda ColorString, x
    jsr c128lib.Kernal.BSOUT
    inx
    cpx #ColorStringLength
    bne !-

    jsr c128lib.Kernal.GETIN
    cmp #48
    bcc UserSelect    // Lower than '0'
    cmp #71
    bcs UserSelect    // Greater than 'F'
    cmp #58
    bcc IsNumber
    cmp #65
    bcs IsLetter
    jmp UserSelect    // If it's between ':' AND '-' restart

  IsNumber:
    and #%00001111    // Number, take the lower nibble
    jmp ChooseColor

  IsLetter:
    and #%00001111    // Letter, take the lower nibble
    clc
    adc #9            // Add 9 to convert to Hex

  ChooseColor:
    sta background      // Background
    eor #$FF
    and #%00001111
    sta foreground      // Foreground is EOR(background) to make text readable
    c128lib_SetBackgroundForegroundColorWithVars(background, foreground)

    jmp UserSelect      // Back to user selection

  background: .byte 0
  foreground: .byte 0
}

}

ColorString: .text "SELECT COLOR (0 TO F): "
.label ColorStringLength = 23;

SampleString: .text "LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT. MAURIS MOLLIS NEC MI VEL COMMODO."
.label SampleStringLength = 90;

SampleString2: .text "UT EU LOREM URNA. PHASELLUS AC MAXIMUS LIBERO, VITAE FINIBUS NISL."
.label SampleString2Length = 66;

SampleString3: .text "DUIS QUIS TEMPOR TELLUS. VIVAMUS MATTIS VESTIBULUM TORTOR ELEIFEND GRAVIDA."
.label SampleString3Length = 75;

#import "keyboard-helper.asm"

#import "./common/lib/common-global.asm"
#import "./chipset/lib/vdc-global.asm"
