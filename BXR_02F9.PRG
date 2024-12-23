procedure bxr_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: BXR_02F9.PRG
 \ Data....: 28-11-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Valor inicial do campo VALORPG, arquivo BXREC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
PRIV vladd:=0
IF op_menu = INCLUSAO
 grupo=GRUPOS->grupo
ELSE
 RETU .T.
 REPL grupo WITH GRUPOS->grupo
ENDIF
IF TAXAS->emissao_< DATE()
 jrok:=PTAB([],'JUROS',1)
 nrd:=(DATE() - TAXAS->emissao_)
 IF jrok .AND. (nrd > JUROS->mltcaren)
  vladd+=TAXAS->valor*JUROS->multa/100
 ENDI
 IF jrok .AND. (nrd > JUROS->jrscaren)
  vladd+=TAXAS->valor*JUROS->juros/100*nrd
 ENDI
ENDI

RETU IIF(EMPT(TAXAS->valorpg),TAXAS->valor+M->vladd,0)


* \\ Final de BXR_02F9.PRG


