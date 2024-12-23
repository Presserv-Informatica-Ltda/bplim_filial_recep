
procedure imp_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: IMP_01F9.PRG
 \ Data....: 06-05-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: F¢rmula (processo falec.) a mostrar na tela de IMPPAR
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:57:21 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

IF base=[AFU]
 IF PTAB(LEFT(docto,9),[AFUNER],1)
  RETU AFUNER->falecido
 ENDIF
ENDI
IF base=[BXR]
 IF PTAB(LEFT(docto,8),[BXREC],1)
  RETU BXREC->codigo+[ ]+BXREC->tipo+[ ]+BXREC->circ+[ ]+;
       TRAN(BXREC->valorpg,"@E 999,999.99")
 ENDIF
ENDIF
IF base=[OBX]
 IF PTAB(LEFT(docto,8),[OBXEC],1)
  RETU OBXEC->codigo+[ ]+OBXEC->ref+[ ]+;
       TRAN(OBXEC->valorpg,"@E 999,999.99")
 ENDIF
ENDIF

RETU [<<N„o encontrado>>]      // <- deve retornar um valor qualquer

* \\ Final de IMP_01F9.PRG