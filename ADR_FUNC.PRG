procedure adr_func
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform†tica - Limeira (019)452.6623
 \ Programa: ADR_FUNC.PRG
 \ Data....: 29-01-04
 \ Sistema.: Administradora - RECEPÄÑO
 \ Funcao..: Funáîes auxiliares
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

/*
   Sintaxe: PTAB( <ExpC1>, <ExpC2> [,ExpN] [,ExpL] )
   Funcao.: Executa pesquisa em tabelas
              ExpC1 = chave de pesquisa
              ExpC2 = arquivo alvo
              ExpN  = numero do indice associado a ExpC2
              ExpL  = se .t. deixa na ordem do indice do parametro
  
   Retorna: .t. se o registro existe
*/
FUNC PTAB(ch_,db_,or_dem,fix_ind_)
LOCAL ar_:=SELECT(), in_, sem_dbf:=ALIAS(), achou, del_a:=SET(_SET_DELETED,.f.), reg_
or_dem=IF(or_dem=NIL,1,or_dem)
fix_ind_=IF(fix_ind_=NIL,.f.,fix_ind_)
IF !USEARQ(db_)            // tenta abrir DBF e seus indices
 RETU (.f.)                // retorna .f. se nao conseguiu
ENDI
in_=INDEXORD()             // salva ordem atual
DBSETORDER(or_dem)         // seta nova ordem dos indices
SEEK ch_                   // procura o registro
achou=.F.                  // flag se achou
IF FOUND()                 // achou... Verif todos da mesma chave
 reg_=RECNO()              // salva registro atual
 DO WHILE !EOF() .AND. &(INDEXKEY(0))=ch_
  IF !DELE()               // este nao esta excluido..
   EXIT                    // cai fora
  ENDI
  SKIP                     // verifica o proximo
 END
 achou=(&(INDEXKEY(0))=ch_) // se for mesma chave entao achou
 IF !achou                 // se nao achou
  GO reg_                  // volta para o reg excluido
 ENDI
ELSE
 IF !EOF()                 // se nao for final do arquivo
  GO BOTT                  // vamos forcar
  SKIP
 ENDI
ENDI
IF !fix_ind_               // se nao quer deixar na ordem da pesquisa
 DBSETORDER(in_)        // retorna ordem original
ENDI
IF EMPTY(sem_dbf)          // se area anterior estiver vaga
 SELE 0                    //  seleciona proxima area vaga
ELSE                       // senao
 SELE (ar_)                //  seleciona area anterior
ENDI
SET(_SET_DELETED,del_a)    // retorna a visibilidade dos excluidos
RETU achou

/*
   Sintaxe: USEARQ( <ExpC> [,ExpL1] [,ExpN1], [,ExpN2] [,ExpL2] )
   Funcao.: Abre arquivo de dados e seus °ndices associados
              ExpC  = nome do arquivo
              ExpL1 = .t. abre modo exclusivo
              ExpN1 = num de vezes que sera tentada a abertura
              ExpN2 = tempo em segundos entre as tentativas de abertura
              ExpL2 = .t. abre associando os ntx
   Retorna: .t. se abriu o arquivo
*/
FUNC USEARQ(db_,use_ex,n_tent,t_tent,com_ntx)
LOCAL op_sis, qt_ind, p_, drv_dbf, p_sempre, v_r, msg,;
      ind01, ind02, ind03, ind04
n_tent=IF(n_tent=NIL,0,n_tent)
t_tent=IF(t_tent=NIL,1,t_tent)
com_ntx=IF(com_ntx=NIL,.t.,com_ntx)
use_ex=IF(use_ex=NIL,.f.,use_ex)
p_sempre=(n_tent=0)
n_ant=n_tent
v_r=.f.
op_sis=EVAL(qualsis,db_)                   // obtem subscricao do DBF no vetor Sistema
IF op_sis>0                                // tem drives
 drv_dbf=sistema[op_sis,O_ARQUI,O_DIR_DBF] // drive de dados
 drv_ntx=sistema[op_sis,O_ARQUI,O_DIR_NTX] // drive dos indices
ELSE                                       // nao tem drives, pega default
 drv_dbf=drvdbf                            // drive de dados
 drv_ntx=drvntx                            // drive dos indices
ENDI
IF "\" $ db_                               // verifica se passou diretorio + arquivo
 p_=RAT("\",db_)
 drv_dbf=LEFT(db_,p_)                      // pega diretorio passado e
 db_=SUBS(db_,p_+1)                        // o nome do arquivo
ENDI
IF EMPTY(SELECT(db_))                      // o arquivo nao esta' em uso, vamos abri-lo...
 db_f=drv_dbf + db_
 SELE 0                                    // seleciona proxima area livre

 #ifdef COM_REDE
  msgt="OUTRO USUèRIO ACESSANDO|O ARQUIVO"
  DO WHIL n_tent>=0 .OR. p_sempre          // tenta abrir o aruivo n vezes ou p/ sempre
   IF use_ex                               // tenta abrir com exclusividade
    USE (db_f) EXCLUSIVE
   ELSE                                    // tenta abrir compartilhado
    USE (db_f) SHARED
   ENDI
   IF ! NETERR()                           // abriu sem problemas
    v_r=.t.
    EXIT
   ENDI
   DBOX("Tentando abrir|"+;                // avisa usuario, espera n_tent
        IF(p_sempre,"(NéO","(ESC")+;       // segundos para tentar novamente
        " cancela)",15,,t_tent,,msgt)
   n_tent-=t_tent
   IF !p_sempre .AND. LASTKEY()=K_ESC      // se nao for para sempre e quer
    EXIT                                   // cancelar, nao tenta abrir mais
   ENDI
  ENDD
  CLEA TYPEAHEAD                           // limpa o buffer do teclado
  IF ! v_r                                 // se nao conseguiu abrir o arquivo
   RETU (.f.)                              // retorna falso
  ENDI
 #else
  USE (db_f)                               // abre o arquivo
 #endi

 IF com_ntx                                // abre arquivo com os indices
  IF op_sis=0                              // se o arquivo e' externo ao sistema...
   v_r=AT(".",db_)                         //  tira extensao do arquivo
   n_t_x=IF(v_r>0,LEFT(db_,v_r-1),db_)     //  caso exista
   nt_x=drv_dbf+LEFT(n_t_x,7)+"1"          //  verifica se existe arquivo
   IF FILE(nt_x+EXTENSAO())                //  se existir indice com nome xxx1.ntx,
    SET INDE TO (nt_x)                     //   vamos usa-lo
    DBSETORDER(1)
   ELSE                                    //  se nao procura
    nt_x=drv_dbf+LEFT(n_t_x,7)             //  indice com
    IF FILE(nt_x+EXTENSAO())               //  nome xxx.ntx, usa
     SET INDE TO (nt_x)
     DBSETORDER(1)
    ENDI
   ENDI
  ELSEIF LEN(sistema[op_sis,O_INDIC])>0    // senao, abre indices segundo vetor sistema
   qt_ind=LEN(sistema[op_sis,O_INDIC])
   ind01=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,1]
   IF qt_ind=1
    SET INDE TO (ind01)
   ELSE
    ind02=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,2]
    IF qt_ind=2
     SET INDE TO (ind01), (ind02)
    ELSE
     ind03=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,3]
     IF qt_ind=3
      SET INDE TO (ind01), (ind02), (ind03)
     ELSE
      ind04=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,4]
      IF qt_ind=4
       SET INDE TO (ind01), (ind02), (ind03), (ind04)
      ENDI
     ENDI
    ENDI
   ENDI
   DBSETORDER(1)
  ENDI
 ENDI
ELSE
 SELE SELECT(db_)                          // arquivo ja' estava aberto
ENDI
RETU .t.                                   // deu tudo certo...

/*
   Sintaxe: CRIT( <ExpC1> <,ExpN> [,ExpC2] )
   Funcao.: Executa validacao de campos/ mostra formulas na tela
              ExpC1 = expressao de validacao e a mensagem a ser mostrada
                      separados separadas pelo caracter "~".
              ExpN  = linha onde sera mostrada a mensagem
              ExpC2 = formulas a serem mostradas na tela. ("nn|nn|nn|...",
                      "nn"=num das f¢rmulas especificadas no vetor "sistema"
   Retorna: .t. se critica ok
*/
FUNC CRIT(msgc,li,form_)
LOCAL cond, msg, flag:=.t., no_gets, i_
PRIV  l, c
no_gets=(RIGHT(PROCNAME(1),5)="_GETS")        // flg se nao esta consultando
IF !EMPT(msgc) .AND. !("V"==msgc) .AND. !("I"==msgc)
 li=IF(li=NIL.OR.li>MAXROW()-5,MAXROW()-5,li) // ajusta linha da mensagem
 msg =SUBS(msgc,AT("~",msgc)+1)               // mensagem a mostrar
 cond=LEFT(msgc,AT("~",msgc)-1)               // condicao de validacao
 IF !(&cond.)                                 // se condicao nao satisfeita,
  IF !no_gets                                 // se tem msg para mostrar
   IF LEN(TRIM(msg))>0                        // se tem msg para mostrar
    ALERTA()                                  // beep, beep, beep
    DBOX(msg,li,,,,"ATENÄéO! "+usuario)       // avisa ao usuario
   ENDI
   flag=.f.                                   //  retornando falso
  ENDI
 ENDI
ENDI
IF flag .AND. form_!=NIL                      // validacao ok e tem formulas
 DO WHIL LEN(form_)>0                         // mostraremos todas ...
  i_=VAL(PARSE(@form_,"|"))                   // pega subscricao da formula
  IMP_FORM(sistema[op_sis,O_FORMULA,i_])      // imprime a formula
 ENDD
ENDI
RETU flag                                     // retorna ok se validacao ok

/*
   Sintaxe: EDITA( <N1> <,N2> <,N3> <,N4> <,ExpL|ExpC1> <,Arr1> <,Arr2> <,ExpC2> <,ExpC3> <,ExpC4> <,ExpL1> )
   Funcao.: Apresenta a tela de consulta no objeto "TBrowse" com diversos recursos.
              N1,N2,N3,N4 = coordenadas da janela de consulta
               ExpL|ExpC1 = rotinas nao acessadas
                     Arr1 = arranjo de campos a apresentar na janela
                     Arr2 = titulos dos campos de Arr1
                    ExpC2 = filtro inicial
                    ExpC3 = ordem inicial
                    ExpC4 = condicao para marcar o registros
                    ExpL1 = .t.=letras pesq - .f.=letras fazem acao
   Retorna: NIL
*/
FUNC EDITA(li_supp,co_supp,li_infp,co_infp,mo_difp,coluna_cp,coluna_tit,cr_,ord_,cdmr_)
LOCAL op_sy_:=op_sis, cor_orig, i_, t_f8, dele_atu:=SET(_SET_DELETED)
PRIV cp_:="", cond_p:="", tit_cons:={"",""}, db_1rela:="", cpord, qual_prg,;
     db_2rela:="", cpord:="", criterio:="", ind_ord:=1, ind_rela:=1, chvpesq:="",;
     grava_db:=.f., op_db:=1, volta_db, ch_tecl:="05042419", op_menu:=PROJECOES,;
     di_tecl:="24262527", br_reg_ori, br_reg_out, brw_tempo, brw_ant:=brw,;
     col_cp:=coluna_cp,col_tit:=coluna_tit, li_sup:=li_supp, vr_edita, cr_ini:=cr_,;
     li_inf:=li_infp, co_sup:=co_supp, co_inf:=co_infp, posi_cur, cmr_:=cdmr_,;
     mo_dif:=mo_difp, hlp_cod:=cod_sos, dir_cur:=3, chv_rela:=""
IF ! USED()                          // se nao existir arquivo
 RETU .f.                            // aberto, cai fora
ENDI
aux:=[]
qual_prg=PROCNAME(1)                 // nome do prg que chamou a funcao
cr_ini=IF(cr_ini=NIL,"",cr_ini)      // filtro inicial nao informado
cmr_=IF(cmr_=NIL,"1=2",cmr_)         // tem condicao de marcar registros?
cpord=IF(ord_=NIL,"",ord_)           // tem ordem inicial?
FOR i_=1 TO FCOU()                   // declara privados todos os
 msg=FIELD(i_)                       // campos do arquivo da consulta
 PRIV &msg.
NEXT

#ifdef COM_MOUSE
 IF drvmouse
  DO WHIL MOUSEGET(0,0)!=0           // se qualquer botao do mouse
  ENDD                               // estiver pressionado espera
 ENDI                                // liberacao
#endi

brw=.t.                              // pega posicao atual da tela
vr_edita=NOVAPOSI(@li_sup,@co_sup,@li_inf,@co_inf)
mo_dif=IF(mo_dif=NIL,.t.,mo_dif)     // trata as rotinas
IF TYPE("mo_dif")="L"                // que nao poderao
 IF !mo_dif                          // ser acessadas
  mo_dif="DERMG"                     // durante a consulta
 ELSE
  mo_dif=""
 ENDI
ENDI
cor_orig=SETCOLOR()                  // salva cor original
brw_reg=RECN()                       // registro atual
volta_db=.t.
IF LEN(cr_ini)>0                     // tem filtro inicial?
 i_=SELECT()                         // salva area atual
 estr_dbf:=DBSTRUCT()                // pega estrutura do dbf aberto
 i=INDEXORD()                        // indice atual
 IF i>LEN(sistema[EVAL(qualsis,ALIAS()),O_ORDEM]) // se esta usando ind tmp
  i=1                                // pega o primeiro
 ENDI
 x_=sistema[EVAL(qualsis,ALIAS()),O_ORDEM,i] // campos do indice
 SELE 0                              // vai para primeira area vazia
 p=1                                 // separa filtro inicial para
 DO WHILE .t.                        // verificar se tem congruencia com o indice
  i=AT("=",SUBS(cr_ini,p))           // campo do filtro
  IF i=0                             // epa! condicao invalida
   chv_rela=""                       // cai fora
   EXIT
  ENDI                               // campo do filtro verifica se ele e' um
  cp_=ALLTRIM(SUBS(cr_ini,p,i-1))    // nome valido e se o indice e formado por ele
  IF AT("+",cp_)>0 .OR. AT("(",cp_)>0 .OR. AT(")",cp_)>0 .OR.;
     AT(".",cp_)>0 .OR. AT(",",cp_)>0 .OR. AT(" ",cp_)>0 .OR.;
     LEN(x_)=0 .OR. !(UPPER(cp_)==UPPER(estr_dbf[VAL(LEFT(x_,2)),1]))
   chv_rela=""                       // campo ilegal
   EXIT                              // cai fora
  ENDI
  x_=SUBS(x_,3)                      // proximo campo do indice
  p+=i
  i=AT(".AND.",SUBS(UPPER(cr_ini),p))// pode ter mais de um campo filtrando
  IF i=0                             // nao tem
   i=LEN(cr_ini)-p+2                 // pega todo o tamanho do filtro
  ENDI
  cond_p=ALLTRIM(SUBS(cr_ini,p,i-1)) // segundo opereando e' valido...
  IF AT("+",cond_p)>0 .OR. AT("(",cond_p)>0 .OR. AT(")",cond_p)>0 .OR.;
     AT(".",cond_p)>0 .OR. AT(",",cond_p)>0 .OR. AT(" ",cond_p)>0
   chv_rela=""
   EXIT                              // se nao cai fora
  ENDI
  p+=i+4                             // ajusta proximo campo
  &cp_.=&cond_p.                     // faz variavel=segundo operando
  IF LEN(chv_rela)>0                 // se ja tem relacionamento
   chv_rela=chv_rela+"+"             // concatenda com um "+"
  ENDI
  chv_rela+="M->"+cp_                // finge que e dbf relacionado
  IF p>=LEN(cr_ini)                  // se nao tem mais filtro
   EXIT                              // cai fora...
  ENDI
 ENDD
 SELE (i_)
 cp_:=cond_p := ""                   // inicializa variaveis
ENDI
IF LEN(cr_ini)>0 .AND. LEN(chv_rela)=0 // se tem filtro e nao consegui relacionar
 criterio=cr_ini                       // vamos preparar para indexar
ENDI

#ifdef COM_REDE
 brw_tempo=drvtempo                  // tempo de "refresh"
#endi

t_f8=SETKEY(K_ALT_F8,NIL)            // salva/reseta tecla ALT-F8
BRWFUNC(PROCNAME(1)!="VDBF")         // funcoes auxiliares
SETKEY(K_ALT_F8,t_f8)                // seta tecla ALT-F8

#ifdef COM_REDE
 IF brw_tempo!=drvtempo              // se alterou o tempo de "refresh"
  SAVE TO (arqconf) ALL LIKE drv*    // salva em disco
 ENDI
#endi

SETCOLOR(cor_orig)                   // restaura cor original
op_sis = op_sy_
SET KEY K_TAB TO                     // resta TAB
brw=brw_ant
SET(_SET_DELETED,dele_atu)           // SET DELE=anterior
RETU .t.

/*
   Sintaxe: MOV_PTR( <ExpN> )
   Funcao.: Move o ponteiro em arquivo relacionado e ou filtrado
              ExpN  = numero de registros para mover o ponteiro
   Retorna: Num de registros pulados
*/
FUNC MOV_PTR(a_pular)
LOCAL ja_pulado := 0, chv_
IF a_pular = 0                             // nao vai pular registros
 SKIP 0
ELSE                                       // vai pular registros...
 chv_=&("{||"+INDEXKEY(0)+"=["+;           // so servem os registro que
      IF(EMPT(criterio),"","T")+chv_1+"]}")// atendao ao filtro/relacao
 DO WHILE !EOF() .AND. !BOF() .AND.;       // pula qtos reg's forao pedidos
    a_pular != ja_pulado .AND. EVAL(chv_)  // ate eof ou fora filtro/relacao
  IF a_pular > 0                           // pulando para frente
   SKIP
   ja_pulado++                             // conta quando foroa pulados
  ELSE                                     // pulando para traz
   SKIP -1
   ja_pulado--                             // menos um pulado
  ENDI
 ENDD
 IF !EVAL(chv_) .OR. EOF() .OR. BOF()      // reg nao atende filtro/relacao
  IF a_pular > 0                           // esta pulando para frente
   FIM_ARQ()                               // acha o fim do arquivo
   ja_pulado--                             // decrementa um na qde de reg pulados
  ELSE                                     // pulando para traz
   INI_ARQ()                               // acha o inicio do arquivo
   ja_pulado++                             // incrementa um na qde de reg pulados
  ENDI
 ENDI
ENDI
RETU ja_pulado                             // retorna a qde exata de reg pulados

/*
   Sintaxe: CABBRW()
   Funcao.: Monta cabecalho da consulta
   Retorna: NIL
*/
STATIC FUNC CABBRW
br_w:headsep:=chr(205)+chr(209)+chr(205)  // separador do cabecalho (Õ—Õ)
br_w:colsep:=" "+chr(179)+" "             // separador das colunas  ( ≥ )
op_sis=EVAL(qualsis,ALIAS())              // subscricao do arquivo atual
br_w:cargo:={"","","",INDEXORD()}         // salva alguns parametros da consulta
RETU NIL

/*
   Sintaxe: MONTABRW()
   Funcao.: Monta janela de visualizaáÑo da consulta
   Retorna: NIL
*/
STATIC FUNC MONTABRW()
LOCAL id_carg:={}
op_sis   = EVAL(qualsis,ALIAS())       // subscricao do arquivo atual
arq_cor  = LEFT(ALIAS(),3)             // prefixo do arquivo
id_carg  = br_w:cargo                  // variaveis da consulta
criterio = id_carg[1]                  // filtro
cpord    = id_carg[2]                  // ordenacao
chv_rela = id_carg[3]                  // relacao
ind_ord  = id_carg[4]                  // indice atual
cmr_     = id_carg[5]                  // marcacao de registros
DBSETORDER(ind_ord)                    // escolhe o indice atual
PEGACHV2()                             // pega final do relaciomento
SETCOLOR(drvcorbox)                    // cor da janela selecionada

