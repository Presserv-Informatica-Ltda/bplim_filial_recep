/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: CAD_04F9.PRG
 \ Data....: 22-04-97
 \ Sistema.: Controle de Processos da Funer ria
 \ Funcao..: Valida‡„o do campo CONTRATO, arquivo CADPROC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
para op_menu
LOCAL reg_dbf1:=POINTER_DBF() , contraux:=GRUPOS->codigo
LOCAL cipend:=vlpend:=0
IF !(op_menu=INCLUSAO)
 retu .t.
ENDI

IF !(contraux=ultcodmsg)
 msg:=[  --->   A T E N C A O  <---|| FAVOR CONFIRMAR|| CPF e Data de Nascimento||]
 KEY2seek:=[ABCDEFGHIJKLMNOPQRSTUVYXWZ]
 KEY2seek+=key2seek
 KEY2seek+=key2seek
 key2press:=[]
 do while EMPT(key2press)
  key2press:=right(str(seconds()),2)
  if (key2press=[00])
   key2press:=[]
  endi
 endd
 key2press:=substr(key2seek,val(key2press),1)

 msg+=[     Tecle <]+key2press+[> para sair|]
// msg+=[     Tecle algo para sair|]
 pressedkey:=[ ]
 do while !(pressedkey=key2press)
  pressedkey:=DBOX(msg,,,,,"ATEN€ŽO! "+usuario," ","!",,)        // avisa ao usuario
  pressedkey:=UPPER(pressedkey)
//  EXIT
 endd
 ultcodmsg:=contraux
endi
msg_obs_aux:=msg:=[]
IF PTAB(contraux,[MFILIAL],2,.t.)
 SELE MFILIAL
 DO WHILE !EOF().AND.codigo=contraux
  IF DELE()
   SKIP
   LOOP
  ENDI
  msg_obs_aux+=[**> ATENCAO   ATENCAO   ATENCAO <**]+[|]
  msg_obs_fim:=[***--(]+ALLTRIM(idxd)+[)--***]+[|]
  IF !EMPT(tcarenc_)
   msg_obs_aux+=[ Contrato em Carencia por negociacao ate ]+dtoc(TCARENc_)+[|]
  ENDI
  msg_obs_aux+=ALLTRIM(obs1)+[|]+;
                         ALLTRIM(obs2)+[|]+;
                         ALLTRIM(obs3)+[|]+;
                         msg_obs_fim
  SKIP
  msg_obs_fim:=[]
 ENDD
 msg:=msg_obs_aux
ENDI
ctlmax:=IIF(GRUPOS->codigo=[020],60,10)
for ctmsg=1 to ctlmax
 IF ctlmax=10
  msgaux:=MEMOLINE(GRUPOS->obs,60,ctmsg)
 ELSE
  msgaux:=MEMOLINE(GRUPOS->obs,60,ctmsg)
 ENDI
 IF !EMPT(msgaux)
  msg+=msgaux+[|]
 ENDI
next
PTAB(LEFT(GRUPOS->codigo,09),'TAXAS',1)
SELE TAXAS
DO WHILE !EOF() .AND.codigo=LEFT(GRUPOS->codigo,09)
 IF valorpg=0.AND.emissao_<=DATE()
  msg+=[Contrato com 1 ou + d‚bitos pendentes.|]
  exit
 ENDI
 SKIP
ENDD
IF !EMPT(msg)
// op_=DBOX(msg,,,E_MENU,,"SITUACAO DO CONTRATO!") //
 op_=DBOX(msg,,,E_MENU,,"SITUACAO DO CONTRATO!") //
 msg:=[]
ENDI
PTAB([],[MENSAG])
SELE MENSAG
DO WHILE ! EOF()
 SELE GRUPOS
 cond=LEFT(MENSAG->filtro,AT("~",MENSAG->filtro)-1)               // condicao de validacao
 OP_=0
 msg:=[...]
 MSGAUX:=[MENSAGEM]
 alerta()
 IF (&cond.)                                 // se condicao nao satisfeita,
  nrlin:=mlcount(MENSAG->mens1,60)
  FOR OP_ = 1 TO nrlin
   msgAUX:=MEMOLINE(MENSAG->mens1,60,OP_)
   msg+=[|]+msgAUX
  NEXT
  msg+=[|...]
  ALERTA()                                   // beep, beep, beep
  DBOX(msg,,,E_MENU,,"ATEN€ŽO! "+usuario)        // avisa ao usuario
 ENDI
 SELE MENSAG
 SKIP
ENDD


 POINTER_DBF(reg_dbf1)

RETU .t.  // <- deve retornar um valor L¢GICO

* \\ Final de CAD_04F9.PRG
