procedure dci_p001
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: DCI_P001.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Documento … Imprimir
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/#include "adrbig.ch"    // inicializa constantes manifestas

PRIV dele_atu, cur_atual, getlist:={}
PARA lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=8, c_s:=12, l_i:=12, c_i:=65, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+16 SAY " DOCUMENTO A IMPRIMIR "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Tipo..:"
@ l_s+02,c_s+1 SAY " N£mero:"
PRIV tipdoc:=SPAC(3)                               // Tipo
PRIV docto:=SPAC(12)                               // Documento
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
// IMP_FORM({"LEFT(TRAN(DCI03F9(M->tipdoc),[]),35)", 1 , 14 })
// IMP_FORM({"LEFT(TRAN(DCI04F9(M->tipdoc),[]),50)", 3 , 2 })
 @ l_s+01 ,c_s+10 GET  tipdoc;
                  PICT "!!!";
                  WHEN "MTAB([BXR-Recebimentos|OBX-Outros recebimentos|AFU-Aux¡lio Funeral],[TIPO])"
                  DEFAULT "[BXR]"
                  AJUDA "Informe o tipo do documento a imprimir|Tecle F8 para tabela auxiliar."
                  CMDF8 "MTAB([BXR-Recebimentos|OBX-Outros recebimentos|AFU-Aux¡lio Funeral],[TIPO])"

 @ l_s+02 ,c_s+10 GET  docto;
                  WHEN "DCI01F9()"
                  DEFAULT "IIF(PTAB(PADR(SUBSTR(M->ide_maq,2),4)+tipdoc,[IMPPAR],1),IMPPAR->docto,[ ])"
                  AJUDA "Digite neste campo o n£mero de|identifica‡„o do documento|(N„o utilize barras nem tra‡os)"
                  CMDF8 "DCI01F9()"

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
cur_atual=SETCURSOR(0)
cod_sos=1
msgp="DOCUMENTO A IMPRIMIR"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgp)
IF op_=1
 POE_GAUGE("Processando registros","AGUARDE!","Feitos:")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
  IF !USEARQ("CLASSES",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("CLASSES")                                // abre o dbf e seus indices
 #endi

 cpord=""
 criterio=""
 chv_rela:=chv_1:=chv_2 := ""

 #ifdef COM_REDE
  IF !USEARQ("IMPPAR",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("IMPPAR")                                 // abre o dbf e seus indices
 #endi

 SELE CLASSES                                      // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().AND.POE_GAUGE()
  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+M->tipdoc,[IMPPAR],1)
   SELE IMPPAR                                     // arquivo alvo do lancamento

   #ifdef COM_REDE
    DO WHIL .t.
     APPE BLAN                                     // tenta abri-lo
     IF NETERR()                                   // nao conseguiu
      DBOX(ms_uso,20)                              // avisa e
      LOOP                                         // tenta novamente
     ENDI
     EXIT                                          // ok. registro criado
    ENDD
   #else
    APPE BLAN                                      // cria registro em branco
   #endi

   SELE CLASSES                                    // inicializa registro em branco
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
        IMPPAR->base WITH M->tipdoc,;
        IMPPAR->docto WITH M->docto

   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

  ENDI

  #ifdef COM_REDE
   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+M->tipdoc,[IMPPAR],1)
    REPBLO('IMPPAR->docto',{||M->docto})
   ENDI
  #else
   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+M->tipdoc,[IMPPAR],1)
    REPL IMPPAR->docto WITH M->docto
   ENDI
  #endi

  SKIP                                             // pega proximo registro
 ENDD
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgp)
ENDI
SETCURSOR(cur_atual)
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de DCI_P001.PRG
