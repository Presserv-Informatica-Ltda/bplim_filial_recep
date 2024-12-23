
procedure adm_rs18
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADM_RS18.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Recibos (2¦via)
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \ Convert.: v5.0 em 2021081014:57:48 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PRIV dele_atu, cur_atual, getlist:={}, so_um_reg, sit_dbf
PARA lin_menu, col_menu, imp_reg
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=20, l_i:=14, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
so_um_reg=(PCOUNT()>2)
IF !so_um_reg                             // vai receber a variaveis?
 IF nivelop < 2                                    // se usuario nao tem
  DBOX("Emiss„o negada, "+usuario,20)              // permissao, avisa
  RETU                                             // e retorna
 ENDI
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+10 SAY " RECIBO SEM FALECIDOS "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Numero..:   -"
 @ l_s+03,c_s+1 SAY " Confirme:"
ENDI
PRIV rnumero:=SPAC(8)                              // Numero
PRIV confirme:=SPAC(1)                             // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF !so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+15 GET  rnumero;
                   PICT "99999999";
                   VALI CRIT("!EMPT(rnumero)~Necess rio informar NUMERO")
                   DEFAULT "IF(PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1),IMPPAR->docto,[])"
                   AJUDA "Informe o n£mero do recibo"
		   CMDF8 "VDBF(6,3,20,77,'BXREC',{'numero','codigo','cobranca','valorpg','emitido_','por'},1,'numero',[])"

  @ l_s+03 ,c_s+12 GET  confirme;
                   PICT "!";
                   VALI CRIT("confirme='S'.AND.V01801F9()~CONFIRME n„o aceit vel|Digite S para confirmar|ou|Tecle ESC para cancelar")
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
  IF !USEARQ("BXREC",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("BXREC")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(cobranca,"TAXAS",1,.t.)
 PTAB(GRUPOS->grupo,"ARQGRUP",1,.t.)
 PTAB(TAXAS->cobrador,"COBRADOR",1,.t.)
 PTAB(GRUPOS->regiao,"REGIAO",1,.t.)
 PTAB(GRUPOS->tipcont,"CLASSES",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
	  TO cobranca INTO TAXAS,;
          TO GRUPOS->grupo INTO ARQGRUP,;
          TO TAXAS->cobrador INTO COBRADOR,;
          TO GRUPOS->regiao INTO REGIAO,;
          TO GRUPOS->tipcont INTO CLASSES
 titrel:=criterio := ""                            // inicializa variaveis
 cpord=""
 chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  fil_ini=""
  IF !opcoes_rel(lin_menu,col_menu,10,11,fil_ini)  // nao quis configurar...
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

 //  Impressora termica de transferencia
 ehtermica:=.F.
 IF "BEMA"$UPPER(drvmarca) // Autenticadora Bematech
   ehtermica:=.T.
 ENDI

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
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
POE_GAUGE("[ESC] Interrompe","AGUARDE...","Emitidos:")
SET DEVI TO PRIN                                   // inicia a impressao
maxli=32                                           // maximo de linhas no relatorio
drvcut1="CHR(27)+'m'"               // corte parcial
drvcut2="CHR(27)+'w'"               // corte total

IMPCTL(lpp_033)                                    // seta pagina com 33 linhas
IF (ehtermica)
 IMPCTL(drvpcom)                                    // seta pagina com 33 linhas
ENDI
SET MARG TO 1                                      // ajusta a margem esquerda
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=50000
  IF so_um_reg
   GO imp_reg
  ELSE
   INI_ARQ()                                       // acha 1o. reg valido do arquivo
   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1)
    PTAB(LEFT(IMPPAR->docto,8),'BXREC',1)
   ENDI
  ENDI
  IF EOF()
   EXIT
  ENDI
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF().AND.(!so_um_reg.OR.imp_reg=RECN()).AND.POE_GAUGE()
   IF INKEY()=K_ESC                               // se quer cancelar
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF (PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1).AND.numero=LEFT(IMPPAR->docto,8)) .OR. so_um_reg// se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(numero,"@R 99-999999")       // N§ Recibo
    IMPAC("Cobran‡a:",cl,014)
    IF !(ehtermica)
     IMPCTL(drvpenf)
    ENDIF
    @ cl,026 SAY TRAN(cobranca,[@R 999.999999-9-99999])   // Ref.:
    IF !(ehtermica)
     IMPCTL(drvtenf)
    ENDIF
    @ cl,046 SAY "Vencimento:"
    @ cl,055 SAY TRAN(TAXAS->emissao_,"@D")               // data 1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,012 SAY TRAN(CLASSES->descricao,"@!")     // Descri‡„o 1
    @ cl,047 SAY "Valor.:"
    IF !(ehtermica)
     IMPCTL(drvpenf)
    ENDI
    @ cl,055 SAY TRAN(valorpg,"@E 999,999.99")     // Valor
    IF !(ehtermica)
     IMPCTL(drvtenf)
    ELSE
     @ cl,000 SAY [RECIBO]
     REL_CAB(1)                                     // soma cl/imprime cabecalho
     @ cl,000 SAY TRAN(numop,"999999")  // N§ Recibo
     IF so_um_reg                             // vai receber a variaveis?
      @ cl,008 SAY [/]+PADL(TRAN(ORDPGRC->nrdoctos,"9999"))               // Emitido em
     ENDI
     @ cl,013 SAY TRAN(CLASSES->descricao,"@!")     // Descri‡„o 1
    ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Contrato..:"
    IF !(ehtermica)
     IMPCTL(drvpenf)
    ENDI
    @ cl,012 SAY GRUPOS->grupo +[  ]+TRAN(codigo,[@R 999.999999])        // Grupo 1
    IF !(ehtermica)
     IMPCTL(drvtenf)
    ENDIF
    @ cl,047 SAY "Data..:"
    @ cl,055 SAY TRAN(emitido_,"@D")               // data 1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Nome......:"
    IF !(ehtermica)
     IMPCTL(drvpenf)
    ENDIF
    @ cl,012 SAY GRUPOS->nome                      // Nome
    IF !(ehtermica)
     IMPCTL(drvtenf)
    ENDIF
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o..:",cl,000)
    @ cl,012 SAY xDECRIPT(GRUPOS->endereco)                  // Endere‡o
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Bairro....:"
    @ cl,012 SAY xDECRIPT(GRUPOS->bairro)                    // Bairro
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Cid./Cobr.:"
    @ cl,012 SAY xDECRIPT(GRUPOS->cidade)+[ ] +GRUPOS->cobrador// Cidade
    @ cl,049 SAY REPL("Ä",19)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,049 SAY "Op:"
    @ cl,053 SAY LEFT(por,1)+LOWER(SUBSTR(por,2))  // operador
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Valor:"
    IF !(ehtermica)
     IMPCTL(drvpcom)
    ENDI
    @ cl,007 SAY '('+SUBSTR(EXT(valorpg),1,AT('/',EXT(valorpg))-1)+')'// Valor Ext
    IF !(ehtermica)
     IMPCTL(drvtcom)
    ENDI
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("Ä",71)
    IF (ehtermica)
     IMPCTL(drvcut1)
    ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IF !(ehtermica)
     IMPEXP(cl,000,LEFT(M->setup1,35),70)           // 2 Ident1
    ELSE
     @ cl,000 SAY LEFT(M->setup1,35)
    ENDI

    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY M->setup2                         // 2 Ident 2
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IF !(ehtermica)
     @ cl,000 SAY REPL("-",71)
    ELSE
     @ cl,000 SAY REPL("-",50)
    ENDIF
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(numero,"@R 99-999999")       // N§ Recibo
    IMPAC("Cobran‡a:",cl,014)
    IF !(ehtermica)
     IMPCTL(drvpenf)
    ENDIF
    @ cl,025 SAY cobranca                          // Ref.:
    IF !(ehtermica)
     IMPCTL(drvtenf)
    ENDIF
    @ cl,043 SAY "Vencimento:"
    @ cl,055 SAY TRAN(TAXAS->emissao_,"@D")               // data 1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,012 SAY TRAN(CLASSES->descricao,"@!")     // Descri‡„o 2
    @ cl,047 SAY "Valor.:"
    IF !(ehtermica)
     IMPCTL(drvpenf)
    ENDIF
    @ cl,055 SAY TRAN(valorpg,"@E 999,999.99")     // Valor pago
    IF !(ehtermica)
     IMPCTL(drvtenf)
    ENDIF
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Contrato..:"
    IF !(ehtermica)
     IMPCTL(drvpenf)
    ENDIF
    @ cl,012 SAY GRUPOS->grupo +[  ]+TRAN(codigo,[@R 999.999999])  // Grupo
    IF !(ehtermica)
     IMPCTL(drvtenf)
    ENDIF
    @ cl,047 SAY "Data..:"
    @ cl,055 SAY TRAN(emitido_,"@D")               // Emitido em
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Nome......:"
    IF !(ehtermica)
     IMPCTL(drvpenf)
    ENDIF
    @ cl,012 SAY GRUPOS->nome                      // Nome
    IF !(ehtermica)
     IMPCTL(drvtenf)
    ENDIF
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o..:",cl,000)
    @ cl,012 SAY xDECRIPT(GRUPOS->endereco)                  // Endere‡o
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Bairro....:"
    @ cl,012 SAY xDECRIPT(GRUPOS->bairro)                    // Bairro
    @ cl,049 SAY REPL("Ä",19)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Cid./Cobr.:"
    @ cl,012 SAY xDECRIPT(GRUPOS->cidade)+[ ] +GRUPOS->cobrador// Cidade
    @ cl,049 SAY "Op:"
    @ cl,053 SAY LEFT(por,1)+LOWER(SUBSTR(por,2))  // Operador
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Valor:"
    IF !(ehtermica)
     IMPCTL(drvpcom)
    ENDIF
    @ cl,007 SAY '('+SUBSTR(EXT(valorpg),1,AT('/',EXT(valorpg))-1)+')'// Valor Ext
    IF !(ehtermica)
     IMPCTL(drvtcom)
    ENDIF
    REL_CAB(2)                                     // soma cl/imprime cabecalho
