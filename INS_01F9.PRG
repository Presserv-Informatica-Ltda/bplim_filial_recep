
procedure ins_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: INS_01F9.PRG
 \ Data....: 21-11-94
 \ Sistema.: Controle da Organiza‡Æo
 \ Funcao..: Valor inicial do campo SEQ, arquivo INSCRITS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:57:57 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"   // inicializa constantes manifestas

IF (grau==[8] .AND. M->pgrau==[7]) .OR. grau<[7]
   M->pseq:=0
ENDIF
M->pgrau:=grau
M->pseq+=IIF(grau>[6],1,0)
RETU M->pseq

* \\ Final de INS_01F9.PRG