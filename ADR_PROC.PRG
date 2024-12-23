// <ADRBIG> - <ADR_>
procedure ADR_proc
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda
 \ Programa: ADR_PROC.PRG
 \ Data....: 25-06-21
 \ Sistema.: Controle de Processos da Funer†ria
 \ Funcao..: Rotinas auxiliares
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "ADRBIG.ch"    // inicializa constantes manifestas

PROC CBC1    // rotina para exibir pano de fundo
DISPBEGIN()                            // monta tela no buffer
SETCOLOR(drvcorpad)                    // imprime pano de fundo
CAIXA(REPL(drvcara,9),0,0,MAXROW(),79)
SETCOLOR(drvtitbox)
CAIXA(mold,01,03,04,77)                // monta caixa da tela
SETCOLOR(drvcorbox)
@ 02,04 SAY "                                                              ,"
@ 02,05 SAY nemp
@ 03,05 SAY nsis
@ 02,66 SAY DATE()
@ 02,57 SAY NSEM(DATE())
@ 03,53 SAY drvdbf
SETCOLOR(drvtitbox)
CAIXA(mold,13,37,21,77)                // monta caixa da tela
SETCOLOR(drvcorbox)
@ 14,38 SAY "    PresServ Inform†tica Ltda. - ME"
@ 15,38 SAY "     Rua Apparecida B.Boldrin, 221 "
@ 16,38 SAY "     Limeira,SP  Tel:(19)99886.3225"
@ 17,38 SAY "           presserv@gmail.com"
@ 18,38 SAY "          REPRODUÄéO PROIBIDA"
@ 19,38 SAY "            ƒƒÕÕÕ * * * ÕÕÕƒƒ"
@ 20,38 SAY "  Usuario:"
@ 20,49 SAY PADR(usuario,15)
@ 20,70 SAY LEFT(TIME(),5)
//POEHORA(20,70,5)
DISPEND()                         // mostra tela que esta no buffer
RETU

PROC AJMOUSE      // Rotina para ajuste da sensibilidade do mouse
#ifdef COM_MOUSE
 IF drvmouse                                  // sensibilidade do mouse
  tpo:=tecl:=li:=co := 1; V=drvratV; H=drvratH
  msg="Horizontal: "+CHR(27)+LPAD(STR(H),3)+" "+CHR(26)+;
      "|Vertical..: "+CHR(27)+LPAD(STR(V),3)+" "+CHR(26)+;
      "|(P)adrÑo - 'default`|"+gcr+" = Ok"
  DBOX(msg,,,,NAO_APAGA,"AJUSTA SENSIBILIDADE DO MOUSE")
  MOUSEBOX(0,0,MAXROW(),79)                   // define area de atuacao
  SETCOLOR(drvcorbox)
  SET CURSOR OFF                              // apaga o cursor do CA-Clipper e
  MOUSECUR(.t.)                               // acende o cursor do mouse
  DO WHIL tecl!=K_ESC .AND. tecl!=K_ENTER
   clic=MOUSEGET(@li,@co)                     // capta coordenadas atuais
   tecl=INKEY()                              // verifica algo digitado
   IF clic=1 .OR. tecl=80 .OR. tecl=112       // se clicado botao esquerdo ou 'P`
    press=(SECONDS()>tpo+1)                   // tempo maximo retido = 1s
    IF tpo=0 .OR. press                       // se 1o. click ou tempo esgotado
     IF (li=13 .AND. co>28 .AND. co<49) .OR.; // verifica local clicado
        tecl=80 .OR. tecl=112                 // e muda a sensibilidade
      H=8; V=16                               // horizontal e vertical
     ELSEIF li=11 .AND. co>40 .AND. co<44
      H=H-IF(H>1,1,0)
     ELSEIF li=11 .AND. co>45 .AND. co<49
      H=H+IF(H<900,1,0)
     ELSEIF li=12 .AND. co>40 .AND. co<44
      V=V-IF(V>1,1,0)
     ELSEIF li=12 .AND. co>45 .AND. co<49
      V=V+IF(V<900,1,0)
     ELSEIF li=14 .AND. co>35 .AND. co<43     // clicou OK
      tecl=K_ENTER
     ENDI
     MOUSERAT(H,V)                            // ajusta sensibilidade escolhida
     MOUSECUR(.f.)                            // esconde cursor do mouse e
     @ 11,43 SAY LPAD(STR(H),3)               // mostra valores horizontal
     @ 12,43 SAY LPAD(STR(V),3)               // e vertical
     MOUSECUR(.t.)                            // exibe novamente o cursor
     tpo=IF(tpo=0,SECONDS(),tpo)              // reinicializa tempo max retencao
    ENDI
   ELSEIF clic=2                              // pressionou botao direito,
    tecl=K_ESC                                // entao forca retorno
   ELSEIF tecl=K_F1                           // se teclou f1,
    HELP()                                    // apresenta ajuda
   ELSE                                       // ou entao,
    tpo=0                                     // zera tempo de retencao
   ENDI
  ENDD
  MOUSECUR(.f.)                               // apaga o cursor do mouse
  COLORSELECT(COR_PADRAO)
  SET CURSOR ON                               // acende o cursor do CA-Clipper
  IF tecl=K_ESC                               // se abandonou,
   MOUSERAT(drvratH,drvratV)                  //  retorna sensibilidade original
  ELSE                                        // senao,
   drvratH=H; drvratV=V                       //  prepara gravacao dos valores
  ENDI                                        //  de sensibilidade escolhidos
 ENDI
#endi
RETU

FUNC EMBARALHA(_lin)
LOCAL ret_val:="", i, j, x, k
x="17389280912340243"
k=0
FOR i=1 TO LEN(_lin)
 k++
 IF k>LEN(x)
  k=1
 ENDI
 j=ASC(SUBS(_lin,i,1))+VAL(SUBS(x,k,1))
 IF j>255
  j=j-255
 ENDI
 ret_val+=CHR(j)
NEXT
RETU ret_val

FUNC DESEMBARALHA(_lin)
LOCAL ret_val:="", i, j, x, k
x="17389280912340243"
k=0
FOR i=1 TO LEN(_lin)
 k++
 IF k>LEN(x)
  k=1
 ENDI
 j=ASC(SUBS(_lin,i,1))-VAL(SUBS(x,k,1))
 IF j<0
  j=255+j
 ENDI
 ret_val+=CHR(j)
NEXT
RETU ret_val

PROC BROWSE_REL(arq_, l_sup_, c_sup_,l_inf_, c_inf_,e_log)
LOCAL cur_atual, cor_atual
PRIV l_arq[l_inf_-l_sup_+1], maxlin_, area_, tablin_, fim_arq_, offset_ini,;
     offset_fim, lsup_:=l_sup_+1, csup_:=c_sup_+1,linf_:=l_inf_-1, t_w, t_r, ;
     cinf_:= c_inf_-1, cod_sos:=55, t_c, t_s, t_d, t_3, t_4, t_7, t_9, t_10
t_w:=SETKEY(K_CTRL_W,NIL); t_r:=SETKEY(K_CTRL_R,NIL) // desabilita teclas
t_c:=SETKEY(K_CTRL_C,NIL); t_s:=SETKEY(K_CTRL_S,NIL) // cursoras
t_d:=SETKEY(K_CTRL_D,NIL)
t_3:=SETKEY(K_F3,NIL);  t_4:=SETKEY(K_F4,NIL)        // desabilita teclas
t_7:=SETKEY(K_F7,NIL);  t_9:=SETKEY(K_F9,NIL)        // de funcoes
t_10:=SETKEY(K_F10,NIL)
e_log=IF(e_log=NIL,.f.,e_log)
IF AT(".",arq_)=0               // se o arquivo nao tiver extensao
 arq_+=".prn"                   // vamos forcar ".prn"
ENDI
IF (area_:=FOPEN(arq_))<0       // abre arquivo modulo binario
 ALERTA(2)                      // arquivo nao foi aberto...
 msg="NÑo foi possivel abrir o arquivo!"
 DBOX(msg,,,3,,"ATENCAO!")
 RETU
ENDI                            // moldura da janela
cor_atual=SETCOLOR(drvcortel)   // cor da janela do browse
cur_atual:=SETCURSOR(0)         // salva/apaga cursor
CAIXA(mold,l_sup_,c_sup_,l_inf_,c_inf_)

#ifdef COM_MOUSE
 msg=" "+CHR(174)+" "+CHR(175)+;// botoes do mouse
     " "+CHR(30)+" "+CHR(31)+;
     " "+CHR(24)+" "+CHR(26)+;
     " "+CHR(25)+" "+CHR(27)+" "
 posi_cur=c_inf_-c_sup_-17      // posicao onde eles comecam
 posi_cur=c_sup_+INT(posi_cur/2)
 IF drvmouse                    // se o mouse esta abilitado
  @ l_inf_,posi_cur SAY msg     // imprime msg no rodape da janela
 ENDI
#endi

maxlin_=linf_-lsup_+1           // qtde maxima de linhas da janela
AFILL(l_arq,"")                 // inicializa vetor das linhas mostradas
offset_ini:=offset_fim := 0     // inicializa ponteiros de inicio e
tablin_ = 1                     // da area mostrada
fim_arq_=FSEEK(area_,0,FS_END)  // tamanho do arquivo
FSEEK(area_,0)                  // volta para o topo do arquivo
MONTA_LIN(maxlin_,0,e_log)      // le/imprime as primeiras linhas
offset_ini=0                    // reinicializa offset de inicio
DO WHILE .t.

 #ifdef COM_MOUSE
  tecl_p=MOUSETECLA(l_inf_,posi_cur,;
                    l_inf_,posi_cur+16,; // aguarda com controle de mouse
                    .f.;
         )
 #else

  tecl_p=INKEY(0)              // espera tecla ser digitada

 #endi

 IF SETKEY(tecl_p)!=NIL         // executa funcao associada a
  EVAL(SETKEY(tecl_p))          // tecla digitada se existir
  tecl_p=0                      // nao faz mais nada depois
 ENDI
 DO CASE
  CASE tecl_p=K_ESC             // fim do browse no arquivo
   EXIT

  CASE tecl_p=K_DOWN            // seta para baixo
   MONTA_LIN(1,0,e_log)

  CASE tecl_p=K_UP              // seta para cima
   MONTA_LIN(-1,0,e_log)

  CASE tecl_p=K_CTRL_PGUP       // inicio do arquivo
   offset_ini:=offset_fim := 0
   AFILL(l_arq,"")
   MONTA_LIN(maxlin_,0,e_log)
   offset_ini=0

  CASE tecl_p=K_CTRL_PGDN       // fim do arquivo
   offset_ini:=offset_fim := fim_arq_
   AFILL(l_arq,CHR(0))
   @ l_sup_+1,c_sup_+1 CLEAR TO l_inf_-1,c_inf_-1
   MONTA_LIN(-1*(maxlin_),0,e_log)

  CASE tecl_p=K_RIGHT           // seta para direita
   MONTA_LIN(0,10,e_log)

  CASE tecl_p=K_LEFT            // seta para esquerda
   MONTA_LIN(0,-10,e_log)

  CASE tecl_p=K_PGDN            // pagina para baixo
   MONTA_LIN(maxlin_-1,0,e_log)

  CASE tecl_p=K_PGUP            // pagina cima/final do arquivo
   MONTA_LIN(-1*(maxlin_-1),0,e_log)

  CASE tecl_p=73.OR.tecl_p=105  // impressao do relatorio
   If !e_log
    MONTA_IMP(cur_atual,e_log)
   ENDI

 END CASE
ENDD
FCLOSE(area_)                   // fecha arquivo .prn
SETKEY(K_CTRL_W,t_w); SETKEY(K_CTRL_R,t_r) // habilita teclas
SETKEY(K_CTRL_C,t_c); SETKEY(K_CTRL_S,t_s) // cursoras
SETKEY(K_CTRL_D,t_d)
SETKEY(K_F3,t_3); SETKEY(K_F4,t_4)         // habilita teclas
SETKEY(K_F7,t_7); SETKEY(K_F9,t_9)         // de funcoes
SETKEY(K_F10,t_10)

SETCURSOR(cur_atual)            // restaura cursor
SETCOLOR(cor_atual)             // e a cor
RETU

STATIC PROC MONTA_LIN(qtlin_,qttab_,e_log)  // le/imprime linhas do arquivo binario
LOCAL t_, i_, x_, j_, lin_, buf_, tambuf_, ini_, fim_, qts_:=0,;
      tp_cmd:="pcomtcompc20tc20pelitelipenftenfpexptexppde8tde8landport"
IF qtlin_!=0                           // quer le outras linhas?
 tambuf_=MIN(ABS(qtlin_)*2700,32000)   // buffer maximo do tamnho das linhas
 IF qtlin_<0 .AND. offset_ini>1        // quer voltar linhas e nao esta no topo
  DO WHILE .t.
   IF offset_ini<tambuf_                // se o tamanho buffer e maior do que
    tambuf_=offset_ini                  // ja foi lido, ajusta seu tamanho
   ENDI
   FSEEK(area_,offset_ini-tambuf_)      // posiciona poteiro para a leitura
   buffer_=SPAC(tambuf_)                // inicializa o buffer e
   FREAD(area_,@buffer_,tambuf_)        // le o arquivo...
   IF e_log
    IF tambuf_=offset_ini
     EXIT
    ELSE
     i_ = AT(CHR(13)+CHR(10),buffer_)
     IF i_>0
      t_ = AT(CHR(13)+CHR(10),SUBS(buffer_,i_+2))
      IF t_>0
       EXIT
      ENDI
     ENDI
     tambuf_+=ABS(qtlin_)*270
    ENDI
   ELSE
    EXIT
   ENDI
  ENDD
  buffer_=STRTRAN(buffer_,CHR(12)+CHR(13),CHR(13)+CHR(10))
  tambuf_++                            // incrementa tamanho do buffer
  buf_=tambuf_                         // salva tamanho original
  FOR t_ = qtlin_ TO -1                // faz p/ todas as linhas requeridas
   IF tambuf_ > 1                      // se nao esta no inicio do buffer
    tambuf_-=3                         // tira o CR+LF do fim da linha
    i_=tambuf_                         // acha o ultimo CR+LF
    tambuf_=RAT(CHR(13)+CHR(10),SUBS(buffer_,1,tambuf_))
    tambuf_=IF(tambuf_>0,tambuf_+2,1)  // se achou desconta o CR+LF
    IF l_arq[maxlin_]!=CHR(0)          // se a linha a excluir for do arquivo
     offset_fim-=LEN(l_arq[maxlin_])+2 // decrementa seu tamanho do offset do
    ENDI                               // fim do arquivo (acresentando o CR+LF)
    AINS(l_arq,1)                      // insere um linha no top do arranjo
    i_=i_-tambuf_+1
    IF e_log                           // se for do log esta encriptada
     l_arq[1]=DESEMBARALHA(SUBS(buffer_,tambuf_,i_)) // inicializa a linha com a linha do arq
    ELSE
     l_arq[1]=SUBS(buffer_,tambuf_,i_) // inicializa a linha com a linha do arq
    ENDI
    qts_--                             // qtde de linhas do scroll
   ELSE                                // se chegou no inicio do tamanho do
    EXIT                               // buffer lido, cai fora...
   ENDI
  NEXT
  offset_ini-=buf_-tambuf_             // ajusta offset da linha inicio da janela

 ELSEIF l_arq[2]!=CHR(0)               // quer avancar linhas e nao esta no fim do arq
  FSEEK(area_,offset_fim)              // posiciona o ponteiro na ultima lin lida
  IF offset_fim+tambuf_>fim_arq_       // se o resto do arquivo e menor do que
   tambuf_=fim_arq_-offset_fim         // o tamanho do buffer, ajusta seu tamanho
  ENDI
  buffer_=SPAC(tambuf_)                // inicializa o buffer e
  FREAD(area_,@buffer_,tambuf_)        // le o arquivo...
  buffer_=STRTRAN(buffer_,CHR(12)+CHR(13),CHR(13)+CHR(10))
  FOR t_ = 1 TO qtlin_                 // mostra proximas linhas requeridas
   IF l_arq[1]!=CHR(0)                 // se for uma linha lida do arquivo
    offset_ini+=LEN(l_arq[1])+2        // ajusta offset do inicio
   ENDI
   ADEL(l_arq,1)                       // apaga a 1a. linha do arranjo
   qts_++                              // qtde de linhas que sera feita o scroll
   IF LEN(buffer_)<3                   // se nao tem mais linha para montar a tela
    l_arq[maxlin_]=CHR(0)              // inicializa linha com CHR(0) (flag)
    IF l_arq[2]=CHR(0)                 // se o fim do arq esta na 1a. linha
     EXIT                              // nao tem mais linha para mostrar
    ENDI
   ELSE                                // caso contrario pega linha corrente
    IF e_log                           // se for do log esta encriptada
     l_arq[maxlin_]=DESEMBARALHA(PARSE(@buffer_,CHR(13)+CHR(10)))
    ELSE
     l_arq[maxlin_]=PARSE(@buffer_,CHR(13)+CHR(10))
    ENDI
    offset_fim+=LEN(l_arq[maxlin_])+2  // ajusta offset do fim da janela
   ENDI
  NEXT
 ENDI
