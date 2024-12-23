procedure adr_r068
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: ADR_R068.PRG
 \ Data....: 21-01-99
 \ Sistema.: Administradora - RECEP��O
 \ Funcao..: Resumo de Recebimento
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={},lindet:=[]
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=9, c_s:=20, l_i:=15, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+10 SAY " RESUMO DE RECEBIMENTO "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " De:......:"
@ l_s+02,c_s+1 SAY " At�:.....:"
@ l_s+03,c_s+1 SAY " Analitico:"
@ l_s+04,c_s+1 SAY " Filtragem:"
@ l_s+05,c_s+1 SAY " Confirme.:"
rde=CTOD('')                                       // De:
rate=CTOD('')                                      // At�:
analit=SPAC(1)                                     // Analitico
rfiltr=space(50)
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+13 GET  rde;
                  PICT "@D";
                  VALI CRIT("!EMPT(rde)~Necess�rio informar a data inicial a considerar")
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data inicial a considerar"

 @ l_s+02 ,c_s+13 GET  rate;
                  PICT "@D";
                  VALI CRIT("!EMPT(rate)~Necess�rio informar AT�:")
                  DEFAULT "DATE()"
                  AJUDA "Informe a data final a considerar"

 @ l_s+03 ,c_s+13 GET  analit;
                  PICT "!";
                  VALI CRIT("analit$[SN]~ANALITICO n�o aceit�vel|Digite S ou N")
                  DEFAULT "[N]"
                  AJUDA "Digite [S] para anal�tico|ou N para totais"

 @ l_s+04 ,c_s+13 GET  rfiltr;
                  PICT "@KS20!"
                  AJUDA "Digite a condicao nescessaria|no contrato para ser impresso|Deixe sem preencher para todos"
                  DEFAULT "MEN_01F9()"

 @ l_s+05 ,c_s+13 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme= 'S'~CONFIRME n�o aceit�vel|Digite S ou Tecle ESC")
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

 #ifdef COM_REDE
  IF !USEARQ("BXREC",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("BXREC")                                  // abre o dbf e seus indices
 #endi

 IF !EMPT(rfiltr)
  PTAB(codigo,[GRUPOS],1)
  SET RELA TO codigo INTO grupos
 ENDI

 titrel:=criterio := ""                            // inicializa variaveis
 cpord="DTOS(emitido_)+codigo"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,23,11)           // nao quis configurar...
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
rcond=LEFT(rfiltr,AT("~",rfiltr)-1)               // condicao de validacao
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  tot040004 := 0                                   // inicializa variaves de totais
  qqu040=0                                         // contador de registros
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
   IF emitido_>=M->rde.and.emitido_<=M->rate       // se atender a condicao...

    IF !EMPT(rcond) // Se pediu filtragem do contrato, verifica...
     SELE GRUPOS
     IF !(&rcond.)    // Se nao for verdadeiro, tchau ...
      SELE BXREC
      SKIP
      LOOP
     ENDI
    ENDI
    SELE BXREC
    IF analit = [S]
     REL_CAB(2)                                     // soma cl/imprime cabecalho
     @ cl,000 SAY [Dia: ]+DTOC(emitido_)                  // titulo da quebra
     REL_CAB(1)                                     // soma cl/imprime cabecalho
    ELSE
     lindet:=[Dia: ]+DTOC(emitido_)
    ENDI
    qb04001=emitido_                               // campo para agrupar 1a quebra
    st04001004 := 0                                // inicializa sub-totais
    qqu04001=0                                     // contador de registros
    DO WHIL !EOF() .AND. emitido_=qb04001
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF emitido_>=M->rde.and.emitido_<=M->rate     // se atender a condicao...

    IF !EMPT(rcond) // Se pediu filtragem do contrato, verifica...
     SELE GRUPOS
     IF !(&rcond.)    // Se nao for verdadeiro, tchau ...
      SELE BXREC
      SKIP
      LOOP
     ENDI
    ENDI
    SELE BXREC

      IF ANALIT=[S]
       lindet+=TRAN(numero,"999999")+[ ]+;
               TRAN(codigo,"999999")+[ ]+;
               tipo+[-]+circ+[ ]+;
               TRAN(valorpg,"@E 9,999.99")+[ | ]   // Valor pago
       IF LEN(lindet)>110
        REL_CAB(1)                                   // soma cl/imprime cabecalho
        IMPCTL(drvpcom)
        @ cl,000 SAY lindet           // Numero
        IMPCTL(drvtcom)
        lindet:=[]
       ENDI
      ENDI
      st04001004+=valorpg
      tot040004+=valorpg
      qqu04001++                                   // soma contadores de registros
      qqu040++                                     // soma contadores de registros
      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD

    IF LEN(lindet)>0
     REL_CAB(1)                                   // soma cl/imprime cabecalho
     IMPCTL(drvpcom)
     @ cl,000 SAY lindet           // Numero
     IMPCTL(drvtcom)
     lindet:=[]
    ENDI

    IF analit = [S]
     @ ++cl,020 SAY REPL('-',10)
     cl++
    ENDI
    @ cl,020 SAY TRAN(qqu04001,"@E 999,999")
    @ cl,030 SAY TRAN(st04001004,"@E 999,999.99")// sub-tot Valor pago
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,020 SAY REPL('-',10)
  @ ++cl,020 SAY [R$ ]+LTRIM(TRAN(tot040004,"@E 999,999.99"))+[ em ]+;
    LTRIM(TRAN(qqu040,"@E 999,999"))+[ recebimentos]+;
    [ entre ]+DTOC(M->rde)+[ e ]+DTOC(M->rate)+[.]
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(23)                                          // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,070 SAY "PAG"
 @ 0,074 SAY TRAN(pg_,'9999')                      // n�mero da p�gina
 IMPAC(nsis,1,000)                                 // t�tulo aplica��o
 @ 1,070 SAY "ADR_R068"                            // c�digo relat�rio
 @ 2,000 SAY "RESUMO DE RECEBIMENTO"
 @ 2,024 SAY IIF(EMPT(rfiltr),titrel,rfiltr)                                // t�tulo a definir
 @ 2,060 SAY NSEM(DATE())                          // dia da semana
 @ 2,068 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY "Numero Contrato Circ  Valor pago   ("+DTOC(M->rde)+[ e ]+DTOC(M->rate)+[)]
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADR_R068.PRG
FUNC MEN_01F9()
sit_dbf:=POINTER_DBF()
crit_ant:=criterio
auxiliar=space(210)
PTAB([],[GRUPOS],1,.T.)
SELE GRUPOS
filtra(.F.)
auxiliar=criterio+[~TRUE]
criterio :=crit_ant
POINTER_DBF(sit_dbf)
RETU auxiliar       // <- deve retornar um valor qualquer

* \\ Final de MEN_01F9.PRG
