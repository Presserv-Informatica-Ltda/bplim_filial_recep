/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ORDPGRC.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Gerenciador do subsistema de caixas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79), l_s, c_s, l_i, c_i, l_a

op_sis=EVAL(qualsis,"ORDPGRC")
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
 msg="Inclus„o~1|"+;                               // menu do subsistema
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
    ORD_INCL()                                     // neste arquivo chama prg de inclusao
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

PROC ORD_incl(reg_cop)  // inclusao no arquivo ORDPGRC
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
 ORD_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com extensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE ORDPGRC
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
 ORD_TELA()
 INFOSIS(.t.)                                      // exibe informacao no rodape' da tela
 DISPEND()
 ORD_GERA_SEQ()
 cabem=DISKSPACE(;
          IF(;
             LEN(sistema[op_sis,O_ARQUI,O_DIR_DBF])<2.OR.sistema[op_sis,O_ARQUI,O_DIR_DBF]="\",;
             0,;
             ASC(sistema[op_sis,O_ARQUI,O_DIR_DBF])-64;
          );
       )
 cabem=INT((cabem-2048)/ORDPGRC->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                            // torna visiveis variaveis de memoria
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 SET KEY K_ALT_F8 TO ROLATELA
 
 /*
    recebe chaves do arquivo de indice basico
 */
 @ l_s+01 ,c_s+19 GET  numop;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()

  #ifdef COM_REDE
   ORD_ANT_SEQ()                                   // decrementa sequencial
  #endi

  LOOP
 ENDI
 SELE ORDPGRC
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->numop
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao

  #ifdef COM_REDE
   ORD_ANT_SEQ()                                   // decrementa sequencial
   SELE ORDPGRC
  #endi

  DISPBEGIN()
  ORD_GETS()                                       // mostra conteudo do registro
  INFOSIS(.f.)                                     // exibe informacao no rodape' da tela
  DISPEND()
  ALERTA()
  msg="Consultar/alterar|Retornar … inclus„o"      // pergunta se deseja
  op_=DBOX(msg,,,E_MENU,,"REGISTRO J EXISTE")     // alterar o registro
  IF op_ =1                                        // caso afirmativo
   EDIT()                                          // deixa alterar
  ENDI
  op_menu=INCLUSAO
  LOOP                                             // volta para inclusao
 ENDI
 SELE 0
 ORD_GET1(INCLUI)                                  // recebe campos
 SELE ORDPGRC
 IF LASTKEY()=K_ESC                                // se cancelou

  #ifdef COM_REDE
   ORD_ANT_SEQ()                                   // decrementa sequencial
  #endi

  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->numop                                    // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   ORD_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE ORDPGRC
   UNLOCK                                          // libera o registro
   LOOP                                            // e recebe chave novamente
  ENDI
 #endi

 IF aprov_reg_                                     // se vai aproveitar reg excluido

  #ifdef COM_REDE
   BLOREG(0,.5)
  #endi

  RECA                                             // excluido, vamos recupera-lo
 ELSE                                              // caso contrario
  APPEND BLANK                                     // inclui reg em branco no dbf
 ENDI
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
 ORD_ANT_SEQ()                                     // restaura sequencial anterior
 SELE ORDPGRC
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
 PROC ORD_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE ORD_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == numop
  REPL numop WITH sq_numop
  REPL intlan WITH sq_intlan
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC ORD_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"ORD_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"numop"     ,"C",  6, 0},;
                    {"intlan"    ,"C",  8, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE ORDPGRC
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL ORD_SEQ->numop WITH numop
  REPL ORD_SEQ->intlan WITH intlan
  DBSETORDER(1)                 // retorna ao indice principal
 ENDI
 SELE ORD_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC ORD_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE ORD_SEQ
 BLOARQ(0,.5)
 sq_numop=ORD_SEQ->numop
 sq_intlan=ORD_SEQ->intlan
#else
 DBSETORDER(0)
 GO BOTT
#endi

M->numop=LPAD(STR(VAL(numop)+1),06,[0])
M->intlan=LPAD(STR(VAL(intlan)+1),08,[0])

#ifdef COM_REDE
 ORD_GRAVA_SEQ()
 IF PROCNAME(1)!="FAZ_LANC"
  sq_atual_=ORD_SEQ->numop
  UNLOCK                                           // libera o registro
  COMMIT
 ENDI
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC ORD_GRAVA_SEQ
REPL numop WITH M->numop
REPL intlan WITH M->intlan
RETU

PROC ORD_tela     // tela do arquivo ORDPGRC
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
@ l_s+01,c_s+1 SAY " N£mero de O.P. :"
@ l_s+02,c_s+1 SAY " Origem:        Lan‡ado em           por"
@ l_s+03,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+04,c_s+1 SAY " Conta:"
@ l_s+05,c_s+1 SAY " Hist¢rico:"
@ l_s+06,c_s+1 SAY " Tipo.....:     Valor:              Vencto:"
@ l_s+07,c_s+1 SAY " Documento..:                    N§ Doctos:"
@ l_s+08,c_s+1 SAY " Complemento:"
@ l_s+09,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+10,c_s+1 SAY " Fechamento.:"
@ l_s+11,c_s+1 SAY " Transferido:"
RETU

PROC ORD_gets     // mostra variaveis do arquivo ORDPGRC
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS(), op_ant := op_menu
ORD_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(HISTORICO,'HISTORIC',1)
@ l_s+01 ,c_s+19 GET  numop;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+02 ,c_s+10 GET  origem;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+02 ,c_s+28 GET  lancto_;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+02 ,c_s+42 GET  por

@ l_s+04 ,c_s+09 GET  numconta;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+05 ,c_s+13 GET  historico;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,06,O_CRIT],,"1")

