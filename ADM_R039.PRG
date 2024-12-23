
procedure adm_r039
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADM_R039.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Fechamento Caixa
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \ Convert.: v5.0 em 2021081014:57:46 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PRIV dele_atu, cur_atual, getlist:={}, lin_det:=[]
PARA lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=09, c_s:=26, l_i:=15, c_i:=56, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                     // se usuario nao tem
 DBOX("Emiss„o negada, "+usuario,20)               // permissao, avisa
 RETU                                              // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+6 SAY " TRANSF.FINANCEIRO "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Nr.Conta...:"
@ l_s+02,c_s+1 SAY " Fechamento.:"
@ l_s+03,c_s+1 SAY " Segunda Via:"
PRIV nrconta:=SPAC(10)                             // Nr.Conta
PRIV emisini_:=CTOD('')                            // Lan‡to. inicial
PRIV ehsegvia:=[N]
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
		  VALI CRIT("emisini_<=DATE()~Deve ser menor ou igual a data de hoje |Data do sistema")
      DEFAULT "DATE()"
      AJUDA "Informe a data inicial"

 @ l_s+03 ,c_s+15 GET  ehsegvia;
		  PICT "!";
		  VALI CRIT("ehsegvia$[SN]~Digite Sim ou Nao")
      DEFAULT "N"
      AJUDA "Digite S para listar os caixas de hoje"

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

 titrel:=criterio := ""                            // inicializa variaveis
 cpord=""
 chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 fil_ini=""
 IF !opcoes_rel(lin_menu,col_menu,12,11,fil_ini)   // nao quis configurar...
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
 IF "4WIN"$UPPER(drvmarca) // nome da configuracao/marca impressora
    arq_:=drvdbf+"WIN"+ide_maq
    tps:=3                                          // se vai para arquivo/video
 ENDIF
 SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
cur_atual=SETCURSOR(0)
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

cpord="numop+numero"
criterio=""
INDTMP()
#ifdef COM_REDE
 IF !USEARQ("OBXEC",.f.,10,1)                      // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("OBXEC")                                   // abre o dbf e seus indices
#endi

