procedure grupos
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: GRUPOS.PRG
 \ Data....: 12-11-03
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Gerenciador do subsistema de consulta contratos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79), l_s, c_s, l_i, c_i, l_a

op_sis=EVAL(qualsis,"GRUPOS")
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
     "Consulta~3|"+;
     "Consulta Inscritos~4|"+;
     "Consulta Taxas~5"
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
    GRU_INCL()                                     // neste arquivo chama prg de inclusao
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

  CASE op_cad=04                                   // consulta inscritos
   cod_sos=8
   CTAINSC()

  CASE op_cad=05                                   // consulta taxas
   cod_sos=8
   CTXAS()

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC GRU_incl(reg_cop)  // inclusao no arquivo GRUPOS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(), cond_incl_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, tem_borda, criterio:="", cpord:=""
cond_incl_={||1=3}                                 // condicao de inclusao de registros
IF !EVAL(cond_incl_)                               // se nao pode incluir
 ALERTA(2)                                         // avisa o motivo
 DBOX("Mantido pelo sistema de Plano",,,4,,"ATEN€ŽO, "+usuario)
 RETU                                              // e retorna
ENDI
atend1:=atend2:=space(15)
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
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE GRUPOS
 GO BOTT                                           // forca o
 SKIP                                              // final do arquivo
 
 /*
    cria variaveis de memoria identicas as de arquivo, para inclusao
    de registros
 */
 atend1:=atend2:=space(15)
 FOR i=1 TO FCOU()
  msg=FIEL(i)
  M->&msg.=IF((fgrep .OR. reg_cop!=NIL).AND.!EMPT(rep[1]),rep[i],&msg.)
 NEXT
 DISPBEGIN()                                       // apresenta a tela de uma vez so
 GRU_GETS()
 IMPRELA()
 GRU_TELA()
 INFOSIS(.t.)                                      // exibe informacao no rodape' da tela
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
 cabem=INT((cabem-2048)/GRUPOS->(RECSIZE()))
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
 @ l_s+01 ,c_s+10 GET  codigo;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE GRUPOS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->codigo
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  GRU_GETS()
  IMPRELA()
  GRU_GETS()                                       // mostra conteudo do registro
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
 GRU_GET1(INCLUI)                                  // recebe campos
 SELE GRUPOS
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
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
   GRU_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE GRUPOS
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
 IF sistema[EVAL(qualsis,"TAXAS"),O_OUTROS,O_NIVEL]<5
  SUBNIVEL("TAXAS")
 ENDI
 IF sistema[EVAL(qualsis,"ECOB"),O_OUTROS,O_NIVEL]<5
  SUBNIVEL("ECOB")
 ENDI
 IF sistema[EVAL(qualsis,"INSCRITS"),O_OUTROS,O_NIVEL]<5
  SUBNIVEL("INSCRITS")
 ENDI
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


PROC GRU_tela     // tela do arquivo GRUPOS
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
@ l_s+01,c_s+1 SAY " Codigo:                                         Situa‡„o:"
@ l_s+02,c_s+1 SAY "  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Dados Pessoais ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY " Nome..:                                     Nasc.:"
@ l_s+04,c_s+1 SAY " ECivil:                  CPF:               RG...:"
@ l_s+05,c_s+1 SAY " Ender.:                                     Bairr:"
@ l_s+06,c_s+1 SAY " Cidade:                           UF.:      CEP..:"
@ l_s+07,c_s+1 SAY " Natur.:                           Relig:"
@ l_s+08,c_s+1 SAY " Contato                           Tel:"
@ l_s+09,c_s+1 SAY " Categor.:     Carnˆ:      F.Pgto:"
@ l_s+10,c_s+1 SAY " Admiss„o:             T.Carˆncia:              Sai Taxas.:"
@ l_s+11,c_s+1 SAY " Vendedor:                                      Dia Pgto..:"
@ l_s+12,c_s+1 SAY " Regi„o..:                                      Observa‡„o:"
@ l_s+13,c_s+1 SAY " Cobrador:                                      Renova‡„o.:"
@ l_s+14,c_s+1 SAY " Funerais:       Circ.Inic:       Ult.:        Emit:      Baix:"
@ l_s+15,c_s+1 SAY " Atendimento.1:                      2:"
@ l_s+16,c_s+1 SAY " Participantes: Vivos:    Falecidos:    Dependentes:"
@ l_s+17,c_s+1 SAY " email:                                             "
@ l_s+18,c_s+1 SAY " Ult.Altera‡„o:                       Ult.Impress„o:"
RETU