ENDI
i_=0
FOR t_ = 1 TO maxlin_                  // pega o tamanho da maior linha
 i_=MAX(i_,LEN(l_arq[t_]))
NEXT
IF (qttab_<0 .AND. tablin_>1) .OR.;    // quer rolar horizontalmente?
   (qttab_>0 .AND. tablin_<i_-10)
 tablin_+=qttab_                       // soma/diminui tabulacao atual
 qts_=maxlin_                          // forca remontagem de toda a janela
ENDI
IF qts_!=0                             // se leu alguma linha
 SCROLL(lsup_,csup_,linf_,cinf_,qts_)  // rola a tela
 ini_=IF(qts_>0,maxlin_-qts_+1,1)      // inicio e fim das linhas
 fim_=IF(qts_>0,maxlin_,ABS(qts_))     // que foram lidas
 i_=cinf_-csup_+1                      // tamanho da janela
 IF e_log                              // quer ver o log
  x=l_arq[1]                           // vamos colocar o cabeclho do dbf
  msg_cab=""
  db_=ALLTRIM(PARSE(@x,"Ø"))           // nome do dbf
  IF LEN(db_)>2                        // se tem dbf
   k=PARSE(@x,"Ø")                     // nome do usuario
   k=PARSE(@x,"Ø")                     // tipo da transacao
   op_i=EVAL(qualsis,db_)              // subscricao do vetor sistema
   msg_cab="ARQUIVO  Ø USUARIO         Ø TRANSACAO        DATA       HORA     "
   FOR j=1 TO LEN(sistema[op_i,O_CAMPO])
    k=PARSE(@x,"Ø")                    // campo
    msg_cab+="Ø "+PADR(sistema[op_i,O_CAMPO,j,O_TITU],LEN(k)-1)
   NEXT
  ENDI
  @ lsup_+-1,csup_ SAY PADR(SUBS(msg_cab,tablin_,i_),i_)
 ENDI
 FOR t_=ini_ TO fim_                   // imprime linhas lidas
  lin_=l_arq[t_]
  IF !EMPTY(lin_).AND.!OK_PRINT(lin_)  // tem caraceter de controle?
   IF AT(" "+CHR(8),lin_)>0            // tira efeito especial da frente da linha
    lin_=SUBS(lin_,AT(" "+CHR(8),lin_)+2)
   ENDI
   FOR j_=1 TO 56 STEP 4               // testa todos os carc de controle
    x_="drv"+SUBS(tp_cmd,j_,4)         // monta o nome do efeito
    x_=&x_.
    IF !EMPTY(x_)                      // tem efeito configurado?
     lin_=STRTRAN(lin_,TRANS(&x_.,""),"") // retira-o da linha
    ENDI
   NEXT
  ENDI
  @ lsup_+t_-1,csup_ SAY SUBS(lin_,tablin_,i_)
 NEXT
ENDI
buffer_=""
RETU

STATIC PROC MONTA_IMP(cur_atual,e_log)  // imprime arquivo
LOCAL pgini_, tp, g_off_ini, g_off_fim, qt_lido, buf_, ctpag_, lin_, t_
SAVE SCREEN                                // salva tela
SETCURSOR(cur_atual)                       // acende cursor
e_log=IF(e_log=NIL,.f.,e_log)
pgini_=DBOX("P†gina inicial:",1,45,,NAO_APAGA,"IMPRIME ARQUIVO",1,"99999")
SETCURSOR(0)                               // apaga cursor
IF pgini_>0
 porta=IMP_PORTA(drvporta,5,60,NAO_APAGA)  // escolhe para onde vai
 IF !EMPT(porta) .AND. LASTKEY()<>K_ESC
  IF PREPIMP()                             // pede para preparar impressora
   DBOX("AGUARDE!",,,,NAO_APAGA)           // mensagem ao usuaruio
   g_off_ini=offset_ini                    // salva ponteiros do arquivo
   g_off_fim=offset_fim
   SET ALTE TO (porta)                     // abre o dispositivo de impressao
   SET ALTE ON                             // liga gravacao
   SET CONS OFF                            // nao iremos exibir na tela
   FSEEK(area_,0)                          // inicio do arquivo
   qt_lido=200                             // qtde de bytes que vamos ler
   buf_=SPAC(200)                          // vamos ler os primeiros 200 bytes
   qt_lido=FREAD(area_,@buf_,200)          // para ver se tem efeito especial...
   IF LEN(buf_)>0                          // leu alguma coisa...
    IF AT(" "+CHR(8),buf_)>0               // se tem algum efetio vamos
     lin_=PARSE(buf_," "+CHR(8))           // extrai so o efeito e
     ? lin_                                // envia para a impressora
    ENDI
   ENDI
   FSEEK(area_,0)                          // inicio do arquivo
   qt_lido=10000                           // qtde de bytes que vamos ler
   buf_=""
   ctpag_=1                                // contador de pagina
   DO WHILE qt_lido=10000
    buffer_=SPAC(10000)                    // inicializa o buffer e le arquivo...
    qt_lido=FREAD(area_,@buffer_,10000)    // le o arquivo...
    buffer_=buf_+buffer_                   // soma o final do buffer anterior
    buf_=""                                // no buffer atual
    DO WHILE LEN(buffer_)>0                // imprime as linhas do buffer lido
     IF e_log                              // se for do log esta encriptada
      lin_=DESEMBARALHA(PARSE(@buffer_,CHR(13)+CHR(10))) // separa uma linha
     ELSE
      lin_=PARSE(@buffer_,CHR(13)+CHR(10))  // separa uma linha
     ENDI
     IF LEN(buffer_)>0 .OR. qt_lido<>10000 // se nao for a ultima do buffer
      IF ctpag_<pgini_                     // se esta pg nao podemos imprimir
       t_=AT(CHR(12)+CHR(13),lin_)         // verifica chr de salto de pg
       IF t_>0                             // tem?
        ctpag_++                           // soma no contador
        lin_=SUBS(lin_,t_+2)               // pega a linha de inicio da pg
       ENDI
      ENDI
      IF INKEY()=K_ESC                    // se quer cancelar
       IF canc()                           // pede confirmacao
        qt_lido=0                          // confirmou,
        EXIT                               // prepara para sair...
       ENDI
      ENDI
      IF ctpag_>=pgini_                    // se ja podemos imprimir
       ? lin_                              // grava no dispositivo de imprissao
      ENDI
     ELSE                                  // fimal do buffer a linha pode
      IF e_log                             // se for do log encriptada novamente
       buf_=EMBARALHA(lin_)                // estar incompleta, salva o resto
      ELSE
       buf_=lin_                           // estar incompleta, salva o resto
      ENDI
     ENDI
    ENDD
   ENDD
   SET ALTE OFF                            // desliga a gravacao
   SET ALTE TO                             // fecha dispositivo de impressao
   SET CONS ON                             // reabilita o video
   offset_ini=g_off_ini                    // restaura ponteiros do arquivo
   offset_fim=g_off_fim
  ENDI
 ENDI
ENDI
REST SCREEN                                // restabelece tela
RETU

PROC DOSCOM    // Executa comandos do DOS (shell)
LOCAL dos_t:=SAVESCREEN(0,0,MAXROW(),79), cor_atual:=SETCOLOR("W+/N"),;
      cur_sor:=SETCURSOR(3)
CLS
QOUT("Digite EXIT para retornar")
! command                         // carrega copia do command.com
MUDAFONTE(drvfonte)               // troca a fonte de caracteres
NAOPISCA()                        // habilita 256 cores (ega/vga)
RESTSCREEN(0,0,MAXROW(),79,dos_t) // restaura tela e
SETCOLOR(cor_atual)               // o esquema de cor
SETCURSOR(cur_sor)
RETU

PROC PARAMETROS(db_, cp_,fr_)  // Atualiza arquivo de parÉmetros da aplicaáÑo
LOCAL ar_:=SELECT(), i_
SELE 0

#ifdef COM_REDE
 USEARQ(db_,.f.,,,.f.)  // abre arquivo de parametro sem indice
#else
 USEARQ(db_)            // abre arquivo de parametro
#endi


/*
   se passou algum parametro entao atualiza o campo campo dentro do arquivo
   antes de inicializar sua variaveis
*/
IF cp_!=NIL .AND. fr_!=NIL

 #ifdef COM_REDE
  REPBLO(cp_,fr_)          // bloqueia e muda o campo
 #else
  REPL &cp_. WITH fr_
 #endi

ENDI

/*
   cria variaveis de memoria publicas identicas as de arquivo,
   para serem usadas por toda a aplicacao
*/
FOR i_=1 TO FCOU()
 msg=FIEL(i_)
 M->&msg.=&msg.
NEXT
USE                          // fecha arquivo de parametro e
SELE (ar_)                   // retorna para area anterior
RETU

PROC FILTRA(flg,ord)  // Monta seleáÑo de registros

/*
   Se flg=.t., cria indice temporario
   Se ord=.t., alem da filtragem, oferece ordenacao
*/
LOCAL m_campos, op_sis, getlist:={}, cn:=.f., filini:=.f., x_, k_, i_, cri_ant:=criterio, xx_
PRIV cod_sos:=12
cpsel:=criterio :="" ; selnum:=i :=0
op_sis=EVAL(qualsis,ALIAS())                     // subscricao do vetor sistema

/*
   enche m_campos com titulos dos campos (para menu)
*/
IF nivelop>=NIV_CRI_LIVRE                        // se usuario autorizado,
 m_campos="|* * CritÇrio livre * *"              //  pode fazer filtragem livre
ELSE                                             // senao,
 m_campos=""                                     //  nao vai ter esta opcao
ENDI
IF LEN(cri_ant)>0                                   // se tem filtro anterior
 m_campos+="|* * Filtro anterior * *"               // deixa concatenar filtro
ENDI
x_=ALIAS()                         // monta menu de campos com
xx_="|"                            // campos do arquivo pricipal
DO WHIL LEN(x_)>0                  // todas os arquivos relacionadas
 k_=PARSE(@x_,"|")                 // arquivo atual
 nc=EVAL(&("{||"+k_+"->(FCOU())}"))// numero de campos do arquivo
 FOR i=1 TO nc                     // monta menu de campos, exceto invisivel
  IF !("I"==sistema[EVAL(qualsis,k_),O_CAMPO,i,O_CRIT])
   m_campos+="|"+sistema[EVAL(qualsis,k_),O_CAMPO,i,O_TITU]
   IF k_==ALIAS()                  // e' o arquivo atual
    xx_+=UPPER(FIEL(i))+"|"
   ENDI
  ENDI
 NEXT
 IF brw .AND. k_==ALIAS()            // veio da EDITA() e e' arq atual
  nc=br_w:colcount                   // numero de colunas para escolher
  FOR i=1 TO nc                      // monta menu de campos
   cargox=br_w:getcolumn(i):cargo    //  desmembra coluna em:
   cp_=PARSE(@cargox,"≥")            //  nome do campo
   ms_=PARSE(@cargox,"≥")            //  mascara
   ti_=PARSE(@cargox,"≥")            //  titulo
   IF AT("|"+UPPER(cp_)+"|",xx_) = 0 // se nao for campo do arquivo atual
    m_campos+="|"+ti_                //  monta menu de campos
   ENDI
  NEXT
 ENDI
 i_=1                                  // pega nome dos arq relacionados
 DO WHIL LEN(&k_.->(DBRELATION(i_)))>0 // ao arq principal
  IF LEN(x_)>0
   x_+="|"
  ENDI
  x_+=&k_.->(ALIAS(DBRSELECT(i_)))     // nome do arq relacionado
  i_++                                 // proximo relacionamento
 ENDD
ENDD
m_campos=SUBS(m_campos,2)                        // despreza 1a. barra
op_6=1
m_criterio=""
DO WHIL selnum<10 .AND. cpsel!=SPAC(10)          // permite escolher somente 10 criterios
 selnum++                                        // contador de criterios
 IF selnum>1                                     // ja foi feito pelo menos um criterio
  m_tit="FILTRAGEM|OPERADORES L¢GICOS|*"+m_criterio
  op_2=DBOX("* Ok! *|E|OU",,,E_MENU,,m_tit)      // recebe operadores
  IF op_2=0                                      // cancelou
   criterio=""; cn=.t.                           // limpa criterio existente
   EXIT                                          // e retorna
  ENDI
  IF op_2=1                                      // criterio montado ok
   cpsel=SPAC(10)                                // prepara para sair
   LOOP
  ELSE
   op_2=TRIM(SUBS(".AND..OR. ",(op_2-1)*5-4,5))  // operador escolhido
   IF AT(".AND.",criterio)>0 .OR. AT(".OR.",criterio)>0
    criterio="("+criterio+")"                    // coloca parenteses
   ENDI
   criterio+=op_2                                // junta operador ao criterio
   m_criterio+="|"+op_2                          // monta titulo para proxima dbox()
  ENDI
 ENDI
 cpsel=SPAC(10) ; messaux=criterio
 m_tit="FILTRAGEM|CAMPOS DO ARQUIVO|*"+m_criterio
 op_1=DBOX(m_campos,,,E_MENU,,m_tit)             // escolhe campo para filtrar
 IF op_1=0                                       // cancelou
  criterio=""; cn=.t.                            // limpa criterio existente
  EXIT                                           // e retorna
 ENDI
 IF nivelop>=NIV_CRI_LIVRE                       // usuario pode fazer criterio livre
  IF op_1=1                                      // foi selecionado
   selnum=0 ; clivre=.t.
   EXIT
  ENDI
  op_1--                                         // com criterio livre, ha' mais um item
 ENDI                                            // no menu, portanto, ajusta op_1 para
 IF LEN(cri_ant)>0                               // se tem filtro anterior
  IF op_1=1                                      // e ele foi selecionado
   criterio+=cri_ant                             // monta o criterio final
   cpsel="Filtro anterior"                       // monta msg para dbox()
   m_criterio+="|"+cpsel
   LOOP
  ENDI
  op_1--                                         // com criterio livre, ha' mais um item
 ENDI
 ii=0
 cpsel=""                                       // inicializa campo esolhido
 x_=ALIAS()                                     // arquivo principal
 DO WHIL LEN(x_)>0                              // corre todas os arquivos
  k_=PARSE(@x_,"|")                             // para pegar campo escolhido
  nc = EVAL(&("{||"+k_+"->(FCOU())}"))          // numero de campos do arquivo
  FOR i=1 TO nc                                 // desprezando campo invisieis
   IF !("I"==sistema[EVAL(qualsis,k_),O_CAMPO,i,O_CRIT])
    ii++
   ENDI
   IF ii=op_1                                   // campo escolhido?
    IF k_==ALIAS()                              // se for o arq principal nao coloca alias()
     cpsel=FIEL(i)
    ELSE                                        // arq relacionado coloca o alias()
     cpsel=k_+"->"+&k_.->(FIEL(i))
    ENDI
    selpic=sistema[EVAL(qualsis,k_),O_CAMPO,i,O_MASC] // mascara do cp escolhido
    EXIT
   ENDI
  NEXT
  IF LEN(cpsel)>0                               // se ja achou o cp
   EXIT                                         // cai fora...
  ENDI
  IF brw                               // veio da EDITA
   IF k_==ALIAS()                      // e' o arquivo atual
    nc=br_w:colcount                   // numero de colunas para escolher
    FOR i=1 TO nc                      // monta menu de campos
     cargox=br_w:getcolumn(i):cargo    //  desmembra coluna em:
     cp_=PARSE(@cargox,"≥")            //  nome do campo
     ms_=PARSE(@cargox,"≥")            //  mascara
     IF AT("|"+UPPER(cp_)+"|",xx_) = 0 // se nao for campo do arquivo atual
      ii++                             // proxima opcao da dbox
     ENDI
     IF ii=op_1                        // coluna escolhida?
      cpsel=cp_                        // conteudo da coluna
      selpic=ms_                       // mascara da coluna
      IF LEFT(cpsel,5)="TRAN("         // vamos tirar a mascara
       i=RAT(",["+selpic+"])",cpsel)   // do conteudo para sabermos
       IF i>0                          // o tipo exato do dado da coluna
        cpsel=SUBSTR(cpsel,6,i-6)
       ENDI
      ENDI
      EXIT                             // cai fora...
     ENDI
    NEXT
    IF LEN(cpsel)>0                    // se ja achou o cp
     EXIT                              // cai fora...
    ENDI
   ENDI
  ENDI
  i_=1
  DO WHIL LEN(&k_.->(DBRELATION(i_)))>0         // pega todas as relacoes
   IF LEN(x_)>0                                 // deste arquivo
    x_+="|"
   ENDI
   x_+=&k_.->(ALIAS(DBRSELECT(i_)))             // nome do arq relacionado
   i_++                                         // nome da relacao
  ENDD
 ENDD
 tp_cp=VALTYPE(&cpsel.)                          // tipo do campo?
 m_tit="FILTRAGEM|OPERADORES RELACIONAIS|*"+;
       m_criterio+"|"+TRIM(cpsel)
 m_relac="=  Igual a      ˇ|"+;
         "#  Diferente de ˇ|"
 IF tp_cp!="L"                                   // logico so '= ou #`
  m_relac=m_relac+"<  Menor que    ˇ|"+;
                  "<= Menor ou igual|"+;
                  ">  Maior que    ˇ|"+;
                  ">= Maior ou igual"
 ENDI
 IF AT(tp_cp,"CM")>0                             // se tipo caracter ou memo tem $ (contem)
  m_relac=m_relac+"|$  ContÇm       ˇ|!$ NÑo contÇm   ˇ"
 ENDI
 op_6=DBOX(m_relac,,,E_MENU,,m_tit)              // pega operando
 IF op_6=0                                       // cancelou com ESC
  criterio=""; cn=.t.                            // limpa criterio existente
  EXIT                                           // e retorna
 ENDI
 op_s=TRIM(SUBS("= # < <=> >=$ $ ",op_6*2-1,2))  // inicializa seg oper=tipo do campo
 IF tp_cp="D"
  oper_2=CTOD("")
 ELSEIF tp_cp="N"
  oper_2=0
 ELSEIF tp_cp="M"
  oper_2=SPAC(40)
 ELSE
  i=LEN(&cpsel.)
  oper_2=SPAC(i)
  IF i>50
   selpic="@S40"+selpic
  ENDI
 ENDI
 m_tit="FILTRAGEM: SEGUNDO OPERANDO|*"+m_criterio+"|"+TRIM(cpsel)+op_s
 oper_2=DBOX("Segundo operando (nÑo use aspas):",,,,,m_tit,oper_2,selpic)
 IF LASTKEY()=K_ESC                              // cancelou
  selnum=0                                       // zera numero de criterios,
  criterio=""; cn=.t.                            // e o criterio parcialmente definido
  EXIT                                           // para retornar
 ENDI
 IF tp_cp="D"
  oper_2="CTOD(["+DTOC(oper_2)+"])"
 ELSEIF tp_cp="N"
  oper_2=LTRIM(TRAN(oper_2,""))
 ELSE
  IF EMPT(oper_2)
   oper_2="'"+oper_2+"'"
  ELSE
   oper_2="'"+TRIM(oper_2)+"'"
  ENDI
 ENDI
 IF op_6>6
  IF op_6=8                                      // operador "nao contem" (!$)
   cpsel="!("+oper_2+PADC(op_s,3)+;
         TRIM(cpsel)+")"
  ELSE
   cpsel=oper_2+PADC(op_s,3)+TRIM(cpsel)         // operador "contem" ($)
  ENDI
 ELSE
  cpsel=TRIM(cpsel)+op_s+oper_2                  // outros operadores
 ENDI
 criterio+=cpsel                                 // monta o criterio
 m_criterio+="|"+cpsel                           // monta msg para dbox()
