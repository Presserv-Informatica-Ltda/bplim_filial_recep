
procedure v02401f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: V02401F9.PRG
 \ Data....: 03-01-96
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Valida‡„o da variavel CONFIRME, relatorio ADM_R024
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \ Convert.: v5.0 em 2021081014:57:51 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas

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
   PARAMETROS(dbfparam,'valor1',M->rvalor1)
   PARAMETROS(dbfparam,'valor2',M->rvalor2)
   PARAMETROS(dbfparam,'valor3',M->rvalor3)

RETU .t.   // <- deve retornar um valor L¢GICO

* \\ Final de V02401F9.PRG