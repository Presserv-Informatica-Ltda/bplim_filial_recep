/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R01801F9.PRG
 \ Data....: 16-07-96
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: codigo de barras do relat¢rio ADM_R018
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistad
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas

 @ cl,001 say ' '+CHR(18)
 SETPRC(cl,1)               // retorna cabeca impressora
SET MARG TO                                        // coloca margem esquerda = 0
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
set printer to 'LPT1'
set devi to prin
cl:=prow()
 twinic()
 twdeflbars(2, 6)
 twdefprint(twepson)
 twdefalt(8)
 twdefcode(twc25)
 twdefsalto(12)
 @ cl,001 SAY ' ' + BARCODE(BXREC->codigo+BXREC->circ,15)
 lpp_004=LEFT(drvtapg,op_-1)+"004"+SUBS(drvtapg,op_+3)
 IMPCTL(lpp_004)                                    // seta pagina com 66 linhas
 cl:=Prow()
 @ cl,089 SAY chr(18)                 // normal
//@ cl+9,001 say '  '

RETU []      // <- deve retornar um valor qualquer

FUNCTION BARCODE
PARA vcod,SP_C
if pcount() = 0
 return ''
endif
vlin = 0
   k_ESC = CHR(27)
   vcop= 1
	    xcont= 0

*           twinic()
*           twdeflbars(2, 6)
*           twdefprint(twepson)
*           set device to printer

	    do while (xcont < vcop)
	       twdefsalto(8)
	       twdefalt(8)
	       twdefcode(twc25)

	       @ PRow() + 1,  SP_C say Space(1)

	       twdefalt(8)
	       twimpcod(vcod)
	       twdefsalto(8)
	       @ PRow() + 1,  SP_C say Space(1)

	       twdefalt(8)
	       twimpcod(vcod)
	       twdefsalto(8)
	       @ PRow() + 1,  SP_C say Space(1)

	       twdefalt(8)
	       twimpcod(vcod)
	       twdefsalto(12)

	       @ PRow() + 1,  SP_C say Space(1)

	       ***********
	       ****************
	       xcont=xcont+1
	       @ PRow() + vlin,  5 say Space(1)
	    enddo
	    * @ PRow() + 1,  5 say Space(1)
	    * set device to screen
	    return ''
* EOF
********************

procedure twinic
public twean13, twean8, twupca, twupce, twc25, twc39
public twepson, twlaser
public twcode, twprinter, twlbarf, twlbarg, twaltura, twround, twsource, twmaxalt
public twnulo, twmaxround
twean13 = 1
twean8 = 2
twupca = 3
twupce = 4
twc25 = 5
twc39 = 6
twepson = 1
twlaser = 2

twcode = twean13
twprinter = twepson
twlbarf = 1
twlbarg = 3
twaltura = 8
twround = 12
twsource = ''
twmaxalt = 3000
twmaxround = 100
twnulo = chr (0)
return

procedure twdefcode
parameters twcodetype
do case
   case twcodetype = twean13 .or. twcodetype = twean8 .or. twcodetype = twupca .or. twcodetype = twupce .or. twcodetype = twc25 .or. twcodetype = twc39
      twcode = twcodetype
endcase
return

procedure twdefprint
parameters twprinttyp
do case
   case twprinttyp = twepson .or. twprinttyp = twlaser
      twprinter = twprinttyp
endcase
return

procedure twdeflbars
parameters twfina, twgrossa
if twfina < 1
   twfina = 1
endif
if twgrossa >= twfina
   twlbarg = twgrossa
   twlbarf = twfina
endif
return

procedure twdefalt
parameters twalt
twaltura = twalt
if twaltura > twmaxalt
   twaltura = twmaxalt
endif
return

procedure twdefround
parameters twroundval
twround = twroundval
if twround > twmaxround
   twround = twmaxround
endif
return

procedure twdefsalto
parameters twsalto
@ prow (), pcol () say chr (27) + 'A' + chr (twsalto)
return

function twhpaltura
parameters twalt
return chr (27) + '*c' + transform (twalt, '9999') + 'B'

function twhpavanco
parameters twavanco
return chr (27) + '*p+' + transform (twavanco, '9999') + 'X'