#ifdef COM_MOUSE
 IF drvmouse                           // define area de atuacao do mouse
  MOUSEBOX(br_w:ntop-1,br_w:nleft-1,br_w:nbottom+1,br_w:nright+1)
 ENDI
#endi


/*
   Monta janela de consulta e mensagens de status e teclas disponiveis
   nas suas bordas
*/
CAIXA(mold+CHR(0),br_w:ntop-2, br_w:nleft-1, br_w:nbottom+1, br_w:nright+1)
@ br_w:ntop-2,br_w:nleft SAY IF(EMPTY(criterio),"{Qde="+LTRIM(STR(RECC(),10))+"}",REPL(SUBS(mold,2,1),11))
msg="TAB [ ],F10"+IF(SETKEY(K_F8)=NIL,"",",F8")+IF((M->v_out.AND.tem_t).OR.!M->v_out,",F9","")

#ifdef COM_MOUSE
 IF drvmouse                           // botoes do mouse
  msg+=" "+CHR(174)+" "+CHR(175)+" "+CHR(30)+" "+CHR(31)+" "+CHR(24)+" "+CHR(26)+" "+CHR(25)+" "+CHR(27)+" "+CHR(18)
 ENDI
#endi

msg=LEFT(msg,br_w:nright-br_w:nleft)
posi_cur=INT((br_w:nright-br_w:nleft-LEN(msg))/2)
@ br_w:nbottom+1,br_w:nleft+posi_cur SAY msg
@ br_w:nbottom+1,br_w:nleft+posi_cur+5 SAY CHR(VAL(SUBS(di_tecl,dir_cur*2-1,2)))
x=br_w:nright-br_w:nleft+1
@ br_w:ntop-1,br_w:nleft SAY PADC(MAIUSC(tit_cons[IF(br_w == br_origem,1,2)]),x,' ')
RETU NIL

/*
   Sintaxe: FORCABRW( <ExpL> )
   Funcao.: Reimprime dados da funcao EDITA()
              ExpL = se .t. reimprime inclusive a moldura.
   Retorna: NIL
*/
STATIC FUNC FORCABRW(imp_cx)
LOCAL id_carg:={}
PRIV op_sis, chv_1, chv_2, criterio, cpord, chv_rela, cmr_, chv_1, chv_2
COMMIT
IF br_outro != NIL               // se a 2a. janela estiver aberta
 TROCA_BRW()                     // troca janela do browse

 #ifdef COM_REDE
  COMMIT                         // forca atualizacao em disco
 #endi

 id_carg = br_w:cargo            // retira da variavel de instancia
 criterio=id_carg[1]             // o filtro que tinha
 cpord=id_carg[2]                // a ordenacao
 chv_rela=id_carg[3]             // a relacao
 ind_ord=id_carg[4]              // indice utilizado
 cmr_=id_carg[5]                 // e a marcacao de registros
 DBSETORDER(ind_ord)
 op_sis=EVAL(qualsis,ALIAS())    // obtem subscricao do DBF no vetor Sistema
 PEGACHV2()                      // pega final do relaciomento
 IF imp_cx                       // reimprime moldura da janela
  SETCOLOR(drvcortna)
  br_w:colorspec := drvcortna+","+INVCOR(drvcortna)+","+drvcorenf+","+drvcorget+","+drvcorhlp
  CAIXA(mold+CHR(0),br_w:ntop-2, br_w:nleft-1, br_w:nbottom+1, br_w:nright+1)
  x=br_w:nright-br_w:nleft+1
  @ br_w:ntop-1,br_w:nleft SAY PADC(MAIUSC(tit_cons[IF(br_w == br_origem,1,2)]),x,' ')
 ENDI
 IF DELE().AND.SET(_SET_DELETED) // registro esta apagado e nao visivel
  MOV_PTR(-1)                    // acha o 1o. reg nao apagado
 ENDI
 br_w:refreshall()               // forca atualizacao da tela nao selecionada
 br_w:forcestable()              // apresenta os dados
 br_w:dehilite()                 // liga barra cursora
 TROCA_BRW()                     // troca janela do browse
ENDI
RETU NIL

/*
   Sintaxe: ABREOUTRO( <ExpN> )
   Funcao.: Abre segunda janela de consulta
              ExpN = subscricao do arquivo dentro vetor "sistema"
   Retorna: .t. se teve sucesso
*/
STATIC FUNC ABREOUTRO(op_s)
LOCAL ar_, c_1, c_2
ar_=UPPER(sistema[op_s,O_ARQUI,O_NOME]) // nome do arquivo da consuta

#ifdef COM_REDE
 IF !USEARQ(ar_,.f.,20,1)               // se nao conseguiu abrir o arquivo
  DBOX(ms_uso,20)                       // avisa
  SELE (m_origem)                       // retorna para o DBF original
  RETU .f.                              // e retorna
 ENDI
#else
 USEARQ(ar_)                            // abre DBF da consulta
#endi

outro_db=ALLTRIM(STR(SELEC(ar_)))       // salva area do arquivo aberto
SELE (m_origem)
M->tp=li_sup+INT((li_inf-li_sup-1)/2)+1 // linha de divisao das janelas
br_reg_ori=RECNO()                      // salva registro do DBF original
br_w:dehilite()                         // apaga barra cursora
br_w:nbottom := M->tp - 2               // final da janela do DBF original
br_w:configure()                        // seta remontagem da janela
c_1=br_w:nleft                          // salva coordenadas da direita
c_2=br_w:nright                         // e da esquerda para a nova janela
SELE (outro_db)                         // novo arquivo
GO TOP                                  // monta browse da nova consulta
br_outro=TBROWSENEW(M->tp+1,c_1,li_inf,c_2)
br_outro:colorspec := drvcorbox+","+INVCOR(drvcorbox)+","+drvcorenf+","+drvcorget+","+drvcorhlp
br_w=br_outro                           // browse atual
CABBRW()                                // monta janela do novo browse
RETU .t.                                // e retorna

/*
   Sintaxe: MOSTRA_RELA()
   Funcao.: Verifica se a janela de baixa esta relacionada e
            se e' necessario mostra os seus registros
   Retorna: .t. se preciso remonta-la
*/
STATIC FUNC MOSTRA_RELA()
LOCAL ok:=.f.
PRIV chv_rela, criterio, cpord, cmr_, chv_1, chv_2, op_sis
IF TYPE("br_outro")="O"                       // tem outra janela aberta?
 id_carg = br_outro:cargo
 IF !EMPT(id_carg[3])                         // a janela esta relacionada?
  criterio = id_carg[1]                       // restabelece o filtro
  cpord    = id_carg[2]                       // ordem e a
  chv_rela = id_carg[3]                       // relacao entre as janelas
  cmr_     = id_carg[5]                       // marcacao de registros
  SELE (outro_db)                             // seleciona dbf da janela
  op_sis=EVAL(qualsis,ALIAS())                // sua subscricao no vetor sistema
  PEGACHV2()                                  // acha o inicio/fim da relacao
  IF chv_1 != &chv_rela .OR. !br_outro:stable // precisa remonta-la?
   INI_ARQ()                                  // acha o inicio da relacao
   br_reg_out = RECNO()                       // salva reg atual
   br_outro:rowpos := 1                       // cursor na 1a. lin do browse
   ok:=.t.                                    // tem que remontar a janela
  ENDI
  SELE (m_origem)                             // seleciona janela superior
 ENDI
ENDI
RETU ok

/*
   Sintaxe: BRWFUNC( [ExpL] )
   Funcao.: Diversas funcoes auxiliares da EDITA()
              ExpL = .t./omitida le consultas gravadas
   Retorna: NIL
*/
STATIC FUNC BRWFUNC(nao_vdbf)
LOCAL br_w1, brw_tela, cri_ant, brw_reg, cp_exp:={}, estr_dbf:={}, tps,;
      tecl_p, l_sup, l_inf, m_od, arqexp, dli_exp, id_carg:={}, q_tela,;
      just_memo, Li:=1, Co:=1, ppp:=0, pp:=0, t, i, l_m, Tp_Sai,t_f8,;
      tit_rel, brw_fundo:=SAVESCREEN(0,0,MAXROW(),79), dele_atu, x_, y_,;
      cmr_ant, getlist:={}, cont_mod, cur_atual, nao_pesq:=.f., ind_ok
PRIV cp_, cp_titu, cp_masc, cp_crit, cp_when, cp_help, cp_cmd, tp_cp, br_w,;
     fg_loc:=.f., volta_db:=.t., arq_cor:=LEFT(ALIAS(),3), br_origem,;
     br_outro:=NIL, m_origem, outro_db:=NIL, chv_1:="", chv_2:="", l_s,;
     c_s, l_i, c_i, db_zoom:=.f., br_arq:="", br_tit:="", _pesq:=drvpesq,;
     st_pesq:="", blk_, blk_a
m_origem = ALLTRIM(STR(SELEC()))
br_origem = TBROWSENEW(li_sup,co_sup,li_inf,co_inf)
br_origem:colorspec := drvcorbox+","+INVCOR(drvcorbox)+","+drvcorenf+","+drvcorget+","+drvcorhlp
br_w = br_origem
CABBRW()                                      // monta cabecalho da consulta
tit_cons[1]=sistema[op_sis,O_MENS]            // titulo da janela
nao_vdbf=IF(nao_vdbf=NIL,.t.,nao_vdbf)        // trata parametro
IF !nao_vdbf                                  // veio do VDBF()
 _pesq=drvpvdbf                               // coloca pesquisa como default
ENDI
IF !LDBEDIT(nao_vdbf)                         // menu de consultas gravadas
 RETU NIL
ENDI
col_cp:=col_tit := NIL
tb = {{K_DOWN,      {||br_w:down()}},;        // vetor contendo as teclas
      {K_UP,        {||br_w:up()}},;          // e suas acoes
      {K_PGDN,      {||br_w:pagedown()}},;
      {K_PGUP,      {||br_w:pageup()}},;
      {K_CTRL_PGUP, {||br_w:gotop()}},;
      {K_CTRL_PGDN, {||br_w:gobottom()}},;
      {K_RIGHT,     {||br_w:right()}},;
      {K_LEFT,      {||br_w:left()}},;
      {K_HOME,      {||br_w:home()}},;
      {K_END,       {||br_w:end()}},;
      {K_CTRL_LEFT, {||br_w:panleft()}},;
      {K_CTRL_RIGHT,{||br_w:panright()}},;
      {K_CTRL_HOME, {||br_w:panhome()}},;
      {K_CTRL_END,  {||br_w:panend()}};
     }
