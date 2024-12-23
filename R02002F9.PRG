procedure r02002f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R02002F9.PRG
 \ Data....: 22-09-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: DECLARACAO do relat¢rio ADM_R020
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
li_aux:=[]
li_aux+=[     O Contratante (ou representante legal) responsabiliza-se pelas ]
li_aux+=[declara‡”es aqui prestadas e est  CIENTE de que qualquer informa‡„o FALSA ]
li_aux+=[importar  em responsabilidade criminal, nos termos do Artigo 299 do C¢digo ]
li_aux+=[Penal. Outrossim declara que tamb‚m est  ciente de que cada funeral d  o ]
li_aux+=[direito de REQUERER somente uma vez a referida Restitui‡„o de Despesas Funerais, ]
li_aux+=[e que n„o poder  existir nenhum outro requerimento feito com ]
li_aux+=[rela‡„o a este falecimento, nem por este contratante e nem por seus ]
li_aux+=[familiares, nem neste e nem em outro CONTRATO ]
li_aux+=[desta Organiza‡„o. Por fim, declara ainda que, se constatada a inexatid„o ]
li_aux+=[ou fraude nas informa‡”es aqui prestadas, al‚m de obrigar-se … devolu‡„o ]
li_aux+=[das importƒncias recebidas INDEVIDAMENTE, sujeitar-se-   s penalidades ]
li_aux+=[previstas no artigo 171 do C¢digo Penal.]

RETU M->li_aux      // <- deve retornar um valor qualquer

* \\ Final de R02002F9.PRG
