
procedure bxr_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: BXR_01F9.PRG
 \ Data....: 20-11-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: F¢rmula (Circ 1 - 4) a mostrar na tela de BXREC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:58:06 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifesta

 LOCAL reg_dbf:=POINTER_DBF()
 LOCAL circax1:=circax2:=circax3:=circax4:=circax5:=circax6:=SPACE(46)
 LOCAL cipend:=ciatrz:=nrd:=vladd:=0, jrok
 IF !op_menu = INCLUSAO
  codigo:=BXREC->codigo
  RETU .T.
 ENDIF
 IF EMPT(codigo)
  RETU .T.
 ENDI
 dele_atu:=SET(_SET_DELETED,.t.)             // os excluidos nao servem...
 circax1:=circax2:=circax3:=circax4:=circax5:=circax6:=SPACE(46)

 PTAB(ALLTRIM(codigo),'GRUPOS',1)
 PTAB(ALLTRIM(codigo),'TAXAS',1)
 SELE TAXAS
 DO WHILE !EOF().AND.TAXAS->codigo=GRUPOS->codigo
  IF DELE()
   SKIP
   LOOP
  ENDI
  vladd:=0
  IF EMPT(TAXAS->valorpg)
   cipend++
   IF TAXAS->emissao_< DATE()
    ciatrz++
    jrok:=PTAB(tipo,'JUROS',1)
    nrd:=(DATE() - TAXAS->emissao_)
    IF jrok .AND. (nrd > JUROS->mltcaren)
     vladd+=TAXAS->valor*JUROS->multa/100
    ENDI
    IF jrok .AND. (nrd > JUROS->jrscaren)
     vladd+=TAXAS->valor*JUROS->juros/100*nrd
    ENDI
   ENDI
  ENDI
  IF cipend < 5 .AND. TAXAS->emissao_ <= DATE()+60
   circax1:=circax2
   circax2:=circax3
   circax3:=circax4
   circax4:=[ ]+TAXAS->tipo+[ ]+TAXAS->circ+[ ]+DTOC(TAXAS->emissao_)+[ ]+;
      TRANSF(TAXAS->valor+M->vladd,"@E 99,999.99")+[ ]+DTOC(TAXAS->pgto_)+;
      TRANSF(TAXAS->valorpg,"@E 99,999.99") //+[ ]+TAXAS->cobrador
  ENDI
  SKIP
 ENDDO
 @ l_s+13, c_s+1 SAY SPACE(46)
 @ l_s+14, c_s+1 SAY SPACE(46)
 @ l_s+15, c_s+1 SAY SPACE(46)
 @ l_s+16, c_s+1 SAY SPACE(46)
 @ l_s+13, c_s+1 SAY circax1
 @ l_s+14, c_s+1 SAY circax2
 @ l_s+15, c_s+1 SAY circax3
 @ l_s+16, c_s+1 SAY circax4
 IF .t. //ciatrz > 4
  IF .t. // BXREC->tipo=' '
   DBOX(STRZERO(ciatrz,2)+" Circulares Pendentes Vencidas!",,,,,"ATEN€ŽO, "+usuario)
  ENDI
 ENDI
 POINTER_DBF(reg_dbf)
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos

RETU []         // <- deve retornar um valor qualquer

* \\ Final de BXR_01F9.PRG
