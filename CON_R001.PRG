/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: CON_R001.PRG
 \ Data....: 15-05-97
 \ Sistema.: Controle de Convˆnios
 \ Funcao..: Emiss„o Guias 1¦ Parte
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=11, c_s:=20, l_i:=14, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
so_um_reg=(PCOU()>2)
IF !so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+12 SAY " EMISSŽO DE GUIAS "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " N£mero:"
ENDI
gnumero=SPAC(7)                                    // N£mero
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF !so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+10 GET  gnumero;
                   PICT "@R 99-99999";
                   VALI CRIT("PTAB(gnumero,'GUIAS',1).AND.V00101F9()~N£MERO n„o existe na tabela")
                   AJUDA "Emitir a guia de n£mero?"
                   CMDF8 "VDBF(6,8,20,77,'GUIAS',{'numero','contrato','nome'},1,'R001gf9()')"
                   MOSTRA {"LEFT(TRAN(GUIAS->nome,[@!]),35)", 2 , 5 }

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
  IF !USEARQ("GUIAS",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GUIAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(medico,"MEDICOS",1,.t.)                      // abre arquivo p/ o relacionamento
 PTAB(contrato,"GRUPOS",1,.t.)                      // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->tipcont,"CLASSES",1,.t.)                      // abre arquivo p/ o relacionamento
 SET RELA TO medico INTO MEDICOS                 // relacionamento dos arquivos

 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,7,11)           // nao quis configurar...
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
 SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura‡„o do tamanho da p gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_024=LEFT(drvtapg,op_-1)+"033"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_024:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=17                                           // maximo de linhas no relatorio
IMPCTL(lpp_024)                                    // seta pagina com 24 linhas
SET MARG TO 1                                      // ajusta a margem esquerda
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop				// imprime qde copias pedida
  pg_=1; cl=999
  IF so_um_reg
   GO imp_reg
  ELSE
   INI_ARQ()                                       // acha 1o. reg valido do arquivo
   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[GUI],[IMPPAR],1)
    SEEK ALLTRIM(IMPPAR->docto)
   ENDI
  ENDI
  ccop++                                           // incrementa contador de copias
  ult_imp=0                                        // ultimo reg impresso
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
   IF (PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[GUI],[IMPPAR],1).AND.ano+numero=LEFT(IMPPAR->docto,7)) .OR. so_um_reg// se atender a condicao...
    PTAB(contrato,"GRUPOS",1,.t.)                      // abre arquivo p/ o relacionamento
    PTAB(GRUPOS->tipcont,"CLASSES",1,.t.)                      // abre arquivo p/ o relacionamento

    REL_CAB(1,.t.)                                 // soma cl/imprime cabecalho
    @ cl,000 SAY "GUIA DE ENCAMINHAMENTO  N§:"
    @ cl,027 SAY ano+'-'+numero+GDV1(ano+numero)   // N£mero
    @ cl,043 SAY IIF(guiapara='C',[Consulta],IIF(guiapara='E',[Exame],IIF(guiapara='I',[Interna‡„o],[     ])))// Guia Para
    IF M->combarra=[S]
     CODBARRAS({{ano+numero+GDV1(ano+numero),4,15,60}},10,6)
    ENDI
    ult_imp=RECNO()                                // ultimo reg impresso
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Para:"
    @ cl,008 SAY TRAN(MEDICOS->especialid,"@!")    // Especialidade
    IF M->combarra=[S]
     CODBARRAS({{ano+numero+GDV1(ano+numero),4,15,60}},10,6)
    ENDI
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Encaminhamento a.......:"
    @ cl,025 SAY ALLTRIM(MEDICOS->nome)+[ (]+ALLTRIM(medico)+[) ]+;// M‚dico
                 [ tel: ]+ ALLTRIM(MEDICOS->telefone)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o...............:",cl,000)
    @ cl,025 SAY MEDICOS->endereco// Endere‡o
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Atendimento dia........:"
    @ cl,025 SAY TRAN(emissao_,"@D")               // Emiss„o
    IMPAC("(V lido at‚ 30 dias)",cl,036)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Benefici rio principal.:",cl,000)
    @ cl,025 SAY TRAN([ (]+ALLTRIM(titular)+[ / ]+contrato+[)],"@!")+;// Titular
         [ ] +&drvpcom+ALLTRIM(CLASSES->descricao)+&drvtcom
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Pessoa a ser atendida..:"
    IMPCTL(drvpenf)
    @ cl,025 SAY TRAN(nome,"@!")                   // Nome
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",60)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Valor Particular:"
    @ cl,018 SAY tran(MEDICOS->valorpart,"@E 99,999,999.99")// Valor Particular
    @ cl,033 SAY "desconto de:"
    IF (MEDICOS->valorpart - valorcon)>0// pode imprimir?
     @ cl,046 SAY TRAN(MEDICOS->valorpart - valorcon,"@E 99,999,999.99")// Valor desconto
    ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Valor Total.....:"
    @ cl,018 SAY TRAN(valorcon+ valorexa,"@E 99,999,999.99")// Valor total
    @ cl,032 SAY LEFT([(]+LEFT(EXT(valorcon+valorexa),AT('/',EXT(valorcon+valorexa))-1)+[)],40)// Total p/Extenso
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,016 SAY SUBSTR([(]+LEFT(EXT(valorcon+valorexa),AT('/',EXT(valorcon+valorexa))-1)+[)],41,54)// Extenso (cont..)
    SKIP                                           // pega proximo registro
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
   exit
  ENDD
  REL_RDP(.t.)                                     // imprime rodape' do relatorio
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET MARG TO                                        // coloca margem esquerda = 0
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(7)                                           // grava variacao do relatorio
SELE GUIAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
IF so_um_reg
 POINTER_DBF(sit_dbf)
