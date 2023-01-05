
.disk [filename="./C128LIB-SAMPLES.d64", name="C128LIB", id="C2023", showInfo]
{
  [name="--- C128LIB ---", type="usr"],
  [name="--- SAMPLES ---", type="usr"],
  [name="---------------", type="usr"],
  [name="CIA", type="prg", segments="Cia"],
  [name="VDC", type="prg", segments="Vdc"],
  [name="VIC2", type="prg", segments="Vic2"],
}

#import "cia.asm"
#import "vdc.asm"
#import "vic2.asm"