ENDD
IF selnum>0 .AND. !cn                            // ha criterio feito
 IF flg                                          // vamos criar indice temporario
  IF ord!=NIL                                    // e possivelmente, ordenar
   ALERTA()
   cod_sos=21
   msg="Ordenar o arquivo|Prosseguir operaáÑo"   // ve se usuario quer ordenar
   op_=DBOX(msg,,,E_MENU,,"CLASSIFICAÄéO DO ARQUIVO")
   IF op_=1                                      // sim! quer...
    cpord=""
    CLASS(.f.)                                   // entao, ordena
   ENDI
  ENDI
  FILTROINI(@filini)                             // concatena filtro inicial
  INDTMP()                                       // cria indice temporario
 ENDI
ELSEIF !cn
 IF clivre                                       // monta criterio livre
  criterio=SPAC(210)
  msg="A EXPRESSéO ABAIXO DEVERè ESTAR DE ACORDO COM|"+;
      "A SINTAXE DA LINGUAGEM PARA EVITAR ERRO DE PROCESSAMENTO|*|"+;
      "F10=CAMPOS DO ARQUIVO|*|INFORME A EXPRESSéO FILTRO:"
  DO WHILE .t.
   SET KEY K_F10 TO ve_campos                    // F10 monta menu de campos
   criterio=DBOX(msg,,,,,SEPLETRA("* FILTRAGEM LIVRE *",1),criterio,"@S50")
   SET KEY K_F10 TO
   IF LASTKEY()=K_ESC                            // cancelou
    criterio=""; cn=.t.
    EXIT
   ENDI
   tp_crit=TYPE(criterio)                        // se a expressao=indeterminada
   IF tp_crit="UI"                               // existe funcao fora da clipper.lib na
    tp_crit=VALTYPE(&criterio.)                  // expressao, logo avalia o seu
   ENDI                                          // conteudo
   IF tp_crit="L"                                // se o tipo da expressao for
    EXIT                                         // logico, entao segue em frente
   ENDI
   ALERTA(3)
   DBOX("EXPRESSéO ILEGAL",15)
  ENDD
  IF !cn
   criterio=ALLTRIM(criterio)                    // tira brancos da expressao
   IF !EMPT(criterio) .AND. flg                  // vai criar indice temporario
    IF ord!=NIL                                  // e ordenar o arquivo se quiser
     CLASS(.f.)
    ENDI
    FILTROINI(@filini)                           // concatena filtro inicial
    INDTMP()                                     // cria indice temporario
   ENDI
  ENDI
 ENDI
ENDI
IF flg .AND. EMPT(criterio) .AND.;               // se tirou o filtro
   INDEXKEY(0)="LTOC("                           // mas antes tinha
 FILTROINI(@filini)                              // concatena filtro inicial
 INDTMP()                                        // indexa o dbf novamente
ENDI
FILTROINI(@filini)                               // concatena filtro inicial
RETU

PROC FILTROINI(filini)    //concatena filtro inicial
IF brw .AND. filini=.f.   //se veio da funcao EDITA() e nao concatenou ainda...
 IF LEN(cr_ini)>0         //se existir filtro inicial, coloca
  criterio=cr_ini+IF(LEN(criterio)>0," .AND. ("+criterio+")","")
 ENDI
ENDI
filini=.t.                //flag: filtro ja' colocado
RETU

PROC VEOUTROS    // Abre opáÑo de consulta a outros arquivos
LOCAL op_a:=0, chvpesq, opm:=ARRAY(nss), db, tp, t_w, t_r, t_c, t_7, t_9,;
      v_:=SAVESCREEN(0,0,MAXROW(),79), reg_dbf:={}
PRIV cod_sos:=23, v_ar:=READVAR()
t_w:=SETKEY(K_CTRL_W,NIL)                        // desabilita e salva
t_r:=SETKEY(K_CTRL_R,NIL)                        // as teclas de controle
t_c:=SETKEY(K_CTRL_C,NIL)
t_7:=SETKEY(K_F7,NIL); t_9:=SETKEY(K_F9,NIL)
reg_dbf=POINTER_DBF()                            // salva situacao de todos dbf's
msg:=db := ""
FOR i=1 TO nss-3                                 // monta menu
 IF LEN(sistema[i,O_CPRELA])=0 .AND.;
    sistema[i,O_OUTROS,O_NIVEL]<=nivelop .AND.;
    LEN(sistema[i,O_INDIC])>0
  msg+="|"+sistema[i,O_MENU]                     // de nomes de arquivos
  db+=RIGHT(STR(1000+i),3)
 ENDI
NEXT
IF LEN(msg)>1
 op_a=DBOX(SUBS(msg,2),,3,E_MENU,,"BASE DE DADOS")// qual arquivo?
ENDI
IF op_a>0                                        // selecionado um...
 op_a=VAL(SUBS(db,op_a*3-2,3))
 db=sistema[op_a,O_ARQUI,O_NOME]                 // nome do arquivo (sem dir)
 tem_t=.f.
 IF !EMPTY(v_ar)                                 // alguma variavel pendente?
  IF  VALTYPE(&v_ar.) $ "CNDL"                   // se for caracter, numerica, data
   tem_t=!("OP_" $ UPPER(v_ar))                  // ou logica e nao for de menu,
   v_ar=TRANSCAMPO(.t.,v_ar)                     // pode transferir campos
  ENDI                                           // para o get pendente
 ENDI
 PTAB(IF(tem_t,v_ar,"^%"),db)                    // abre arquivo e tenta posicionar
                                                 // com conteudo do get pendente
 #ifdef COM_REDE
  IF NETERR()                                    // se deu erro de abertura,
   RETU                                          // retorna
  ENDI
 #endi

 SELE &db.                                       // seleciona o arquivo escolhido
 IF EOF()                                        // se fim de arquivo,
  GO TOP                                         // vai para o 1o. registro
 ENDI
 v_out=.t.
 cod_sos=8
 EDITA(09,10,MAXROW()-3,70)                      // consulta e faz projecoes
 v_out=.f.
ENDI
POINTER_DBF(reg_dbf)                             // restaura ponteiro dos dbf's
SETKEY(K_CTRL_W,t_w)                             // restaura teclas de controle
SETKEY(K_CTRL_R,t_r)
SETKEY(K_CTRL_C,t_c)
SETKEY(K_F7,t_7); SETKEY(K_F9,t_9)
RESTSCREEN(0,0,MAXROW(),79,v_)                   // restaura tela
RETU

PROC VE_CAMPOS   // Abre janela com nomes de campos
LOCAL ve_op:="", t_f10:=SETKEY(K_F10,NIL), ii                // evita recursividade
PRIV cod_sos:=26
FOR i=1 TO FCOU()                                            // monta menu com nomes e titulos
 IF !("I"==sistema[EVAL(qualsis,ALIAS()),O_CAMPO,i,O_CRIT])  //  exceto campos invisiveis
  ve_op+="|"+sistema[EVAL(qualsis,ALIAS()),O_CAMPO,i,O_TITU]+" ("+FIEL(i)+")"
 ENDI
NEXT
op_campo=DBOX(SUBS(ve_op,2),,50,E_MENU,,"CAMPOS DO ARQUIVO") // apresentar menu de campos
IF op_campo>0                                                // escolheu um campo
 ii=0
 FOR i=1 TO FCOU()                                           // sincriniza opcao escolhida
  IF !("I"==sistema[EVAL(qualsis,ALIAS()),O_CAMPO,i,O_CRIT]) // com o campo equivalente
   ii++
  ENDI
  IF ii=op_campo                                             // e este o campo
   KEYB ALLTRIM(FIEL(i))                                     // coloca no buffer do teclado
   EXIT                                                      // seu nome (nome em arquivo)
  ENDI
 NEXT
ENDI
SETKEY(K_F10,t_f10)                                          // reabilita F10
RETU

PROC INDTMP    // Cr°a °ndices tempor†rios
LOCAL op_sis, ind_ok, ind_an, arqtmp, cur_atual:=SETCURSOR(0), chv_, p_ , x_, ind01, ind02, ind03, ind04, ind05, ind06, ind07, ind08
op_sis=EVAL(qualsis,ALIAS())                   // subscricao do vetor sistema

/*
   se pediu ordenacao e nao e' indice de pesquisa ou ha filtragem,
   cria novo arquivo indice
*/

IF LEN(cpord)>1 .OR. !EMPT(criterio) .OR.;     // se tem ordenacao ou filtro
   INDEXORD()>LEN(sistema[op_sis,O_CHAVE])     // ou esta usando indice temporario
// arqtmp=drvntx+LEFT(ALIAS(),3)+ide_maq+EXTENSAO()                     // nome arquivo ntx temporario
arqtmp=LEFT(ALIAS(),3)+ide_maq   // nome TAG temporario

 ind_ok=0
 nord:=juncao_ := ""
 IF !EMPT(criterio)                            // tem filtro?
  nord="LTOC("+criterio+")"; juncao_="+"       // indexa pela condicao
 ENDI
 IF !EMPT(chv_rela)                            // a janela esta relacionada?
  chv_=INDEXKEY(0)                          // chave do indice atual
  IF chv_="LTOC("                              // se existir filtro na chave
   chv_=SUBS(chv_,6); x_=1                     // vamos tirar a sua expressao
   DO WHILE x_!=0                              // ltoc(...)+...
    p_=LEFT(chv_,1)
    x_=x_+IF(p_=")",-1,IF(p_="(",1,0))
    chv_=SUBS(chv_,2)
   ENDD
   chv_=SUBS(chv_,2)                           // retira o "+" da frente
  END IF
  p_=CONTA("+",chv_rela)+1                     // quantidade de campos da relacao
  DO WHILE p_-->0                              // extrai os campos do indice
   nord+=juncao_+PARSE(@chv_,"+"); juncao_="+" // monta expressao do indice
  ENDD
 ENDI
 IF LEN(cpord)>1                               // se escolheu outra ordenacao
  nord+=juncao_+cpord                          // vamos usa-la
 ELSEIF LEN(INDEXKEY(0))=0
  nord+=juncao_+UPPE(INDEXKEY(1))              // concatena com o indice basico
 ELSE
  nord+=juncao_+UPPE(INDEXKEY(0))              // concatena com o indice basico
 ENDI
 qt_ind=LEN(sistema[op_sis,O_INDIC])
 FOR t=1 TO qt_ind                             // ordem escolhida e' igual
  IF UPPE(INDEXKEY(t))=UPPE(nord)              // a algum indice de pesquisa?
   ind_ok=t                                    // sim! vamos usa'-lo
   EXIT
  ENDI
 NEXT
 IF ind_ok=0
  ind_t=SAVESCREEN(0,0,MAXROW(),79)            // sava tela e da msg
  ind_ok=qt_ind+1                           // ordem do indice a usar
  POE_GAUGE("Criando °ndice tempor†rio")
  INDE ON &nord. TAG (arqtmp) EVAL odometer() EVERY 50 ADDITIVE MEMORY // indexando... VERIFICAR
  RESTSCREEN(0,0,MAXROW(),79,ind_t)
  ind01=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,1]
/*
  ind01=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,1]
  IF qt_ind=1
   SET INDE TO (ind01), (arqtmp)
  ELSE
   ind02=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,2]
   IF qt_ind=2
    SET INDE TO (ind01), (ind02), (arqtmp)
   ELSE
    ind03=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,3]
    IF qt_ind=3
     SET INDE TO (ind01), (ind02), (ind03), (arqtmp)
    ELSE
     ind04=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,4]
     IF qt_ind=4
      SET INDE TO (ind01), (ind02), (ind03), (ind04), (arqtmp)
     ELSE
      ind05=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,5]
      IF qt_ind=5
       SET INDE TO (ind01), (ind02), (ind03), (ind04), (ind05), (arqtmp)
      ELSE
       ind06=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,6]
       IF qt_ind=6
        SET INDE TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (arqtmp)
       ELSE
        ind07=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,7]
        IF qt_ind=7
         SET INDE TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (ind07), (arqtmp)
        ELSE
         ind08=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,8]
         IF qt_ind=8
          SET INDE TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (ind07), (ind08), (arqtmp)
         ENDI
        ENDI
       ENDI
      ENDI
     ENDI
    ENDI
   ENDI
  ENDI
*/
 ENDI
 DBSETORDER(ind_ok)                            // usa a ordem apropriada
 REGINICIO()                                   // verifica se reg esta' no filtro
ENDI
SETCURSOR(cur_atual)                           // retorna o cursor ao normal
RETU

PROC REP  // Liga/desliga repetiáÑo de registro
IF op_menu=INCLUSAO .AND. !EMPT(READVAR())
 fgrep=!fgrep
 im_aj_at_=1            // var usada dentro da GETSYS para
ENDI                    // imprimir informacoes no rodape'
RETU

PROC CONF  // Liga/desliga confirmaáÑo em campos
IF op_menu=INCLUSAO .AND. !EMPT(READVAR())
 drvconf=!drvconf
 SET CONF (drvconf)     // ajusta SET CONFIRM
 im_aj_at_=1            // var usada dentro da GETSYS para
ENDI                    // imprimir informacoes no rodape'
RETU

PROC CLASS(conf_ord_)  //  Pega seqÅància de campos para ordenar arquivo
LOCAL menucp:="", op_sis, clivre:=.f., msg, cpord_antes:=cpord,;
      qt_ind, op_ord:=0, tela_class:=SAVESCREEN(0,0,MAXROW(),79), x_, k_, i_
PRIV cod_sos:=14
op_sis=EVAL(qualsis,ALIAS())               // qual subsistema?
qt_ind=LEN(sistema[op_sis,O_CHAVE])        // qde de indices do arquivo
IF ATAIL(sistema[op_sis,O_CHAVE])="codlan" // ve se ultima chaves e' de relacionamento
 qt_ind--                                  // se for, nao pode ser escolhido
ENDI
IF qt_ind>1                                // se mais de um indice,
 msg=""                                    // escolhe por menu o conjunto
 FOR t=1 to qt_ind                         // de indice desejado para a
  msg+="|"+sistema[op_sis,O_CONSU,t]       // nova ordenacao
 NEXT
 msg+="|* OUTRA ORDEM *"                   // ou deixa escolher qualquer campo
 op_ord=DBOX(SUBS(msg,2),,,E_MENU,,"SELECIONE A ORDENAÄéO")
 DO CASE
  CASE op_ord=0                            // quer abandonar...
   op_ord=1

  CASE op_ord=qt_ind+1                     // quer escolher qualquer campo
   op_ord=0

  OTHERWISE                                // escolheu um indice...
   cpord+=IF(LEN(cpord)>1,"+","")+;        // comcatena o indice com a
          sistema[op_sis,O_CHAVE,op_ord]   // ordenacao pre-definida
 ENDC
