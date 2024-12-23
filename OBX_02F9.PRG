
procedure obx_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: BXR_02F9.PRG
 \ Data....: 28-11-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Valor inicial do campo VALORPG, arquivo BXREC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:58:28 Fase_01
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