PROC GRU_gets     // mostra variaveis do arquivo GRUPOS
LOCAL getlist := {}, t_f7_
GRU_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB('',[ARQGRUP],1)
PTAB(TIPCONT,'CLASSES',1)
PTAB(VENDEDOR,'COBRADOR',1)
PTAB(REGIAO,'REGIAO',1)
PTAB(COBRADOR,'COBRADOR',1)
PTAB(IIF(CLASSES->PRIOR=[S],M->MGRUPVIP,GRUPO)+ULTCIRC,'CIRCULAR',1)
CRIT("",,"2|3|6|9|10|11|12|13")
@ l_s+01 ,c_s+10 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+01 ,c_s+60 GET  situacao;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"1")

@ l_s+03 ,c_s+10 GET  nome;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+03 ,c_s+53 GET  nascto_;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,05,O_CRIT],,"16")

@ l_s+04 ,c_s+10 GET  estcivil;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,06,O_CRIT],,"8")

@ l_s+04 ,c_s+31 GET  cpf;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+04 ,c_s+53 GET  rg;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+05 ,c_s+10 GET  endereco;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+05 ,c_s+53 GET  bairro;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+06 ,c_s+10 GET  cidade;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]

@ l_s+06 ,c_s+41 GET  uf;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]

@ l_s+06 ,c_s+53 GET  cep;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]

@ l_s+07 ,c_s+10 GET  natural;
                 PICT sistema[op_sis,O_CAMPO,14,O_MASC]

@ l_s+07 ,c_s+43 GET  relig;
                 PICT sistema[op_sis,O_CAMPO,15,O_MASC]

@ l_s+08 ,c_s+10 GET  contato;
                 PICT sistema[op_sis,O_CAMPO,16,O_MASC]

@ l_s+08 ,c_s+41 GET  telefone;
                 PICT sistema[op_sis,O_CAMPO,17,O_MASC]

@ l_s+09 ,c_s+12 GET  tipcont;
                 PICT sistema[op_sis,O_CAMPO,18,O_MASC]

@ l_s+09 ,c_s+23 GET  vlcarne

@ l_s+09 ,c_s+36 GET  formapgto;
                 PICT sistema[op_sis,O_CAMPO,20,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,20,O_CRIT],,"15")

@ l_s+10 ,c_s+12 GET  admissao;
                 PICT sistema[op_sis,O_CAMPO,22,O_MASC]

@ l_s+10 ,c_s+36 GET  tcarencia;
                 PICT sistema[op_sis,O_CAMPO,23,O_MASC]

@ l_s+10 ,c_s+61 GET  saitxa;
                 PICT sistema[op_sis,O_CAMPO,24,O_MASC]

@ l_s+11 ,c_s+61 GET  diapgto;
                 PICT sistema[op_sis,O_CAMPO,25,O_MASC]

@ l_s+11 ,c_s+12 GET  vendedor;
                 PICT sistema[op_sis,O_CAMPO,26,O_MASC]

@ l_s+12 ,c_s+12 GET  regiao;
                 PICT sistema[op_sis,O_CAMPO,27,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,27,O_CRIT],,"7")

@ l_s+13 ,c_s+12 GET  cobrador;
                 PICT sistema[op_sis,O_CAMPO,28,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,28,O_CRIT],,"4|5")

@ l_s+12 ,c_s+61 SAY "{M} "

@ l_s+13 ,c_s+61 GET  renovar;
                 PICT sistema[op_sis,O_CAMPO,30,O_MASC]

@ l_s+14 ,c_s+12 GET  funerais;
                 PICT sistema[op_sis,O_CAMPO,31,O_MASC]

@ l_s+14 ,c_s+29 GET  circinic;
                 PICT sistema[op_sis,O_CAMPO,32,O_MASC]

@ l_s+14 ,c_s+41 GET  ultcirc;
                 PICT sistema[op_sis,O_CAMPO,33,O_MASC]

@ l_s+14 ,c_s+54 GET  qtcircs;
                 PICT sistema[op_sis,O_CAMPO,34,O_MASC]

@ l_s+14 ,c_s+65 GET  qtcircpg;
                 PICT sistema[op_sis,O_CAMPO,35,O_MASC]

@ l_s+15 ,c_s+16 GET  atend1;
                 PICT sistema[op_sis,O_CAMPO,45,O_MASC]

@ l_s+17 ,c_s+16 GET  email;
                 PICT sistema[op_sis,O_CAMPO,50,O_MASC]

CLEAR GETS
RETU

PROC GRU_get1(tp_mov)     // capta variaveis do arquivo GRUPOS
LOCAL getlist := {}, t_f7_
PRIV  blk_grupos:=.t.

IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  memo29:="{F7}"
  t_f7_=SETKEY(K_F7,{||GRU_memo()})
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"2|3|6|9|10|11|12|13")
  @ l_s+01 ,c_s+60 GET  situacao;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3
                   MOSTRA sistema[op_sis,O_FORMULA,1]

  @ l_s+03 ,c_s+10 GET  nome;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+03 ,c_s+53 GET  nascto_;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5
                   MOSTRA sistema[op_sis,O_FORMULA,16]

  @ l_s+04 ,c_s+10 GET  estcivil;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6
                   MOSTRA sistema[op_sis,O_FORMULA,8]

  @ l_s+04 ,c_s+31 GET  cpf;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+04 ,c_s+53 GET  rg;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+05 ,c_s+10 GET  endereco;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+05 ,c_s+53 GET  bairro;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

  @ l_s+06 ,c_s+10 GET  cidade;
                   PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                   DEFINICAO 11

  @ l_s+06 ,c_s+41 GET  uf;
                   PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                   DEFINICAO 12

  @ l_s+06 ,c_s+53 GET  cep;
                   PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                   DEFINICAO 13

  @ l_s+07 ,c_s+10 GET  natural;
                   PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                   DEFINICAO 14

  @ l_s+07 ,c_s+43 GET  relig;
                   PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                   DEFINICAO 15

  @ l_s+08 ,c_s+10 GET  contato;
                   PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                   DEFINICAO 16

  @ l_s+08 ,c_s+41 GET  telefone;
                   PICT sistema[op_sis,O_CAMPO,17,O_MASC]
                   DEFINICAO 17

  @ l_s+09 ,c_s+12 GET  tipcont;
                   PICT sistema[op_sis,O_CAMPO,18,O_MASC]
                   DEFINICAO 18

  @ l_s+09 ,c_s+23 GET  vlcarne
                   DEFINICAO 19

  @ l_s+09 ,c_s+36 GET  formapgto;
                   PICT sistema[op_sis,O_CAMPO,20,O_MASC]
                   DEFINICAO 20
                   MOSTRA sistema[op_sis,O_FORMULA,15]

  @ l_s+10 ,c_s+12 GET  admissao;
                   PICT sistema[op_sis,O_CAMPO,22,O_MASC]
                   DEFINICAO 22

  @ l_s+10 ,c_s+36 GET  tcarencia;
                   PICT sistema[op_sis,O_CAMPO,23,O_MASC]
                   DEFINICAO 23

  @ l_s+10 ,c_s+61 GET  saitxa;
                   PICT sistema[op_sis,O_CAMPO,24,O_MASC]
                   DEFINICAO 24

  @ l_s+11 ,c_s+61 GET  diapgto;
                   PICT sistema[op_sis,O_CAMPO,25,O_MASC]
                   DEFINICAO 25

  @ l_s+11 ,c_s+12 GET  vendedor;
                   PICT sistema[op_sis,O_CAMPO,26,O_MASC]
                   DEFINICAO 26

  @ l_s+12 ,c_s+12 GET  regiao;
                   PICT sistema[op_sis,O_CAMPO,27,O_MASC]
                   DEFINICAO 27
                   MOSTRA sistema[op_sis,O_FORMULA,7]

  @ l_s+13 ,c_s+12 GET  cobrador;
                   PICT sistema[op_sis,O_CAMPO,28,O_MASC]
                   DEFINICAO 28
                   MOSTRA sistema[op_sis,O_FORMULA,4]
                   MOSTRA sistema[op_sis,O_FORMULA,5]

  @ l_s+12 ,c_s+61 GET  memo29;
                   PICT "@!"
                   DEFINICAO 29

  @ l_s+13 ,c_s+61 GET  renovar;
                   PICT sistema[op_sis,O_CAMPO,30,O_MASC]
                   DEFINICAO 30

  @ l_s+14 ,c_s+12 GET  funerais;
                   PICT sistema[op_sis,O_CAMPO,31,O_MASC]
                   DEFINICAO 31

  @ l_s+14 ,c_s+29 GET  circinic;
                   PICT sistema[op_sis,O_CAMPO,32,O_MASC]
                   DEFINICAO 32

  @ l_s+14 ,c_s+41 GET  ultcirc;
                   PICT sistema[op_sis,O_CAMPO,33,O_MASC]
                   DEFINICAO 33

  @ l_s+14 ,c_s+54 GET  qtcircs;
                   PICT sistema[op_sis,O_CAMPO,34,O_MASC]
                   DEFINICAO 34

  @ l_s+14 ,c_s+65 GET  qtcircpg;
                   PICT sistema[op_sis,O_CAMPO,35,O_MASC]
                   DEFINICAO 35

  @ l_s+15 ,c_s+16 GET  atend1;
                   PICT sistema[op_sis,O_CAMPO,45,O_MASC]
                   DEFINICAO 45
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
PTAB('',[ARQGRUP],1)
PTAB(TIPCONT,'CLASSES',1)
PTAB(VENDEDOR,'COBRADOR',1)
PTAB(REGIAO,'REGIAO',1)
PTAB(COBRADOR,'COBRADOR',1)
PTAB(IIF(CLASSES->PRIOR=[S],M->MGRUPVIP,GRUPO)+ULTCIRC,'CIRCULAR',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA

 #ifdef COM_REDE
  REPBLO('ARQGRUP->contrat',{||ARQGRUP->contrat - 1})
 #else
  REPL ARQGRUP->contrat WITH ARQGRUP->contrat - 1
 #endi

 INTREF(FORM_INVERSA)
 IF !EMPTY(ALIAS())
  DELE
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO

  #ifdef COM_REDE
   REPBLO('ARQGRUP->contrat',{||ARQGRUP->contrat + 1})
   IF op_menu=INCLUSAO
    ender_=DATE()
   ELSE
    REPL ender_ WITH DATE()
   ENDI
   IF op_menu=INCLUSAO
    ultend=M->usuario
   ELSE
    REPL ultend WITH M->usuario
   ENDI
  #else
   REPL ARQGRUP->contrat WITH ARQGRUP->contrat + 1
   IF op_menu=INCLUSAO
    ender_=DATE()
   ELSE
    REPL ender_ WITH DATE()
   ENDI
   IF op_menu=INCLUSAO
    ultend=M->usuario
   ELSE
    REPL ultend WITH M->usuario
   ENDI
  #endi

  IF op_menu!=INCLUSAO
   RECA
   INTREF(FORM_DIRETA)
  ENDI
 ENDI
ENDI
RETU

PROC GRU_MEMO
IF READVAR()="MEMO29"
 EDIMEMO("obs",sistema[op_sis,O_CAMPO,29,O_TITU],14,2,23,38)
ENDI
RETU

PROC TAX_incl(reg_cop)  // inclusao no arquivo TAXAS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, t_f3_, t_f4_, l_max, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:="", l_a
op_sis=EVAL(qualsis,"TAXAS")
IF AT("D",exrot[op_sis])>0
 RETU
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
DISPBEGIN()                                        // monta tela na pagina de traz
IMPRELA()                                          // imp telas do pai
TAX_TELA()                                         // imp tela para inclusao
INFOSIS(.t.)                                       // exibe informacao no rodape' da tela
l_a=Sistema[op_sis,O_TELA,O_SCROLL]
DISPEND()                                          // apresenta tela de uma vez so
DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE TAXAS
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
 
 /*
    inicializa campos de relacionamentos do com os campos do arquivo
    superior (pai)
 */
 FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
  msg=FIEL(VAL(SUBS(sistema[op_sis,O_ORDEM,1],i*2-1,2)))
  M->&msg.=&(sistema[op_sis,O_CPRELA,i])
 NEXT
 cabem=DISKSPACE(;
          IF(;
             LEN(sistema[op_sis,O_ARQUI,O_DIR_DBF])<2.OR.sistema[op_sis,O_ARQUI,O_DIR_DBF]="\",;
             0,;
             ASC(sistema[op_sis,O_ARQUI,O_DIR_DBF])-64;
          );
       )
 cabem=INT((cabem-2048)/TAXAS->(RECSIZE()))
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
 @ l_s+l_a,c_s+11 GET  cobranca;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE TAXAS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->codigo+M->cobranca
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  l_a=Sistema[op_sis,O_TELA,O_SCROLL]
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  TAX_GETS()                                       // mostra conteudo do registro
  INFOSIS(.f.)                                     // exibe informacao no rodape' da tela
  DISPEND()
  ALERTA()
  msg="Consultar/alterar|Retornar … inclus„o"      // pergunta se deseja
  op_=DBOX(msg,,,E_MENU,,"REGISTRO J EXISTE")     // alterar o registro
  IF op_ =1                                        // caso afirmativo
   EDIT()                                          // deixa alterar
  ENDI
  op_menu=INCLUSAO
  DISPBEGIN()
  TAX_TELA()
  INFOSIS(.t.)                                     // exibe informacao no rodape' da tela
  DISPEND()
  LOOP                                             // volta para inclusao
 ENDI
 SELE 0
 TAX_GET1(INCLUI)                                  // recebe campos
 SELE TAXAS
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->codigo+M->cobranca                       // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   TAX_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE TAXAS
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
 l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
 IF l_s+l_a+1<l_max                                // se nao atingiu o fim da tela
  l_a++                                            // digita na proxima linha
 ELSE                                              // se nao rola a campos para cima
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+11,l_max-1,c_s+28,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+30,l_max-1,c_s+39,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+41,l_max-1,c_s+50,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+53,l_max-1,c_s+62,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+64,l_max-1,c_s+73,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+75,l_max-1,c_s+77,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+01,l_max-1,c_s+08,1)
 ENDI
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