ENDI
IF op_ord=0                           // quer definir uma ordenacao...
 msg=IF(EMPTY(cpord),"","*"+cpord)
 IF nivelop>=NIV_CRI_LIVRE            // verifica se usuario autorizado a fazer
  menucp="|* * OrdenaáÑo livre * *"   // ordenacao livre
 ENDI
 IF brw                              // veio da EDITA()
  nc=br_w:colcount                   // numero de campos para escolher
  FOR i=1 TO nc                      // monta menu de campos
   cargox=br_w:getcolumn(i):cargo    //  desmembra coluna em:
   cp_=PARSE(@cargox,"≥")            //  nome do campo
   ms_=PARSE(@cargox,"≥")            //  mascara
   ti_=PARSE(@cargox,"≥")            //  titulo
   menucp+="|"+ti_                   //  monta menu de campos
  NEXT
 ELSE                                // ordenacao do relat¢rio
  x_=ALIAS()                         // monta menu de campos com
  DO WHIL LEN(x_)>0                  // todas os arquivos relacionadas
   k_=PARSE(@x_,"|")                 // arquivo atual
   nc=EVAL(&("{||"+k_+"->(FCOU())}"))// numero de campos do arquivo
   FOR i=1 TO nc                     // monta menu de campos, exceto invisivel
    IF !("I"==sistema[EVAL(qualsis,k_),O_CAMPO,i,O_CRIT])
     menucp+="|"+sistema[EVAL(qualsis,k_),O_CAMPO,i,O_TITU]
    ENDI
   NEXT
   i_=1                                  // pega nome dos arq relacionados
   DO WHIL LEN(&k_.->(DBRELATION(i_)))>0 // ao arq principal
    IF LEN(x_)>0
     x_+="|"
    ENDI
    x_+=&k_.->(ALIAS(DBRSELECT(i_)))     // nome do arq relacionado
    i_++                                 // proximo relacionamento
   ENDD
  ENDD
 ENDI
ENDI
DO WHIL op_ord=0
 IF LEN(msg)>0                        // mostra campos escolhidos
  op_0=DBOX(SUBS(msg,2),,50,,NAO_APAGA,"ORDENAÄéO")
 ENDI
 op_0=DBOX(SUBS(menucp,2),,6,E_MENU,,"CAMPOS PARA ORDENAR|O ARQUIVO")
 IF op_0!=0                           // escolheu um campo
  op_1=op_0
  IF nivelop>=NIV_CRI_LIVRE           // se tem autorizacao para ordenacao
   IF op_1=1                          // livre, entao faz...
    clivre=.t.
    EXIT
   ENDI
   op_1--                             // faz op_1 a subscricao do campo ou coluna
  ENDI
  IF brw                              // se chamado da EDITA()
   cargox=br_w:getcolumn(op_1):cargo  // desmembra coluna em campo, mascara e titulo
   cp_=PARSE(@cargox,"≥")
   ms_=PARSE(@cargox,"≥")
   ti_=PARSE(@cargox,"≥")
  ELSE
   ii=0
   cp_=""                             // inicializa campo escolhido
   x_=ALIAS()                         // acha campo escolhido
   DO WHIL LEN(x_)>0                  // considerando todas os arquivos relacionados
    k_=PARSE(@x_,"|")                 // arquivo atual
    nc=EVAL(&("{||"+k_+"->(FCOU())}"))// numero de campos do arquivo
    FOR i=1 TO nc                     // monta menu de campos, exceto invisivel
     IF !("I"==sistema[EVAL(qualsis,k_),O_CAMPO,i,O_CRIT])
      ii++
     ENDI
     IF ii=op_1                       // campo escolhido?
      IF k_==ALIAS()
       cp_=&k_.->(FIEL(i))
      ELSE
       cp_=k_+"->"+&k_.->(FIEL(i))
      ENDI
      ti_=sistema[EVAL(qualsis,k_),O_CAMPO,i,O_TITU]
      EXIT
     ENDI
    NEXT
    IF LEN(cp_)>0
     EXIT
    ENDI
    i_=1                                  // pega nome dos arq relacionados
    DO WHIL LEN(&k_.->(DBRELATION(i_)))>0 // ao arq principal
     IF LEN(x_)>0
      x_+="|"
     ENDI
     x_+=&k_.->(ALIAS(DBRSELECT(i_)))     // nome do arq relacionado
     i_++                                 // proximo relacionamento
    ENDD
   ENDD
  ENDI
  IF TYPE(cp_) $ "MLU"                     // se tipo MEMO, LOGICO ou INDEFINIDO...
   ALERTA(3)                               // ... nao da' para usar
   DBOX("Campo "+MAIUSC(ti_)+" nÑo|pode ser usado para ordenaáÑo",,,,,"ATENÄéO!")
   LOOP
  ENDI
  cp_=TRANSCAMPO(.f.,cp_)                  // transforma paara caracter
  msgt="ESCOLHA O SENTIDO DA ORDENAÄéO|DO CAMPO "+MAIUSC(ti_)
  op=DBOX("Crescente|Decrescente",,,E_MENU,,msgt)
  msg +="|"+ti_
  IF op=2                                  // pediu ordem decrescente
   cp_="DESCEND("+cp_+")"
   msg+=" (Decrescente)"
  ENDI
  cpord+=IF(LEN(cpord)>1,"+","")+cp_       // concatena campos escolhidos
 ELSE
  EXIT
 ENDI
ENDD
IF clivre                                  // vai fazer ordenacao livre
 cpord=SPAC(210)
 msg="A EXPRESSéO ABAIXO DEVERè ESTAR DE ACORDO COM|"+;
     "A SINTAXE DA LINGUAGEM PARA EVITAR ERRO DE PROCESSAMENTO|*|"+;
     "F10=CAMPOS DO ARQUIVO|*|INFORME A EXPRESSéO PARA ORDENAÄéO"
 DO WHILE .T.
  SET KEY K_F10 TO ve_campos               // habilita F10 para ver campos DBF
  cpord=DBOX(msg,,,,,SEPLETRA("* ORDENAÄéO  LIVRE *",1),cpord,"@S50")
  SET KEY K_F10 TO                         // desabilita F10
  IF LASTKEY()=K_ESC
   cpord=""                                // cancelou...
   EXIT
  ENDI
  tp_crit=TYPE(cpord)
  IF tp_crit="UI"                          // se expressao=indeterminado
   tp_crit=VALTYPE(&cpord.)                // existe funcao fora da clipper.lib
  ENDI                                     // entao avalia o conteudo da expressao
  IF tp_crit $ "CND"                       // so ordena tipos caracter/numerico/data
   IF tp_crit="N"                          // transf p/ caracter ordem tp numerica
    cpord="STR("+ALLTRIM(cpord)+")"
   ELSEIF tp_crit="D"                      // transf p/ caracter ordem tp data
    cpord="DTOS("+ALLTRIM(cpord)+")"
   ENDI
   EXIT                                    // vamos retornar, ordenacao ajustada
  ENDI
  ALERTA(3)                                // ordenacao livre invalida
  DBOX("EXPRESSéO ILEGAL",15)              // vamos avisar...
 ENDD
 cpord=ALLTRIM(cpord)                      // tira brancos da expressao
ENDI
RESTSCREEN(0,0,MAXROW(),79,tela_class)     // restaura tela original
IF !EMPTY(cpord) .AND. conf_ord_ .AND.;    // mudou a ordenacao e quer
   cpord_antes!=cpord                      // que confirma a ordenacao?
 IF op_ord=0                               // se nao escolheu um ja existente
  ALERTA(1)                                // beep! e
  msg="Prosseguir|Cancelar"                // ve se usuario quer ordenar
  msgt="ORDENAÄéO DO ARQUIVO"              // realmente o arquivo
  cod_sos=1
  ii=DBOX(msg,,,E_MENU,,msgt)
  IF ii!=1                                 // se desistiu,
   cpord=cpord_antes                       //  volta ordenacao anterior
  ELSE                                     // senao,
   INDTMP()                                //  cria indice temporario
  ENDI
 ELSE
  INDTMP()                                 // seleciona indice escolhido
 ENDI
ENDI
RETU

PROC CAPTURAARQ()  // captura arquivo da lista
LSTARQDIR(.t.)
RETU

PROC CAPTURADIR()  // captura diretorio da lista
LSTARQDIR(.f.)
RETU

PROC ESCOLHIDOUM()
_Escolheu=.t.
KEYB CHR(K_ENTER)
RETU

PROC LSTARQDIR(_comarq)
LOCAL t, op_a, dir_arq:={}, dir_, qt_dir, dir_base, v_ar:=READVAR(),;
      t_f10:=SETKEY(K_F10,NIL), msgt:=""     // evita recursividade
PRIVATE _Escolheu
IF !EMPTY(v_ar)                              // alguma variavel pendente?
 dir_base=ALLTRIM(&v_ar.)                    // pega dir default dela
ENDI
IF EMPTY(dir_base)                           // se nao pegou diretorio da var
 dir_base=drvdbf                             // o default sera o dos dbf's
ENDI
IF RIGHT(dir_base,1)<>"\"                    // se dirtorio nao terninar com \
 dir_base=dir_base+"\"                       // vamos colocar
ENDI
IF !criadrv(dir_base)                        // verifica/cria diretorio
 SETKEY(K_F10,t_f10)                         // cancelou... reabilita F10
 RETU                                        // e cai fora
