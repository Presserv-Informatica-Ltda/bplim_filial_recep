
procedure adm_r020
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADM_R020.PRG
 \ Data....: 22-09-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Impress„o Aux.Funeral 1
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \ Convert.: v5.0 em 2021081014:57:54 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=20, l_i:=13, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
so_um_reg=(PCOU()>2)
IF !so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+10 SAY " IMPRESSŽO AUX.FUNERAL "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Processo:"
 @ l_s+02,c_s+1 SAY " Confirme:"
ENDI
rproc=SPAC(11)                                     // Processo
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF !so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+12 GET  rproc;
                   PICT "@R 99999/9999-99";
                   VALI CRIT("!EMPT(RPROC).AND.PTAB(rproc,[AFUNER],1)~Campo utilizado para localiza‡„o dos documentos.|Tecle F8 para busca em tabela")
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
  IF LASTKEY()=K_ESC                               // se quer cancelar
   RETU                                            // retorna
  ENDI
 ENDI

 #ifdef COM_REDE
  IF !USEARQ("AFUNER",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("AFUNER")                                 // abre o dbf e seus indices
 #endi

 PTAB(contrato,"GRUPOS",1,.t.)                     // abre arquivo p/ o relacionamento
 PTAB(contrato,"INSCRITS",1,.t.)
 SET RELA TO contrato INTO GRUPOS,;                // relacionamento dos arquivos
          TO contrato INTO INSCRITS
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,1,11)           // nao quis configurar...
   CLOS ALL                                        // fecha arquivos e
   LOOP                                            // volta ao menu
  ENDI

 #ifdef COM_REDE

  ELSE

   tps=lin_menu

 #endi

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
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  IF so_um_reg
   GO imp_reg
  ELSE
   INI_ARQ()                                       // acha 1o. reg valido do arquivo
   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[AFU],[IMPPAR],1)
    PTAB(LEFT(IMPPAR->docto,11),'AFUNER',1)
   ENDI
  ENDI
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF().AND.(!so_um_reg.OR.imp_reg=RECN())
   #ifdef COM_TUTOR
    IF INKEY()=K_ESC                              // se quer cancelar
   #else
    IF INKEY()=K_ESC                               // se quer cancelar
   #endi
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF (PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[AFU],[IMPPAR],1).and.processo+proc2+filial+categ=ALLTRIM(IMPPAR->docto)) .OR. so_um_reg// se atender a condicao...
    PTAB(contrato+[1 0],[INSCRITS])
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,049 SAY "N§ do Processo"
    IMPCTL(drvpenf)
    @ cl,064 SAY TRAN(processo+proc2+filial,"@R 99999/99/!!")// Nr.Processo
    IMPCTL(drvtenf)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY "Contratante:"
    IMPCTL(drvpenf)
    @ cl,014 SAY TRAN(GRUPOS->nome,"@!")// Nome do contratante
    IMPCTL(drvtenf)
    @ cl,053 SAY "Docto:"
    @ cl,060 SAY GRUPOS->rg// rg contratante
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o...:",cl,001)
    @ cl,014 SAY TRAN(xDECRIPT(GRUPOS->endereco),"@!")       // Endereco contratante
    @ cl,055 SAY TRAN(xDECRIPT(GRUPOS->cidade),"@!")         // cidade contratante
