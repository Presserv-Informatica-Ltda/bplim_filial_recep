procedure v02301f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: V02301F9.PRG
 \ Data....: 26-05-97
 \ Sistema.: Administradora - RECEP��O
 \ Funcao..: Valida��o da variavel CONFIRME, relatorio ADM_R023
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[OBX],[IMPPAR],1)
   ord_=LEN(sistema[EVAL(qualsis,"IMPPAR"),O_CHAVE])
   FAZ_LANC("IMPPAR",[ ])
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
   IMPPAR->base WITH [OBX]
  ENDI
   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[OBX],[IMPPAR],1)
    REPBLO('IMPPAR->docto',{||rnumero})
   ENDI

RETU .t.       // <- deve retornar um valor L�GICO

* \\ Final de V02301F9.PRG