ENDI
DO WHILE .t.
 _Escolheu=.f.
 IF _comarq
  dir_arq=DIRECTORY(dir_base+mask_)          // lst de arquivo desejados
  msgt=mask_
 ELSE
  dir_arq:={}
  msgt="|F10=Escolhe"
 ENDI
 dir_=DIRECTORY(dir_base+"*.*","D")          // lst de todos arq + diretorios
 qt_dir=1
 FOR t=1 TO LEN(dir_)                        // verifica quais dos arquivos
  IF dir_[t,5]="D" .AND. "."!=dir_[t,1]      // e' um diretorio e o
   AADD(dir_arq,{})                          // adiciona mais um na lst
   AINS(dir_arq,qt_dir)                      // insere na posicao certa
   ACOPY(dir_,dir_arq,t,1,qt_dir)            // copia todos os atributos
   qt_dir++                                  // qtde de diretorios
  ENDI
 NEXT
 FOR t=1 TO LEN(dir_arq)
  IF AT("~",dir_arq[t,1])>0
   dir_arq[t,1]=STRTRAN(dir_arq[t,1],"~","Ù")
  ENDI
 NEXT
 IF _comarq=.f.
  SET KEY K_F10 TO ESCOLHIDOUM()
 ENDI
 op_a=DBOX(dir_arq,,,.T.,,dir_base+msgt)    // escolhe o arquivo desejado
 IF op_a=0                                   // abandonou
  EXIT                                       // entao, cai fora
 ENDI
 IF AT("Ù",dir_arq[op_a,1])>0
  dir_arq[op_a,1]=STRTRAN(dir_arq[op_a,1],"Ù","~")
 ENDI
 IF dir_arq[op_a,5]="D" .AND. _escolheu=.f.  // o arquivo escolhido e' um diretorio
  IF dir_arq[op_a,1]=".."                    // que voltar um diretorio
   dir_base=LEFT(dir_base,LEN(dir_base)-1)   // tira a "\" do final do diretorio
   dir_base=LEFT(dir_base,RAT("\",dir_base)) // tira o nome do ultimo diretorio
  ELSE                                       // escolheu um sub-diretorio
   dir_base=dir_base+dir_arq[op_a,1]+"\"     // vamos ate ele...
  ENDI
 ELSE                                        // coloca no buffer do teclado arq escolhido
  KEYB CHR(K_HOME)+CHR(K_CTRL_Y)+dir_base+IIF(dir_arq[op_a,1]="..","",dir_arq[op_a,1])
  EXIT                                       // e cai fora
 ENDI
ENDD
SETKEY(K_F10,t_f10)                          // reabilita F10
RETU

PROC POSI   // Recebe argumentos e pesquisa arquivo
LOCAL op_sis, i, ii, iii, tip, j_, msg, ind, qt_ind, ok_
PRIV cod_sos
op_sis=EVAL(qualsis,ALIAS())         // subscricao do vetor Sistema
ind=INDEXORD()                       // salva ordem atual
DO WHIL op_sis>0
 cod_sos=24
 qt_ind=LEN(sistema[op_sis,O_INDIC]) // qde de indices do arquivo
 chv=ATAIL(sistema[op_sis,O_CHAVE])  // pega ultimo elemento das chaves
 IF chv=="codlan"                    // e ve se e' ntx de relacionamento
  qt_ind--                           // se for, nao pode ser escolhido
 ENDI
 IF qt_ind>1                         // se mais de um,
  msg=""                             // escolhe por menu o conjunto de pesquisa
  FOR t=1 to qt_ind
   msg+="|"+sistema[op_sis,O_CONSU,t]
  NEXT
  op_posi=DBOX(SUBS(msg,2),,,E_MENU,,"SELECIONE A PESQUISA",,,op_posi)
  IF op_posi=0                       // cancelou
   DBSETORDER(ind)                   // restaura ordem anterior
   RETU                              // e retorna
  ENDI
 ELSE
  op_posi=1                          // so um indice, usa 1o. cj pesquisa
 ENDI
 DBSETORDER(op_posi)                 // usa o conjunto de pesquisa escolhido
 chvpesq:=msg:=""
 cod_sos=25

 /*
    Pega cada um dos campos chaves do conjunto de pesquisa selecionado.
    A variavel sistema[op_sis,O_ORDEM,1] possui, a cada dois digitos,
    os numeros de ordem dos campos escolhidos para chave.
    Exemplo: "010305"     (campos 1, 3 e 5 compoem a chave do conj pesquisa)
 */
 FOR i=1 TO LEN(sistema[op_sis,O_ORDEM,op_posi]) STEP 2   // para cada chave...
  ii=VAL(SUBS(sistema[op_sis,O_ORDEM,op_posi],i,2))       // ordem do campo
  tip=VALTYPE(&(FIELD(ii)))                               // tipo do campo
  IF tip="C"                                              // inicializa variavel
   chv=SPAC(LEN(&(FIELD(ii))))                            // p/ receber argumento
  ELSEIF tip="N"                                          // de acordo com o tipo
   chv=0                                                  // do campo
  ELSEIF tip="D"
   chv=CTOD('')
  ELSEIF tip="L"
   chv=.t.
  ENDI
  gab=sistema[op_sis,O_CAMPO,ii,O_MASC]                   // mascara do campo
  IF ii<=LEN(sistema[op_sis,O_CPRELA]) .AND.;             // se campo for de relacionamento
     sistema[op_sis,O_CAMPO,ii,O_CRIT]="I"                // e e' invisivel entao
   chv=&(sistema[op_sis,O_CPRELA,ii])                     // monta a chave automaticamente
  ELSE
   chv=DBOX(msg+"Informe "+;                              // recebe argumento de pesquisa
       sistema[op_sis,O_CAMPO,ii,O_TITU],,,,,"PROCURA REGISTRO",chv,gab)
  ENDI
  IF (EMPT(chv).AND.tip!="L") .OR. LASTKEY()=K_ESC        // cancelou ou informou parte
   EXIT
  ENDI
  msg=msg+sistema[op_sis,O_CAMPO,ii,O_TITU]+": "+;        // prepara mensagem do
      TRAN(chv,gab)+"||"                                  // titulo da janela
  chvpesq=chvpesq+TRANSCAMPO(.t.,"chv",ii)                // transforma p/ caracter
 NEXT
 chvpesq=TRIM(chvpesq)                                    // tira espacos
 IF EMPT(chvpesq) .OR. LASTKEY()=K_ESC                    // cancelou ou nao informou
  EXIT
 ENDI
 ultreg=RECN()                                            // salva registro corrente
 ok_=.f.
 SEEK chvpesq                                             // procura
 IF FOUND()                                               // achou?
  DO WHILE !EOF() .AND. &(INDEXKEY(op_posi))=chvpesq   // verifica se atende filtro
   IF &(INDEXKEY(ind))=IF(EMPT(criterio),"","T")+chv_1
    ok_=.t.                                               // ok...
    EXIT
   ELSE
    SKIP                                                  // tenta o proximo
   ENDI
  ENDD
 ENDI
 IF ok_
  EXIT                                                    // este serve...
 ELSE                                                     // nao serviu
  GO ultreg                                               // volta ao registro
  ALERTA(2)
  DBOX(msg+"nÑo encontrado, "+usuario,,,2,,"ATENÄéO!")    // vamos avisar ao usuario
 ENDI
ENDD
DBSETORDER(ind)                                           // usa ordem original
RETU

PROC IMPRELA    // Imprime as telas dos arquivos relacionados
LOCAL i_, op_sy_, op_s:=op_sis, ar_db:=ALIAS(), ultreg, ord_ind, chv_, ;
      cor_ant:=SETCOLOR()
PRIV op_sis:=op_sis, corcampo:=corcampo, drvcortel:=drvcortel,;
     drvtittel:=drvtittel, l_s, c_s, l_i, c_i, vr_memo:=vr_memo,;
     chv_rela, chv_1, chv_2, criterio, cpord
IF !EMPTY(ar_db)                       // sava situacao atual
 ultreg =RECNO()                       // registro e
 ord_ind=INDEXORD()                 // indice utilizado
ENDI
op_sy_=PEGAPAI(op_sis)                 // pega o "pai" de todos
SELE (sistema[op_sy_,O_ARQUI,O_NOME])
drvcortel =drvcortna                   // cores de tela nao ativa
drvtittel:=corcampo := drvtittna
FOR op_sis=op_sy_ TO nss               // a partir do "pai" pega os "filhos"
 IF op_s!=op_sis                       // menos o arquivo atual
  IF op_sis>op_sy_                     // pode ser um "filho"
   IF PEGAPAI(op_sis)!=op_sy_ .OR.;    // se nao tem o mesmo "pai"
      sistema[op_sis,O_OUTROS,O_NIVEL]>5// ou nao tem tela
    EXIT                               // cai fora...
   ENDI
  ENDI

  #ifdef COM_REDE
   IF !USEARQ(sistema[op_sis,O_ARQUI,O_NOME],.f.,20,1)
    RETU                               // nao conseguiu abrir o arquivo
   ENDI
  #else
   USEARQ(sistema[op_sis,O_ARQUI,O_NOME])     // abre o arquivo
  #endi

  chv_rela=""                          // monta expressao de ligacao
  FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
   chv_rela+="+"+TRANSCAMPO(.f.,sistema[op_sis,O_CPRELA,i],i)
  NEXT
  chv_rela=IF(LEN(chv_rela)>2,SUBS(chv_rela,2),"")
  PEGACHV2()                           // acha o 1o. e ultimo reg da relacao
  cr_="cr_"+ALIAS()                    // filtro da janela
  or_="or_"+ALIAS()                    // ordem da janela
  IF TYPE(cr_)!="U"                    // se ja esta definido
   criterio=&cr_                       // pega o filtro e a
   cpord=&or_                          // ordem
  ELSE                                 // caso contrario
   criterio:=cpord := ""               // inicializa o filtro/ordem
  ENDI
  REGINICIO()                          // verif/posiciona no 1 reg que atende filtro
  l_s=Sistema[op_sis,O_TELA,O_LS]      // coordenadas da tela
  c_s=Sistema[op_sis,O_TELA,O_CS]
  l_i=Sistema[op_sis,O_TELA,O_LI]
  c_i=Sistema[op_sis,O_TELA,O_CI]
  NOVAPOSI(@l_s,@c_s,@l_i,@c_i)        // pega posicao atual da tela
  i_=LEFT(sistema[op_sis,O_ARQUI,O_NOME],3)
  EVAL(&("{||"+i_+"_gets()}"))         // imprime a tela/registro
 ENDI
NEXT
op_sis=op_s                            // retorna ao arquivo anterior
IF !EMPTY(ar_db)                       // se existia um dbf nesta area
 SELE (ar_db)                          // restabelece a area
 DBSETORDER(ord_ind)                   // indice usado
 GO ultreg                             // registro
ELSE                                   // senao, pode ser uma inclusao
 SELE 0                                // seleciona a 1a. area sem dbf
ENDI
SETCOLOR(cor_ant)                      // restaura cor original
RETU

PROC REIMPTEL    // reeimprime as telas dos arquivos relacionados
LOCAL tl_item_:=SAVESCREEN(l_s,c_s,l_i,c_i) // salva janela ativa
DISPBEGIN()                                 // montaremos na tela de traz
IMPRELA()                                   // reeimprime outras janelas
CAIXA(mold,l_s,c_s,l_i,c_i)                 // refaz a sombra janela atual
RESTSCREEN(l_s,c_s,l_i,c_i,tl_item_)        // restraura janela atual
DISPEND()                                   // mostra a nova tela
RETU

PROC EDIT   // ManutenáÑo de arquivos
LOCAL prgets, prget1, princl, li, co, tecl_p, msg, sos_cod:=cod_sos,;
      i, ii, ultreg, pri_vez:=.t., ord_dbf, t_w, t_r, t_c
PRIV  chv_1, chv_2, tem_borda, op_sis:=op_sis, chv_rela:="", chv_1:="", chv_2:="", l_a
edic=1
t_w:=SETKEY(K_CTRL_W,NIL)                               // desabilita e salva
t_r:=SETKEY(K_CTRL_R,NIL)                               // as teclas de controle
t_c:=SETKEY(K_CTRL_C,NIL)

/*
   Simplificando o CASE. A variavel tbtecla e' um vetor bidimensional
   que contem as teclas a serem testadas e suas respectivas acoes dentro
   do "code block" correspondente
*/
tbtecla={{K_LEFT,     {||op_edic:="A"}},;
         {K_RIGHT,    {||op_edic:="S"}},;
         {K_UP,       {||op_edic:="A"}},;
         {K_DOWN,     {||op_edic:="S"}},;
         {K_F9,       {||if(op_sis=nss .and. !eof(),trocasenha(.f.,DECRIPT(pw_nome)),veoutros())}},;
         {K_ALT_F8,   {||rola_t:=.t.,ROLATELA()}},;
         {K_CTRL_PGDN,{||FIM_ARQ()}},;
         {K_CTRL_PGUP,{||INI_ARQ()}};
        }

DO WHIL .t.
 SET CURS OFF
 IF pri_vez
  tbmenu="PSADCMERFOG"                         // letras iniciais das opcoes
  FOR i=1 TO LEN(exrot[op_sis])                // exclui comando da lista
   tbmenu=STRTRAN(tbmenu,SUBS(exrot[op_sis],i,1),"")
  NEXT
  IF AT("D",tbmenu)=0                             // se pode incluir deixa copiar
   tbmenu=STRTRAN(tbmenu,"C","")
  ENDI
  msg_menu=""
  msg_menu+=IF(AT("P",tbmenu)>0,"Procura|","") // variavel contendo opcoes
  msg_menu+=IF(AT("S",tbmenu)>0,"Seguinte|","")// do menu de edicao
  msg_menu+=IF(AT("A",tbmenu)>0,"Anterior|","")
  msg_menu+=IF(AT("D",tbmenu)>0,"Digita|Copia|","")
  msg_menu+=IF(AT("M",tbmenu)>0,"Modifica|","")
  msg_menu+=IF(AT("E",tbmenu)>0,"Exclui|","")
  msg_menu+=IF(AT("R",tbmenu)>0,"Recupera|","")
  msg_menu+=IF(AT("F",tbmenu)>0,"Filtra|","")
  msg_menu+=IF(AT("O",tbmenu)>0,"Ordena|","")
  msg_menu+=IF(AT("G",tbmenu)>0,"Global","")

  #ifdef COM_REDE
   IF !USEARQ(sistema[op_sis,O_ARQUI,O_NOME],.f.,20,1)// se nao abriu arquivo,
    RETU                                       // volta
   ENDI
  #else
   USEARQ(sistema[op_sis,O_ARQUI,O_NOME])      // abre DBF/NTX
  #endi

  prget1=LEFT(ALIAS(),3)+"_get1"               // nome prg para modificar o registro
  princl=LEFT(ALIAS(),3)+"_incl"               // nome prg para inclusao de registros

  /*
     compila code block em tempo de execucao para apresentar as telas/campos
  */
  prgets=&("{||"+LEFT(ALIAS(),3)+"_gets()}")
  chv_rela=""                                  // monta expressao de ligacao
  FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])     // com a jenela superoir
   chv_rela+="+"+TRANSCAMPO(.f.,sistema[op_sis,O_CPRELA,i],i)
  NEXT
  chv_rela=IF(LEN(chv_rela)>2,SUBS(chv_rela,2),"")
  cr_="cr_"+ALIAS()
  or_="or_"+ALIAS()
  IF TYPE(cr_)!="U"
   criterio=&cr_
   cpord=&or_
  ELSE
   criterio:=cpord := ""
  ENDI
  PEGACHV2()                                   // acha o 1o. e ultimo reg da relacao
  DISPBEGIN()
  EVAL(Prgets)       // exibe tela e conteudo do registro
  IMPRELA()
  EVAL(Prgets)       // exibe tela e conteudo do registro
  INFOSIS(.f.)       // exibe informacao no rodape' da tela
  DISPEND()
  pri_vez=.f.
 ENDI
 cod_sos=sos_cod

 #ifdef COM_MOUSE
  tecl_p=MOUSETECLA()
  MOUSEGET(@li,@co)
  IF tecl_p=CLICK                            // clicou botao esquerdo
   IF li<l_s.OR.co<c_s.OR.li>l_i.OR.co>c_i
    IF LEN(sistema[op_sis,O_DBRELA])>0 .OR.; // e' um "pai" ou "filho"
       LEN(sistema[op_sis,O_CPRELA])>0
     pai_sis=PEGAPAI(op_sis)                 // ve se o clique do mouse
     ii=op_sis                               // esta dentro da area da
     FOR op_sis=pai_sis TO nss               // tela de qualquer um
      IF PEGAPAI(op_sis)=Pai_sis             // arquivo relacionado
       l_s=Sistema[op_sis,O_TELA,O_LS]       // coordenadas da tela
       c_s=Sistema[op_sis,O_TELA,O_CS]
       l_i=Sistema[op_sis,O_TELA,O_LI]
       c_i=Sistema[op_sis,O_TELA,O_CI]
       vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i) // pega posicao atual da tela
       IF li>=l_s .AND. co>=c_s .AND.;       // esta' dentro desta tela...
          li<=l_i .AND. co<=c_i
        ii=op_sis
       ENDI
      ELSE
       EXIT
      ENDI
     NEXT
     op_sis=ii
     pri_vez=.t.
     l_a=NIL
    ENDI
    LOOP
   ENDI
   novapos=.t.
   KEYB CHR(77)            // coloca "M" no buffer para
   tecl_p=INKEY(0)        // fazer lastkey() != de ESC
  ENDI
 #else

  #ifdef COM_REDE
   tecl_p=INKEY(drvtempo)  // faz "refresh" da tela a cada drvtempo seg
  #else
   tecl_p=INKEY(0)         // aguarda usuario teclar algo
  #endi

 #endi

 IF SETKEY(tecl_p)!=NIL     // se tecla digitada tem funcao programada
  EVAL(SETKEY(tecl_p))      // executa programacao
  tecl_p=0
 ENDI
 SET CURS ON                              // acende o cursor
 op_edic=""
 nm=ASCAN(tbtecla,{|ve_a|tecl_p=ve_a[1]}) // procura tecla digitada no vetor tbtecla
 IF nm != 0                               // se achou,
  EVAL(tbtecla[nm,2])                     // entao executa
 ELSEIF tecl_p=K_PGDN .AND.;              // PgDn com scroll
        LEN(sistema[op_sis,O_TELA])>7
  IF MOV_PTR(sistema[op_sis,O_TELA,O_QTDE])=0
   ALERTA(2)                              // encontrado o final do
   DBOX("* FINAL DO ARQUIVO *",15,,1)     // arquivo, vamos avisar
  ENDI
 ELSEIF tecl_p=K_PGUP .AND.;              // PgUp com scroll
        LEN(sistema[op_sis,O_TELA])>7
  IF MOV_PTR(-1*sistema[op_sis,O_TELA,O_QTDE])=0
   ALERTA(2)                              // encontrado o inicio do
   DBOX("* INICIO DO ARQUIVO *",15,,1)    // arquivo, vamos avisar
  ENDI
 ELSEIF tecl_p=K_PGDN .AND.;              // PgDn p/ proxima tela
        sistema[op_sis,O_TELA,O_DEF]>1
  IF sistema[op_sis,O_TELA,O_ATUAL]<sistema[op_sis,O_TELA,O_DEF]
   sistema[op_sis,O_TELA,O_ATUAL]++
  ENDI
 ELSEIF tecl_p=K_PGUP .AND.;              // PgDn p/ tela anterior
        sistema[op_sis,O_TELA,O_DEF]>1
  IF sistema[op_sis,O_TELA,O_ATUAL]>1
   sistema[op_sis,O_TELA,O_ATUAL]--
  ENDI
 ELSEIF tecl_p=K_ESC                      // cancelou
  EXIT
 ELSEIF tecl_p=K_F8 .OR. tecl_p=K_TAB     // troca de janela so
  IF LEN(sistema[op_sis,O_DBRELA])>0.OR.; // se tem dbfs relacionados
     LEN(sistema[op_sis,O_CPRELA])>0
   pai_sis=PEGAPAI(op_sis)                // "pai" do arquivo
   ii=1
   IF tecl_p=K_F8                         // F8 monta menu de dbfs relacionados
    msg=SUBS(MENURELA(pai_sis),2)         // nome dos dbfs relacionados
    IF CONTA("|",msg)>0                   // mais de um dbf
     cod_sos=13
     ii=DBOX(msg,,3,E_MENU,,"ARQUIVOS")   // escolhe o arquivo
    ENDI
   ENDI
   IF ii>0
    IF tecl_p=K_TAB                       // TAB muda para proxima janela
     op_sis++
     DO WHILE op_sis<nss .AND. sistema[op_sis,O_OUTROS,O_NIVEL]>5
      op_sis++
     ENDD
     IF op_sis>nss .OR.;                  // se nao for filho volta
        PEGAPAI(op_sis)!=Pai_sis          // para o "pai de todos"
      op_sis=Pai_sis
     ENDI
    ELSE                                  // F8...
     IF CONTA("|",msg)>0                  // mais de um dbf relacionado
      op_sis=QUALRELA(pai_sis,ii,0)       // acha subscricao do dbf escolhido
     ELSE
      op_sis++
      DO WHILE op_sis<nss .AND. sistema[op_sis,O_OUTROS,O_NIVEL]>5
       op_sis++
      ENDD
      IF op_sis>nss .OR.;                 // se nao for filho volta
         PEGAPAI(op_sis)!=Pai_sis         // para o "pai de todos"
       op_sis=Pai_sis
      ENDI
     ENDI
    ENDI
   ENDI
   cr_="cr_"+ALIAS()
   or_="or_"+ALIAS()
   &cr_.=criterio
   &or_.=cpord
   pri_vez=.t.
   l_a=NIL
   LOOP
  ENDI
 ELSEIF tecl_p=K_F10                      // menu de opcoes
  op_edic=DBOX(msg_menu,2,67,E_MENU,,"MENU DE|EDIÄéO",,,AT(op_edic,tbmenu))
  op_edic=SUBS(" "+tbmenu,op_edic+1,1)
 ELSE
  IF tecl_p>0
   op_edic=UPPER(CHR(tecl_p))             // converte tecla em letra
  ENDI
 ENDI
 IF AT(op_edic,"SA")=0 .AND. AT(op_edic,ALLTRIM(exrot[op_sis]))>0
  ALERTA()                                // se usuario nao tem permissao,
  DBOX(msg_auto,,,3)                      // beep, beep, beep
  LOOP                                    // exibe mensagem e
 ENDI                                     // volta ao menu
 ii=.f.
 IF LEN(sistema[op_sis,O_CPRELA])>0       // tem um "pai"....
  msg=LEFT(sistema[op_sis,O_CPRELA,1],AT("->",sistema[op_sis,O_CPRELA,1])-1)
  ii=(msg)->(EOF() .OR. BOF())            // o pai esta vazio!
  IF op_edic="D" .AND. (msg)->(DELE())    // nao deixa inclui se o "pai"
   ii=IF(ii,EVAL(qualsis,msg),op_sis)     // esta deletado
   msg="Registro excluido em "+ALLTRIM(sistema[ii,O_MENU])
   ALERTA()                               // 3 beeps
   DBOX(msg+", "+usuario)                 // para avisar
   LOOP                                   // e voltar...
  ENDI
 ENDI
 IF (EOF() .OR. BOF())                    // nao existe reg no arquivo
  IF (op_edic!="D" .OR. ii) .AND.;        // inibe todas as alternativas
     !EMPT(op_edic)                       // exceto a digitacao
   ii=IF(ii,EVAL(qualsis,msg),op_sis)
   msg="NÑo h† registros em "+ALLTRIM(sistema[ii,O_MENU])
   ALERTA()                               // 3 beeps
   DBOX(msg+", "+usuario)                 // para avisar
   LOOP                                   // espera digitar outra tecla
  ENDI
 ENDI

 DO CASE
  CASE op_edic="P"                        // procura registro
   POSI()

  CASE op_edic="S"                        // registro seguinte
   SKIP                                   // as formulas se existirem
   IF EOF() .OR. &(INDEXKEY(0))!=IF(EMPT(criterio),"","T")+chv_1
    ALERTA(2)                             // encontrado o final do
    DBOX("* FINAL DO ARQUIVO *",15,,1)    // arquivo, da mensagem e
    FIM_ARQ()                             // posiciona no ultimo registro
   ENDI

  CASE op_edic="A"                        // registro anterior

   /*
      se inicio de arquivo ou, se ha filtro e nao atende, nao retrocede
      senao, retrocede um registro por vez
   */
   SKIP -1
   IF BOF().OR.&(INDEXKEY(0))!=IF(EMPT(criterio),"","T")+chv_1
    ALERTA(2)                             // encontrado o inicio do
    DBOX("* INICIO DO ARQUIVO *",15,,1)   // arquivo, da mensagem e
    INI_ARQ()                             // posiciona no primeiro registro
   ENDI

  CASE op_edic="M"                        // modifica registro
   IF !(EOF() .OR. BOF())                 // registro excluido, nao pode ser alterado

    #ifdef COM_REDE
     IF !BLOREG(3,.5)                     // se nao conseguiu bloquear o
      LOOP                                //  registro, volta ao menu
     ENDI
    #endi

    IF DELE()                             // registro esta escluido
     ALERTA()                             // vamos avisar
     DBOX("REGISTRO EXCLU°DO",12,,1)

     #ifdef COM_MOUSE
      novapos=.f.                         // cancela clique do mouse no campo
     #endi

    ELSE
     IF CONFALT()                         // se o reg pode ser alterado
      &prget1.(FORM_INVERSA)              // processamento inverso, se houver
      INFOSIS(.t.)                        // exibe informacao no rodape' da tela
      &prget1.(INCLUI)                    // modif reg, com process dir, se houver
     ENDI

     #ifdef COM_MOUSE
      novapos=.f.                         // cancela clique do mouse no campo
     #endi

    ENDI

    #ifdef COM_REDE
     UNLOCK                               // libera registro
    #endi

    REGINICIO()                           // verifica se reg esta' no filtro
   ENDI

  CASE op_edic="D" .OR. op_edic="C"       // Inclusao de registros
   ord_dbf:=INDEXORD()                 // sava indice atual para incluirmos
   DBSETORDER(1)                       // inclusao sempre pelo indice 1
   IF op_edic="D" .OR. EOF() .OR. BOF()   // inclusao ou nao tem reg no dbf
    &PrIncl.()                            // chama programa de inclusao
   ELSE                                   // senao,
    &PrIncl.(RECNO())                     // chama programa de inclusao com repeticao
   ENDI
   DBSETORDER(ord_dbf)                    // retorna ao indice da consulta
   REGINICIO()                            // verifica se reg esta' no filtro

  CASE op_edic="E"                        // marca para exclusao

   #ifdef COM_REDE
    IF !BLOREG(3,.5)                      // se nao bloqueou o registro
     LOOP                                 // volta ao menu
    ENDI
   #endi

   IF !DELE()                             // ja esta excluido?
    IF CONFEXCL()                         // pede para confirmar
     &prget1.(EXCLUI)                     // exclui e processo inverso
    ENDI
   ENDI

   #ifdef COM_REDE
    UNLOCK                                // libera registro
   #endi

   DO WHILE !EOF() .AND. DELE() .AND.;    // acha o proximo
      SET(_SET_DELETED)                   // registro que nao
    SKIP                                  // esta excluido
   ENDD
   IF EOF() .OR. &(INDEXKEY(0))!=IF(EMPT(criterio),"","T")+chv_1
    FIM_ARQ()                             // forca eof()
   ENDI

  CASE op_edic="R"                        // recupera registro marcado

   #ifdef COM_REDE
    IF !BLOREG(3,.5)                      // tenta bloquear o registro
     LOOP
    ENDI
   #endi

   IF DELE()                              // o registro esta excluido?
    IF !EMPT(sistema[op_sis,O_CONDREC,1]) // se tem condicao de
     IF !&(sistema[op_sis,O_CONDREC,1])   // recuperacao e se esse
      ALERTA(2)                           // reg nao pode ser
      msg=sistema[op_sis,O_CONDREC,2]     // avisa o motivo
      DBOX(msg,,,,,"ATENÄéO!|IMPOSS°VEL RECUPERAR")
      LOOP                                // e retorna
     ENDI
    ENDI
    &prget1.(RECUPERA)                    // recupera/processo direto, se houver
   ENDI

   #ifdef COM_REDE
    UNLOCK                                // libera o registro
   #endi


  CASE op_edic="F"
   FILTRA(.t.,.t.)                        // filtra (indexando, ordenando)

  CASE op_edic="O"                        // ordena o arquivo
   cpord=""                               // inicializa variavel
   CLASS(.t.)                             // escolhe ordenacao

  CASE op_edic="G"                        // processamento global
   ultreg=RECN()                          // salva registro
   GLOBAL()                               // prepara o processamento
   GO ultreg                              // retorna ao registro anterior
   REGINICIO()                            // verifica se reg esta' no filtro

 ENDC

 #ifdef COM_REDE
  IF op_edic!="S" .AND. op_edic!="A"
   COMMIT                                 // descarrega buffers
   GO RECNO()                             // ajusta ponteiro
  ENDI
 #endi

 DISPBEGIN()
 IF LEN(sistema[op_sis,O_DBRELA])>0
  IMPRELA()
 ENDI
 EVAL(prgets)                             // mostra registro que atende condicao
 INFOSIS(.f.)                             // exibe informacao no rodape' da tela
 DISPEND()
