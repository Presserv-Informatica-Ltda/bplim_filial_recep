procedure r00201f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: R00201F9.PRG
 \ Data....: 24-12-95
 \ Sistema.: Administradora de Funer�rias
 \ Funcao..: Pr�-valida��o da variavel RECMENSAG, relaotiro ADM_R002
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas
priva doneaux:=[]
DO CASE
 CASE GRUPOS->situacao!=[1]
  doneaux:=[Cancelado]
 CASE GRUPOS->qtcircs>=(GRUPOS->funerais+1)*ARQGRUP->qtdremir
  doneaux:=[Remido]
 CASE RIGHT(GRUPOS->saitxa,2)+LEFT(GRUPOS->saitxa,2)>RIGHT(CIRCULAR->mesref,2)+LEFT(CIRCULAR->mesref,2)
  doneaux:=[SaiTxa > Emissao]
ENDCASE

RETU doneaux      // <- retorna vazio se contrato em codic�es de emiss�o.

* \\ Final de R00201F9.PRG
