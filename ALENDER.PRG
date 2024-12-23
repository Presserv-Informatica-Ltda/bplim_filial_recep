procedure alender
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ALENDER.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Gerenciador do subsistema de endere‡os
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "adrbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79), l_s, c_s, l_i, c_i, l_a

op_sis=EVAL(qualsis,"ALENDER")
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
    ALE_INCL()                                     // neste arquivo chama prg de inclusao
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

PROC ALE_incl(reg_cop)  // inclusao no arquivo ALENDER
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
 ALE_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com extensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE ALENDER
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
 ALE_TELA()
 INFOSIS(.t.)                                      // exibe informacao no rodape' da tela
 DISPEND()
 ALE_GERA_SEQ()
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
 cabem=INT((cabem-2048)/ALENDER->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 M->data_=DATE()
 M->por=M->usuario
 SELE 0                                            // torna visiveis variaveis de memoria
 ALE_GET1(INCLUI)                                  // recebe campos
 SELE ALENDER
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
 ALE_ANT_SEQ()                                     // restaura sequencial anterior
 SELE ALENDER
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
 PROC ALE_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE ALE_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == numero
  REPL numero WITH sq_numero
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC ALE_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"ALE_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"numero"    ,"C",  8, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE ALENDER
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL ALE_SEQ->numero WITH numero
  DBSETORDER(1)                 // retorna ao indice principal
 ENDI
 SELE ALE_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC ALE_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE ALE_SEQ
 BLOARQ(0,.5)
 sq_numero=ALE_SEQ->numero
#else
 DBSETORDER(0)
 GO BOTT
#endi

M->numero=LPAD(STR(VAL(numero)+1),08,[0])
IF VAL(M->numero)=1
 M->numero=LPAD(RIGHT(DTOC(DATE()),2)+[000001],08,[0])
ENDI

#ifdef COM_REDE
 ALE_GRAVA_SEQ()
 sq_atual_=ALE_SEQ->numero
 UNLOCK                                            // libera o registro
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC ALE_GRAVA_SEQ
REPL numero WITH M->numero
RETU

PROC ALE_tela     // tela do arquivo ALENDER
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
@ l_s+01,c_s+1 SAY " Contrato:"
@ l_s+02,c_s+1 SAY " Alterar de:                          para:"
@ l_s+06,c_s+1 SAY "             Tel:                                Tel:"
@ l_s+07,c_s+1 SAY " Cobrador:                            Cobrador:"
@ l_s+08,c_s+1 SAY "                      p/               Listado em:"
RETU

PROC ALE_gets     // mostra variaveis do arquivo ALENDER
LOCAL getlist := {}
ALE_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(CODIGO,'GRUPOS',1)
CRIT("",,"2")
@ l_s+01 ,c_s+12 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,01,O_CRIT],,"1")

@ l_s+03 ,c_s+39 GET  endereco

@ l_s+04 ,c_s+39 GET  bairro

@ l_s+05 ,c_s+39 GET  cidade

@ l_s+05 ,c_s+67 GET  uf;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+06 ,c_s+39 GET  cep;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+06 ,c_s+55 GET  telefone;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+07 ,c_s+49 GET  cobrador;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+08 ,c_s+10 GET  data_;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+08 ,c_s+26 GET  por

@ l_s+03 ,c_s+02 GET  dendereco

@ l_s+04 ,c_s+02 GET  dbairro

@ l_s+05 ,c_s+02 GET  dcidade

@ l_s+05 ,c_s+30 GET  duf;
                 PICT sistema[op_sis,O_CAMPO,15,O_MASC]

@ l_s+06 ,c_s+02 GET  dcep;
                 PICT sistema[op_sis,O_CAMPO,16,O_MASC]

@ l_s+06 ,c_s+19 GET  dtelefone;
                 PICT sistema[op_sis,O_CAMPO,17,O_MASC]

@ l_s+07 ,c_s+12 GET  dcobrador;
                 PICT sistema[op_sis,O_CAMPO,18,O_MASC]

@ l_s+08 ,c_s+52 GET  emitido_;
                 PICT sistema[op_sis,O_CAMPO,20,O_MASC]