ENDD
criterio:=cpord := ""                     // reinicializa ordenacao e filtragem
SETKEY(K_CTRL_W,t_w)                      // restaura teclas de controle
SETKEY(K_CTRL_R,t_r)
SETKEY(K_CTRL_C,t_c)
RETU

PROC REGINICIO()   // posiciona no 1 reg do filtro
//IF &(INDEXKEY(0))!=IF(EMPT(criterio),"","T")+chv_1 // esta fora do filtro/relacao
IF &(ORDKEY(INDEXORD()))!=IF(EMPT(criterio),"","T")+chv_1 // esta fora do filtro/relacao INI_ARQ()                                         // forca inicio do arquivo
 INI_ARQ()
ENDI
RETU

PROC INI_ARQ()   // inicio do arquivo
LOCAL ch_:=IF(EMPTY(criterio),"","T")+; // monta expressao para achar
           IF(EMPTY(chv_rela),"",chv_1) // 1o. registro do filtro/relacao
IF EMPTY(ch_) .AND. EMPTY(chv_rela)     // nao tem filtro/relacao
 GO TOP                                 // vai para o 1o. reg do arquivo
ELSE                                    // senao,
 SEEK ch_                               // acha o 1o. que atenda a expressao
ENDI
RETU

PROC FIM_ARQ()   // final do arquivo
LOCAL cr_:=IF(EMPT(criterio),"","T")
IF EMPTY(chv_2) .AND. EMPTY(chv_rela)   // se nao estiver relacionado vai
 GO BOTT                                // para o ultimo reg do arquivo
ELSE                                    // caso contrario,
 SET SOFTSEEK ON                        // procura o ultimo registro
 SEEK cr_+chv_2                         // da relacao
 SET SOFTSEEK OFF                       // (desliga index mais proximo)
 SKIP -1                                // volta para dentro da relacao
 IF &(INDEXKEY(0))!=cr_+chv_1           // reg esta fora do filtro ou da
  GO BOTT                               // relacao, vai para o fimal
  SKIP                                  // do arquivo real
 ENDI
ENDI
RETU

PROC POSIPAI   // relaicona o "filho" com seus "pais"
LOCAL op_sy_, p_, i, ar_db:=ALIAS(), dbf_pais:=""
PRIV  db_, chv_rela
op_sy_=op_sis                               // subscricao do arquivo atual
DO WHILE LEN(sistema[op_sy_,O_CPRELA])>0    // se existir um pai...
 chv_rela=""
 p_=AT("->",sistema[op_sy_,O_CPRELA,1])+2   // separador de arquivo->campo
 db_=LEFT(sistema[op_sy_,O_CPRELA,1],p_-3)  // pega o nome do pai e a
 dbf_pais="|"+db_+dbf_pais                  // todos os pais
 FOR i=1 TO LEN(sistema[op_sy_,O_CPRELA])   // chave de ligacao
  chv_rela+=TRANSCAMPO(.t.,SUBS(sistema[op_sy_,O_CPRELA,i],p_),i)
 NEXT
 PTAB(chv_rela,db_,1)                       // abre/relaciona o pai
 op_sy_=EVAL(qualsis,db_)                   // sera que tem avo?...
ENDD
dbf_pais=SUBS(dbf_pais,2)                   // ajusta var com nome dos pais
DO WHILE LEN(dbf_pais)>0                    // tem mais uma pai?
 db_=PARSE(@dbf_pais,"|")                   // separa o nome deste
 SELE (db_)                                 // seleciona sua area
 db_=LEFT(db_,3)+"_get1"                    // e chama o programa xxx_get1
 &db_.(POSICIONA)                           // para abrir os arquivos
ENDD                                        // relacionados atraves de PTAB()
SELE (ar_db)                                // restabelece a area do dbf
RETU

PROC IMP_FORM(f_)  // imprime formula na tela
LOCAL l_, c_
IF VALTYPE(f_[O_LINHA])="B"  // a linhas esta variando (scroll)
 l_=l_s+EVAL(f_[O_LINHA])    // acha a nova posicao
ELSE
 l_=l_s+f_[O_LINHA]          // a linha e fixa na tela
ENDI
c_=c_s+f_[O_COLUNA]          // coluna
@ l_,c_ SAY &(f_[O_FORM])    // exibe formula
RETU

PROC PEGACHV2()  // inicializa chv_1 e chv_2
IF !EMPTY(chv_rela)                   // se existe alguma relacao
 chv_1 = &chv_rela.                   // chv_1 contera a chave da relacao
 chv_2 = LEFT(chv_1,LEN(chv_1)-1)+;   // chv_2 sera o mais proximo
         CHR(ASC(RIGHT(chv_1,1))+1)   // de chv_1
ELSE                                  // se nao existe relacao
 chv_1:=chv_2 := ""                   // inicializa vaiaveis
ENDI
RETU

PROC GLOBAL    // Processamento global de registros

/*
   dentro desta rotina, o usuario pode definir, em tempo de execucao,
   processamentos para alterar campos do arquivo. Nos comentarios a seguir
   nao confundir estes com os processamentos definidos em tempo de projeto
   da aplicacao, os quais sao aqui chamados de formulas direta e inversa
*/
LOCAL c_ampo:={}, exp_r:={}, cf_, a_ok, i:=0, getlist:={}, chv_x:="",;
      t_glob:=SAVESCREEN(0,0,MAXROW(),79), m_campos:="", dele_atu:=SET(_SET_DELETED)
PRIV cod_sos:=19

#ifdef COM_REDE
 IF !BLOARQ(3,.5)                                     // tenta bloquear o arquivo
  RETU                                                // se nao conseguiu, volta
 ENDI
#endi

ALERTA()
msg="Continuar processamento global|Cancelar a operaáÑo"
msgt=IF(EMPTY(criterio),"TODOS OS REGISTROS DO ARQUIVO!!!",;
        "SOMENTE OS REGISTROS FILTRADOS")
op=DBOX(msg,,,E_MENU,,"ATENÄéO, "+usuario+;           // aviso importante!
        "!|ESTA ROTINA ATINGIRè|"+msgt+;
        "|ê ACONSELHAVEL FAZER 'BACKUP` ANTES!")
IF op!=1
 RETU                                                 // cancelou
ENDI
FOR i=1 TO FCOU()                                     // enche m_campos com os titulos
 IF !("I"==sistema[op_sis,O_CAMPO,i,O_CRIT])          // dos nomes dos campos do dbf
  m_campos+="|"+sistema[op_sis,O_CAMPO,i,O_TITU]      // excetos campos invisiveis
 ENDI
NEXT
m_campos=SUBS(m_campos,2)
op_o=1
msg="APAGA determinados registros|RECUPERA determinados registros|"+;
    "MODIFICA campos de determinados registros"
op_o=DBOX(msg,,,E_MENU,,"PROCESSAMENTO GLOBAL")       // menu dos processamentos
IF op_o>0
 IF op_o=3                                            // alteracao de campos
  DO WHIL LEN(c_ampo)<=FCOU()
   msg="PROCESSAMENTO GLOBAL|ESCOLHA O CAMPO PARA SER ALTERADO"
   op_1=DBOX(m_campos,,,E_MENU,,msg)
   IF op_1!=0
    ii=0
    FOR i=1 TO FCOU()                                 // acha campo escolhido
     IF !("I"==sistema[op_sis,O_CAMPO,i,O_CRIT])
      ii++                                            // desprezando campos
     ENDI                                             // invisiveis
     IF ii=op_1                                       // campo escolhido?
      cp_=FIEL(i)                                     // nome do campo
      msg=sistema[op_sis,O_CAMPO,i,O_CRIT]            // critica do campo
      EXIT
     ENDI
    NEXT
    IF TYPE(cp_)="M".OR.UPPER(cp_)$UPPE(INDEXKEY(1)); // nega processamento em campos
       .OR. msg=="V" .OR. msg=="I"                    // memo, nao editavel, invisivel
     msg="NÑo permitido alterar campo|"+;             // ou que seja parte da chave
         "MEMO, INVIS°VEL, NéO EDITèVEL ou CHAVE"
     ALERTA(3)
     DBOX(msg,,,3,,"ATENÄéO! "+usuario)
     LOOP
    ENDI
    IF ASCAN(c_ampo,cp_)>0                            // campo ja' tem um
     ALERTA(3)                                        // processamento definido
     DBOX("Campo j† foi selecionado",,,3,,"ATENÄéO! "+usuario)
     LOOP
    ENDI
    expg=SPAC(254)
    msg="A EXPRESSéO ABAIXO DEVERè OBEDECER A SINTAXE DA LINGUAGEM|*|"+;
        "F10=CAMPOS DO ARQUIVO|*|"+;
        "(Usar 'aspas' em constantes do tipo caracter)|*|"+;
        "Substituir "+cp_+" com"
    DO WHILE .t.
     SET KEY K_F10 TO ve_campos                       // f10 ve campos
     msgt="ALTERAÄéO DE CAMPO"
     expg=DBOX(msg,,,,,msgt,expg,"@S54")              // capta processamento
     SET KEY K_F10 TO
     IF LASTKEY()=K_ESC                               // cancelou
      expg=""
     ELSEIF !CRIT("TYPE(expg)==TYPE(cp_)~"+;          // verifica se a expressao
                  "ExpressÑo ilegal!",15)             // e do mesmo tipo do campo
      LOOP                                            // se nao for, sobe
     ENDI
     EXIT
    ENDD
    IF !EMPT(expg)                                    // se nao cancelou,
     AADD(c_ampo,cp_)                                 // coloca o campo e a
     AADD(exp_r,ALLTRIM(expg))                        // a expressao nos arranjos
    ENDI
   ELSE
    EXIT                                              // saindo...
   ENDI
  ENDD
 ENDI
 IF LEN(c_ampo)>0 .OR. op_o!=3                        // existe processo
  msg="Apaga   RecuperaAltera"                        // mglob=nome do processo
  mglob=TRIM(SUBS(msg,op_o*8-7,8))                    // que foi escolhido
  ALERTA(2)
  op_g=2
  msg="Confirma a cada registro|"+mglob+" sem confirmar"
  op_g=DBOX(msg,,,E_MENU,,UPPER(mglob))               // confirmar ou nao?
  IF op_g=0

   #ifdef COM_REDE
    UNLOCK                                            // desbloqueia o arquivo
   #endi

   RETU
  ELSE
   cf_=(op_g=1)                                       // cf_=.t., tem confirmacao
   op_a=2
   IF (op_o=1 .AND. !EMPT(sistema[op_sis,O_CONDEXC,1])) .OR. (op_o=3 .AND. !EMPT(sistema[op_sis,O_CONDALT,1])) .OR.  (op_o=2 .AND. !EMPT(sistema[op_sis,O_CONDREC,1]))
    ALERTA()
    msg="Obedecer condiáîes|Ignorar condiáîes"
    msgt="|EXISTEM CONDIÄôES ESPECIAIS|PARA ATUALIZACAO DESTE ARQUIVO"
    op_a=DBOX(msg,,,E_MENU,,"ATENÄéO, "+usuario+msgt)
    IF op_a=0

     #ifdef COM_REDE
      UNLOCK                                       // libera o registro
     #endi

     RETU
    ENDI
   ENDI
   getsx=LEFT(ALIAS(),3)+"_gets"
   get1x=LEFT(ALIAS(),3)+"_get1"
   SET DELE OFF                                       // excluidos serÑo vistos
   IF !cf_                                            // nao confirmado
    DBOX("Aguarde! ESC cancela",,,,NAO_APAGA)
   ELSEIF brw                                         // se veio da EDITA()
    CBC1()
    IF sistema[op_sis,O_TELA,O_DEF]>1                 // se o subsistema tem
     SET KEY K_CTRL_R TO tela_ant                     // mais de uma tela,
     SET KEY K_CTRL_C TO tela_seg                     // habilita PGDN e PGUP
    ENDI
   ENDI
   INI_ARQ()                                          // posiciona no inicio do arquivo
   DO WHIL !EOF() .AND. INKEY()!=K_ESC               // correndo o arquivo

    IF cf_                                            // se metodo confirmado
     DISPBEGIN()
     IF LEN(sistema[op_sis,O_DBRELA])>0
      IMPRELA()
     ENDI
     &getsx.()                                        // conteudo do registro
     DISPEND()
     ALERTA(1)                                        // beep!
     volta=0
     msg=mglob+"|NÑo "+mglob+"|Cessa confirmaáÑo|Cancela"
     op_g=DBOX(msg,0,2,E_MENU,,,,"SELECIONE",2)       // oferece confirmacao
     IF volta>0                                       // volta>0 significa que
      sistema[op_sis,O_TELA,O_ATUAL]++                // teclou PGDN ou PGUP
      LOOP                                            // incrementa tela e sobe
     ENDI
     IF op_g=0 .OR. op_g=4                            // cancelou
      EXIT
     ENDI
     a_ok=(op_g!=2)                                   // a_ok=.t., pode processar!
     cf_=(op_g!=3)                                    // se cf_=.t., quer continuar
     IF !cf_                                          // confirmando os processos
      DBOX("Aguarde!  ESC cancela",,,,NAO_APAGA)
     ENDI
    ELSE                                              // metodo nao confirmado,
     a_ok=.t.
    ENDI
    IF op_o=1 .AND. op_a=1 .AND. a_ok                 // existe e quer testar
     a_ok=&(sistema[op_sis,O_CONDEXC,1])              // condicao de exclusao
    ENDI
    IF op_o=2 .AND. op_a=1 .AND. a_ok                 // existe e quer testar
     a_ok=&(sistema[op_sis,O_CONDREC,1])              // condicao de recuperacao
    ENDI
    IF op_o=3 .AND. op_a=1 .AND. a_ok                 // existe e quer testar
     a_ok=&(sistema[op_sis,O_CONDALT,1])              // condicao de alteracao
    ENDI
    IF a_ok                                           // vamos fazer o processo global

     IF op_o=1                                        // excluindo
      IF !DELE()                                      // (so se nao apagado)
       &get1x.(EXCLUI)                                // executa formula inversa,
      ENDI                                            // se existir e marca para apagar

     ELSEIF op_o=2                                    // recuperando
      IF DELE()                                       // (so os marcados)
       &get1x.(RECUPERA)                              // executa formula direta e
      ENDI                                            // desmarca o apagamento

     ELSEIF !DELE()                                   // alterando campos
      &get1x.(FORM_INVERSA)                           // executa formula inversa
      SKIP                                            // vamos salvar o prox registro
      proxreg=IF(EOF(),-1,RECN())                     // se estivermos alterando campo do
      SKIP -1                                         // componente do filtro ou ordenacao
      FOR i=1 TO LEN(c_ampo)                          // modifica os campos
       REPL &(c_ampo[i]) WITH &(exp_r[i])             // que foram escolhidos
      NEXT
      &get1x.(FORM_DIRETA)                            // executa a formula direta
      IF proxreg>0                                    // se nao for final do arquivo,
       GO proxreg                                     // reposiciona no proximo
       SKIP -1                                        // registro a ser alterado
      ELSE                                            // senao,
       GO BOTT                                        // forca fim do arquivo
      ENDI
     ENDI

    ENDI
    SKIP                                              // o proximo por favor...
    IF &(INDEXKEY(0))!=IF(EMPT(criterio),"","T")+chv_1 // esta fora do filtro ou relacao
     EXIT                                             // acabou o processo global
    ENDI
   ENDD
   IF op_menu=PROJECOES                               // se veio da EDITA() ve
    IF sistema[op_sis,O_TELA,O_DEF]>1                 // se o subsistema tem
     SET KEY K_CTRL_R TO                              // mais de uma tela para
     SET KEY K_CTRL_C TO                              // desabilita PGDN e PGUP
    ENDI
   ENDI
   RESTSCREEN(0,0,MAXROW(),79,t_glob)                 // restaura tela
   DISPBEGIN()                                        // escreve sem mostrar
   IF LEN(sistema[op_sis,O_DBRELA])>0                 // se tem filho
    IMPRELA()                                         // vamos mostra-lo
   ENDI
   &getsx.()                                          // conteudo do registro
   DISPEND()                                          // mostra o que escreveu
  ENDI
 ENDI