procedure twajusta
if twprinter = twlaser
   @ prow (), pcol () say chr (27) + '&f0S' + chr (27) + '*p-30Y'
endif
return

procedure twrecup
if twprinter = twlaser
   @ prow (), pcol () say chr (27) + '&f1S'
endif
return

function twhpretang
parameters twavanco
return chr (27) + '*c' + transform (twavanco, '9999') + 'a0P' + twhpavanco (twavanco)

function twcalcdig
parameters twsrc
twk = 0
for twi = len (twsrc) to 1 step -1
   twj = val (substr (twsrc, twi, 1))
   if mod (len (twsrc) - twi, 2) = 0
      twj = twj * 3
   endif
   twk = twk + twj
next
twk = mod (10 - mod (twk, 10), 10)
return chr (twk + 48)

function twvalidnum
parameters twsrc, twsrclen
if twsrclen = 0
   twsrclen = len (twsrc)
endif
twflag = .t.
do while len (twsrc) < twsrclen
   twsrc = '0' + twsrc
enddo
for twi = 1 to twsrclen
   twflag = twflag .and. at (substr (twsrc, twi, 1), '0123456789') > 0
next
if twflag
   twsource = twsrc
endif
return twflag

function twvalidc39
parameters twsrc
if substr (twsrc, 1, 1) = '*'
   twsrc = substr (twsrc, 2, len (twsrc))
endif
if substr (twsrc, len (twsrc), 1) = '*'
   twsrc = substr (twsrc, 1, len (twsrc) - 1)
endif
twflag = .t.
for twi = 1 to len (twsrc)
   twflag = twflag .and. at (upper (substr (twsrc, twi, 1)), '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ- $/+%.') > 0
next
if twflag
   twsource = '*' + twsrc + '*'
endif
return twflag

function twvalid
parameters twsrc
twflag = .f.
twi = twcode
do case
   case twi = twean13
      twflag = twvalidnum (twsrc, 12)
      if twflag
	 twsource = twsource + twcalcdig (twsource)
      endif
   case twcode = twean8
      twflag = twvalidnum (twsrc, 7)
      if twflag
	 twsource = twsource + twcalcdig (twsource)
      endif
   case twcode = twupca
      twflag = twvalidnum (twsrc, 12)
      if twflag
	 twsource = twsource + twcalcdig (twsource)
      endif
   case twcode = twupce
      twflag = twvalidnum (twsrc, 7)
      if twflag
	 twsource = twsource + twcalcdig (twsource)
      endif
   case twcode = twc25
      twflag = twvalidnum (twsrc, 0)
      if twflag .and. mod (len (twsrc), 2) = 1
	 twsource = '0' + twsource
      endif
   case twcode = twc39
      twflag = twvalidc39 (twsrc)
endcase
return twflag

function twtam
parameters twsrc
twtamanho = 0
if twvalid (twsrc)
   do case
      case twcode = twean13
	 twtamanho = twlbarf * 95
      case twcode = twean8
	 twtamanho = twlbarf * 67
      case twcode = twupca
	 twtamanho = twlbarf * 95
      case twcode = twupce
	 twtamanho = twlbarf * 51
      case twcode = twc25
	 twtamanho = 6 * twlbarf + twlbarg + len (twsrc) * (3 * twlbarf + 2 * twlbarg)
      case twcode = twc39
	 twtamanho = (7 * twlbarf + 3 * twlbarg) * len (twsrc) - 1
      otherwise
	 twtamanho = 0
   endcase
endif
return twtamanho

function twtamr
parameters twsrc
twi = twtam (twsrc)
do while mod (twi, twround) != 0
   twi = twi + 1
enddo
return twi

function twtamchar
parameters twsrc
return int (twtamr (twsrc) / twround)

function tword39
parameters twchar
return at (upper (twchar), '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*')