volta_db=.t.
MONTABRW()                                    // inicializa tbrowse
DO WHILE volta_db
 SETCOLOR(drvcorbox)
 SET CURSO OFF                                // apaga cursor da tela
 DO WHILE !br_w:stabilize() .AND. NEXTKEY()=0 // apresenta dados na tela
 ENDD
 x_ = COL() ; y_ = ROW()                      // salva posicao atual do cursor
 READINSERT(.f.)                              // retira o "insert"
 t = SUBS(mold,2,1)
 msg=IF(_pesq,"{*Procura*}",IF(EMPTY(criterio),"{Qde="+LTRIM(STR(RECC(),10))+"}",""))
 @ br_w:ntop-2,br_w:nleft SAY LEFT(msg+REPL(SUBS(mold,2,1),11),11)
 IF br_w:nleft+22<br_w:nright                 // msg no canto superior esquerdo
  @ br_w:ntop-2,br_w:nleft+12 SAY IF(DELE(),"{Exclu°do}",REPL(t,10))
 ENDI
 IF br_w:nleft+31<br_w:nright                 // msg inicio/fim de arq no centro
  msg=IF(br_w:hittop,"{In°cio}",IF(br_w:hitbottom,"{Final}"+t,REPL(t,8)))
  @ br_w:ntop-2,br_w:nleft+23 SAY msg
 ENDI
 IF br_w == br_origem .AND. br_w:stable       // esta na janela superior
  IF MOSTRA_RELA()                            // e' preciso refazer janela de baixo
   FORCABRW(.f.)                              // entao vamos la...
  ENDI
 ENDI
 IF LEN(st_pesq)>0                            // se esta pesquisando
  SEPARA(br_w:getcolumn(br_w:colpos):cargo)   // separa nome do campo
  IF LEN(st_pesq) <= br_w:getcolumn(br_w:colpos):width // da p/ imprimir...
   i_=SETCOLOR(drvcorenf)                     // coloca cor enfatizada
   t=1
   l_m=TRAN(&cp_.,cp_masc)                    // conteudo da coluna
   FOR j=1 TO LEN(l_m)                        // ajustando com a mascara
    IF SUBS(st_pesq,t,1)=SUBS(l_m,j,1)        // vamos ver quantos
     t++                                      // caracteres vamos colorir...
     IF t>LEN(st_pesq)                        // chegamos ao fim da pesquisa
      @ y_,x_ SAY LEFT(l_m,j)                 // imprime colorido
      EXIT
     ENDI
    ENDI
   NEXT
   SETCOLOR(i_)                               // volta para cor normal
  ENDI
 ENDI
 cod_sos=hlp_cod

 #ifdef COM_MOUSE
  tecl_p=MOUSETECLA(br_w:ntop-1,br_w:nleft-1,; // aguarda com controle de mouse
                    br_w:nbottom+1,br_w:nright+1,.f.;
         )
  MOUSEGET(@li,@co)                            // salva posicao atual do mouse
  IF tecl_p=CLICK                              // se botao esquerdo foi pressionado
   t=br_w:rowpos; colpos_=br_w:colpos          // salva linha/coluna atual
   br_w:dehilite(); tecl_p=0                   // desliga cursor do browse
   br_w:rowpos:=t+li-y_                        // linha do clique
   FOR i=br_w:rightvisible TO br_w:leftvisible STEP -1
    br_w:dehilite()                            // deliga/liga cursor da coluna para
    br_w:colpos:=i                             // pegar as nova coordenadas do cursor
    br_w:hilite()
    IF COL()-1<=co                             // a coluna do clique e' esta?
     tecl_p=1                                  // flag fim da procura
     EXIT                                      // e sai do FOR...
    ENDI
   NEXT
   IF tecl_p=0 .AND. Br_w:freeze>0             // se ainda nao achou a coluna
    FOR i=br_w:freeze TO 1 STEP -1             // verifica se esta' nas colunas
     br_w:dehilite()                           // congeladas
     br_w:colpos:=i
     br_w:hilite()
     IF COL()-1<=Co                            // achamos a coluna do clique
      EXIT
     ENDI
    NEXT
   ENDI
   IF t=br_w:rowpos .AND. colpos_=br_w:colpos  // clicou duas vezes na mesma
    KEYB CHR(77)                               // coluna entao forca modificacao
   ENDI
   tecl_p=0                                    // nao faz nada
  ENDI
 #else

  #ifdef COM_REDE
   tecl_p=IN_KEY(drvtempo)                    // espera tecla ser digitada
  #else
   tecl_p=IN_KEY(0)                           // espera tecla ser digitada
  #endi

 #endi

 #ifdef COM_REDE
  IF tecl_p=0                                  // nao teclou nada, sai pelo
   br_w:refreshall()                           // tempo de "refresh" entao
   FORCABRW(.f.)                               // forca reimpressao dos dados
   LOOP                                        // na tela e volta
  ENDI
 #endi

 IF SETKEY(tecl_p)!=NIL .AND. tecl_p!=K_F3     // executa funcao associada a
  EVAL(SETKEY(tecl_p))                         // tecla digitada se existir
  tecl_p=0                                     // nao faz mais nada
 ENDI
 SET CURSO ON                                  // acende o cursor
 nm = ASCAN(tb,{|ve_a| tecl_p = ve_a[1]})      // verifica se tecla esta
 IF nm != 0                                    // no vetor de teclas progamadas
  st_pesq := ""                                // limpa pesq por palavra
  IF tb[nm,2]!=NIL                             // em caso afirmativo,
   EVAL(tb[nm,2])                              // executa a funcao definida para
  ENDI                                         // a tecla
 ELSE
  br_w:dehilite()                              // apaga barra cursora
  nao_pesq=.f.                                 // flag - tudo normal
  IF tecl_p=K_F10
   st_pesq := ""                               // limpa pesq por palavra
   SET CURS OFF                                // desliga cursor
   tbmenu="PFDMERVNAIOQL"+IF(fg_loc,"S","")+;
          "GCTJXZB"

   #ifdef COM_REDE
    tbmenu+="+-"                               // teclas de "refresh"
   #endi

   l_m=exrot[op_sis]                           // senhas nao tem rotinas
   l_m=RTRIM(mo_dif+l_m)                       // para serem retiradas
   FOR i=1 TO LEN(l_m)                         // retira rotina que o usuario
    tbmenu=STRTRAN(tbmenu,SUBS(l_m,i,1),"")    // nao pode acessar e monta menu
    tbmenu=STRTRAN(tbmenu,SUBS(l_m,i,1),"")    // nao pode acessar e monta menu
   NEXT                                        // com as rotinas disponiveis
   msg =IF(AT("P",tbmenu)>0,"P. Procura determinado registro  ˇ|","")
   msg+=IF(AT("F",tbmenu)>0,"F. Filtragem (seleciona/ordena)  ˇ|","")
   msg+=IF(AT("D",tbmenu)>0,"D. DigitaáÑo - inclui registros  ˇ|","")
   msg+=IF(AT("M",tbmenu)>0,"M. Modifica conte£do do campo    ˇ|","")
   msg+=IF(AT("E",tbmenu)>0,"E. Exclui (marca apagamento)     ˇ|","")
   msg+=IF(AT("R",tbmenu)>0,"R. Recupera (desmarca apagamento)ˇ|","")
   msg+=IF(AT("V",tbmenu)>0,"V. Và todo o registro na tela    ˇ|","")
   msg+=IF(AT("N",tbmenu)>0,"N. Nova coluna                    |","")
   msg+=IF(AT("A",tbmenu)>0,"A. Apaga coluna do cursor        ˇ|","")
   msg+=IF(AT("I",tbmenu)>0,"I. Imprime a consulta            ˇ|","")
   msg+=IF(AT("O",tbmenu)>0,"O. Ordena os registros           ˇ|","")
   msg+=IF(AT("Q",tbmenu)>0,"Q. Quantifica registros          ˇ|","")
   msg+=IF(AT("L",tbmenu)>0,"L. Localiza um registro          ˇ|","")
   msg+=IF(AT("S",tbmenu)>0,"S. Seguinte - localiza seguinte  ˇ|","")
   msg+=IF(AT("G",tbmenu)>0,"G. Global - processa os registrosˇ|","")
   msg+=IF(AT("C",tbmenu)>0,"C. Congela/descongela colunas    ˇ|","")
   msg+=IF(AT("T",tbmenu)>0,"T. Tamanho - muda tamanho coluna ˇ|","")
   msg+=IF(AT("J",tbmenu)>0,"J. "+IF(outro_db=NIL,"Janela - abre uma nova janela ˇ|","Janela - troca de janelas     ˇ|"),"")
   msg+=IF(AT("X",tbmenu)>0,"X. eXporta dados (TXT, SDF, DBF) ˇ|","")
   msg+=IF(AT("Z",tbmenu)>0,"Z. totaliZa coluna (se numÇrica) ˇ|","")
   msg+=IF(AT("B",tbmenu)>0,"B. estaBelece condiáÑo para marcar|","")

   #ifdef COM_REDE
    msg+=IF(AT("+",tbmenu)>0,"+. +5 seg na remontagem da tela  ˇ|","")
    msg+=IF(AT("-",tbmenu)>0,"-. -5 seg na remontagem da tela  ˇ|","")
   #endi

   msg=LEFT(msg,LEN(msg)-1)                     // tira pipe do final da msg
   msgt="OPÄôES   -   F3=Pesquisa|ALT-F10=excluidos, ALT-Z=zoom, ALT-G=grava"
   op_db=DBOX(msg,,,E_MENU,,msgt,,,op_db)       // escolhe a rotina
   IF op_db = 0                                 // cancelou...
    LOOP
   ENDI
   tecl_p = ASC(SUBS(tbmenu,op_db,1))           // pega o ASC
   IF SUBS(tbmenu,op_db,1)="L"                  // se escolheu "localiza", entao ajusta
    op_db++                                     // default para o continua
   ENDI
   SET CURSO ON                                 // acende o cursor
   nao_pesq=.t.                                 // assume acao da opcao escolhida
  ELSEIF tecl_p = K_F9                          // ve outros arquivos
   st_pesq := ""                                // limpa pesq por palavra
   IF !M->v_out                                 // se tem permissao
    l_sup=li_sup; l_inf=li_inf                  // salva coordenadas da janela
    c_sup=co_sup; c_inf=co_inf
    m_od=mo_dif                                 // salva rotinas acessadas e
    br_w1 := br_w                               // o objeto browse atual
    VEOUTROS()                                  // escolhe arquivo a consultar
    br_w := br_w1                               // restaura o browse
    br_w:configure()                            // remonta titulo da colunas
    volta_db=.t.
    li_sup=l_sup; li_inf=l_inf                  // restaura as coordenadas da
    co_sup=c_sup; co_inf=c_inf                  // janela e
    mo_dif=m_od                                 // rotinas acessadas
    br_w:refreshall()                           // refaz os dados na tela
    FORCABRW(.f.)                               // forca browse do 2a. janela (se existir)
    MONTABRW()                                  // remonta as bordas da janela
   ELSEIF tem_t                                 // transfere o campo para o get pendente
    IF nao_vdbf                                 // se nao veio do VDBF()
     SEPARA(br_w:getcolumn(br_w:colpos):cargo)  // separa atrib coluna e transf p/ caracter
     IF tp_cp="D"
      msg=STRTRAN(DTOC(&cp_.),"/")
     ELSE
      msg=TRANSCAMPO(.t.,cp_)
     ENDI
     KEYB ALLTRIM(msg)                          // coloca campo no buffer do teclado
    ENDI
    volta_db=.f.
   ENDI
  ELSEIF tecl_p = K_ALT_F10                     // ALT-F10 esconde e mostra os
   st_pesq := ""                                // limpa pesq por palavra
   SET(_SET_DELETED,!SET(_SET_DELETED))         // registros excluidos na consulta
   IF DELE() .AND. SET(_SET_DELETED)            // registro esta apagado
    MOV_PTR(1)                                  // acha o 1o. reg nao apagado
   ENDI
   br_w:refreshall()                            // remonta os dados do browse
   br_w:forcestable()                           // apresenta os dados
   br_w:refreshcurrent()                        // refaz so' a linha do browse
   FORCABRW(.f.)

  ELSEIF tecl_p = K_F3                          // liga/desliga pesquisa
   _pesq=(!_pesq)                               // troca flag
   cond_p:=st_pesq := ""                        // inicializa var de pesq
   tecl_p=0                                     // nao faz mais nada
   IF nao_vdbf                                  // se nao veio do VDBF()
    drvpesq=_pesq
   ELSE
    drvpvdbf=_pesq
   ENDI
   SAVE TO (arqconf) ALL LIKE drv*              // salva configuracao

  ELSEIF tecl_p = K_ALT_G                       // grava a consulta em arquivo
   st_pesq := ""                                // limpa pesq por palavra
   t=ALIAS()                                    // salva arquivo corrente
   br_w1 := br_w                                // e browse atual
   SELE (m_origem)                              // selecion dbf da janela de cima
   cod_sos=22                                   // novo codigo de help
   db_aqcom=PADR(br_tit,58)                     // default para o titulo a gravar
   ALERTA(2)                                    // solicita o titulo para a consulta
   db_aqcom=DBOX("Identifique-a para gravaáÑo. ESC cancela",,,,,"GRAVA CONSULTA",db_aqcom)
   db_aqcom=ALLTRIM(db_aqcom)                   // tira brancos do nome
   IF LASTKEY()!=K_ESC.AND.!EMPT(db_aqcom)      // se nao cancelou...
    pas = "1"                                   // grava paramenetros das duas janelas
    br_w = br_origem                            // vai para janela de cima
    db_outro=IF(outro_db=NIL,"",ALIAS(VAL(outro_db)))
    db_indrela=ind_rela                         // indice utilizado para relacionar
    db_qprg=qual_prg                            // prg chamador
    DO WHILE .t.
     db_&pas.qtdc=br_w:colcount                 // numero de colunas
     FOR i=1 TO db_&pas.qtdc                    // para cada coluna
      tt=RIGHT(STR(100+i,3),2)
      db_&pas.carg&tt.= br_w:getcolumn(i):cargo // (conteudo,mascara,titulo,pre-val,valida,tipo)
      db_&pas.tam&tt. = br_w:getcolumn(i):width // tamanho da coluna
     NEXT
     id_carg = br_w:cargo                       // situacao do browse
     db_&pas.expo=id_carg[2]                    // ordem
     db_&pas.arqf=id_carg[1]                    // filtro
     db_&pas.chvr=id_carg[3]                    // relacionamento, outra janela
     db_&pas.ind_ord=id_carg[4]                 // indice atual
     db_&pas.cmr=id_carg[5]                     // marcacao de registros
     db_&pas.freeze=br_w:freeze                 // coluna congelada
     IF pas = "1" .AND. br_outro != NIL         // tem outra janela aberta?
      pas="2"                                   // salva o mesmo
      SELE (outro_db)                           // para a outra janela
      br_w = br_outro
     ELSE
      EXIT                                      // tudo feito...
     ENDI
    ENDD
    IF br_tit==db_aqcom                         // se for a mesma consulta lida
     aqdbe=br_arq                               // grava no arquivo de mesmo nome
    ELSE                                        // se nao,
     DO WHIL .t.                                // procura um nome para gravar
      hms=TIME()                                // a consulta
      resaq=LEFT(hms,2)+SUBS(hms,4,2)+RIGHT(hms,2)+"."+LEFT(ALIAS(VAL(m_origem)),3)
      aqdbe=drvdbf+"DB"+resaq
      IF ! FILE("&aqdbe.")                      // se achou um
       EXIT                                     // cai fora...
      ENDI
     ENDD
    ENDI
    SAVE ALL LIKE db_* TO (aqdbe)               // salva em disco a consulta
   ENDI
   SELE (t)                                     // volta para a area anterior
   br_w := br_w1                                // e browse atual

  ELSEIF tecl_p = K_ALT_F8                      // ALT-F8 rola a janela
   st_pesq := ""                                // limpa pesq por palavra
   li_sup-=2; co_sup--                          // ajusta coordenadas e
   li_inf++; co_inf++                           // executa a rolagem da janela
   MUDA_PJ(@li_sup,@co_sup,@li_inf,@co_inf,brw_fundo,.t.)
   li_sup+=2; co_sup++                          // reajusta as coordenadas
   li_inf--; co_inf--
   PUBL &vr_edita.:=STR(li_sup,2)+STR(co_sup,2) // publica variaves que contem
   SAVE TO (arqconf) ALL LIKE drv*              // as coordenadas da janela e
   REST FROM (arqconf) ADDI                     // grava em disco
   br_origem:ntop   := li_sup                   // ajusta browse com
   br_origem:nleft  := co_sup                   // as novas coordenadas
   br_origem:nbottom:= li_inf
   br_origem:nright := co_inf
   IF br_outro != NIL                           // se existe outra janela aberta
    M->tp=li_sup+INT((li_inf-li_sup-1)/2)+1     // ajusta as coordenadas dela
    br_origem:nbottom:=M->tp-2                  // tambem
    br_outro:ntop   := M->tp+1
    br_outro:nleft  := co_sup
    br_outro:nbottom:= li_inf
    br_outro:nright := co_inf
    FORCABRW(.f.)                               // reimprime dados na tela
   ENDI
  ENDI
  carac_ = UPPER(CHR(tecl_p))                   // escolheu uma rotina...
  l_m=exrot[op_sis]                             // arq de senhas nao tem restricoes
  IF _pesq .AND. !nao_pesq .AND. tecl_p>31      // que pesquisar....
   IF AT("L",mo_dif+l_m)>0                      // se usuario nao tem permissao
    LOOP                                        // nao deixa executar
   ENDI
   SEPARA(br_w:getcolumn(br_w:colpos):cargo)    // separa atributos da coluna
   brw_tela = SAVESCREEN(0,0,MAXROW(),79)       // salva tela atual
   st_pesq+=carac_                              // contatena letra dig com que ja existe
   IF tp_cp=="C"                                // carater concatena com aspas
    cond_p="LTRIM("+cp_+")='"+st_pesq+"'"
   ELSEIF tp_cp=="N"                            // numerico
    cond_p="LTRIM(STR("+cp_+"))='"+st_pesq+"'"  // tira os brancos da frente
    i=AT(".",cp_masc)
    IF i=0
     i=LEN(cp_masc)+1
     j=0
    ELSE
     j=LEN(cp_masc)-i
    ENDI
    cp_="STR("+cp_+","+LPAD(i-1,2,"0")+","+LPAD(j,2,"0")+")"
   ELSEIF tp_cp=="D"                            // campo data
    cond_p="STRTRAN(DTOC("+cp_+"),'/')='"+st_pesq+"'"  // tranforma para char antes de testar
   ELSE                                         // tipo sem pesquisa...
    cond_p:=st_pesq := ""
   ENDI
   IF LEN(cond_p)>2                             // tem condicao para pesquisa
    ind_ok=0                                    // verifica se tem um indice pela coluna
    IF tp_cp=="N" .OR. tp_cp=="C" .OR. tp_cp=="D"               // no seek vamos aceitar so data ou caracter
     FOR t=1 TO LEN(sistema[op_sis,O_INDIC])    // corre todos os indices do dbf
      IF UPPE(INDEXKEY(t))=UPPE(cp_)            // indice = a coluna
       ind_ok=t                                 // vamos usa'-lo
       EXIT
      ENDI
     NEXT
    ENDI
    x_=IF(EMPT(criterio),"","T")                // tem filtro?
    IF LEN(chv_rela)>0                          // se tem relacao pesq somente nela
     x_=x_+chv_1                                // chave de relacionamento
    ENDI
    brw_reg=RECN()                              // registro atual
    IF ind_ok=0
     IF LEN(st_pesq)=1                          // 1a. vez
      INI_ARQ()                                 // move ponteiro para o inicio do arquivo
      br_w:rowpos=1                             // posicao da barra seletora
      br_w:refreshall()                         // forca atualizacao da tela
      br_w:forcestable()                        // apresenta os dados
     ENDI
     cur_atual=SETCURSOR(0)                     // salva/apaga cursor
     POE_GAUGE("Pesquisando...|ESC interrompe","AGUARDE...","Processados:")
     IF LEN(x_)>0                               // se tem relacao pesq somente nela
      LOCA FOR &cond_p. WHIL IN_KEY()!=K_ESC .AND. POE_GAUGE() .AND. &(INDEXKEY(0))=x_ // tenta localizar registro desejado
     ELSE
      LOCA FOR &cond_p. WHIL IN_KEY()!=K_ESC .AND. POE_GAUGE() // tenta localizar registro desejado
     ENDI
     ind_ok=(FOUND() .AND. IF(LEN(x_)>0,&(INDEXKEY(0))=x_,.t.)) // achou?
    ELSE
     i=ind_ok                                    // salva indice atual
     ind_ok=PTAB(st_pesq,ALIAS(),ind_ok)         // tenta achar...
     IF ind_ok                                   // achou?
      IF IF(LEN(x_)>0,&(INDEXKEY(0))=x_,.t.)=.f. // esta dentro do filtro
       p=INDEXORD()                              // ordem atual
       DBSETORDER(i)                             // seta ordem do indice
       DO WHILE !EOF()                           // verifica se o proximo
        IF &cond_p.                              // esta dentro da condicao
         IF IF(LEN(x_)>0,&(INDEXKEY(p))=x_,.t.)  // e filtro
          ind_ok=.t.                             // tudo ok
          EXIT
         ENDI
        ELSE                                     // nao encontrou
         ind_ok=.f.                              // cai fora
         EXIT
        ENDI
        SKIP
       END
       DBSETORDER(p)         // volta ordem do indice
      ENDI
     ENDI
    ENDI
    IF !ind_ok .AND. LEN(st_pesq)>0             // nao achou?
     ALERTA(1)                                  // aviso sonoro
     st_pesq=LEFT(st_pesq,LEN(st_pesq)-1)       // descarta caracter digitado
     ind_ok=.t.
     GO brw_reg                                 // volta para o registro que estava
    ENDI
    SETCURSOR(cur_atual)                        // retorna o cursor ao normal
    IF !ind_ok.OR.LASTKEY()=K_ESC               // nao achou ou cancelou
     cond_p:=st_pesq := ""                      // limpa variavies
    ENDI
    IF !ind_ok                                  // nao achou...
     br_w:gobottom()                            // acha o ultimo reg do arq
     KEYB CHR(K_PGDN)
    ELSE
     br_w:rowpos = 1
    ENDI
    br_w:configure()                               // forca atualizacao da tela
    RESTSCREEN(0,0,MAXROW(),79,brw_tela)        // restaura tela anterior
   ENDI
   carac_=""
   tecl_p=0
  ELSE
   IF AT(carac_,"ERMG")>0 .AND. (RECC()=0 .OR.; // nao permite alterar um
      IF(EMPTY(criterio),.f.,!&criterio.))      // arquivo vazio ou
    LOOP                                        // fora do filtro
   ENDI
   IF AT(carac_,mo_dif+l_m)>0                   // se usuario nao tem permissao
    LOOP                                        // nao deixa executar
   ENDI
   IF AT(carac_,"DERMGV")>0 .AND.;              // se vai alterar um registro
      LEN(sistema[op_sis,O_CPRELA])>0           // e se e' um filho
    i=.t.                                       // flag - vai relacionar com o pai
    IF br_outro!=NIL .AND. EOF()                // se for janela de baixo e nao tem registros
     IF br_w==br_outro                          // e esta na janela de baixo
      x_=AT("->",sistema[op_sis,O_CPRELA,1])-1  // separador de arquivo->campo
      x_=LEFT(sistema[op_sis,O_CPRELA,1],x_)    // pega o nome do pai
      IF ALIAS(VAL(m_origem))!=x_               // se janela de cima nao for o pai
      ALERTA(2)                                 // nao pode incluir!
        DBOX("InclusÑo nÑo permitida!",,,3)     // mensagem ao usuario
       LOOP                                     // e retorna ao browse
      ELSE
       i=.f.                                    // flag - nao vai relacionar com o pai
      ENDI
     ENDI
   ENDI
    IF i                                        // vai relacionar?
     POSIPAI()                                  // abre/posiciona seus pais
    ENDI
   ENDI
  ENDI
  DO CASE

   #ifdef COM_REDE
    CASE (tecl_p=43 .OR. tecl_p=45)             // teclou + ou - para mudar o "refresh"
     DO WHILE .T.
      msg=LTRIM(STR(drvtempo))
      msg=IF(drvtempo=0,"NÑo",msg+" seg")       // tempo=0 nao tem "refresh"
      ALERTA(1)
      DBOX(msg,,,25,,"'REFRESH`|(+/-)")         // mostra msg do tempo atual
      IF LASTKEY()=43                           // teclou +, entao
       drvtempo=IF(drvtempo>57,60,drvtempo+5)   // aumenta o tempo em 5 seg
      ELSEIF LASTKEY()=45                       // teclou -, entao
       drvtempo=IF(drvtempo<1,0,drvtempo-5)     // diminui o tempo em 5 seg
      ELSE                                      // teclou algo diferente de + e -
       EXIT                                     // entao aceita refresh atual
      ENDI
     ENDD
   #endi


   CASE tecl_p = K_ENTER                        // teclou o ENTER
    IF nao_vdbf                                 // nao veio do VDBF() o ENTER movimentara'
     KEYB CHR(VAL(SUBS(ch_tecl,dir_cur*2-1,2))) // para onde a SETA (TAB) esta apontando
    ELSE                                        // caso contrario,
     volta_db=.f.                               // retorna falso
    ENDI

   CASE tecl_p = K_TAB                          // teclou o TAB
    dir_cur()                                   // muda direcao do cursor

   CASE tecl_p = K_ALT_Z .AND. !db_zoom         // aumenta o tamanho da janela
    li_sup=3; li_inf=22; co_sup=3; co_inf=77    // coordenadas da janela expandida
    br_origem:nTop   := li_sup                  // passa as novas coordenadas
    br_origem:nbottom:= li_inf                  // para o browse de cima
    br_origem:nleft  := co_sup
    br_origem:nright := co_inf
    IF br_outro != NIL                          // existe a janela de baixo
     M->tp=li_sup+INT((li_inf-li_sup-1)/2)+1    // linha de divisao das janelas
     br_origem:nbottom := M->tp - 2             // final da janela de cima
     br_outro:nTop   := M->tp+1                 // topo da jenela de baixo
     br_outro:nbottom:= li_inf                  // ajusta o resto das
     br_outro:nleft  := co_sup                  // coordenadas
     br_outro:nright := co_inf
    ENDI
    db_zoom:=.t.                                // flag dizendo do zoom
    FORCABRW(.t.)                               // reimprime janela nao ativa
    MONTABRW()                                  // remonta janela

   CASE tecl_p = K_F1                           // teclou F1
    help()                                      // mostra ajuda correspondente

   CASE tecl_p = K_ESC                          // teclou ESC
    volta_db=.f.                                // abandona a consulta

   CASE carac_="A" .AND. br_w:colcount > 1      // apaga consulta se mais de 1 coluna
    ALERTA(2)                                   // pede confirmacao
    msg="Apagar a coluna|Cancelar a operaáÑo"
    cod_sos=1
    op_=DBOX(msg,,,E_MENU,,"COLUNA "+MAIUSC(br_w:getcolumn(br_w:colpos):heading))
    IF op_=1                                    // confirmou...
     br_w:delColumn(br_w:colpos)                // retira a coluna do browse
     grava_db = .t.                             // seta flag de consulta alterada
     br_w:configure()                           // remonta todo browse
    ENDI

   CASE carac_="B"                              // estabelece condicao de marcacao de reg
    cri_ant = criterio                          // salva filtro atual
    cmr_ant = cmr_                              // salva cond de marcacao atual
    FILTRA(.f.)                                 // monta expressao de pesquisa
    cmr_=criterio                               // condicao de marcacao
    criterio = cri_ant                          // retorna filtro atual
    IF EMPTY(cmr_)                              // tirou marcacao
     cmr_="1=2"                                 // nemhum sera marcado
    ENDI
    IF cmr_!=cmr_ant                            // mudou condicao de marcacao
     br_w:cargo := {criterio,cpord,chv_rela,INDEXORD(),cmr_}
     FOR i=1 TO br_w:colcount                   // atualiza as cores das colunas
      br_w:getcolumn(i):colorblock=&("{||IF(DELE(),{3,2},IF("+cmr_+",{5,2},{1,2}))}")
     NEXT
     br_w:refreshall()                          // reapresenta os dados na tela
    ENDI

   CASE carac_="C" .AND.;                       // congela/descongela coluna se
        br_w:colpos-1 != br_w:freeze            // a coluna ja' congelada
    IF br_w:freeze != 0                         // se outra coluna ja' congelada
     br_w:getcolumn(br_w:freeze+1):colsep:=NIL  // retira o marcador da coluna congelada
    ENDI
    br_w:freeze := br_w:colpos - 1              // congela coluna requerida
    IF br_w:freeze != 0                         // se nao descongelou todas colunas
     br_w:getcolumn(br_w:colpos):colsep:=" € "  // coloca marcador de colunas congeladas
    ENDI
    br_w:configure()                            // remonta todo browse
    grava_db = .t.                              // seta flag de consulta alterada

   CASE carac_="D"                              // inclusao de registros
    dele_atu=SET(_SET_DELETED,!drvvisivel)      // salva DELE() atual,
    br_w1 := br_w                               // browse atual,
    brw_tela = SAVESCREEN(0,0,MAXROW(),79)      // tela atual e o
    in_=INDEXORD()                              // salva indice atual para incluirmos
    DBSETORDER(1)                               // seta 1 indice para incluirmos
    brw=.f.
    Tela_fundo=SAVESCREEN(0,0,MAXROW(),79)      // salva pano de fundo para ALT-F8
    t_f8=SETKEY(K_F8,NIL)                       // salva/reseta tecla F8
    cp_exp:={}                                  // enche vetor com relacoes atuais
    i_=1                                        // pega todas relacoes que existir
    DO WHILE LEN(DBRELATION(i_))>0
     AADD(cp_exp,{DBRELATION(i_),ALIAS(DBRSELECT(i_))}) // adiciona ao vetor temporario
     i_++
    ENDD
    SET RELA TO                                 // retira todas as relacoes
    &arq_cor._incl()                            // inclusao de novos registros de dados
    FOR i_=1 TO LEN(cp_exp)                     // coloca todos as relacoes anteriores
     dli_exp=cp_exp[i_,1]                       // expresao de ligacao
     arqexp=cp_exp[i_,2]                        // dbf de ligacao
     SET RELA ADDI TO &dli_exp. INTO &arqexp.   // recoloca a relacao
    NEXT
    SETKEY(K_F8,t_f8)                           // seta tecla F8
    op_menu=PROJECOES; brw=.t.                  // volta para consulta
    DBSETORDER(in_)                             // retorna ao indice da consulta
    REGINICIO()                                 // verifica se reg esta' no filtro
    RESTSCREEN(0,0,MAXROW(),79,brw_tela)        // restaura a tela,
    SET(_SET_DELETED,dele_atu)                  // DELE() e o
    br_w := br_w1                               // browse anteriores
    br_w:refreshall()                           // reapresenta os dados na tela
    FORCABRW(.f.)                               // forca remontagem da janela relacionada
    MONTABRW()

   CASE carac_="E"                              // exclui registro

    #ifdef COM_REDE
     IF !BLOREG(10,.5)                          // tenta bloquear o arquivo
      LOOP                                      // nao conseguiu...
     ENDI
    #endi

    IF ! DELE()                                 // ja esta excluido?
     IF CONFEXCL()                              // pede confirmacao
      &arq_cor._get1(EXCLUI)                    // exclui registro/processo inverso
      br_w:refreshall()                         // remonta os reg da tela
      FORCABRW(.f.)                             // remonta janela relacionada
     ENDI
    ENDI

    #ifdef COM_REDE
     UNLOCK                                     // libera o registro
    #endi

    IF DELE() .AND.SET(_SET_DELETED)            // se nao que ver excluidos
     MOV_PTR(1)                                 // procura o proximo que
    ENDI                                        // nao esteje excluido

   CASE carac_="F" .OR. carac_="Q"              // filtra/quantifica
    cri_ant = criterio
    IF carac_="F"                               // filtra
     FILTRA(.t.,.t.)                            // escolhe o filtro
     br_w:cargo := {criterio,cpord,chv_rela,INDEXORD(),cmr_}
     br_w:refreshall()                          // refaz toda a tela
     IF cri_ant!=criterio.AND.!EMPTY(criterio)  // se alterou o filtro
      grava_db=.t.                              // seta flag de consulta alterada
     ENDI
    ELSE                                        // quantifica
     FILTRA(.f.)                                // so' monta a expressao
     condq=criterio                             // retorna filtro anterior
     criterio = cri_ant
    ENDI
    brw_reg=RECN()                              // salva registro atual
    IF carac_="Q" .AND. LEN(condq)>2            // continuacao da quantificacao
     brw_tela = SAVESCREEN(0,0,MAXROW(),79)     // da mensagem que esta contando...
     DBOX("CondiáÑo:|"+LEFT(condq,78)+"|| AGUARDE...  Contando. ESC cancela",,,,NAO_APAGA)
     INI_ARQ()                                  // move ponteiro para o inicio do arquivo

     COUN FOR &condq WHIL IN_KEY()!=K_ESC TO qu// conta....

     IF LASTKEY()!=K_ESC                        // nao cancelou entao mostra
      ALERTA(2)                                 // quantos reg foram contados
      DBOX("Existe(m) "+LTRIM(TRAN(qu,"@E 9,999,999"))+" registro(s)|na condiáÑo|"+LEFT(condq,78)+"|*",8)
     ENDI
     RESTSCREEN(0,0,MAXROW(),79,brw_tela)       // restaura a tela anterior e
     GO brw_reg                                 // o registro
    ENDI
    MONTABRW()                                  // remonta janela de visualizacao

   CASE carac_="G"                              // processo glogal
    brw_tela = SAVESCREEN(0,0,MAXROW(),79)      // salva situacao atual
    brw_reg = RECNO()
    GLOBAL()                                    // executa processo
    GO brw_reg                                  // restabelece situacao anterior
    REGINICIO()                                 // verifica se reg esta' no filtro
    br_w:cargo := {criterio,cpord,chv_rela,INDEXORD(),cmr_}
    br_w:refreshall()                           // remonta dados da tela
    RESTSCREEN(0,0,MAXROW(),79,brw_tela)        // restaura tela
    MONTABRW()                                  // remonta janela do browse

   CASE carac_="I"                              // imprime consulta
    IMP_BRW()

   CASE carac_="J" .AND. br_outro != NIL        // troca janela de consulta
    TROCA_BRW()                                 // troca arquivo do browse
    br_w:colorspec := drvcorbox+","+INVCOR(drvcorbox)+","+drvcorenf+","+drvcorget+","+drvcorhlp
    FORCABRW(.t.)                               // troca as cores da janela
    MONTABRW()                                  // remonta dados e a
    br_w:hilite()                               // janela com a nova cor

   CASE carac_="J"                              // abre uma nova janela
    msg=""; op_a=0; db=""
    pp=SETKEY(K_F9,NIL)                         // desliga F9 (consulta outro DBF)
    FOR i=1 TO nss                              // monta menu de DBF disponiveis
     IF sistema[i,O_OUTROS,O_NIVEL]<=nivelop .AND.;
        LEN(sistema[i,O_INDIC])>0
      msg+="|"+sistema[i,O_MENU]
      db+=RIGHT(STR(1000+i),3)
     ENDI
    NEXT
    cod_sos=30
    IF LEN(msg)>1                               // escolhe o DBF da nova janela
     op_a=DBOX(SUBS(msg,2),,,E_MENU,,"BASES DE DADOS")
    ENDI
    IF op_a>0                                   // escolheu...
     op_a=VAL(SUBS(db,op_a*3-2,3))              // acha a sua subscricao
     op_sis_x=op_sis                            // salva subscricao atual
     SETCOLOR(drvcortna)
     IF abreoutro(op_a)                         // e abre a outra janela
      grava_db = .t.                            // flag de consulta alterada
      tit_cons[2]=sistema[op_sis,O_MENS]        // titulo da segunda janela
      IF op_sis_x != op_sis
       op_ind=1                                 // indice 'default`
       qt_ind=LEN(sistema[op_sis,O_INDIC])      // qde de indices do arquivo
       chv=ATAIL(sistema[op_sis,O_CHAVE])       // pega ultimo elemento das chaves
       IF chv=="codlan"                         // se e' ntx de relacionamento nao pode
        qt_ind--
       ENDI
       IF qt_ind>1                              // escolheum conjunto de indice
        msg=""
        FOR t=1 to qt_ind
         msg+="|"+sistema[op_sis,O_CONSU,t]
        NEXT
        op_ind=DBOX(SUBS(msg,2),,,E_MENU,,"SELECIONE O INDICE")
        IF op_ind>1
         ind_rela=ALLTRIM(STR(op_ind))
         DBSETORDER(VAL(ind_rela))
        ENDI
       ENDI
       SELE (m_origem)
       x_=ASCAN(sistema[op_sis_x,O_DBRELA],{|db_|sistema[op_sis,O_ARQUI,O_NOME]=db_})
       i_=LEN(sistema[op_sis,O_CPRELA])         // se DBF escolhido e relacionado,
       IF x_>0.AND.i_>0                         // monta a expressao de relacionamento
        chv_rela=""
        FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
         chv_rela+="+"+TRANSCAMPO(.f.,sistema[op_sis,O_CPRELA,i],i)
        NEXT
       ELSE                                     // se usuario montar expressao
        PEGARELA(.t.)
       ENDI
       chv_rela=IF(LEN(chv_rela)>2,SUBS(chv_rela,2),"")
       br_outro:cargo := {"","",chv_rela,op_ind}// inicializa variavel de usuario
      ENDI
      criterio:=cpord := ""                     // inicializa filtro/ordenacao
      cmr_="1=2"                                // cond marcacao de registros
      SELE (outro_db)                           // muda para a janela de baixo
      PEGACHV2()                                // pega final do relaciomento
      INI_ARQ()                                 // procura 1o. reg da relacao
      LDBEDIT(.f.)                              // monta as novas colunas
      FORCABRW(.t.)                             // imprime dados da janela de cima
      MONTABRW()                                // monta nova janela de visualizacao
     ELSE
      op_sis = op_sis_x                         // nao conseguiu abrir nova janela
     ENDI
    ENDI
    SETKEY(K_F9,pp)                             // habilita F9 (consulta outros DBFs)

   CASE carac_="L"                              // localiza registro
    SEPARA(br_w:getcolumn(br_w:colpos):cargo)   // separa atributos da coluna
    cod_sos=36
    ecara=(tp_cp=="C".OR.tp_cp=="M")            // tipo do campo
    brw_tela = SAVESCREEN(0,0,MAXROW(),79)      // salva tela atual
    chvpesq=IF(ecara,SPAC(30),IF(tp_cp="D",CTOD(''),IF(tp_cp="L",.t.,0)))
    msg="Argumento - Localiza argumento no campo "+cp_titu+;
        "|CondiáÑo - Localiza registro sob uma condiáÑo"+;
        "|Cancelar a operaáÑo"                  // escolhe o tipo de localizacao
    x=DBOX(msg,,,E_MENU,,SEPLETRA("LOCALIZAÄéO",1))
    IF x!=0 .AND. x!=3                          // nao cancelou
     cond_p=""
     IF x=1                                     // localiza por argumento
      msg="LOCALIZAR ARGUMENTO "+IF(ecara,"CONTIDO ","")+" EM "+MAIUSC(cp_titu)
      chvpesq=DBOX("Informe o argumento",,,,,msg,chvpesq,cp_masc)
      IF cp_crit=="V" .OR. CRIT(cp_crit,18)     // argumento de pesquisa ok?
       IF (!EMPT(chvpesq) .OR. tp_cp="L").AND.LASTKEY()!=K_ESC
        IF ecara                                // se for caracter
         chvpesq=ALLTRIM(chvpesq)               // deixa localizar so as letras digitadas
         igc=1                                  // se tem minusculo no campo
         IF cp_masc!="@!"                       // pergunta se quer ignorar a caixa
          igc=DBOX("Sim|NÑo|Cancelar a operaáÑo",,,E_MENU,,"IGNORAR CAIXA|(A=a)?")
         ENDI
         IF igc=1.OR.igc=2                      // prepara expressao de pesquisa
          cond_p=IF(igc=2,"'"+chvpesq+"' $ "+cp_,"MAIUSC('"+chvpesq+"') $ UPPER("+cp_+")")
         ENDI
        ELSE
         cond_p=cp_+"=chvpesq"                  // prepara expressao de pesquisa
        ENDI
       ENDI
      ENDI
     ELSE                                       // localiza por condicao
      cri_ant = criterio                        // salva filtro atual
      FILTRA(.f.)                               // monta expressao de pesquisa
      cond_p=criterio
      criterio = cri_ant                        // retorna filtro atual
     ENDI
     RESTSCREEN(0,0,MAXROW(),79,brw_tela)       // restaura tela anterior
     IF LEN(cond_p)>2                           // continua a localizar...
      cur_atual=SETCURSOR(0)                    // salva/apaga cursor
      POE_GAUGE("Loczalizando "+LTRIM(TRAN(chvpesq,""))+".|ESC interrompe","AGUARDE...","Processados:")
      brw_reg=RECN()
      INI_ARQ()                                 // move ponteiro para o inicio do arquivo
      IF LEN(chv_rela)>0                        // se tem relacao pesq somente nela
       x_=IF(EMPT(criterio),"","T")+chv_1       // chave de relacionamento
       LOCA FOR &cond_p. WHIL IN_KEY()!=K_ESC .AND. POE_GAUGE() .AND. &(INDEXKEY(0))=x_ // tenta localizar registro desejado
      ELSE
       LOCA FOR &cond_p. WHIL IN_KEY()!=K_ESC .AND. POE_GAUGE() // tenta localizar registro desejado
      ENDI
      SETCURSOR(cur_atual)                      // retorna o cursor ao normal
      IF ! FOUND().AND.LASTKEY()!=K_ESC         // nao achou ou cancelou
       ALERTA(4)
       DBOX("NÑo encontrado!|*",13,40)          // mensagem ao usuario
       GO brw_reg
      ELSE
       ALERTA(1)                                // achou...
       fg_loc=.t.                               // sinal sonoro
      ENDI
     ENDI
     br_w:refreshall()                          // remonta os dados da consulta
    ENDI
    RESTSCREEN(0,0,MAXROW(),79,brw_tela)        // restaura tela anterior

   CASE carac_="M"                              // modifica registro
    IF !br_w:stable                             // forca a apresentacao de
     br_w:forcestable()                         // todos os registros na tela
     x_=COL(); y_=ROW()                         // salva coordenadas atuais do cursor
    ENDI
    brw_reg = RECNO()                           // salva registro atual
    SKIP                                        // tenta pegar o proximo reg
    IF EOF() .OR. &(INDEXKEY(0))!=IF(EMPT(criterio),"","T")+chv_1 // esta fora do filtro/relacao
     regseg = -1                                // esta no ultimo reg
    ELSE
     regseg = RECNO()
    ENDI
    GO brw_reg                                  // tenta pegar o reg anterior
    SKIP -1
    IF BOF() .OR. &(INDEXKEY(0))!=IF(EMPT(criterio),"","T")+chv_1 // esta fora do filtro/relacao
     regant = -1                                // esta no 1o. reg
    ELSE
     regant = RECNO()
    ENDI
    GO brw_reg                                  // volta para o reg que estava
    cont_mod=.f.                                // flag - continua modificando?

    #ifdef COM_REDE
     IF !BLOREG(10,.5)                          // tenta bloquear o registro
      LOOP                                      // nao conseguiu...
     ENDI
     blk_="blk_"+ALIAS()
     IF TYPE(blk_)="L"
      blk_a=&blk_.
     ELSE
      blk_a=.f.
     ENDI
     PRIV &blk_.:=.t.
    #endi

    IF !CONFALT()                               // verifica se o registro
     LOOP                                       // pode ser modificado
    ENDI
    SEPARA(br_w:getcolumn(br_w:colpos):cargo)   // separa atributos da coluna
    evirt=(cp_crit=="V")                        // pode modificar?
    IF (AT(UPPER(cp_),UPPER(INDEXKEY(1)))>0.AND.sistema[op_sis,O_OUTROS,O_TPCHV]).OR.;
       evirt.OR.DELE()
     ALERTA()
     DBOX(IF(DELE(),"REGISTRO EXCLU°DO","CAMPO NéO EDITèVEL"),12,,1)
    ELSE
     &arq_cor._get1(FORM_INVERSA)               // executa processo inverso se existir
     pp=.f.                                     // flag "refresh" na outra janela?
     IF IF(!EMPTY(cp_when).AND.;                // tem pre-validacao. pode modificar?
        !("MTAB(" $ cp_when).AND.!("VDBF(" $ cp_when),EVAL(&("{||"+cp_when+"}")),.t.)
      SETCOLOR(drvcorbox)                       // coloca mensagem no topo da janela
      IF br_w:nleft+22<br_w:nright              // avisando que estamos modificando
       @ br_w:ntop-2,br_w:nleft+12 SAY "{Modifica}"
      ENDI
      ALERTA(1)                                 // Beep!
      IF tp_cp=="M"                             // campo memo...
       EDIMEMO(cp_,cp_titu,15,2,MAXROW()-1,3+VAL(SUBS(cp_masc,3)),cp_crit)
      ELSE
       i = br_w:getcolumn(br_w:colpos):width    // o tamanho atual da coluna
       IF i != LEN(TRAN(&cp_.,cp_masc)) .AND.;  // esta' diferente to tamanho
          tp_cp="C"                             // real do campo estao vamos
        cp_masc="@S"+ALLTRIM(STR(i,3))+IIF(LEFT(cp_masc,1)<>"@"," ","")+cp_masc  // forcar a rolagem do campo
       ENDI
       @ y_,x_ GET &cp_. PICT cp_masc;
                         VALI CRIT(cp_crit);
                         WHEN cp_when
                         AJUDA cp_help
                         CMDF8 cp_cmd
       READ
      ENDI
      IF br_w:nleft+22<br_w:nright              // retira mensagem de alteracao
       @ br_w:ntop-2,br_w:nleft+12 SAY REPL(SUBS(mold,2,1),10)
      ENDI
      IF tp_cp!="M".AND.LASTKEY()!=K_ESC.AND.;  // se o campo nao for memo, nao deu ESC,
         RECNO()=brw_reg                        // nao esta fora do filtro/relacao e
       cont_mod=.t.                             // segue modificando...
      ENDI
     ELSE                                       // nao pode ser modificado
      ALERTA()                                  // mostra por que
      DBOX("Modifica quando "+UPPER(cp_when),,,3,,"PRê-CR°TICA NéO ATENDIDA!")
     ENDI
     &arq_cor._get1(FORM_DIRETA)                // executa processos/lancamentos
     IF pp                                      // se for preciso, forca
      REGINICIO()                               // verifica se reg esta' no filtro
      FORCABRW(.f.)                             // browse da outra janela
     ENDI
    ENDI

    #ifdef COM_REDE
     UNLOCK                                     // atualiza o disco
     &blk_.:=blk_a
    #endif

    br_w:refreshcurrent()                       // refaz so' a linha do browse
    IF cont_mod                                 // continua modicar?
     i_=VAL(SUBS(ch_tecl,dir_cur*2-1,2))        // proxima posicao do cursor
     IF &(INDEXKEY(0))!=IF(EMPT(criterio),"","T")+chv_1 // esta fora do filtro/relacao
      IF i_=5                                   // vai para o reg de cima
       IF regant>=0                             // exitem um...
        GO regant                               // posiciona nela e forca
        KEYB CHR(i_)+"M"                        // "M" para cont modificando
       ELSE                                     // esta no 1o. reg
        br_w:gotop()                            // acha o top do arq atual
       ENDI
      ELSE                                      // vai para reg seg ou para os lados
       IF regseg>=0                             // tem reg seguinte?
        GO regseg                               // posiciona nele
        KEYB "M"                                // forca "M" no buffer do teclado
       ELSE                                     // ja esta no ultimo
        br_w:gobottom()                         // acha o novo ultimo reg do arq
       ENDI
      ENDI
      br_w:hilite()                             // tira barra cursora da tela
      br_w:refreshall()                         // forca atualizacao da tela
      br_w:forcestable()                        // apresenta os dados
      br_w:dehilite()                           // liga barra cursora
      FORCABRW(.f.)                             // atualiza browse da outra janela
     ELSE                                       // nao esta fora do filtro...
      IF AT(UPPER(cp_),UPPER(INDEXKEY(0))) > 0  // se esta modificando campo do indice
       br_w:hilite()                             // tira barra cursora da tela
       br_w:refreshall()                         // forca atualizacao da tela
       br_w:forcestable()                        // apresenta os dados
       br_w:dehilite()                           // liga barra cursora
       FORCABRW(.f.)                             // atualiza browse da outra janela
      ENDI
      KEYB CHR(i_)+"M"                          // vai para onde o TAB esta indicando
     ENDI
    ENDI

   CASE carac_="N"                              // cria nova coluna
    cod_sos=28
    cp_ =SPAC(250) ; cp_titu=SPAC(30)           // inicializa variveis
    cp_masc=SPAC(30)
    msg="T°tulo da nova coluna:"
    f10=.f.                                     // recebe titulo da nova coluna
    SET KEY K_F10 TO colnova                    // F10 campo de outro arquivo
    cp_titu=DBOX(msg,,,,,"NOVA COLUNA|*|F10=CAMPO DE OUTRO ARQUIVO",cp_titu)
    SET KEY K_F10 TO                            // desativa F10
    IF LASTKEY()!=K_ESC                         // se nao abandonou e nao teclou
     IF !f10                                    // F10, recebe conteudo da nova coluna
      msg+=" "+ALLTRIM(cp_titu)+"|ExpressÑo conte£do:"
      DO WHILE .t.
       SET KEY K_F10 TO ve_campos               // F10 ve campos da estrutura
       cp_=DBOX(msg,,,,,"NOVA COLUNA|*|F10=CAMPOS DO ARQUIVO",cp_,"@S52@!")
       SET KEY K_F10 TO                         // desativa F10
       IF LASTKEY()!=27 .AND. !EMPTY(cp_)       // verifica se o conteudo e valido
        IF !CRIT("[U]!=TYPE(cp_) .OR. ([|] $ cp_ .AND. [->] $ cp_)~EXPRESSéO ILEGAL",15)
         LOOP
        ENDI
       ENDI
       EXIT
      ENDD
     ENDI
     IF !EMPT(cp_) .AND. LASTKEY()!=K_ESC      // nao cancelou...
      IF !f10                                  // recebe mascara da nova coluna
       msg+=" "+LEFT(ALLTRIM(cp_),30)+"|Com a m†scara:"
       cp_masc=DBOX(msg,,,,,"NOVA COLUNA",cp_masc,"@!")
      ENDI
      IF LASTKEY()!=K_ESC                      // se nao cancelou
       IF SETARELA(cp_)                        // coloca set relation
        IF br_w == br_origem                   // e prepara variavel para
         db_1rela=db_1rela+TRIM(cp_)+"≥"       // a gravacao da consulta
        ELSE
         db_2rela=db_2rela+TRIM(cp_)+"≥"
        ENDI
        cp_=SUBS(cp_,AT("|",cp_)+1)
       ENDI                                    // cria nova coluna com o que
       ncol = br_w:colpos                      // foi informado
       cp_titu=ALLTRIM(cp_titu) ; cp_=ALLTRIM(cp_) ; cp_masc=ALLTRIM(cp_masc)
       br_w:inscolumn(ncol,tbcolumnnew(cp_titu,&("{||TRAN("+cp_+",["+cp_masc+"])}")))
       br_w:getcolumn(ncol):cargo := cp_+"≥"+cp_masc+"≥"+cp_titu+"≥≥V"
       br_w:getcolumn(ncol):width := LEN(TRAN(&cp_.,cp_masc))
       br_w:getcolumn(ncol):colorblock=&("{||IF(DELE(),{3,2},IF("+cmr_+",{5,2},{1,2}))}")
       grava_db = .t.                          // modificou a consulta (flag)
       br_w:refreshall()                       // remonta toda a tela
      ENDI
     ENDI
    ENDI
    SET KEY K_F10 TO                           // desativa F10

   CASE carac_="O"                             // ordenacao da consulta
    cpord=""
    br_wx = br_w                               // salva browse atual
    CLASS(.t.)                                 // recebe expressao de ordenacao
    IF !EMPT(cpord)                            // montou ordenacao?
     br_w:refreshall()                         // refaz toda a tela
     IF INDEXORD()>LEN(sistema[op_sis,O_CHAVE])// se criou indice extra
      grava_db = .t.                           // seta flag de gravacao e
     ENDI                                      // grava a nova ordenacao
     br_w:cargo:={criterio,cpord,chv_rela,INDEXORD(),cmr_}
    ENDI
    MONTABRW()                                 // refaz todo o browse

   CASE carac_="P" .AND. ! EMPT(INDEXKEY(1))   // pesquisa indexada de registro
    brw_reg = RECNO()                          // registro atual
    POSI()                                     // recebe/procura registro
    IF brw_reg != RECNO()                      // se o reg nao e o mesmo,
     br_w:rowpos = 1                           // coloca reg atual na primeira
    ENDI                                       // linha da tela
    br_w:configure()                           // refaz a configuracao do browse

   CASE carac_="R"                             // recupera registro

    #ifdef COM_REDE
     IF !BLOREG(10,.5)                         // se nao bloqueou o registro,
      LOOP                                     // retorna ao browse
     ENDI
    #endi

    IF DELE()                                  // se o registro esta' excluido
     IF !EMPT(sistema[op_sis,O_CONDREC,1])     // se tem condicao de
      IF !&(sistema[op_sis,O_CONDREC,1])       // recuperacao e se esse
       ALERTA(2)                               // reg nao pode ser
       msg=sistema[op_sis,O_CONDREC,2]         // avisa o motivo
       DBOX(msg,,,,,"ATENÄéO!|IMPOSS°VEL RECUPERAR")
       LOOP                                    // e retorna
      ENDI
     ENDI
     &arq_cor._get1(RECUPERA)                  // recupera reg/processo direto
     ALERTA(1)                                 // aviso sonoro
     br_w:refreshcurrent()                     // refaz so' a linha do browse
     FORCABRW(.f.)                             // remonta a outra janela (se houver)
    ENDI

    #ifdef COM_REDE
     UNLOCK                                    // libera registro
    #endi


   CASE carac_="S".AND.fg_loc                  // seguinte (proximo do localiza)
    brw_tela = SAVESCREEN(0,0,MAXROW(),79)     // salva tela/avisa que esta localizando
    cur_atual=SETCURSOR(0)                     // salva/apaga cursor
    POE_GAUGE("Loczalizando "+LTRIM(TRAN(chvpesq,""))+".|ESC interrompe","AGUARDE...","Processados:")
    brw_reg=RECN()                             // salva registro atual
    SKIP IF(EOF(),0,1)                         // pula para o proximo, se nao for fim de arq
    IF LEN(chv_rela)>0                         // se tem relacao pesq somente nela
     x_=IF(EMPT(criterio),"","T")+chv_1        // chave de relacionamento
     LOCA FOR &cond_p. WHIL IN_KEY()!=K_ESC .AND. POE_GAUGE() .AND. &(INDEXKEY(0))=x_ // continua a procura...
    ELSE
     LOCA FOR &cond_p. WHIL IN_KEY()!=K_ESC .AND. POE_GAUGE() // continua a procura...
    ENDI
    SETCURSOR(cur_atual)                       // retorna o cursor ao normal
    IF ! FOUND().AND.LASTKEY()!=K_ESC          // se nao achou,
     ALERTA(4)                                 // avisa
     DBOX("Registro nÑo encontrado!",13,40)
     GO brw_reg
    ELSE                                       // achou...
     ALERTA(1)                                 // avisa com beep e
     br_w:refreshall()                         // prepara p/ remontar toda a tela
    ENDI
    RESTSCREEN(0,0,MAXROW(),79,brw_tela)       // retira msg de "localizando"

   CASE carac_="T"                             // muda tamanho da coluna
    SEPARA(br_w:getcolumn(br_w:colpos):cargo)  // pega tamanho atual
    x=IF(TYPE(cp_)=="M",60,LEN(TRAN(&cp_.,cp_masc)))
    msg="Informe o novo tamanho da coluna "+;
        MAIUSC(br_w:getcolumn(br_w:colpos):heading)
    cod_sos=1
    x=DBOX(msg,,,,,"TAMANHO DA COLUNA",x,"99") // recebe o novo tamanho
    IF CRIT(STR(x)+"<=77.AND."+STR(x)+;        // se o tamanho e valido
       ">0~TAMANHO ILEGAL",12)
     br_w:getcolumn(br_w:colpos):width = x     // atualiza tamanho da coluna
     grava_db = .t.                            // no browse e
     br_w:configure()                          // reconfigura tudo
    ENDI

   CASE carac_="V"                             // ve todo o registro na tela
    tela_fundo=SAVESCREEN(0,0,MAXROW(),79)     // salva tela
    t_tab:=SETKEY(K_TAB,NIL)                   // desativa o TAB

    #ifdef COM_MOUSE
     IF drvmouse                               // se mouse esta' ativo,
      MOUSEGET(@x_,@y_)                        // salva sua posicao atual
     ENDI
    #endi

    i_=SETCOLOR()                              // salva a cor atual
    DO WHILE .t.
     DISPBEGIN()                               // comeca a montagem da tela
     IMPRELA()                                 // imprime telas relacionadas
     &arq_cor._gets()                          // apresenta o conteudo do registro
     INFOSIS(.f.)                              // imprime o rodape' da tela
     DISPEND()                                 // mostra tela pronta
     ALERTA(1)
     cod_sos=35

     #ifdef COM_MOUSE
      tecl_p=MOUSETECLA(l_s,c_s,l_i,c_i,.f.)   // espera clique ou alguma tecla
     #else


      #ifdef COM_REDE
       tecl_p=IN_KEY(drvtempo)                 // espera tecla ou sai para refresh
      #else
       tecl_p=IN_KEY(0)                        // espera uma tecla ser digitada
      #endi

     #endi

     DO CASE
      CASE tecl_p=K_ALT_F8                     // teclou F8 (rolagem da janela)
       rola_t=.t.                              // liga flag e
       ROLATELA()                              // executa a rolagem
      CASE tecl_p=K_ESC.OR.tecl_p=K_ENTER.OR.tecl_p=32
       EXIT                                    // abandona
     ENDC
    ENDD
    SETCOLOR(i_)                               // restaura cor anterior

    #ifdef COM_MOUSE
     IF drvmouse                               // define janela do mouse
      MOUSEBOX(br_w:ntop-1,br_w:nleft-1,br_w:nbottom+1,br_w:nright+1)
      DO WHIL MOUSEGET(0,0)!=0                 // so' sai se os botoes do
      ENDD                                     // mouse estiverem liberados
      MOUSESET(x_,y_)                          // restaura a posicao do mouse
     ENDI
    #endi

    RESTSCREEN(0,0,MAXROW(),79,tela_fundo)     // restaura tela
    SETKEY(K_TAB,t_tab)                        // TAB volta a funcionar

   CASE carac_="X"                           // exporta dados
    cod_sos=32                               // escolhe o formato da exportacao
    msg="Texto - delimitados, para editores de texto|"+;
        "SDF - 'standard Data Format` para outros sistemas|"+;
        "DBF - formato padrÑo dBASE"
    op_exp=DBOX(msg,,,E_MENU,,"TIPO DE ARQUIVO DE SAIDA")
    IF op_exp!=0
     IF op_exp=1                             // escolheu o delimitado, entao
      dli_exp=","                            // escolhe o delimitador
      dli_exp=DBOX("Informe o delimitador",,,,,"SEPARAÄéO DOS CAMPOS",dli_exp)
     ENDI
     IF LASTKEY()!=K_ESC
      brw_tela = SAVESCREEN(0,0,MAXROW(),79) // salva a tela
      arq_=ARQGER()                          // recebe o nome do arquivo a gerar
      IF !EMPTY(arq_)                        // quer continuar...
       cod_sos=1
       arqexp=arq_+".TXT"                    // se o arq informado existir
       IF FILE(arqexp)                       // verifica se pode gravar por cima
        op_=DBOX("Gravar por cima|Cancelar a operaáÑo",,,E_MENU,,"ARQUIVO "+UPPER(arqexp)+" JA EXISTE!")
        cn=(op_!=1)
        IF !cn                               // pode sobrepor,
         ERASE (arqexp)                      // entao mata arq
        ENDI
       ENDI
       IF op_exp=3                           // se exporta para outro DBF
        IF FILE(arq_+".DBF")                 // verifica se o DBF ja existe
         op_=DBOX("Gravar por cima|Cancelar a operaáÑo",,,E_MENU,,"ARQUIVO "+UPPER(arq_)+".DBF JA EXISTE!")
         cn=(op_!=1)
        ENDI
       ENDI
      ENDI
      IF !cn                                 // avisa que esta' trabalhando...
       DBOX("Gerando o arquivo "+arqexp,15,,,NAO_APAGA)
       ASIZE(estr_dbf,0); ASIZE(cp_exp,0)    // vetores auxiliares
       FOR i=1 TO br_w:colcount              // exporta todas as colunas
        SEPARA(br_w:getcolumn(i):cargo)      // separa atributo da coluna
        IF tp_cp!="M"                        // campo memo nao e' exportado
         IF op_exp=3                         // exporta para DBF
          cp_x=cp_
          casadec=0                          // se a coluna for numerica, verifica
          IF tp_cp="N"                       // a qde de casas decimais
           casadec=IF("." $ cp_masc,LEN(cp_masc)-RAT(".",cp_masc),0)
           tamanho=0                         // acha o tamanho
           FOR t=1 TO LEN(cp_masc)           // do campo
            IF !(SUBS(cp_masc,t,1) $ "@BCDEKXZR, ()")
             tamanho++
            ENDI
           NEXT
          ELSEIF tp_cp="D"                   // a coluna e' uma data
           tamanho=8                         // o tamanho e' sempre 8
          ELSEIF tp_cp="L"                   // a coluna e' tipo logico
           tamanho=1                         // o tamanho e' sempre 1
          ELSE                               // coluna tipo caracter
           tamanho=br_w:getcolumn(i):width
           cp_="LEFT("+cp_+"+["+SPAC(tamanho)+"],"+STR(tamanho,3)+")"
          ENDI
          IF "->" $ cp_x                     // coluna de outro arquivo
           cp_x=SUBS(cp_x,AT("->",cp_x)+2)   // retira o nome do DBF
          ENDI
          FOR tt=1 TO 12                     // retira caracteres ilegais
           i_=SUBS(" ()*/+-^%$@&",tt,1)      // do conteudo da coluna
           IF i_ $ cp_x                      // nome do campo do DBF a exportar
            cp_x=STRTRAN(cp_titu,i_,"")
           ENDI
          NEXT                               // monta vetor da nova estrutura
          AADD(estr_dbf,{cp_x,tp_cp,tamanho,casadec})
         ELSE                                // exportacao TXT/SDF
          IF AT(tp_cp,"CN")>0                // caracter/numerico trunca pelo tam da coluna
           cp_="LEFT(TRAN("+cp_+",["+cp_masc+"])+["+SPAC(br_w:getcolumn(i):width)+"],"+STR(br_w:getcolumn(i):width,3)+")"
          END IF
         ENDI
         AADD(cp_exp,cp_)                    // vetor com conteudos a exportar
        ENDI
       NEXT
       brw_reg = RECNO()                     // volta para registro anterior
       dele_atu:=SET(_SET_DELETED,.t.)       // os excluidos nao serao exportados
       INI_ARQ()                             // move ponteiro para o inicio do arquivo
       SET ALTE TO (arq_)                    // abre o arquivo para gravacao
       SET ALTE ON                           // liga gravacao
       SET CONS OFF                          // nao iremos exibir na tela
       q=CHR(34)                             // "aspas"
       DO WHIL !EOF()                        // para todos os registros
        FOR t=1 TO LEN(cp_exp)               // e para todas as colunas
         c_p=EVAL(&("{||"+cp_exp[t]+"}"))    // "code block" com o conteudo da coluna
         IF op_exp!=1                        // se nao for delimitado
          c_p=IF(VALTYPE(c_p)="D",DTOS(c_p),c_p)
          ?? c_p                             // grava no arquivo
         ELSE                                // se delimitado grava entre aspas
          c_p=IF(VALTYPE(c_p)="D",DTOC(c_p),c_p)
          ?? q+ALLTRIM(c_p)+q+IF(t=LEN(cp_exp),"",dli_exp)
         ENDI
        NEXT
        ?                                    // pula para proxima linha
        SKIP                                 // pega proximo registro
       ENDD
       SET ALTE OFF                          // desliga a gravacao
       SET ALTE TO                           // fecha arquivo
       SET CONS ON                           // reabilita o video
       SET(_SET_DELETED,dele_atu)            // restaura situacao do DELE()
       GO brw_reg                            // volta para registro anterior
       IF op_exp=3                           // exportacao para DBF
        DBOX("Gerando o arquivo "+arq_+".DBF",15,,,NAO_APAGA)
        i_=LEN(estr_dbf)                     // verifica/assegura que os nomes
        FOR t=1 TO i_                        // dos campos nao estao repetidos
         FOR i=t+1 TO i_
          IF estr_dbf[t,1]=estr_dbf[i,1]
           estr_dbf[i,1]=LEFT(estr_dbf[i,1],8)+STRZERO(i,2)
          ENDI
         NEXT
        NEXT
        are_a:=SELECT()                      // area atual
        SELE 0
        DBCREATE(arq_,estr_dbf)              // cria o novo DBF
        USE (arq_)                           // abre
        APPEND FROM (arqexp) SDF             // e anexa os registros
        USE                                  // fecha
        ERASE (arqexp)                       // elimina arq .txt temporario
        SELE (are_a)                         // retorna para area DBF origem
       ENDI
       AFILL(cp_exp,"")
       RESTSCREEN(0,0,MAXROW(),79,brw_tela)  // restaura a tela e
       ALERTA()                              // beep
      ENDI
     ENDI
    ENDI

   CASE carac_="Z"                             // totaliza coluna
    SEPARA(br_w:getcolumn(br_w:colpos):cargo)  // separa atributos da coluna
    IF !(tp_cp $ "NC")                         // se o campo nao for numerico
     ALERTA()                                  // nao da para somar
     DBOX("Coluna nÑo pode ser totalizada",,,2)
    ELSE
     brw_tela = SAVESCREEN(0,0,MAXROW(),79)    // salva tela, registro e avisa
     brw_reg=RECN()                            // que esta somando
     DBOX("Totalizando "+MAIUSC(cp_titu)+"|ESC interrompe",,,,NAO_APAGA,"AGUARDE!")
     INI_ARQ()                                 // vai para o topo do arquivo
     x=INDEXKEY(0)                             // e comeca a somar
     IF tp_cp="N"
      SUM &cp_. TO tot_ FOR !DELE() WHIL IN_KEY()!=K_ESC .AND. &x.=IF(EMPTY(criterio),"","T")+chv_1
     ELSE
      SUM VALBR(cp_) TO tot_ FOR !DELE() WHIL IN_KEY()!=K_ESC .AND. &x.=IF(EMPTY(criterio),"","T")+chv_1
     ENDI
     GO brw_reg
     IF LASTKEY()!=K_ESC                       // nao cancelou
      ms="999,999,999,999,999,999"             // mostra quanto foi o somatorio
      dec=AT(".",cp_masc)
      ms+=IF(dec>0,SUBS(cp_masc,dec),".99")
      ALERTA(4)
      DBOX("O somat¢rio de "+MAIUSC(cp_titu)+" Ç|"+TRAN(tot_,ms),,,,,"TOTALIZAÄéO")
     ENDI
     RESTSCREEN(0,0,MAXROW(),79,brw_tela)      // restaura a tela
    ENDI

  ENDC
 ENDI