//    @ cl,000 say [>]+cobranca+[<]
    @ cl,000 SAY ""
    CODBARRAS({{left(cobranca,13)+[0],4,25,9},{ALLTRIM(str(valorpg,10,2)),3,20,47}},10,6)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY ""
    CODBARRAS({{left(cobranca,13)+[0],4,25,9},{ALLTRIM(str(valorpg,10,2)),3,20,47}},10,6)

    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY ""
//    CODBARRAS({{strzero(valorpg,10,2),3,20,39}},10,6)
    SKIP                                           // pega proximo registro
    cl=50000                                       // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 IF !(ehtermica)
  EJEC                                              // salta pagina
 ELSE
  IMPCTL(drvcut2)
 ENDI

END SEQUENCE
SETCURSOR(cur_atual)
SET MARG TO                                        // coloca margem esquerda = 0
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO //(drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI          // mostra o arquivo gravado
GRELA(10)                                          // grava variacao do relatorio
SELE BXREC                                         // seleciona arquivo
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
 IF !(ehtermica)
  IMPEXP(0,000,LEFT(M->setup1,35),70)               // Ident1
 ELSE
  IMPCTL(drvpcom)
  @ 0,000 SAY LEFT(M->setup1,35)               // Ident1
 ENDI
 @ 1,000 SAY M->setup2                             // Ident2
 @ 2,000 SAY REPL("-",55)
 cl=qt+2 ; pg_++
ENDI
RETU

* \\ Final de ADM_RS18.PRG