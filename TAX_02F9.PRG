procedure tax_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: TAX_02F9.PRG
 \ Data....: 22-11-96
 \ Sistema.: Administradora - RECEP��O
 \ Funcao..: F�rmula (Status) a mostrar na tela de TAXAS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

DO CASE
 CASE TAXAS->stat = [1]
  RETU [Gerada  ]
 CASE TAXAS->stat = [2]
  RETU [Impressa]
 CASE TAXAS->stat = [6]
  RETU [BxRecep�]
 CASE TAXAS->stat = [7]
  RETU [Bx FCC  ]
 CASE TAXAS->stat = [9]
  RETU [Bx Plano]
ENDC
RETU [        ]       // <- deve retornar um valor qualquer

* \\ Final de TAX_02F9.PRG