PROC TAX_tela     // tela do arquivo TAXAS
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
@ l_s+01,c_s+1 SAY "N§                            Emissao       Valor  ³ Pagto    Valor Pago Stat"
@ l_s+02,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY "                                                   ³"
@ l_s+04,c_s+1 SAY "                                                   ³"
@ l_s+05,c_s+1 SAY "                                                   ³"
@ l_s+06,c_s+1 SAY "                                                   ³"
@ l_s+07,c_s+1 SAY "                                                   ³"
@ l_s+08,c_s+1 SAY "                                                   ³"
@ l_s+09,c_s+1 SAY "                                                   ³"
RETU

PROC TAX_gets     // mostra variaveis do arquivo TAXAS
LOCAL getlist := {}, l_max, reg_atual:=RECNO()
PRIV  l_a:=Sistema[op_sis,O_TELA,O_SCROLL]
TAX_TELA()
l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
DO WHILE !EOF() .AND. l_s+l_a<l_max .AND.;
   &(INDEXKEY(0))=IF(EMPT(criterio),"","T")+chv_1
 CRIT("",,"1|2")
 @ l_s+l_a,c_s+11 GET  cobranca;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]

 @ l_s+l_a,c_s+30 GET  emissao_;
                  PICT sistema[op_sis,O_CAMPO,05,O_MASC]

 @ l_s+l_a,c_s+41 GET  valor;
                  PICT sistema[op_sis,O_CAMPO,06,O_MASC]

 @ l_s+l_a,c_s+53 GET  pgto_;
                  PICT sistema[op_sis,O_CAMPO,07,O_MASC]

 @ l_s+l_a,c_s+64 GET  valorpg;
                  PICT sistema[op_sis,O_CAMPO,08,O_MASC]

 SETCOLOR(drvcortel+","+drvcortel+",,,"+drvcortel)
 l_a++
 SKIP
