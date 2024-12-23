/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: R07702F9.PRG
 \ Data....: 23-05-98
 \ Sistema.: Administradora -CRD/COBRAN€A
 \ Funcao..: Valor do relat¢rio ADC_R077
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
PRIVA vladd:=0
IF TAXAS->emissao_< DATE()
 jrok:=PTAB(tipo,'JUROS',1)
 nrd:=(DATE() - TAXAS->emissao_)
 IF jrok .AND. (nrd > JUROS->mltcaren)
  vladd+=TAXAS->valor*JUROS->multa/100
 ENDI
 IF jrok .AND. (nrd > JUROS->jrscaren)
  vladd+=TAXAS->valor*JUROS->juros/100*nrd
 ENDI
ENDI

RETU IIF(EMPT(TAXAS->valorpg),TAXAS->valor+M->vladd,TAXAS->valorpg)

* \\ Final de R07702F9.PRG
