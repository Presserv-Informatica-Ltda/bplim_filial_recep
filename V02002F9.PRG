procedure v02002f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: V02002F9.PRG
 \ Data....: 26-05-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Valida‡„o da variavel CONFIRME, relatorio ADM_R020
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[AFU],[IMPPAR],1)
   ord_=LEN(sistema[EVAL(qualsis,"IMPPAR"),O_CHAVE])
   FAZ_LANC("IMPPAR",[ ])
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
   IMPPAR->base WITH [AFU]
  ENDI
   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[AFU],[IMPPAR],1)
    REPBLO('IMPPAR->docto',{||AFUNER->processo+AFUNER->proc2+AFUNER->filial+AFUNER->categ})
   ENDI

RETU .t.       // <- deve retornar um valor L¢GICO

* \\ Final de V02002F9.PRG
