
procedure adm_r029
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADM_R029.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Relat¢rio de Processo
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \ Convert.: v5.0 em 2021081014:57:01 Fase_01
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
 PTAB(contrato,"INSCRITS",1,.t.)
 SET RELA TO contrato INTO GRUPOS,;                // relacionamento dos arquivos
          TO contrato INTO INSCRITS
 titrel:=criterio := ""                            // inicializa variaveis
 cpord=""
 chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 fil_ini=""
 IF !opcoes_rel(lin_menu,col_menu,5,11,fil_ini)    // nao quis configurar...
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
maxli=62                                           // maximo de linhas no relatorio
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
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Contrato:"
    IMPCTL(drvpenf)
    @ cl,011 SAY GRUPOS->grupo+'-'+GRUPOS->codigo  // Contrato
    IMPCTL(drvtenf)
    @ cl,043 SAY "Processo"
    IMPCTL(drvpenf)
    @ cl,052 SAY TRAN(processo+proc2+filial,"@R 99999/99/!!")// Nr.Processo
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",74)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,013 SAY "R E L A T O R I O   D E   P R O C E S S O"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",74)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Nome do Falecido.:"
    IMPCTL(drvpenf)
    @ cl,020 SAY TRAN(falecido,"@!")               // nome do falecido
    IMPCTL(drvtenf)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "End. do Falecido.:"
    @ cl,020 SAY LEFT(ALLTRIM(ruares)+' ' +baires,59)// Rua Residˆncia
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Cidade...........:"
    @ cl,020 SAY munres                            // Munic¡pio de residˆncia
    @ cl,054 SAY "Estado:"
    @ cl,062 SAY TRAN(estres,"!!")                 // UF Residˆncia
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Falecimento......:"
    IMPCTL(drvpenf)
    @ cl,019 SAY TRAN(falecto_,"@D")               // data falecto
    IMPCTL(drvtenf)
    @ cl,029 SAY "Local...:"
    @ cl,039 SAY ruafal                            // Rua Falecimento
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Inscrito Contrato como.:"
    @ cl,026 SAY grauparcon                        // Parentesco
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",74)
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Contratante:"
    IMPCTL(drvpenf)
    @ cl,013 SAY GRUPOS->nome                      // Nome CONTRATANTE
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o...:",cl,000)
    @ cl,013 SAY xDECRIPT(GRUPOS->endereco)                  // Endere‡o
    @ cl,049 SAY xDECRIPT(GRUPOS->cidade)                    // Cidade
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",74)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Valor em Reais....:"
    @ cl,020 SAY vlauxilio                         // Valor
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "PROCESSAR PAGAMENTO EM :"
    IMPCTL(drvpenf)
    @ cl,025 SAY LEFT(DTOC(procpagto_),2)+' de '+ALLTRIM(NMES(procpagto_))+' de '+STR(YEAR(procpagto_),4)// Proc.pagto em
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",74)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPMEMO([   ],10,1,cl,000,.f.)                 // AUX (memo)
    qli_m=MLCOUNT([   ],10)-1                      // quantas linhas a imprimir?
    li_m=0
    DO WHIL .t.                                    // imprime linhas do memo
     li_m++
     IF li_m>qli_m                                 // fim do memo
      EXIT
     ENDI
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     IMPMEMO([   ],10,1+li_m,cl,000,.f.)           // imprime...
     IF INKEY()=K_ESC                             // se quer cancelar
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
    ENDD
    SKIP                                           // pega proximo registro
    cl=50000                                       // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
END SEQUENCE
SETCURSOR(cur_atual)
SET PRINTER TO //(drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI          // mostra o arquivo gravado
GRELA(5)                                           // grava variacao do relatorio
SELE AFUNER                                        // seleciona arquivo
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 @ 0,000 SAY REPL("-",74)
 IMPAC("BOM PASTOR - Organiza‡„o Administradora de Bens BOM PASTOR Ltda",1,000)
 @ 2,000 SAY "Data:"
 @ 2,006 SAY TRAN(DATE(),"@D")                     // DATA
 @ 2,025 SAY "CAT:"
 @ 2,030 SAY IIF(categ=[PD],[Plano c/Difer. ],IIF(categ=[PL],[Atend.Plano],[Auxilio Funeral  ]))// Categoria
 cl=qt+2 ; pg_++
ENDI
RETU

* \\ Final de ADM_R029.PRG