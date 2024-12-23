/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: DCI04F9.PRG
 \ Data....: 29-08-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: F¢rmula (Descr.Documento) a mostrar na tela de DCI_P001
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
PARA tipdoc
PRIVA donex:=[]
DO CASE
// ADRBIG - Programa da Recepcao
 CASE tipdoc= [BXR]
 IF PTAB(ALLTRIM(docto),[BXREC],1)
  RETU BXREC->codigo+[ ]+BXREC->tipo+[-]+BXREC->circ+TRAN(BXREC->valorpg,[999999.99])
 ENDIF
 CASE tipdoc= [OBX]
 IF PTAB(ALLTRIM(docto),[OBXEC],1)
  RETU OBXEC->codigo+[ ]+OBXEC->ref+TRAN(OBXEC->valorpg,[999999.99])
 ENDIF
 CASE tipdoc= [AFU]
 IF PTAB(ALLTRIM(docto),[AFUNER],1)
  RETU AFUNER->ocorr_+[ ]+AFUNER->categ+[ ]+AFUNER->contrato+[ ]+AFUNER->falecido
 ENDIF

// ADCBIG - Programa de Credito e Cobran‡a
 CASE tipdoc= [BXF]
  donex:=[Baixa por FCC]

// CONBIG - Programa de Guias de convˆnio
 CASE tipdoc= [GUI]
  donex:=[Guia de Convˆnio]

// FUNBIG - Programa de Funer ria
 CASE tipdoc= [CAD]
  donex:=[Processo de Atendimento]
 CASE tipdoc= [PCO]
  donex:=[Pedido de Coroa]
 CASE tipdoc= [REC]
  donex:=[Recibo de Atendimento]
 CASE tipdoc= [RCO]
  donex:=[Recibo de Coroa]
 CASE tipdoc= [NFI]
  donex:=[Nota Fiscal]
OTHERWISE
 donex:=[N„o cadastrado]
ENDCASE

RETU M->donex     // <- deve retornar um valor qualquer

* \\ Final de DCI04F9.PRG
