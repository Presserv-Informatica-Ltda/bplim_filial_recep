
procedure dci03f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: DCI03F9.PRG
 \ Data....: 29-08-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: F¢rmula (Tipo do docto) a mostrar na tela de DCI_P001
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:56:49 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
PARA tipdoc
PRIVA donex:=[ ]
DO CASE
// ADRBIG - Programa da Recepcao
 CASE tipdoc= [BXR]
  donex:=[Baixa na Recep‡„]
 CASE tipdoc= [OBX]
  donex:=[Outros recebimentos]
 CASE tipdoc= [AFU]
  donex:=[Aux¡lio Funeral]

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

RETU       // <- deve retornar um valor qualquer

* \\ Final de DCI03F9.PRG