ENDI

#ifdef COM_REDE
 UNLOCK                                               // libera arquivo
#endi

SET(_SET_DELETED,dele_atu)                            // retorna visibilidade
RETU

PROC SUBNIVEL(db_item)   // InclusÑo em arquivos subordinados
LOCAL ar_db, ultreg
PRIV op_sis, cod_sos
ultreg=RECN()                                         // salva registro atual e
ar_db=ALIAS()                                         // o nome do arquivo aberto
op_sis=EVAL(qualsis,db_item)

#ifdef COM_REDE
 IF !USEARQ(sistema[op_sis,O_ARQUI,O_NOME],.f.,20,1)  // se nao abriu arquivo, volta
  RETU
 ENDI
#else
 USEARQ(sistema[op_sis,O_ARQUI,O_NOME])               // abre DBF/NTX
#endi

IF op_menu=INCLUSAO
 EVAL(&("{||"+LEFT(db_item,3)+"_incl()}"))
ELSE
 EDIT()
ENDI
IF !EMPTY(ar_db)                                      // se havia arquivo aberto,
 SELE (ar_db)                                         //  seleciona-o e tambem
 GO ultreg                                            //  retorna ao registro
ELSE                                                  // senao,
 SELE 0                                               //  seleciona proxima area livre
ENDI
RETU .t.

PROC INTREF(oq_fazer) // Manipula integridade refencial de arquivos subordinados
LOCA statusdele, db_f:=ALIAS(), op_sy_:=EVAL(qualsis,ALIAS()),;
     chv_:=&(INDEXKEY(1)), i_, ind_ord, reg_
PRIV op_sis
statusdele=SET(_SET_DELETED,.f.)                 // reg excluidos serao vistos
FOR i_=1 TO LEN(sistema[op_sy_,O_DBRELA])        // para cada "filho" do arquivo
 op_sis=EVAL(qualsis,sistema[op_sy_,O_DBRELA,i_])// subscricao do vetor Sistema

 #ifdef COM_REDE
  IF !USEARQ(sistema[op_sis,O_ARQUI,O_NOME],.f.,20,1) // se nao abriu arquivo,
   RETU                                          // volta
  ENDI
 #else
  USEARQ(sistema[op_sis,O_ARQUI,O_NOME])         // abre DBF/NTX
 #endi

 ind_ord=INDEXORD()                              // sava indice atual
 DBSETORDER(1)                                   // seta indice principal
 reg_=RECNO()                                    // registro atual
 SEEK chv_                                       // acha o 1o. da relacao
 DO WHILE &(INDEXKEY(1))=chv_
  IF (oq_fazer=FORM_INVERSA .AND. !DELE()) .OR.; // para cada registro que
     (oq_fazer=FORM_DIRETA .AND. flag_excl!="*") // atende a relacao...

   #ifdef COM_REDE
    BLOREG(0,.5)                                 // bloqueia o registro
   #endi

   EVAL(&("{|o|"+LEFT(ALIAS(),3)+;
          "_get1(o,.t.)}"),oq_fazer)             // exclui ou recupera o registro

   #ifdef COM_REDE
    UNLOCK                                       // libera o registro
   #endi

  ENDI
  SKIP                                           // proximo...
 ENDD
 DBSETORDER(ind_ord)                             // volta ao indice em uso e
 GO reg_                                         // ao registro atual
NEXT
SET(_SET_DELETED,statusdele)                     // retaura o status do SET DELE
SELE (db_f)
RETU

PROC VE_REL()  // ve relatorio gravado em disco
PRIV cod_sos, cur_sor:=SETCURSOR(3)  // salva cursor/acende
SAVE SCREEN                          // salva tela
arq_=ARQGER()                        // pega nome do arquivo
IF !EMPTY(arq_)                      // se cancelou ou nao informou
 cod_sos=1
 BROWSE_REL(arq_,2,3,MAXROW()-2,78,.f.) // mostra o arquivo gravado
ENDI
REST SCREEN                          // restaura a tela
SETCURSOR(cur_sor)                   // restabelece o cursor
RETU

PROC HELP    // Apresenta ajuda on-line
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
IF !FILE(arq_sos)                                    // nao ha texto de ajuda...
 ALERTA()                                            // beep beep beep
 DBOX("O arquivo "+arq_sos+"|contendo o texto de "+;
      "ajuda|nÑo foi encontrado",,,2,,"ATENÄéO,"+;   // avisa!
      usuario)
ELSE
 txt=LEMANU(arq_sos,cod_sos)                         // pega bloco de ajuda
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

ENDI
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


#ifdef COM_TUTOR
 PROC mHelp  // grava/le teclas do tutorial
 PRIV  t_:=LASTKEY()                        // tecla digitado no help
 IF acao_mac $ "Gg"                         // se esta gravando macro
  KEYB_MAC(MONTA_BUFF(t_))                  // joga no buffer do teclado
  Q_TEC(0)                                  // para gravar a tecla
 ELSEIF acao_mac $ "LAC" .AND. t_!=K_ESC    // se esta lendo
  KEYB_MAC(MONTA_BUFF(Q_TEC(0)))            // le a tecla e joga no buffer
 ENDI                                       // do teclado
 RETURN
#endi


PROC NADAFAZ  // desativa ^W/PgUp/PgDn em inclusao
RETU

PROC VE_LOG()  // ve relatorio gravado em disco
PRIV cod_sos, cur_sor
IF nivelop<3        // se usuario nao autorizado,
 RETU               // cai fora..
ENDI
cur_sor=SETCURSOR(3)   // salva cursor/acende
SAVE SCREEN            // salva tela
cod_sos=1
BROWSE_REL(arq_log,2,3,MAXROW()-2,78,.t.) // mostra o arquivo de log
REST SCREEN                               // restaura a tela
SETCURSOR(cur_sor)                        // restabelece o cursor
RETU

PROC POE_NO_LOG(tp_mov)  // coloca informacoes no log
LOCAL i, estr_:={}, nc, j, x, db_:=sistema[op_sis,O_ARQUI,O_NOME] // nome do dbf
t=FILEATTRIB(arq_log)                     // testa se existe/verif atributos
IF !(t)                                   // arquivo nao existe
 area_=FCREATE(arq_log,1)                 // tenta criar o arquivo
ELSE                                      // atributo errado
 RWRITE(arq_log)                          // torna o arquivo R/W
 area_=FOPEN(arq_log,1)                   // abre o arquivo
ENDI
IF area_>0                                // arquivo aberto beleza.
 buff=PADR(db_,8)+" Ø "                   // comeca o log com o nome do dbf
 buff+=PADR(usuario,15)+" Ø "             // nome do usuario
 IF tp_mov=INCLUI                         // esta incluindo/alterando
  IF op_menu=INCLUSAO                     // e' inclusao
   buff+="INCLUSAO         "              // coloca no log
  ELSE
   buff+="DEPOIS ALTERACAO "              // modificou o dbf
  ENDI
 ELSEIF tp_mov=EXCLUI                     // excluindo registro
  buff+="EXCLUSAO         "
 ELSEIF tp_mov=FORM_INVERSA               // formula inversa e feita
  buff+="ANTES ALTERACAO  "               // antes da alteracao
 ELSEIF tp_mov=RECUPERA
  buff+="RECUPERACAO      "               // recuperando reg excluido
 ELSEIF tp_mov=FORM_DIRETA
  buff+="DEPOIS ALTERACAO "               // modificou o dbf
 ENDI
 buff+=DTOC(DATE())+" "+TIME()            // coloca data e hora no log
 nc=EVAL(&("{||"+db_+"->(FCOU())}"))      // numero de campos do arquivo
 estr_=&db_.->(DBSTRUCT())                // pega estrutura do dbf
 FOR i=1 TO nc                            // coloca todos os campos no log
  IF db_==ALIAS()
   msg=&db_.->(FIEL(i))                    // campo do arquivo
  ELSE
   msg=db_+"->"+&db_.->(FIEL(i))
  ENDI
  x=TRANS(&msg.,sistema[op_sis,O_CAMPO,i,O_MASC])
  j=IF(LEN(x)>LEN(sistema[op_sis,O_CAMPO,i,O_TITU]),LEN(x),LEN(sistema[op_sis,O_CAMPO,i,O_TITU]))
  IF estr_[i,2] = "C" .OR. estr_[i,2] = "D" // caracter e data alinha a esquerda
   buff+=" Ø "+PADR(TRANS(&msg.,sistema[op_sis,O_CAMPO,i,O_MASC]),j+2)
  ELSEIF estr_[i,2] = "M"                   // memo tira Cr+Lf
   buff+=" Ø "+PADR(STRTRAN(&msg.,CHR(13)+CHR(10),"  "),j+2)
  ELSE                                      // campo numerico alinha a direita
   buff+=" Ø "+PADL(TRANS(&msg.,sistema[op_sis,O_CAMPO,i,O_MASC]),j+2)
  ENDI
 NEXT
 buff=EMBARALHA(buff)                     // encripta os dados
 buff+=CHR(13)+CHR(10)                    // forca quebra de linha
 FSEEK(area_,0,2)                         // vai para o final do arquivo
 j=FWRITE(area_,buff,LEN(buff))           // grava o log
 FCLOSE(area_)                            // fecha o log
 SETRHS(arq_log)                          // coloca atrigutos rhs
ENDI
RETU

PROC INFOSIS(ed_)  // coloca informacao no rodape' da tela
LOCAL co_r:=SETCOLOR(drvcorenf), MsgEsq, MsgCen, MsgDir, i_
ed_=IF(ed_=NIL,.f.,ed_)                           // flag - esta editando?
IF op_menu=INCLUSAO                               // teclas disponiveis na
 MsgEsq="Inclui"                                  // inclusao
 MsgCen="F3,F4,F9"
ELSEIF op_menu=ALTERACAO                          // teclas disponiveis na
 MsgEsq="Altera"                                  // alteracao
 MsgCen=""
 IF (LEN(sistema[op_sis,O_DBRELA]) > 0 .OR.;      // tem dbfs relacionados?
    LEN(sistema[op_sis,O_CPRELA]) > 0) .AND. !ed_
  MsgCen="F8,"
 ENDI
 MsgCen+="F9"+IF(ed_,"",",F10")
ELSE                                              // teclas disponiveis na
 MsgEsq="Ve Global"                               // ve global da func EDITA()
 MsgCen=gcr
ENDI
IF sistema[op_sis,O_TELA,O_DEF]>1              // tem varias telas?
 MsgCen+=IF(sistema[op_sis,O_TELA,O_ATUAL]<sistema[op_sis,O_TELA,O_DEF].AND.;
            op_menu!=INCLUSAO," PgDn","";
         )
 MsgCen+=IF(sistema[op_sis,O_TELA,O_ATUAL]>1," PgUp","")
ENDI

#ifdef COM_MOUSE
 IF drvmouse .AND. op_menu=ALTERACAO              // teclas do mouse
  MsgCen+=" "+CHR(27)+" "+CHR(26)
 ENDI
#endi

IF op_menu=INCLUSAO                               // flags de repeticao e
 MsgDir=IF(fgrep," Rep",SPAC(4))+;                // confirmacao na inclusao
        IF(drvconf," Conf",SPAC(5))
ELSEIF DELE() .AND. EMPTY(READVAR()) .AND. !ed_   // coloca msg de EXCLUIDO
 MsgDir=" EXCLUIDO"                               // se for o caso...
ELSE
 MsgDir=SPACE(9)
ENDI
i_=c_i-c_s-3-LEN(MsgEsq)-LEN(MsgDir)
IF i_ > 2                                         // se msg cabe natela
 MsgCen=PADC(MsgCen,i_)                           // centraliza msg
 IF RIGHT(MsgCen,1)=","                           // msg foi truncada
  MsgCen=" "+LEFT(MsgCen,LEN(MsgCen)-1)           // tira virgula do final
 ENDI                                             // se existir
 MsgCen=" "+MsgEsq+MsgCen+MsgDir+" "
ELSE
 MsgCen=LEFT(" "+MsgEsq+MsgDir+" ",c_i-c_s-1)     // msg cabe toda na tela
ENDI
@ l_i,c_s+1 SAY MsgCen
SETCOLOR(co_r)
RETU

PROC TELA_ANT  // Prepara volta para tela anterior (PgUp)
IF sistema[op_sis,O_TELA,O_ATUAL]>1      // se for a da primeira tela,
 sistema[op_sis,O_TELA,O_ATUAL]-=2       // decrementa em dois e forca
 KEYB CHR(K_ESC)                         // saida com ESC
 volta=1                                 // volta=1 indica ao chamador
ENDI                                     // que pressionou PGUP
RETU

PROC TELA_SEG  // Prepara o avanco para a tela seguinte (PgDn)
IF sistema[op_sis,O_TELA,O_ATUAL]<sistema[op_sis,O_TELA,O_DEF] // se nao estiver na ultima tela,
 KEYB CHR(K_ESC)                         // forca ESC para sair
 volta=2                                 // volta=2 indica ao chamador
ENDI                                     // que pressionou PGDN
RETU

PROC TIRA_LANC(db_,lan_,for_inv_)  // Retira o lancamento feito no arquivo alvo
LOCAL ar_:=ALIAS(), prg_:=LEFT(db_,3)+"_get1", in_:=1, ord_
for_inv_=IF(for_inv_=NIL,.t.,for_inv_)
IF !EMPTY(SELECT(db_))                       // se o arquiov ja esta aberto
 SELE (db_)                                  // salva a ordem do indice
 in_=INDEXORD()                              // atual
