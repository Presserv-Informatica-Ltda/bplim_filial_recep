/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: GUI_07F9.PRG
 \ Data....: 23-05-98
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Fun‡„o de busca do inscrito, arquivo GUIAS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
LOCAL reg_dbf
PTAB([],[GRUPOS],1,.t.)
IF !(op_menu=INCLUSAO)
 retu .t.
ENDI
PARA cod_igo
reg_dbf:=POINTER_DBF()
PRIVA respx,nomx:=space(35)
codigo:=contrato:=cod_igo
nome:=space(35)
IF EMPT(VAL(contrato)) //=[000000]
 nomx=DBOX("Nome",,,,,"Informe o nome a procurar",nomx,"@!")

 IF PTAB(alltrim(nomx),[GRUPOS],2,.t.)
	codigo:=contrato:=GRUPOS->codigo
	codigo:=VDBF(6,3,20,77,'GRUPOS',{'nome','codigo','endereco','tcarencia'},2,'codigo')
	nome:=GRUPOS->nome
  contrato:=M->codigo


 ELSEIF PTAB(alltrim(nomx),[INSCRITS],2,.t.)
	codigo:=contrato:=INSCRITS->codigo //+INSCRITS->grau+STR(INSCRITS->seq,2)
  nome:=alltrim(inscrits->nome)
	codigo:=VDBF(6,3,20,77,'INSCRITS',{'nome','codigo','grau','tcarencia'},2,'codigo')
	nome:=INSCRITS->nome
  codigo:=contrato:=IIF(codigo=NIL,[         ],left(codigo,9))

 ENDI

 IF LASTKEY()=K_ESC             // se teclou ESC
	codigo:=contrato:=[         ]
	POINTER_DBF(reg_dbf)
	RETU .f.
 ENDI
ELSEIF LEN(ALLTRIM(contrato))<9.AND.!EMPT(COntrato)
 msg_ins:=cod_msg:=[]
 nopc:=1
 tem10:=ptab('010'+strzero(VAL(contrato),6),[GRUPOS],1)
 IF tem10
  cod_msg+=GRUPOS->codigo
 	msg_ins+=GRUPOS->codigo+' '+GRUPOS->nome//+' '+GRUPOS->endereco+' '//+DTOC(GRUPOS->tcarencia)
 ENDI

 tem20:=ptab('020'+strzero(VAL(contrato),6),[GRUPOS],1)
 IF tem20
  IF tem10
   msg_ins+=[|]
  ENDI
  cod_msg+=GRUPOS->codigo
 	msg_ins+=GRUPOS->codigo+' '+GRUPOS->nome//+' '+GRUPOS->endereco//+' '+DTOC(GRUPOS->tcarencia)
 ENDI
 if len(cod_msg) > 9
  msg_:=[Escolha o contrato|Codigo Nome                           Endereco]
  nopc:=DBOX(msg_ins,,,E_MENU,,msg_,,,nopc)
 endi
 codigo:=SUBSTR(cod_msg,((nopc-1)*10)+1,10)


ENDI
respx:=contrato:=codigo

IF PTAB(respx,[GRUPOS],1)
 titular:=GRUPOS->nome
ENDI

POINTER_DBF(reg_dbf)

retu PTAB(respx,[GRUPOS])	 // <- deve retornar um valor qualquer

* \\ Final de GUI_02F9.PRG
