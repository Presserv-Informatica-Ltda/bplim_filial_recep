procedure afuner
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: AFUNER.PRG
 \ Data....: 04-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Gerenciador do subsistema de lan‡amento aux.funeral
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79), l_s, c_s, l_i, c_i, l_a

op_sis=EVAL(qualsis,"AFUNER")
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
    AFU_INCL()                                     // neste arquivo chama prg de inclusao
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

PROC AFU_incl(reg_cop)  // inclusao no arquivo AFUNER
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
 AFU_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com extensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE AFUNER
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
 AFU_TELA()
 INFOSIS(.t.)                                      // exibe informacao no rodape' da tela
 DISPEND()
 AFU_GERA_SEQ()
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
 cabem=INT((cabem-2048)/AFUNER->(RECSIZE()))
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
 @ l_s+01 ,c_s+14 GET  processo;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1

 @ l_s+01 ,c_s+20 GET  proc2;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()

  #ifdef COM_REDE
   AFU_ANT_SEQ()                                   // decrementa sequencial
  #endi

  LOOP
 ENDI
 SELE AFUNER
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->processo+M->proc2
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao

  #ifdef COM_REDE
   AFU_ANT_SEQ()                                   // decrementa sequencial
   SELE AFUNER
  #endi

  DISPBEGIN()
  AFU_GETS()                                       // mostra conteudo do registro
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
 AFU_GET1(INCLUI)                                  // recebe campos
 SELE AFUNER
 IF LASTKEY()=K_ESC                                // se cancelou

  #ifdef COM_REDE
   AFU_ANT_SEQ()                                   // decrementa sequencial
  #endi

  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->processo+M->proc2                        // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   AFU_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE AFUNER
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
 AFU_REL(ult_reg)                               // imprime relat apos inclusao
 IF reg_cop!=NIL                                   // estava na consulta e quis rep o campo
  sq_atual_=NIL
  EXIT                                             // cai fora...
 ENDI
ENDD

#ifdef COM_REDE
 AFU_ANT_SEQ()                                     // restaura sequencial anterior
 SELE AFUNER
#endi

GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU


