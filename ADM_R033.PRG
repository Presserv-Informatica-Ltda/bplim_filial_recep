
procedure adm_r033
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADM_R033.PRG
 \ Data....: 11-12-96
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Uma a uma Convencional
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \ Convert.: v5.0 em 2021081014:57:53 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=8, c_s:=16, l_i:=13, c_i:=59, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+14 SAY " TAXAS (2¦ VIA) "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Contrato:"
@ l_s+04,c_s+1 SAY " Circular:  -               Confirma?"
rcodigo=SPAC(6)                                    // Codigo
rtipo=SPAC(1)                                      // Tipo
rcirc=SPAC(3)                                      // Circular
confirme=SPAC(1)                                   // Confirme?
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  rcodigo;
                  PICT "999999";
                  VALI CRIT("PTAB(rcodigo,'GRUPOS',1)~Necess rio informar CODIGO")
                  AJUDA "Informe o n£mero do contrato"
                  CMDF8 "VDBF(6,3,20,77,'GRUPOS',{'grupo','codigo','nome','cidade'},1,'codigo',[])"
                  MOSTRA {"LEFT(TRAN(GRUPOS->nome,[@!]),35)", 2 , 5 }
                  MOSTRA {"LEFT(TRAN(GRUPOS->endereco,[]),35)", 3 , 5 }

 @ l_s+04 ,c_s+12 GET  rtipo;
                  PICT "!";
                  VALI CRIT("rtipo $ [123678]~TIPO n„o aceit vel")
                  AJUDA "Qual o tipo de lan‡amento"
                  CMDF8 "MTAB([1=J¢ia|2=Taxa|3=Carnˆ|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnˆ+Seguro],[TIPO])"

 @ l_s+04 ,c_s+14 GET  rcirc;
                  PICT "999";
                  VALI CRIT("PTAB(rcodigo+rtipo+rcirc,'TAXAS',1)~Necess rio informar CIRCULAR v lida")
                  AJUDA "Informe o n£mero da circular a imprimir"

 @ l_s+04 ,c_s+39 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'.AND.V03301F9()~Digite S para confirmar|ou|Tecle ESC para cancelar")
                  AJUDA "Digite S para confirmar|ou|Tecle ESC para cancelar"

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
  IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->grupo,"ARQGRUP",1,.t.)
 PTAB(GRUPOS->regiao,"REGIAO",1,.t.)
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->grupo INTO ARQGRUP,;
          TO GRUPOS->regiao INTO REGIAO,;
          TO GRUPOS->grupo+circ INTO CIRCULAR
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="codigo"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,15,11)           // nao quis configurar...
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
 IF !USEARQ("CPRCIRC",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CPRCIRC")                                 // abre o dbf e seus indices
#endi

cpord="grupo+circ+DTOS(dfal)"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE TAXAS
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura‡„o do tamanho da p gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_048=LEFT(drvtapg,op_-1)+"048"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_048:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=19                                           // maximo de linhas no relatorio
IMPCTL(lpp_048)                                    // seta pagina com 48 linhas
SET MARG TO 1                                      // ajusta a margem esquerda
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  ult_imp=0                                        // ultimo reg impresso
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
   IF codigo=M->rcodigo                            // se atender a condicao...
    REL_CAB(1,.t.)                                 // soma cl/imprime cabecalho
    @ cl,000 SAY "."
    ult_imp=RECNO()                                // ultimo reg impresso
    chv027=GRUPOS->grupo+TAXAS->circ
    SELE CPRCIRC
    SEEK chv027
    IF FOUND()
     DO WHIL ! EOF() .AND. chv027=LEFT(&(INDEXKEY(0)),LEN(chv027))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      IMPCTL(drvpc20)                              // comprime os dados
      @ cl,030 SAY num                             // Contrato
      @ cl,041 SAY processo                        // Processo
      @ cl,054 SAY fal                             // Falecido
      @ cl,091 SAY TRAN(ALLTRIM(ends)+'-'+ALLTRIM(cids),"@!")// Ends
      @ cl,149 SAY TRAN(dfal,"@D")                 // Data
      IMPCTL(drvtc20)                              // retira comprimido
      SKIP                                         // pega proximo registro
     ENDD
    ENDI
    SELE TAXAS                                     // volta ao arquivo pai
    SKIP                                           // pega proximo registro
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  REL_RDP(.t.)                                     // imprime rodape' do relatorio
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET MARG TO                                        // coloca margem esquerda = 0
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO //(drvporta)                        // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(15)                                          // grava variacao do relatorio
SELE TAXAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_RDP(volta_reg)                     // rodape'
LOCAL ar_:=ALIAS(), reg_atual
SELE TAXAS                                         // volta ao arquivo pai
reg_atual=RECNO()
IF volta_reg
 GO ult_imp                                        // ajusta reg p/ imp de campos no rodape'
ENDI
@ 21,008 SAY CHR(18)+CIRCULAR->menscirc            // Mensagem
@ 25,017 SAY TRAN(valor,"@E 999,999.99")           // Valor
@ 25,065 SAY TRAN(valor,"@E 999,999.99")           // Valor 2
@ 28,020 SAY TRAN(0,"########")                    // N§ Recibo
@ 28,068 SAY TRAN(0,"########")                    // N§ Recibo 2
@ 31,002 SAY TAXAS->circ+[     ]+DTOC(TAXAS->emissao_)+[     ]+STR(GRUPOS->funerais,2)// Circular 1
@ 31,038 SAY TAXAS->circ+[     ]+DTOC(TAXAS->emissao_)+[     ]+STR(GRUPOS->funerais,2)// Circular 2
@ 34,002 SAY GRUPOS->grupo +[        ]+codigo+[       ]+GRUPOS->cobrador// Grupo 1
@ 34,038 SAY GRUPOS->grupo +[        ]+codigo+[       ]+GRUPOS->cobrador// Grupo 2
@ 36,000 SAY GRUPOS->nome                          // Nome
@ 36,036 SAY GRUPOS->nome                          // Nome 2
@ 37,000 SAY GRUPOS->endereco                      // Endere‡o
@ 37,036 SAY GRUPOS->endereco                      // Endere‡o 2
@ 38,000 SAY GRUPOS->bairro                        // Bairro
@ 38,036 SAY GRUPOS->bairro                        // Bairro 2
@ 39,000 SAY GRUPOS->cidade+[ ] +GRUPOS->cep       // Cidade
@ 39,036 SAY GRUPOS->cidade+[ ] +GRUPOS->cep       // Cidade 2
@ 40,000 SAY [Inic:]+DTOC(GRUPOS->admissao)+[ Ult:]+GRUPOS->ultcirc+[ QtTx:]+STR(GRUPOS->qtcircs,3)// Inicio
@ 40,036 SAY [Inic:]+DTOC(GRUPOS->admissao)+[ Ult:]+GRUPOS->ultcirc+[ QtTx:]+STR(GRUPOS->qtcircs,3)// Inicio 2
@ 42,000 SAY ""
IF M->combarra=[S]
 CODBARRAS({{codigo+tipo+circ,4,10,18}},10,6)
ENDI
@ 43,002 SAY [ ]                                   // data 1
@ 43,039 SAY [ ]                                   // data 2
IF M->combarra=[S]
 CODBARRAS({{codigo+tipo+circ,4,10,18}},10,6)
ENDI
IF volta_reg
 GO reg_atual                                      // retorna reg a posicao original
ENDI
SELE (ar_)
RETU

STATIC PROC REL_CAB(qt, volta_reg)                 // cabecalho do relatorio
LOCAL ar_:=ALIAS()
volta_reg=IF(volta_reg=NIL,.f.,volta_reg)
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IF pg_>1
  REL_RDP(volta_reg)                               // imprime rodape' do relatorio
 ENDI
 SELE TAXAS                                        // volta ao arquivo pai
 @ 1,007 SAY GRUPOS->nome                          // Nome
 @ 1,058 SAY TRAN(codigo,"999999")                 // Codigo
 @ 1,076 SAY TRAN(GRUPOS->grupo,"!9")              // Grupo
 @ 3,032 SAY TRAN(valor,"@E 999,999.99")           // Valor
 SELE (ar_)
 cl=qt+7 ; pg_++
ENDI
RETU

* \\ Final de ADM_R033.PRG