ENDD
GO reg_atual
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CLEAR GETS
RETU

PROC TAX_get1(tp_mov, excl_rela)     // capta variaveis do arquivo TAXAS
LOCAL getlist := {}
PRIV  blk_taxas:=.t.
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
 IF TYPE("l_a")!="N"
  l_a=Sistema[op_sis,O_TELA,O_SCROLL]
 ENDI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"1|2")
  @ l_s+l_a,c_s+30 GET  emissao_;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+l_a,c_s+41 GET  valor;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+l_a,c_s+53 GET  pgto_;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+l_a,c_s+64 GET  valorpg;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

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
PTAB(COBRADOR,'COBRADOR',1)
PTAB(COBRADOR+M->MMESREF,'FCCOB',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
 IF !EMPTY(codlan) .AND. tp_mov=EXCLUI
  ALERTA()       // existe registro validado aqui!
  msg="Registro de Lan‡amento"
  DBOX(msg,,,,,"IMPOSS¡VEL EXCLUIR!")
 ELSE

  #ifdef COM_REDE
   IF !tipo='1'
    REPBLO('GRUPOS->qtcircs',{||GRUPOS->qtcircs - 1})
   ENDI
   IF !tipo='1'.AND.valorpg>0
    REPBLO('GRUPOS->qtcircpg',{||GRUPOS->qtcircpg - 1})
   ENDI
   IF !excl_rela
    IF !EMPTY(ALIAS())
     REPL flag_excl WITH '*'
    ENDI
   ENDI
  #else
   IF !tipo='1'
    REPL GRUPOS->qtcircs WITH GRUPOS->qtcircs - 1
   ENDI
   IF !tipo='1'.AND.valorpg>0
    REPL GRUPOS->qtcircpg WITH GRUPOS->qtcircpg - 1
   ENDI
   IF !excl_rela
    IF !EMPTY(ALIAS())
     REPL flag_excl WITH '*'
    ENDI
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
   msg="Registro de Lan‡amento"
   DBOX(msg,,,,,"IMPOSS¡VEL RECUPERAR!")
  ELSE
   IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (GRUPOS->(DELE()))
    msg="|"+sistema[EVAL(qualsis,"GRUPOS"),O_MENU]
    ALERTA(2)
    DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
   ELSE

    #ifdef COM_REDE
     IF !tipo='1'
      REPBLO('GRUPOS->qtcircs',{||GRUPOS->qtcircs + 1})
     ENDI
     IF !tipo='1'.AND.valorpg>0
      REPBLO('GRUPOS->qtcircpg',{||GRUPOS->qtcircpg + 1})
     ENDI
     IF !tipo='1'.AND.circ>GRUPOS->ultcirc
      REPBLO('GRUPOS->ultcirc',{||circ})
     ENDI
     IF !excl_rela
      IF op_menu=INCLUSAO
       flag_excl=' '
      ELSE
       REPL flag_excl WITH ' '
      ENDI
     ENDI
    #else
     IF !tipo='1'
      REPL GRUPOS->qtcircs WITH GRUPOS->qtcircs + 1
     ENDI
     IF !tipo='1'.AND.valorpg>0
      REPL GRUPOS->qtcircpg WITH GRUPOS->qtcircpg + 1
     ENDI
     IF !tipo='1'.AND.circ>GRUPOS->ultcirc
      REPL GRUPOS->ultcirc WITH circ
     ENDI
     IF !excl_rela
      IF op_menu=INCLUSAO
       flag_excl=' '
      ELSE
       REPL flag_excl WITH ' '
      ENDI
     ENDI
    #endi

    IF op_menu!=INCLUSAO
     RECA
    ENDI
   ENDI
  ENDI
 ENDI
ENDI
RETU

PROC ECO_incl(reg_cop)  // inclusao no arquivo ECOB
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:=""
op_sis=EVAL(qualsis,"ECOB")
IF AT("D",exrot[op_sis])>0
 RETU
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
DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE ECOB
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
 
 /*
    inicializa campos de relacionamentos do com os campos do arquivo
    superior (pai)
 */
 FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
  msg=FIEL(VAL(SUBS(sistema[op_sis,O_ORDEM,1],i*2-1,2)))
  M->&msg.=&(sistema[op_sis,O_CPRELA,i])
 NEXT
 DISPBEGIN()                                       // apresenta a tela de uma vez so
 ECO_TELA()
 INFOSIS(.t.)                                      // exibe informacao no rodape' da tela
 DISPEND()
 cabem=DISKSPACE(;
          IF(;
             LEN(sistema[op_sis,O_ARQUI,O_DIR_DBF])<2.OR.sistema[op_sis,O_ARQUI,O_DIR_DBF]="\",;
             0,;
             ASC(sistema[op_sis,O_ARQUI,O_DIR_DBF])-64;
          );
       )
 cabem=INT((cabem-2048)/ECOB->(RECSIZE()))
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
 @ l_s+01 ,c_s+12 GET  tipo;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2
                  MOSTRA sistema[op_sis,O_FORMULA,1]

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE ECOB
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->codigo+M->tipo
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  ECO_GETS()                                       // mostra conteudo do registro
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
 ECO_GET1(INCLUI)                                  // recebe campos
 SELE ECOB
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->codigo+M->tipo                           // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   ECO_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE ECOB
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


PROC ECO_tela     // tela do arquivo ECOB
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
@ l_s+01,c_s+1 SAY " Tipo....:"
@ l_s+02,c_s+1 SAY " Endere‡o:"
@ l_s+03,c_s+1 SAY " Bairro..:"
@ l_s+04,c_s+1 SAY " CEP.....:"
@ l_s+05,c_s+1 SAY " Cidade..:                            Est.:"
@ l_s+06,c_s+1 SAY " Telefone:"
@ l_s+07,c_s+1 SAY " Obs.....:"
RETU

PROC ECO_gets     // mostra variaveis do arquivo ECOB
LOCAL getlist := {}
ECO_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
IF &(INDEXKEY(0))=IF(EMPT(criterio),"","T")+chv_1
 CRIT("",,"2")
 @ l_s+01 ,c_s+12 GET  tipo;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"1")

 @ l_s+02 ,c_s+12 GET  endereco;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]

 @ l_s+03 ,c_s+12 GET  bairro;
                  PICT sistema[op_sis,O_CAMPO,04,O_MASC]

 @ l_s+04 ,c_s+12 GET  cep;
                  PICT sistema[op_sis,O_CAMPO,05,O_MASC]

 @ l_s+05 ,c_s+12 GET  cidade;
                  PICT sistema[op_sis,O_CAMPO,06,O_MASC]

 @ l_s+05 ,c_s+45 GET  uf;
                  PICT sistema[op_sis,O_CAMPO,07,O_MASC]

 @ l_s+06 ,c_s+12 GET  telefone;
                  PICT sistema[op_sis,O_CAMPO,08,O_MASC]

 @ l_s+07 ,c_s+12 GET  obs

