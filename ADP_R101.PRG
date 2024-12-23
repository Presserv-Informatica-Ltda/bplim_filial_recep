procedure adp_r101
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_R101.PRG
 \ Data....: 23-03-10
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Cartinha
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PRIV dele_atu, cur_atual, getlist:={}
PARA lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=7, c_s:=4, l_i:=17, c_i:=77, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+26 SAY " CARTINHA DE PROCESSOS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Contrato:            Grupo:     Circular:"
@ l_s+02,c_s+1 SAY " Mensagem:"
@ l_s+08,c_s+1 SAY " Confirme:"
PRIV rcodigo:=SPAC(9)                               // Grupo
PRIV rgrupo:=SPAC(2)                               // Grupo
PRIV rcirc:=SPAC(3)                                // Circular
PRIV rmens1:=SPAC(70)                              // Mens1
PRIV rmens2:=SPAC(70)                              // Mens2
PRIV rmens3:=SPAC(70)                              // Mens3
PRIV rmens4:=SPAC(70)                              // Mens4
PRIV rmens5:=SPAC(70)                              // Mens5
IF FILE('PR101VAR.MEM')
 REST FROM PR101VAR ADDITIVE
ENDI
PRIV confirme:=SPAC(1)                             // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  rcodigo;
                  PICT "999999999";
                  VALI CRIT("(PTAB(rcodigo,'GRUPOS',1).AND.!EMPT(rgrupo:=GRUPOS->grupo)).OR.EMPT(rcodigo)~GRUPO n„o existe na tabela|Informe um existente |ou|deixe sem preencher para listar todos")
                  AJUDA "Informe o nr. do contrato"
                  CMDF8 "VDBF(6,3,20,77,'GRUPOS',{'codigo','grupo','nome','endereco'},1,'codigo',[])"

 @ l_s+01 ,c_s+30 GET  rgrupo;
                  PICT "!!"
                  AJUDA "Circular de qual grupo?"
                  CMDF8 "VDBF(6,54,20,77,'ARQGRUP',{'grup','inicio','final'},1,'grup',[])"

 @ l_s+01 ,c_s+45 GET  rcirc;
                  PICT "999";
                  VALI CRIT("PTAB(rgrupo+rcirc,'CIRCULAR',1).OR.EMPT(rcirc)~Necess rio informar CIRCULAR v lida")
                  AJUDA "Informe o n£mero da circular a listar"
                  CMDF8 "VDBF(6,40,20,77,'CIRCULAR',{'grupo','circ','emissao_','valor'},1,'circ',[grupo=rgrupo])"

 @ l_s+03 ,c_s+02 GET  rmens1;
                  PICT "@!"
                  AJUDA "Mensagem 1"
                  CMDF8 "Informe a linha 1/5 da cartinha"

 @ l_s+04 ,c_s+02 GET  rmens2;
                  PICT "@!"
                  AJUDA "Mensagem 2"
                  CMDF8 "Informe a linha 2/5 da cartinha"

 @ l_s+05 ,c_s+02 GET  rmens3;
                  PICT "@!"
                  AJUDA "Mensagem 3"
                  CMDF8 "Informe a linha 3/5 da cartinha"

 @ l_s+06 ,c_s+02 GET  rmens4;
                  PICT "@!"
                  AJUDA "Mensagem 4"
                  CMDF8 "Informe a linha 4/5 da cartinha"

 @ l_s+07 ,c_s+02 GET  rmens5;
                  PICT "@!"
                  AJUDA "Mensagem 5"
                  CMDF8 "Informe a linha 5/5 da cartinha"

 @ l_s+08 ,c_s+12 GET  confirme;
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

 SAVE TO PR101VAR ALL LIKE R*

 #ifdef COM_REDE
  IF !USEARQ("CIRCULAR",.f.,10,1)                  // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("CIRCULAR")                               // abre o dbf e seus indices
 #endi

 titrel:=criterio := ""                            // inicializa variaveis
 cpord="grupo"
 chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 fil_ini=""
 IF !opcoes_rel(lin_menu,col_menu,14,11,fil_ini)   // nao quis configurar...
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
   tps:=3                                         // se vai para arquivo/video
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
 lpp_033=LEFT(drvtapg,op_-1)+"033"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_033:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("CPRCIRC",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CPRCIRC")                                 // abre o dbf e seus indices
#endi

cpord="grupo+circ+DTOS(dfal)"
criterio=""
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE CIRCULAR
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
POE_GAUGE("[ESC] Interrompe","AGUARDE...","Emitidos:")
SET DEVI TO PRIN                                   // inicia a impressao
maxli=63
maxli=32                                           // maximo de linhas no relatorio
IMPCTL(lpp_033)                                    // seta pagina com 33 linhas
                                           // maximo de linhas no relatorio
SET MARG TO 1                                      // ajusta a margem esquerda
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=50000
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  IF EOF()
   EXIT
  ENDI
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF().AND.POE_GAUGE()
   IF IN_KEY()=K_ESC                               // se quer cancelar
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF grupo=M->rgrupo.AND.circ=M->rcirc            // se atender a condicao...
    IMPCTL(drvtcom)                               // comprime os dados
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Circular:"
    @ cl,012 SAY TRAN(M->rgrupo,"!!")+[-]+TRAN(M->rcirc,"999")              // Circular
    @ cl,031 SAY "Emissao:"
    @ cl,040 SAY TRAN(emissao_,"@D")               // Emiss„o
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(M->rmens1,"@!")              // Mens1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(M->rmens2,"@!")              // Mens2
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(M->rmens3,"@!")              // Mens3
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(M->rmens4,"@!")              // Mens4
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(M->rmens5,"@!")              // Mens5
    chv030=grupo+circ
    SELE CPRCIRC
    SEEK chv030
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     IMPCTL(drvpcom)                                    // comprime os dados
     cl+=1                                         // soma contador de linha
     IMPAC("Contrato Processo    Falecido(a)                         Endere‡o                                           Data Fal",cl,000)
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "======== =========== =================================== ================================================== =========="
     DO WHIL ! EOF() .AND. chv030=LEFT(&(INDEXKEY(0)),LEN(chv030)).AND.POE_GAUGE()
      IF IN_KEY()=K_ESC                            // se quer cancelar
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,001 SAY num                             // Contrato
      @ cl,009 SAY TRAN(processo,"@R 99999/99/!!") // Processo
      @ cl,021 SAY TRAN(fal,"@!")                  // Falecido(a)
      @ cl,057 SAY TRAN(ALLTRIM(ends)+[-]+ALLTRIM(cids),"@!")// Endere‡o
      @ cl,108 SAY TRAN(dfal,"@D")                 // Data Fal
      SKIP                                         // pega proximo registro
     ENDD
     cl++
     @ cl,000 SAY "======== =========== =================================== ================================================== =========="
     cl+=3                                         // soma contador de linha
    ENDI
    IMPCTL(drvtcom)                               // comprime os dados
    SELE CIRCULAR                                  // volta ao arquivo pai
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
SET MARG TO                                        // coloca margem esquerda = 0
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI          // mostra o arquivo gravado
GRELA(14)                                          // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPCTL(drvtcom)                               // comprime os dados
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,070 SAY "PAG"
 @ 0,074 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,027 SAY titrel                                // t¡tulo a definir
 @ 1,068 SAY "ADP_R101"                            // c¢digo relat¢rio
 @ 2,000 SAY "Relacao dos funerais efetuados (cartinha)"
 @ 2,058 SAY NSEM(DATE())                          // dia da semana
 @ 2,066 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY REPL("-",76)
 cl=qt+3 ; pg_++
ENDI
RETU

* \\ Final de ADP_R101.PRG
