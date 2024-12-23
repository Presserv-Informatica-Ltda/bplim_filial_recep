procedure adr_rx29
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADR_RX29.PRG
 \ Data....: 22-09-97
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Recibo Aux.Funeral 1
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
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
 @ l_s,c_s+10 SAY " RECIBO AUX.FUNERAL 1 "
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
  IF !opcoes_rel(lin_menu,col_menu,4,11)           // nao quis configurar...
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
    IF IN_KEY()=K_ESC                              // se quer cancelar
   #else
    IF INKEY()=K_ESC                               // se quer cancelar
   #endi
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF (PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[AFU],[IMPPAR],1).and.processo+proc2+filial+categ=ALLTRIM(IMPPAR->docto)) .OR. so_um_reg// se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,054 SAY "Processo"
    IMPCTL(drvpenf)
    @ cl,063 SAY TRAN(processo+proc2+filial,"@R 99999/99/!!")// Nr.Processo
    IMPCTL(drvtenf)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,003 SAY "Nome do Contratante:"
    IMPCTL(drvpenf)
    @ cl,024 SAY TRAN(IIF(PTAB(contrato+GRUPOS->titular,'INSCRITS',1),INSCRITS->nome,GRUPOS->nome),"@!")// Nome do contratante
    IMPCTL(drvtenf)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o:",cl,003)
    IMPCTL(drvpenf)
    @ cl,013 SAY TRAN(xDECRIPT(GRUPOS->endereco),"@!")       // Endereco contratante
    IMPCTL(drvtenf)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY "Cidade               Estado  Documento de Identidade Estado Civil"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,005 SAY TRAN(xDECRIPT(GRUPOS->cidade),"@!")         // cidade contratante
    IMPCTL(drvtenf)
    @ cl,028 SAY TRAN([  ],"!!")                   // Estado Contratante
    IMPCTL(drvpenf)
    @ cl,037 SAY GRUPOS->rg                        // Doc
    IMPCTL(drvtenf)
    IMPCTL(drvpenf)
    @ cl,059 SAY TRAN(subst(tbestciv,AT(GRUPOS->estcivil,tbestciv),10),"@!")// Est.Civil contratante
    IMPCTL(drvtenf)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    IMPAC("Contrato    Grupo            Admiss„o                 Processo",cl,005)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,005 SAY contrato                          // contrato numero
    IMPCTL(drvtenf)
    IMPCTL(drvpenf)
    @ cl,018 SAY GRUPOS->grupo                     // grupo
    IMPCTL(drvtenf)
    IMPCTL(drvpenf)
    @ cl,034 SAY GRUPOS->admissao                  // data admissao
    IMPCTL(drvtenf)
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    IMPMEMO(Rx2901F9(),70,1,cl,002,.t.)            // pedido (memo)
    qli_m=MLCOUNT(Rx2901F9(),70)-1                 // quantas linhas a imprimir?
    li_m=0
    DO WHIL .t.                                    // imprime linhas do memo
     li_m++
     IF li_m>qli_m                                 // fim do memo
      EXIT
     ENDI
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     IMPMEMO(Rx2901F9(),70,1+li_m,cl,002,.t.)      // imprime...
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
    ENDD
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "Nome do falecido....:"
    IMPCTL(drvpenf)
    @ cl,026 SAY TRAN(falecido,"@!")               // nome do falecido
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o do falecido:",cl,004)
    IMPCTL(drvpenf)
    @ cl,026 SAY TRAN(ALLTRIM(ruares)+[, ]+ALLTRIM(baires),"@!")// Endereco falecido
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "Inscrito neste contrato na qualidade de"
    IMPCTL(drvpenf)
    @ cl,044 SAY grauparcon                        // Inscrito na qualidade de
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "Data do Falecimento.:"
    @ cl,026 SAY TRAN(falecto_,"@D")               // Data falcto.
    IMPAC("Hor rio do Falecimento:",cl,036)
    @ cl,060 SAY TRAN(horafal,"99:99")             // Hora Falcto.
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "Cidade do Falecimento Estado   Local do falecimento"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,004 SAY municfal                          // Cidade Falecimento
    IMPCTL(drvtenf)
    IMPCTL(drvpenf)
    @ cl,028 SAY TRAN(estfal,"!!")                 // UF falecimento
    IMPCTL(drvtenf)
    IMPCTL(drvpenf)
    @ cl,035 SAY ALLTRIM(ruafal)                   // local falecimento
    IMPCTL(drvtenf)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    IMPAC("Cemit‚rio onde foi sepultado        Hora do sepultamento",cl,004)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,004 SAY cemitsep                          // Cemit‚rio sepultamento
    IMPCTL(drvtenf)
    IMPCTL(drvpenf)
    @ cl,046 SAY TRAN(horasepult,"99:99")          // Hora sepultamento
    IMPCTL(drvtenf)
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY "Datado em       de                    de           , conforme processo"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("administrativo n£mero",cl,002)
    @ cl,024 SAY TRAN(processo+proc2+filial,"@R 99999/99/!!")// Processo
    @ cl,032 SAY "."
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,025 SAY IMPAC(RTRIM(M->p_cidade)+[, ]+LEFT(DTOC(DATE()),2)+[ de ]+NMES(MONTH(DATE()))+ [ de ]+LEFT(DTOS(DATE()),4))// DATA
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY "PROCESSAR"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "PAGAMENTO EM"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,002 SAY TRAN(procpagto_,"@D")             // Proc.pagto em
    IMPCTL(drvtenf)
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,021 SAY REPL("-",42)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,021 SAY "Ass.:"
    IMPCTL(drvpenf)
    @ cl,027 SAY GRUPOS->nome                      // Nome
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,027 SAY "RG:"
    @ cl,031 SAY TRAN(GRUPOS->rg,"@!")             // R.G.
    SKIP                                           // pega proximo registro
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
   EXIT
  ENDD
 ENDD ccop
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(4)                                           // grava variacao do relatorio
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
 @ 0,001 SAY IIF(categ=[PD],[Plano c/Difer. ],IIF(categ=[PL],[Atend.Plano],[Rest.Desp.Funerais]))// Categoria
 @ 5,021 SAY M->setup1                             // Ident1
 @ 7,034 SAY "RECIBO"
 cl=qt+8 ; pg_++
ENDI
RETU

* \\ Final de ADR_RX29.PRG