ENDD

#ifdef COM_MOUSE
 IF drvmouse
  DO WHIL MOUSEGET(@Li,@Co)!=0                 // se qualquer botao do mouse
  ENDD                                         // estiver pressionado, espera
  MOUSEBOX(0,0,MAXROW(),79)                    // a sua liberacao
 ENDI
#endi

RETU NIL

/*
   Sintaxe: VALBR(cp)
   Funcao.: Transforma caracter em numerico despresando a mascara
   Retorna: valor numerico de cp
*/
STATIC FUNC VALBR(cp_)
LOCAL val_br
val_br=&cp_.                       // campo a ser transformado
IF AT("@E", UPPER(cp_))>0          // tem @E na mascara, entao
 val_br=STRTRAN(val_br, ".", "")   // vamos trocar o ponto por nada
 val_br=STRTRAN(val_br, ",", ".")  // e a virgula pelo ponto
ELSE                               // nao tem @E na mascara, entao
 val_br=STRTRAN(val_br, ",", "")   // so vamos trocar a virgula por nada
ENDI
RETU VAL(val_br)                   // retorna o valor numerico

/*
   Sintaxe: IMP_BRW()
   Funcao.: Imprime a consulta da funcao EDITA()
   Retorna: NIL
*/
STATIC FUNC IMP_BRW()
LOCAL dele_atu, qb_:={}, qba_:={}, x_, or_i, tot_num:=.f., tot_snum:=.f.,;
      tot_sint:=.f., lin_qb:={}
