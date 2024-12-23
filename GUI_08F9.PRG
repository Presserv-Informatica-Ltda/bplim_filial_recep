
procedure gui_08f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: GUI_08F9.PRG
 \ Data....: 23-05-98
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Fun‡„o de preenchimento do campo m‚dico, arquivo GUIAS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:56:48 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

//LOCAL reg_dbf:=POINTER_DBF()

PRIVA respx:=SPACE(10),nomx:=space(35)
PTAB([],[MEDICOS],1,.t.)
IF EMPT(medico).and.op_menu=INCLUSAO
 nomx=DBOX("Nome",,,,,"Informe o nome a procurar",nomx,"@!")
 IF PTAB(alltrim(nomx),[MEDICOS],2)
  medico:=MEDICOS->codbenefic
 ELSEIF PTAB(alltrim(nomx),[MEDICOS],3)
  medico:=MEDICOS->codbenefic
 ENDI
 Codbenefic=MEDICO
 Codbenefic:=VDBF(6,3,20,77,'MEDICOS',{'LEFT(oldespec,20)','nome','endereco','cidade','codbenefic','fonesdiv','fonecom1'},3,'codbenefic',[])
 MEDICO=Codbenefic
 IF LASTKEY()=K_ESC             // se teclou ESC
	medico=space(10)
//	POINTER_DBF(reg_dbf)
	RETU .f.
 ENDI
ELSE
 retur .t.
ENDI
respx:=medico
//dbox([>]+respx+[<])
//POINTER_DBF(reg_dbf)

retu PTAB(respx,[MEDICOS],1)  // <- deve retornar um valor qualquer

* \\ Final de GUI_02F9.PRG