procedure twimpean13
private twalt [8]
private twcodigo1 [10], twcodigo2 [10], twcodigo3 [10], twtab7a12 [10]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo1 [1] = '0001101'
twcodigo1 [2] = '0011001'
twcodigo1 [3] = '0010011'
twcodigo1 [4] = '0111101'
twcodigo1 [5] = '0100011'
twcodigo1 [6] = '0110001'
twcodigo1 [7] = '0101111'
twcodigo1 [8] = '0111011'
twcodigo1 [9] = '0110111'
twcodigo1 [10] = '0001011'
twcodigo2 [1] = '0100111'
twcodigo2 [2] = '0110011'
twcodigo2 [3] = '0011011'
twcodigo2 [4] = '0100001'
twcodigo2 [5] = '0011101'
twcodigo2 [6] = '0111001'
twcodigo2 [7] = '0000101'
twcodigo2 [8] = '0010001'
twcodigo2 [9] = '0001001'
twcodigo2 [10] = '0010111'
twcodigo3 [1] = '1110010'
twcodigo3 [2] = '1100110'
twcodigo3 [3] = '1101100'
twcodigo3 [4] = '1000010'
twcodigo3 [5] = '1011100'
twcodigo3 [6] = '1001110'
twcodigo3 [7] = '1010000'
twcodigo3 [8] = '1000100'
twcodigo3 [9] = '1001000'
twcodigo3 [10] = '1110100'
twtab7a12 [1] = '111111'
twtab7a12 [2] = '221211'
twtab7a12 [3] = '212211'
twtab7a12 [4] = '122211'
twtab7a12 [5] = '221121'
twtab7a12 [6] = '211221'
twtab7a12 [7] = '112221'
twtab7a12 [8] = '212121'
twtab7a12 [9] = '122121'
twtab7a12 [10] = '121221'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 2 to 13
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 7
	       twm = 'TWCODIGO' + substr (twtab7a12 [twl], 8 - twi, 1)
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say replicate (twchar, twlbarf)
	    else
	       @ prow (), pcol () say replicate (twnulo, twlbarf)
	    endif
	 next
	 if twi = 7
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	 endif
      next
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 2 to 13
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 7
	       twm = 'TWCODIGO' + substr (twtab7a12 [twl], 8 - twi, 1)
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say twhpretang (twlbarf)
	    else
	       @ prow (), pcol () say twhpavanco (twlbarf)
	    endif
	 next
	 if twi = 7
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	 endif
      next
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
endcase
return

procedure twimpean8
private twalt [8]
private twcodigo1 [10], twcodigo3 [10]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo1 [1] = '0001101'
twcodigo1 [2] = '0011001'
twcodigo1 [3] = '0010011'
twcodigo1 [4] = '0111101'
twcodigo1 [5] = '0100011'
twcodigo1 [6] = '0110001'
twcodigo1 [7] = '0101111'
twcodigo1 [8] = '0111011'
twcodigo1 [9] = '0110111'
twcodigo1 [10] = '0001011'
twcodigo3 [1] = '1110010'
twcodigo3 [2] = '1100110'
twcodigo3 [3] = '1101100'
twcodigo3 [4] = '1000010'
twcodigo3 [5] = '1011100'
twcodigo3 [6] = '1001110'
twcodigo3 [7] = '1010000'
twcodigo3 [8] = '1000100'
twcodigo3 [9] = '1001000'
twcodigo3 [10] = '1110100'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 1 to 8
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 4
	       twm = 'TWCODIGO1'
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say replicate (twchar, twlbarf)
	    else
	       @ prow (), pcol () say replicate (twnulo, twlbarf)
	    endif
	 next
	 if twi = 4
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	 endif
      next
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 1 to 8
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 4
	       twm = 'TWCODIGO1'
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say twhpretang (twlbarf)
	    else
	       @ prow (), pcol () say twhpavanco (twlbarf)
	    endif
	 next
	 if twi = 4
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	 endif
      next
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
endcase
return

procedure twimpupca
private twalt [8]
private twcodigo1 [10], twcodigo3 [10]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo1 [1] = '0001101'
twcodigo1 [2] = '0011001'
twcodigo1 [3] = '0010011'
twcodigo1 [4] = '0111101'
twcodigo1 [5] = '0100011'
twcodigo1 [6] = '0110001'
twcodigo1 [7] = '0101111'
twcodigo1 [8] = '0111011'
twcodigo1 [9] = '0110111'
twcodigo1 [10] = '0001011'
twcodigo3 [1] = '1110010'
twcodigo3 [2] = '1100110'
twcodigo3 [3] = '1101100'
twcodigo3 [4] = '1000010'
twcodigo3 [5] = '1011100'
twcodigo3 [6] = '1001110'
twcodigo3 [7] = '1010000'
twcodigo3 [8] = '1000100'
twcodigo3 [9] = '1001000'
twcodigo3 [10] = '1110100'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 2 to 13
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 7
	       twm = 'TWCODIGO1'
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say replicate (twchar, twlbarf)
	    else
	       @ prow (), pcol () say replicate (twnulo, twlbarf)
	    endif
	 next
	 if twi = 7
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	 endif
      next
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 2 to 13
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 7
	       twm = 'TWCODIGO1'
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say twhpretang (twlbarf)
	    else
	       @ prow (), pcol () say twhpavanco (twlbarf)
	    endif
	 next
	 if twi = 7
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	 endif
      next
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
endcase
return

