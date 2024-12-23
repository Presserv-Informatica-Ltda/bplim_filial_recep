
procedure kinscf9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: KINSCF9.PRG
 \ Data....: 19-08-95
 \ Sistema.: Controle de Processos da Funer ria V.á
 \ Funcao..: Fun‡„o F8 do campo CODDECL, arquivo CADPROC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:57:30 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

RETU INSCRITS->codigo //+INSCRITS->grau+STR(INSCRITS->seq,02,00)

* \\ Final de KINSCF9.PRG