
procedure sin_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: SIN_01F9.PRG
 \ Data....: 31-03-97
 \ Sistema.: Seguros
 \ Funcao..: Valida‡„o do campo NASCTO_, arquivo SINSCRIT
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:57:47 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
PRIV idmes
idmes := (YEAR(DATE()) - YEAR(nascto_))*12
idmes += (MONTH(DATE()) - MONTH(nascto_))

IF op_menu=1.AND.!EMPT(nascto_) .AND. idmes > (60*12)
 DBOX([Inscrito com ]+STR(INT(idmes/12),2)+[ anos completos])
ENDI

RETU .T.       // <- deve retornar um valor L¢GICO

* \\ Final de SIN_01F9.PRG