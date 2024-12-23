/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADR_MANU.PRG
 \ Data....: 22-01-08
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Menu geral de auxilio da aplica‡„o
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

opc_01=1
v01=SAVESCREEN(0,0,MAXROW(),79)
arqx_:=M->arq_sos
arq_sos=direxe+"ADRBIG.TXT"  // nome do arquivo de ajud
menu02:=[]
contx:=0
IF FILE(arq_sos)
 txtini:=MEMOREAD(arq_sos) // texto
 nLines:=MLCOUNT(M->txtini,56)
 FOR nCurrLine = 1 TO nLines
  Lineaux:=MEMOLINE(txtini, 56, nCurrLine)
  IF LineAux=[\0]
   LineAux:=SUBSTR(LineAux,6,RAT([ -],LineAux)-3)+[~]+SUBSTR(LineAux,3,2)
   menu02+=LineAux+[|]
  ENDI
 NEXT
 opc_02=1
 v02=SAVESCREEN(0,0,MAXROW(),79)
 DO WHIL opc_02!=0
  RESTSCREEN(0,0,MAXROW(),79,v02)
  msgt="PROCEDIMENTOS"
  ROLAPOP(1)
  opc_02=DBOX(menu02,1,2,E_MENU,NAO_APAGA,msgt,,,opc_02)
  ROLAPOP()
  IF !EMPT(opc_02)
   txt_cut1:=SUBSTR(txtini,AT([\0]+strzero(opc_02,2),txtini)+56)
   txt_cut1:=LEFT(txt_cut1,AT([\0],txt_cut1))

   cod_sos:=opc_02
   HELP_PROC()
  ENDIF
 ENDD
ENDI
M->arq_sos:=arqx_
RESTSCREEN(0,0,MAXROW(),79,v01)
RETU

PROC HELP_PROC    // Apresenta ajuda on-line
LOCAL tela_, txt, ctr, t, cor_, qdlin_, linf_, estr_db, pg_up, pg_dn,;
      tec_f3, tec_f4, tec_f9, tec_f8
SETKEY(K_F1,NIL)                                     // evita recursividade
pg_up =SETKEY(K_PGUP,NIL)                            // desabilita PgUp,
pg_dn =SETKEY(K_PGDN,NIL)                            // PgDn,
tec_f3=SETKEY(K_F3,NIL)                              // F3,
tec_f4=SETKEY(K_F4,NIL)                              // F4,
tec_f9=SETKEY(K_F9,NIL)                              // F9 e
tec_f8=SETKEY(K_ALT_F8,NIL)                          // ALT-F8
tela_=SAVESCREEN(0,0,MAXROW(),79)                    // salva a tela por baixo e
cor_=SETCOLOR(drvtithlp)                             // o esquema de cor vigente
 txt=txt_cut1
 qdlin_=MLCOUNT(txt,56)                              // qde linhas
 maxlt_ =MAXROW()
 linf_ =IF(qdlin_>maxlt_-7,maxlt_-3,qdlin_+3)        // calcula linha inferior
 CAIXA(mold,2,10,linf_,69,392)                       // monta janela
 ctr=IF(qdlin_>maxlt_-6," "+CHR(K_CTRL_X)+" "+;      // monta teclas de controle
        CHR(K_CTRL_Y)+" PgUp PgDn","")+" ESC "       // disponiveis na janela
 @ linf_,(80-LEN(ctr))/2 SAY ctr                     // mostra teclas de controle
 SETCOLOR(drvcorhlp)

 #ifdef COM_TUTOR
  MEMOEDIT(txt,3,12,linf_-1,68,.f.,"mHelp")          // mostra o bloco de ajuda
 #else
  MEMOEDIT(txt,3,12,linf_-1,68,.f.)                  // mostra o bloco de ajuda
 #endi

SETCOLOR(cor_)
RESTSCREEN(0,0,MAXROW(),79,tela_)
SETKEY(K_PGUP,pg_up)                                 // habilita teclas PgUp,
SETKEY(K_PGDN,pg_dn)                                 // PgDn,
SETKEY(K_F3,tec_f3)                                  // F3,
SETKEY(K_F4,tec_f4)                                  // F4,
SETKEY(K_F9,tec_f9)                                  // F9 e
SETKEY(K_ALT_F8,tec_f8)                              // ALT-F8
SET KEY K_F1 TO help                                 // habilita F1
RETU

func mkinx
para filetxt
 txtini:=MEMOREAD(filetxt) // texto
 nLines:=MLCOUNT(M->txtini,56)
 posinx:=0
 FOR nCurrLine = 1 TO nLines
  Lineaux:=MEMOLINE(txtini, 56, nCurrLine)
  posinx+=LEN(lineaux)
  IF LineAux=[\0]
   LineAux:=SUBSTR(LineAux,6,RAT([ -],LineAux)-3)+[~]+SUBSTR(LineAux,3,2)
   menu02+=strzero(posinx+2,8)
  ENDI
 NEXT
 menu02+=repl([0],1920-len(menu02))
// memowrite([adrbig.inx],menu02)
retu
