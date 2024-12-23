/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADM_RS18.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Recibos (2¦via)
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
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
IMPCTL(lpp_033)                                    // seta pagina com 33 linhas
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
   IF IN_KEY()=K_ESC                               // se quer cancelar
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF (PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1).AND.numero=LEFT(IMPPAR->docto,8)) .OR. so_um_reg// se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(numero,"@R 99-999999")       // N§ Recibo
    IMPAC("Cobran‡a:",cl,014)
    IMPCTL(drvpenf)
    @ cl,026 SAY TRAN(cobranca,[@R 999.999999-9-99999])   // Ref.:
    IMPCTL(drvtenf)
    @ cl,046 SAY "Vencimento:"
    @ cl,058 SAY TRAN(TAXAS->emissao_,"@D")               // data 1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,012 SAY TRAN(CLASSES->descricao,"@!")     // Descri‡„o 1
    @ cl,050 SAY "Valor.:"
    IMPCTL(drvpenf)
    @ cl,058 SAY TRAN(valorpg,"@E 999,999.99")     // Valor
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Contrato..:"
    IMPCTL(drvpenf)
    @ cl,012 SAY GRUPOS->grupo +[  ]+TRAN(codigo,[@R 999.999999])        // Grupo 1
    IMPCTL(drvtenf)
    @ cl,050 SAY "Data..:"
    @ cl,058 SAY TRAN(emitido_,"@D")               // data 1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Nome......:"
    IMPCTL(drvpenf)
    @ cl,012 SAY GRUPOS->nome                      // Nome
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o..:",cl,000)
    @ cl,012 SAY xDECRIPT(GRUPOS->endereco)                  // Endere‡o
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Bairro....:"
    @ cl,012 SAY xDECRIPT(GRUPOS->bairro)                    // Bairro
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Cid./Cobr.:"
    @ cl,012 SAY xDECRIPT(GRUPOS->cidade)+[ ] +GRUPOS->cobrador// Cidade
    @ cl,052 SAY REPL("Ä",19)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,052 SAY "Op:"
    @ cl,056 SAY LEFT(por,1)+LOWER(SUBSTR(por,2))  // operador
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Valor:"
    @ cl,007 SAY chr(15)+'('+SUBSTR(EXT(valorpg),1,AT('/',EXT(valorpg))-1)+')'+chr(18)// Valor Ext
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("Ä",71)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPEXP(cl,000,LEFT(M->setup1,35),70)           // 2 Ident1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY M->setup2                         // 2 Ident 2
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",71)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(numero,"@R 99-999999")       // N§ Recibo
    IMPAC("Cobran‡a:",cl,014)
    IMPCTL(drvpenf)
    @ cl,025 SAY cobranca                          // Ref.:
    IMPCTL(drvtenf)
    @ cl,046 SAY "Vencimento:"
    @ cl,058 SAY TRAN(TAXAS->emissao_,"@D")               // data 1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,012 SAY TRAN(CLASSES->descricao,"@!")     // Descri‡„o 2
    @ cl,050 SAY "Valor.:"
    IMPCTL(drvpenf)
    @ cl,058 SAY TRAN(valorpg,"@E 999,999.99")     // Valor pago
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Contrato..:"
    IMPCTL(drvpenf)
    @ cl,012 SAY GRUPOS->grupo +[  ]+TRAN(codigo,[@R 999.999999])  // Grupo
    IMPCTL(drvtenf)
    @ cl,050 SAY "Data..:"
    @ cl,058 SAY TRAN(emitido_,"@D")               // Emitido em
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Nome......:"
    IMPCTL(drvpenf)
    @ cl,012 SAY GRUPOS->nome                      // Nome
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o..:",cl,000)
    @ cl,012 SAY xDECRIPT(GRUPOS->endereco)                  // Endere‡o
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Bairro....:"
    @ cl,012 SAY xDECRIPT(GRUPOS->bairro)                    // Bairro
    @ cl,052 SAY REPL("Ä",19)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Cid./Cobr.:"
    @ cl,012 SAY xDECRIPT(GRUPOS->cidade)+[ ] +GRUPOS->cobrador// Cidade
    @ cl,052 SAY "Op:"
    @ cl,056 SAY LEFT(por,1)+LOWER(SUBSTR(por,2))  // Operador
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Valor:"
    @ cl,007 SAY chr(15)+'('+SUBSTR(EXT(valorpg),1,AT('/',EXT(valorpg))-1)+')'+chr(18)// Valor Ext
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
 IMPEXP(0,000,LEFT(M->setup1,35),70)               // Ident1
 @ 1,000 SAY M->setup2                             // Ident2
 @ 2,000 SAY REPL("-",71)
 cl=qt+2 ; pg_++
ENDI
RETU

* \\ Final de ADM_RS18.PRG
