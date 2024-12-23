
procedure adc_rx76
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADC_RX76.PRG
 \ Data....: 14-09-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Ficha de Acerto
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \ Convert.: v5.0 em 2021081014:56:16 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=15, l_i:=18, c_i:=65, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
so_um_reg=(PCOU()>2)
IF !so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
 @ l_s,c_s+14 SAY " CONTRATOS & COBRAN€AS "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Situacao....:"
 @ l_s+02,c_s+1 SAY " Contratos de:                  at‚:"
 @ l_s+03,c_s+1 SAY " Vencimentos de:                at‚:"
 @ l_s+04,c_s+1 SAY " Imprimir as cobran‡as j  pagas?"
 @ l_s+05,c_s+1 SAY " Imprimir as cobran‡as vencidas?"
 @ l_s+06,c_s+1 SAY " M¡nimo de pendentes a listar..:"
 @ l_s+07,c_s+1 SAY "                     Confirme?"
ENDI
cods=[0123456789]
codi=SPAC(9)                                       // Codigo
codf=SPAC(9)                                       // Codigo
veni_=CTOD('')                                     // Venc.Inicial
venf_=DATE() //CTOD('')                                     // Venc.Final
pag=[S] //SPAC(1)                                        // Pagas?
pend=[S] //SPAC(1)                                       // Pendentes?
rpend=0                                            // Nrpend
confirme=[S] //SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF !so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
/*
  @ l_s+01 ,c_s+22 GET  cods;
									PICT "9"
*/
  @ l_s+02 ,c_s+22 GET  codi;
									PICT "999999999";
									VALI CRIT("PTAB(codi,'GRUPOS',1).OR.VAL(codi)=0~Necess rio informar CODIGO existente")
									AJUDA "Informe o n£mero do contrato"
									CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"
/*
 @ l_s+02 ,c_s+41 GET  codf;
									PICT "999999";
									VALI CRIT("(PTAB(codf,'GRUPOS',1).AND.codf>=codi).OR.VAL(codf)=0~Necess rio informar CODIGO existente")
									AJUDA "Informe o n£mero do contrato"
									CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+03 ,c_s+21 GET  veni_;
									PICT "@D"
									AJUDA "Informe o primeiro vencimento a considerar"

 @ l_s+03 ,c_s+40 GET  venf_;
									PICT "@D"
									AJUDA "Informe o £ltimo vencimento a considerar"

 @ l_s+04 ,c_s+34 GET  pag;
									PICT "!";
									VALI CRIT("pag$([SN])~PAGAS? n„o aceit vel|Digite S ou N")
									DEFAULT "[N]"
									AJUDA "Digite S para listar as cobran‡as pagas."

 @ l_s+05 ,c_s+34 GET  pend;
									PICT "!";
									VALI CRIT("pend$([SN])~PENDENTES? n„o aceit vel|Digite S ou N")
									DEFAULT "[S]"
									AJUDA "Digite S para listar as cobran‡as pendentes"

 @ l_s+06 ,c_s+34 GET  rpend;
									PICT "99";
									VALI CRIT("rpend>0~NRPEND n„o aceit vel")
									DEFAULT "3"
									AJUDA "Informe o n£mero m¡nimo de taxas|pendentes para listar"

 @ l_s+07 ,c_s+32 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'~CONFIRME n„o aceit vel")
                  AJUDA "Digite S para confirmar|ou|tecle ESC para cancelar"
*/
  READ
  SET KEY K_ALT_F8 TO
  IF rola_t
   ROLATELA(.f.)
   LOOP
  ENDI
  IF LASTKEY()=K_ESC                                // se quer cancelar
   RETU                                             // retorna
  ENDI
 ENDI

 #ifdef COM_REDE
  CLOSE GRUPOS
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
	 RETU                                            // volta ao menu anterior
	ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(codigo,"ECOB",1,.t.)                         // abre arquivo p/ o relacionamento
 SET RELA TO codigo INTO ECOB                      // relacionamento dos arquivos
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,52,11)           // nao quis configurar...
   CLOS ALL                                         // fecha arquivos e
   LOOP                                             // volta ao menu
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
   tps:=3                                         // se vai para arquivo/video
 ENDIF
 SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

