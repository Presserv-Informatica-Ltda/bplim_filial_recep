
procedure v03301f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: V03301F9.PRG
 \ Data....: 07-11-96
 \ Sistema.: Administradora -CRêD/COBRANÄA
 \ Funcao..: ValidaáÑo da variavel CONFIRME, relatorio ADM_R033
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistad
 \ Convert.: v5.0 em 2021081014:57:58 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
   PARAMETROS(dbfparam,'mcodigo',rcodigo)
   PARAMETROS(dbfparam,'mcirc',rcirc)
RETU .t.   // <- deve retornar um valor L¢GICO

* \\ Final de V03301F9.PRG