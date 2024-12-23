
procedure bxrec
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: BXREC.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Gerenciador do subsistema de recebimentos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \ Convert.: v5.0 em 2021081014:57:26 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79), l_s, c_s, l_i, c_i, l_a

op_sis=EVAL(qualsis,"BXREC")
IF nivelop<sistema[op_sis,O_OUTROS,O_NIVEL]        // se usuario nao tem permissao,
 ALERTA()                                          // entao, beep, beep, beep
 DBOX(msg_auto,,,3)                                // lamentamos e
 RETU                                              // retornamos ao menu
ENDI
cn:=fgrep :=.f.

#ifdef COM_LOCK
 IF LEN(pr_ok)>0                                   // se a protecao acusou
  ? pr_ok                                          // erro, avisa e
  QUIT                                             // encerra a aplicacao
 ENDI
#endi

t_fundo=SAVESCREEN(0,0,MAXROW(),79)                // salva tela do fundo
op_cad=1
DO WHIL op_cad!=0
 criterio=""
 RESTSCREEN(0,0,MAXROW(),79,t_fundo)               // restaura tela do fundo
 cod_sos=5 ; cn=.f.
 CLEA TYPEAHEAD                                    // limpa o buffer do teclado
 fgrep=.f.
 SET KEY K_F3 TO                                   // retira das teclas F3 e F4 as
 SET KEY K_F4 TO                                   // funcoes de repeticao e confirmacao
 if nivelop>2
  msg="Inclus„o~1|"+;
     "Manuten‡„o~2|"+;
     "Consulta~3"
  op_cad=DBOX(msg,lin_menu,col_menu,E_MENU,NAO_APAGA,MAIUSC(sistema[op_sis,O_MENU]),,,op_cad)
 else
  op_cad=1
 endif
 IF op_cad!=0                                      // se escolheu uma opcao
  Tela_fundo=SAVESCREEN(0,0,MAXROW(),79)           // salva a tela para ROLATELA()
  PARAMETROS(dbfparam)
  SELE A                                           // e abre o arquivo e seus indices

  #ifdef COM_REDE
   IF !USEARQ(sistema[op_sis,O_ARQUI,O_NOME],.f.,20,1)
						   // se falhou a abertura do
    RETU                                           // arquivo volta ao menu anterior
   ENDI
  #else
   USEARQ(sistema[op_sis,O_ARQUI,O_NOME])
  #endi

  SET KEY K_F9 TO veoutros                         // habilita consulta em outros arquivos
  Vinscr:=[]
  SET KEY K_F2 TO veinscrits()                         // habilita consulta em outros arquivos
 ENDI
 DO CASE
  CASE op_cad=01                                   // inclus„o
   op_menu=INCLUSAO
   IF AT("D",exrot[op_sis])=0                      // se usuario pode fazer inclusao
    BXR_INCL()                                     // neste arquivo chama prg de inclusao
   ELSE                                            // caso contrario vamos avisar que
    ALERTA()                                       // ele nao tem permissao para isto
    DBOX(msg_auto,,,3)
   ENDI

  CASE op_cad=02                                   // manuten‡„o
   op_menu=ALTERACAO
   cod_sos=7
   EDIT()

  CASE op_cad=03                                   // consulta
   op_menu=PROJECOES
   cod_sos=8
   EDITA(03,03,MAXROW()-2,77)

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 set key K_F2 TO
 CLOS ALL                                          // fecha todos arquivos abertos
 exit
ENDD
RETU

PROC BXR_incl(reg_cop)  // inclusao no arquivo BXREC
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),cond_incl_,dbfseq_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:=""
cond_incl_={||nivelop>1}                           // condicao de inclusao de registros
IF !EVAL(cond_incl_)                               // se nao pode incluir
 ALERTA(2)                                         // avisa o motivo
 DBOX("Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior",,,4,,"ATEN€ŽO, "+usuario)
 RETU                                              // e retorna
ENDI
FOR i=1 TO FCOU()                                  // cria/declara privadas as
 msg=FIEL(i)                                       // variaveis de memoria com
 PRIV &msg.                                        // o mesmo nome dos campos