cpord="codigo"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
codf:=codi
veni:=CTOD([01/01/1970])
#ifdef COM_REDE
 IF !USEARQ("INSCRITS",.f.,10,1)                   // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("INSCRITS")                                // abre o dbf e seus indices
#endi

cpord="codigo"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos

SELE GRUPOS
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
   IF codigo > M->codi
    GO BOTT
    SKIP
    LOOP
   ENDI
	 IF (codigo>=M->codi.AND.(M->codf=[000000000].OR.codigo<=M->codf));
    .OR. so_um_reg                  // se atender a condicao...
    IF !(so_um_reg.OR.(GRUPOS->situacao$M->cods))
     SKIP
     LOOP
    ENDI
    PTAB(GRUPOS->tipcont,[CLASSES],1)
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		 IMPCTL(drvpenf)
		@ cl,000 SAY TRAN(codigo,"999999999")            // Codigo
		@ cl,006 SAY "-"
		@ cl,007 SAY TRAN(grupo,"!!")                  // Grupo
		@ cl,010 SAY nome                              // Nome
		 IMPCTL(drvTenf)
    IF !EMPT(xDECRIPT(telefone)+contato)
		 @ cl,046 SAY LEFT(ALLTRIM(xDECRIPT(telefone))+[/]+alltrim(contato),33)// Telefone
    ENDI
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		@ cl,010 SAY TRAN(xDECRIPT(endereco),"@!")               // Endere‡o
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,010 SAY TRAN(ALLTRIM(xDECRIPT(bairro))+[ ]+ALLTRIM(xDECRIPT(cidade))+[, ]+uf+[ - CEP:]+TRAN(cep,"@R 99999-999"),"@!")// Cidade
		subtt=0                                        // variavel temporaria
		@ cl,067 SAY "Vend/Reg/Cob"
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		IMPAC("Admiss„o:",cl,010)
		@ cl,020 SAY TRAN(admissao,"@D")               // Admiss„o
		@ cl,032 SAY "SaiTxa:"
		@ cl,040 SAY TRAN(saitxa,"@R 99/99")           // Saitxa
		@ cl,047 SAY "Dia Pgto:"
		@ cl,057 SAY TRAN(diapgto,"99")                // Dia Pgto.
		@ cl,068 SAY vendedor+[/]+regiao+[/]+cobrador  // Vend/Cob/Reg
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,010 SAY [Cir.Inic.]+circinic+[   Ultima: ]+ultcirc+;
                 [   Quant.: ]+STR(qtcircs,3)+[   Nr.funerais: ]+str(funerais,3)
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,010 SAY [Categoria: ]+GRUPOS->tipcont+[ ]+CLASSES->descricao
		IF !ECOB->(EOF())
		 SELE ECOB
		 REL_CAB(1)                                     // soma cl/imprime cabecalho
		 IF ECOB->tipo=[T]
			@ cl,002 SAY [Endereco de trabalho]
		 ELSEIF ECOB->tipo=[R]
			@ cl,002 SAY [Endereco de residencia]
		 ELSE
			@ cl,002 SAY [Outro endereco  ]
		 ENDI
		 REL_CAB(1)                                     // soma cl/imprime cabecalho
		 @ cl,010 SAY TRAN(endereco,"@!")+[ ]+telefone  // Endere‡o
		 REL_CAB(1)                                     // soma cl/imprime cabecalho
		 @ cl,010 SAY TRAN(ALLTRIM(bairro)+[ ]+ALLTRIM(cidade)+[, ]+uf+[ - CEP:]+TRAN(cep,"@R 99999-999"),"@!")// Cidade
		 SELE GRUPOS
		ENDI
	 chv088=codigo
	 SELE INSCRITS
	 SEEK chv088
	 IF FOUND()
		 cl+=1                                         // soma contador de linha
		 @ cl,002 SAY REPL("-",77)
		 cl+=1                                         // soma contador de linha
		 IMPAC("Inscritos no contrato                      Observa‡„o",cl,002)
		 cl+=1                                         // soma contador de linha
