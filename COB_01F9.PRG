
procedure cob_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: COB_01F9.PRG
 \ Data....: 17-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Fun‡„o F8 do campo COBRADOR, arquivo COBRADOR
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:58:02 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

 rcodin:=[001]

 DO WHILE PTAB(M->rcodin,[COBRADOR],1)
  rcodin:=sTRzero(VAL(rcodin)+1,3,0)
 ENDD

RETU M->rcodin       // <- deve retornar um valor qualquer

* \\ Final de COB_01F9.PRG