PROC AFU_REL(ult_reg)  // imprime relatorio apos inclusao
LOCAL p_imp:=.t., i_ok:=.f., imp_rel:=.f.
DO WHIL .t.
 SAVE SCREEN                     // salva a tela

 #ifdef COM_REDE
  tps=TP_SAIDA(,,.t.)            // escolhe a impressora
  IF LASTKEY()=K_ESC             // se teclou ESC
   EXIT                          // cai fora...
  ENDI
  IF tps=2 .OR. PREPIMP("AUXILIO FUNERAL")   // se nao vai para video conf impressora pronta
   IF categ=[AF]
    ADM_R020(tps,0,ult_reg)
    ADR_R029(tps,0,ult_reg)
   ELSE
    ADM_RX20(tps,0,ult_reg)
    ADR_RX29(tps,0,ult_reg)
   ENDI
   ADM_R029(tps,0,ult_reg)
 #else
  IF PREPIMP("AUXILIO FUNERAL")              // confima preparacao da impressora
   IF categ=[AF]
    ADM_R020(0,0,ult_reg)
    ADR_R029(0,0,ult_reg)
   ELSE
    ADM_RX20(0,0,ult_reg)
    ADR_RX29(0,0,ult_reg)
   ENDI
   ADM_R029(0,0,ult_reg)
 #endi

 REST SCREEN                    // restaura tela
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
 PROC AFU_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE AFU_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == processo
  REPL processo WITH sq_processo
  REPL intlan WITH sq_intlan
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC AFU_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"AFU_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"processo"  ,"C",  5, 0},;
                    {"intlan"    ,"C",  8, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE AFUNER
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL AFU_SEQ->processo WITH processo
  REPL AFU_SEQ->intlan WITH intlan
  DBSETORDER(1)                 // retorna ao indice principal
 ENDI
 SELE AFU_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC AFU_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE AFU_SEQ
 BLOARQ(0,.5)
 sq_processo=AFU_SEQ->processo
 sq_intlan=AFU_SEQ->intlan
#else
 DBSETORDER(0)
 GO BOTT
#endi

M->processo=LPAD(STR(VAL(processo)+1),05,[0])
M->intlan=LPAD(STR(VAL(intlan)+1),08,[0])

#ifdef COM_REDE
 AFU_GRAVA_SEQ()
 sq_atual_=AFU_SEQ->processo
 UNLOCK                                            // libera o registro
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC AFU_GRAVA_SEQ
REPL processo WITH M->processo
REPL intlan WITH M->intlan
RETU

PROC AFU_tela     // tela do arquivo AFUNER
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
@ l_s+01,c_s+1 SAY " Processo..:      /  /    de             Categoria:"
@ l_s+02,c_s+1 SAY " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ   Dados do Contratante  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY " Contrato...:"
@ l_s+04,c_s+1 SAY " Grau.......:"
@ l_s+05,c_s+1 SAY " Respons vel:                                     (Declarante)"
@ l_s+06,c_s+1 SAY " Endere‡o...:                                      Fone:"
@ l_s+07,c_s+1 SAY " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ   Dados do Falecido   ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+08,c_s+1 SAY " Inscrito..:"
@ l_s+09,c_s+1 SAY " Rua...:                                 Bairro:"
@ l_s+10,c_s+1 SAY " Cidade:                           UF:     Dt.Nasc.:"
@ l_s+11,c_s+1 SAY " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ   Dados do Falecimento   ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+12,c_s+1 SAY " Data:            hora:        Endere‡o:"
@ l_s+13,c_s+1 SAY "               Cidade:                           UF:"
@ l_s+14,c_s+1 SAY " Seu sepultamento ser  ..:            hora:"
@ l_s+15,c_s+1 SAY "                Cemit‚rio:"
@ l_s+16,c_s+1 SAY " Funcion rio respons vel.:"
@ l_s+18,c_s+1 SAY " Proc. Pgto em:              Vl.Auxilio:                Pago em"
RETU

PROC AFU_gets     // mostra variaveis do arquivo AFUNER
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS(), op_ant := op_menu
AFU_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(CONTRATO,'GRUPOS',1)
PTAB(FUNCRESP,'FNCS',1)
PTAB(PROCESSO+PROC2+M->P_FILIAL+CATEG,[PRCESSOS],1)
PTAB(PADR(SUBSTR(M->IDE_MAQ,2),4)+[AFU],[IMPPAR],1)
CRIT("",,"5")
@ l_s+01 ,c_s+14 GET  processo;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+01 ,c_s+20 GET  proc2;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]
		 CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"5")

@ l_s+01 ,c_s+30 GET  ocorr_;
		 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+01 ,c_s+53 GET  categ;
		 PICT sistema[op_sis,O_CAMPO,05,O_MASC]
		 CRIT(sistema[op_sis,O_CAMPO,05,O_CRIT],,"4")

@ l_s+03 ,c_s+15 GET  contrato;
		 PICT sistema[op_sis,O_CAMPO,06,O_MASC]
		 CRIT(sistema[op_sis,O_CAMPO,06,O_CRIT],,"1|2|6")

@ l_s+04 ,c_s+15 GET  grauparcon

@ l_s+05 ,c_s+15 GET  nomedec;
		 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+06 ,c_s+15 GET  ruadec;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+06 ,c_s+58 GET  fonedec;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+08 ,c_s+14 GET  codigofal

@ l_s+08 ,c_s+33 GET  falecido

@ l_s+09 ,c_s+10 GET  ruares

@ l_s+09 ,c_s+50 GET  baires

@ l_s+10 ,c_s+10 GET  munres

@ l_s+10 ,c_s+40 GET  estres;
                 PICT sistema[op_sis,O_CAMPO,16,O_MASC]

@ l_s+10 ,c_s+54 GET  nascto_;
                 PICT sistema[op_sis,O_CAMPO,17,O_MASC]

