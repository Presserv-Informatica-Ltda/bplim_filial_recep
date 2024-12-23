
procedure r02501f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: R02501F9.PRG
 \ Data....: 24-11-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: MOTIVO do relat¢rio ADM_R025
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:58:08 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas
IF !PTAB(codigo+circ,'TAXAS',1)
 RETU [Nao cadastrada]
ELSEIF TAXAS->valorpg>0
 RETU [Taxa baixada  ]
ENDIF

RETU []
* \\ Final de R02501F9.PRG