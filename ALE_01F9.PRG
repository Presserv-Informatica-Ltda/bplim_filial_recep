procedure ale_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: ALE_01F9.PRG
 \ Data....: 23-07-96
 \ Sistema.: Administradora de Funer�rias
 \ Funcao..: Valida��o do campo CODIGO, arquivo ALENDER
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistad
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
IF PTAB(codigo,'GRUPOS',1)
 M->dgrupo:=GRUPOS->grupo
 M->dendereco:=GRUPOS->endereco
 M->dbairro:=GRUPOS->bairro
 M->dcidade:=GRUPOS->cidade
 M->dcobrador:=GRUPOS->cobrador
 M->dcep:=GRUPOS->cep
 RETU .t.
ENDI

RETU .F. // <- deve retornar um valor L�GICO

* \\ Final de ALE_01F9.PRG
