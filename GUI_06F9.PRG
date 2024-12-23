/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: GUI_02F9.PRG
 \ Data....: 23-05-98
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Fun‡„o F8 do campo NOME, arquivo GUIAS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL reg_dbf:=POINTER_DBF()
PRIVA nopc:=1, respx:=space(30), ctx:=0
PTAB(ALLTRIM(contrato),[INSCRITS],1,.t.)
nopc:=1
ctx:=0
msg_ins:=[]
SELE INSCRITS
DO WHIL !EOF() .AND. INSCRITS->codigo=ALLTRIM(contrato)
 msg_ins+=INSCRITS->nome+[ (]+;
 LEFT(TRAN(SUBSTR([TitPaiMaeSgoSgaEspFilDep],(VAL(grau)-1)*3+1,3),[]),03)+;
 [) tc ]+DTOC(INSCRITS->tcarencia)+[ ]+vivofalec+[ ]+tipo+[|]
 ctx++
 IF (M->nome = INSCRITS->nome)
	nopc:=ctx
 ENDI
 SKIP
ENDD

POINTER_DBF(reg_dbf)
IF !EMPT(msg_ins)
 nopc:=DBOX(msg_ins,,,E_MENU,,[Escolha o Benefici rio],,,nopc)
 respx:=substr(msg_ins,(nopc-1)*62+1,35)
ENDI

IF LASTKEY()=K_ESC             // se teclou ESC
 RETU nil
ENDI

RETU respx
// <- deve retornar um valor qualquer

* \\ Final de GUI_02F9.PRG