ENDI
ord_=LEN(sistema[EVAL(qualsis,db_),O_CHAVE]) // ultimo indice do dbf (ind lancamento)
IF PTAB(lan_,db_,ord_,.t.)                   // procura o 1o. que existe
 SELE (db_)
 WHILE !EOF() .AND. codlan=lan_              // para todos os registros do lancamento

  #ifdef COM_REDE
   BLOREG(0,.5)                              // bloqueia para sempre
  #endi

  IF for_inv_
   &prg_.(FORM_INVERSA)
  ELSE
   DELE
  ENDI

  #ifdef COM_REDE
   UNLOCK                                    // libera registro
  #endi

  SKIP                                       // proximo registro
 ENDD
ELSE
 SELE (db_)
ENDI
DBSETORDER(in_)                              // retorna p/ o indice atual
IF !EMPTY(ar_)
 SELE (ar_)
ELSE
 SELE 0
ENDI
RETU

PROC FAZ_LANC(db_,lan_,com_seq)  // realiza lancamentos em arquivos
LOCAL ar_:=ALIAS(), dbf_eof

#ifdef COM_REDE
 PRIV  s_cria, s_gera, s_grava, s_arqu
#else
 PRIV  s_gera, s_grava
#endi

com_seq:=IF(com_seq=NIL,.f.,com_seq)
SELE (db_)                        // seleciona dbf alvo do lancamento
dbf_eof = EOF()
IF com_seq                        // existe cp sequencial?

 #ifdef COM_REDE
  s_cria=LEFT(db_,3)+"_CRIA_SEQ"  // prg que cria XXX_seq.dbf
  s_arqu=LEFT(db_,3)+"_SEQ"       // nome arq sequencial
 #endi

 s_gera=LEFT(db_,3)+"_GERA_SEQ"   // prg que gera campo sequencial
 s_grava=LEFT(db_,3)+"_GRAVA_SEQ" // prg que grava campo no arquivo
 FOR i=1 TO FCOU()                // cria/declara privadas as
  msg=FIEL(i)                     // variaveis de memoria com
  PRIV &msg.                      // o mesmo nome dos campos
 NEXT                             // do arquivo
ENDI

#ifdef COM_REDE
 IF com_seq .AND. dbf_eof         // se o dbf tem campo sequencial
  &s_cria.()                      // e vai criar um registro novo
  SELE (db_)                      // cria/seleciona dbf de controle
  &s_gera.()                      // e gera os sequenciais...
 ELSE                             // caso contrario
  com_seq=.f.                     // desabilita cp sequencial
 ENDI
 DO WHIL .t.
  IF dbf_eof                      // se for final do arquivo
   APPE BLAN                      // cria um novo registro
  ELSE
   BLOREG(0,.5)                   // bloqueia o registro
  ENDI
  IF NETERR()                     // erro...
   DBOX(ms_uso,20)                // mensagem ao usuario
   LOOP                           // e tenta novamente
  ENDI
  EXIT
 ENDD
#else
 IF dbf_eof                       // e final de arquivo
  IF com_seq                      // se o dbf tem campo sequencial
   &s_gera.()                     // gera os campos...
  ENDI
  APPE BLAN                       // cria um novo registro
 ELSE
  com_seq=.f.
 ENDI
#endi

IF DELE()                         // registro excluido?
 RECA                             // recupera-o
ENDI
REPL codlan WITH lan_             // atualiza o codigo do lancamento
IF com_seq                        // tem sequencial entao
 &s_grava.()                      // grava no arquivo

 #ifdef COM_REDE
  SELE (s_arqu)
  UNLOCK                          // libera DBF para outros usuarios
  COMMIT                          // atualiza cps sequenciais no disco
 #endi

ENDI
IF !EMPTY(ar_)                    // se existia dbf aberto na area
 SELE (ar_)                       // inicial, vamos seleciona-los
ELSE                              // caso contrario
 SELE 0                           // pega a primeira area livre
ENDI
RETU

PROC MASENHA(lin_menu,col_menu) // manutencao de senhas
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
IF nivelop<3                             // so pode trocar a senha
 TROCASENHA(.f.,usuario)                 // vamos trocar
 RETU
ENDI
op_sis=nss-2                             // gerente pode tudo
cn:=fgrep :=.f.
criterio=""
SELE A                                   // abre dbf de acesos da senhas

#ifdef COM_REDE
 IF !USEARQ(sistema[op_sis+1,O_ARQUI,O_NOME],.f.,20,1)
  RETU                                   // nao abriu... volta ao menu anterior
 ENDI
#else
 USEARQ(sistema[op_sis+1,O_ARQUI,O_NOME])
#endi

#ifdef COM_REDE
 IF !USEARQ(sistema[op_sis,O_ARQUI,O_NOME],.f.,20,1) // abre arq de grupos de senhas
  RETU                                   // falhou... cai fora
 ENDI
#else
 USEARQ(sistema[op_sis,O_ARQUI,O_NOME])
#endi

op_menu=ALTERACAO                        // vamos colocar em modo de alteracao
cod_sos=17
EDIT()                                   // altera dados da senhas
CLOS ALL                                 // fecha todos arquivos abertos
RETU

PROC PWG_incl(reg_cop)  // inclusao no arquivo PWGRUPOS (grupos)
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),dbfseq_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:=""
FOR i=1 TO FCOU()                        // cria/declara privadas as
 msg=FIEL(i)                             // variaveis de memoria com
 PRIV &msg.                              // o mesmo nome dos campos
NEXT                                     // do arquivo
IF reg_cop!=NIL                          // quer repetir todo o reg atual
 FOR i=1 TO FCOU()                       // para cada campo,
  msg=FIEL(i)                            // salva o conteudo
  rep[i]=&msg.                           // para repetir
 NEXT
ELSE
 AFILL(rep,"")                           // eche com valor vazio
ENDI
t_f3_=SETKEY(K_F3,{||rep()})             // repeticao reg anterior
t_f4_=SETKEY(K_F4,{||conf()})            // confirma campos com ENTER
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})     // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})

DO WHIL cabem>0
 rola_t=.f.                              // flag se quer rolar a tela
 SELE PWGRUPOS
 M->pw_grupo="0001"                      // procura proximo numero do grupo
 GO TOP
 DO WHILE !EOF()                         // corre todo dbf e ve qual o valor do maior grupo
  IF VAL(DECRIPT(pw_grupo))>=VAL(M->pw_grupo)
   M->pw_grupo=LPAD(STR(VAL(DECRIPT(pw_grupo))+1),4,[0])
  ENDI
  SKIP                                   // proximo...
 ENDD

 /*
    cria variaveis de memoria identicas as de arquivo, para inclusao
    de registros
 */
 FOR i=2 TO FCOU()
  msg=FIEL(i)
  M->&msg.=IF((fgrep .OR. reg_cop!=NIL).AND.!EMPT(rep[1]),DECRIPT(rep[i]),&msg.)
 NEXT
 DISPBEGIN()                             // vamos apresentar a tela de uma vez so
 PWG_GETS()                              // mostra o grupo
 IMPRELA()                               // imprime telas dos filhos
 PWG_TELA()                              // tela do grupo
 INFOSIS(.t.)                            // exibe informacao no rodape' da tela
 DISPEND()                               // mostra a tela agora...

 cabem=DISKSPACE(;                       // da para incluir mais...
          IF(;
             LEN(sistema[op_sis,O_ARQUI,O_DIR_DBF])<2.OR.sistema[op_sis,O_ARQUI,O_DIR_DBF]="\",;
             0,;
             ASC(sistema[op_sis,O_ARQUI,O_DIR_DBF])-64;
          );
       )
 cabem=INT((cabem-2048)/PWGRUPOS->(RECSIZE()))
 IF cabem<1                              // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPAÄO EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSéO INTERROMPIDA!") // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                  // torna visiveis variaveis de memoria
 PWG_GET1(INCLUI)                        // recebe campos
 SELE PWGRUPOS
 IF LASTKEY()=K_ESC                      // se cancelou
  cabem=0                                // prepara saida da inclusao
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                // vamos bloquear o final do
  SKIP                                   // arq para que nehum outro
  BLOREG(0,.5)                           // usuario possa incluir
 #endi

 APPEND BLANK                            // inclui reg em branco no dbf
 FOR i=1 TO FCOU()                       // para cada campo,
  msg=FIEL(i)                            // salva o conteudo
  rep[i]=M->&msg.                        // para repetir
  REPL &msg. WITH rep[i]                 // enche o campo do arquivo
 NEXT
 ult_reg=RECN()                          // ultimo registro digitado
 SELE PWTABELA
 FOR i=1 TO nss-3                        // inclui todos os dbf no arq de acessos

  #ifdef COM_REDE
   GO BOTT                               // vamos bloquear o final do
   SKIP                                  // arq para que nehum outro
   BLOREG(0,.5)                          // usuario possa incluir
  #endi

  APPEND BLANK                           // inclui reg em branco no dbf de acessos
  REPL pw_grupo WITH M->pw_grupo,;       // enche com o codigo do grupo
       pw_dbf WITH sistema[i,O_MENU]     // titulo do dbf
  REPL pw_dbf WITH ENCRIPT(pw_dbf),;
       pw_permis WITH ENCRIPT(pw_permis) // e as permissoes (todas)
 NEXT

 #ifdef COM_REDE
  UNLOCK                                 // libera o registro e
  COMMIT                                 // forca gravacao
 #else
  IF RECC()-INT(RECC()/20)*20=0          // a cada 20 registros
   COMMIT                                // digitados forca gravacao
  ENDI
 #endi

 SUBNIVEL("PWTABELA")                    // coloca permissoes nas tabelas
 SUBNIVEL("PWUSUA")                      // cadastra os usuarios no gupo
 IF reg_cop!=NIL                         // estava na consulta e quis rep o campo
  EXIT                                   // cai fora...
 ENDI
ENDD

GO ult_reg                               // move para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                       // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC PWG_tela     // tela do arquivo PWGRUPOS
tem_borda=.t.
l_s=Sistema[op_sis,O_TELA,O_LS]        // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)  // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)            // monta caixa da tela
i=LEN(sistema[op_sis,O_MENS])/2
@ l_s,c_s-1+(c_i-c_s+1)/2-i SAY " "+MAIUSC(sistema[op_sis,O_MENS])+" "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "     C¢digo:              Nome:"
RETU

PROC PWG_gets     // mostra variaveis do arquivo PWGRUPOS
LOCAL getlist := {}
PRIV _grupo, _nogrupo
PWG_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
IF EMPTY(pw_grupo)              // se nao esta encriptado
 _grupo=pw_grupo                // aproveita o que esta no arquivo
 _nogrupo=pw_nogrupo
ELSE                            // esta encriptado
 _grupo=DECRIPT(pw_grupo)       // desencripta antes de mostrar
 _nogrupo=DECRIPT(pw_nogrupo)
ENDI
@ l_s+01 ,c_s+15 GET  _grupo;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+01 ,c_s+33 GET  _nogrupo;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

CLEAR GETS
RETU

PROC PWG_get1(tp_mov)     // capta variaveis do arquivo PWGRUPOS
LOCAL getlist := {}
PRIV _grupo, _nogrupo
IF tp_mov=INCLUI                  // esta incluindo ou alterando
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA    // permite mudar posicao da tela
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  IF op_menu=ALTERACAO            // se esta alterando
   _grupo=DECRIPT(pw_grupo)       // desencripta o que esta no dbf
   _nogrupo=DECRIPT(pw_nogrupo)
  ELSE                            // esta incluindo
   _grupo=M->pw_grupo             // pega variaveis de memoria
   _nogrupo=M->pw_nogrupo         // ja desencriptadas
  ENDI
  @ l_s+01 ,c_s+15 GET _grupo;    // mostra codigo do grupo
                   PICT sistema[op_sis,O_CAMPO,01,O_MASC]
  CLEA GETS
  @ l_s+01 ,c_s+33 GET  _nogrupo; // recebe nome do grupo
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                   DEFINICAO 2

  READ
  SET KEY K_ALT_F8 TO             // desabilita alt+f8
  IF rola_t                       // quer rolar a tela
   ROLATELA()                     // entao deixa
   LOOP                           // volta para digiracao
  ENDI
  IF LASTKEY()!=K_ESC .AND. drvincl .AND. op_menu=INCLUSAO
   IF !CONFINCL()                 // confirma inclusao
    LOOP                          // nao confirmou...
   ENDI
  ENDI
  IF op_menu=ALTERACAO                    // na alteracao
   REPL pw_grupo WITH ENCRIPT(_grupo),;   // encripta os campos no dbf
        pw_nogrupo WITH ENCRIPT(_nogrupo)
  ELSE                                    // na inclusao
   M->pw_grupo=ENCRIPT(_grupo)            // encripta na memoria
   M->pw_nogrupo=ENCRIPT(_nogrupo)
  ENDI
  EXIT
 ENDD
ENDI
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
 INTREF(FORM_INVERSA)                     // exclui acessos e usualrios
 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF op_menu!=INCLUSAO                     // se nao esta incluindo
  RECA
  INTREF(FORM_DIRETA)                     // recupera todos os acessos e usuarios
 ENDI
ENDI
RETU

PROC PWT_incl(reg_cop)  // inclusao no arquivo PWTABELA. Nao tem...
RETU

PROC PWT_tela     // tela do arquivo PWTABELA
tem_borda=.t.
l_s=Sistema[op_sis,O_TELA,O_LS]        // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)  // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)            // monta caixa da tela
i=LEN(sistema[op_sis,O_MENS])/2
@ l_s,c_s-1+(c_i-c_s+1)/2-i SAY " "+MAIUSC(sistema[op_sis,O_MENS])+" "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Arquivo                     ≥ Permissîes"
@ l_s+02,c_s+1 SAY "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ"
@ l_s+03,c_s+1 SAY "                             ≥"
@ l_s+04,c_s+1 SAY "                             ≥"
@ l_s+05,c_s+1 SAY "                             ≥"
@ l_s+06,c_s+1 SAY "                             ≥"
@ l_s+07,c_s+1 SAY "                             ≥"
RETU

PROC PWT_gets     // mostra variaveis do arquivo PWTABELA
LOCAL getlist := {}, l_max, reg_atual:=RECNO()
PRIV  l_a:=Sistema[op_sis,O_TELA,O_SCROLL], _dbf, _permis
PWT_TELA()
l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
DO WHILE !EOF() .AND. l_s+l_a<l_max .AND.;
   &(INDEXKEY(0))=IF(EMPT(criterio),"","T")+chv_1
 _dbf=DECRIPT(pw_dbf)
 _permis=DECRIPT(pw_permis)
 @ l_s+l_a,c_s+02 GET  _dbf;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]

 @ l_s+l_a,c_s+32 GET  _permis;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]

 SETCOLOR(drvcortel+","+drvcortel+",,,"+drvcortel)
 l_a++
 SKIP
ENDD
GO reg_atual
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CLEAR GETS
RETU

PROC PWT_get1(tp_mov, excl_rela)     // capta variaveis do arquivo PWTABELA
LOCAL getlist := {}
PRIV  _permis
excl_rela=IF(excl_rela=NIL,.f.,excl_rela) // exclusao do pai?
IF tp_mov=INCLUI
 IF TYPE("l_a")!="N"                      // linha atual do scroll
  l_a=Sistema[op_sis,O_TELA,O_SCROLL]
 ENDI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA            // altera permissoes
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  _permis=DECRIPT(pw_permis)
  @ l_s+l_a,c_s+32 GET  _permis;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3

  READ
  SET KEY K_ALT_F8 TO                     // desabilita alt+f8
  IF rola_t                               // quer rolar a tela
   ROLATELA()                             // entao deixa
   LOOP                                   // volta para digiracao
  ENDI
  IF LASTKEY()!=K_ESC .AND. drvincl .AND. op_menu=INCLUSAO
   IF !CONFINCL()                         // confirma inclusao
    LOOP                                  // nao confirmou...
   ENDI
  ENDI
  REPL pw_permis WITH ENCRIPT(_permis)    // encripta permissoes
  EXIT
 ENDD
ENDI
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA

 #ifdef COM_REDE
  IF !excl_rela                           // esta excluindo o pai
   REPL flag_excl WITH '*'                // coloca uma marca
  ENDI
 #else
  IF !excl_rela                           // esta excluindo o pai
   REPL flag_excl WITH '*'                // coloca uma marca
  ENDI
 #endi

 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (PWGRUPOS->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"PWGRUPOS"),O_MENU]
   ALERTA(2)                              // pai excuido
   DBOX("Registro exclu°do em:"+msg+"|*",,,,,"IMPOSS°VEL RECUPERAR!")
  ELSE
   IF !excl_rela                          // esta recuperando o pai
    IF op_menu=INCLUSAO                   // desfaz a flag
     flag_excl=' '
    ELSE
     REPL flag_excl WITH ' '
    ENDI
   ENDI
   IF op_menu!=INCLUSAO                   // se nao esta incluindo
    RECA                                  // recura o registro
   ENDI
  ENDI
 ENDI
ENDI
RETU

PROC ERRORSYS()   // Mensagem de erro durante a execucao da aplicacao
ERRORBLOCK({|erro| ERROMSG(erro)})
RETU

* \\ Final de ADR_PROC.PRG
// troca_nome