cpord="numop+numero"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE ORDPGRC
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
POE_GAUGE("[ESC] Interrompe","AGUARDE...","Emitidos:")
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=50000
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  IF EOF()
   EXIT
  ENDI
  ccop++                                           // incrementa contador de copias
  tot025005 := 0                                   // inicializa variaves de totais
  DO WHIL !EOF().AND.POE_GAUGE()
   IF INKEY()=K_ESC                               // se quer cancelar
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF numconta==M->nrconta.AND.;
      (EMPT(fechto_).and.ehsegvia#[S]).or.;
      (ehsegvia=[S].AND.fechto_=emisini_) // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(numop+R03001F9(),"999999")   // N§ OP.
    @ cl,007 SAY TRAN(origem,"!!!")                // Ori
    @ cl,011 SAY TRAN(historico,"999")             // Hist
    @ cl,016 SAY TRAN(debcred,"!")                 // D/C
    tot025005+=valortotal * IIF(debcred='C',1,-1)
    @ cl,019 SAY TRAN(valortotal * IIF(debcred='C',1,-1),"99999999.99")// Val Lan‡to
    @ cl,031 SAY TRAN(documento,"@!")              // Documento
    @ cl,044 SAY TRAN(LEFT(complement,20),"@!")             // Complemento de Hist¢rico
    @ cl,065 SAY DTOC(ORDPGRC->fechto_)
    chv026=numop
    SELE BXREC
    SEEK chv026
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=1                                         // soma contador de linha
     IMPCTL(drvpcom)                              // comprime os dados
     @ cl,002 SAY "Numero  Codigo Circ. Valor pago"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "========= ================== =========="
     DO WHIL ! EOF() .AND. chv026=numop //LEFT(&(INDEXKEY(0)),LEN(chv026)).AND.POE_GAUGE()
      IF INKEY()=K_ESC                            // se quer cancelar
       IF canc()                                   // pede confirmacao
	BREAK                                      // confirmou...
       ENDI
      ENDI
      lin_det+=TRAN(numero,"@R 99-999999")+;           // Numero
	       [ ]+LEFT(cobranca,15)+;      // Codigo
	       TRAN(valorpg,"@E 9,999.99")+[ ]   // Valor pago

      IF LEN(lin_det)>100
       REL_CAB(1)                                   // soma cl/imprime cabecalho
       @ cl,000 SAY lin_det
       lin_det:=[]
      ENDI
      SKIP                                         // pega proximo registro
     ENDD
    ENDI
    IF !EMPT(lin_det)
     REL_CAB(1)                                   // soma cl/imprime cabecalho
     @ cl,000 SAY lin_det
     lin_det:=[]
    ENDI
    IMPCTL(drvTcom)                              // comprime os dados
    cl++
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
       IF INKEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      lin_det+=TRAN(numero,"99-999999")+' '+;           // Numero
	       TRAN(codigo,"@!")+' '+;           // Codigo
	       TRAN(valorpg,"@E 9,999.99")+' '+;   // Valor pago
	       cobranca+' | '
      IF LEN(lin_det)>100
       REL_CAB(1)                                   // soma cl/imprime cabecalho
       IMPCTL(drvpcom)                              // comprime os dados
       @ cl,000 SAY lin_det
       IMPCTL(drvtcom)                              // retira comprimido
       lin_det:=[]
      ENDI
      tot020004+=valorpg
      SKIP                                         // pega proximo registro
     ENDD
     REL_CAB(1)                                   // soma cl/imprime cabecalho
     IMPCTL(drvpcom)                              // comprime os dados
     @ cl,000 SAY lin_det
     IMPCTL(drvtcom)                              // retira comprimido
     lin_det:=[]
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     IMPCTL(drvpcom)                               // comprime os dados
     @ ++cl,015 SAY REPL('-',10)
     @ ++cl,015 SAY TRAN(tot020004,"@E 999,999.99")// total Valor pago
     IMPCTL(drvtcom)                               // retira comprimido
     cl+=3                                         // soma contador de linha
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
  @ ++cl,019 SAY TRAN(tot025005,"99999999.99")     // total Val Lan‡to
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SETCURSOR(cur_atual)
SET PRINTER TO //(drvporta)                        // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI          // mostra o arquivo gravado
GRELA(12)                                          // grava variacao do relatorio
msgp="PROCESSAMENTOS DO RELAT¢RIO|FECHAMENTO CAIXA"
POE_GAUGE("Processando registros","AGUARDE!","Feitos:")
SET(_SET_DELETED,.t.)                              // os excluidos nao servem...
SELE ORDPGRC                                       // processamentos apos emissao
INI_ARQ()                                          // acha 1o. reg valido do arquivo
DO WHIL !EOF().AND.POE_GAUGE().AND.!(ehsegvia=[S])
 IF numconta==M->nrconta.AND.EMPT(fechto_)         // se atender a condicao...

   IF EMPT(fechto_)
    do while !rlock()
	endd
    REPL fechto_ with DATE(), fechpor with M->usuario
   ENDI

  SELE ORDPGRC                                     // volta ao arquivo pai
  SKIP                                             // pega proximo registro
 ELSE                                              // se nao atende condicao
  SKIP                                             // pega proximo registro
 ENDI
ENDD
SET(_SET_DELETED,.f.)                              // os excluidos serao vistos
SELE BXREC                                         // arquivo origem do processamento

SET(_SET_DELETED,.t.)
ALERTA(2)
DBOX("Processo terminado com sucesso!",,,,,msgp)
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,070 SAY "PAG"
 @ 0,074 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,070 SAY "ADM_R039"                            // c¢digo relat¢rio
 @ 2,000 SAY "TRANSF.FINANCEIRO"
 @ 2,061 SAY NSEM(DATE())                          // dia da semana
 @ 2,069 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY ALLtrim(titrel)+[ Conta:]+M->nrconta   // t¡tulo a definir
 IMPAC("N§ OP. Ori Hist DC  Val Lan‡to Documento    Complemento Hist¢rico Fechto.",4,000)
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R039.PRG
