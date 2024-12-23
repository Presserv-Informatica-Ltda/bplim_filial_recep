/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: DCI01F9.PRG
 \ Data....: 29-08-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Fun‡„o F8 da variavel DOCTO, relatorio DCI_P001
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
priva donedci:=[]
IF tipdoc=[BXR]
 donedci:=VDBF(6,20,20,77,'BXREC',{'ano','numero','codigo','tipo','circ','valorpg','emitido_'},1,'DCI02F9([BXR])',[])
ELSEIF tipdoc=[OBX]
 donedci:=VDBF(6,4,20,77,'OBXEC',{'ano','numero','codigo','ref','valorpg','emitido_'},1,'DCI02F9([OBX])',[])
ELSEIF tipdoc=[AFU]
 donedci:=VDBF(6,3,20,77,'AFUNER',{'processo','proc2','filial','ocorr_','categ','contrato','falecido'},1,'DCI02F9([AFU])',[])
ELSEIF tipdoc=[BXF]
 donedci:=VDBF(6,23,20,77,'BXFCC',{'idfilial','numero','lancto_','cobrador','baixa_','vltaxas'},1,'DCI02F9([BXF])',[])
ELSEIF tipdoc=[CAD]
 donedci:=VDBF(6,3,20,77,'CADPROC',{'processo','proc2','filial','ocorr_','tippgto','valor','falecido'},1,'DCI02F9([CAD])',[])
ELSEIF tipdoc=[PCO]
 donedci:=VDBF(6,12,20,77,'PCOROAS',{'numero','nomesolic','processo'},1,'DCI02F9([PCO])',[])
ELSEIF tipdoc=[NFI]
 donedci:=VDBF(6,7,20,77,'NFISCAL',{'numeronf','processo','firma'},1,'DCI02F9([NFI])',[])
ELSEIF tipdoc=[REC]
 donedci:=VDBF(6,3,20,77,'RECIBOS',{'ano','numero','processo','valor','nome'},1,'DCI02F9([REC])',[])
ELSEIF tipdoc=[RCO]
 donedci:=VDBF(6,12,20,77,'RCOROAS',{'ano','numero','processo','nome'},1,'DCI02F9([RCO])',[])
ENDI
RETU M->donedci       // <- deve retornar um valor qualquer

FUNCTION dci02f9
PARA doneaux
IF doneaux=[BXR]
 RETU BXREC->ano+BXREC->numero
ELSEIF doneaux=[OBX]
 RETU OBXEC->ano+OBXEC->numero
ELSEIF doneaux=[AFU]
 RETU AFUNER->processo+AFUNER->proc2+AFUNER->filial
ELSEIF doneaux=[BXF]
 RETU BXFCC->idfilial+BXFCC->numero
ELSEIF doneaux=[CAD]
 RETU CADPROC->processo+CADPROC->proc2+CADPROC->filial
ELSEIF doneaux=[PCO]
 RETU PCOROAS->numero
ELSEIF doneaux=[NFI]
 RETU NFISCAL->numeronf
ELSEIF doneaux=[REC]
 RETU RECIBOS->ano+RECIBOS->numero
ELSEIF doneaux=[RCO]
 RETU RCOROAS->ano+RCOROAS->numero

ENDI
RETU []
* \\ Final de DCI01F9.PRG