@ l_s+12 ,c_s+08 GET  falecto_;
                 PICT sistema[op_sis,O_CAMPO,18,O_MASC]

@ l_s+12 ,c_s+25 GET  horafal;
                 PICT sistema[op_sis,O_CAMPO,19,O_MASC]

@ l_s+12 ,c_s+42 GET  ruafal

@ l_s+13 ,c_s+24 GET  municfal

@ l_s+13 ,c_s+54 GET  estfal;
                 PICT sistema[op_sis,O_CAMPO,22,O_MASC]

@ l_s+14 ,c_s+28 GET  sepult_;
                 PICT sistema[op_sis,O_CAMPO,23,O_MASC]

@ l_s+14 ,c_s+45 GET  horasepult;
                 PICT sistema[op_sis,O_CAMPO,24,O_MASC]

@ l_s+15 ,c_s+28 GET  cemitsep

@ l_s+16 ,c_s+28 GET  funcresp;
                 PICT sistema[op_sis,O_CAMPO,26,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,26,O_CRIT],,"3")

@ l_s+18 ,c_s+17 GET  procpagto_;
                 PICT sistema[op_sis,O_CAMPO,27,O_MASC]

@ l_s+18 ,c_s+42 GET  vlauxilio;
                 PICT sistema[op_sis,O_CAMPO,28,O_MASC]

@ l_s+18 ,c_s+65 GET  pagtoem_;
                 PICT sistema[op_sis,O_CAMPO,29,O_MASC]

CLEAR GETS
RETU

PROC AFU_get1(tp_mov)     // capta variaveis do arquivo AFUNER
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS(), op_ant := op_menu
PRIV  blk_afuner:=.t.

IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"5")
  @ l_s+01 ,c_s+30 GET  ocorr_;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+01 ,c_s+53 GET  categ;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5
                   MOSTRA sistema[op_sis,O_FORMULA,4]

  @ l_s+03 ,c_s+15 GET  contrato;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6
                   MOSTRA sistema[op_sis,O_FORMULA,1]
                   MOSTRA sistema[op_sis,O_FORMULA,2]
                   MOSTRA sistema[op_sis,O_FORMULA,6]

  @ l_s+04 ,c_s+15 GET  grauparcon
                   DEFINICAO 7

  @ l_s+05 ,c_s+15 GET  nomedec;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+06 ,c_s+15 GET  ruadec;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+06 ,c_s+58 GET  fonedec;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

  @ l_s+08 ,c_s+14 GET  codigofal
                   DEFINICAO 11

  @ l_s+08 ,c_s+33 GET  falecido
                   DEFINICAO 12

  @ l_s+09 ,c_s+10 GET  ruares
                   DEFINICAO 13

  @ l_s+09 ,c_s+50 GET  baires
                   DEFINICAO 14

  @ l_s+10 ,c_s+10 GET  munres
                   DEFINICAO 15

  @ l_s+10 ,c_s+40 GET  estres;
                   PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                   DEFINICAO 16

  @ l_s+10 ,c_s+54 GET  nascto_;
                   PICT sistema[op_sis,O_CAMPO,17,O_MASC]
                   DEFINICAO 17

  @ l_s+12 ,c_s+08 GET  falecto_;
                   PICT sistema[op_sis,O_CAMPO,18,O_MASC]
                   DEFINICAO 18

  @ l_s+12 ,c_s+25 GET  horafal;
                   PICT sistema[op_sis,O_CAMPO,19,O_MASC]
                   DEFINICAO 19

  @ l_s+12 ,c_s+42 GET  ruafal
                   DEFINICAO 20

  @ l_s+13 ,c_s+24 GET  municfal
                   DEFINICAO 21

  @ l_s+13 ,c_s+54 GET  estfal;
                   PICT sistema[op_sis,O_CAMPO,22,O_MASC]
                   DEFINICAO 22

  @ l_s+14 ,c_s+28 GET  sepult_;
                   PICT sistema[op_sis,O_CAMPO,23,O_MASC]
                   DEFINICAO 23

  @ l_s+14 ,c_s+45 GET  horasepult;
                   PICT sistema[op_sis,O_CAMPO,24,O_MASC]
                   DEFINICAO 24

  @ l_s+15 ,c_s+28 GET  cemitsep
                   DEFINICAO 25

  @ l_s+16 ,c_s+28 GET  funcresp;
                   PICT sistema[op_sis,O_CAMPO,26,O_MASC]
                   DEFINICAO 26
                   MOSTRA sistema[op_sis,O_FORMULA,3]

  @ l_s+18 ,c_s+17 GET  procpagto_;
                   PICT sistema[op_sis,O_CAMPO,27,O_MASC]
                   DEFINICAO 27

  @ l_s+18 ,c_s+42 GET  vlauxilio;
                   PICT sistema[op_sis,O_CAMPO,28,O_MASC]
                   DEFINICAO 28

  @ l_s+18 ,c_s+65 GET  pagtoem_;
                   PICT sistema[op_sis,O_CAMPO,29,O_MASC]
                   DEFINICAO 29

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
PTAB(CONTRATO,'GRUPOS',1)
PTAB(CONTRATO,'TAXAS',1)
PTAB(GRUPOS->GRUPO,'ARQGRUP',1)
PTAB(CODIGOFAL,'INSCRITS',1)
PTAB(FUNCRESP,'FNCS',1)
PTAB(PROCESSO+PROC2+M->P_FILIAL+CATEG,[PRCESSOS],1)
PTAB(PADR(SUBSTR(M->IDE_MAQ,2),4)+[AFU],[IMPPAR],1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA

 #ifdef COM_REDE
  PARAMETROS(dbfparam,'procimp',processo+proc2+filial)
 #else
  PARAMETROS(dbfparam,'procimp',processo+proc2+filial)
 #endi

 IF 1=3
  IF !EMPTY(PRCESSOS->codlan)
   TIRA_LANC("PRCESSOS",LEFT(PRCESSOS->codlan,16))
  ENDI
 ENDI
 IF 1=3
  IF !EMPTY(IMPPAR->codlan)
   TIRA_LANC("IMPPAR",LEFT(IMPPAR->codlan,16))
  ENDI
 ENDI
 IF !EMPTY(ALIAS())
  DELE
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF !PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1)
   ord_=LEN(sistema[EVAL(qualsis,"PRCESSOS"),O_CHAVE])
   IF !EMPTY(PRCESSOS->codlan)
    chv_=LEFT(PRCESSOS->codlan,16)
   ELSE
    IF TYPE("M->intlan")="C" .AND. EMPTY(intlan)
     chv_="AFU-"+M->intlan+"-001"
    ELSE
     chv_="AFU-"+intlan+"-001"
    ENDI
   ENDI
   PTAB(chv_,"PRCESSOS",ord_)
   FAZ_LANC("PRCESSOS",chv_)
   REPL PRCESSOS->processo WITH processo+proc2+M->p_filial,;
        PRCESSOS->categ WITH categ,;
        PRCESSOS->grup WITH GRUPOS->grupo,;
        PRCESSOS->num WITH contrato,;
        PRCESSOS->grau WITH SUBSTR(codigofal,10,1),;
        PRCESSOS->seq WITH VAL(SUBSTR(codigofal,11,2)),;
        PRCESSOS->seg WITH nomedec,;
        PRCESSOS->ends WITH ruares,;
        PRCESSOS->cids WITH munres,;
        PRCESSOS->fal WITH falecido,;
        PRCESSOS->sep WITH cemitsep,;
        PRCESSOS->dfal WITH falecto_
   SELE PRCESSOS                                   // arquivo alvo do lancamento
   op_menu=ALTERACAO
   PRC_GET1(FORM_DIRETA)                           // faz processo do arq do lancamento
   op_menu=op_ant

   #ifdef COM_REDE
    UNLOCK                                         // libera o registro
   #endi

   IF EMPT(ar_get1)                                // retorna para area original
    SELE 0
   ELSE
    SELE (ar_get1)
   ENDI
  ENDI
  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[AFU],[IMPPAR],1)
   ord_=LEN(sistema[EVAL(qualsis,"IMPPAR"),O_CHAVE])
   IF !EMPTY(IMPPAR->codlan)
    chv_=LEFT(IMPPAR->codlan,16)
   ELSE
    IF TYPE("M->intlan")="C" .AND. EMPTY(intlan)
     chv_="AFU-"+M->intlan+"-002"
    ELSE
     chv_="AFU-"+intlan+"-002"
    ENDI
   ENDI
   PTAB(chv_,"IMPPAR",ord_)
   FAZ_LANC("IMPPAR",chv_)
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
        IMPPAR->base WITH [AFU]

   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

  ENDI
  PARAMETROS(dbfparam,'procimp',processo+proc2+filial)

  #ifdef COM_REDE
   IF op_menu=INCLUSAO
    filial=M->p_filial
   ELSE
    REPL filial WITH M->p_filial
   ENDI
   IF PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1).AND.(EMPT(PRCESSOS->saiu).OR.PRCESSOS->saiu=ARQGRUP->ultcirc)
    REPBLO('PRCESSOS->categ',{||categ})
   ENDI
   IF PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1).AND.(EMPT(PRCESSOS->saiu).OR.PRCESSOS->saiu=ARQGRUP->ultcirc)
    REPBLO('PRCESSOS->ends',{||ruares})
   ENDI
   IF PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1).AND.(EMPT(PRCESSOS->saiu).OR.PRCESSOS->saiu=ARQGRUP->ultcirc)
    REPBLO('PRCESSOS->cids',{||munres})
   ENDI
   IF PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1).AND.(EMPT(PRCESSOS->saiu).OR.PRCESSOS->saiu=ARQGRUP->ultcirc)
    REPBLO('PRCESSOS->fal',{||falecido})
   ENDI
   IF PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1).AND.(EMPT(PRCESSOS->saiu).OR.PRCESSOS->saiu=ARQGRUP->ultcirc)
    REPBLO('PRCESSOS->dfal',{||falecto_})
   ENDI
   IF PTAB(PADR(M->ide_maq,4)+[AFU],[IMPPAR],1)
    REPBLO('IMPPAR->docto',{||processo+proc2+filial+categ})
   ENDI
  #else
  PARAMETROS(dbfparam,'procimp',processo+proc2+filial)
   IF op_menu=INCLUSAO
    filial=M->p_filial
   ELSE
    REPL filial WITH M->p_filial
   ENDI
   IF PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1).AND.(EMPT(PRCESSOS->saiu).OR.PRCESSOS->saiu=ARQGRUP->ultcirc)
    REPL PRCESSOS->categ WITH categ
   ENDI
   IF PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1).AND.(EMPT(PRCESSOS->saiu).OR.PRCESSOS->saiu=ARQGRUP->ultcirc)
    REPL PRCESSOS->ends WITH ruares
   ENDI
   IF PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1).AND.(EMPT(PRCESSOS->saiu).OR.PRCESSOS->saiu=ARQGRUP->ultcirc)
    REPL PRCESSOS->cids WITH munres
   ENDI
   IF PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1).AND.(EMPT(PRCESSOS->saiu).OR.PRCESSOS->saiu=ARQGRUP->ultcirc)
    REPL PRCESSOS->fal WITH falecido
   ENDI
   IF PTAB(processo+proc2+M->p_filial+categ,[PRCESSOS],1).AND.(EMPT(PRCESSOS->saiu).OR.PRCESSOS->saiu=ARQGRUP->ultcirc)
    REPL PRCESSOS->dfal WITH falecto_
   ENDI
   IF PTAB(PADR(M->ide_maq,4)+[AFU],[IMPPAR],1)
    REPL IMPPAR->docto WITH processo+proc2+filial+categ
   ENDI
  #endi

  IF op_menu!=INCLUSAO
   RECA
  ENDI
 ENDI
ENDI
RETU

* \\ Final de AFUNER.PRG