//		 @ cl,002 SAY "=====  =================================== ========== ======================="
		DO WHIL ! EOF() .AND. chv088=codigo //LEFT(&(INDEXKEY(0)),LEN(chv088))
		 #ifdef COM_TUTOR
			IF IN_KEY()=K_ESC                            // se quer cancelar
		 #else
			IF INKEY()=K_ESC                             // se quer cancelar
		 #endi
			IF canc()                                    // pede confirmacao
			 BREAK                                       // confirmou...
			ENDI
		 ENDI
		 REL_CAB(1)                                    // soma cl/imprime cabecalho
		 DO CASE
		 CASE grau=[1]
			@ cl,002 SAY [Tit  ]                          // Inscr.
		 CASE grau=[2]
			@ cl,002 SAY [Pai  ]                          // Inscr.
		 CASE grau=[3]
			@ cl,002 SAY [Mae  ]                          // Inscr.
		 CASE grau=[4]
			@ cl,002 SAY [Sogro]                          // Inscr.
		 CASE grau=[5]
			@ cl,002 SAY [Sogra]                          // Inscr.
		 CASE grau=[6]
			@ cl,002 SAY [Espos]                          // Inscr.
		 CASE grau=[7]
			@ cl,002 SAY [Filh ]                          // Inscr.
		 CASE grau=[8]
			@ cl,002 SAY [Depen]                          // Inscr.
		 ENDC
//		 @ cl,002 SAY grau+'-'+STR(seq,2)              // Inscr.
		 @ cl,009 SAY nome                             // Nome
//		 @ cl,045 SAY TRAN(nascto_,"@D")               // Nascto
		 IF !EMPT(falecto_)
			@ cl,045 SAY [Falec. em ]+TRAN(falecto_,"@D")              // Falecto.
		  @ cl,066 SAY TRAN(tipo,"!!!")                 // Tipo
		  @ cl,070 SAY TRAN(procnr,"@R 99999/99")       // N§Processo
		 ENDI
		 SKIP                                          // pega proximo registro
		ENDD
	 ENDI
	 SELE GRUPOS                                     // volta ao arquivo pai

		tot091004 := 0                                 // inicializa variaves de totais
		chv091=codigo
		SELE TAXAS
		SEEK chv091
		vlatras:=vlemdia:=0
		IF FOUND()
		 // Corrigir o valor antes de listar
		 DO WHILE !EOF().AND.TAXAS->codigo==GRUPOS->codigo
			IF EMPT(TAXAS->valorpg)
			 IF TAXAS->emissao_< DATE()
				vlatras+=R07702F9()
			 ELSE
				vlemdia+=TAXAS->valor
			 ENDI
			ENDI

			SKIP
		 ENDD
		 // De volta ao inicio
		 SELE TAXAS
		 SEEK chv091

		 IF cl+3>maxli                                 // se cabecalho do arq filho
			REL_CAB(0)                                   // nao cabe nesta pagina
		 ENDI                                          // salta para a proxima pagina
		 cl+=2                                         // soma contador de linha
		 @ cl,002 SAY REPL("-",77)
		 cl+=1                                         // soma contador de linha
		 IMPAC("Cobran‡as do contrato ",cl,002)
		 cl+=1                                         // soma contador de linha
		 IMPAC("Circular Vencimento    Valor       Observa‡„o",cl,002)
		 IMPCTL(drvpenf)
     IF codigo>=[010600001].AND.codigo<[010800000]
      @ cl,50 SAY [*Valor em atraso: ]+TRAN(vlatras,"@E 9,999.99")   // Valor
     ELSE
      @ cl,50 SAY [*Valor do debito: ]+TRAN(vlatras+vlemdia,"@E 9,999.99")   // Valor
     ENDI
		 IMPCTL(drvtenf)
		 cl+=1                                         // soma contador de linha
