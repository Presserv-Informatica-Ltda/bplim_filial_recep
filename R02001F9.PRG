procedure r02001f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: R02001F9.PRG
 \ Data....: 23-07-96
 \ Sistema.: Administradora de Funer�rias
 \ Funcao..: recibo do relat�rio ADM_R020
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistad
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
 li_aux:=space(1024)
 li_aux:=[     O Contratante acima qualificado (ou seu representante legal) ]
 li_aux+=[vem mui respeitosamente � presen�a desta empresa ]
 li_aux+=ALLTRIM(M->setup1)+[, ]
 IF !EMPT(M->cgcsetup)
  li_aux+=[inscrita no CGC sob n� ]+TRAN(M->cgcsetup,"@R 99.999.999/9999-99")+[, ]
 ENDI
 li_aux+=[requerer que ]
 li_aux+=[se digne autorizar o pagamento da cota denominada RESTITUI��O ]
 li_aux+=[DE DESPESAS FUNERAIS, (conforme cl�usulas contratuais) ]
 li_aux+=[referente as respectivas notas fiscais e/ou recibos que est�o ]
 li_aux+=[anexados a este processo administrativo e que totalizam o valor ]
 li_aux+=[de ]+&drvpenf+[R$]+ALLTRIM(TRAN(vlauxilio,[@E 999,999.99]))+;
  [ (]+LEFT(EXT(vlauxilio),AT([/],EXT(vlauxilio))-1)+[)]+&drvtenf
 li_aux+=[ por ocasi�o do falecimento descrito abaixo: ]
RETU M->li_aux       // <- deve retornar um valor qualquer

* \\ Final de R02001F9.PRG