NEXT                                               // do arquivo
IF reg_cop!=NIL                                    // quer repetir todo o reg atual
 FOR i=1 TO FCOU()                                 // para cada campo,
  msg=FIEL(i)                                      // salva o conteudo
  rep[i]=&msg.                                     // para repetir
 NEXT
ELSE
 AFILL(rep,"")                                     // eche com valor vazio
ENDI
t_f3_=SETKEY(K_F3,{||rep()})                       // repeticao reg anterior
t_f4_=SETKEY(K_F4,{||conf()})                      // confirma campos com ENTER
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})               // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})

#ifdef COM_REDE
 BXR_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com extensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE BXREC
 GO BOTT                                           // forca o
 SKIP                                              // final do arquivo

 /*
    cria variaveis de memoria identicas as de arquivo, para inclusao
    de registros
 */
 FOR i=1 TO FCOU()
  msg=FIEL(i)
  M->&msg.=IF((fgrep .OR. reg_cop!=NIL).AND.!EMPT(rep[1]),rep[i],&msg.)
 NEXT
 DISPBEGIN()                                       // apresenta a tela de uma vez so
 BXR_TELA()
 INFOSIS(.t.)                                      // exibe informacao no rodape' da tela
 DISPEND()
 BXR_GERA_SEQ()
 IF !EVAL(cond_incl_)
  EXIT
 ENDI
 cabem=DISKSPACE(;
          IF(;
             LEN(sistema[op_sis,O_ARQUI,O_DIR_DBF])<2.OR.sistema[op_sis,O_ARQUI,O_DIR_DBF]="\",;
             0,;
             ASC(sistema[op_sis,O_ARQUI,O_DIR_DBF])-64;
          );
       )
 cabem=INT((cabem-2048)/BXREC->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                            // torna visiveis variaveis de memoria
 BXR_GET1(INCLUI)                                  // recebe campos
 SELE BXREC
 IF LASTKEY()=K_ESC                                // se cancelou
  cabem=0                                          // prepara saida da inclusao
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
 #endi

 APPEND BLANK                                      // inclui reg em branco no dbf
 FOR i=1 TO FCOU()                                 // para cada campo,
  msg=FIEL(i)                                      // salva o conteudo
  rep[i]=M->&msg.                                  // para repetir
  REPL &msg. WITH rep[i]                           // enche o campo do arquivo
 NEXT

 #ifdef COM_REDE
  UNLOCK                                           // libera o registro e
  COMMIT                                           // forca gravacao
 #else
  IF RECC()-INT(RECC()/20)*20=0                    // a cada 20 registros
   COMMIT                                          // digitados forca gravacao
  ENDI
 #endi

 ult_reg=RECN()                                    // ultimo registro digitado
 BXR_REL(ult_reg)                               // imprime relat apos inclusao
 IF reg_cop!=NIL                                   // estava na consulta e quis rep o campo
  sq_atual_=NIL
  EXIT                                             // cai fora...
 ENDI
ENDD

#ifdef COM_REDE
 BXR_ANT_SEQ()                                     // restaura sequencial anterior
 SELE BXREC
#endi

GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU


PROC BXR_REL(ult_reg)  // imprime relatorio apos inclusao
LOCAL p_imp:=.t., i_ok:=.f., imp_rel:=.f.
DO WHIL .t.
 SAVE SCREEN                     // salva a tela

 #ifdef COM_REDE
  tps=TP_SAIDA(,,.t.)
  IF LASTKEY()=K_ESC
   EXIT
  ENDI
  i_ok=(tps=2 .OR. PREPIMP("TAXAS (RECEP€ŽO)"))
  IF i_ok
   ADM_RS18(tps,0,ult_reg)
   imp_rel=.t.
  ENDI
 #else
  i_ok=PREPIMP("TAXAS (RECEP€ŽO)")
  IF i_ok
   ADM_RS18(0,0,ult_reg)
   imp_rel=.t.
  ENDI
 #endi

 REST SCREEN                    // restaura tela
 IF imp_rel                     // imprimiu algo?
  msg="Prosseguir|Outra c¢pia"
  op_=1 //DBOX(msg,,,E_MENU,,"FIM DE IMPRESSŽO") // quer emitir outra copia?
  IF op_=2
   LOOP                         // nao quer...
  ENDI
 ENDI
 EXIT
ENDD
RETU


#ifdef COM_REDE
 PROC BXR_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE BXR_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == numero
  REPL numero WITH sq_numero
  REPL intlan WITH sq_intlan
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC BXR_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"BXR_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"numero"    ,"C",  8, 0},;
                    {"intlan"    ,"C",  8, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE BXREC
 IF RECC()>0                    // se o DBF nao estiver
  DBSETORDER(0)                 // retorna ao indice principal
  GO BOTT                       // com o ultimo reg digitado
  REPL BXR_SEQ->numero WITH numero
  REPL BXR_SEQ->intlan WITH intlan
  DBSETORDER(1)                 // retorna ao indice principal
 ENDI
 SELE BXR_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC BXR_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE BXR_SEQ
 BLOARQ(0,.5)
 sq_numero=BXR_SEQ->numero
 sq_intlan=BXR_SEQ->intlan
#else
 DBSETORDER(0)
 GO BOTT
#endi

M->numero=LPAD(STR(VAL(numero)+1),08,[0])
IF VAL(M->numero)=1
 M->numero=LPAD(RIGHT(DTOC(DATE()),2)+[000001],08,[0])
ENDI
M->intlan=LPAD(STR(VAL(intlan)+1),08,[0])

#ifdef COM_REDE
 BXR_GRAVA_SEQ()
 sq_atual_=BXR_SEQ->numero
 UNLOCK                                            // libera o registro
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC BXR_GRAVA_SEQ
REPL numero WITH M->numero
REPL intlan WITH M->intlan
RETU

PROC BXR_tela     // tela do arquivo BXREC
tem_borda=.t.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
i=LEN(sistema[op_sis,O_MENS])/2
@ l_s,c_s-1+(c_i-c_s+1)/2-i SAY " "+MAIUSC(sistema[op_sis,O_MENS])+" "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Numero:"
@ l_s+02,c_s+1 SAY " Contrato:"
@ l_s+03,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ"
@ l_s+04,c_s+1 SAY "                                      ³Circulares"
@ l_s+05,c_s+1 SAY "                                      ³ Ini"
@ l_s+06,c_s+1 SAY "                            Reg.:     ³  £lt"
@ l_s+07,c_s+1 SAY "                                      ³"
@ l_s+08,c_s+1 SAY " Admiss„o:            Sai Taxa:       ³"
@ l_s+09,c_s+1 SAY " Funerais:     Cobrador: "
@ l_s+10,c_s+1 SAY " Tel:"
@ l_s+11,c_s+1 SAY " e-mail:"
//@ l_s+10,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
//@ l_s+15,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+17,c_s+1 SAY " Ref.:                       Vl.Pago:"
@ l_s+18,c_s+1 SAY " Pago com..:             Troco:"
@ l_s+20,c_s+1 SAY "  emitida em             por"
RETU

PROC BXR_gets     // mostra variaveis do arquivo BXREC
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS(), op_ant := op_menu
BXR_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(CODIGO,[GRUPOS])
PTAB(IIF(EMPT(M->USUARIO),PADR(M->CONTAREC+IDE_MAQ,10,' '),PADR(M->USUARIO,10,' '))+M->HISTRCFCC+[       ],'ORDPGRC',2)
PTAB(PADR(SUBSTR(M->IDE_MAQ,2),4)+[BXR],[IMPPAR],1)
CRIT("",,"16")
@ l_s+01 ,c_s+12 GET  numero;
		 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+02 ,c_s+12 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"1|2|3|4|5|6|7|8|9|10|11|12|13|14")

@ l_s+17 ,c_s+08 GET  cobranca;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+17 ,c_s+39 GET  valorpg;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+18 ,c_s+14 GET  valoraux;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,05,O_CRIT],,"15")

