procedure ben_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: BEN_01F9.PRG
 \ Data....: 22-05-01
 \ Sistema.: Administradora - RECEP��O
 \ Funcao..: F�rmula (meno1) a mostrar na tela de BENEFIC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas
PARA qual
linhas:=[]
memos:={[detalhes],[vantagens],[condicoes],[informutil]}
FOR contmem = 1 TO 4
 temobs=.f.
 FOR contlin = 1 TO 10
  campomemo=memos[contmem]
  linaux := MEMOLINE(&campomemo,60,contlin,.t.)
  IF !EMPT(linaux)
   linhas += ALLTRIM(linaux)+[ ]
   temobs=.t.
  ENDI
 NEXT
 IF temobs
  linhas+=[ - ]
 ENDI
NEXT
RETU memoline(linhas,60,qual)

       // <- deve retornar um valor qualquer

* \\ Final de BEN_01F9.PRG