//		 @ cl,002 SAY "======== ========== ========== =============================="
		 qqu091=0                                      // contador de registros
     addcl=0
		 DO WHIL ! EOF() .AND. chv091=codigo //LEFT(&(INDEXKEY(0)),LEN(chv091))
			#ifdef COM_TUTOR
			 IF IN_KEY()=K_ESC                           // se quer cancelar
			#else
			 IF INKEY()=K_ESC                            // se quer cancelar
			#endi
			 IF canc()                                   // pede confirmacao
				BREAK                                      // confirmou...
			 ENDI
			ENDI
			IF R07701F9()                                // se atender a condicao...
			 IF addcl=0
        REL_CAB(1)                                  // soma cl/imprime cabecalho
       ENDI

//			 IF R07701F9()                               // pode imprimir?
				IF TYPE("omt091001")!="C" .OR. omt091001!=tipo// imp se dif do anterior
//				 @ cl,003 SAY TRAN(tipo,"!")               // Tipo
				 omt091001=tipo                            // imp se dif do anterior
				ENDI
//			 ENDI
			 @ cl,002+addcl SAY IIF(emissao_<DATE(),[*],[ ])
			 @ cl,003+addcl SAY TRAN(tipo,"!")               // Tipo
			 @ cl,004+addcl SAY "-"
			 @ cl,005+addcl SAY TRAN(circ,"999")               // Circular
			 @ cl,009+addcl SAY TRAN(emissao_,"@D")            // Emissao
			 vlpend=R07702F9()                           // variavel temporaria
			 tot091004+=vlpend
			 @ cl,020+addcl SAY TRAN(vlpend,"@E 9,999.99")   // Valor
			 vlpg=valorpg                                // variavel temporaria
			 subtt=subtt+vlpend-vlpg                     // variavel temporaria
			 IF !EMPT(valorpg)                             // pode imprimir?
				@ cl,029+addcl SAY [Pg.]+LEFT(dtoc(pgto_),6)+;     // Obs.
                     RIGHT(dtoc(pgto_),2)
			 ENDI
       IF addcl=0
        addcl=40
       ELSE
        addcl=0
       ENDI
			 qqu091++                                    // soma contadores de registros
			 SKIP                                        // pega proximo registro
			ELSE                                         // se nao atende condicao
			 SKIP                                        // pega proximo registro
			ENDI
		 ENDD
		 IF cl+3>maxli                                 // se cabecalho do arq filho
			REL_CAB(0)                                   // nao cabe nesta pagina
		 ENDI                                          // salta para a proxima pagina