ENDI
CLEAR GETS
RETU

PROC ECO_get1(tp_mov, excl_rela)     // capta variaveis do arquivo ECOB
LOCAL getlist := {}
PRIV  blk_ecob:=.t.
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"2")
  @ l_s+02 ,c_s+12 GET  endereco;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3

  @ l_s+03 ,c_s+12 GET  bairro;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+04 ,c_s+12 GET  cep;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+05 ,c_s+12 GET  cidade;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+05 ,c_s+45 GET  uf;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+06 ,c_s+12 GET  telefone;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+07 ,c_s+12 GET  obs
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
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA

 #ifdef COM_REDE
  IF !excl_rela
   IF !EMPTY(ALIAS())
    REPL flag_excl WITH '*'
   ENDI
  ENDI
 #else
  IF !excl_rela
   IF !EMPTY(ALIAS())
    REPL flag_excl WITH '*'
   ENDI
  ENDI
 #endi

 IF !EMPTY(ALIAS())
  DELE
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (GRUPOS->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"GRUPOS"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
  ELSE
    IF op_menu=INCLUSAO
     data_=DATE()
    ELSE
     REPL data_ WITH DATE()
    ENDI
    IF !excl_rela
     IF op_menu=INCLUSAO
      flag_excl=' '
     ELSE
      REPL flag_excl WITH ' '
     ENDI
    ENDI
   IF op_menu!=INCLUSAO
    RECA
   ENDI
  ENDI
 ENDI
ENDI
RETU

PROC INS_incl(reg_cop)  // inclusao no arquivo INSCRITS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:=""
op_sis=EVAL(qualsis,"INSCRITS")
IF AT("D",exrot[op_sis])>0
 RETU
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
DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE INSCRITS
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
 
 /*
    inicializa campos de relacionamentos do com os campos do arquivo
    superior (pai)
 */
 FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
  msg=FIEL(VAL(SUBS(sistema[op_sis,O_ORDEM,1],i*2-1,2)))
  M->&msg.=&(sistema[op_sis,O_CPRELA,i])
 NEXT
 DISPBEGIN()                                       // apresenta a tela de uma vez so
 INS_TELA()
 INFOSIS(.t.)                                      // exibe informacao no rodape' da tela
 DISPEND()
 cabem=DISKSPACE(;
          IF(;
             LEN(sistema[op_sis,O_ARQUI,O_DIR_DBF])<2.OR.sistema[op_sis,O_ARQUI,O_DIR_DBF]="\",;
             0,;
             ASC(sistema[op_sis,O_ARQUI,O_DIR_DBF])-64;
          );
       )
 cabem=INT((cabem-2048)/INSCRITS->(RECSIZE()))
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
 @ l_s+01 ,c_s+09 GET  grau;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2
                  MOSTRA sistema[op_sis,O_FORMULA,1]

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE INSCRITS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->codigo+M->grau
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  INS_GETS()                                       // mostra conteudo do registro
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
 INS_GET1(INCLUI)                                  // recebe campos
 SELE INSCRITS
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->codigo+M->grau                           // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   INS_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE INSCRITS
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


PROC INS_tela     // tela do arquivo INSCRITS
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
@ l_s+01,c_s+1 SAY " Inscr:                                            (                   )"
@ l_s+02,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY " Nome:                                     Nasc.:"
@ l_s+04,c_s+1 SAY " Est.Civil.:     Sexo:    T.Carˆncia:             CPF:                 "
@ l_s+05,c_s+1 SAY " Vivo/Falec:     Falecto..:            Tipo:      N§ Processo:"
RETU

PROC INS_gets     // mostra variaveis do arquivo INSCRITS
LOCAL getlist := {}, tl_item_
INS_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
IF &(INDEXKEY(0))=IF(EMPT(criterio),"","T")+chv_1
 CRIT("",,"2|3")
 @ l_s+01 ,c_s+09 GET  grau;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"1")

 @ l_s+01 ,c_s+10 GET  seq;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]

 @ l_s+03 ,c_s+08 GET  nome;
                  PICT sistema[op_sis,O_CAMPO,05,O_MASC]

 @ l_s+03 ,c_s+51 GET  nascto_;
                  PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                  CRIT(sistema[op_sis,O_CAMPO,06,O_CRIT],,"4")

 @ l_s+04 ,c_s+14 GET  estcivil

 @ l_s+04 ,c_s+24 GET  sexo;
                  PICT sistema[op_sis,O_CAMPO,09,O_MASC]

 @ l_s+04 ,c_s+39 GET  tcarencia;
                  PICT sistema[op_sis,O_CAMPO,10,O_MASC]

 @ l_s+04 ,c_s+56 GET  cpf;
                  PICT sistema[op_sis,O_CAMPO,18,O_MASC]

 @ l_s+05 ,c_s+14 GET  vivofalec;
                  PICT sistema[op_sis,O_CAMPO,12,O_MASC]

 @ l_s+05 ,c_s+29 GET  falecto_;
                  PICT sistema[op_sis,O_CAMPO,13,O_MASC]

 @ l_s+05 ,c_s+46 GET  tipo;
                  PICT sistema[op_sis,O_CAMPO,14,O_MASC]

 @ l_s+05 ,c_s+64 GET  procnr;
                  PICT sistema[op_sis,O_CAMPO,15,O_MASC]

