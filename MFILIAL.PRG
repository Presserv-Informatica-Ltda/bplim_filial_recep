/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: MFILIAL.PRG
 \ Data....: 22-01-08
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Gerenciador do subsistema de avisos / carencias
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79), l_s, c_s, l_i, c_i, l_a

op_sis=EVAL(qualsis,"MFILIAL")
IF .f. //nivelop<sistema[op_sis,O_OUTROS,O_NIVEL]        // se usuario nao tem permissao,
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
 msg="Inclus„o~1|"+;
     "Manuten‡„o~2|"+;
     "Consulta~3"
 op_cad=DBOX(msg,lin_menu,col_menu,E_MENU,NAO_APAGA,MAIUSC(sistema[op_sis,O_MENU]),,,op_cad)
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
 ENDI
 DO CASE
  CASE op_cad=01                                   // inclus„o
   op_menu=INCLUSAO
   IF AT("D",exrot[op_sis])=0                      // se usuario pode fazer inclusao
    MFI_INCL()                                     // neste arquivo chama prg de inclusao
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
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC MFI_incl(reg_cop)  // inclusao no arquivo MFILIAL
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),dbfseq_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:=""
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
 MFI_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com extensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE MFILIAL
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
 MFI_TELA()
 INFOSIS(.t.)                                      // exibe informacao no rodape' da tela
 DISPEND()
 MFI_GERA_SEQ()
 cabem=DISKSPACE(;
          IF(;
             LEN(sistema[op_sis,O_ARQUI,O_DIR_DBF])<2.OR.sistema[op_sis,O_ARQUI,O_DIR_DBF]="\",;
             0,;
             ASC(sistema[op_sis,O_ARQUI,O_DIR_DBF])-64;
          );
       )
 cabem=INT((cabem-2048)/MFILIAL->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 M->data_=DATE()
 M->por=M->usuario
 SELE 0                                            // torna visiveis variaveis de memoria
 MFI_GET1(INCLUI)                                  // recebe campos
 SELE MFILIAL
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
 IF reg_cop!=NIL                                   // estava na consulta e quis rep o campo
  sq_atual_=NIL
  EXIT                                             // cai fora...
 ENDI
ENDD

#ifdef COM_REDE
 MFI_ANT_SEQ()                                     // restaura sequencial anterior
 SELE MFILIAL
#endi

GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU



#ifdef COM_REDE
 PROC MFI_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE MFI_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == seq0
  REPL seq0 WITH sq_seq0
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC MFI_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"MFI_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"seq0"      ,"C",  6, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE MFILIAL
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL MFI_SEQ->seq0 WITH seq0
  DBSETORDER(1)                 // retorna ao indice principal
 ENDI
 SELE MFI_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC MFI_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE MFI_SEQ
 BLOARQ(0,.5)
 sq_seq0=MFI_SEQ->seq0
#else
 DBSETORDER(0)
 GO BOTT
#endi

M->seq0=LPAD(STR(VAL(seq0)+1),06,[0])

#ifdef COM_REDE
 MFI_GRAVA_SEQ()
 sq_atual_=MFI_SEQ->seq0
 UNLOCK                                            // libera o registro
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC MFI_GRAVA_SEQ
REPL seq0 WITH M->seq0
RETU

PROC MFI_tela     // tela do arquivo MFILIAL
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
@ l_s+02,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY " Codigo..........:"
@ l_s+04,c_s+1 SAY " Termino Carencia:"
@ l_s+05,c_s+1 SAY " Obs1............:"
@ l_s+06,c_s+1 SAY " Obs2............:"
@ l_s+07,c_s+1 SAY " Obs3............:"
RETU

PROC MFI_gets     // mostra variaveis do arquivo MFILIAL
LOCAL getlist := {}
MFI_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(ALLTRIM(CODIGO),[GRUPOS])
@ l_s+01 ,c_s+03 GET  seq0;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+01 ,c_s+49 GET  data_;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+01 ,c_s+60 GET  por

@ l_s+03 ,c_s+20 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+04 ,c_s+20 GET  tcarenc_;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+05 ,c_s+20 GET  obs1;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+06 ,c_s+20 GET  obs2;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+07 ,c_s+20 GET  obs3;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

CRIT("",,"1")
CLEAR GETS
RETU

PROC MFI_get1(tp_mov)     // capta variaveis do arquivo MFILIAL
LOCAL getlist := {}
PRIV  blk_mfilial:=.t.

IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+03 GET seq0;
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
  @ l_s+01 ,c_s+49 GET data_;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
  @ l_s+01 ,c_s+60 GET por
  CLEA GETS
  @ l_s+03 ,c_s+20 GET  codigo;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+04 ,c_s+20 GET  tcarenc_;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+05 ,c_s+20 GET  obs1;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+06 ,c_s+20 GET  obs2;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+07 ,c_s+20 GET  obs3;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

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
PTAB(ALLTRIM(CODIGO),[GRUPOS])
PTAB(CODIGO,'TAXAS',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
 msgX:=[]
 msg1find:=[**> ATENCAO   ATENCAO   ATENCAO <**]
 msg2find:=[(]+ALLTRIM(idxd)
 ultmsg1:=ultmsg2:=0
 FOR contmsg=1 TO 20
  msgadd:=MEMOLINE(GRUPOS->obs,60,contmsg)
  IF (msg1find$msgadd)
   ultmsg1:=contmsg
  ENDI
  IF (msg2find$msgadd)
   ultmsg2:=contmsg
  ENDI
 NEXT
 FOR contmsg=1 TO 20
  IF contmsg>=ultmsg1.AND.contmsg<=ultmsg2
  ELSE
   msgadd:=MEMOLINE(GRUPOS->obs,60,contmsg)
   msgX+=msgadd+chr(13)+chr(10)
  ENDI
 NEXT
/*
// Bloqueado em 01/06/2010 para naum interferir nas mensagens depois
// de excluido o lancamento
 #ifdef COM_REDE
  REPBLO('GRUPOS->obs',{||msgX})
 #else
  REPL GRUPOS->obs WITH msgX
 #endi
*/

 IF !EMPTY(ALIAS())
  DELE
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
   IF EMPT(idxd)
    IF op_menu=INCLUSAO
     idxd=dtoS(DATE())+time()+M->usuario
    ELSE
     REPL idxd WITH dtoS(DATE())+time()+M->usuario
    ENDI
   ENDI
/*
// Bloqueado em 01/06/2010 para naum interferir nas mensagens depois
// de excluido o lancamento
   msg_obs_aux:=[**> ATENCAO   ATENCAO   ATENCAO <**]+CHR(13)+CHR(10)
   msg_obs_fim:=[***--(]+ALLTRIM(idxd)+[)--***]+CHR(13)+CHR(10)
   IF !EMPT(tcarenc_)
    msg_obs_aux+=[ Contrato em Carencia por negociacao ate ]+dtoc(TCARENc_)+;
                CHR(13)+CHR(10)
   ENDI
   REPBLO('GRUPOS->obs',{||msg_obs_aux+ALLTRIM(obs1)+CHR(13)+CHR(10)+;
                          ALLTRIM(obs2)+CHR(13)+CHR(10)+;
                          ALLTRIM(obs3)+chr(13)+chr(10)+;
                          msg_obs_fim+GRUPOS->obs})
*/
//   [ (]+LEFT(DTOC(DATE()),6)+RIGHT(DTOC(DATE()),2)+[ ]+LEFT(TIME(),5)+[ ]+M->USUARIO+[)]+chr(13)+chr(10)+GRUPOS->obs})
   IF op_menu=INCLUSAO
    idxm=DTOS(DATE())+time()+M->usuario
   ELSE
    REPL idxm WITH DTOS(DATE())+time()+M->usuario
   ENDI
   IF op_menu=INCLUSAO
    filial=M->p_filial
   ELSE
    REPL filial WITH M->p_filial
   ENDI
  IF op_menu!=INCLUSAO
   RECA
  ENDI
 ENDI
ENDI
RETU

* \\ Final de MFILIAL.PRG
