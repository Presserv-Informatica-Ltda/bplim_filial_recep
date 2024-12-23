/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: MEDICOS.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Gerenciador do subsistema de credenciados
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "adrbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79), l_s, c_s, l_i, c_i, l_a

op_sis=EVAL(qualsis,"MEDICOS")
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
    MED_INCL()                                     // neste arquivo chama prg de inclusao
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

PROC MED_incl(reg_cop)  // inclusao no arquivo MEDICOS
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
 MED_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com extensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE MEDICOS
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
 MED_TELA()
 INFOSIS(.t.)                                      // exibe informacao no rodape' da tela
 DISPEND()
 MED_GERA_SEQ()
 cabem=DISKSPACE(;
          IF(;
             LEN(sistema[op_sis,O_ARQUI,O_DIR_DBF])<2.OR.sistema[op_sis,O_ARQUI,O_DIR_DBF]="\",;
             0,;
             ASC(sistema[op_sis,O_ARQUI,O_DIR_DBF])-64;
          );
       )
 cabem=INT((cabem-2048)/MEDICOS->(RECSIZE()))
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
 @ l_s+07 ,c_s+14 GET  nome
                  DEFINICAO 12

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()

  #ifdef COM_REDE
   MED_ANT_SEQ()                                   // decrementa sequencial
  #endi

  LOOP
 ENDI
 SELE MEDICOS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->nome
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao

  #ifdef COM_REDE
   MED_ANT_SEQ()                                   // decrementa sequencial
   SELE MEDICOS
  #endi

  DISPBEGIN()
  MED_GETS()                                       // mostra conteudo do registro
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
 MED_GET1(INCLUI)                                  // recebe campos
 SELE MEDICOS
 IF LASTKEY()=K_ESC                                // se cancelou

  #ifdef COM_REDE
   MED_ANT_SEQ()                                   // decrementa sequencial
  #endi

  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->nome                                     // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   MED_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE MEDICOS
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
 MED_ANT_SEQ()                                     // restaura sequencial anterior
 SELE MEDICOS
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
 PROC MED_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE MED_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == ai
  REPL ai WITH sq_ai
  REPL intlan WITH sq_intlan
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC MED_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"MED_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"ai"        ,"C",  5, 0},;
                    {"intlan"    ,"C",  8, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE MEDICOS
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL MED_SEQ->ai WITH ai
  REPL MED_SEQ->intlan WITH intlan
  DBSETORDER(1)                 // retorna ao indice principal
 ENDI
 SELE MED_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC MED_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE MED_SEQ
 BLOARQ(0,.5)
 sq_ai=MED_SEQ->ai
 sq_intlan=MED_SEQ->intlan
#else
 DBSETORDER(0)
 GO BOTT
#endi

M->ai=PADR(ALLTRIM(STR(VAL(ai)+1)),5)
M->intlan=LPAD(STR(VAL(intlan)+1),08,[0])

#ifdef COM_REDE
 MED_GRAVA_SEQ()
 sq_atual_=MED_SEQ->ai
 UNLOCK                                            // libera o registro
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC MED_GRAVA_SEQ
REPL ai WITH M->ai
REPL intlan WITH M->intlan
RETU

PROC MED_tela     // tela do arquivo MEDICOS
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
@ l_s+01,c_s+1 SAY "        CodBenefic:"
@ l_s+02,c_s+1 SAY " Oldescrito:                Oldclasse.:"
@ l_s+03,c_s+1 SAY " Prioridade:                Situa‡„o..:"
@ l_s+04,c_s+1 SAY " Oldespec..:"
@ l_s+05,c_s+1 SAY " Detalhes..:                Vantagens.:"
@ l_s+06,c_s+1 SAY " Condicoes.:                Informutil:"
@ l_s+07,c_s+1 SAY " Nome......:"
@ l_s+08,c_s+1 SAY " Endere‡o..:"
@ l_s+09,c_s+1 SAY " Bairro....:"
@ l_s+10,c_s+1 SAY " Cidade....:                                    CEP:"
@ l_s+11,c_s+1 SAY " Contato...:"
@ l_s+12,c_s+1 SAY " FoneCom1..:                 FoneCom2.:"
@ l_s+13,c_s+1 SAY " Fonecel...:                 Foneres1.:"
@ l_s+14,c_s+1 SAY " Email.....:"
@ l_s+15,c_s+1 SAY " Fax.......:                 Bip......:"
@ l_s+16,c_s+1 SAY " Fonesdiv..:"
@ l_s+17,c_s+1 SAY " DataInc...:                 DataAlt..:"
@ l_s+18,c_s+1 SAY " Codcidade.:                 Contrato.:"
@ l_s+19,c_s+1 SAY " Flagetq...:                 Codclasse:"
RETU

PROC MED_gets     // mostra variaveis do arquivo MEDICOS
LOCAL getlist := {}, ord_, chv_, t_f7_
MED_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
@ l_s+01 ,c_s+02 GET  ai

@ l_s+01 ,c_s+21 GET  codbenefic

@ l_s+02 ,c_s+14 GET  oldescrito

@ l_s+02 ,c_s+41 GET  oldclasse

@ l_s+03 ,c_s+14 GET  prioridade

@ l_s+03 ,c_s+41 GET  status;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+04 ,c_s+14 GET  oldespec;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+05 ,c_s+14 SAY "{M} "

@ l_s+05 ,c_s+41 SAY "{M} "

@ l_s+06 ,c_s+14 SAY "{M} "

@ l_s+06 ,c_s+41 SAY "{M} "

@ l_s+07 ,c_s+14 GET  nome

@ l_s+08 ,c_s+14 GET  endereco

@ l_s+09 ,c_s+14 GET  bairro;
                 PICT sistema[op_sis,O_CAMPO,14,O_MASC]

@ l_s+10 ,c_s+14 GET  cidade;
                 PICT sistema[op_sis,O_CAMPO,15,O_MASC]

@ l_s+10 ,c_s+45 GET  uf;
                 PICT sistema[op_sis,O_CAMPO,16,O_MASC]

@ l_s+10 ,c_s+54 GET  cep;
                 PICT sistema[op_sis,O_CAMPO,17,O_MASC]

@ l_s+11 ,c_s+14 GET  contato;
                 PICT sistema[op_sis,O_CAMPO,18,O_MASC]

@ l_s+12 ,c_s+14 GET  fonecom1

@ l_s+12 ,c_s+41 GET  fonecom2;
                 PICT sistema[op_sis,O_CAMPO,20,O_MASC]

@ l_s+13 ,c_s+14 GET  fonecel;
                 PICT sistema[op_sis,O_CAMPO,21,O_MASC]

@ l_s+13 ,c_s+41 GET  foneres1;
                 PICT sistema[op_sis,O_CAMPO,22,O_MASC]

@ l_s+14 ,c_s+14 GET  email;
                 PICT sistema[op_sis,O_CAMPO,23,O_MASC]

@ l_s+15 ,c_s+14 GET  fax;
                 PICT sistema[op_sis,O_CAMPO,24,O_MASC]

@ l_s+15 ,c_s+41 GET  bip;
                 PICT sistema[op_sis,O_CAMPO,25,O_MASC]

@ l_s+16 ,c_s+14 GET  fonesdiv;
                 PICT sistema[op_sis,O_CAMPO,26,O_MASC]

@ l_s+17 ,c_s+14 GET  datainc;
                 PICT sistema[op_sis,O_CAMPO,27,O_MASC]

@ l_s+17 ,c_s+41 GET  dataalt;
                 PICT sistema[op_sis,O_CAMPO,28,O_MASC]

@ l_s+18 ,c_s+14 GET  codcidade

@ l_s+18 ,c_s+41 GET  contrato

@ l_s+19 ,c_s+14 GET  flagetq

@ l_s+19 ,c_s+41 GET  codclasse

CLEAR GETS
RETU

PROC MED_get1(tp_mov)     // capta variaveis do arquivo MEDICOS
LOCAL getlist := {}, ord_, chv_, t_f7_
PRIV  blk_medicos:=.t.

IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  memo08:=memo09:=memo10:=memo11:="{F7}"
  t_f7_=SETKEY(K_F7,{||MED_memo()})
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+02 GET  ai
                   DEFINICAO 1

  @ l_s+01 ,c_s+21 GET  codbenefic
                   DEFINICAO 2

  @ l_s+02 ,c_s+14 GET  oldescrito
                   DEFINICAO 3

  @ l_s+02 ,c_s+41 GET  oldclasse
                   DEFINICAO 4

  @ l_s+03 ,c_s+14 GET  prioridade
                   DEFINICAO 5

  @ l_s+03 ,c_s+41 GET  status;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+04 ,c_s+14 GET  oldespec;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+05 ,c_s+14 GET  memo08;
                   PICT "@!"
                   DEFINICAO 8

  @ l_s+05 ,c_s+41 GET  memo09;
                   PICT "@!"
                   DEFINICAO 9

  @ l_s+06 ,c_s+14 GET  memo10;
                   PICT "@!"
                   DEFINICAO 10

  @ l_s+06 ,c_s+41 GET  memo11;
                   PICT "@!"
                   DEFINICAO 11

  @ l_s+08 ,c_s+14 GET  endereco
                   DEFINICAO 13

  @ l_s+09 ,c_s+14 GET  bairro;
                   PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                   DEFINICAO 14

  @ l_s+10 ,c_s+14 GET  cidade;
                   PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                   DEFINICAO 15

  @ l_s+10 ,c_s+45 GET  uf;
                   PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                   DEFINICAO 16

  @ l_s+10 ,c_s+54 GET  cep;
                   PICT sistema[op_sis,O_CAMPO,17,O_MASC]
                   DEFINICAO 17

  @ l_s+11 ,c_s+14 GET  contato;
                   PICT sistema[op_sis,O_CAMPO,18,O_MASC]
                   DEFINICAO 18

  @ l_s+12 ,c_s+14 GET  fonecom1
                   DEFINICAO 19

  @ l_s+12 ,c_s+41 GET  fonecom2;
                   PICT sistema[op_sis,O_CAMPO,20,O_MASC]
                   DEFINICAO 20

  @ l_s+13 ,c_s+14 GET  fonecel;
                   PICT sistema[op_sis,O_CAMPO,21,O_MASC]
                   DEFINICAO 21

  @ l_s+13 ,c_s+41 GET  foneres1;
                   PICT sistema[op_sis,O_CAMPO,22,O_MASC]
                   DEFINICAO 22

  @ l_s+14 ,c_s+14 GET  email;
                   PICT sistema[op_sis,O_CAMPO,23,O_MASC]
                   DEFINICAO 23

  @ l_s+15 ,c_s+14 GET  fax;
                   PICT sistema[op_sis,O_CAMPO,24,O_MASC]
                   DEFINICAO 24

  @ l_s+15 ,c_s+41 GET  bip;
                   PICT sistema[op_sis,O_CAMPO,25,O_MASC]
                   DEFINICAO 25

  @ l_s+16 ,c_s+14 GET  fonesdiv;
                   PICT sistema[op_sis,O_CAMPO,26,O_MASC]
                   DEFINICAO 26

  @ l_s+17 ,c_s+14 GET  datainc;
                   PICT sistema[op_sis,O_CAMPO,27,O_MASC]
                   DEFINICAO 27

  @ l_s+17 ,c_s+41 GET  dataalt;
                   PICT sistema[op_sis,O_CAMPO,28,O_MASC]
                   DEFINICAO 28

  @ l_s+18 ,c_s+14 GET  codcidade
                   DEFINICAO 29

  @ l_s+18 ,c_s+41 GET  contrato
                   DEFINICAO 30

  @ l_s+19 ,c_s+14 GET  flagetq
                   DEFINICAO 31

  @ l_s+19 ,c_s+41 GET  codclasse
                   DEFINICAO 32

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
 IF 1=3
  TIRA_LANC("TESPEC","MED-"+intlan)
 ENDI
 IF !EMPTY(ALIAS())
  DELE
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF !PTAB(especialid,'TESPEC',1)
   ord_=LEN(sistema[EVAL(qualsis,"TESPEC"),O_CHAVE])
   IF TYPE("M->intlan")="C" .AND. EMPTY(intlan)
    chv_="MED-"+M->intlan+"-001"
   ELSE
    chv_="MED-"+intlan+"-001"
   ENDI
   PTAB(chv_,"TESPEC",ord_)
   FAZ_LANC("TESPEC",chv_)
   REPL TESPEC->especialid WITH especialid

   #ifdef COM_REDE
    TESPEC->(DBUNLOCK())                           // libera o registro
   #endi

  ENDI
  IF op_menu!=INCLUSAO
   RECA
  ENDI
 ENDI
ENDI
RETU

PROC MED_MEMO
IF READVAR()="MEMO08"
 EDIMEMO("detalhes",sistema[op_sis,O_CAMPO,08,O_TITU],14,2,23,38)
ELSEIF READVAR()="MEMO09"
 EDIMEMO("vantagens",sistema[op_sis,O_CAMPO,09,O_TITU],14,2,23,38)
ELSEIF READVAR()="MEMO10"
 EDIMEMO("condicoes",sistema[op_sis,O_CAMPO,10,O_TITU],14,2,23,38)
ELSEIF READVAR()="MEMO11"
 EDIMEMO("informutil",sistema[op_sis,O_CAMPO,11,O_TITU],14,2,23,38)
ENDI
RETU

* \\ Final de MEDICOS.PRG
