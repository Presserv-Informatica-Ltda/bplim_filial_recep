
procedure con_r027
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: CON_R027.PRG
 \ Data....: 31-12-98
 \ Sistema.: Controle de Convˆnios
 \ Funcao..: Ranking
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \ Convert.: v5.0 em 2021081014:57:30 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu, rde, rate
nucop=1

#ifdef COM_REDE
 IF !USEARQ("MEDICOS",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("MEDICOS")                                 // abre o dbf e seus indices
#endi

titrel:=criterio := ""                             // inicializa variaveis
cpord="" //"str(999999-VAL(numconta),6)"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,25,11)            // nao quis configurar...
 CLOS ALL                                          // fecha arquivos e
 RETU                                              // volta ao menu
ENDI
IF tps=2                                           // se vai para arquivo/video
 arq_=ARQGER()                                     // entao pega nome do arquivo
 IF EMPTY(arq_)                                    // se cancelou ou nao informou
  RETU                                             // retorna
 ENDI
ELSE
 arq_=drvporta                                     // porta de saida configurada
ENDI
SET PRINTER TO (arq_)                              // redireciona saida
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
IMPCTL(drvpcom)                                    // comprime os dados
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  ctaux:=ctmed:=0
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
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
   IF !EMPT(numconta)                              // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(crm,"@!")                    // C¢digo
    @ cl,011 SAY nome                              // Nome
    @ cl,052 SAY TRAN(especialid,"@!")             // Especialidade
    @ cl,083 SAY telefone                          // Telefone
    @ cl,098 SAY TRAN(numconta,"@!")               // Conta
    ctaux+=VAL(numconta)
    ctmed++
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  REL_CAB(1)                                     // soma cl/imprime cabecalho
  @ cl,000 SAY REPL("-",108)
  REL_CAB(1)                                     // soma cl/imprime cabecalho
  @ cl,000 SAY [Quantidade: ]+STR(ctmed,5)+[ credenciados emitiram ] +;
    STR(ctaux,6)+[ guias entre ]+DTOC(M->rde)+[ e ]+DTOC(M->rate)+[.]
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtcom)                                    // retira comprimido
SET PRINTER TO //(drvporta)                        // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(25)                                          // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,100 SAY "PAG"
 @ 0,104 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,100 SAY "CON_R027"                            // c¢digo relat¢rio
 @ 2,000 SAY "RANKING (De: "+DTOC(M->rde)+[   ate: ]+DTOC(M->rate)+[)]
 @ 2,090 SAY NSEM(DATE())                          // dia da semana
 @ 2,098 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 IMPAC("C¢digo     Nome                                     Especialidade                  Telefone       N§ Guias",4,000)
 @ 5,000 SAY REPL("-",108)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de CON_R027.PRG