ENDI
RETU

STATIC PROC REL_RDP(volta_reg)                     // rodape'
LOCAL reg_atual:=RECNO()
IF volta_reg
 GO ult_imp                                        // ajusta reg p/ imp de campos no rodape'
ENDI
@ 16,000 SAY "" //chr(15)                               // comprime
IMPCTL(drvpcom)
@ 16,002 SAY [IMPORTANTE:- Esta guia tem a finalidade principal de encaminhamento em consultas e exames,]// Mensagem 1
@ 17,002 SAY [N„o dando direito a cirurgias, interna‡”es entre outros.]// Mensagem 2
@ 18,002 SAY [ - Esta guia s¢ ter  validade com o carimbo e assinatura do respons vel pela emiss„o.]// Mensagem 4
@ 19,002 SAY [ - A BOM PASTOR n„o se responsabiliza por procedimentos medicos e outros, visto ser de]
@ 20,002 SAY [   livre escolha do associado.]
@ 21,000 SAY "" //chr(18)                               // normal
IMPCTL(drvtcom)
@ 22,060 SAY [FR-OPE-0017]
@ 23,001 SAY replicate('- ',36)                    // traco
IF volta_reg
 GO reg_atual                                      // retorna reg a posicao original
ENDI
RETU

STATIC PROC REL_CAB(qt, volta_reg)                 // cabecalho do relatorio
volta_reg=IF(volta_reg=NIL,.f.,volta_reg)
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IF pg_>1
  REL_RDP(volta_reg)                               // imprime rodape' do relatorio
 ENDI
 IMPCTL(drvpenf)
 IMPEXP(0,000,LEFT(M->setup1,38),76)               // Setup1
 IMPCTL(drvtenf)
// @ 1,000 SAY M->defconv                            // Defconv
 @ 2,000 SAY M->setup2                             // setup2
 @ 3,000 SAY M->setup3                             // Setup3
 @ 4,000 SAY REPL("-",60)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de CON_R001.PRG
FUNC R001GF9
RETURN ano+numero
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623.
 \ Programa: V00101F9.PRG
 \ Data....: 03-10-95
 \ Sistema.: Controle de Convˆnios
 \ Funcao..: Valida‡„o da variavel GNUMERO, relatorio CON_R001
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

//#include "ADRbig.ch"    // inicializa constantes manifestas
func v00101f9
//PARAMETROS('pnumero',gnumero)

  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[GUI],[IMPPAR],1)
   ord_=LEN(sistema[EVAL(qualsis,"IMPPAR"),O_CHAVE])
   FAZ_LANC("IMPPAR",[ ])
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
	IMPPAR->base WITH [GUI]
  ENDI
   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[GUI],[IMPPAR],1)
    REPBLO('IMPPAR->docto',{||gnumero})
   ENDI

RETU .T.      // <- deve retornar um valor L¢GICO

* \\ Final de V00101F9.PRG
