
procedure v02001f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: V02001F9.PRG
 \ Data....: 26-05-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Pr‚-valida‡„o da variavel RPROC, relaotiro ADM_R020
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:57:56 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

RETU (AFUNER->processo+AFUNER->proc2+AFUNER->filial+AFUNER->categ)// <- deve retornar um valor L¢GICO

* \\ Final de V02001F9.PRG