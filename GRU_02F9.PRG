procedure gru_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: GRU_02F9.PRG
 \ Data....: 22-02-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Fun‡„o F8 do campo CODIGO, arquivo GRUPOS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adRbig.ch"    // inicializa constantes manifestas

//LOCAL reg_dbf:=POINTER_DBF()
DO WHILE .T.
 rgruin:=VDBF(6,32,20,77,'ARQGRUP',{'grup','classe','inicio','final','ultcirc','emissao_'},1,'grup',[])
 IF LASTKEY()=K_ESC          // nao confirmou...
  rcodin:=' '
  EXIT                                  // retorna para o DOS
 ENDI
 PTAB(rgruin,[ARQGRUP],1)
 rcodin:=ARQGRUP->inicio

 DO WHILE PTAB(M->rcodin,[GRUPOS],1).and.rcodin<=ARQGRUP->final
  rcodin:=sTRzero(VAL(rcodin)+1,6,0)
 ENDD

 IF M->rcodin>ARQGRUP->final
  M->rcodin:=ARQGRUP->inicio
  DO WHILE PTAB(rcodin,[GRUPOS],1).and.rcodin<=ARQGRUP->final
   IF GRUPOS->situacao='2'
    EXIT
   ENDI
   M->rcodin:=sTRzero(VAL(rcodin)+1,6,0)
  ENDD
 ENDI
 IF M->rcodin>ARQGRUP->final
  M->rcodin:='000000'
  DBOX("Grupo sem vagas, "+usuario,13,45,2)   // Grupo cheio!.Fazer oque?
 ELSE
  EXIT
 ENDI
ENDD

//POINTER_DBF(reg_dbf)

RETU M->rcodin       // <- deve retornar um valor qualquer

* \\ Final de GRU_02F9.PRG
