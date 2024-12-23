
procedure r00101f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: R00101F9.PRG
 \ Data....: 15-10-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: importante do relat¢rio CON_R001
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:58:08 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

/*
   -------------------------------------------------------------------
   Se abrir outros arquivos salve situacao anterior e restaure ao sair
   como no exemplo abaixo:
     LOCAL reg_dbf:=POINTER_DBF()
     ...        ...        ...        ...
     POINTER_DBF(reg_dbf)
     RETU
   -------------------------------------------------------------------
*/
msgaux:=[IMPORTANTE: Esta guia tem a finalidade principal de encaminhamento em consultas e exames.]
msgaux+=[Nao dando o direito a cirurgias, internacoes, entre outros]
RETU       // <- deve retornar um valor qualquer

* \\ Final de R00101F9.PRG