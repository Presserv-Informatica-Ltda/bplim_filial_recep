/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_R039.PRG
 \ Data....: 12-02-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Fechamento Caixa
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, lin_det:=[]
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=26, l_i:=14, c_i:=56, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                     // se usuario nao tem
 DBOX("Emiss„o negada, "+usuario,20)               // permissao, avisa
 RETU                                              // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+6 SAY " FECHAMENTO DE CAIXA "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Nr.Conta...:"
@ l_s+02,c_s+1 SAY " Fechamento.:"
nrconta=SPAC(10)                                   // Nr.Conta
emisini_=CTOD('')                                  // Lan‡to. inicial
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+15 GET  nrconta;
                  VALI CRIT("!EMPT(nrconta)~Necess rio informar NR.CONTA")
                  DEFAULT "M->usuario"
                  AJUDA "Informe a conta a fechar.|Tecle F8 para conta atual"
                  CMDF8 "IIF(EMPT(M->usuario),PADR(M->contarec+M->ide_maq,10,' '),PADR(M->usuario,10,' '))"

 @ l_s+02 ,c_s+15 GET  emisini_;
                  PICT "@D";
                  VALI CRIT("emisini_=DATE()~Deve ser exatamente a data de hoje |Data do sistema")
                  DEFAULT "DATE()"
                  AJUDA "Informe a data inicial"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
  RETU                                             // retorna
 ENDI

 #ifdef COM_REDE
	IF !USEARQ("ORDPGRC",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
	USEARQ("ORDPGRC")                                // abre o dbf e seus indices
 #endi

 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,9,11)            // nao quis configurar...
  CLOS ALL                                         // fecha arquivos e
  LOOP                                             // volta ao menu
 ENDI
 IF tps=2                                          // se vai para arquivo/video
  arq_=ARQGER()                                    // entao pega nome do arquivo
  IF EMPTY(arq_)                                   // se cancelou ou nao informou
   LOOP                                            // retorna
  ENDI
 ELSE
  arq_=drvporta                                    // porta de saida configurada
 ENDI
 SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("BXREC",.f.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("BXREC")                                   // abre o dbf e seus indices
#endi

cpord="numop+ano+numero"
INDTMP()

#ifdef COM_REDE
 IF !USEARQ("OBXEC",.f.,10,1)                      // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("OBXEC")                                   // abre o dbf e seus indices
#endi

cpord="numop+ano+numero"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE ORDPGRC
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
drvcut1="CHR(27)+'m'"               // corte parcial
drvcut2="CHR(27)+'w'"               // corte total

SET DEVI TO PRIN                                   // inicia a impressao
maxli=58                                           // maximo de linhas no relatorio
histpar:=M->histrcfcc+[,]+M->histrcrec+[,]+M->histrccar+[,]+M->histpg
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  tot019005 := 0                                   // inicializa variaves de totais
  DO WHIL !EOF()
   #ifdef COM_TUTOR
    IF IN_KEY()=K_ESC                              // se quer cancelar
   #else
    IF INKEY()=K_ESC                               // se quer cancelar
   #endi
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF numconta==M->nrconta.AND.EMPT(fechto_).AND.historico$histpar       // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(numop+R03001F9(),"999999")   // N§ OP.
    @ cl,007 SAY TRAN(origem,"!!!")                // Ori
    @ cl,011 SAY TRAN(historico,"999")             // Hist
    @ cl,016 SAY TRAN(debcred,"!")                 // D/C
    tot019005+=valortotal * IIF(debcred='C',1,-1)
    @ cl,019 SAY TRAN(valortotal * IIF(debcred='C',1,-1),"99999999.99")// Val Lan‡to
    @ cl,031 SAY TRAN(documento,"@!")              // Documento
    @ cl,044 SAY TRAN(complement,"@!")             // Complemento de Hist¢rico
    chv020=numop
    tot020005:=0
    SELE BXREC
    SEEK chv020
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=1                                         // soma contador de linha
     IMPCTL(drvpcom)                              // comprime os dados
     @ cl,002 SAY "Numero  Codigo Circ. Valor pago"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "========= ====== ===== =========="
     DO WHIL ! EOF() .AND. chv020=numop //LEFT(&(INDEXKEY(0)),LEN(chv020))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      lin_det+=TRAN(ano,"99")+'-'+;                  // Ano
	       TRAN(numero,"999999")+' '+;           // Numero
	       TRAN(codigo,"999999")+' '+;           // Codigo
	       tipo+'-'+circ+' '+;                   // Circular
	       TRAN(valorpg,"@E 9,999.99")+' | '   // Valor pago

      IF LEN(lin_det)> 5 //110
       REL_CAB(1)                                   // soma cl/imprime cabecalho
       @ cl,000 SAY lin_det
       lin_det:=[]
      ENDI
      tot020005+=valorpg
      SKIP                                         // pega proximo registro
     ENDD
     REL_CAB(1)                                   // soma cl/imprime cabecalho
//     @ cl,000 SAY lin_det
     lin_det:=[]
     IMPCTL(drvpcom)                               // comprime os dados
     @ ++cl,015 SAY REPL('-',10)
     @ ++cl,015 SAY TRAN(tot020005,"@E 999,999.99")// total Valor pago
     IMPCTL(drvpcom)                               // retira comprimido
     cl+=2                                         // soma contador de linha
    ENDI
    IMPCTL(drvpcom)                              // comprime os dados
    SELE ORDPGRC                                   // volta ao arquivo pai
    tot020004 := 0                                 // inicializa variaves de totais
    chv020=numop
    SELE OBXEC
    SEEK chv020
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     IMPCTL(drvpcom)                               // comprime os dados
     cl+=1                                         // soma contador de linha
     @ cl,001 SAY "Numero  Codig Valor pago Ref"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "======== ===== ========== ======================="
     IMPCTL(drvpcom)                               // retira comprimido
     DO WHIL ! EOF() .AND. chv020=numop //LEFT(&(INDEXKEY(0)),LEN(chv020))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      lin_det+=TRAN(ano,"99")+'-'+;                  // Ano
	       TRAN(numero,"999999")+' '+;           // Numero
	       TRAN(codigo,"999999")+' '+;           // Codigo
	       TRAN(valorpg,"@E 9,999.99")+' '+;   // Valor pago
	       ref+' | '
      IF LEN(lin_det) > 5 //110
       REL_CAB(1)                                   // soma cl/imprime cabecalho
       IMPCTL(drvpcom)                              // comprime os dados
       @ cl,000 SAY lin_det
       IMPCTL(drvpcom)                              // retira comprimido
       lin_det:=[]
      ENDI
      tot020004+=valorpg
      SKIP                                         // pega proximo registro
     ENDD
     REL_CAB(1)                                   // soma cl/imprime cabecalho
     IMPCTL(drvpcom)                              // comprime os dados
     @ cl,000 SAY lin_det
     IMPCTL(drvpcom)                              // retira comprimido
     lin_det:=[]
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     IMPCTL(drvpcom)                               // comprime os dados
     @ ++cl,015 SAY REPL('-',10)
     @ ++cl,015 SAY TRAN(tot020004,"@E 999,999.99")// total Valor pago
     IMPCTL(drvpcom)                               // retira comprimido
     cl+=1                                         // soma contador de linha
    ENDI
    SELE ORDPGRC                                   // volta ao arquivo pai
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,019 SAY REPL('-',11)
  @ ++cl,019 SAY TRAN(tot019005,"99999999.99")     // total Val Lan‡to
  exit
 ENDD ccop
 @ ++cl, 010 say [.]
 IMPCTL(drvcut2)
// EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(9)                                           // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|FECHAMENTO CAIXA"
ALERTA()
op_=1 //DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE ORDPGRC                                      // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF numconta==M->nrconta.AND.EMPT(fechto_)        // se atender a condicao...

   #ifdef COM_REDE
		IF EMPT(fechto_)
     REPBLO('ORDPGRC->fechto_',{||DATE()})
     REPBLO('ORDPGRC->fechpor',{||M->usuario})
    ENDI
   #else
    IF EMPT(fechto_)
     REPL ORDPGRC->fechto_ WITH DATE()
     REPL ORDPGRC->fechpor WITH M->usuario
    ENDI
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 drvautent:=.f.
 drvultval:=0
 drvultusu:=[]
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPCTL(drvpcom)
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,061 SAY "PAG"
 @ 0,065 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,061 SAY "ADM_R039"                            // c¢digo relat¢rio
 @ 2,000 SAY "FECHAMENTO DE CAIXA"
 @ 2,058 SAY NSEM(DATE())                          // dia da semana
 @ 2,066 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY M->nrconta+' '+titrel                                // t¡tulo a definir
 IMPAC("N§ OP. Ori Hist DC  Val Lan‡to Documento    Complemento de Hist¢rico",4,000)
 @ 5,000 SAY REPL("-",60)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R039.PRG
