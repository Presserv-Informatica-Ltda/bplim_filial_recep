
procedure rec_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: REC_01F9.PRG
 \ Data....: 14-11-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Valida‡„o do campo ENDERECO, arquivo RECIBOS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:58:08 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas


   PARAMETROS(dbfparam,'impnrrec',numero)
   PARAMETROS(dbfparam,'mproc1',LEFT(processo,5))
   PARAMETROS(dbfparam,'mproc2',RIGHT(processo,2))
RETU .T.  // <- deve retornar um valor L¢GICO

* \\ Final de REC_01F9.PRG