ALERTA(1)
x_=PADR(tit_cons[IF(br_w == br_origem,1,2)],40)         // recebe um titulo do relatorio
cod_sos=38                                              // sugerindo o titulo da consulta
tit_rel=DBOX("Informe um t°tulo",,,,,"IMPRESSéO DE CONSULTA",x_)
IF LASTKEY()!=K_ESC
 cod_sos=1
 ALERTA(1)                                              // a onde vai imprimir?
 tps=TP_SAIDA(,0,.T.)                                   // escolhe a saida...
 IF tps>0 .AND. LASTKEY()!=K_ESC
  cn=.f.
  ALERTA(1)
  IF "4WIN"$UPPER(drvmarca) // nome da configuracao/marca impressora
    arq_:=drvdbf+"WIN"+ide_maq
    tps:=3                                          // se vai para arquivo/video
    cn:=.F.
  ELSEIF tps=2                                              // saida para arquivo
   arq_=ARQGER()                                        // solicita um nome
   cn=EMPTY(arq_)
  ELSE                                                  // vai para a impressora
   cn=!PREPIMP()                                        // pede para prepara-la
   arq_=drvporta                                        // porta de saida configurada
  ENDI
  IF !cn
   brw_reg=RECN()                                       // salva registro atual
   dele_atu=SET(_SET_DELETED,.t.)                       // salva/seta visao dos reg apagados
   brw_tela = SAVESCREEN(0,0,MAXROW(),79)               // salva tela
   qb_=QUEBRA_BRW()                                     // pega quebra da impressao
   ltot := ltot_o := 0                                  // inicializa variaveis
   lin4win:=iif("4WIN"$UPPER(drvmarca),20,0)
   brw_cb1 = ""; brw_imp:=just_memo:=tot_num:=tot_snum:=tot_sint := .f.
   IF LEN(qb_)>1                                        // se tem quebra
    brw_cb1 = SPACE((3*(LEN(qb_)-1)))                   // coloca cabecalho mais a direita
    ltot = (3*(LEN(qb_)-1))                             // tamanho do cabecalho
   ENDI
   IF br_w == br_origem .AND. VALTYPE(outro_db) = "C"   // se esta imprimindo da janela de cima
    id_carg = br_outro:cargo                            // vamos verificar se a janela
    brw_imp = !EMPTY(id_carg[3])                        // de baixo esta relacionada
   ENDI
   FOR t = 1 TO br_w:colcount                           // para cada coluna,
    SEPARA_IMP(br_w:getcolumn(t):cargo)                 // separa os atributos
    le_=br_w:getcolumn(t):width                         // tamanho da coluna
    brw_cb1 +=" "+PADR(ALLTRIM(cp_titu),le_)            // monta linha de cabecalho
    ltot += le_ + 1                                     // tamanho do relatorio
    IF tp_cp=="N"                                       // coluna e' numerica?
     var="to"+SUBS(STR(t+100,3),2)                      // inicializa variavel
     &var.=0; tot_num=.t.                               // para totalizar a coluna
     IF LEN(qb_)>0                                      // se tem quebra
      FOR ii=1 TO LEN(qb_)                              // inicializa variaves de sub totalizacao
       var="Q"+SUBS(STR(ii+100,3),2)+"to"+SUBS(STR(t+100,3),2)  // inicializa variavel
       &var.=0; tot_snum=.t.                            // para totalizar a coluna
      NEXT
     ENDI
    ENDI
    IF tp_cp="M"                                        // coluna e' memo?
     just_memo=.t.                                      // liga flag da pergunta
    ENDI                                                // para justificar memo
   NEXT
   brw_cb1 = SUBS(brw_cb1,2)                            // tira 1o. espaco do titulo e
   ltot--                                               // ajusta tamanho do relatorio
   IF brw_imp                                           // existe janela relacionada?
    SELE (outro_db)                                     // seleciona o DBF da janela de
    IF LEN(qb_)>1                                       // se tem quebra
     brw_cb2 = SPACE(ltot_o)                            // defasa cabecalho do arq relacionado
     ltot_o = (3*(LEN(qb_)-1))                          // aumenta tamanho da cabecalho do arq rela
    ELSE                                                // nao tem quebra
     ltot_o = 0                                         // inicializa variaveis do cabecalho
     brw_cb2 = ""
    ENDI
    FOR t = 1 TO br_outro:colcount                      // para cada coluna
     SEPARA_IMP(br_outro:getcolumn(t):cargo)            // separa os atributos
     le_=br_outro:getcolumn(t):width                    // tamanho da coluna
     brw_cb2 +=" "+PADR(ALLTRIM(cp_titu),le_)           // monta titulo das colunas
     ltot_o += le_ + 1                                  // e o tamanho do relatorio
     IF tp_cp=="N"                                      // coluna e' numerica?
      var="too"+SUBS(STR(t+100,3),2)                    // inicializa variavel
      &var.=0; tot_num=.t.                              // para totalizar a coluna
     END IF
     IF tp_cp="M"                                       // coluna e' memo?
      just_memo=.t.                                     // liga flag de pergunta
     ENDI                                               // para justificar memo
    NEXT
    brw_cb2 = SUBS(brw_cb2,2)                           // tira 1o. espaco do titulo e
    ltot_o--                                            // ajusta tamanho do relatorio
    SELE (m_origem)                                     // seleciona DBF da janela de cima
   ENDI
   IF tot_num                                           // tem alguma coluna numerica?
    ALERTA(1)                                           // pergunta se quer totalizar
    cod_sos=1                                           // o relatorio
    i=DBOX("Sim|NÑo",,,E_MENU,,"TOTALIZAR AS|COLUNAS NUMêRICAS")
    IF i=0
     RETU                                               // cancelou...
    ENDI                                                // flag se quer totalizar
    tot_num=(i=1)
    IF !tot_num                                         // se nao vai totalizar
     tot_snum=.f.                                       // tambem nao sub-totaliza
    ENDI
    IF tot_snum                                         // se tem?
     ALERTA(1)                                          // pergunta se quer sub totalizar
     cod_sos=1                                          // a quebra
     i=DBOX("Sim|NÑo",,,E_MENU,,"SUBTOTALIZAR AS QUEBRAS")
     IF i=0
      RETU                                               // cancelou...
     ENDI                                                // flag se quer sub totalizar
     tot_snum=(i=1)
    ENDI
    IF tot_snum .AND. !brw_imp                           // vai subtotalizar e nao tem arq relacionado
     ALERTA(1)                                           // pergunta se quer sintetizar a impressao
     cod_sos=1
     i=DBOX("Sim|NÑo",,,E_MENU,,"SINTETIZAR O RELATORIO")
     IF i=0
      RETU                                               // cancelou...
     ENDI
     tot_sint=(i=1)                                      // flag se quer sub totalizar
    ENDI
   ENDI
   IF just_memo                                         // tem algum campo memo?
    ALERTA(1)                                           // pergunta se quer justificar
    cod_sos=50                                          // os campos memos no relatorio
    i=DBOX("Sim|NÑo",,,E_MENU,,"JUSTIFICAR OS|CAMPOS MEMO")
    IF i=0
     RETU                                               // cancelou...
    ENDI
    just_memo=(i=1)                                     // flag se quer justificar memos
   ENDI
   or_i=cpord                                           // salva ordenacao atual
   IF LEN(qb_)>0                                        // tem quebra
    x_=""                                               // junta a expressao
    FOR t=1 TO LEN(qb_)                                 // de ordenacao de todas
     x_+=IF(LEN(x_)>1,"+","")+qb_[t,2]                  // as quebras
    NEXT
    IF LEFT(cpord,LEN(x_))!=x_                          // se ainda nao esta ordenado
     cpord=x_+IF(LEN(cpord)>1,"+"+cpord,"")             // por esta expressao
     INDTMP()                                           // vamos ordernar agora...
     br_w:refreshall()                                  // forca atualizacao da tela
    ENDI
   ENDI
   DBOX("Aguarde o final de impressÑo||ESC para interromper",17,,,NAO_APAGA)
   INI_ARQ()                                            // vai para o inicio do arquivo
   cl:=pg:=creg := 0                                    // inicializar variaveis
   SET PRINTER TO (arq_)                                // abre arq escolhido ou redireciona saida
   SET DEVI TO PRIN                                     // se tamanho > 80, comprime
   @ PROW(),PCOL() SAY IF(MAX(ltot,ltot_o)>80,&drvpcom.,"")
   cl=CABCONS(brw_cb1,tit_rel)                          // imprime cabecalho da janela superior
   brw_cn = .f.
   x_ = INDEXKEY(0)
   IF LEN(qb_)>0                                        // tem quebra definida
    qba_:=AFILL(ARRAY(LEN(qb_)),"")                     // cria vetor do conteudo de cada quebra
   ENDI
   DO WHIL ! EOF() .AND. ! brw_cn .AND.;                // imprime ate o fim do arquivo
      IF(EMPTY(chv_rela).OR.br_w==br_origem,.t.,&x_.=IF(EMPTY(criterio),"","T")+chv_1)
    IF cl>IF(brw_imp,54,57)                             // atingiu o final da folha
     EJEC                                               // pula para proxima pagina
     cl=CABCONS(brw_cb1,tit_rel)                        // e reimprime o cabecalho
    ENDI

    IF IN_KEY()=K_ESC .OR. MOUSEGET(0,0)=2              // quer cancelar a impressao?
     brw_cn = CANC(1)                                   // pede confimacao do cancelamento
     LOOP
    ENDI
    IF LEN(qb_)>0                                       // tem quebra
     FOR t=1 TO LEN(qb_)                                // vamos correr todas
      IF qba_[t]<>&(qb_[t,1])                           // quebrou...
       x_ = .f.
       IF tot_snum .AND. LEN(qba_[t])>0                 // quer totalizar e nao e a 1a. vez
        FOR ii= LEN(qb_) TO t STEP -1                   // coloca os totais das sub-quebras menores
         IF cl+1>IF(brw_imp,52,55)                  // precisa quebrar pagina
          EJEC
          cl=CABCONS(brw_cb1,tit_rel)
         ENDI
         IF ii=LEN(qb_) .AND. tot_sint              // vai sintetizar e e' ultima quebra
          FOR tt=1 TO LEN(lin_qb)                   // corre as linhas salvas
           IF cl+1>IF(brw_imp,54,57)                // precisa quebrar pagina...
            EJEC                                    // forca quebra de folha
            cl=CABCONS(brw_cb1,tit_rel)
           ENDI
           @ cl++,0 SAY lin_qb[tt]                  // imprime linha sintetizada
          NEXT
         ELSE
          lin = SPACE((3*(ii-1)))                   // esp branco ate a quebra
          @ cl++,0 SAY lin+REPL("-", ltot-LEN(lin)) // traco antes da quebra
          lin = SPACE((3*(len(qb_)-1)))             // esp branco ate os dados
         ENDI
         FOR tt=1 TO br_w:colcount                  // monta linha dos sub-totais
          SEPARA_IMP(br_w:getcolumn(tt):cargo)      // separa dados da coluna
          i = br_w:getcolumn(tt):width              // tananho da coluna
          IF tp_cp=="N"                             // coluna numerica, pega sub-total
           var="Q"+SUBS(STR(ii+100,3),2)+"to"+SUBS(STR(tt+100,3),2)
           lin += LEFT(TRAN(&var.,cp_masc)+SPAC(i),i)+" "
           &var.=0
          ELSE
           lin += SPAC(i+1)                         // coluna nao numerica coloca brancos
          ENDI
         NEXT
         IF ii<LEN(qb_) .OR. !tot_sint              // nao e' a ultima quebra
          @ cl++,0 SAY lin                          // imprime sub-totais
          x_ = .t.
         ENDI
         qba_[ii]=""                                // limpa conteudo da quebra
        NEXT
       ENDI
       qba_[t]=&(qb_[t,1])                          // novo conteudo da quebra
       IF LEN(qb_[t,3])>0                                // imprime o titulo
        cl++
        @ cl++,0 SAY SPACE((3*(t-1)))+;                  // somente se foi informado
                     qb_[t,3]+" "+qba_[t]                // imprime titulo da quebra e seu conteudo
       ELSEIF x_
        cl++
       ENDI
      ENDI
     NEXT
     lin = SPACE((3*(LEN(qb_)-1)))                       // onde comeca os dados
    ELSE
     lin = ""                                            // sem quebra, dados comeca na coluna um
    ENDI
    tem_memo=.f.; qli_m=0
    FOR t=1 TO br_w:colcount                            // monta linha a imprimir
     SEPARA_IMP(br_w:getcolumn(t):cargo)                // separa os atributos da coluna
     i = br_w:getcolumn(t):width                        // tamanho da coluna
     IF tp_cp="M"                                       // coluna e' memo?
      IF qli_m<MLCOUNT(&cp_.,i)                         // mumero maximo de linhas
       qli_m=MLCOUNT(&cp_.,i)                           // a imprimir de todos campos memo
      ENDI                                              // monta linha de impressao
      lin += IMPAC(LEFT(MEMOLINE(&cp_.,i,1)+SPACE(i),i),just_memo)+" "
      tem_memo=.t.                                      // flag tem memo?
     ELSE
      IF tp_cp=="N" .AND. tot_num                       // coluna e' numerica?
       var="to"+SUBS(STR(t+100,3),2)                    // soma coluna para
       &var. += &cp_.                                   // totalizacao
       IF LEN(qb_)>0 .AND. tot_snum                     // tem quebra e quer sub-total
        FOR ii=1 TO LEN(qb_)                            // soma de cada quebra
         var="Q"+SUBS(STR(ii+100,3),2)+"to"+SUBS(STR(t+100,3),2)  // inicializa variavel
         &var. += &cp_.
         IF ii=LEN(qb_) .AND. tot_sint                  // sitetiza a ultima quebra
          cp_=var
         ENDI
        NEXT
       ENDI
      ENDI
      lin+=LEFT(TRAN(&cp_.,cp_masc)+SPAC(i),i)+" "      // monta linha de impressao
     ENDI
    NEXT
    IF tot_sint                                            // esta sintetizando
     lin_qb:={}                                            // salva linhas para
     AADD(lin_qb,lin)                                      // imprimir quando quebrar
    ELSE
     @ cl++,0 SAY lin                                      // joga linha na impressora
    ENDI
    IF tem_memo .AND. qli_m>1                           // imprime resto do memo
     li_m=1
     DO WHIL .t.
      li_m++                                            // proxima linha do memo
      IF li_m>qli_m                                     // se ja' imprimiu todos
       EXIT                                             // cai fora...
      ENDI
      IF LEN(qb_)>1                                     // se tem quebra calcula
       lin = SPACE((3*(LEN(qb_)-1)))                    // posicao de inicio dos dados
      ELSE
       lin = ""                                         // sem quebra inicio=1a. coluna
      ENDI
      FOR t=1 TO br_w:colcount                          // procura todos os memo
       SEPARA_IMP(br_w:getcolumn(t):cargo)              // e monta uma linha so'
       i = br_w:getcolumn(t):width
       IF tp_cp="M"
        lin += IMPAC(LEFT(MEMOLINE(&cp_.,i,li_m)+SPACE(i),i),just_memo)+" "
       ELSE
        lin += SPAC(i+1)
       ENDI
      NEXT
      IF cl+1>(IF(brw_imp,54,57)+lin4win)
       IF !("4WIN"$UPPER(drvmarca))
        EJEC                                             // quebra de folha
       ENDI
       cl=CABCONS(brw_cb1,tit_rel)
      ENDI
      IF tot_sint                                       // esta sintetizando
       AADD(lin_qb,lin)                                 // salva linha
      ELSE
       @ cl++,0 SAY lin                                 // joga linha na impressora
      ENDI
      IF IN_KEY()=K_ESC .OR. MOUSEGET(0,0)=2            // quer cancelar a impressao?
       brw_cn = CANC(1)
       LOOP
      ENDI
     ENDD
    ENDI
    IF tem_memo .AND. !tot_sint                         // se imprimiu algum campo
     cl++                                               // memo, forca espacejamento duplo
    ENDI
    creg++                                              // contador de registros impressos
    IF brw_imp                                          // tem outra janela relacionada?
     cl++                                               // forca salto de linha
     id_carg=br_outro:cargo                             // prepara para a impressao
     c_antes=IF(EMPTY(id_carg[1]),"","T")+&(id_carg[3]) // da janela relacionada
     SELE (outro_db)
     SEEK c_antes                                       // acha o 1o. registro da relacao
     ind_outro = INDEXKEY(0)                            // ordem atual do arquivo
     imp_brw_out=.f.
     IF !EOF().AND.!brw_cn.AND.&ind_outro.=c_antes      // se tem registro a imprimir
      cl=CABCONS_O(cl,brw_cb2)                          // imprime cabecalho
      cl++
     ENDI
     DO WHIL !EOF().AND.!brw_cn.AND.&ind_outro.=c_antes // imprime so quem atende a relacao
      cl--
      IF cl>57                                          // final da folha
       IF !("4WIN"$UPPER(drvmarca))
        EJEC                                             // salta para proxima
       ENDI
       cl=CABCONS(brw_cb1,tit_rel)                      // imprime cabecalho do "pai"
      ENDI
      IF IN_KEY()=K_ESC .OR. MOUSEGET(0,0)=2            // quer cancelar?
       brw_cn = CANC(1)                                 // pede confirmacao
       LOOP
      ENDI
      tem_memo=.f.; qli_m=0
      IF LEN(qb_)>1                                     // se tem quebra
       lin_o = SPACE((3*(LEN(qb_)-1)))                  // inicio dos dados
      ELSE
       lin_o = ""                                       // nao tem quebra posicao 0
      ENDI
      FOR t=1 TO br_outro:colcount                      // monta linha a imprimir
       SEPARA_IMP(br_outro:getcolumn(t):cargo)          // separa os atributos da coluna
       IF tp_cp="M"                                     // tamanho da coluna
        IF qli_m<MLCOUNT(&cp_.,i)                       // coluna e' memo?
         qli_m=MLCOUNT(&cp_.,i)                         // mumero maximo de linhas
        ENDI                                            // a imprimir de todos campos memo
        lin_o+=" "+IMPAC(LEFT(MEMOLINE(&cp_.,i,1)+;
             SPACE(i),i),just_memo)                     // monta linha de impressao
        tem_memo=.t.                                    // flag se tem memo
       ELSE
        IF tp_cp=="N" .AND. tot_num                     // coluna e' numerica?
         var="too"+SUBS(STR(t+100,3),2)                 // soma coluna para
         &var. += &cp_.                                 // totalizacao
        ENDI
        i = br_outro:getcolumn(t):width                 // tamanho da coluna
        lin_o+=" "+LEFT(TRAN(&cp_.,cp_masc)+SPAC(i),i)  // monta linha de impressao
       ENDI
      NEXT
      imp_brw_out=.t.
      @ cl,0 SAY PADL(SUBS(lin_o,2),MAX(ltot,ltot_o))   // joga linha na impressora
      IF tem_memo .AND. qli_m>1                         // imprime resto do memo
       li_m=1
       DO WHIL .t.
        li_m++                                          // proxima linha do memo
        IF li_m>qli_m                                   // se ja imprimiu todos
         EXIT                                           // cai fora...
        ENDI
        IF LEN(qb_)>1                                   // se tem quebra
         lin = SPACE((3*(LEN(qb_)-1)))                  // inicio dos dados
        ELSE
         lin = ""                                       // posicao 0 sem quebra
        ENDI
        FOR t=1 TO br_w:colcount                        // procura todos os memo
         SEPARA_IMP(br_w:getcolumn(t):cargo)            // e monta uma linha so'
         i = br_w:getcolumn(t):width
         IF tp_cp="M"
          lin += IMPAC(LEFT(MEMOLINE(&cp_.,i,li_m)+SPACE(i),i),just_memo)+" "
         ELSE
          lin += SPAC(i+1)
         ENDI
        NEXT
        IF cl+1>57                                      // chegou no final da folha?
         IF !("4WIN"$UPPER(drvmarca))
          EJEC                                           // salta para proxima pagina
         ENDI
         cl=CABCONS(brw_cb1,tit_rel)                    // reimprime cabecalho do "pai"
        ENDI
        @ ++cl,0 SAY PADL(lin,MAX(ltot,ltot_o))         // imprime linhas dos memo
        IF IN_KEY()=K_ESC .OR. MOUSEGET(0,0)=2          // quer cancelar?
         brw_cn = CANC(1)
         LOOP
        ENDI
       ENDD
      ENDI
      cl += 2
      SKIP                                              // de imprimir o proximo "pai"
     ENDD
     IF imp_brw_out                                     // se imprimiu algum registro...
      @ cl-1,0 SAY PADL(REPL("-",ltot_o),MAX(ltot,ltot_o))
     ENDI
     cl++
     IF tot_num                                      // pediu para totalizar
      lin_o=""
      FOR t=1 TO br_outro:colcount                   // monta linha dos totais
       SEPARA_IMP(br_outro:getcolumn(t):cargo)
       i=br_outro:getcolumn(t):width
       IF tp_cp=="N"
        var="too"+SUBS(STR(t+100,3),2)                    // variavel com a mascara
        lin_o+=" "+LEFT(TRAN(&var.,cp_masc)+SPAC(i),i)    // da propria coluna
        &var.=0
       ELSE
        lin_o += SPAC(i+1)
       ENDI
      NEXT
      IF LEN(ALLTRIM(lin_o))>0                          // se tem totais, imprime
       @ cl-1,0 SAY PADL(SUBS(lin_o,2),MAX(ltot,ltot_o))
       cl++
      ENDI
     ENDI
     SELE (m_origem)                                    // retorna ao "pai"
    ENDI
    SKIP
   ENDD
   IF tot_snum                                          // quer sub-totalizar?
    IF LEN(qba_[1])>0                                   // teve alguma quebra impressa?
     FOR ii= LEN(qb_) TO 1 STEP -1                      // corre todas para imprimir sub-total
      IF cl+1>IF(brw_imp,52,55)                         // precisa pular pagina
       IF !("4WIN"$UPPER(drvmarca))
        EJEC
       ENDI
       cl=CABCONS(brw_cb1,tit_rel)                      // se pulou reimprime cabecalho
      ENDI
      IF ii=LEN(qb_) .AND. tot_sint                     // ultima quebra vai sintetizar...
       FOR tt=1 TO LEN(lin_qb)                          // imprime linhas salvas
        IF cl+1>(IF(brw_imp,54,57)+lin4win)             // precisa quebrar a pagina
         IF !("4WIN"$UPPER(drvmarca))
          EJEC                                           // entao forca
         ENDI
         cl=CABCONS(brw_cb1,tit_rel)
        ENDI
        @ cl++,0 SAY lin_qb[tt]                         // linha com total da ultima quebra
       NEXT
      ELSE
       lin = SPACE((3*(ii-1)))                          // inicio da quebra
       @ cl++,0 SAY lin+REPL("-", ltot-LEN(lin))        // traco da quebra
       lin = SPACE((3*(len(qb_)-1)))                    // inicio dos dados
      ENDI
      FOR tt=1 TO br_w:colcount                         // monta linha dos sub-totais
       SEPARA_IMP(br_w:getcolumn(tt):cargo)             // separa a coluna
       i = br_w:getcolumn(tt):width                     // tamanho da coluna
       IF tp_cp=="N"                                    // numerico pega sub-total
        var="Q"+SUBS(STR(ii+100,3),2)+"to"+SUBS(STR(tt+100,3),2)
        lin += LEFT(TRAN(&var.,cp_masc)+SPAC(i),i)+" "
        &var.=0                                         // zera sub-total
       ELSE
        lin += SPAC(i+1)                                // col nao numerica poe espacos
       ENDI
      NEXT
      IF ii<LEN(qb_) .OR. !tot_sint                     // nao esta sintetizando...
       @ cl++,0 SAY lin                                 // imprime sub-total
      ENDI
      qba_[ii]=""                                       // inicializa quebra
     NEXT
    ENDI
   ENDI
   @ PROW()+1,0 SAY REPL("=", MAX(ltot,ltot_o))         // traco do fim do relatorio
   IF LEN(qb_)>0                                        // se tem quebra
    lin = SPACE((3*(LEN(qb_)-1)))                       // dados na posicao da ultima quebra
   ELSE
    lin = ""
   ENDI
   IF tot_num                                           // quer totalizar
    FOR t=1 TO br_w:colcount                            // monta linha dos totais
     SEPARA_IMP(br_w:getcolumn(t):cargo)
     i = br_w:getcolumn(t):width
     IF tp_cp=="N"
      var="to"+SUBS(STR(t+100,3),2)                     // variavel com a mascara
      lin += LEFT(TRAN(&var.,cp_masc)+SPAC(i),i)+" "    // da propria coluna
     ELSE
      lin += SPAC(i+1)
     ENDI
    NEXT
    @ PROW()+1,0 SAY lin
   ENDI                                                 // se tem totais, imprime
   @ PROW()+1,0 SAY IIF(tot_sint,"Processados: ","Listados: ")+; // imprime qde de registros
                    ALLTRIM(TRAN(creg,"@E 999,999"))+;           // listados
                    " registros"+;
                    IF(MAX(ltot,ltot_o)>80,&drvtcom.,"")
   IF !("4WIN"$UPPER(drvmarca))
    EJEC
   ENDI
   cpord=or_i                                           // restaura ordenacao
   SET PRINTER TO (drvporta)                            // finaliza o relatorio
   SET DEVI TO SCRE
   SET(_SET_DELETED,dele_atu)                           // restaura visao dos reg apagados
   GO brw_reg                                           // reposiciona o ponteiro
   IF tps=2                                             // se vai para arquivo/video
    BROWSE_REL(arq_,2,3,MAXROW()-2,78,.f.)              // mostra o arquivo gravado
   ENDI
   RESTSCREEN(0,0,MAXROW(),79,brw_tela)                 // restaura a tela e
  ENDI                                                  // do arquivo
 ENDI
