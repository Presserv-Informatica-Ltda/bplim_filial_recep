
procedure adm_r026
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADM_R026.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Capa de Processo
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \ Convert.: v5.0 em 2021081014:57:54 Fase_01
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
@ l_s,c_s+10 SAY " IMPRESSŽO AUX.FUNERAL "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Processo:"
@ l_s+02,c_s+1 SAY " Confirme:"
PRIV rproc:=SPAC(11)                               // Processo
PRIV confirme:=SPAC(1)                             // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  rproc;
                  PICT "@R 99999/9999-99";
                  VALI CRIT("!EMPT(RPROC).AND.PTAB(M->rproc,[AFUNER],1)~Campo utilizado para localiza‡„o dos documentos.|Tecle F8 para busca em tabela")
                  DEFAULT "IIF(PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[AFU],[IMPPAR],1),ALLTRIM(IMPPAR->docto),[])"
                  AJUDA "Digite neste campo o n£mero de|identifica‡„o do processo"
                  CMDF8 "VDBF(6,12,20,77,'AFUNER',{'processo','proc2','categ','contrato','falecido'},1,'V02001F9()',[])"

 @ l_s+02 ,c_s+12 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'.AND.V02002F9()~CONFIRME n„o aceit vel|Digite S para confirmar|ou|Tecle ESC para cancelar")
                  AJUDA "Digite S para confirmar|ou|tecle ESC para cancelar"

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

 PTAB(contrato,"GRUPOS",1,.t.)                     // abre arquivo p/ o relacionamento
 PTAB(funcresp,"FNCS",1,.t.)
 PTAB(GRUPOS->tipcont,"CLASSES",1,.t.)
 SET RELA TO contrato INTO GRUPOS,;                // relacionamento dos arquivos
          TO funcresp INTO FNCS,;
          TO GRUPOS->tipcont INTO CLASSES
 titrel:=criterio := ""                            // inicializa variaveis
 cpord=""
 chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 fil_ini=""
 IF !opcoes_rel(lin_menu,col_menu,6,11,fil_ini)    // nao quis configurar...
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
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura‡„o do tamanho da p gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_050=LEFT(drvtapg,op_-1)+"050"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_050:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
POE_GAUGE("[ESC] Interrompe","AGUARDE...","Emitidos:")
SET DEVI TO PRIN                                   // inicia a impressao
maxli=65                                           // maximo de linhas no relatorio
IMPCTL(lpp_050)                                    // seta pagina com 50 linhas
IMPCTL(drvpde8)                                    // ativa 8 lpp
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=50000
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  IF EOF()
   EXIT
  ENDI
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF().AND.POE_GAUGE()
   IF INKEY()=K_ESC                               // se quer cancelar
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[AFU],[IMPPAR],1).and.processo+proc2+filial+categ=ALLTRIM(IMPPAR->docto)// se atender a condicao...
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,060 SAY TRAN(processo+proc2+filial,"@R 99999/99/!!")// N£mero Processo
    REL_CAB(12)                                    // soma cl/imprime cabecalho
    @ cl,011 SAY TRAN(falecido,"@!")               // Nome do falecido
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,011 SAY ALLTRIM(ruares)+[ ]+ALLTRIM(baires)+'-'+ALLTRIM(munres)// endereco (falecido)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,019 SAY TRAN(falecto_,"@D")               // Data falcto.
    @ cl,056 SAY TRAN(horafal,"99:99")             // Hora Falcto.
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,019 SAY TRAN(ALLTRIM(ruafal),"@!")        // Rua Falecimento
    REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,012 SAY TRAN(nomedec,"@!")                // Declarante
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,012 SAY ALLTRIM(ruadec)                   // endereco (declarante)
    @ cl,056 SAY fonedec                           // fone declarante
    REL_CAB(11)                                    // soma cl/imprime cabecalho
    @ cl,012 SAY CLASSES->descricao                // tipo de plano
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,025 SAY IIF(categ=[PD],[Plano c/Difer. ],IIF(categ=[PL],[Atend.Plano],[Auxilio Funeral  ]))// Categoria
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,012 SAY FNCS->nome                        // Motorista respons vel
    @ cl,050 SAY TRAN(contrato,"@R 999.999999")           // CONTRATO
    @ cl,066 SAY IIF(CLASSES->prior=[S],M->mgrupvip,GRUPOS->grupo)// GRUPO
    REL_CAB(13)                                    // soma cl/imprime cabecalho
    @ cl,015 SAY TRAN(cemitsep,"@!")               // Cemit‚rio Sepultamento
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,021 SAY horasepult                        // hora sepultamento
    IF !EMPT(sepult_)                              // pode imprimir?
     @ cl,058 SAY DTOC(sepult_)                    // data sepultamento
    ENDI
    SKIP                                           // pega proximo registro
    cl=50000                                       // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SETCURSOR(cur_atual)
IMPCTL(drvtde8)                                    // ativa 6 lpp
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO //(drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI          // mostra o arquivo gravado
GRELA(6)                                           // grava variacao do relatorio
SELE AFUNER                                        // seleciona arquivo
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R026.PRG