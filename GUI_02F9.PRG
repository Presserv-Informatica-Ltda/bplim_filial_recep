
procedure gui_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: GUI_02F9.PRG
 \ Data....: 22-11-95
 \ Sistema.: Controle de Convˆnios
 \ Funcao..: F¢rmula (circ 1-4) a mostrar na tela de GUIAS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:57:59 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

 LOCAL reg_dbf:=POINTER_DBF()
 LOCAL circax1:=circax2:=circax3:=circax4:=circax5:=circax6:=SPACE(46)
 LOCAL cipend:=ciatrz:=nrd:=vladd:=0, jrok
 IF !op_menu = INCLUSAO
	contrato:=GUIAS->contrato
 ENDIF
 dele_atu:=SET(_SET_DELETED,.t.)             // os excluidos nao servem...


 PTAB(contrato,'GRUPOS',1)
 PTAB(contrato,'TAXAS',1)
 SELE TAXAS

 DO WHILE !EOF() .AND. TAXAS->codigo = GRUPOS->codigo
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
  IF cipend < 4 .AND. TAXAS->emissao_ <= DATE()+30
   circax1:=circax2
   circax2:=circax3
   circax3:=circax4
   circax4:=[ ]+TAXAS->tipo+[ ]+TAXAS->circ+[ ]+DTOC(TAXAS->emissao_)+[ ]+;
      TRANSF(TAXAS->valor+M->vladd,"@E 99,999.99")+[ ]+DTOC(TAXAS->pgto_)+;
      TRANSF(TAXAS->valorpg,"@E 99,999.99") //+[ ]+TAXAS->cobrador
  ENDI
  SKIP
 ENDDO
 @ l_s+06, c_s+1 SAY SPACE(56)
 @ l_s+07, c_s+1 SAY SPACE(56)
 @ l_s+08, c_s+1 SAY SPACE(56)
 @ l_s+09, c_s+1 SAY SPACE(56)
 @ l_s+06, c_s+1 SAY circax1
 @ l_s+07, c_s+1 SAY circax2
 @ l_s+08, c_s+1 SAY circax3
 @ l_s+09, c_s+1 SAY circax4

 POINTER_DBF(reg_dbf)



RETU []         // <- deve retornar um valor qualquer


* \\ Final de GUI_02F9.PRG
