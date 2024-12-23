
procedure v01801f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: V01801F9.PRG
 \ Data....: 26-05-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Valida‡„o da variavel CONFIRME, relatorio ADM_R018
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:56:28 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1)
   ord_=LEN(sistema[EVAL(qualsis,"IMPPAR"),O_CHAVE])
   FAZ_LANC("IMPPAR",[ ])
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
	IMPPAR->base WITH [BXR]
  ENDI
   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1)
    REPBLO('IMPPAR->docto',{||rnumero})
   ENDI

RETU .t.       // <- deve retornar um valor L¢GICO

* \\ Final de V01801F9.PRG