ENDI
RETU NIL

/*
   Sintaxe: QUEBRA_BRW()
   Funcao.: pega campos/tituos para quebra da impressao da consulta
   Retorna: arranjo com as quebras
*/
STATIC FUNC QUEBRA_BRW()
LOCAL menucp:="", clivre:=.f., msg, qb_:={}, cpqb_, cpod_, cpti_, ;
      op_qb:=0, tela_qb:=SAVESCREEN(0,0,MAXROW(),79), x_, i_
PRIV cod_sos:=14
IF nivelop>=NIV_CRI_LIVRE         // verifica se usuario autorizado a fazer
 menucp="|* * Quebra livre * *"   // quebra livre
ENDI
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
DO WHILE .t.                      // vamos montar varias quebras...
 msg:=cpqb_:=cpod_:=cpti_ := ""   // inicializa variaves da quebra
 DO WHIL op_qb=0                  // escolhes os campos de cada quebra
  IF LEN(msg)>0                   // mostra campos escolhidos
   op_0=DBOX(SUBS(msg,2),,50,,NAO_APAGA,"QUEBRA")
  ENDI
  op_0=DBOX(SUBS(menucp,2),,6,E_MENU,,"CAMPOS PARA QUEBRA")
  IF op_0!=0                      // escolheu um campo
   op_1=op_0
   IF nivelop>=NIV_CRI_LIVRE      // se tem autorizacao para quebra
    IF op_1=1                     // livre, entao faz...
     clivre=.t.
     EXIT
    ENDI
    op_1--                        // faz op_1 a subscricao da coluna
   ENDI
   ii=0
   cp_=""                                         // inicializa campo esolhido
   x_=ALIAS()                                     // arquivo principal
   DO WHIL LEN(x_)>0                              // corre todas os arquivos
    k_=PARSE(@x_,"|")                             // para pegar campo escolhido
    nc=EVAL(&("{||"+k_+"->(FCOU())}"))            // numero de campos do arquivo
    FOR i=1 TO nc                                 // desprezando campo invisieis
     IF !("I"==sistema[EVAL(qualsis,k_),O_CAMPO,i,O_CRIT])
      ii++
     ENDI
     IF ii=op_1                                   // campo escolhido?
      IF k_==ALIAS()                              // se for o arq principal nao coloca alias()
       cp_=FIEL(i)
      ELSE                                        // arq relacionado coloca o alias()
       cp_=k_+"->"+&k_.->(FIEL(i))
      ENDI
      ms_=sistema[EVAL(qualsis,k_),O_CAMPO,i,O_MASC] // mascara do cp escolhido
      ti_=sistema[EVAL(qualsis,k_),O_CAMPO,i,O_TITU] // mascara do cp escolhido
      EXIT
     ENDI
    NEXT
    IF LEN(cp_)>0                                 // se ja achou o cp
     EXIT                                         // cai fora...
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
   IF TYPE(cp_) $ "MU"                // se tipo MEMO ou INDEFINIDO...
    ALERTA(3)                         // ... nao da' para usar
    DBOX("Campo "+MAIUSC(ti_)+" nÑo|pode ser usado para quebra",,,,,"ATENÄéO!")
    LOOP
   ENDI
   cpod_+=IF(LEN(cpod_)>1,"+","")+;
          TRANSCAMPO(.f.,cp_)          // concatena campos escolhidos para ordenacao
   cp_=TRANSCAMPO(.f.,cp_,,.f.)        // transforma para caracter
   msg +="|"+ti_
   cpqb_+=IF(LEN(cpqb_)>1,"+"+CHR(34)+" - "+CHR(34)+"+","")+cp_  // concatena campos escolhidos
   cpti_+=IF(LEN(cpti_)>1,", ","")+ti_ // titulo default da quebra
  ELSE
   EXIT                                // termino da escolha de cps da quebra
  ENDI
 ENDD
 IF clivre                             // vai fazer quebra livre
  cpqb_=SPAC(210)
  msg="A EXPRESSéO ABAIXO DEVERè ESTAR DE ACORDO COM|"+;
      "A SINTAXE DA LINGUAGEM PARA EVITAR ERRO DE PROCESSAMENTO|*|"+;
      "F10=CAMPOS DO ARQUIVO|*|INFORME A EXPRESSéO PARA QUEBRA"
  DO WHILE .T.
   SET KEY K_F10 TO ve_campos          // habilita F10 para ver campos DBF
   cpqb_=DBOX(msg,,,,,SEPLETRA("* QUEBRA  LIVRE *",1),cpqb_,"@S50")
   SET KEY K_F10 TO                    // desabilita F10
   IF LASTKEY()=K_ESC
    cpqb_:=cpod_ := ""                 // cancelou...
    EXIT
   ENDI
   cpod_=cpqb_                         // exp de ordenacao = exp da quebra
   tp_crit=TYPE(cpqb_)
   IF tp_crit="UI"                     // se expressao=indeterminado
    tp_crit=VALTYPE(&cpqb_.)           // existe funcao fora da clipper.lib
   ENDI                                // entao avalia o conteudo da expressao
   IF tp_crit $ "CND"                  // so ordena tipos caracter/numerico/data
    IF tp_crit="N"                     // transf p/ caracter ordem tp numerica
     cpqb_="STR("+ALLTRIM(cpqb_)+")"
     cpod_="STR("+ALLTRIM(cpod_)+")"
    ELSEIF tp_crit="D"                 // transf p/ caracter ordem tp data
     cpqb_="DTOC("+ALLTRIM(cpqb_)+")"
     cpod_="DTOS("+ALLTRIM(cpqb_)+")"
    ENDI
    EXIT                               // vamos retornar, ordenacao ajustada
   ENDI
   ALERTA(3)                           // ordenacao livre invalida
   DBOX("EXPRESSéO ILEGAL!",15)        // vamos avisar...
  ENDD
  cpqb_=ALLTRIM(cpqb_)                 // tira brancos da expressao
  cpod_=ALLTRIM(cpod_)
 ENDI
 RESTSCREEN(0,0,MAXROW(),79,tela_qb)   // restaura tela original
 IF !EMPTY(cpqb_)                      // escolheu uma quebra
  IF LEN(cpti_)>0                      // coloca : no default do titulo
   cpti_+=":"
  ENDI
  cpti_ = LEFT(cpti_+SPAC(80),80)      // pede o titulo para a quebra
  msg="Informe um t°tulo para ser impresso ao lado|esquerdo do campo da quebra"
  cpti_=DBOX(msg,,,,,"TITULO DA QUEBRA",cpti_,"@S50")
  IF LASTKEY()=K_ESC
   cpqb_:=cpod_ := ""                  // cancelou...
   EXIT
  ENDI
  AADD(qb_,{cpqb_,cpod_,RTRIM(cpti_)}) // imcrementa vetor de quebras
  ALERTA(1)                            // beep! e
  msg="Sim|NÑo"                        // ve se usuario quer outra quebra
  msgt="CRIAR QUEBRA "+ALLTRIM(STR(LEN(qb_)+1))
  cod_sos=1
  ii=DBOX(msg,,,E_MENU,,msgt)
  IF ii!=1                             // se desistiu,
   EXIT                                // prossegue impressao
  ENDI
 ELSE
  EXIT                                 // nenhuma quebra feita...
 ENDI
