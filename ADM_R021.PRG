procedure adm_r021
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADM_R021.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Processar Pgto em
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PRIV dele_atu, cur_atual, getlist:={}
PARA lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=20, l_i:=13, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+12 SAY " PROCESSAR PGTO EM "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Data Inicial:"
@ l_s+02,c_s+1 SAY " Data Final..:"
PRIV data1_:=CTOD('')                              // Data Inicial
PRIV data2_:=CTOD('')                              // Data Final
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+16 GET  data1_;
                  PICT "@D";
                  VALI CRIT("!EMPT(data1_)~Necess rio informar DATA INICIAL")
                  AJUDA "Considerar a partir de..."

 @ l_s+02 ,c_s+16 GET  data2_;
                  PICT "@D";
                  VALI CRIT("!EMPT(data2_)~Necess rio informar DATA FINAL")
                  AJUDA "At‚ a data ..."

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
  IF !USEARQ("AFUNER",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("AFUNER")                                 // abre o dbf e seus indices
 #endi

 titrel:=criterio := ""                            // inicializa variaveis
 cpord="DTOS(procpagto_)"
 chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 fil_ini=""
 IF !opcoes_rel(lin_menu,col_menu,7,11,fil_ini)    // nao quis configurar...
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
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
POE_GAUGE("[ESC] Interrompe","AGUARDE...","Emitidos:")
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
hora_rel_=LEFT(TIME(),5)                           // hora de emissao do relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=50000
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  IF EOF()
   EXIT
  ENDI
  ccop++                                           // incrementa contador de copias
  qqu018=0                                         // contador de registros
  DO WHIL !EOF().AND.POE_GAUGE()
   IF IN_KEY()=K_ESC                               // se quer cancelar
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF procpagto_>=M->data1_.AND.procpagto_<=M->data2_// se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(processo+proc2+filial,"@R 99999/99/!!")   // Processo
    @ cl,012 SAY TRAN(procpagto_,"@D")             // Proc.Pgto em
    @ cl,023 SAY TRAN(vlauxilio,"9999999.99")  // Valor Auxilio
    @ cl,038 SAY TRAN(falecido,"@!")               // Nome do falecido
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,011 SAY TRAN(nomedec,"@!")                // Nome
    @ cl,053 SAY TRAN(contrato,"@R 999.999999")           // Contrato
    @ cl,065 SAY TRAN(pagtoem_,"@D")               // Pago em
    qqu018++                                       // soma contadores de registros
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu018,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SETCURSOR(cur_atual)
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI          // mostra o arquivo gravado
GRELA(7)                                           // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,065 SAY "PAG"
 @ 0,069 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,065 SAY "ADM_R021"                            // c¢digo relat¢rio
 @ 2,000 SAY titrel                                // t¡tulo a definir
 @ 2,058 SAY DTOC(DATE())                          // data do sistema
 @ 2,068 SAY hora_rel_                             // hora da emiss„o
 @ 3,000 SAY "Processo Proc.Pgto em  Valor Auxilio  Nome do falecido"
 @ 4,011 SAY "Nome do Declarante                       Contrato   Pago em"
 @ 5,000 SAY REPL("-",73)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R021.PRG
