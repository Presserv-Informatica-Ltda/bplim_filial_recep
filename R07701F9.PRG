
procedure r07701f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: R07701F9.PRG
 \ Data....: 26-12-97
 \ Sistema.: Administradora -CRD/COBRAN€A
 \ Funcao..: Express„o de filtro do relat¢rio ADC_R077.PRG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:58:28 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adRbig.ch"    // inicializa constantes manifestas
donex:=(M->pag=[S].AND.TAXAS->valorpg>0)
donex:=donex.OR.(M->pend=[S].AND.TAXAS->valorpg=0)
//donex:=donex.AND.(EMPT(M->veni_).OR.TAXAS->emissao_>=M->veni_)
donex:=donex.AND.(EMPT(M->venf_).OR.TAXAS->emissao_<=M->venf_)

RETU M->donex       // <- deve retornar um valor L¢GICO

* \\ Final de R07701F9.PRG