procedure twimpupce
private twalt [8]
private twcodigo1 [10], twcodigo2 [10], twtab2a7 [10]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo1 [1] = '0001101'
twcodigo1 [2] = '0011001'
twcodigo1 [3] = '0010011'
twcodigo1 [4] = '0111101'
twcodigo1 [5] = '0100011'
twcodigo1 [6] = '0110001'
twcodigo1 [7] = '0101111'
twcodigo1 [8] = '0111011'
twcodigo1 [9] = '0110111'
twcodigo1 [10] = '0001011'
twcodigo2 [1] = '0100111'
twcodigo2 [2] = '0110011'
twcodigo2 [3] = '0011011'
twcodigo2 [4] = '0100001'
twcodigo2 [5] = '0011101'
twcodigo2 [6] = '0111001'
twcodigo2 [7] = '0000101'
twcodigo2 [8] = '0010001'
twcodigo2 [9] = '0001001'
twcodigo2 [10] = '0010111'
twtab2a7 [1] = '222111'
twtab2a7 [2] = '221211'
twtab2a7 [3] = '221121'
twtab2a7 [4] = '221112'
twtab2a7 [5] = '212211'
twtab2a7 [6] = '211221'
twtab2a7 [7] = '211122'
twtab2a7 [8] = '212121'
twtab2a7 [9] = '212112'
twtab2a7 [10] = '211212'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      twl = val (substr (twsource, 8, 1)) + 1
      for twi = 2 to 7
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    twm = 'TWCODIGO' + substr (twtab2a7 [twl], twi - 1, 1)
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say replicate (twchar, twlbarf)
	    else
	       @ prow (), pcol () say replicate (twnulo, twlbarf)
	    endif
	 next
      next
      @ prow (), pcol () say replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
      twl = val (substr (twsource, 8, 1)) + 1
      for twi = 2 to 7
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    twm = 'TWCODIGO' + substr (twtab2a7 [twl], twi - 1, 1)
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say twhpretang (twlbarf)
	    else
	       @ prow (), pcol () say twhpavanco (twlbarf)
	    endif
	 next
      next
      @ prow (), pcol () say twhpavanco (twlbarf) + twhpretang (twlbarf)
      @ prow (), pcol () say twhpavanco (twlbarf) + twhpretang (twlbarf)
      @ prow (), pcol () say twhpavanco (twlbarf) + twhpretang (twlbarf)
endcase
return

procedure twimpc25
private twalt [8]
private twcodigo [10]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo [1] = '00110'
twcodigo [2] = '10001'
twcodigo [3] = '01001'
twcodigo [4] = '11000'
twcodigo [5] = '00101'
twcodigo [6] = '10100'
twcodigo [7] = '01100'
twcodigo [8] = '00011'
twcodigo [9] = '10010'
twcodigo [10] = '01010'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf) + replicate (twnulo, twlbarf)
      for twi = 1 to len (twsource) / 2
	 twk = val (substr (twsource, twi * 2 - 1, 1)) + 1
	 twl = val (substr (twsource, twi * 2, 1)) + 1
	 for twj = 1 to 5
	    if substr (twcodigo [twk], twj, 1) = '1'
	       twm = twlbarg
	    else
	       twm = twlbarf
	    endif
	    if substr (twcodigo [twl], twj, 1) = '1'
	       twn = twlbarg
	    else
	       twn = twlbarf
	    endif
	    @ prow (), pcol () say replicate (twchar, twm) + replicate (twnulo, twn)
	 next
      next
      @ prow (), pcol () say replicate (twchar, twlbarg) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf) + twhpavanco (twlbarf)
      for twi = 1 to int (len (twsource) / 2)
	 twk = val (substr (twsource, twi * 2 - 1, 1)) + 1
	 twl = val (substr (twsource, twi * 2, 1)) + 1
	 for twj = 1 to 5
	    if substr (twcodigo [twk], twj, 1) = '1'
	       twm = twlbarg
	    else
	       twm = twlbarf
	    endif
	    if substr (twcodigo [twl], twj, 1) = '1'
	       twn = twlbarg
	    else
	       twn = twlbarf
	    endif
	    @ prow (), pcol () say twhpretang (twm) + twhpavanco (twn)
	 next
      next
      @ prow (), pcol () say twhpretang (twlbarg) + twhpavanco (twlbarf) + twhpretang (twlbarf)
