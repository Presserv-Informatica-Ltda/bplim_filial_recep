procedure prcessos
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: PRCESSOS.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP��O
 \ Funcao..: Gerenciador do subsistema de processos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79), l_s, c_s, l_i, c_i, l_a

op_sis=EVAL(qualsis,"PRCESSOS")
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
 msg="Consulta Individual~1|"+;
     "Consulta Global~2"
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
  CASE op_cad=01                                   // consulta individual
   op_menu=ALTERACAO
   cod_sos=7
   EDIT()

  CASE op_cad=02                                   // consulta global
   op_menu=PROJECOES
   cod_sos=8
   EDITA(03,03,MAXROW()-2,77)

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC PRC_incl(reg_cop)  // inclusao no arquivo PRCESSOS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, tem_borda, criterio:="", cpord:=""
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
DO WHIL cabem>0
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE PRCESSOS
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
 PRC_TELA()
 INFOSIS(.t.)                                      // exibe informacao no rodape' da tela
 DISPEND()
 cabem=DISKSPACE(;
          IF(;
             LEN(sistema[op_sis,O_ARQUI,O_DIR_DBF])<2.OR.sistema[op_sis,O_ARQUI,O_DIR_DBF]="\",;
             0,;
             ASC(sistema[op_sis,O_ARQUI,O_DIR_DBF])-64;
          );
       )
 cabem=INT((cabem-2048)/PRCESSOS->(RECSIZE()))
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
 @ l_s+01 ,c_s+13 GET  processo;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1

 @ l_s+02 ,c_s+13 GET  categ;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE PRCESSOS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->processo+M->categ
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  PRC_GETS()                                       // mostra conteudo do registro
  INFOSIS(.f.)                                     // exibe informacao no rodape' da tela
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
 PRC_GET1(INCLUI)                                  // recebe campos
 SELE PRCESSOS
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n�o inclu�do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->processo+M->categ                        // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   PRC_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu�do por outro usu�rio!"
   DBOX(msg,,,,,"ATEN��O!")                        // avisa
   SELE PRCESSOS
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


PROC PRC_tela     // tela do arquivo PRCESSOS
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
@ l_s+01,c_s+1 SAY " Processo.:"
@ l_s+02,c_s+1 SAY " Categoria:    (PL=Plano, PD=Plano c/Dif.,AF=Auxilio)"
@ l_s+03,c_s+1 SAY " Saiu.....:"
@ l_s+04,c_s+1 SAY " Contrato.:   /      / /"
@ l_s+05,c_s+1 SAY " Segurado.:"
@ l_s+06,c_s+1 SAY " Endere�o.:"
@ l_s+07,c_s+1 SAY " Cidade...:"
@ l_s+08,c_s+1 SAY " Falecido.:"
@ l_s+09,c_s+1 SAY " Sepultam.:"
@ l_s+10,c_s+1 SAY " Data Fal.:"
RETU

PROC PRC_gets     // mostra variaveis do arquivo PRCESSOS
LOCAL getlist := {}
PRC_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(NUM,'INSCRITS',1)
@ l_s+01 ,c_s+13 GET  processo;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+02 ,c_s+13 GET  categ;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+03 ,c_s+13 GET  saiu

@ l_s+04 ,c_s+13 GET  grup;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+04 ,c_s+16 GET  num;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+04 ,c_s+23 GET  grau;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+04 ,c_s+25 GET  seq;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+05 ,c_s+13 GET  seg;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+06 ,c_s+13 GET  ends;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+07 ,c_s+13 GET  cids;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+08 ,c_s+13 GET  fal;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]

@ l_s+09 ,c_s+13 GET  sep;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]

@ l_s+10 ,c_s+13 GET  dfal;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,13,O_CRIT],,"1")

CLEAR GETS
RETU

PROC PRC_get1(tp_mov)     // capta variaveis do arquivo PRCESSOS
LOCAL getlist := {}
PRIV  blk_prcessos:=.t.

IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+03 ,c_s+13 GET  saiu
                   DEFINICAO 3

  @ l_s+04 ,c_s+13 GET  grup;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+04 ,c_s+16 GET  num;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+04 ,c_s+23 GET  grau;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+04 ,c_s+25 GET  seq;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+05 ,c_s+13 GET  seg;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+06 ,c_s+13 GET  ends;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+07 ,c_s+13 GET  cids;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

  @ l_s+08 ,c_s+13 GET  fal;
                   PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                   DEFINICAO 11

  @ l_s+09 ,c_s+13 GET  sep;
                   PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                   DEFINICAO 12

  @ l_s+10 ,c_s+13 GET  dfal;
                   PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                   DEFINICAO 13
                   MOSTRA sistema[op_sis,O_FORMULA,1]

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
PTAB(GRUP,'ARQGRUP',1)
PTAB(NUM,'GRUPOS',1)
PTAB(NUM,'INSCRITS',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
 IF !EMPTY(codlan) .AND. tp_mov=EXCLUI
  ALERTA()       // existe registro validado aqui!
  msg="Registro de Lan�amento"
  DBOX(msg,,,,,"IMPOSS�VEL EXCLUIR!")
 ELSE

  #ifdef COM_REDE
   IF saiu<'001'.AND.PTAB(grup,'ARQGRUP',1)
    REPBLO('ARQGRUP->procpend',{||ARQGRUP->procpend - 1})
   ENDI
   IF saiu<'001'.AND.PTAB(grup,'ARQGRUP',1)
    REPBLO('ARQGRUP->partic',{||ARQGRUP->partic + 1})
   ENDI
   IF PTAB(num,'GRUPOS',1)
    REPBLO('GRUPOS->funerais',{||GRUPOS->funerais - 1})
   ENDI
   IF PTAB(num,'GRUPOS',1)
    REPBLO('GRUPOS->particv',{||GRUPOS->particv + 1})
   ENDI
   IF PTAB(num,'GRUPOS',1)
    REPBLO('GRUPOS->particf',{||GRUPOS->particf - 1})
   ENDI
   IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
    REPBLO('INSCRITS->vivofalec',{||[V]})
   ENDI
   IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
    REPBLO('INSCRITS->falecto_',{||ctod('  /  /  ')})
   ENDI
   IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
    REPBLO('INSCRITS->tipo',{||[  ]})
   ENDI
   IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
    REPBLO('INSCRITS->procnr',{||[ ]})
   ENDI
  #else
   IF saiu<'001'.AND.PTAB(grup,'ARQGRUP',1)
    REPL ARQGRUP->procpend WITH ARQGRUP->procpend - 1
   ENDI
   IF saiu<'001'.AND.PTAB(grup,'ARQGRUP',1)
    REPL ARQGRUP->partic WITH ARQGRUP->partic + 1
   ENDI
   IF PTAB(num,'GRUPOS',1)
    REPL GRUPOS->funerais WITH GRUPOS->funerais - 1
   ENDI
   IF PTAB(num,'GRUPOS',1)
    REPL GRUPOS->particv WITH GRUPOS->particv + 1
   ENDI
   IF PTAB(num,'GRUPOS',1)
    REPL GRUPOS->particf WITH GRUPOS->particf - 1
   ENDI
   IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
    REPL INSCRITS->vivofalec WITH [V]
   ENDI
   IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
    REPL INSCRITS->falecto_ WITH ctod('  /  /  ')
   ENDI
   IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
    REPL INSCRITS->tipo WITH [  ]
   ENDI
   IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
    REPL INSCRITS->procnr WITH [ ]
   ENDI
  #endi

  IF !EMPTY(ALIAS())
   DELE
  ENDI
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF !EMPTY(codlan) .AND. tp_mov=RECUPERA
   ALERTA()      // existe registro validado aqui!
   msg="Registro de Lan�amento"
   DBOX(msg,,,,,"IMPOSS�VEL RECUPERAR!")
  ELSE

   #ifdef COM_REDE
    IF saiu<'001'.AND.PTAB(grup,'ARQGRUP',1)
     REPBLO('ARQGRUP->procpend',{||ARQGRUP->procpend + 1})
    ENDI
    IF saiu<'001'.AND.PTAB(grup,'ARQGRUP',1)
     REPBLO('ARQGRUP->partic',{||ARQGRUP->partic - 1})
    ENDI
    IF PTAB(num,'GRUPOS',1)
     REPBLO('GRUPOS->funerais',{||GRUPOS->funerais + 1})
    ENDI
    IF PTAB(num,'GRUPOS',1)
     REPBLO('GRUPOS->particv',{||GRUPOS->particv - 1})
    ENDI
    IF PTAB(num,'GRUPOS',1)
     REPBLO('GRUPOS->particf',{||GRUPOS->particf + 1})
    ENDI
    IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
     REPBLO('INSCRITS->vivofalec',{||[F]})
    ENDI
    IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
     REPBLO('INSCRITS->falecto_',{||dfal})
    ENDI
    IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
     REPBLO('INSCRITS->tipo',{||categ})
    ENDI
    IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
     REPBLO('INSCRITS->procnr',{||processo})
    ENDI
   #else
    IF saiu<'001'.AND.PTAB(grup,'ARQGRUP',1)
     REPL ARQGRUP->procpend WITH ARQGRUP->procpend + 1
    ENDI
    IF saiu<'001'.AND.PTAB(grup,'ARQGRUP',1)
     REPL ARQGRUP->partic WITH ARQGRUP->partic - 1
    ENDI
    IF PTAB(num,'GRUPOS',1)
     REPL GRUPOS->funerais WITH GRUPOS->funerais + 1
    ENDI
    IF PTAB(num,'GRUPOS',1)
     REPL GRUPOS->particv WITH GRUPOS->particv - 1
    ENDI
    IF PTAB(num,'GRUPOS',1)
     REPL GRUPOS->particf WITH GRUPOS->particf + 1
    ENDI
    IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
     REPL INSCRITS->vivofalec WITH [F]
    ENDI
    IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
     REPL INSCRITS->falecto_ WITH dfal
    ENDI
    IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
     REPL INSCRITS->tipo WITH categ
    ENDI
    IF PTAB(num+grau+STR(seq,03,00),'INSCRITS',1)
     REPL INSCRITS->procnr WITH processo
    ENDI
   #endi

   IF op_menu!=INCLUSAO
    RECA
   ENDI
  ENDI
 ENDI
ENDI
RETU

* \\ Final de PRCESSOS.PRG
