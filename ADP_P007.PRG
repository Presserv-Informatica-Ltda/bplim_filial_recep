
procedure adp_p007
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADP_P007.PRG
 \ Data....: 11-01-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Lan‡amento de acertos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \ Convert.: v5.0 em 2021081014:56:41 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, sit_dbf2:=POINTER_DBF(), arr:=SETS()
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=7, c_s:=10, l_i:=12, c_i:=51, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
set curs on
SET KEY K_F2 TO                                   // retira das teclas F3 e F4 as
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+10 SAY " LAN€AMENTO DE ACERTOS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "    Contrato:"
@ l_s+02,c_s+1 SAY "    Gerar    parcelas de"
@ l_s+03,c_s+1 SAY "    com tipo  , n£mero inicial     e"
@ l_s+04,c_s+1 SAY "    vencimento a partir de         ."
rcodigo=codigo //SPAC(6)                                    // Codigo
parcf=0                                            // Parcf
vlparc=0                                           // Vlparc
rtipo=SPAC(1)                                      // Tipo
rcirc=SPAC(3)                                      // Circular
vini_=CTOD('')                                     // Vencimento
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+15 GET  rcodigo;
		  PICT "999999";
		  VALI CRIT("PTAB(rcodigo,'GRUPOS',1).AND.GRUPOS->situacao=[1]~Contrato cancelado |ou inexistente")
		  AJUDA "Informe o n£mero do contrato"
		  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+02 ,c_s+11 GET  parcf;
		  PICT "99";
		  VALI CRIT("parcf>0~PARCF n„o aceit vel")

 @ l_s+02 ,c_s+26 GET  vlparc;
		  PICT "99999999.99";
		  VALI CRIT("vlparc>0~VLPARC n„o aceit vel")

 @ l_s+03 ,c_s+14 GET  rtipo;
		  PICT "!";
		  VALI CRIT("!EMPT(rtipo)~TIPO n„o aceit vel")
		  AJUDA "Qual o tipo de lan‡amento"
		  CMDF8 "MTAB([1=J¢ia |2=Taxa |3=Carnˆ|4=Acerto|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnˆ+Seguro],[TIPO])"

 @ l_s+03 ,c_s+32 GET  rcirc;
		  PICT "999";
		  VALI CRIT("!EMPT(rcirc)~Necess rio informar n£mero de CIRCULAR v lida")
		  AJUDA "Informe o n£mero da circular inicial a gerar"

 @ l_s+04 ,c_s+28 GET  vini_;
		  PICT "@D";
		  VALI CRIT("vini_>=DATE()~Necess rio informar Data v lida")
		  AJUDA "Data da Vencimento Circular|Mantido pela emissao do recibo"

 READ
 SET KEY K_ALT_F8 TO
 sets(arr)
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
  SET KEY K_F2 TO adp_p007                                  // retira das teclas F3 e F4 as
  RETU                                             // retorna
 ENDI
 EXIT
ENDD
cod_sos=1
msgt="LAN€AMENTO DE ACERTOS"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
  CLOSE GRUPOS
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

 SELE GRUPOS                                       // processamentos apos emissao
 PTAB(M->rcodigo,[GRUPOS],1)
// INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.codigo=M->rcodigo
  FOR nparc=1 TO parcf
   IF !PTAB(codigo+rtipo+RIGHT('00'+ALLTRIM(STR(nparc+VAL(rcirc)-1)),3) ,[TAXAS],1)

   SELE TAXAS                                      // arquivo alvo do lancamento

   #ifdef COM_REDE
    DO WHIL .t.
     APPE BLAN                                     // tenta abri-lo
     IF NETERR()                                   // nao conseguiu
      DBOX(ms_uso,20)                              // avisa e
      LOOP                                         // tenta novamente
     ENDI
     EXIT                                          // ok. registro criado
    ENDD
   #else
    APPE BLAN                                      // cria registro em branco
   #endi

   SELE GRUPOS                                     // inicializa registro em branco
   REPL TAXAS->codigo WITH codigo,;
	TAXAS->tipo WITH rtipo,;
	TAXAS->circ WITH RIGHT('00'+ALLTRIM(STR(nparc+VAL(rcirc)-1)),3),;
	TAXAS->emissao_ WITH P00801F9(),;
	TAXAS->valor WITH M->vlparc,;
	TAXAS->cobrador WITH cobrador
   ELSEIF TAXAS->valorpg>0
	// nada faz
   ELSE
    msgt1:=[Taxa ]+codigo+[-]+rtipo+[-]+;
	   RIGHT('00'+ALLTRIM(STR(nparc+VAL(rcirc)-1)),3)+[ j  existe]
    op_1=DBOX("Substituir|Ignorar esta TAXA",,,E_MENU,,msgt1)
    if op_1=1
     SELE TAXAS
     BLOREG(0,.05)
     REPL TAXAS->emissao_ WITH P00801F9(),;
	TAXAS->valor WITH M->vlparc,;
	TAXAS->cobrador WITH cobrador
     UNLOCK
     SELE GRUPOS
    endi
   ENDI


   #ifdef COM_REDE
    TAXAS->(DBUNLOCK())                            // libera o registro
   #endi

  NEXT
  exit
  //SKIP                                             // pega proximo registro
 ENDD
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)
// DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
POINTER_DBF(sit_dbf2)
imprela()
SET KEY K_F2 TO adp_p007                                  // retira das teclas F3 e F4 as
RESTSCREEN(,0,MAXROW(),79,tela_fundo)                // restaura tela do fundo

//CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de ADP_P007.PRG

/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: P00801F9.PRG
 \ Data....: 11-01-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Lan‡amento em TAXAS->emissao_, gerado por ADP_P008
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:56:47 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
FUNCT P00801F9
PRIV dataux, diaaux

    diaaux:=LEFT(DTOC(vini_),3)+SUBSTR(DTOC(vini_-DAY(vini_)+1+(31*(nparc-1))),4)
    dataux:=CTOD(M->diaaux)
    DO WHILE EMPT(M->dataux)
     diaaux:=STR(VAL(LEFT(diaaux,2))-1,2)+SUBSTR(diaaux,3)
     dataux:=CTOD(M->diaaux)
    ENDD



RETU M->dataux      // <- deve retornar um valor DATA

* \\ Final de P00801F9.PRG