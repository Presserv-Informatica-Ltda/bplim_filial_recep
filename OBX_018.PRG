procedure obx_018
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind�stria de Urnas Bignotto Ltda
 \ Programa: BXR_018.PRG
 \ Data....: 07-12-95
 \ Sistema.: Administradora de Funer�rias
 \ Funcao..: Rotina avulsa (Emiss�o do Recibo)
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas

/*
   Nivelop = Nivel de acesso do usuario (1=operacao, 2=manutencao e
   3=gerencia)
*/
IF nivelop < 1          // se usuario nao tem
 ALERTA()               // permissao, avisa
 DBOX(msg_auto,,,3)     // e retorna
 RETU
ENDI
/*
  Emite o recibo
*/
ADM_R033(3,10)
RETU

* \\ Final de BXR_018.PRG