@ l_s+06 ,c_s+13 GET  debcred;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+06 ,c_s+24 GET  valortotal;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+06 ,c_s+45 GET  vencto_;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+07 ,c_s+15 GET  documento;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+07 ,c_s+45 GET  nrdoctos;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]

@ l_s+08 ,c_s+15 GET  complement;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]

@ l_s+10 ,c_s+15 GET  fechto_;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]

@ l_s+10 ,c_s+26 GET  fechpor

@ l_s+11 ,c_s+15 GET  autoriz_;
		 PICT sistema[op_sis,O_CAMPO,15,O_MASC]

@ l_s+11 ,c_s+26 GET  autorpor

@ l_s+11 ,c_s+35 GET  numos;
                 PICT sistema[op_sis,O_CAMPO,17,O_MASC]

CLEAR GETS
RETU

PROC ORD_get1(tp_mov)     // capta variaveis do arquivo ORDPGRC
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS(), op_ant := op_menu
PRIV  blk_ordpgrc:=.t.

IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+02 ,c_s+28 GET lancto_;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
  @ l_s+02 ,c_s+42 GET por
  @ l_s+10 ,c_s+15 GET fechto_;
                   PICT sistema[op_sis,O_CAMPO,13,O_MASC]
  @ l_s+10 ,c_s+24 GET fechpor
  @ l_s+11 ,c_s+15 GET autoriz_;
                   PICT sistema[op_sis,O_CAMPO,15,O_MASC]
  @ l_s+11 ,c_s+24 GET autorpor
  @ l_s+11 ,c_s+35 GET numos;
                   PICT sistema[op_sis,O_CAMPO,17,O_MASC]
  CLEA GETS
  @ l_s+02 ,c_s+10 GET  origem;
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                   DEFINICAO 2

  @ l_s+04 ,c_s+09 GET  numconta;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+05 ,c_s+13 GET  historico;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6
                   MOSTRA sistema[op_sis,O_FORMULA,1]

  @ l_s+06 ,c_s+13 GET  debcred;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+06 ,c_s+24 GET  valortotal;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+06 ,c_s+45 GET  vencto_;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+07 ,c_s+15 GET  documento;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

  @ l_s+07 ,c_s+45 GET  nrdoctos;
                   PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                   DEFINICAO 11

  @ l_s+08 ,c_s+15 GET  complement;
                   PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                   DEFINICAO 12

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
PTAB(HISTORICO,'HISTORIC',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
 IF !EMPTY(codlan) .AND. tp_mov=EXCLUI
  ALERTA()       // existe registro validado aqui!
  msg="Registro de Lan‡amento"
  DBOX(msg,,,,,"IMPOSS¡VEL EXCLUIR!")
 ELSE
  TIRA_LANC("HISTORIC","ORD-"+intlan,.f.)
  IF !EMPTY(ALIAS())
   DELE
  ENDI
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF !EMPTY(codlan) .AND. tp_mov=RECUPERA
   ALERTA()      // existe registro validado aqui!
   msg="Registro de Lan‡amento"
   DBOX(msg,,,,,"IMPOSS¡VEL RECUPERAR!")
  ELSE
   IF 1=3 // For‡a INTLAN
    ord_=LEN(sistema[EVAL(qualsis,"HISTORIC"),O_CHAVE])
    IF TYPE("M->intlan")="C" .AND. EMPTY(intlan)
     chv_="ORD-"+M->intlan+"-001"
    ELSE
     chv_="ORD-"+intlan+"-001"
    ENDI
    PTAB(chv_,"HISTORIC",ord_)
    FAZ_LANC("HISTORIC",chv_,.t.)

    #ifdef COM_REDE
     HISTORIC->(DBUNLOCK())                        // libera o registro
    #endi

   ENDI
   IF op_menu!=INCLUSAO
    RECA
   ENDI
  ENDI
 ENDI
ENDI
RETU

* \\ Final de ORDPGRC.PRG
