/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623.
 \ Programa: V00101F9.PRG
 \ Data....: 03-10-95
 \ Sistema.: Controle de Convˆnios
 \ Funcao..: Valida‡„o da variavel GNUMERO, relatorio CON_R001
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "ADRbig.ch"    // inicializa constantes manifestas

//PARAMETROS('pnumero',gnumero)

  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[GUI],[IMPPAR],1)
   ord_=LEN(sistema[EVAL(qualsis,"IMPPAR"),O_CHAVE])
   FAZ_LANC("IMPPAR",[ ])
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
	IMPPAR->base WITH [GUI]
  ENDI
   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[GUI],[IMPPAR],1)
    REPBLO('IMPPAR->docto',{||gnumero})
   ENDI

RETU .T.      // <- deve retornar um valor L¢GICO

* \\ Final de V00101F9.PRG
