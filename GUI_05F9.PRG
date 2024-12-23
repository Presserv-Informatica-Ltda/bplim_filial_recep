/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: GUI_05F9.PRG
 \ Data....: 24-11-96
 \ Sistema.: Controle de Convˆnios
 \ Funcao..: Fun‡„o F8 do campo CONTRINSC, arquivo GUIAS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "ADRbig.ch"    // inicializa constantes manifestas

RETU INSCRITS->codigo+INSCRITS->grau+STR(INSCRITS->seq,2,0) // <- deve retornar um valor qualquer

* \\ Final de GUI_05F9.PRG
