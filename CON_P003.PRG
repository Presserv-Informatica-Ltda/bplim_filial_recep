procedure con_p003
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: CON_P003.PRG
 \ Data....: 31-12-98
 \ Sistema.: Controle de Convˆnios
 \ Funcao..: Contagem
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=8, c_s:=17, l_i:=16, c_i:=66, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+21 SAY " RANKING "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Contrato.: De:            At‚:"
@ l_s+02,c_s+1 SAY " Per¡odo..: De:            At‚:"
@ l_s+03,c_s+1 SAY " Regi„o...: "
@ l_s+04,c_s+1 SAY " Confirme:"
rde=CTOD('')                                       // De:
rate=CTOD('')                                      // At‚:
rregiao:=[000]
rcodi:=rcodf:=[      ]
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+17 GET  rcodi;
                  PICT "999999";
                  VALI CRIT("!EMPT(rcodi)~Informe o numero do menor contrato a considerar")

 @ l_s+01 ,c_s+33 GET  rcodf;
                  PICT "999999";
                  VALI CRIT("!EMPT(rcodf)~Informe o numero do maior contrato a considerar")

 @ l_s+02 ,c_s+17 GET  rde;
                  PICT "@D";
                  VALI CRIT("!EMPT(rde)~Necess rio informar a data inicial a considerar")
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data inicial a considerar"

 @ l_s+02 ,c_s+33 GET  rate;
                  PICT "@D";
                  VALI CRIT("!EMPT(rate)~Necess rio informar AT:")
                  DEFAULT "DATE()"
                  AJUDA "Informe a data final a considerar"

 @ l_s+03 ,c_s+17 GET  rregiao;
                  PICT "999";
                  VALI CRIT("!EMPT(rregiao)~Informe a regi„o a considerar")

 @ l_s+04 ,c_s+12 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme= 'S'~CONFIRME n„o aceit vel|Digite S ou Tecle ESC")
                  AJUDA "Digite S para confirmar |ou|Tecle ESC para cancelar"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
  RETU                                             // retorna
 ENDI
 EXIT
ENDD
cod_sos=1
msgt="CONTAGEM"
//ALERTA()
op_=1 //DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
// DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
  IF !USEARQ("MEDICOS",.t.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("MEDICOS")                                // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 SELE MEDICOS                                      // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF()

  #ifdef COM_REDE
   REPBLO('MEDICOS->numconta',{||[ ]})
  #else
   REPL MEDICOS->numconta WITH [          ]
  #endi

  SKIP                                             // pega proximo registro
 ENDD

 #ifdef COM_REDE
  IF !USEARQ("GUIAS",.F.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GUIAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(medico,"MEDICOS",1,.t.)                      // abre arquivo p/ o relacionamento
 PTAB(contrato,"GRUPOS",1,.t.)                      // abre arquivo p/ o relacionamento
 SET RELA TO medico INTO MEDICOS                   // relacionamento dos arquivos
 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 SELE GUIAS                                        // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF() .and. odometer()
  IF M->rcodi>[000000].and.contrato<M->rcodi
   SKIP
   LOOP
  ENDI
  IF M->rcodf>[000000].and.contrato>M->rcodf
   SKIP
   LOOP
  ENDI

  PTAB(contrato,"GRUPOS",1,.t.)                      // abre arquivo p/ o relacionamento
  IF M->rregiao>[000].and.GRUPOS->regiao#M->rregiao
   SKIP
   LOOP
  ENDI
  IF emissao_>=M->rde.and.emissao_<=M->rate        // se atender a condicao...
   SELE MEDICOS
   RLOCK()
   #ifdef COM_REDE
    REPBLO('MEDICOS->numconta',{||STR(VAL(MEDICOS->numconta)+1,6)})
   #else
    REPL MEDICOS->numconta WITH STR(VAL(MEDICOS->numconta)+1,6)
   #endi

   SELE GUIAS
   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 SELE GUIAS                                        // salta pagina
 SET RELA TO                                       // retira os relacionamentos
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)
// DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de CON_P003.PRG