@ l_s+20 ,c_s+14 GET  emitido_;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+20 ,c_s+30 GET  por

@ l_s+20 ,c_s+44 GET  numop;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

CRIT("",,"1|3|4|5|6|7|8|9|10|11|12|13|14")
CLEAR GETS
RETU

PROC BXR_get1(tp_mov)     // capta variaveis do arquivo BXREC
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS(), op_ant := op_menu
PRIV  blk_bxrec:=.t.

IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+12 GET numero;
                   PICT sistema[op_sis,O_CAMPO,01,O_MASC]
  @ l_s+20 ,c_s+14 GET emitido_;
		   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
  @ l_s+20 ,c_s+30 GET por
  @ l_s+20 ,c_s+44 GET numop;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
  CLEA GETS
  CRIT("",,"16")
  @ l_s+02 ,c_s+12 GET  codigo;
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                   DEFINICAO 2
                   MOSTRA sistema[op_sis,O_FORMULA,1]
                   MOSTRA sistema[op_sis,O_FORMULA,2]
                   MOSTRA sistema[op_sis,O_FORMULA,3]
                   MOSTRA sistema[op_sis,O_FORMULA,4]
                   MOSTRA sistema[op_sis,O_FORMULA,5]
                   MOSTRA sistema[op_sis,O_FORMULA,6]
                   MOSTRA sistema[op_sis,O_FORMULA,7]
                   MOSTRA sistema[op_sis,O_FORMULA,8]
                   MOSTRA sistema[op_sis,O_FORMULA,9]
                   MOSTRA sistema[op_sis,O_FORMULA,10]
                   MOSTRA sistema[op_sis,O_FORMULA,11]
		   MOSTRA sistema[op_sis,O_FORMULA,12]
                   MOSTRA sistema[op_sis,O_FORMULA,13]
                   MOSTRA sistema[op_sis,O_FORMULA,14]

  @ l_s+17 ,c_s+08 GET  cobranca;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3

  @ l_s+17 ,c_s+39 GET  valorpg;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+18 ,c_s+14 GET  valoraux;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5
                   MOSTRA sistema[op_sis,O_FORMULA,15]

  READ
  SET KEY K_ALT_F8 TO
  IF rola_t
   ROLATELA()
   LOOP
  ENDI
  IF LASTKEY()!=K_ESC .AND. drvincl .AND. op_menu=INCLUSAO
   IF !CONFINCL()
    LOOP
   ENDI
  ENDI
  EXIT
 ENDD
