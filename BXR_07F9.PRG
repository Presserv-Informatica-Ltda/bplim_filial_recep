procedure bxr_07f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: BXR_07F9.PRG
 \ Data....: 28-11-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Valor inicial do campo VALORPG, arquivo BXREC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
LOCAL reg_dbf:=POINTER_DBF()
PRIVA respx,nomx:=space(35)
if op_menu#INCLUSAO
 retu PTAB(codigo,[GRUPOS],1)
endi
PTAB([],[GRUPOS],1,.t.)

nome:=space(35)
//DBOX([>]+CODIGO+[<])
IF EMPT(codigo)
 nomx=DBOX("Nome",,,,,"Informe o nome a procurar",nomx,"@!")

 IF PTAB(alltrim(nomx),[GRUPOS],2,.t.)
	codigo:=GRUPOS->codigo
	codigo:=VDBF(6,3,20,77,'GRUPOS',{'nome','codigo','xDECRIPT(endereco)','tcarencia'},2,'codigo')
	nome:=GRUPOS->nome

 ELSE
  msgt="Nome n„o encontrado como titular|Procurar como inscrito?"
  ALERTA()
  op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
  IF op_ = 1
   IF !PTAB(alltrim(nomx),[INSCRITS],2,.t.)
    PTAB(ALLTRIM(LEFT(nomx,AT(' ',nomx))),[INSCRITS],2,.t.)
   ENDI
	 codigo:=INSCRITS->codigo+INSCRITS->grau+STR(INSCRITS->seq,2)
   nome:=alltrim(inscrits->nome)
	 codiGO:=VDBF(6,3,20,77,'INSCRITS',{'nome','codigo','grau','seq','tcarencia','vivofalec','tipo'},2,'codigo')
	 nome:=INSCRITS->nome
   codigo:=IIF(codigo=NIL,SPACE(9),left(codigo,9))
  ENDI

 ENDI

 IF LASTKEY()=K_ESC             // se teclou ESC
	codigo=SPACE(9)
	POINTER_DBF(reg_dbf)
	RETU .f.
 ENDI
ELSEIF LEN(ALLTRIM(codigo))<9.AND.!EMPT(CODIGO)
 msg_ins:=cod_msg:=[]
 nopc:=1
 tem10:=ptab('010'+strzero(VAL(codigo),6),[GRUPOS],1)
 IF tem10
  cod_msg+=GRUPOS->codigo
 	msg_ins+=GRUPOS->codigo+' '+GRUPOS->nome//+' '+xDECRIPT(GRUPOS->endereco)+' '//+DTOC(GRUPOS->tcarencia)
 ENDI

 tem20:=ptab('020'+strzero(VAL(codigo),6),[GRUPOS],1)
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
 codigo:=SUBSTR(cod_msg,((nopc-1)*9)+1,9)

ENDI
respx:=LEFT(codigo,9)

IF PTAB(respx,[GRUPOS],1)
 titular:=GRUPOS->nome
// dbox(titular+respx)
ENDI

POINTER_DBF(reg_dbf)

retu PTAB(respx,[GRUPOS],1)	 // <- deve retornar um valor qualquer