ENDD
RETU qb_                               // retorna vetor de quebras

/*
   Sintaxe: CABCONS(<ExpC1> <,ExpC2> )
   Funcao.: Imprime cabecalho da consulta na impressora (pai)
              ExpC1 = titulo da consulta
              ExpC2 = titulo extra
   Retorna: Linha de impressao do proximo registro
*/
STATIC FUNC CABCONS(cb_1,tit_rel)
pg++
@ 1,ltot-18 SAY DATE()                   // data do sistema
@ 1,ltot-7  SAY TRAN(pg,"Pag 999")       // numero da pagina
//@ 2,0 SAY IMPAC(PADC(TRIM(nemp),ltot))   // nome da empresa
@ 3,0 SAY PADC(TRIM(tit_rel),ltot)       // titulo informado
@ 4,0 SAY IMPAC(cb_1)                    // titulo das colunas
@ 5,0 SAY REPL("=",MAX(ltot,ltot_o))
RETU 6

/*
   Sintaxe: CABCONS_O()
   Funcao.: Imprime cabecalho da consulta na impressora (filho)
              ExpC1 = titulo da consulta
              ExpC2 = titulo extra
   Retorna: Linha de impressao do proximo registro
*/
STATIC FUNC CABCONS_O(cl,cb_1)
@ cl++,0 SAY IMPAC(PADL(cb_1,MAX(ltot,ltot_o)))              // titulo das colunas
@ cl++,0 SAY IMPAC(PADL(REPL("-",ltot_o),MAX(ltot,ltot_o)))  // justificado a direita
RETU cl

/*
   Sintaxe: SEPARA_IMP( <ExpC> )
     Funcao.: Separa atributos de campos da coluna para impressao
              verifica a possibilidade da formula ser um campo numerico
              ExpC = atributos (nome do campo/mascara/titulo/validacao)
     Retorna: NIL
*/
STATIC FUNC SEPARA_IMP(cp_atr)
LOCAL x
SEPARA(cp_atr)                        // separa atributos da coluna
x=AT("@E",UPPER(cp_))                 // posicao do @E dentro da formula
IF tp_cp="C" .AND.;                   // se a formula for caracter,
   UPPER(cp_masc)="@X" .AND.;         // sua mascara for @X, ter @E
   x>0 .AND. LEFT(cp_,5)="TRAN("      // dentro da formula e comecar com TRAN(
 tp_cp="N"                            // entao e' um formula numerica
 cp_masc=SUBS(cp_,x)                  // pega mascara desta formula
 cp_masc=LEFT(cp_masc,LEN(cp_masc)-2)
 cp_=SUBS(cp_,6,x-8)                  // pega somente a formula
ENDI
RETU NIL

/*
   Sintaxe: TROCA_BRW()
   Funcao.: Troca os arquivos do browse
   Retorna: NIL
*/
STATIC FUNC TROCA_BRW()
IF br_w == br_outro    // se for a janela de baixo
 br_reg_out = RECNO()  // salva situacao e
 SELE (m_origem)       // passa para a janela de cima
 br_w = br_origem
 GO br_reg_ori
ELSE                   // esta' na janela de cima
 br_reg_ori = RECNO()  // salva situacao e
 SELE (outro_db)       // passa para a janela de baixo
 br_w = br_outro
 GO br_reg_out
ENDI
RETU NIL

/*
   Sintaxe: LDBEDIT( <ExpL> )
   Funcao.: Carrega parametros de consulta
            se .t. le consulta dos discos e apresenta menu
   Retorna: .t. se teve sucesso.
*/
STATIC FUNC LDBEDIT(lecons)
LOCAL aqdbe, naq, qarq, cor_, ret_:=.t., sos_cod:=cod_sos, leat_,;
      tela_brw:=SAVESCREEN(0,0,MAXROW(),79), i_, l_mp, c_mp, x_, k_
IF ! USED()                                          // nao existe DBF aberto
 RETU .f.