ENDI
PTAB(CODIGO,[GRUPOS])
PTAB(LEFT(COBRANCA,15),'TAXAS',1)
PTAB(IIF(EMPT(M->USUARIO),PADR(M->CONTAREC+IDE_MAQ,10,' '),PADR(M->USUARIO,10,' '))+M->HISTRCFCC+[       ],'ORDPGRC',2)
PTAB(PADR(SUBSTR(M->IDE_MAQ,2),4)+[BXR],[IMPPAR],1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA

 #ifdef COM_REDE
  IF EMPT(numop)
   IF !EMPTY(ALIAS())
    REPL numop WITH ORDPGRC->numop
   ENDI
  ENDI
  IF PTAB(numop,'ORDPGRC',1)
   REPBLO('ORDPGRC->nrdoctos',{||ORDPGRC->nrdoctos - 1})
  ENDI
  IF !EMPT(valorpg)
   REPBLO('TAXAS->pgto_',{||CTOD('')})
   REPBLO('TAXAS->forma',{||[ ]})
   REPBLO('TAXAS->baixa_',{||CTOD('  /  /  ')})
   REPBLO('TAXAS->stat',{||[ ]})
   REPBLO('TAXAS->valorpg',{||0})
  ENDI
  IF EMPT(numop).AND.PTAB(IIF(EMPT(M->usuario),PADR(M->contarec+ide_maq,10,' '),PADR(M->usuario,10,' '))+M->histrcfcc+[       ],'ORDPGRC',2)
   REPBLO('ORDPGRC->valortotal',{||ORDPGRC->valortotal-valorpg})
  ENDI
  IF !EMPT(numop).AND.PTAB(numop,'ORDPGRC',1)
   REPBLO('ORDPGRC->valortotal',{||ORDPGRC->valortotal -valorpg})
  ENDI
 #else
  IF EMPT(numop)
   IF !EMPTY(ALIAS())
    REPL numop WITH ORDPGRC->numop
   ENDI
  ENDI
  IF PTAB(numop,'ORDPGRC',1)
   REPL ORDPGRC->nrdoctos WITH ORDPGRC->nrdoctos - 1
  ENDI
  IF !EMPT(valorpg)
   REPL TAXAS->pgto_ WITH CTOD('')
   REPL TAXAS->forma WITH [ ]
   REPL TAXAS->baixa_ WITH CTOD('  /  /  ')
   REPL TAXAS->stat WITH [ ]
   REPL TAXAS->valorpg WITH 0
  ENDI
  IF EMPT(numop).AND.PTAB(IIF(EMPT(M->usuario),PADR(M->contarec+ide_maq,10,' '),PADR(M->usuario,10,' '))+M->histrcfcc+[       ],'ORDPGRC',2)
   REPL ORDPGRC->valortotal WITH ORDPGRC->valortotal-valorpg
  ENDI
  IF !EMPT(numop).AND.PTAB(numop,'ORDPGRC',1)
   REPL ORDPGRC->valortotal WITH ORDPGRC->valortotal -valorpg
  ENDI
 #endi

 IF 1=3
  IF !EMPTY(ORDPGRC->codlan)
   TIRA_LANC("ORDPGRC",LEFT(ORDPGRC->codlan,16),.f.)
  ENDI
 ENDI
 IF 1=3
  IF !EMPTY(IMPPAR->codlan)
   TIRA_LANC("IMPPAR",LEFT(IMPPAR->codlan,16))
  ENDI
 ENDI
 IF !EMPTY(ALIAS())
    POE_NO_LOG(tp_mov)
 IF !EMPTY(ALIAS())
  DELE
 ENDI
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF !EMPT(valorpg).AND. !PTAB(IIF(EMPT(M->usuario),PADR(M->contarec+ide_maq,10,' '),PADR(M->usuario,10,' '))+M->histrcfcc+[       ],'ORDPGRC',2)
   ord_=LEN(sistema[EVAL(qualsis,"ORDPGRC"),O_CHAVE])
   IF !EMPTY(ORDPGRC->codlan)
    chv_=LEFT(ORDPGRC->codlan,16)
   ELSE
    IF TYPE("M->intlan")="C" .AND. EMPTY(intlan)
     chv_="BXR-"+M->intlan+"-001"
    ELSE
     chv_="BXR-"+intlan+"-001"
    ENDI
   ENDI
   PTAB(chv_,"ORDPGRC",ord_)
   FAZ_LANC("ORDPGRC",chv_,.t.)
   REPL ORDPGRC->origem WITH [ADM],;
        ORDPGRC->lancto_ WITH DATE(),;
        ORDPGRC->por WITH M->usuario,;
        ORDPGRC->numconta WITH IIF(EMPT(M->usuario),PADR(M->contarec+ide_maq,10,' '),PADR(M->usuario,10,' ')),;
        ORDPGRC->historico WITH M->histrcfcc,;
        ORDPGRC->debcred WITH [C],;
        ORDPGRC->valortotal WITH 0,;
        ORDPGRC->vencto_ WITH DATE(),;
        ORDPGRC->documento WITH [FCC/Taxas],;
	ORDPGRC->complement WITH [FCC/Taxas pagas na Recep‡„o]

   #ifdef COM_REDE
    ORDPGRC->(DBUNLOCK())                          // libera o registro
   #endi

  ENDI
  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1)
   ord_=LEN(sistema[EVAL(qualsis,"IMPPAR"),O_CHAVE])
   IF !EMPTY(IMPPAR->codlan)
    chv_=LEFT(IMPPAR->codlan,16)
   ELSE
    IF TYPE("M->intlan")="C" .AND. EMPTY(intlan)
     chv_="BXR-"+M->intlan+"-002"
    ELSE
     chv_="BXR-"+intlan+"-002"
    ENDI
   ENDI
   PTAB(chv_,"IMPPAR",ord_)
   FAZ_LANC("IMPPAR",chv_)
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
        IMPPAR->base WITH [BXR]

   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

  ENDI
   IF EMPT(numop)
    IF op_menu=INCLUSAO
     numop=ORDPGRC->numop
    ELSE
     REPL numop WITH ORDPGRC->numop
    ENDI
   ENDI

  #ifdef COM_REDE
   IF PTAB(numop,'ORDPGRC',1)
    REPBLO('ORDPGRC->nrdoctos',{||ORDPGRC->nrdoctos + 1})
   ENDI
   IF !EMPT(valorpg)
    REPBLO('TAXAS->pgto_',{||DATE()})
   ENDI
   IF !EMPT(valorpg)
    REPBLO('TAXAS->forma',{||[P]})
   ENDI
   IF !EMPT(valorpg)
    REPBLO('TAXAS->baixa_',{||DATE()})
   ENDI
   IF !EMPT(valorpg)
    REPBLO('TAXAS->por',{||M->usuario})
   ENDI
   IF !EMPT(valorpg)
    REPBLO('TAXAS->stat',{||[6]})
   ENDI
   IF !EMPT(valorpg)
    REPBLO('TAXAS->valorpg',{||valorpg})
   ENDI
   IF op_menu=INCLUSAO
    emitido_=DATE()
   ELSE
    REPL emitido_ WITH DATE()
   ENDI
   IF op_menu=INCLUSAO
    por=M->usuario
   ELSE
    REPL por WITH M->usuario
   ENDI
   IF op_menu=INCLUSAO
    filial=M->p_filial
   ELSE
    REPL filial WITH M->p_filial
   ENDI
   IF EMPT(numop).AND.PTAB(IIF(EMPT(M->usuario),PADR(M->contarec+ide_maq,10,' '),PADR(M->usuario,10,' '))+M->histrcfcc+[       ],'ORDPGRC',2)
    REPBLO('ORDPGRC->valortotal',{||ORDPGRC->valortotal+valorpg})
   ENDI
   IF !EMPT(numop).AND.PTAB(numop,'ORDPGRC',1)
    REPBLO('ORDPGRC->valortotal',{||ORDPGRC->valortotal +valorpg})
   ENDI
   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1)
    REPBLO('IMPPAR->docto',{||numero})
   ENDI
  #else
   IF EMPT(numop)
    IF op_menu=INCLUSAO
     numop=ORDPGRC->numop
    ELSE
     REPL numop WITH ORDPGRC->numop
    ENDI
   ENDI
   IF PTAB(numop,'ORDPGRC',1)
    REPL ORDPGRC->nrdoctos WITH ORDPGRC->nrdoctos + 1
   ENDI
   IF !EMPT(valorpg)
    REPL TAXAS->pgto_ WITH DATE()
   ENDI
   IF !EMPT(valorpg)
    REPL TAXAS->forma WITH [P]
   ENDI
   IF !EMPT(valorpg)
    REPL TAXAS->baixa_ WITH DATE()
   ENDI
   IF !EMPT(valorpg)
    REPL TAXAS->por WITH M->usuario
   ENDI
   IF !EMPT(valorpg)
    REPL TAXAS->stat WITH [6]
   ENDI
   IF !EMPT(valorpg)
    REPL TAXAS->valorpg WITH valorpg
   ENDI
   IF op_menu=INCLUSAO
    emitido_=DATE()
   ELSE
    REPL emitido_ WITH DATE()
   ENDI
   IF op_menu=INCLUSAO
    por=M->usuario
   ELSE
    REPL por WITH M->usuario
   ENDI
   IF op_menu=INCLUSAO
    filial=M->p_filial
   ELSE
    REPL filial WITH M->p_filial
   ENDI
   IF EMPT(numop).AND.PTAB(IIF(EMPT(M->usuario),PADR(M->contarec+ide_maq,10,' '),PADR(M->usuario,10,' '))+M->histrcfcc+[       ],'ORDPGRC',2)
    REPL ORDPGRC->valortotal WITH ORDPGRC->valortotal+valorpg
   ENDI
   IF !EMPT(numop).AND.PTAB(numop,'ORDPGRC',1)
    REPL ORDPGRC->valortotal WITH ORDPGRC->valortotal +valorpg
   ENDI
   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1)
    REPL IMPPAR->docto WITH numero
   ENDI
  #endi

  POE_NO_LOG(tp_mov)
  IF op_menu!=INCLUSAO
   RECA
  ENDI
 ENDI
ENDI
RETU

* \\ Final de BXREC.PRG
