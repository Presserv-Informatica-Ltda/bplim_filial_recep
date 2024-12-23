procedure bxr_06f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: BXR_06F9.PRG
 \ Data....: 15-10-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Fun‡„o F8 do campo COBRANCA, arquivo BXREC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
LOCAL reg_dbf:=POINTER_DBF()
PRIVA nopc:=1, respx:=space(30), ctx:=0
if op_menu#INCLUSAO
 retu .t.
endi
PTAB(LEFT(codigo,9),[TAXAS],1,.t.)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
nopc:=0
ctx:=0
msg_ins:=[]
msg_arr:={}
SELE TAXAS

 DO WHILE !EOF().AND.TAXAS->codigo=GRUPOS->codigo.AND.ctx<60
  IF DELE()
   SKIP
   LOOP
  ENDI
	vladd:=0
	IF EMPT(TAXAS->valorpg)
	 IF TAXAS->emissao_< DATE()
		jrok:=PTAB([],'JUROS',1)
		nrd:=(DATE() - TAXAS->emissao_)
		IF jrok .AND. (nrd > JUROS->mltcaren)
		 vladd+=TAXAS->valor*JUROS->multa/100
		ENDI
		IF jrok .AND. (nrd > JUROS->jrscaren)
		 vladd+=TAXAS->valor*JUROS->juros/100*nrd
		ENDI
	 ENDI
	ENDI
	/*
	msg_ins+=SUBSTR(TAXAS->codigo,11)+[ ]+DTOC(TAXAS->emissao_)+[ ]+;
			TRANSF(TAXAS->valor+M->vladd,"@E 99,999.99")+[ ]+DTOC(TAXAS->pgto_)+;
			TRANSF(TAXAS->valorpg,"@E 99,999.99")+[|]//+TAXAS->cobrador
	*/
	ctx++
/*
	AADD(msg_arr,{ TAXAS->cobranca+[ ]+DTOC(TAXAS->emissao_)+[ ]+;
			TRANSF(TAXAS->valor+M->vladd,"@E 99,999.99")+[ ]+DTOC(TAXAS->pgto_)+;
			TRANSF(TAXAS->valorpg,"@E 99,999.99")+[|],TAXAS->emissao_, TAXAS->valorpg } )
*/
	AADD(msg_arr,{ TAXAS->codigo+[ ]+DTOC(TAXAS->emissao_)+[ ]+;
			TRANSF(TAXAS->valor+M->vladd,"@E 99,999.99")+[ ]+DTOC(TAXAS->pgto_)+;
			TRANSF(TAXAS->valorpg,"@E 99,999.99")+[|],TAXAS->emissao_, TAXAS->valorpg } )

 SKIP
ENDD

POINTER_DBF(reg_dbf)
IF ctx>0
 ASORT(msg_arr,,,{ |x, y| x[2] < y[2] } )
 for ctx_x=1 to ctx
	msg_ins+=msg_arr[ctx_x] [1]
	IF msg_arr[ctx_x] [3]= 0.and.nopc=0
	 nopc=ctx_x
	ENDI
 next ctx_x
 msg_:=[Escolha a Parcela|Circ. Vencimento   Valor  Pagamento   Vlr.Pg]
 nopc:=DBOX(msg_ins,,,E_MENU,,msg_,,,nopc)
ENDI

IF LASTKEY()=K_ESC             // se teclou ESC
 RETU nil
ENDI
if nopc>0
 respx:=substr(msg_ins,(nopc-1)*57+1,56)
 tipo=left(respx,1)
 circ=substr(respx,3,3)
 valorpg=msg_arr[nopc] [3]
// respx:=LEFT(codigo,9)+respx
else
 respx:=[]
endi
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU respx

* \\ Final de BXR_06F9.PRG
/*
Quem (nome/depto)
quando (data/hora)
pedido:
motivo da solicitacao/problema ocorrido:
Nr.Protocolo:
*/