ENDI
cod_sos=27
leat_=.t.
IF lecons                                            // se quer ler consultas gravadas
 DBOX("AGUARDE!",,,,NAO_APAGA)
 aqdbe=drvdbf+"DB*."+LEFT(ALIAS(),3)                 // mascara dos arquivos
 qarq=ADIR(aqdbe)                                    // capta arquivo do disco
 IF qarq>0                                           // existe alguma consulta gravada?
  PRIV l_arq[qarq+1], v_arq[qarq+1]
  ADIR(aqdbe,l_arq)                                  // monta vetor com os titulos
  i_=0
  FOR i=qarq TO 1 STEP -1                            // de cada consulta
   naq=drvdbf+l_arq[i]
   REST FROM (naq) ADDI
   IF TYPE("db_qprg")="U" .OR. qual_prg==db_qprg
    i_++
    v_arq[i_+1]=db_aqcom+"≥"+l_arq[i]
   ENDI
   RELE ALL LIKE db_*                                 // libera variaveis com "DB"
  NEXT
  If i_>0
   v_arq[1]="* Definir nova consulta *"               // primeira opcao do menu
   volta_ac=.t.
   RESTSCREEN(0,0,MAXROW(),79,tela_brw)
   DO WHIL volta_ac
    volta_ac=.f.
    msg=""                                            // tira os espacos dos titulos
    AEVAL(v_arq,{|ms|;                                // da consulta
                  IF(ms!=NIL,msg+="|"+ALLTRIM(PARSE(ms,"≥")),"");
                };
    )
    l_mp=IF(TYPE("lin_menu")="N",lin_menu+2,NIL)      // coordenadas do menu
    c_mp=IF(TYPE("col_menu")="N",col_menu+8,NIL)      // apresenta menu
    op_co=DBOX(SUBS(msg,2),l_mp,c_mp,E_MENU,,"CONSULTAS DEFINIDAS|(DEL=APAGA)")
    IF volta_ac                                       // quer apagar a consulta
     pos_=RAT("≥",v_arq[op_co])
     IF pos_>3                                        // evita matar opcao sem aquivo
      naq=drvdbf+SUBS(v_arq[op_co],pos_+1)
      i_=ALLTRIM(UPPE(LEFT(v_arq[op_co],pos_-1)))
      ALERTA()                                        // pede confirmacao
      msg="Cancelar a operaáÑo|Efetivar exclusÑo"
      op_=DBOX(msg,8,,E_MENU,,"EXCLUINDO|Ø "+i_+" Æ")
      IF op_=2                                        // se confirmou exclusao elimina
       ERAS &naq.                                     // arquivo de atributos da consulta
       ADEL(v_arq,op_co)                              // exclui consulta do menu
      ENDI
     ENDI
    ENDI
   ENDD
   RELE ALL LIKE db_*                                 // libera variaveis com "DB"
   db_1rela:=db_2rela := ""
   db_zoom=.f.
   IF op_co=0                                         // nao quis ler consulta
    ret_=.f.
   ELSEIF op_co>1
    op_=v_arq[op_co]                                  // consulta escolhida
    br_tit=ALLTRIM(PARSE(@op_,"≥"))                   // extrai o nome do arquivo
    br_arq=drvdbf+op_
    REST FROM (br_arq) ADDI                            // le variaveis do disco
    pas = "1"
    tit_cons[1]=ALLTRIM(br_tit)                       // titulo da consulta
    IF db_zoom                                        // se janela tem zoom
     li_sup=3; li_inf=22; co_sup=3; co_inf=77         // ajusta as coordanadas
     br_w:nTop   := li_sup                            // da janela e do browse
     br_w:nbottom:= li_inf
     br_w:nleft  := co_sup
     br_w:nright := co_inf
    END IF
    ind_rela=db_indrela                               // indice utilizado para relacionar
    DO WHILE .t.
     xdb_rela=LEFT(db_&pas.rela,LEN(db_&pas.rela)-1)
     DO WHIL LEN(xdb_rela)>0                          // restabelece relations
      n_cp=ALLTRIM(PARSE(@xdb_rela,"≥"))
      SETARELA(n_cp)
     ENDD
     cmr_=db_&pas.cmr                                 // marcacao de reg
     FOR t=1 TO db_&pas.qtdc                          // remonta todas colunas
      tt=RIGHT(STR(100+t,3),2)
      cargox=db_&pas.carg&tt.
      cp_ =PARSE(@cargox,"≥")                         // conteudo
      cp_masc=PARSE(@cargox,"≥")                      // mascara
      cp_titu=PARSE(@cargox,"≥")                      // titulo
      cp_when=PARSE(@cargox,"≥")                      // pre-validacao
      cp_crit=PARSE(@cargox,"≥")                      // validacao
      br_w:addcolumn(tbcolumnnew(cp_titu,&("{||"+IF(TYPE(cp_)=="M","MEMOLINE("+cp_+")","TRAN("+cp_+",["+cp_masc+"])")+"}")))
      br_w:getcolumn(t):cargo = db_&pas.carg&tt.
      br_w:getcolumn(t):width = db_&pas.tam&tt.       // tamanho da coluna
      br_w:getcolumn(t):colorblock = &("{||IF(DELE(),{3,2},IF("+cmr_+",{5,2},{1,2}))}")
     NEXT
     br_w:freeze = db_&pas.freeze                     // coluna congelada
     IF br_w:freeze != 0
      br_w:getcolumn(br_w:freeze+1):colsep := " € "
      br_w:configure()
     ENDI
     criterio=db_&pas.arqf                            // filtro
     cpord=db_&pas.expo                               // ordem
     chv_rela=db_&pas.chvr                            // ligacao entre janelas
     ind_ord=db_&pas.ind_or  //d                          // indice atual
     br_w:cargo         := {criterio,cpord,chv_rela,ind_ord,cmr_}
     br_w:gobottomblock := {||FIM_ARQ()}
     br_w:gotopblock    := {||INI_ARQ()}
     br_w:skipblock     := {|n|MOV_PTR(n)}
     PEGACHV2()
     INDTMP()
     IF pas = "1"
      br_reg_ori = IF(FOUND(),RECNO(),1)
      IF TYPE("db_outro")=="C".AND.!EMPTY(db_outro)   // tem duas janelas?
       opi = EVAL(qualsis,db_outro)                   // obtem subscricao do DBF no vetor Sistema
       IF !abreoutro(opi)                             // abre o segundo browse
        EXIT
       ENDI
       SETCOLOR(drvcortna)                            // monta janela
       CAIXA(mold,br_outro:ntop-2, br_outro:nleft-1, br_outro:nbottom+1, br_outro:nright+1)
      ELSE
       EXIT
      ENDI
      pas = "2"
      tit_cons[2]=sistema[opi,O_MENS]                 // titulo da segunda janela
      DBSETORDER(ind_rela)                            // vai para utilizado da relacao
     ELSE
      br_reg_out = IF(FOUND(),RECNO(),1)              // segunda janela
      SELE (m_origem)
      br_w = br_origem
      GO br_reg_ori
      br_outro:colorspec := drvcortna+","+INVCOR(drvcortna)+","+drvcorenf+","+drvcorget+","+drvcorhlp
      FORCABRW(.f.)                                   // imprime dados na tela
      EXIT
     ENDI
    ENDD
    leat_=.f.
   ENDI
  ELSE
   RESTSCREEN(0,0,MAXROW(),79,tela_brw)              // restaura tela
  ENDI
 ELSE
  RESTSCREEN(0,0,MAXROW(),79,tela_brw)               // restaura tela
 ENDI
ENDI
IF leat_
 IF col_cp!=NIL                                      // passou arranjo das colunas
  estr_dbf=DBSTRUCT()                                // campos dos arquivo
  ct_cp=0
  FOR i=1 TO LEN(col_cp)
   t=ASCAN(estr_dbf,{|db_|UPPER(col_cp[i])==db_[1]}) // ve se a coluna e cp do arquivo
   IF t>0
    MONTA_COL()                                      // e' um campo do arquivo
   ELSE
    ct_cp++                                          // nao e' campo do arquivo
    br_w:addcolumn(tbcolumnnew(col_cp[i],&("{||"+col_cp[i]+"}")))
    i_=IF(TYPE("col_tit[i]")!="UE".AND.!EMPTY(col_tit[i]),col_tit[i],"")
    x_=LEN(&(col_cp[i]))                             // tamanho da coluna
    br_w:getcolumn(ct_cp):width := x_
    br_w:getcolumn(ct_cp):colorblock := &("{||IF(DELE(),{3,2},IF("+cmr_+",{5,2},{1,2}))}")
    x_="@X"                                          // mascara default
    IF LEFT(col_cp[i],5)="TRAN("                     // vamos tentar pegar um mascara p/ o cp
     t=RAT("[",col_cp[i])                            // separa os limitadores da mascara
     k=RAT("]",col_cp[i])
     IF t>0 .AND. t<k                                // achamos vamos pega-la..
      x_=SUBS(col_cp[i],t+1,k-t-1)
      t=RAT(",[",col_cp[i])                          // separa somente o campo
      IF t>0
       col_cp[i]=SUBST(col_cp[i],6,t-6)
      ENDI
     ENDI
    ENDI
    br_w:getcolumn(ct_cp):cargo := col_cp[i]+"≥"+x_+"≥"+i_+"≥≥V≥"+VALTYPE(col_cp[i])
   ENDI
   IF TYPE("col_tit[i]")!="UE" .AND. !EMPTY(col_tit[i])
    br_w:getcolumn(ct_cp):heading := col_tit[i]
   ENDI
  NEXT
 ELSE                                                // monta consulta com todos
  estr_dbf=DBSTRUCT()                                // os campos do arquivo
  ct_cp=0
  FOR t=1 TO LEN(estr_dbf)
   IF !("I"==sistema[op_sis,O_CAMPO,t,O_CRIT])       // exceto os invisiveis...
    MONTA_COL()
   END IF
  NEXT
 ENDI
 IF LEN(chv_rela)>0                                  // tem relacionamento
  PEGACHV2()                                         // pega faixa
  INI_ARQ()                                          // vai para o inicio do arquivo
 ENDI
 br_w:gobottomblock := {||FIM_ARQ()}
 br_w:gotopblock    := {||INI_ARQ()}
 br_w:skipblock     := {|n|MOV_PTR(n)}
 IF !EMPTY(criterio) .OR. !EMPTY(cpord)              // tem filtro ou ordem inicial
  INDTMP()                                           // cria indice temporario
  INI_ARQ()                                          // vai para o inicio do arquivo
 ENDI
 br_w:cargo := {criterio,cpord,chv_rela,INDEXORD(),cmr_} // grada nova configuracao
ENDI
RELE ALL LIKE db_*                                   // libera variaveis
cod_sos=sos_cod
RETU ret_                                            // .t. montou consulta com sucesso

/*
   Sintaxe: MONTA_COL()
   Funcao.: Enche uma coluna da edita com atributos de campo
   Retorna: NIL
*/
STATIC FUNC MONTA_COL
M->ms:=sistema[op_sis,O_CAMPO,t,O_MASC]     // mascara
M->tm:=LEN(TRAN(&(FIELD(t)),M->ms))         // conteudo
M->tm:=IF(M->tm=0,34,M->tm)                 // tamanho da coluna
IF LEFT(M->ms,2)="@S"                       // mascara truncada
 M->tm:=VAL(SUBS(M->ms,3))                  // ajusta tamanho e mascara
 IF estr_dbf[t,2]!="M"
  M->ms:=ALLTRIM(SUBS(M->ms,AT(ALLTRIM(STR(M->tm)),M->ms)+LEN(ALLTRIM(STR(M->tm)))))
 END IF
END IF
ct_cp++
br_w:addcolumn(;                            // inicializa coluna
       tbcolumnnew(sistema[op_sis,O_CAMPO,t,O_TITU],;
                      &("{||"+;
                        IF(estr_dbf[t,2]=="M",;
                           "MEMOLINE("+estr_dbf[t,1]+")",;
                           "TRAN("+estr_dbf[t,1]+",["+M->ms+"])";
                        )+"}";
                       );
       );
     )
br_w:getcolumn(ct_cp):cargo := estr_dbf[t,1]+"≥"+M->ms+"≥"+sistema[op_sis,O_CAMPO,t,O_TITU]+"≥"+;
                               sistema[op_sis,O_CAMPO,t,O_WHEN]+"≥"+sistema[op_sis,O_CAMPO,t,O_CRIT]+"≥"+;
                               sistema[op_sis,O_CAMPO,t,O_HELP]+"≥"+sistema[op_sis,O_CAMPO,t,O_CMD]
br_w:getcolumn(ct_cp):width := M->tm
br_w:getcolumn(ct_cp):colorblock := &("{||IF(DELE(),{3,2},IF("+cmr_+",{5,2},{1,2}))}")
RETU

/*
   Sintaxe: SEPARA( <ExpC> )
   Funcao.: Separa atributos de campos da coluna da consulta
              ExpC = atributos (nome do campo/mascara/titulo/validacao)
   Retorna: NIL
*/
STATIC FUNC SEPARA(cp_atr)
cp_ =PARSE(@cp_atr,"≥")     // conteudo
cp_masc=PARSE(@cp_atr,"≥")  // mascara
cp_titu=PARSE(@cp_atr,"≥")  // titulo
cp_when=PARSE(@cp_atr,"≥")  // pre-validacao
cp_crit=PARSE(@cp_atr,"≥")  // validacao (critica)
cp_help=PARSE(@cp_atr,"≥")  // help do campo
cp_cmd =PARSE(@cp_atr,"≥")  // comando especial
tp_cp= TYPE(cp_)            // tipo da coluna
IF tp_cp="UI"               // se tipo indefinido
 tp_cp = VALTYPE(cp_)       // tenta pegar o conteudo do campo
 IF tp_cp = "UI"            // se ainda continua indefinido
  tp_cp="C"                 // forca caracter
 ENDI
ENDI
RETU NIL

/*
   Sintaxe: DIR_CUR()
   Funcao.: Muda direcionamento do cursor dentro da funcao EDITA() quando
            o TAB e' acionado
   Retorna: NIL
*/
STATIC FUNC DIR_CUR
dir_cur=IF(dir_cur=4,1,dir_cur+1)
@ br_w:nbottom+1,br_w:nleft+posi_cur+5 SAY CHR(VAL(SUBS(di_tecl,dir_cur*2-1,2)))
RETU NIL

/*
   Sintaxe: COLNOVA()
   Funcao.: Cria uma nova coluna na consulta
   Retorna: NIL
*/
STATIC FUNC COLNOVA
LOCAL brw_tela, ar_, i, ii, db:="", msg:="", qt_ind, op_ind
PRIV cod_sos:=1
brw_tela = SAVESCREEN(0,0,MAXROW(),79)                 // salva tela e monta
FOR i=1 TO nss                                         // menu dos arquivos possiveis
 IF sistema[i,O_ARQUI,O_NOME]!=ALIAS(VAL(m_origem)) .AND. ;
    IF(EMPTY(outro_db),.t.,sistema[i,O_ARQUI,O_NOME]!=ALIAS(VAL(outro_db))) .AND.;
    sistema[i,O_OUTROS,O_NIVEL]<=nivelop .AND.;
    LEN(sistema[i,O_INDIC])>0
  msg+="|"+sistema[i,O_MENU]
  db+=RIGHT(STR(1000+i),3)
 ENDI
NEXT
IF LEN(msg) <= 0                                       // nao existe arq a escolher
 ALERTA()
 DBOX("NÑo h† mais arquivos dispon°veis",15,,3,,"ATENÄéO!, "+usuario)
 KEYB CHR(K_ESC)
ELSE
 tit="SELECIONE O ARQUIVO|DO QUAL SERè MOSTRADO O CAMPO"
 op_a=DBOX(SUBS(msg,2),,,E_MENU,,tit)                  // escolhe um arquivo
 ar_:=SELECT()
 IF op_a>0                                             // escolheu...
  op_a=VAL(SUBS(db,op_a*3-2,3))                        // subscricao de "sistema"
  db=sistema[op_a,O_ARQUI,O_NOME]                      // nome do arquivo (sem dir)
  IF USEARQ(db)                                        // abre o arquivo
   op_ind=1                                            // indice 'default`
   qt_ind=LEN(sistema[op_a,O_INDIC])                   // qde de indices do arquivo
   IF ATAIL(sistema[op_a,O_CHAVE])="codlan"         // o ntx de relacionamento nao pode...
    qt_ind--
   ENDI
   IF qt_ind>1                                         // escolhe um conjunto de indice
    msg=""
    FOR i=1 to qt_ind
     msg+="|"+sistema[op_a,O_CONSU,i]
    NEXT
    op_ind=DBOX(SUBS(msg,2),,,E_MENU,,"SELECIONE O INDICE")
    IF op_ind>1
     DBSETORDER(op_ind)
    ENDI
   ENDI
   SELE (ar_)
   IF PEGARELA(.f.)                                    // pega campos de relacionamentos
    msg=""
    SELE (db)
    FOR i=1 TO FCOU()                                  // menu de campos
     IF !("I"==sistema[op_a,O_CAMPO,i,O_CRIT])         // exceto os invisiveis...
      msg+="|"+sistema[op_a,O_CAMPO,i,O_TITU]
     ENDI
    NEXT
    op_0=DBOX(SUBS(msg,2),,,E_MENU,,"CAMPO A MOSTRAR NA NOVA COLUNA")
    IF LASTKEY()!=K_ESC .AND. op_0 > 0                 // escolheu um campo
     ii=0
     FOR i=1 TO FCOU()                                 // acha campo escolhido
      IF !("I"==sistema[op_a,O_CAMPO,i,O_CRIT])
       ii++
      ENDI
      IF ii=op_0
       op_0=i
       EXIT
      ENDI
     NEXT
     v_ar=READVAR()                                   // titulo da coluna
     &v_ar.:=sistema[op_a,O_CAMPO,op_0,O_TITU]        // contera' o titulo do campo
     cp_masc:=sistema[op_a,O_CAMPO,op_0,O_MASC]       // mascara
     cp_ =ALLTRIM(STR(op_ind))+"}"+cp_+"|"+;       // expressao para relacionar
          db+"->"+FIEL(op_0)
    ELSE
     cp_=" "
    ENDI
   ELSE
    cp_=" "
   ENDI
  ENDI
 ENDI
 SELE (ar_)                                           // seleciona arquivo original
 f10=.t.
 KEYB CHR(K_CTRL_W)                                   // forca saida do get pendente
ENDI
RETU NIL

/*
   Sintaxe: PEGARELA( <ExpL> )
   Funcao.: Monta menu com arquivos e campos para relacionamento
              ExpL = .t. relacao entre duas janelas
                     .f. relacao entre colunas
   Retorna: .t. se teve sucesso.
*/
STATIC FUNC PEGARELA(fl)
LOCAL tit_chv:="", msg:="", op_0:=0, cp_rela:="", ii
PRIV cod_sos:=31
op_x = EVAL(qualsis,ALIAS())                // subscricao do arquivo atual
FOR i=1 TO FCOU()                           // monta menu com os campos do
 IF !("I"==sistema[op_x,O_CAMPO,i,O_CRIT])  // arquivo, exceto os invisiveis
  msg+="|"+sistema[op_x,O_CAMPO,i,O_TITU]
 ENDI
NEXT                                        // titulo da DBOX()
tit="RELACIONAMENTO|*|ESCOLHA O CAMPO PARA|SINCRONIZAR OS ARQUIVOS|ESC=FIM|*"
IF fl
 chv_rela=""                                // vai sincronizar duas janelas
ENDI
temrela=.f.
DO WHIL .t.                                 // escolhe um campo
 op_0=DBOX(SUBS(msg,2),,,E_MENU,,tit+tit_chv,,,op_0)
 IF LASTKEY()=K_ESC .OR. op_0<=0
  EXIT                                      // cancelou ou ja terminou
 ENDI
 ii=0                                       // procura campo escolhido
 FOR i=1 TO FCOU()
  IF !("I"==sistema[op_x,O_CAMPO,i,O_CRIT]) // despreza os invisiveis
   ii++
  ENDI
  IF ii=op_0
   op_0=i
   EXIT
  ENDI
 NEXT
 cp_ = FIEL(op_0)                           // campo escolhido
 IF TYPE(cp_)="M"
  DBOX("Campo ilegal",,,3,,"ATENÄéO!")      // campo memo nao pode...
  LOOP
 ELSE
  temrela=.t.                               // atualiza o titulo da DBOX()
  tit_chv+="|"+MAIUSC(sistema[op_x,O_CAMPO,op_0,O_TITU])+","
  cp_=TRANSCAMPO(.f.,cp_,op_0)              // transforma campo em caracter
  IF fl
   chv_rela+="+"+ALIAS()+"->("+cp_+")"      // chave de relacionamento entre janelas
  ENDI
  cp_rela+="+"+cp_                          // mais um campo de sincronismo?
  op_0=DBOX("Prosseguir|Informar outro campo",,,E_MENU,,"RELACIONAMENTO POR"+tit_chv)
  IF op_0!=2
   cp_=SUBS(cp_rela,2)                      // sincronismo terminado
   EXIT
  ENDI
 ENDI
ENDD
RETU temrela

/*
   Sintaxe: SETARELA( <ExpC> )
   Funcao.: Estabelece relacionamento de arquivos na consulta
              ExpC = parametros de relacionamento
   Retorna: .t. se relacionou
*/
STATIC FUNC SETARELA(p_cp)
op_ind=1                           // indice 'default`
IF VAL(p_cp)>0                     // existe um indice?
 op_ind=VAL(p_cp)                  // vamos utiliza-lo
 p_cp=SUBS(p_cp,AT("}",p_cp)+1)    // arruma expressao de relacionamento
ENDI
p_m=RAT("->",p_cp)
p_b=AT("|",p_cp)
IF p_m>0 .AND. p_b>0               // existe campo e arq para o relacionamento
 c_rel=LEFT(p_cp,p_b-1)            // campo ou expressao para a relacao
 a_u=SUBS(p_cp,p_b+1,(p_m-1)-p_b)  // nome do arquivo que sera' relacionado
 a_r_=SELEC()
 IF USEARQ(a_u)                    // abre arquivo e seus indices
  DBSETORDER(op_ind)         // indice escolhido...
  SELE (a_r_)
  ja=.f.
  FOR t=1 TO 99                    // verifica se a relacao ja' foi feita
   x=DBRSELECT(t)
   IF x>0
    IF UPPER(a_u) == ALIAS(x)
     ja=.t.                        // existe o relacionamento
     EXIT
    ENDI
   ENDI
  NEXT
  IF !ja                           // relaciona se nao tem o relacionamento
   SET RELA ADDI TO &c_rel. INTO &a_u.
  ENDI
 ELSE
  CLOSE ALL                        // ocorreu erro de abertura de arquivo
  BREAK                            // cancela toda a operacao
 ENDI
ENDI
RETU (p_m>0 .AND. p_b>0)           // retorna .t. se relacionou

* \\ Final de ADR_FUNC.PRG

