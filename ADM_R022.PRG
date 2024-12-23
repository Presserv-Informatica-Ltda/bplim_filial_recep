/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADM_R022.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Endere‡os Alterados
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PRIV dele_atu, cur_atual, getlist:={}
PARA lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=26, l_i:=14, c_i:=56, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                     // se usuario nao tem
 DBOX("Emiss„o negada, "+usuario,20)               // permissao, avisa
 RETU                                              // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+5 SAY " ENDERE€OS ALTERADOS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Usu rio........:"
@ l_s+02,c_s+1 SAY " Lan‡to. inicial:"
@ l_s+03,c_s+1 SAY " Lan‡to. final..:"
PRIV musuario:=SPAC(10)                            // Usuario
PRIV emisini_:=CTOD('')                            // Lan‡to. inicial
PRIV emisfim_:=CTOD('')                            // Lan‡to. final
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+19 GET  musuario;
                  PICT "@!"
                  DEFAULT "M->usuario"
                  AJUDA "Informe o usu rio a listar|ou deixe sem preencher para listar todos."
                  CMDF8 "M->usuario"

 @ l_s+02 ,c_s+19 GET  emisini_;
                  PICT "@D";
                  VALI CRIT("!EMPT(emisini_).and. emisini_<=DATE()~Necess rio informar Lan‡to. inicial correta")
                  DEFAULT "DATE() - DAY(DATE()) + 1"
                  AJUDA "Informe a data inicial"

 @ l_s+03 ,c_s+19 GET  emisfim_;
                  PICT "@D";
                  VALI CRIT("!EMPT(emisfim_).and.emisfim_>=emisini_.and.emisfim_<=DATE()~Necess rio informar Lan‡to. final correta")
                  DEFAULT "DATE()"
                  AJUDA "Informe a data final"

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
  IF !USEARQ("ALENDER",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("ALENDER")                                // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 SET RELA TO codigo INTO GRUPOS                    // relacionamento dos arquivos
 titrel:=criterio := ""                            // inicializa variaveis
 cpord=""
 chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 fil_ini=""
 IF !opcoes_rel(lin_menu,col_menu,11,11,fil_ini)   // nao quis configurar...
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
maxli=63                                           // maximo de linhas no relatorio
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
   IF EMPT(emitido_).AND.(EMPT(M->musuario).OR.por=M->musuario).AND.data_>=M->emisini_.AND.data_<=M->emisfim_// se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,042 SAY "³"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Alterar"
    IMPCTL(drvpenf)
    IMPEXP(cl,008,dgrupo+'-'+codigo,18)            // Codigo
    IMPCTL(drvtenf)
    @ cl,028 SAY "DE:           ³ PARA:        ("
    @ cl,058 SAY por                               // Por
    @ cl,069 SAY TRAN(data_,"@D")                  // Data_
    @ cl,077 SAY ")"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Ender.."
    @ cl,007 SAY dendereco                         // Endere‡o
    @ cl,042 SAY "³"
    @ cl,044 SAY endereco                          // Endere‡o
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Bairro."
    @ cl,007 SAY dbairro                           // Bairro
    @ cl,042 SAY "³"
    @ cl,044 SAY bairro                            // Bairro
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Cidade."
    @ cl,007 SAY dcidade                           // Cidade
    @ cl,033 SAY TRAN(dcep,"@R 99999-999")         // CEP
    @ cl,042 SAY "³"
    @ cl,044 SAY cidade                            // Cidade
    @ cl,070 SAY TRAN(cep,"@R 99999-999")          // CEP
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
END SEQUENCE
SETCURSOR(cur_atual)
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI          // mostra o arquivo gravado
GRELA(11)                                          // grava variacao do relatorio
msgp="PROCESSAMENTOS DO RELAT¢RIO|ENDERE€OS ALTERADOS"
POE_GAUGE("Processando registros","AGUARDE!","Feitos:")
SET(_SET_DELETED,.t.)                              // os excluidos nao servem...
SELE ALENDER                                       // processamentos apos emissao
INI_ARQ()                                          // acha 1o. reg valido do arquivo
DO WHIL !EOF().AND.POE_GAUGE()
 IF EMPT(emitido_).AND.(EMPT(M->musuario).OR.por=M->musuario).AND.data_>=M->emisini_.AND.data_<=M->emisfim_// se atender a condicao...

  #ifdef COM_REDE
   IF PTAB(codigo,'GRUPOS',1)
    REPBLO('GRUPOS->endereco',{||endereco})
   ENDI
   REPBLO('GRUPOS->bairro',{||bairro})
   REPBLO('GRUPOS->cidade',{||cidade})
   REPBLO('GRUPOS->cep',{||cep})
   REPBLO('GRUPOS->cobrador',{||cobrador})
   REPBLO('GRUPOS->ender_',{||DATE()})
   REPBLO('GRUPOS->ultend',{||M->usuario})
   REPBLO('ALENDER->emitido_',{||DATE()})
  #else
   IF PTAB(codigo,'GRUPOS',1)
    REPL GRUPOS->endereco WITH endereco
   ENDI
   REPL GRUPOS->bairro WITH bairro
   REPL GRUPOS->cidade WITH cidade
   REPL GRUPOS->cep WITH cep
   REPL GRUPOS->cobrador WITH cobrador
   REPL GRUPOS->ender_ WITH DATE()
   REPL GRUPOS->ultend WITH M->usuario
   REPL ALENDER->emitido_ WITH DATE()
  #endi

  SKIP                                             // pega proximo registro
 ELSE                                              // se nao atende condicao
  SKIP                                             // pega proximo registro
 ENDI
ENDD
ALERTA(2)
DBOX("Processo terminado com sucesso!",,,,,msgp)
SELE ALENDER                                       // seleciona arquivo
SET RELA TO                                        // retira os relacionamentos
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
 @ 1,070 SAY "ADM_R022"                            // c¢digo relat¢rio
 @ 2,000 SAY titrel                                // t¡tulo a definir
 IMPAC("ALTERA€ŽO DE ENDERE€OS",2,032)
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY REPL("-",78)
 cl=qt+3 ; pg_++
ENDI
RETU

* \\ Final de ADM_R022.PRG
