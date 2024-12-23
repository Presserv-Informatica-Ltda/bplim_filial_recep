
procedure gui_05f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: GUI_05F9.PRG
 \ Data....: 24-11-96
 \ Sistema.: Controle de Convˆnios
 \ Funcao..: Fun‡„o F8 do campo CONTRINSC, arquivo GUIAS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:58:28 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "ADRbig.ch"    // inicializa constantes manifestas

RETU INSCRITS->codigo+INSCRITS->grau+STR(INSCRITS->seq,2,0) // <- deve retornar um valor qualquer

* \\ Final de GUI_05F9.PRG