//    @ cl,076 SAY TRAN(GRUPOS->estado,"!!")// Estado Contratante
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY "Contrato...:"
    IMPCTL(drvpenf)
    @ cl,014 SAY GRUPOS->grupo                     // grupo
    IMPCTL(drvtenf)
    @ cl,017 SAY contrato                          // contrato numero
    IMPAC("Admiss:",cl,028)
    @ cl,036 SAY GRUPOS->admissao                  // data admissao
    @ cl,047 SAY "Est.Civil:"
    @ cl,058 SAY TRAN(IIF(INSCRITS->(EOF()),[ ],subst(tbestciv,AT(INSCRITS->estcivil,tbestciv),10)),"@!")// Est.Civil contratante
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    IMPAC("Vem mui respeitosamente a presen‡a de V.S., atrav‚s deste,",cl,013)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY "requerer que se digne autorizar o pagamento da cota denominada AUXILIO"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("FUNERAL, conforme cl usulas contratuais no valor abaixo  especificado,",cl,001)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("e tamb‚m afirmar que estou ciente quanto as minhas responsabilidades na",cl,001)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("cobertura deste Aux¡lio recebido.",cl,001)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY "Valor em Reais....R$"
    IMPCTL(drvpenf)
    @ cl,021 SAY ALLTRIM(TRAN(vlauxilio,'@E 99,999,999.99'))// Valor
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,003 SAY [(]+SUBSTR(EXT(vlauxilio),1,AT('/',EXT(vlauxilio))-1)+[)]// Valor extenso
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,020 SAY "D A D O S   D O   F A L E C I D O"
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "Nome do falecido.......:"
    IMPCTL(drvpenf)
    @ cl,029 SAY TRAN(falecido,"@!")               // nome do falecido
    IMPCTL(drvtenf)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "End. do falecido.......:"
    @ cl,029 SAY TRAN(ALLTRIM(ruares)+[, ]+ALLTRIM(baires),"@!")// Endereco falecido
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "Cidade.................:"
    @ cl,029 SAY municfal                          // Cidade Falecimento
    @ cl,056 SAY "Estado:"
    @ cl,064 SAY TRAN(estfal,"!!")                 // UF falecimento
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "Local do Falecimento...:"
    @ cl,029 SAY ALLTRIM(ruafal)                   // local falecimento
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Cemit‚rio de sepulta/to:",cl,004)
    @ cl,029 SAY cemitsep                          // Cemit‚rio sepultamento
    @ cl,064 SAY "Horas:"
    @ cl,071 SAY TRAN(horasepult,"99:99")          // Hora sepultamento
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "Inscrito Contrato como.:"
    @ cl,029 SAY grauparcon                        // Inscrito na qualidade de
    @ cl,047 SAY "Faleceu em"
    @ cl,058 SAY DTOC(falecto_)+[, ]+horafal +[ hs]// obs.:
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,016 SAY "D O C U M E N T O S   A P R E S E N T A D O S"
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    IMPAC("1§.Certid„o de Nascimento ou Casamento do Falecido...:",cl,004)
    @ cl,059 SAY [S] //TRAN(doc1,"!")                    // Cert.nasc.
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("2§.Certid„o de ¢bito do Falecido.....................:",cl,004)
    @ cl,059 SAY [S] //TRAN(doc2,"!")                    // Cert.¢bito
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "3§.Nota Fiscal da Empresa que executou o Funeral.....:"
    @ cl,059 SAY [S] //TRAN(doc3,"!")                    // Nota Fiscal
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "4§.Recibo da Empresa que executou o Funeral..........:"
    @ cl,059 SAY [N] //TRAN(doc4,"!")                    // Recibo
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "5§.Taxa de Sepultamento ou Recibo da Prefeitura......:"
    @ cl,059 SAY [N] //TRAN(doc5,"!")                    // Taxa Sepult.
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "" //chr(15)                           // comprimir
    IMPCTL(drvpcom)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("DECLARA€ŽO - Declaro que me responsabilizo pelas declara‡”es aqui prestadas, CIENTE de que qualquer declara‡„o FALSA importa",cl,000)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("em responsabilidade criminal, nos termos do Artigo 299 do C¢digo Penal, declarando ainda que, se constatada a inexatid„o  das",cl,000)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("declara‡”es prestadas do compromisso ora assumido, al‚m de  obrigar a devolu‡„o compuls¢ria da importƒncia recebida indevidamente,",cl,000)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("sujeitar-me-ei  s penalidades previstas no artigo 171 do C¢digo Penal.",cl,000)
    @ cl,071 SAY "" //chr(18)                           // normal
    IMPCTL(drvtcom)
    @ cl,076 SAY "Data:"
    @ cl,082 SAY TRAN(DATE(),"@D")                 // data
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,000 SAY [PROCESSAR PAGAMENTO EM : ]+ DTOC(procpagto_)// processar pgto em
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,042 SAY REPL("-",30)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,042 SAY "Ass. do Requerente declarante"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",72)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPEXP(cl,000,[R E C I B O],24)                // R E C I B O
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY R02BP1F9()                        // recibo
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Data:"
    @ cl,006 SAY TRAN(DATE(),"@D")                 // data
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,042 SAY REPL("-",30)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,042 SAY "Ass. do Requerente declarante"
    SKIP                                           // pega proximo registro
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
   EJEC
   EXIT
  ENDD
 ENDD ccop
END SEQUENCE
SET PRINTER TO //(drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(1)                                           // grava variacao do relatorio
SELE AFUNER                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
IF so_um_reg
 POINTER_DBF(sit_dbf)
ENDI
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 @ 1,001 SAY TRAN(setup1,"@!")                     // Administradora
 @ 2,000 SAY REPL("-",72)
 @ 3,004 SAY "R E Q U E R I M E N T O   D E   A U X I L I O   F U N E R A L"

 nucop:=1

 @ 3,067 SAY STR(ccop-1,1)+[¦ Via]  // ccop contˆn o n£mero da via + 1.
 @ 4,000 SAY REPL("-",72)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADM_R020.PRG
FUNC R02BP1F9()
 LOCAL ar_db:=ALIAS(), ultreg, ord_ind
 LOCAL tit:=[Sra.], tit1:=[a]
 LOCAL li_:=PROW(), co_:=PCOL(), nrdec_:=[]

 li_aux:=space(1024)
 li_aux:=[Recebi da ]+ALLTRIM(M->setup1)+;
  [, a importƒncia supra de R$]+ALLTRIM(TRAN(vlauxilio,[@E 999,999.99]))+;
  [ (]+LEFT(EXT(vlauxilio),AT([/],EXT(vlauxilio))-1)+[)]
 li_aux+=[ referente ao AUXILIO FUNERAL por ocasi„o do falecimento acima mencionado ]+;
  [ conforme requerimento anexo.]
 li_aux+=CHR(13)+CHR(10)+[Para clareza legal, firmo o presente, da qual dou f‚.]
 li_m:=-1
 qli_m:=MLCOUNT(li_aux,70)-1                  // quantas linhas a imprimir?
 DO WHIL .t.                                     // imprime linhas do memo
  li_m++
  cl++
  IF li_m>qli_m                                  // fim do memo
   EXIT
  ENDI
  IMPMEMO(li_aux,70,1+li_m,cl,005,.t.)       // imprime...
  IF INKEY()=K_ESC                               // se quer cancelar
   IF canc()                                     // pede confirmacao
    BREAK                                        // confirmou...
   ENDI
  ENDI
 ENDD
 cl:=56
RETU [ ]       // <- deve retornar um valor qualquer