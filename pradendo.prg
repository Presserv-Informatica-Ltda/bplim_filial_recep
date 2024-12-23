procedure pradendo
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: PRADENDO.PRG
 \ Data....: 23-10-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerenciador do subsistema de produtos do adendo
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \ Convert.: v5.0 em 2021081108:53:51 Fase_01
 \ Convert.: v5.0 em 2021081014:47:46 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79), l_s, c_s, l_i, c_i, l_a
op_sis=EVAL(qualsis,"PRADENDO")
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

criterio=""
SELE A                                             // e abre o arquivo e seus indices

#ifdef COM_REDE
 IF !USEARQ(sistema[op_sis,O_ARQUI,O_NOME],.f.,20,1)      // se falhou a abertura do
  RETU                                             // arquivo volta ao menu anterior
 ENDI
#else
 USEARQ(sistema[op_sis,O_ARQUI,O_NOME])
#endi

SET KEY K_F9 TO veoutros                           // habilita consulta em outros arquivos
op_menu=ALTERACAO
cod_sos=7
EDIT()
SET KEY K_F9 TO                                    // F9 nao mais consultara outros arquivos
CLOS ALL                                           // fecha todos arquivos abertos
RETU

PROC PRA_incl(reg_cop)     // inclusao no arquivo PRODUTOS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(), cond_incl_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, tem_borda, criterio:="", cpord:=""
cond_incl_={||1=3}                                 // condicao de inclusao de registros
IF !EVAL(cond_incl_)                               // se nao pode incluir
 ALERTA(2)                                         // avisa o motivo
 DBOX("Mantido pelo sistema de Estoque",,,4,,"ATEN��O, "+usuario)
 RETU                                              // e retorna
ENDI
FOR i=1 TO FCOU()                                  // cria/declara privadas as
 msg=FIEL(i)                                       // variaveis de memoria com
 PRIV &msg.                                        // o mesmo nome dos campos
NEXT                                               // do arquivo
IF reg_cop!=NIL                                     // quer repetir todo o reg atual
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
DO WHIL cabem>0
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE PRADENDO
 GO BOTT                                           // forca o
 SKIP                                              // final do arquivo

 /*
    cria variaveis de memoria identicas as de arquivo, para inclusao
    de registros
 */
 FOR i=1 TO FCOU()
  msg=FIEL(i)
  M->&msg.=IF((fgrep.OR.reg_cop!=NIL).AND.!EMPT(rep[1]),rep[i],&msg.)
 NEXT
 DISPBEGIN()                                       // apresenta a tela de uma vez so
 PRA_TELA()
INFOSIS(.T.)
 DISPEND()
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
 cabem=INT((cabem-2048)/PRADENDO->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA�O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUS�O INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                            // torna visiveis variaveis de memoria
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 SET KEY K_ALT_F8 TO ROLATELA

 /*
    recebe chaves do arquivo de indice basico
 */
 @ l_s+01 ,c_s+24 GET  codigo;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE PRADENDO
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->codigo
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  PRA_GETS()                                       // mostra conteudo do registro
INFOSIS(.f.)
  DISPEND()
  ALERTA()
  msg="Consultar/alterar|Retornar � inclus�o"      // pergunta se deseja
  op_=DBOX(msg,,,E_MENU,,"REGISTRO J� EXISTE")     // alterar o registro
  IF op_ =1                                        // caso afirmativo
   EDIT()                                          // deixa alterar
  ENDI
  op_menu=INCLUSAO
  LOOP                                             // volta para inclusao
 ENDI
 SELE 0
 PRA_GET1(INCLUI)                                  // recebe campos
 SELE PRADENDO
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n�o inclu�do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->codigo                                   // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   PRA_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu�do por outro usu�rio!"
   DBOX(msg,,,,,"ATEN��O!")                        // avisa
   SELE PRADENDO
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
GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC PRA_tela     // tela do arquivo PRODUTOS
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
@ l_s+01,c_s+1 SAY " C�digo do produto...:               Data Atualiza��o:"
@ l_s+02,c_s+1 SAY " Descri��o do produto:"
@ l_s+03,c_s+1 SAY " Unidade do produto..:               Ref. t�cnica....:"
@ l_s+04,c_s+1 SAY " Qde em estoque......:               Qde m�nima......:"
@ l_s+05,c_s+1 SAY " Preco custo em R$...:               em"
@ l_s+06,c_s+1 SAY " Pre�o de Venda......:               em"
@ l_s+07,c_s+1 SAY " Lucro Bruto (%) ....:"
RETU

PROC PRA_gets     // mostra variaveis do arquivo PRODUTOS
LOCAL getlist := {}, t_f7_
PRA_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
@ l_s+01 ,c_s+24 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+02 ,c_s+24 GET  produto;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+03 ,c_s+24 GET  unid;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"1")

@ l_s+03 ,c_s+56 SAY "{M} "

@ l_s+04 ,c_s+24 GET  qd_est;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+04 ,c_s+56 GET  qd_min;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+05 ,c_s+24 GET  preco_cus;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+05 ,c_s+42 GET  custo_;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+06 ,c_s+24 GET  preco_ven;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,09,O_CRIT],,"2")

@ l_s+06 ,c_s+42 GET  venda_;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+01 ,c_s+56 GET  dt_ult_atu;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]

CLEAR GETS
RETU

PROC PRA_get1     // capta variaveis do arquivo PRODUTOS
LOCAL getlist := {}, t_f7_
PRIV  blk_produtos:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  memo04:="{F7}"
  t_f7_=SETKEY(K_F7,{||PRA_memo()})
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+56 GET dt_ult_atu;
                   PICT sistema[op_sis,O_CAMPO,11,O_MASC]
  CLEA GETS
  @ l_s+02 ,c_s+24 GET  produto;
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                   DEFINICAO 2

  @ l_s+03 ,c_s+24 GET  unid;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3
                   MOSTRA sistema[op_sis,O_FORMULA,1]

  @ l_s+03 ,c_s+56 GET  memo04;
                   PICT "@!"
                   DEFINICAO 4

  @ l_s+04 ,c_s+24 GET  qd_est;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+04 ,c_s+56 GET  qd_min;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+05 ,c_s+24 GET  preco_cus;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+05 ,c_s+42 GET  custo_;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+06 ,c_s+24 GET  preco_ven;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9
                   MOSTRA sistema[op_sis,O_FORMULA,2]

  @ l_s+06 ,c_s+42 GET  venda_;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

  READ
  SETKEY(K_F7,t_f7_)
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
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
    POE_NO_LOG(tp_mov)
 IF !EMPTY(ALIAS())
  DELE
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
   IF op_menu=INCLUSAO
    dt_ult_atu=DATE()
   ELSE
    REPL dt_ult_atu WITH DATE()
   ENDI
  POE_NO_LOG(tp_mov)
  IF op_menu!=INCLUSAO
   RECA
  ENDI
 ENDI
ENDI
RETU

PROC PRA_MEMO
IF READVAR()="MEMO04"
 EDIMEMO("reftec",sistema[op_sis,O_CAMPO,04,O_TITU],14,2,23,37)
ENDI
RETU

* \\ Final de PRODUTOS.PRG