/*
		 @ ++cl,022 SAY REPL('-',10)
		 @ ++cl,022 SAY TRAN(subtt,"@E 999,999.99")// total Valor
		 @ cl,003 SAY "*** Quantidade "+TRAN(qqu091,"999")
*/
		 cl+=2
		 @ ++cl,002 SAY [OBS.: ]
     @ cl,002 say GET_MSG()
		 cl+=3                                    // soma cl/imprime cabecalho
		 @ cl,02 SAY [Data: ___ / ___ / ___]//
		 cl+=3
		 @ cl,002 SAY [________________________________]
		 @ cl,040 SAY [________________________________]
		 cl++
		 @ cl,002 SAY [Representante]
		 @ cl,040 SAY [Contratante]
		 cl+=2
		 @ ++cl,002 SAY [Valor para continuidade: ]+TRAN(subtt,"@E 999,999.99")// total Valor
		 @ ++cl,002 SAY [Valor para cancelamento: ]
		 @ ++cl,002 SAY [Calculo efetuado por...: ]

     cl+=2                                         // soma contador de linha

    ENDI
    SELE GRUPOS                                    // volta ao arquivo pai
    SKIP                                           // pega proximo registro
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO //(drvporta)                        // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(52)                                          // grava variacao do relatorio
SELE GRUPOS                                        // salta pagina
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
 IMPCTL(drvtcom)
 @ 0,000 SAY M->nemp                                // nome da empresa
 @ 0,071 SAY "PAG"
 @ 0,075 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,071 SAY "ADC_RX76"                            // c¢digo relat¢rio
 IMPAC("FICHA DE ACERTOS",2,000)
 @ 2,024 SAY titrel                                // t¡tulo a definir
 @ 2,060 SAY NSEM(DATE())                          // dia da semana
 @ 2,069 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY "Contrato  Nome                               "+IIF(!EMPT(telefone+contato)," Telefone/ Contato"," ")
 @ 4,000 SAY REPL("-",79)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADC_RX76.PRG

FUNC get_msg
msg:=[]
ctlmax:=IIF(GRUPOS->codigo=[020],60,10)
for ctmsg=1 to ctlmax
 IF ctlmax=10
  msgaux:=MEMOLINE(GRUPOS->obs,55,ctmsg)
 ELSE
  msgaux:=MEMOLINE(GRUPOS->obs,55,ctmsg)
 ENDI
 IF !EMPT(msgaux)
  msg+=msgaux
 ENDI
next
IF !EMPT(msg)
 msg+=chr(10)+chr(13)+[:============]
ENDI
PTAB([],[MENSAG])
SELE MENSAG
msg2add:=[]
msg2prt:=.f.
DO WHILE ! EOF()
 SELE GRUPOS
 cond=LEFT(MENSAG->filtro,AT("~",MENSAG->filtro)-1)               // condicao de validacao
 OP_=0
 MSGAUX:=[MENSAGEM]
 alerta()
 msg2prt:=.f.
 msg2add:=[]
 IF (&cond.)                                 // se condicao nao satisfeita,
  nrlin:=mlcount(MENSAG->mens1,50)
  FOR OP_ = 1 TO nrlin
   msgAUX:=MEMOLINE(MENSAG->mens1,50,OP_)
   msg2add+=msgAUX
   IF [ATEN]$msgAUX
    msg2prt:=.t.
   ENDIF
  NEXT
 ENDI
 IF msg2prt
  msg+=msg2add+chr(10)+chr(13)+[:============]
 ENDI
 SELE MENSAG
 SKIP
ENDD

RETU msg

FUNC R07701F9
donex:=(M->pag=[S].AND.TAXAS->valorpg>0)
donex:=donex.OR.(M->pend=[S].AND.TAXAS->valorpg=0)
//donex:=donex.AND.(EMPT(M->veni_).OR.TAXAS->emissao_>=M->veni_)
donex:=donex.AND.(EMPT(M->venf_).OR.TAXAS->emissao_<=M->venf_)

RETU M->donex       // <- deve retornar um valor L¢GICO

* \\ Final de R07701F9.PRG

FUNC R07702F9
PRIVA vladd:=0
IF TAXAS->emissao_< DATE()
 jrok:=PTAB(tipo,'JUROS',1)
 nrd:=(DATE() - TAXAS->emissao_)
 IF jrok .AND. (nrd > JUROS->mltcaren)
  vladd+=TAXAS->valor*JUROS->multa/100
 ENDI
 IF jrok .AND. (nrd > JUROS->jrscaren)
  vladd+=TAXAS->valor*JUROS->juros/100*nrd
 ENDI
ENDI

RETU IIF(EMPT(TAXAS->valorpg),TAXAS->valor+M->vladd,TAXAS->valorpg)

* \\ Final de R07702F9.PRG