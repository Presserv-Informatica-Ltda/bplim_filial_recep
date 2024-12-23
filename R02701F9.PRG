
procedure r02701f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: R02701F9.PRG
 \ Data....: 24-12-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: motivo do relat¢rio ADM_R027 // N„o impress„o do recibo
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:57:53 Fase_01
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

RETU doneaux      // <- retorna vazio se contrato em codic”es de emiss„o.

* \\ Final de R02701F9.PRG