CLEAR GETS
RETU

PROC ALE_get1(tp_mov)     // capta variaveis do arquivo ALENDER
LOCAL getlist := {}
PRIV  blk_alender:=.t.

IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+08 ,c_s+10 GET data_;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
  @ l_s+08 ,c_s+26 GET por
  @ l_s+03 ,c_s+02 GET dendereco
  @ l_s+04 ,c_s+02 GET dbairro
  @ l_s+05 ,c_s+02 GET dcidade
  @ l_s+05 ,c_s+30 GET duf;
                   PICT sistema[op_sis,O_CAMPO,15,O_MASC]
  @ l_s+06 ,c_s+02 GET dcep;
                   PICT sistema[op_sis,O_CAMPO,16,O_MASC]
  @ l_s+06 ,c_s+19 GET dtelefone;
                   PICT sistema[op_sis,O_CAMPO,17,O_MASC]
  @ l_s+07 ,c_s+12 GET dcobrador;
                   PICT sistema[op_sis,O_CAMPO,18,O_MASC]
  CLEA GETS
  CRIT("",,"2")
  @ l_s+01 ,c_s+12 GET  codigo;
                   PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                   DEFINICAO 1
                   MOSTRA sistema[op_sis,O_FORMULA,1]

  @ l_s+03 ,c_s+39 GET  endereco
                   DEFINICAO 3

  @ l_s+04 ,c_s+39 GET  bairro
                   DEFINICAO 4

  @ l_s+05 ,c_s+39 GET  cidade
                   DEFINICAO 5

  @ l_s+05 ,c_s+67 GET  uf;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+06 ,c_s+39 GET  cep;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+06 ,c_s+55 GET  telefone;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+07 ,c_s+49 GET  cobrador;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+08 ,c_s+52 GET  emitido_;
                   PICT sistema[op_sis,O_CAMPO,20,O_MASC]
                   DEFINICAO 20

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
PTAB(CODIGO,'GRUPOS',1)
PTAB(COBRADOR,'COBRADOR',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
 IF !EMPTY(ALIAS())
  DELE
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
   IF EMPT(data_)
    IF op_menu=INCLUSAO
     data_=DATE()
    ELSE
     REPL data_ WITH DATE()
    ENDI
   ENDI
   IF EMPT(por)
    IF op_menu=INCLUSAO
     por=M->usuario
    ELSE
     REPL por WITH M->usuario
    ENDI
   ENDI
   IF op_menu=INCLUSAO
    filial=M->p_filial
   ELSE
    REPL filial WITH M->p_filial
   ENDI

  #ifdef COM_REDE
   REPBLO('GRUPOS->endereco',{||endereco})
   REPBLO('GRUPOS->bairro',{||bairro})
   REPBLO('GRUPOS->cidade',{||cidade})
   REPBLO('GRUPOS->uf',{||uf})
   REPBLO('GRUPOS->telefone',{||telefone})
   REPBLO('GRUPOS->cep',{||cep})
   REPBLO('GRUPOS->cobrador',{||cobrador})
  #else
   IF EMPT(data_)
    IF op_menu=INCLUSAO
     data_=DATE()
    ELSE
     REPL data_ WITH DATE()
    ENDI
   ENDI
   IF EMPT(por)
    IF op_menu=INCLUSAO
     por=M->usuario
    ELSE
     REPL por WITH M->usuario
    ENDI
   ENDI
   IF op_menu=INCLUSAO
    filial=M->p_filial
   ELSE
    REPL filial WITH M->p_filial
   ENDI
   REPL GRUPOS->endereco WITH endereco
   REPL GRUPOS->bairro WITH bairro
   REPL GRUPOS->cidade WITH cidade
   REPL GRUPOS->uf WITH uf
   REPL GRUPOS->telefone WITH telefone
   REPL GRUPOS->cep WITH cep
   REPL GRUPOS->cobrador WITH cobrador
  #endi

  IF op_menu!=INCLUSAO
   RECA
  ENDI
 ENDI
ENDI
RETU

* \\ Final de ALENDER.PRG