ENDI
CLEAR GETS
RETU

PROC INS_get1(tp_mov, excl_rela)     // capta variaveis do arquivo INSCRITS
LOCAL getlist := {}, tl_item_
PRIV  blk_inscrits:=.t.
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"2|3")
  @ l_s+01 ,c_s+10 GET  seq;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3

  @ l_s+03 ,c_s+08 GET  nome;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+03 ,c_s+51 GET  nascto_;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6
                   MOSTRA sistema[op_sis,O_FORMULA,4]

  @ l_s+04 ,c_s+14 GET  estcivil
                   DEFINICAO 7

  @ l_s+04 ,c_s+24 GET  sexo;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+04 ,c_s+39 GET  tcarencia;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

  @ l_s+04 ,c_s+56 GET  cpf;
                   PICT sistema[op_sis,O_CAMPO,18,O_MASC]
                   DEFINICAO 18

  @ l_s+05 ,c_s+14 GET  vivofalec;
                   PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                   DEFINICAO 12

  @ l_s+05 ,c_s+29 GET  falecto_;
                   PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                   DEFINICAO 13

  @ l_s+05 ,c_s+46 GET  tipo;
                   PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                   DEFINICAO 14

  @ l_s+05 ,c_s+64 GET  procnr;
                   PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                   DEFINICAO 15

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
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA

 #ifdef COM_REDE
  IF !EMPTY(ALIAS())
   REPL lancto_ WITH date()
  ENDI
  IF ehtitular=[S]
   REPBLO('GRUPOS->titular',{||[   ]})
  ENDI
  IF vivofalec=[V]
   REPBLO('GRUPOS->particv',{||GRUPOS->particv - 1})
  ENDI
  IF vivofalec=[F]
   REPBLO('GRUPOS->particf',{||GRUPOS->particf - 1})
  ENDI
  IF grau=[8]
   REPBLO('GRUPOS->nrdepend',{||GRUPOS->nrdepend - 1})
  ENDI
  IF !excl_rela
   IF !EMPTY(ALIAS())
    REPL flag_excl WITH '*'
   ENDI
  ENDI
 #else
  IF !EMPTY(ALIAS())
   REPL lancto_ WITH date()
  ENDI
  IF ehtitular=[S]
   REPL GRUPOS->titular WITH [   ]
  ENDI
  IF vivofalec=[V]
   REPL GRUPOS->particv WITH GRUPOS->particv - 1
  ENDI
  IF vivofalec=[F]
   REPL GRUPOS->particf WITH GRUPOS->particf - 1
  ENDI
  IF grau=[8]
   REPL GRUPOS->nrdepend WITH GRUPOS->nrdepend - 1
  ENDI
  IF !excl_rela
   IF !EMPTY(ALIAS())
    REPL flag_excl WITH '*'
   ENDI
  ENDI
 #endi

 IF !EMPTY(ALIAS())
  DELE
 ENDI
 IF op_menu!=PROJECOES .AND. op_menu!=TEL_EXTRA
  REIMPTEL()
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (GRUPOS->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"GRUPOS"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
  ELSE
    IF op_menu=INCLUSAO
     lancto_=date()
    ELSE
     REPL lancto_ WITH date()
    ENDI

   #ifdef COM_REDE
    IF ehtitular=[S]
     REPBLO('GRUPOS->titular',{||grau+STRZERO(seq,2)})
    ENDI
    IF vivofalec=[V]
     REPBLO('GRUPOS->particv',{||GRUPOS->particv + 1})
    ENDI
    IF vivofalec=[F]
     REPBLO('GRUPOS->particf',{||GRUPOS->particf + 1})
    ENDI
    IF grau=[8]
     REPBLO('GRUPOS->nrdepend',{||GRUPOS->nrdepend + 1})
    ENDI
    IF !excl_rela
     IF op_menu=INCLUSAO
      flag_excl=' '
     ELSE
      REPL flag_excl WITH ' '
     ENDI
    ENDI
   #else
    IF op_menu=INCLUSAO
     lancto_=date()
    ELSE
     REPL lancto_ WITH date()
    ENDI
    IF ehtitular=[S]
     REPL GRUPOS->titular WITH grau+STRZERO(seq,2)
    ENDI
    IF vivofalec=[V]
     REPL GRUPOS->particv WITH GRUPOS->particv + 1
    ENDI
    IF vivofalec=[F]
     REPL GRUPOS->particf WITH GRUPOS->particf + 1
    ENDI
    IF grau=[8]
     REPL GRUPOS->nrdepend WITH GRUPOS->nrdepend + 1
    ENDI
    IF !excl_rela
     IF op_menu=INCLUSAO
      flag_excl=' '
     ELSE
      REPL flag_excl WITH ' '
     ENDI
    ENDI
   #endi

   IF op_menu!=INCLUSAO
    RECA
   ENDI
   IF (tp_mov=INCLUI .OR. tp_mov=RECUPERA) .AND. op_menu!=PROJECOES .AND. op_menu!=TEL_EXTRA
    REIMPTEL()
   ENDI
  ENDI
 ENDI
ENDI
RETU

* \\ Final de GRUPOS.PRG
