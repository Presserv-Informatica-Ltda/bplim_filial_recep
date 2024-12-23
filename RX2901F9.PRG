
procedure rx2901f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: R02901F9.PRG
 \ Data....: 22-09-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: pedido do relat¢rio ADR_R029
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:57:51 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

 li_aux:=space(1024)
 li_aux:=[O Contratante acima qualificado (ou seu representante legal) ]
 li_aux+=[declara que recebeu de ]
 li_aux+=ALLTRIM(M->setup1)+[, ]
 IF !EMPT(M->cgcsetup)
  li_aux+=[inscrita no CGC sob n§ ]+TRAN(M->cgcsetup,"@R 99.999.999/9999-99")+[, ]
 ENDI
 li_aux+=[o ]+&drvpenf+[Pagamento/Atendimento Funeral]+&drvtenf+[,  ]
 li_aux+=[por ocasi„o do falecimento abaixo descrito, conforme ]
 li_aux+=[processo administrativo contendo requerimento e as ]
 li_aux+=[respectivas notas fiscais e/ou recibos, os quais totalizam ]
 li_aux+=[o valor de ]+&drvpenf+[R$]+ALLTRIM(TRAN(vlauxilio,[@E 999,999.99]))+;
  [ (]+LEFT(EXT(vlauxilio),AT([/],EXT(vlauxilio))-1)+[). ]+&drvtenf

RETU M->li_aux       // <- deve retornar um valor qualquer

* \\ Final de R02901F9.PRG