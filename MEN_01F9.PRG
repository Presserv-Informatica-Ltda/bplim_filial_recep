procedure men_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: MEN_01F9.PRG
 \ Data....: 20-10-99
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Fun‡„o F8 do campo FILTRO, arquivo MENSAG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
sit_dbf:=POINTER_DBF()
crit_ant:=criterio
auxiliar=space(210)
PTAB([],[GRUPOS],1,.T.)
SELE GRUPOS
filtra(.F.)
auxiliar=criterio+[~TRUE]
criterio :=crit_ant
POINTER_DBF(sit_dbf)
RETU auxiliar       // <- deve retornar um valor qualquer

* \\ Final de MEN_01F9.PRG