endcase
return

procedure twimpc39
private twalt [8]
private twcodigo [44]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo [1] = '000110100'
twcodigo [2] = '100100001'
twcodigo [3] = '001100001'
twcodigo [4] = '101100000'
twcodigo [5] = '000110001'
twcodigo [6] = '100110000'
twcodigo [7] = '001110000'
twcodigo [8] = '000100101'
twcodigo [9] = '100100100'
twcodigo [10] = '001100100'
twcodigo [11] = '100001001'
twcodigo [12] = '001001001'
twcodigo [13] = '101001000'
twcodigo [14] = '000011001'
twcodigo [15] = '100011000'
twcodigo [16] = '001011000'
twcodigo [17] = '000001101'
twcodigo [18] = '100001100'
twcodigo [19] = '001001100'
twcodigo [20] = '000011100'
twcodigo [21] = '100000011'
twcodigo [22] = '001000011'
twcodigo [23] = '101000010'
twcodigo [24] = '000010011'
twcodigo [25] = '100010010'
twcodigo [26] = '001010010'
twcodigo [27] = '000000111'
twcodigo [28] = '100000110'
twcodigo [29] = '001000110'
twcodigo [30] = '000010110'
twcodigo [31] = '110000001'
twcodigo [32] = '011000001'
twcodigo [33] = '111000000'
twcodigo [34] = '010010001'
twcodigo [35] = '110010000'
twcodigo [36] = '011010000'
twcodigo [37] = '010000101'
twcodigo [38] = '110000100'
twcodigo [39] = '011000100'
twcodigo [40] = '010101000'
twcodigo [41] = '010100010'
twcodigo [42] = '010001010'
twcodigo [43] = '000101010'
twcodigo [44] = '010010100'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      for twi = 1 to len (twsource)
	 twj = tword39 (substr (twsource, twi, 1))
	 for twk = 1 to 9
	    if substr (twcodigo [twj], twk, 1) = '1'
	       twm = twlbarg
	    else
	       twm = twlbarf
	    endif
	    if mod (twk, 2) = 1
	       @ prow (), pcol () say replicate (twchar, twm)
	    else
	       @ prow (), pcol () say replicate (twnulo, twm)
	    endif
	 next
	 @ prow (), pcol () say replicate (twnulo, twlbarf)
      next
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      for twi = 1 to len (twsource)
	 twj = tword39 (substr (twsource, twi, 1))
	 for twk = 1 to 9
	    if substr (twcodigo [twj], twk, 1) = '1'
	       twm = twlbarg
	    else
	       twm = twlbarf
	    endif
	    if mod (twk, 2) = 1
	       @ prow (), pcol () say twhpretang (twm)
	    else
	       @ prow (), pcol () say twhpavanco (twm)
	    endif
	 next
	 @ prow (), pcol () say twhpavanco (twlbarf)
      next
endcase
return

procedure twimpcod
parameters twsrc
if twvalid (twsrc)
   twajusta ()
   do case
      case twcode = twean13
	 do twimpean13
      case twcode = twean8
	 do twimpean8
      case twcode = twupca
	 do twimpupca
      case twcode = twupce
	 do twimpupce
      case twcode = twc25
	 do twimpc25
      case twcode = twc39
	 do twimpc39
   endcase
   twrecup ()
endif
return


* \\ Final de R00102F9.PRG




RETU       // <- deve retornar um valor qualquer

* \\ Final de R01801F9.PRG
