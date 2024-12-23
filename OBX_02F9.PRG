procedure obx_02f9
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

//PARAMETROS('nrauxrec',ano+numero)
IF op_menu = INCLUSAO
 grupo=GRUPOS->grupo
ELSE
 REPL grupo WITH GRUPOS->grupo
ENDIF
RETU 0


* \\ Final de BXR_02F9.PRG

