procedure adr_fun2
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADR_FUN2.PRG
 \ Data....: 29-01-04
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Fun‡”es auxiliares II
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "adrbig.ch"    // inicializa constantes manifestas

/*
   Sintaxe: CANC()
   Funcao.: Cancela impressao de relat¢rio ou consulta
   Retorna: .t. se confirmou o cancelamento.
*/
FUNC CANC()
LOCAL ii, msg, defa_dev
PRIV cod_sos:=1
defa_dev=SET(_SET_DEVICE,"SCREEN")   // direciona para video para mensagem
ALERTA()                             // beep, beep, beep
msg="Cancelar o relat¢rio|Prosseguir a impress„o"
ii=DBOX(msg,,,E_MENU,,"EMISSŽO SUSPENSA")
SET(_SET_DEVICE,defa_dev)            // redireciona para impressora ou arquivo
RETU ii=1

/*
   Sintaxe: ROLATELA()
   Funcao.: Ajusta flag e prepara rolamento de tela
   Retorna: NIL
*/
FUNC ROLATELA()
LOCAL t_atual:=SAVESCREEN(l_s,c_s,l_i,c_i)
PRIV  tela_fundo:=tela_fundo
IF rola_t                                          // rolar a tela...
 DISPBEGIN()                                       // inicia montagem da tela
 RESTSCREEN(0,0,MAXROW(),79,tela_fundo)            // restaura pano de fundo
 IMPRELA()                                         // imprime DBFs relacionados
 tela_fundo=SAVESCREEN(0,0,MAXROW(),79)            // exceto o atual
 CAIXA(mold,l_s,c_s,l_i,c_i)                       // salva novo pano de fundo e
 RESTSCREEN(l_s,c_s,l_i,c_i,t_atual)               // restaura a tela do DBF atual
 DISPEND()                                         // reapresenta tela
 MUDA_PJ(@l_s,@c_s,@l_i,@c_i,tela_fundo,tem_borda) // muda posicao da janela
 PUBL &vr_memo.:=STR(l_s,2)+STR(c_s,2)             // salva novas coordenadas da
 SAVE TO (arqconf) ALL LIKE drv*                   // janela em disco
 REST FROM (arqconf) ADDI
ELSE                                               // seta flag e abandona get pendente
 rola_t=.t.
 KEYB CHR(K_ESC)                                   // forca ESC
ENDI
RETU NIL

/*
   Sintaxe: PEGAPAI( <ExpN> )
   Funcao.: Capta o numero da subscricao do arquivo "pai de todos"
              ExpN = subscricao do arquivo relacionado
   Retorna: subscricao do "pai de todos"
*/
FUNC PEGAPAI(op_)
LOCAL ii
DO WHIL .t.
 IF LEN(sistema[op_,O_CPRELA])>0           // tem campo de ligacao com o pai?
  ii=sistema[op_,O_CPRELA,1]               // extrai o nome do arquivo da ligacao
  op_=EVAL(qualsis,LEFT(ii,AT("->",ii)-1)) // e acha a sua subscricao
  LOOP                                     // repete operacao para ver se o pai
 ENDI                                      // tambem e' filho
 EXIT
ENDD
RETU op_                                   // retorna susbcricao do pai de todos

/*
   Sintaxe: MENURELA( <ExpN> )
   Funcao.: Monta string com titulos de arquivos relacionados
              ExpN = subscricao do arquivo no vetor "sistema"
   Retorna: String
*/
FUNC MENURELA(op_)
LOCAL i, ii, menu
menu=IF(op_!=op_sis,"|"+sistema[op_,O_MENU],"") // se o DBF e' dif do atual
FOR i=1 TO LEN(sistema[op_,O_DBRELA])           // pega todos os DBF relacionados
 ii=EVAL(qualsis,sistema[op_,O_DBRELA,i])       // pega sua subscricao no vetor sistema
 IF sistema[ii,O_OUTROS,O_NIVEL]<5              // pode visualizar o arquivo?
  IF LEN(sistema[ii,O_DBRELA])>0                // se o DBF da relacao tem suas proprias
   menu=menu+MENURELA(ii)                       // relacoes chama a funcao recursivamente
  ELSE                                          // se DBF relacionado nao tem relacao
   IF ii!=op_sis                                // e nao e' o DBF atual
    menu+="|"+sistema[ii,O_MENU]                // entao monta string
   ENDI
  ENDI
 ENDI
NEXT
RETU menu                                       // retorna string dos nomes do DBFs

/*
   Sintaxe: QUALRELA( <ExpN1> <,ExpN2> <,ExpN3> )
   Funcao.: Pega subscricao do enesimo arquivo da relacao
              ExpN1 = subscricao do arquivo atual
              ExpN2 = enesimo arquivo da relacao
              ExpN3 = valor temporario que contera' a qde de arquivos
                      da relacao. Passar sempre 0.
   Retorna: Subscricao encontrada
*/
FUNC QUALRELA(op_,op_esc,qt_op)
LOCAL i, ii, menu:=0
IF op_!=op_sis                             // se nao for o DBF atual, soma
 qt_op++                                   // 1 na qde de DBFs relacionados
 IF op_esc=qt_op                           // e' o enesimo arquivo da relacao
  menu=op_                                 // prepara p/ retornar sua subscricao
 ENDI
ENDI
IF menu=0                                  // ainda nao achou o enesimo arquivo
 FOR i=1 TO LEN(sistema[op_,O_DBRELA])     // pega todos os DBF da relacao
  ii=EVAL(qualsis,sistema[op_,O_DBRELA,i]) // pega sua subscricao no vetor sistema
  IF sistema[ii,O_OUTROS,O_NIVEL]<5        // pode visualizar o arquivo?
   IF LEN(sistema[ii,O_DBRELA])>0          // se o DBF da relacao tem suas proprias
    menu=QUALRELA(ii,op_esc,@qt_op)        // relacoes chama a funcao recursivamente
    IF menu>0                              // se achou o enesimo,
     EXIT                                  // cai fora
    ENDI
   ELSE                                    // se DBF relacionado nao tem relacao
    IF ii!=op_sis                          // e nao e' o DBF atual
     IF ++qt_op=op_esc                     // entao soma qde de DBFs da relacao
      menu=ii                              // e verifica se e' o enesimo
      EXIT                                 // se for, cai fora
     ENDI
    ENDI
   ENDI
  ENDI
 NEXT
ENDI
RETU menu                                  // retorna o enesimo DBF da relacao

/*
   Sintaxe: OPCOES_REL( <N1> <,N2> <,N3> <,N4> <,C1> )
   Funcao.: Abre diversas op‡”es para emissao de relatorio
               N1,N2 = coordenada linha/coluna superior do menu de opcoes
                  N3 = Numero sequencial para montar nome de arquivo para
                       gravar as variacoes do relatorio.
                  N4 = codigo do bloco de ajuda (cod_sos)
                  C1 = filtro inicial do relatorio
   Retorna: .t. se vai prosseguir
*/
FUNC OPCOES_REL(l_m,c_m,op_rel,sos_cod,fil_ini)
LOCAL li_, op_x, ant_, cr_i, or_i, t_opc:=SAVESCREEN(0,0,MAXROW(),79)
op_x=LRELA(l_m,c_m,op_rel)     // verifica/seleciona relatorios gravados
IF op_x=2                      // leu um relatorio gravado anteriormente
 improk=.t.
 IF tps=1                      // vai para impressora...
  improk=PREPIMP()             // confima preparacao da impressora
 ENDI
 IF !improk                    // cancelou
  op_x=0
 ELSE
  INDTMP()                     // verifica/indexa o arquivo se for necessario
 ENDI
 RETU .t.                      // retorna
ENDI
fil_ini=IF(fil_ini=NIL,"",fil_ini)
nucop=1
or_i=cpord                     // salva ordenacao inicial
ant_=criterio+cpord+titrel     // salva criterio, ordenacao e titulo atuais
DO WHIL op_x>0
 cod_sos=sos_cod
 msg="Prosseguir|Sa¡da: "        // monta menu de opcoes
 IF tps=1 .AND. !EMPTY(drvporta) // se a saida e para prn
  msg+=drvmarca+" em "+drvporta  // pega conf atual
 ELSE                            // caso contrario
  msg+="Arquivo/Video"           // coloca a palavra "Arquivo/Video"
 ENDI
 msg+="|Filtrar|C¢pia(s) ("+TRAN(nucop,"99")+")"+;
      "|Ordenar|T¡tulo"
 IF !EMPTY(titrel)             // se tem titulo coloca-o no menu
  msg+=": "+IF(LEN(titrel)>30,LEFT(titrel,30)+"...",titrel)
 ENDI
 cr_i=criterio+cpord+titrel    // se tem alteracao, liga
 gr_rela=(ant_!=cr_i)          // flag de gravacao de relatorio
 msgt="OP€”ES DO RELAT¢RIO"    // recebe opcao desejada
 RESTSCREEN(0,0,MAXROW(),79,t_opc)
 op_x=DBOX(msg,l_m,c_m,E_MENU,NAO_APAGA,msgt,,,op_x)
 DO CASE
  CASE op_x=1                  // prossegue...
   IF tps=1                    // vai para impressora.....
    IF !PREPIMP()              // pede confirmacao da impressora
     LOOP                      // nao quis mais, volta para menu de opcoes
    ENDI
   ENDI
   IF LEN(fil_ini)>0           // se tem filtro inicial
    IF LEN(criterio)>0         // vamos concatenar com filtro feito pelo usuario
     criterio=fil_ini+".AND. ("+criterio+")"
    ELSE
     criterio=fil_ini          // usuario nao fez filtro. Pega o inicial...
    ENDI
   ENDI
   INDTMP()                    // verifica/indexa o arquivo se for necessario
   EXIT

  CASE op_x=2                  // tipo de saida
   tps=TP_SAIDA(IF(l_m=NIL,NIL,l_m+2),IF(c_m=NIL,NIL,c_m+8),.t.)

  CASE op_x=3                  // pega criterio de selecao dos registro
   FILTRA(.f.)                 // parametro .f. = nao indexa ao final da selecao

  CASE op_x=4                  // numero de copias a emitir
   nucop=DBOX("(de 1 a 99)",IF(l_m=NIL,NIL,l_m+2),IF(c_m=NIL,NIL,c_m+8),,,"QUANTIDADE DE C¢PIAS",nucop,"99")
   nucop=IF(nucop<1.OR.LASTKEY()=K_ESC,1,nucop)

  CASE op_x=5                  // escolhe uma nova ordem
   cpord=or_i                  // inicializa ordenacao
   CLASS(.f.)

  CASE op_x=6                  // recebe um titulo para o sistema
   msg="Informe, se Desejar:"
   titrel=LEFT(titrel+SPAC(70),70)
   titrel=ALLTRIM(DBOX(msg,,,,,"T¡TULO DO RELAT¢RIO",titrel))
   RESTSCREEN(0,0,MAXROW(),79,t_opc)

 ENDC
ENDD                           // restaura a tela
RESTSCREEN(0,0,MAXROW(),79,t_opc)
RETU(op_x=1)                   // retorna .t. se quiser prosseguir

/*
   Sintaxe: TP_SAIDA( <N1> <,N2> <,L> )
   Funcao.: Permite a escolha das diversas configuracoes da impressora
              N1,N2 = coordenada linha/coluna superior do menu
               ExpL = se .t. deixa escolher saida para arquivo/video
   Retorna: o tipo de saida escolhido
*/
FUNC TP_SAIDA(l_tp,c_tp,arq_vid)
LOCAL ar_, i:=1
tps:=IF(TYPE("tps")="N",tps,1)
ar_=SELECT()               // salva area atual e
SELE 0                     // vai p/ uma area vazia

#ifdef COM_REDE
 IF ! USEARQ(arq_prn,.f.,20,1,.f.)
  RETU tps                 // falhou abertura, retorna
 ENDI
#else
 USE (arq_prn)             // abre arquivo de configuracoes
#endi

msg=""                     // variavel que contera as configuracoes
DO WHIL !EOF()             // le todo o arquivo
 msg+="|"+ALLTRIM(marca)+; // e vai montando a variavel
      " em "+porta         // para o menu de tipos de saidas
 IF drvporta=porta .AND.;  // pega impressora configurada
    drvmarca=ALLTRIM(marca)// para o default do menu
  i=RECNO()
 ENDI
 SKIP
ENDD
msg=SUBS(msg,2)            // retira o primeiro "|"
IF arq_vid                 // se pode enviar para arq/video
 IF !EMPTY(msg)            // se tem impressora
  msg+="|"                 // coloca conector
 ENDI
 msg+="Arquivo/Video"     // acrescenta esta opcao
END IF
IF !EMPTY(msg)
 i=DBOX(msg,l_tp,c_tp,E_MENU,,"TIPO DE SA¡DA",,,i)
 IF i>0                     // escolheu um tipo...
  tps=IF(i<=RECC(),1,2)     // ajusta tps: 1-impressora, 2=arquivo
  IF tps=1
   drvprn=i                 // ajusta default da configuracao atual
   GO drvprn                // reinicializa as variaveis de impressao
   FOR i=1 TO FCOU()        // de acordo com configuracao escolhida
    msg=FIEL(i)
    drv&msg.=ALLTRIM(FIELDGET(i))
   NEXT
   SAVE TO (arqconf) ALL LIKE drv* // salva mo disco configuracao escolhida
  ENDI
 ENDI
ENDI
USE                        // fecha o arq de conf de prn
SELE (ar_)                 // volta para area anterior
RETU tps

/*
   Sintaxe: TRANSCAMPO( <ExpL> <,ExpC> [,ExpN] [,ExpL] )
   Funcao.: Adapta campo para pesquisa segundo seu tipo
             ExpL = se .t. monta expressao com conteudo do campo, caso
                    contrario, monta expressao com o nome do campo
             ExpC = nome do campo para adaptacao
             ExpN = numero do campo dentro da estrutura do DBF
             ExpL = se .t. ou nula data sera tranformada para DTOS()
                    caso contratio, datas sera transformada para DTOC()
   Retorna: String convertida
*/
FUNC TRANSCAMPO(conteudo_,chv_,indcp_,fdata_)
LOCAL tp_cp:=VALTYPE(&chv_.), cp_, estr_dbf:=DBSTRUCT()
 fdata_=IF(fdata_=NIL, .t., fdata_)
IF conteudo_
 IF tp_cp="D"
  IF fdata_
   cp_=DTOS(&chv_.)
  ELSE
   cp_=DTOC(&chv_.)
  ENDI
 ELSEIF tp_cp="N"
  IF indcp_=NIL
   cp_=STR(&chv_.)
  ELSE
   cp_=STR(&chv_.,estr_dbf[indcp_,3],estr_dbf[indcp_,4])
  ENDI
 ELSE
  cp_=&chv_.
 ENDI
ELSE
 IF tp_cp="D"
  IF fdata_
   cp_="DTOS("+chv_+")"
  ELSE
   cp_="DTOC("+chv_+")"
  ENDI
 ELSEIF tp_cp="N"
  IF indcp_=NIL
   cp_="STR("+chv_+")"
  ELSE
   cp_="STR("+chv_+","+LPAD(estr_dbf[indcp_,3],2,"0")+","+LPAD(estr_dbf[indcp_,4],2,"0")+")"
  ENDI
 ELSE
  cp_=chv_
 ENDI
ENDI
RETU cp_

/*
   Sintaxe: ARQGER()
   Funcao.: recebe nome do arquivo
   Retorna: String (nome do arquivo)
*/
FUNC ARQGER()
LOCAL defa_:=drvdbf+"TMP"+ide_maq, t_l, t_r
t_l=SETKEY(K_LEFT,NIL)                         // desabilita seta -> e <-
t_r=SETKEY(K_RIGHT,NIL)
KEYB CHR(K_END)                                   // cursor no final do drive sugerido
mask_="*.PRN"                                     // mascara dos campos da lista
SET KEY K_F10 TO CAPTURAARQ()                     // f10 pega arq da lista
arq_=DBOX("Nome do arquivo",,,,,"ARQUIVO EM DISCO|F10=captura arquivo",PADR(defa_,150),"@S50@!")
SET KEY K_F10 TO                                  // desativa f10
arq_=TRIM(arq_)
SETKEY(K_LEFT,t_l)                             // reabilita setas cursoras
SETKEY(K_RIGHT,t_r)
RETU IF(LEN(SUBS(arq_,RAT("\",arq_)+1))<1.OR.; // nome do arquivo sem dir ou
     LASTKEY()=K_ESC,"",arq_)                  // ou cancelou

/*
   Sintaxe: PREPIMP( [msgt] )
   Funcao.: Apresenta mensagem para preparo da impressora
            msgt=titulo para menu
   Retorna: .t. se pronta
*/
FUNC PREPIMP(msgt)
PRIV cod_sos:=29
msgt=IF(msgt=NIL,"ATEN€ŽO, "+usuario,msgt)
ALERTA(3)
op_=1
DO WHILE op_=1
 msg="Impressora pronta|Cancelar opera‡„o"
 op_=DBOX(msg,,,E_MENU,,msgt)             // solicita preparo da impressora
 IF LEFT(drvporta,3)="LPT".AND.op_=1
  IF !IMPOK(VAL(SUBS(drvporta,4,1)))      // porta paralela podemos testar
   ALERTA(4)
   DBOX("Impressora n„o pronta!",,,,,"ATEN€ŽO, "+usuario)
   LOOP                                   // fora de linha, ficamos por aqui
  ENDI
 ENDI
 EXIT                                     // s'imbora
ENDD
RETU (op_=1)                              // retorna .T. se pronta

/*
   Sintaxe: CONFINCL()
   Funcao.: Apresenta mensagem para confirmar a inclusao
   Retorna: .t. se inclusao ok
*/
FUNC CONFINCL()
PRIV cod_sos:=1
ALERTA(2)
op_=1
msg="Efetuar inclus„o|Corrigir digita‡„o"
op_=DBOX(msg,l_i-1,c_i-10,E_MENU,,"ATEN€ŽO, "+usuario) // solicita confirmacao
RETU (op_=1)     // retorna .T. se quer incluir

/*
   Sintaxe: CONFEXCL()
   Funcao.: Apresenta mensagem para confirmacao da exclusao e
            verifica se o reg pode ser excluido
   Retorna: .t. se ok
*/
FUNC CONFEXCL()
LOCAL op_:=1
PRIV cod_sos:=1
IF drvexcl                                      // se conf de exclusao
 ALERTA(1)                                      // esta ligada, vamos
 cod_sos=1                                      // pedir confirmacao
 msg=IF(LEN(sistema[op_sis,O_DBRELA])>0,"|(INCLUSIVE RELACIONADOS)","")
 msg="EXCLUIR"+msg
 op_=DBOX("Sim|N„o",17,,E_MENU,,msg)
ENDI
IF op_=1.AND.!EMPT(sistema[op_sis,O_CONDEXC,1]) // se tem condicao de
 IF !&(sistema[op_sis,O_CONDEXC,1])             // exclusao e se esse
  ALERTA(2)                                     // reg nao pode ser
  op_=2                                         // excluido, avisa o
  msg=sistema[op_sis,O_CONDEXC,2]               // motivo e prepara
  DBOX(msg,,,,,"ATEN€ŽO!|IMPOSS¡VEL EXCLUIR")   // para retornar .f.
 ENDI
ENDI
RETU op_=1

/*
   Sintaxe: CONFALT()
   Funcao.: verifica se o reg pode ser alterado
   Retorna: .t. se ok
*/
FUNC CONFALT()
LOCAL op_:=1
PRIV cod_sos:=1
IF !EMPT(sistema[op_sis,O_CONDALT,1])         // se tem condicao de
 IF !&(sistema[op_sis,O_CONDALT,1])           // alteracao e se esse
  ALERTA(2)                                   // reg nao pode ser
  op_=2                                       // alterado, avisa o
  msg=sistema[op_sis,O_CONDALT,2]             // motivo e prepara
  DBOX(msg,,,,,"ATEN€ŽO!|IMPOSS¡VEL ALTERAR") // para retornar .f.
 ENDI
ENDI
RETU op_=1

/*
   Sintaxe: ROLAPOP( <ExpN> )
   Funcao.: Efetua a rolagem do menu pop-down
   Retorna: NIL
*/
FUNC ROLAPOP(q_t)
IF q_t=NIL               // se nao tem parametro desabilita setas da
 SETKEY(K_LEFT,NIL)      // esquerda/direita, caso contrario, liga as
 SETKEY(K_RIGHT,NIL)     // teclas com a qde de ESC, SETA e ENTER
ELSE                     // nesessarios para rolar a janela na horizontal
 SETKEY(K_LEFT,{||KEYBUFF(REPL(CHR(K_ESC),q_t)+CHR(K_LEFT)+CHR(K_ENTER))})
 SETKEY(K_RIGHT,{||KEYBUFF(REPL(CHR(K_ESC),q_t)+CHR(K_RIGHT)+CHR(K_ENTER))})
ENDI
RETU NIL

/*
   Sintaxe: PEGADIR( <ExpL> )
   Funcao.: Pega novo diret¢rio de trabalho para a aplica‡„o
              ExpL = se .f., so pega diretorios de dados e de indices
                     se .t. recebe o diret¢rio do ERROS.DBF tambem
   Retorna: .t. se nao foi cancelado
*/
FUNC PEGADIR(pri_vez)
LOCAL cn, drv_dbf, drv_ntx, drv_err:=drverr, t, msgt, msg, ado_, aio_,;
      add_, aid_, drv_, ntx_, cria_dbf:=.f., u_drv, u_ntx
cn=.f.

#ifdef COM_PROTECAO
 IF !pri_vez                                     // se veio do apoio
  EVAL(protdbf,.f.)                              // protege DBFs
 ENDI
#endi

IF !pri_vez                                      // so quer trocar diretorio
 SAVE TO (arqconf) ALL LIKE drv*                 // salva configuracao atual
ENDI
u_drv=drvdbf
u_ntx=drvntx
FOR t=0 TO nss-3
 IF t=0 .OR. sistema[t,O_OUTROS,O_PEDEDIR]       // pedir diretorio deste arq?
  IF t=0
   msgt="DIRET¢RIOS DE TRABALHO"
   drv_="drvdbf"
   ntx_="drvntx"
  ELSE
   msgt="DIRET¢RIO EXCLUSIVO DO|SUBSISTEMA '"+UPPER(sistema[t,O_MENU])+"`"
   drv_="drvdbf"+LEFT(sistema[t,O_ARQUI,O_NOME],3)
   ntx_="drvntx"+LEFT(sistema[t,O_ARQUI,O_NOME],3)
  ENDI
  msgt+="|F10=captura diret¢rio"
  drv_dbf=&drv_.
  drv_ntx=&ntx_.
  DO WHIL !cn
   SET KEY K_F10 TO CAPTURADIR()                 // f10 pega diretorio
   msg="Arquivo de dados"
   &drv_.=u_drv
   &drv_.=DBOX(msg,,,,,msgt,PADR(&drv_.,50),"@!")// diretorio dos DBF
   IF LASTKEY()=K_ESC                            // cancelou
    cn=.t.                                       // flag de cancelamento
    &drv_.=drv_dbf                               // desfaz drives modificados
    &ntx_.=drv_ntx
    LOOP
   ENDI
   &drv_.=TRATADIR(ALLTRIM(&drv_.))              // tira espacos e coloca "\" no final
   IF !criadrv(&drv_.)                           // verifica/cria diretorio
    LOOP                                         // desistiu de criar
   ENDI
   msg+=": "+&drv_.                              // diretorio dos NTX
   u_drv=&drv_.
   &ntx_.=u_ntx
   &ntx_.=DBOX(msg+"|*|Arquivos de ¡ndices",,,,,msgt,PADR(&ntx_.,50),"@!")
   IF LASTKEY()=K_ESC                            // se cancelou,
    LOOP                                         // volta a pedir dir DBF
   ENDI
   &ntx_.=TRATADIR(ALLTRIM(&ntx_.))              // tira espacos e coloca "\" no final
   IF !criadrv(&ntx_.)                           // verifica/cria diretorio
    LOOP                                         // desistiu de criar
   ENDI
   u_ntx=&ntx_.
   msg+="|Arquivo de ¡ndices: "+&ntx_.
   IF pri_vez .AND. t=0                          // recebe diretorio do ERROS.DBF
    drverr=DBOX(msg+"|*|Arquivos de apoio … aplica‡„o:",,,,,msgt,PADR(drverr,50),"@!")
    IF LASTKEY()=K_ESC                           // se cancelou,
     LOOP                                        // volta a pedir dir DBF
    ENDI
    drverr=TRATADIR(ALLTRIM(drverr))             // tira espacos e coloca "\" no final
    IF !criadrv(drverr)                          // verifica/cria diretorio
     LOOP                                        // desistiu de criar
    ENDI
    msg+="|Arquivos de apoio: "+drverr
    drvpw=DBOX(msg+"|*|Arquivo de senhas:",,,,,msgt,PADR(drvpw,50),"@!")
    IF LASTKEY()=K_ESC                           // se cancelou,
     LOOP                                        // volta a pedir dir DBF SENHAS
    ENDI
    drvpw=TRATADIR(ALLTRIM(drvpw))               // tira espacos e coloca "\" no final
    IF !criadrv(drvpw)                           // verifica/cria diretorio
     LOOP                                        // desistiu de criar
    ENDI
    msg+="|Arquivo de senhas: "+drvpw
   ENDI
   msg=msgt+"|*|"+msg
   SET KEY K_F10 TO
   ALERTA(1)
   op_=DBOX("Prosseguir|Corrigir",,,E_MENU,,msg) // confirma as informacoes
   IF op_=1                                      // se tudo certo,
    EXIT                                         // sai do loop
   ENDI
  ENDD
  SET KEY K_F10 TO
  IF (!(&drv_.==drv_dbf) .OR.;                   // se mudou diretorio de trabalho
     !(&ntx_.==drv_ntx))                         // e nao for a primeira vez, seta
   cria_dbf=.t.
  ENDI
  IF !pri_vez                                    // se nao for a 1a. vez
   EXIT                                          // nao pega dir dos dbf exclusivos
  ENDI
 ENDI
NEXT
IF cn                                            // se cancelou,
 IF !pri_vez
  REST FROM (arqconf) ADDI                       // restaura configuracoes
 ENDI
ELSE
 ADR_ATRI()                                      // vamos reenche-lo
 ADR_ATR1()
 ADR_ATR2()
 IF cria_dbf .AND. !pri_vez                      // mudou diretorios?
  cn=!CRIADBF()                                  // cria dbf's e ntx's
 ENDI
 SAVE TO (arqconf) ALL LIKE drv*                 // salva diretorios no disco
ENDI

#ifdef COM_PROTECAO
 IF !pri_vez                                     // se veio do apoio
  EVAL(protdbf,.t.)                              // desprotege DBFs
 ENDI
#endi

RETU !cn

FUNC TRATADIR(drv_)  // trata diretorio informado
drv_=ALLTRIM(drv_)                               // tira espacos
drv_=IF(RIGHT(drv_,1)!="\".AND.;                 // diretorio tem que
       LEN(drv_)>0,drv_+"\",drv_)                // terminar com barra (\)
RETU drv_

/*
   Sintaxe: CRIADRV( <ExpC> )
   Funcao.: Testa/cria se nao exitir o diretorio ExpC
   Retorna: .t. se teve sucesso.
*/
FUNC CRIADRV(drv_)
LOCAL drv_atual:="\"+CURDIR(),x
drv_=LEFT(drv_,LEN(drv_)-1)
IF !CHDIR(drv_) .AND. LEN(drv_)>2              // se diretorio nao existe
 ALERTA(2)                                     // beep, beep e
 x="Criar "+drv_+"|Digitar outro diret¢rio"    // pergunta se quer
 op_=DBOX(x,,,E_MENU,,"DIRET¢RIO NŽO EXISTE!") // cria-lo
 IF op_!=1                                     // se nao quis...
  RETU .f.                                     // retorna
 ENDI
 IF !MKDIR(drv_)                               // se nao conseguiu criar
  ALERTA(4)                                    // avisa e retorna
  x="Erro ao criar o diret¢rio"
  op_=DBOX(x,,,3,,"ERRO!")
  RETU .f.
 ENDI
ELSE                                           // ok diretorio existe
 CHDIR(drv_atual)                              // posiciona dentro dele
ENDI
RETU .t.

PROC RCLA     // reconstroi indices
LOCAL msg, op_a:=1, db, ii, rcla_t, cur_atual:=SETCURSOR(0)
msg:=db := ""                                   // monta menu de dbf
FOR i=1 TO nss-IF(nivelop=3,0,3)                // se for o gerente, entra
 IF LEN(sistema[i,O_CPRELA])=0 .AND.;           // so o "pai" e se
    LEN(sistema[i,O_INDIC])>0                   // tiver indice definido
  msg+="|"+sistema[i,O_MENU]                    // este entra no menu...
  db+=RIGHT(STR(1000+i),3)                      // subscricao dentro de "sistema"
 ENDI
NEXT
rcla_t=SAVESCREEN(0,0,MAXROW(),79)              // sava tela
DO WHIL op_a>0
 op_sis=1
 RESTSCREEN(0,0,MAXROW(),79,rcla_t)             // escolhe um dbf para indexacao
 op_a=DBOX(SUBS(msg,2),03,55,E_MENU,NAO_APAGA,"BASE DE DADOS",,,op_a)
 IF op_a>0                                      // escolheu um...
  op_sis=op_a
  ii=VAL(SUBS(db,op_sis*3-2,3))                 // acha sua subscricao
  FOR op_sis=ii TO nss                          // indexa "pais e filhos"
   IF PEGAPAI(op_sis)!=ii                       // nao e' um "filho"
    EXIT
   ENDI
   dbf=sistema[op_sis,O_ARQUI,O_NOME]           // nome do arquivo dbf

   #ifdef COM_REDE
    IF !USEARQ(dbf,.t.,5,1,.f.)                 // se nao conseguiu abrir o dbf
     RETU                                       // cancela a operacao
    ENDI
   #else
    USEARQ(dbf,,,,.f.)                          // abre o arquivo
   #endi

   FOR t=1 TO LEN(sistema[op_sis,O_INDIC])      // recria todos os ntx do arquivo
    ntx=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,t]+EXTENSAO() // nome do indice
    POE_GAUGE("Classificando o arquivo|"+ntx,"AGUARDE!")
    chvind=sistema[op_sis,O_CHAVE,t]            // chave de indexacao
    INDE ON &chvind. TO (ntx) EVAL POE_GAUGE() EVERY (LASTREC()/20)
   NEXT
   CLOS ALL
  NEXT
  op_a++                                        // default para o proximo
 ENDI
ENDD
 SETCURSOR(cur_atual)                           // retorna o cursor ao normal
RETU

PROC COMPACTA    // exclusao fisica de registros
LOCAL msg, op_a:=1, db, ii, pack_t, cur_atual:=SETCURSOR(0)
LOCAL dele_atu:=SET(_SET_DELETED,.t.), tmp
msg:=db := ""
FOR i=1 TO nss-IF(nivelop=3,0,3)          // monta menu de arquivos
 IF LEN(sistema[i,O_CPRELA])=0 .AND.;  // so entre os "pais" e
    LEN(sistema[i,O_INDIC])>0          // quem tem indice
  msg+="|"+sistema[i,O_MENU]           // este serve
  db+=RIGHT(STR(1000+i),3)             // subscricao dentro de "sistema"
 ENDI
NEXT
pack_t=SAVESCREEN(0,0,MAXROW(),79)     // salva tela
DO WHIL op_a>0
 op_sis=1
 RESTSCREEN(0,0,MAXROW(),79,pack_t)    // escolhe um arquivo para o pack
 op_a=DBOX(SUBS(msg,2),03,55,E_MENU,NAO_APAGA,"BASE DE DADOS",,,op_a)
 IF op_a>0                             // escolheu um...
  op_sis=op_a                          // subscricao do dbf escolhido
  ii=VAL(SUBS(db,op_sis*3-2,3))
  FOR op_sis=ii TO nss                 // compacta o "pai e seus filhos"
   IF PEGAPAI(op_sis)!=ii              // e' "filho"?
    EXIT
   ENDI
   dbf=sistema[op_sis,O_ARQUI,O_NOME]  // nome do dbf

   #ifdef COM_REDE
    IF !USEARQ(dbf,.t.,5,1,.f.)        // se nao conseguiu abrir o arquivo
    SET(_SET_DELETED,dele_atu)         // os excluidos serao vistos
     RETU                              // cancela a operacao
    ENDI
   #else
    USEARQ(dbf,,,,.f.)                 // abre o arquivo
   #endi

   dbf=sistema[op_sis,O_ARQUI,O_DIR_DBF]+dbf           // nome do dbf
   tmp=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"temp$.dbf"   // nome tmp para copiar
   POE_GAUGE("Compactando o arquivo|"+dbf,"AGUARDE!","Registros feitos:")  // msg de gauge
   GO TOP                                              // inicio do dbf
   COPY TO &tmp. WHILE POE_GAUGE()                     // copia reg nao excluido para tmp
   CLOS ALL                                            // fecha o arquivo
   ERASE &dbf..dbf                                     // apaga arq dbf
   RENAME &tmp. TO &dbf..dbf                           // remomea temp para o dbf
   dbf+=EXTENSAO(.f.)                                  // idem para o .dbt se existir
   tmp=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"temp$"+EXTENSAO(.f.) // nome do .dbt temporario
   IF FILE(dbf)                                        // .dbt existe?
    ERASE (dbf)                                        // apaga e
    RENAME (tmp) TO (dbf)                              // copia tmp para o .dbt
   ENDI
   dbf=sistema[op_sis,O_ARQUI,O_NOME]           // nome do dbf

   #ifdef COM_REDE
    IF !USEARQ(dbf,.t.,5,1,.f.)                 // se nao conseguiu abrir o dbf
     SET(_SET_DELETED,dele_atu)                 // os excluidos serao vistos
     RETU                                       // cancela a operacao
    ENDI
   #else
    USEARQ(dbf,,,,.f.)                          // abre o arquivo sem indice
   #endi

   FOR t=1 TO LEN(sistema[op_sis,O_INDIC])   // recria todos os ntx do arquivo
    ntx=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,t]+EXTENSAO() // nome do indice
    POE_GAUGE("Classificando o arquivo|"+ntx,"AGUARDE!")
    chvind=sistema[op_sis,O_CHAVE,t]                                // chave de indexacao
    INDE ON &chvind. TO (ntx) EVAL POE_GAUGE() EVERY (LASTREC()/20) // indexa colocando gauge
   NEXT
   CLOS ALL
  NEXT
  op_a++
 ENDI
ENDD
SET(_SET_DELETED,dele_atu)             // os excluidos serao vistos
SETCURSOR(cur_atual)              // retorna o cursor ao normal
RETU

PROC CONFCORES      // Configura‡„o de cores
LOCAL fez_conf:=.f.
NAOPISCA()                                   // habilita 256 cores (ega/vga)
maxfore=IF(CARDTYPE()>=V_EGA, 32, 16)        // numero maximo de cores
maxcol =IF(CARDTYPE()>=V_EGA, 71, 39)        // ultima coluna das cores

tb={;
     "N" , "B"  , "G"  , "BG" ,;             // tabela de cores literais
     "R" , "RB" , "GR" , "W"  ,;
     "N+", "B+" , "G+" , "BG+",;
     "R+", "RB+", "GR+", "W+" ;
   }
qcor={;
       drvcorpad, drvcorbox, drvcormsg,;     // cores configuraveis
       drvcorenf, drvcorget, drvcortel,;
       drvcortna, drvcorhlp;
     }

qtit={;
       drvtitpad, drvtitbox, drvtitmsg,;     // cores de titulos configuraveis
       drvtitenf, drvtitget, drvtittel,;
       drvtittna, drvtithlp;
     }

SET CURSO OFF                                // apaga cursor
SETCOLOR(drvcorbox)
CAIXA(mold+" ",12,5,23,maxcol)
FOR fundo=0 TO 7                             // monta janela de selecao
 FOR frente=0 TO maxfore-1                   // das cores a serem configuradas
  cor=STR(frente,2)+"/"+STR(fundo,1)+IF(frente>15,"*","")
  SETCOLOR(cor)
  @ 14+fundo,6+(2*frente) SAY " þ "
 NEXT
NEXT
op_cor=1
DO WHILE .t.
 cod_sos=44
 msg="Pano do fundo|Janelas|Caixas de di logos|Avisos e erros|Menus e campos|Tela de digita‡„o|Tela de digita‡„o n„o ativa|Janela de ajuda"
 op_cor=DBOX(msg,4,38,E_MENU,,"ESQUEMAS DE CORES",,,op_cor)
 IF op_cor=0                                 // volta ao menu
  EXIT
 ENDI
 fg=LEFT(qcor[op_cor],AT("/",qcor[op_cor])-1)// cor da frente literal
 fg=ASCAN(tb,{|ve_a|fg==ve_a})               // numero da cor da frente
 bg=SUBS(qcor[op_cor],AT("/",qcor[op_cor])+1)// cor do fundo  literal
 IF "*" $ bg                                 // se 'blink` soma 16 na cor
  bg=STRTRAN(bg,"*"); fg=fg+16               // da frente
 ENDI
 bg=ASCAN(tb,{|ve_a|bg==ve_a})               // numero da cor do fundo
 ti=LEFT(qtit[op_cor],AT("/",qtit[op_cor])-1)// cor da frente do titulo literal
 ti=ASCAN(tb,{|ve_a|ti==ve_a})               // numero da cor da titulo
 tela_cor=SAVESCREEN(0,0,MAXROW(),79)
 qcor_antes=qcor[op_cor]; qtit_antes=qtit[op_cor]
 DO WHILE .t.
  SETCOLOR(qtit[op_cor])                     // monta janela para exemplo
  CAIXA(mold,4,33,12,64)                     // da selecao de cores
  @ 6,34 SAY REPL("Ä",30)
  @ 5,34 SAY "EXEMPLO DO ESQUEMA SELECIONADO"
  SETCOLOR(qcor[op_cor])
  IF op_cor=1                                // enche caixa-exemplo com
   FOR t=1 TO 5                              // o fundo que estiver selecionado
    @ 6+t,34 SAY REPL(drvcara,30)
   NEXT
  ELSE                                       // mostra mensagens na caixa-exemplo
   @  8,34 SAY PADC(CHR(24)+" e "+CHR(25)+" muda fundo",30)
   @  9,34 SAY PADC("^"+CHR(27)+" e ^"+CHR(26)+" muda t¡tulo",30)
   @ 10,34 SAY PADC("ENTER para aceitar esquema",30)
   @ 11,34 SAY PADC("ESC para terminar",30)
   IF op_cor=5                               // se for menu, mostra como
    SETCOLOR(INVCOR(qcor[5]))                // vai ficar
   ENDI
   @ 7,34 SAY PADC(CHR(27)+" e "+CHR(26)+" muda frente",30)
  ENDI
  SETCOLOR(drvcorbox)
  tc_=SAVESCREEN(12,5,23,maxcol)
  IF INT(fg/17)!=INT(ti/17)                  // fundo do titulo tem que
   ti=IF(fg>16,ti+16,ti-16)                  // ter a mesma cor do restante
  ENDI
  le=12+bg; ce=fg*2+4; ct=ti*2+5
  @ le,ce,le+2,ce+2 BOX LEFT(mold,8)         // imprime caixa de selecao
  IF op_cor>1                                // se nao for pano de fundo,
   @ 22,Ct SAY CHR(30)                       // imprime ponteiro de selecao
  ENDI                                       // da cor do titulo
  cod_sos=51

  #ifdef COM_MOUSE
   tecl=MOUSETECLA(14,7,22,7+(maxfore-1)*2)  // teclou algo ou clicou o mouse?
   IF tecl=CLICK                             // o mouse foi clicado
    li:=co:=0
    MOUSEGET(@li,@co)                        // coordenadas do mouse
    IF li=22                                 // lin 22 quer modificar o titulo
     ct=co+IF(co%2=0,1,0)
     IF ti=(ct-5)/2                          // clicado 2 vezes no mesmo lugar
      tecl=K_ENTER                           // forca saida da configuracao
     ELSE
      ti=(ct-5)/2                            // calcula nova cor do titulo
      tecl=32
     ENDI
    ELSE                                     // clicou em cima das cores
     le=li; ce=co-IF(co%2=0,0,1)
     IF bg=le-13 .AND. fg=(ce-4)/2           // 2 vezes no mesmo lugar
      tecl=K_ENTER                           // forca saida
     ELSE
      bg=le-13; fg=(ce-4)/2                  // calcula novas cores
      tecl=32
     ENDI
    ENDI
   ENDI
  #else

   tecl=IN_KEY(0)

  #endi

  RESTSCREEN(12,5,23,maxcol,tc_)
  IF fg<17
   liminf=1; limsup=16
  ELSE
   liminf=17; limsup=32
  ENDI
  DO CASE
   CASE tecl=K_ESC                           // abandonou
    qcor[op_cor]=qcor_antes                  // restaura cores anteriores
    qtit[op_cor]=qtit_antes
    EXIT

   CASE tecl=K_ENTER                         // escolheu cor
    EXIT

   CASE tecl=K_CTRL_D                        // pra direita
    fg=IF(fg<maxfore,fg+1,1)

   CASE tecl=K_CTRL_S                        // para esquerda
    fg=IF(fg>1 ,fg-1,maxfore)

   CASE tecl=K_CTRL_E                        // para cima
    bg=IF(bg>1,bg-1,7)

   CASE tecl=K_CTRL_X                        // para baixo
    bg=IF(bg<8,bg+1,1)

   CASE tecl=K_F1                            // help
    EVAL(SETKEY(K_F1))

   CASE tecl=K_CTRL_RIGHT .AND. op_cor>1     // pra direita
    ti=IF(ti<limsup,ti+1,liminf)

   CASE tecl=K_CTRL_LEFT .AND. op_cor>1      // para esquerda
    ti=IF(ti>liminf,ti-1,limsup)

  ENDC
  /*
     converte cor numerica em cor literal
  */
  qcor[op_cor]=tb[fg-IF(fg>16,16,0)]+"/"+tb[bg]+IF(fg>16,"*","")
  qtit[op_cor]=tb[ti-IF(ti>16,16,0)]+"/"+tb[bg]+IF(fg>16,"*","")
 ENDD
 IF qcor[op_cor]!=qcor_antes .OR. qtit[op_cor]!=qtit_antes
  fez_conf=.t.                               // trocou de cor
 ENDI
 RESTSCREEN(0,0,MAXROW(),79,tela_cor)
ENDD
SET CURSO ON                                 // acende o cursor
IF fez_conf                                  // configurou cores
 drvcorpad=qcor[1]; drvcorbox=qcor[2]        // significa que as cores
 drvcormsg=qcor[3]; drvcorenf=qcor[4]        // foram alteradas, entao,
 drvcorget=qcor[5]; drvcortel=qcor[6]        // move para as variaveis do sistema
 drvcortna=qcor[7]; drvcorhlp=qcor[8]
 drvtitpad=qtit[1]; drvtitbox=qtit[2]
 drvtitmsg=qtit[3]; drvtitenf=qtit[4]
 drvtitget=qtit[5]; drvtittel=qtit[6]
 drvtittna=qtit[7]; drvtithlp=qtit[8]
 SETCOLOR(drvcorpad+","+drvcorget+",,,"+drvcortel)
 SAVE TO (arqconf) ALL LIKE drv*             // grava configuracoes,
 corcampo=drvtittel                          // cor "unselected"
 CBC1()
 v01=SAVESCREEN(0,0,MAXROW(),79)             // salva para o break
 BREAK                                       // forca a volta para o menu geral
ENDI
SET CURSO ON                                 // acende o cursor
RETU


PROC CONFPRN     // Cria/Muda configuracao para a impressora
LOCAL i,l_,c_,op_imp:=1
PRIV  ar_prn, pd_prn                 // area do arquivo de configuracoes

pd_prn="1. IBM  9 pinos   |2. IBM 24 pinos   |3. Epson  9 pinos |"+;
       "4. Epson 24 pinos |5. Hp DeskJet     |6. Hp DeskJet Plus|"+;
       "7. Hp LaseJet II  |8. Hp LaseJet III  "  // padroes das impressoras
#ifdef COM_REDE
 IF ! USEARQ(arq_prn,.t.,20,1,.f.)   // falhou abertura modo
  RETU                               // exclusivo, retorna
 ENDI
#else
 USE (arq_prn)                       // abre arquivo de configuracoes
#endi

ar_prn=SELECT()                      // qual e' o numero da area
DO WHIL .t.
 rel_imp=""                          // variavel que contera as configuracoes
 GO TOP                              // ja existentes
 IF !EOF()
  DO WHIL !EOF()                     // le todo o arquivo
   rel_imp+="|"+ALLTRIM(marca)+;     // e vai montando a variavel
            " em "+porta             // para o menu de configuracoes
   SKIP
  ENDD
 ENDI
 volta_ac=.f.                        // flag p/ dizer que o DEL foi
 rel_imp="* NOVA *"+rel_imp          // pressionado denotr da DBOX()
 cod_sos=42
 op_imp=DBOX(rel_imp,05,63,E_MENU,NAO_APAGA,"IMPRESSORAS|(DEL=APAGA)",,,op_imp)
 IF volta_ac                         // quer apagar a configuracao?
  IF LASTREC()>1
   GO op_imp-1                        // posiciona nela e
   ALERTA()                           // pede confirmacao
   msg="Cancelar a opera‡„o|Efetivar exclus„o"
   op_=DBOX(msg,,,E_MENU,,"EXCLUINDO CONFIGURA€ŽO|¯ "+ALLTRIM(marca)+"em "+porta+" ®")
   IF op_=2                           // se confirmou exclusao elimina
    DELE                              // o registro logicamente e
    PACK                              // fisicamente do arquivo
   ENDI
  ENDI
  LOOP                               // retorna para menu de conf
 ENDI
 IF op_imp=0                         // ESC quer voltar
  EXIT
 ELSEIF op_imp=1                     // que fazer uma nova configuracao
  GO BOTT
  SKIP
 ELSE                                // escolheu um configuracao ja pronta
  GO op_imp-1                        // posiciona dentro do dbf
 ENDI
 FOR i=1 TO FCOU()                   // cria variaveis de memoria
  msg=FIEL(i)                        // com o mesmo nome das variaveis
  M->&msg.=FIELDGET(i)               // do arquivo
 NEXT
 SELE 0                              // torna as variaveis visiveis
 cod_sos=18
 v4=SAVESCREEN(0,0,MAXROW(),79)      // salva tela
 DBOX(REPL("|",18),2,11,,NAO_APAGA,PADC("CONSULTE O MANUAL DA SUA IMPRESSORA",54,CHR(0)),,,,drvcortel)
 IF !EMPTY(padrao)                   // se existe um padrao...
  SETCOLOR(drvtittel)                // imprime o seu nome
  @ 07,40 SAY SUBS(pd_prn,19*VAL(padrao)-18,18)
 ENDI
 SETCOLOR(drvcortel)                 // recebe as informacoes da configuracao

 @ 05,13 SAY "Marca da impressora.......";
         GET marca;                  // maraca da impressora
         WHEN "IMP_MARCA(marca)";
         VALI CRIT("!EMPT(marca)~MARCA Ilegal!")

 @ 06,13 SAY "Porta de sa¡da............";
         GET porta PICT "@!";        // para ativa
         WHEN "IMP_PORTA(porta,5,60)";
         VALI CRIT("!EMPT(porta)~PORTA Ilegal!")

 @ 07,13 SAY "Padr„o da impressora......";
         GET padrao PICT "@!";       // padrao da impressora
         WHEN "IMP_PADRAO(padrao)";
         VALI CRIT("padrao $ '12345678' ~PADRŽO Ilegal!")

                                     // os codigos de impressao
 @ 08,13 SAY "Linhas por p ginas........" GET tapg PICT "@S28"
 @ 09,13 SAY "   Ativa comprime 17,5 cpp" GET pcom PICT "@S28"
 @ 10,13 SAY "Desativa comprime 17,5 cpp" GET tcom PICT "@S28"
 @ 11,13 SAY "   Ativa comprime 20 cpp.." GET pc20 PICT "@S28"
 @ 12,13 SAY "Desativa comprime 20 cpp.." GET tc20 PICT "@S28"
 @ 13,13 SAY "   Ativa elite............" GET peli PICT "@S28"
 @ 14,13 SAY "Desativa elite............" GET teli PICT "@S28"
 @ 15,13 SAY "   Ativa negrito.........." GET penf PICT "@S28"
 @ 16,13 SAY "Desativa negrito.........." GET tenf PICT "@S28"
 @ 17,13 SAY "   Ativa expandido........" GET pexp PICT "@S28"
 @ 18,13 SAY "Desativa expandido........" GET texp PICT "@S28"
 @ 19,13 SAY "   Ativa 8 lin/pol........" GET pde8 PICT "@S28"
 @ 20,13 SAY "Desativa 8 lin/pol........" GET tde8 PICT "@S28"
 @ 21,13 SAY "   Ativa landscape........" GET land PICT "@S28"
 @ 22,13 SAY "Desativa landscape........" GET port PICT "@S28"
 READ
 SELE (ar_prn)                       // seleciona arq de configuracao
 IF LASTKEY()!=K_ESC                 // se nao abandonou com ESC
  IF EOF()                           // se quer incluir mais uma conf
   APPEND BLAN                       // cria um registro em branco
  ENDI
  FOR i=1 TO FCOU()                  // joga para o arquivo as
   msg=FIEL(i)                       // informacoes digitadas
   REPL &msg. WITH M->&msg.
  NEXT
 ENDI
 RESTSCREEN(0,0,MAXROW(),79,v4)      // restaura a tela anterior
ENDD
drvprn=IF(RECC()<drvprn,1,drvprn)    // ajusta configuracao atual
GO drvprn                            // inicializa novamente as
FOR i=1 TO FCOU()                    // variaveis de impressao
 msg=FIEL(i)                         // para as novas configuracoes
 drv&msg.=ALLTRIM(FIELDGET(i))
NEXT
CLOSE ALL                            // fecha o arquivo
RETU                                 // volta para o menu anterior

FUNC IMP_MARCA(m)   // escolhe a marca da impressora
LOCAL op_, msg, x:=1, mar_:=""
PRIV  cod_sos:=60
msg="Padrao IBM  |HP Laser IIP|"+;        // menu de modelos de
    "DeskJet 500 |Rima        |"+;        // impressoras
    "Epson       |Outras"
IF !EMPTY(m)                              // se esta alterando uma conf
 x=AT(UPPER(LEFT(m,12)),UPPER(msg))       // procura o default
 x=IF(x>0,CONTA("|",LEFT(msg,x))+1,6)
ENDI
op_=DBOX(msg,05,60,E_MENU,,,,,x)          // apresenta menu de impressoras
IF op_>0                                  // escolheu uma...
 IF EMPTY(m) .OR. op_!=x                  // e nao e a mesma
  mar_=PADR(SUBS(msg,1+13*(op_-1),12),15) // sujestao do nome da marca
  IF op_!=6                               // se nao for "outras" inicializa
   land=SPAC(40)                          // ativa landscape
   port=SPAC(40)                          // ativa portrait
   tapg=SPAC(40)                          // tamanho da pagina e
  ENDI
  DO CASE

   CASE op_=1                             //   * PADRAO IBM *
    padrao="1"                            // padrao
    tapg=PADR("CHR(27)+'C'+CHR(NNN)",40)  // tamanho da pagina
    pcom=PADR("CHR(15)",40)               // ativa comprimido 17,5 cpp
    tcom=PADR("CHR(18)",40)               // desativa comprimido 17,5 cpp
    pc20=PADR("CHR(30)+'5'",40)           // ativa comprimido 20 cpp
    tc20=PADR("CHR(30)+'0'",40)           // desativa comprimido 20 cpp
    peli=PADR("CHR(30)+'2'",40)           // ativa elite
    teli=PADR("CHR(30)+'0'",40)           // desativa elite
    penf=PADR("CHR(27)+'E'",40)           // ativa negrito
    tenf=PADR("CHR(27)+'F'",40)           // desativa negrito
    pexp=PADR("CHR(27)+'W'+CHR(1)",40)    // ativa expandido
    texp=PADR("CHR(27)+'W'+CHR(0)",40)    // desativa expandido
    pde8=PADR("CHR(27)+'0'",40)           // ativa 8 lin/pol
    tde8=PADR("CHR(27)+'2'",40)           // ativa 6 lin/pol

   CASE op_=2 .OR. op_=3                  //    * HP  LASER *
    padrao=IF(op_=2,"7","5")              // padrao
    pcom=PADR("CHR(27)+'(s16.67H'",40)    // ativa comprimido 17,5 cpp
    tcom=PADR("CHR(27)+'(s10H'",40)       // desativa comprimido 17,5 cpp
    pc20=PADR("CHR(27)+'(s16.67H'",40)    // ativa comprimido 20 cpp
    tc20=PADR("CHR(27)+'(s10H'",40)       // desativa comprimido 20 cpp
    peli=PADR("CHR(27)+'(s12H'",40)       // ativa elite
    teli=PADR("CHR(27)+'(s10H'",40)       // desativa elite
    penf=PADR("CHR(27)+'(s3B'",40)        // ativa negrito
    tenf=PADR("CHR(27)+'(s-3B'",40)       // desativa negrito
    pexp=PADR("CHR(27)+'(s3B'",40)        // ativa expandido
    texp=PADR("CHR(27)+'(s-3B'",40)       // desativa expandido
    pde8=PADR("CHR(27)+'(s1P'",40)        // ativa 8 lin/pol
    tde8=PADR("CHR(27)+'(s0P'",40)        // ativa 6 lin/pol
    land=PADR("CHR(27)+'&l1O'",40)        // ativa landscape
    port=PADR("CHR(27)+'&l0O'",40)        // ativa portrait

   CASE op_=4                             //    * RIMA *
    padrao="1"                            // padrao
    tapg=PADR("CHR(27)+'C'+CHR(NNN)",40)  // tamanho da pagina
    pcom=PADR("CHR(15)",40)               // ativa comprimido 17,5 cpp
    tcom=PADR("CHR(18)",40)               // desativa comprimido 17,5 cpp
    pc20=PADR("CHR(27)+'['+CHR(5)",40)    // ativa comprimido 20 cpp
    tc20=PADR("CHR(27)+'['+CHR(0)",40)    // desativa comprimido 20 cpp
    peli=PADR("CHR(27)+'['+CHR(2)",40)    // ativa elite
    teli=PADR("CHR(27)+'['+CHR(1)",40)    // desativa elite
    penf=PADR("CHR(27)+'E'",40)           // ativa negrito
    tenf=PADR("CHR(27)+'F'",40)           // desativa negrito
    pexp=PADR("CHR(27)+'W'+CHR(1)",40)    // ativa expandido
    texp=PADR("CHR(27)+'W'+CHR(0)",40)    // desativa expandido
    pde8=PADR("CHR(27)+'0'",40)           // ativa 8 lin/pol
    tde8=PADR("CHR(27)+'2'",40)           // ativa 6 lin/pol

   CASE op_=5                             //    * EPSON *
    padrao="3"                            // padrao
    tapg=PADR("CHR(27)+'C'+CHR(NNN)",40)  // tamanho da pagina
    pcom=PADR("CHR(15)",40)               // ativa comprimido 17,5 cpp
    tcom=PADR("CHR(18)",40)               // desativa comprimido 17,5 cpp
    pc20=PADR("CHR(27)+'M'+CHR(15)",40)   // ativa comprimido 20 cpp
    tc20=PADR("CHR(27)+'P'",40)           // desativa comprimido 20 cpp
    peli=PADR("CHR(27)+'M'",40)           // ativa elite
    teli=PADR("CHR(27)+'P'",40)           // desativa elite
    penf=PADR("CHR(27)+'E'",40)           // ativa negrito
    tenf=PADR("CHR(27)+'F'",40)           // desativa negrito
    pexp=PADR("CHR(27)+'W'+CHR(1)",40)    // ativa expandido
    texp=PADR("CHR(27)+'W'+CHR(0)",40)    // desativa expandido
    pde8=PADR("CHR(27)+'0'",40)           // ativa 8 lin/pol
    tde8=PADR("CHR(27)+'2'",40)           // ativa 6 lin/pol

  ENDC
  x=SETCOLOR(drvtittel)                   // reimprime codigos na tela
  @ 07,40 SAY SUBS(pd_prn,19*VAL(padrao)-18,18)
  @ 08,40 SAY tapg PICT "@S28"
  @ 09,40 SAY pcom PICT "@S28"
  @ 10,40 SAY tcom PICT "@S28"
  @ 11,40 SAY pc20 PICT "@S28"
  @ 12,40 SAY tc20 PICT "@S28"
  @ 13,40 SAY peli PICT "@S28"
  @ 14,40 SAY teli PICT "@S28"
  @ 15,40 SAY penf PICT "@S28"
  @ 16,40 SAY tenf PICT "@S28"
  @ 17,40 SAY pexp PICT "@S28"
  @ 18,40 SAY texp PICT "@S28"
  @ 19,40 SAY pde8 PICT "@S28"
  @ 20,40 SAY tde8 PICT "@S28"
  @ 21,40 SAY land PICT "@S28"
  @ 22,40 SAY port PICT "@S28"
  SETCOLOR(x)
 ENDI
ENDI
RETU mar_                                 // retorna sempre verdade

FUNC IMP_PADRAO(p)   // escolhe o padrao
LOCAL op_:=1, msg
PRIV  cod_sos:=61
IF !EMPTY(p)                              // se esta alterando uma conf
 op_=VAL(p)                               // procura o default
ENDI
op_=DBOX(pd_prn,05,60,E_MENU,,,,,op_)     // apresenta menu de padroes
IF op_>0                                  // escolheu um...
 x=SETCOLOR(drvtittel)                    // reimprime nome do padrao
 @ 07,40 SAY SUBS(pd_prn,19*op_-18,18)
 SETCOLOR(x)
 op_=LTRIM(STR(op_))
ELSE
 op_=""
ENDI
RETU op_                                  // retorna sempre verdade

FUNC IMP_PORTA(p,l_,c_,ap_ja_,msgT)    // menu de portas ativas
LOCAL msg:="", t, op_, tp_sai_:=""
PRIV  cod_sos:=37
FOR t=1 TO 3                                // verifica quais as portas
 IF PARALELA(t)                             // paralelas estao ativa
  msg+="|Lpt"+STR(t,1)                      // para montar a varivel que
 ENDI                                       // contera o menu de portas
NEXT                                        // ativas
FOR t=1 TO 4
 IF SERIAL(t)                               // idem para os portas
  msg+="|Com"+STR(t,1)                      // seriais...
 ENDI
NEXT
IF !EMPTY(msg)                              // existe pelo menos um porta?
 op_=AT(UPPER(p),UPPER(msg))
 msg=SUBS(msg,2)
 op_=IF(op_>0,CONTA("|",LEFT(msg,op_))+1,1) // acha o defautl do menu
 op_=DBOX(msg,l_,c_,E_MENU,ap_ja_,msgT,,,op_)// apresenta menu
 IF op_>0                                   // escolheu uma...
  tp_sai_=UPPER(SUBS(msg,1+5*(op_-1),4))    // forca conteudo da porta
 ENDI
ENDI
RETU tp_sai_                                // retorna sempre verdade

FUNC POE_GAUGE(msg_,tit_,tit_reg)  // coloca gauge na tela
STATIC l_g, c_g, ct_g:=0, so_conta // linha e coluna do inicio gauge
LOCAL x, defa_dev, i
IF msg_!=NIL                      // mensagem da dbox
 so_conta=(tit_reg!=NIL)          // vai contar ou colocar %
 ct_g=0                           // contador de registro ja processados
 IF so_conta                      // se vai contar concatena msg que
  msg_+="|*|"+tit_reg+"       0"  // vamos mostrar qtde de reg processados
 ELSE                             // processo em todo o arq
  msg_+="|*|"+REPL("°",20)        // concatena gauge no final
 ENDI
 x=DBOX(msg_,,,,NAO_APAGA,tit_)   // coloca msg na tela
 SETCOLOR(drvtitbox)              // cor do titulo para gauge
 l_g = VAL(PARSE(@x,"|"))         // linha e
 c_g = VAL(x)                     // coluna de inicio do gauge
 IF so_conta                      // vai contar registro
  c_g+=LEN(tit_reg)+1             // posiciona cursor apos msg de proc
 ENDI
ELSE                              // coloca o gauge
 ct_g++                           // conta quantos ja foi feito
 IF so_conta                      // gauge em contador
  IF INT(ct_g/30)=ct_g/30         // mostra em 30 em 30
   x=RIGHT(SPACE(8)+STR(ct_g),8)  // coloca qtde na tela sem
   FOR i=1 TO 8                   // usar o SAY (pode estar imprimindo)
    POKE(-18432,(l_g*160)+((c_g+i)*2),ASC(SUBS(x,i+1,1)))
   NEXT
  ENDI
 ELSE                             // gauge com percentual
  @ l_g,c_g SAY REPL("Û",MIN(ct_g,20)) // coloca na msg
 END IF
ENDI
RETURN .t.                        // sempre retorna verdadeiro
/*
   Sintaxe: POINTER_DBF( [ExpA] [,ExpL] )
   Funcao.: acha/restaura ponteiro dos dbf do vetor sistema
               ExpA = arranjo de RECNO() dos dbf do vetor sistema
               ExpL = se .t. deixa abertos os dbf's usados apos salvamento
   Retorna: arranjo de RECNO() dos dbf do vetor sistema
*/
FUNC POINTER_DBF(reg_dbf, deixa_ab)
LOCAL t, i_, ar_, i_reg, i_ord, i_tmp, db_, db_s, repoe:=(reg_dbf!=NIL), rel_dbf:={}, seq_dbf, cp_, db_r
PRIV cpord:="", criterio:="", chv_rela:="", chv_1:=""
deixa_ab=IF(deixa_ab=NIL,.f.,deixa_ab)
IF !repoe                        // ira retornar os RECNO() de cada dbf
 reg_dbf:={}                     // inicializa vetor de retorno
 ar_=ALIAS()                     // salva area atual
ENDI
FOR t=1 TO nss                   // para cada sistema do vetor sistema...
 db_=sistema[t,O_ARQUI,O_NOME]   // nome do dbf
 db_s=LEFT(db_,3)+"_SEQ"       // nome do dbf de sequencia
 IF repoe                        // vai repor os ponteiros dos dbf's
  IF reg_dbf[t,1]>=0             // se o arquivo estava aberto
   IF !EMPTY(SELECT(db_))         // se o dbf esta aberto
    IF LEN(reg_dbf[t,3])=0 .AND. LEN((db_)->(INDEXKEY(LEN(sistema[t,O_INDIC])+1)))>0
     CLOSE (db_)                  // e ind tmp nao for o mesmo
    ENDI                          // fecha arq para abrir ind novamente
   ENDI

   #ifdef COM_REDE
    USEARQ(db_,.f.)              // selecina ou abre o arquivo
   #else
    USEARQ(db_)                  // selecina ou abre o arquivo
   #endi

   IF LEN(reg_dbf[t,3])>0        // tinha indice temporario
    IF INDEXKEY(LEN(sistema[t,O_INDIC])+1)<>reg_dbf[t,3]
     cpord=reg_dbf[t,3]          // se nao for o mesmo
     INDTMP()                    // indexa novamente
    ENDI
   ENDI
   DBSETORDER(reg_dbf[t,2])      // restaura o indice e o
   GO reg_dbf[t,1]               // seu ponteiro
   SET RELA TO                   // retira todas as relacoes existentes
   IF reg_dbf[t,5]>=0            // se tem sequencial
    USEARQ(db_s,.f.,,,.f.)       // abre arquivo de cps sequencial
    GO reg_dbf[t,5]              // e reposiciona seu ponteiro
   ENDI
  ELSE                           // se o arquivo estava fechado
   IF !EMPTY(SELECT(db_)) .AND.; // e agora esta aberto
      !deixa_ab                  // e quer fechar,
    CLOSE (db_)                  // entao vamos fecha-lo
   ENDI
  ENDI
 ELSE                            // acha situacao dos dbf's
  IF !EMPTY(SELECT(db_))         // se o dbf esta aberto
   i_reg=(db_)->(RECNO())        // pega o seu ponteiro
   i_ord=(db_)->(INDEXORD())  // e o seu indice atual
   i_tmp=(db_)->(INDEXKEY(LEN(sistema[t,O_INDIC])+1)) // indice temporario
   rel_dbf:={}                   // relacoes do arquivo
   i_=1                          // pega todas que existir
   DO WHILE LEN((db_)->(DBRELATION(i_)))>0
    AADD(rel_dbf,{(db_)->(DBRELATION(i_)),ALIAS((db_)->(DBRSELECT(i_)))}) // adiciona ponteiro ao vetor de retorno
    i_++
   ENDD
   IF !EMPTY(SELECT(db_s))       // se o dbf de sequencial esta aberto
    seq_dbf=(db_s)->(RECNO())    // pega o seu ponteiro
   ELSE
    seq_dbf=-1                   // nao tem cp sequencial
   ENDI
  ELSE                           // caso contrario vamos
   i_tmp=""
   i_reg:=i_ord:=seq_dbf := -1   // nao tem relacao zera o vetor
   rel_dbf:={}
  ENDI
  AADD(reg_dbf,{i_reg,i_ord,i_tmp,rel_dbf,seq_dbf}) // adiciona ponteiro ao vetor de retorno
 ENDI
NEXT
IF !repoe                        // se esta enchendo o vetor, adiciona
 AADD(reg_dbf,ar_)               // a area atual no ultimo elemento
ELSE                             // se esta restabelecendo,
 FOR t=1 TO nss                  // vamos recolocar as relacoes...
  db_=sistema[t,O_ARQUI,O_NOME]  // nome do dbf
  IF LEN(reg_dbf[t,4])>0         // tem relacoes?
   SELE (db_)                    // vai para area do dbf
   FOR i_=1 TO LEN(reg_dbf[t,4]) // e corre todos as relacoes anteriores
    cp_=reg_dbf[t,4,i_,1]        // expresao de ligacao
    db_r=reg_dbf[t,4,i_,2]       // dbf de ligacao
    SET RELA ADDI TO &cp_. INTO &db_r. // recoloca a relacao
   NEXT
  ENDI
 NEXT
 IF LEN(reg_dbf[nss+1])>0        // se tinha dbf aberto na area atual
  SELE (reg_dbf[nss+1])          // vamos abri-lo
 ELSE
  SELE 0                         // abre primeira area livre
 ENDI
ENDI
RETU reg_dbf                     // retorna vetor

/*
   Sintaxe: VDBF( <N1> <,N2> <,N3> <,N4> <,ExpC1> [,ExpA1] [,ExpN] [,ExpC2] [,ExpC3])
   Funcao.: Abre janela de consulta a outro arquivo da aplicacao
              N1,N2,N3,N4 = coordenadas da janela
                    ExpC1 = nome do arquivo a ser consultado
                    ExpA1 = arranjo de campos a mostrar na consulta
                     ExpN = ordem do indice associado ao arquivo
                    ExpC2 = campo a ser transferido para o get pendente
                    ExpC3 = expressao de filtro inicial
   Retorna: logico sempre .t.
*/
FUNC VDBF(l_1,c_1,l_2,c_2,db,cp_db,ord_db,cp_trans,fil_db)
LOCAL v_ar, v_:=SAVESCREEN(0,0,MAXROW(),79), t_w, t_r, t_c, t_7, t_9,;
      reg_dbf:={}, ret_val, del_a
PRIV tela_fundo, cod_sos:=10
v_ar=READVAR()
ord_db=IF(ord_db=NIL,1,ord_db)
reg_dbf=POINTER_DBF()                     // salva situacao de todos dbf's
del_a:=SET(_SET_DELETED,!drvvisivel)      // coloca visibilidade escolhida
tem_t=.f.
IF !EMPTY(v_ar)                           // alguma variavel pendente?
 IF VALTYPE(&v_ar.) $ "CNDL" .AND.;       // se for caracter, numerica, data
    !EMPTY(&v_ar.)                        // ou logico e tiver conteudo
  tem_t=!("OP_" $ UPPER(v_ar))            // e nao for de menu, pode
  v_ar=TRIM(TRANSCAMPO(.t.,v_ar))         // transferir para o get pendente
 ENDI
ENDI
PTAB(IF(tem_t,v_ar,"%^"),db,1)            // abre arquivo e tenta posicionar

#ifdef COM_REDE
 IF NETERR()                              // se ocorreu erro de abertura
  RETU .t.                                // retorna
 ENDI
#endi

SELE (db)                                 // seleciona o arquivo escolhido
IF EOF()                                  // se fim de arquivo,
 DBSETORDER(ord_db)                       // vai para o indice desejado
 GO TOP                                   // vai para o 1o. registro
ELSE
 DBSETORDER(ord_db)                       // vai para o indice desejado
ENDI
t_w:=SETKEY(K_CTRL_W,NIL)                 // desabilita e salva
t_r:=SETKEY(K_CTRL_R,NIL)                 // as teclas de controle
t_c:=SETKEY(K_CTRL_C,NIL)
t_7:=SETKEY(K_F7,NIL); t_9:=SETKEY(K_F9,NIL)
IF sistema[EVAL(qualsis,ALIAS()),O_OUTROS,O_NIVEL]>nivelop
 ALERTA()                                 // usuario nao tem permissao
 DBOX(msg_auto,,,3)                       // avisa
ELSE
 l_2=IF(l_2-l_1-1>RECC(),l_1+RECC()+1,l_2)
 v_out=.t.
 EDITA(l_1,c_1,l_2,c_2,.t.,cp_db,,fil_db)
 IF LASTKEY()!=K_ESC .AND. cp_trans!=NIL
  ret_val=&cp_trans.
 ENDI
 v_out=.f.
ENDI
SET(_SET_DELETED,del_a)                   // retorna a visibilidade dos excluidos
POINTER_DBF(reg_dbf)                      // restaura ponteiro dos dbf's
SETKEY(K_CTRL_W,t_w)                      // restaura teclas de controle
SETKEY(K_CTRL_R,t_r)
SETKEY(K_CTRL_C,t_c)
SETKEY(K_F7,t_7); SETKEY(K_F9,t_9)
RESTSCREEN(0,0,MAXROW(),79,v_)            // restaura tela
RETU ret_val


#ifdef COM_MOUSE

 /*
    Sintaxe: MOUSETECLA( [N1] [,N2] [,N3] [,N4] [,ExpL] )
    Funcao.: Aguarda digita‡„o de tecla com controle de mouse
               N1,N2,N3,N4 = janela de avaliacao
                      ExpL = .f. somente as bordas da janela serao verificadas
    Retorna: codigo ASCII da tecla digitada
 */
 FUNC MOUSETECLA(l1,c1,l2,c2,cx_toda)
 LOCAL tecl_p, i, li:=1, co:=1, clic:=0, Tp_Sai, lin_cur, col_cur,;
       cur_, e_calc:=(PROCNAME(3)="MAQCALC")
 IF drvmouse                            // mouse esta' ligado?
  lin_cur=ROW()                         // salva linha e
  col_cur=COL()                         // coluna atual do mouse
  cur_=SETCURSOR()                      // setuacao atual do cursor
  IF e_calc                             // mouse na calculadora
   l1=lisu_+5                           // ajusta area de atuacao do mouse
   c1=cosu_+2
   l2=lisu_+8
   c2=cosu_+22
  ELSE
   l1=IF(l1=NIL,0,l1)                   // acha a area de atuacao do mouse
   c1=IF(c1=NIL,0,c1)
   l2=IF(l2=NIL,MAXROW(),l2)
   c2=IF(c2=NIL,79,c2)
  ENDI
  cx_toda=IF(cx_toda=NIL,.t.,cx_toda)   // avalia toda a area de atuacao do mouse?
  MOUSEBOX(l1,c1,l2,c2)                 // define area do mouse
  Tecl_p=0
  MOUSECUR(.t.)                         // liga cursor do mouse

  #ifdef COM_REDE
   Tp_Sai=SECONDS()+drvtempo            // tempo de "refresh"
  #endi

  DO WHIL Tecl_p=0

   #ifdef COM_REDE
    IF drvtempo>0.AND.SECONDS()>Tp_Sai  // see' tempo do "refresh"
     EXIT                               // cai fora...
    ENDI
   #endi

   DO WHILE (clic:=MOUSEGET(@li,@co))>0 // espera um clique do mouse
    IF SECONDS()>tpo_mouse              // botao do mouse retido por mais de 1 seg,
     EXIT                               // significa mouse sendo arrastado com
    ENDI                                // o botao apertado
   ENDD
   tecl_p=NEXT_KEY()                    // le tecla do buffer do teclado
   IF tecl_p=0                          // esta vazio
    IF clic=ESQUERDO                    // botao esquerdo pressionado
     tecl_p=CLICK
     IF li=l1 .OR. li=l2 .OR. cx_toda   // avalia onde foi o clique
      IF CLICK_EM(gcr,li,co)
       tecl_p=K_ENTER
      ELSEIF CLICK_EM("F10",li,co)
       tecl_p=K_F10
      ELSEIF CLICK_EM("F9",li,co)
       tecl_p=K_F9
      ELSEIF CLICK_EM("F8",li,co)
       tecl_p=K_F8
      ELSEIF CLICK_EM("F4",li,co)
       tecl_p=K_F4
      ELSEIF CLICK_EM("F3",li,co)
       tecl_p=K_F3
      ELSEIF CLICK_EM("TAB",li,co)
       tecl_p=K_TAB
      ELSEIF CLICK_EM(CHR(27),li,co)
       tecl_p=K_LEFT
      ELSEIF CLICK_EM(CHR(26),li,co)
       tecl_p=K_RIGHT
      ELSEIF CLICK_EM(CHR(24),li,co)
       tecl_p=K_UP
      ELSEIF CLICK_EM(CHR(25),li,co)
       tecl_p=K_DOWN
      ELSEIF CLICK_EM("PgUp",li,co) .OR. CLICK_EM(CHR(30),li,co)
       tecl_p=K_PGUP
      ELSEIF CLICK_EM("PgDn",li,co) .OR. CLICK_EM(CHR(31),li,co)
       tecl_p=K_PGDN
      ELSEIF CLICK_EM("Topo",li,co) .OR. CLICK_EM(CHR(174),li,co)
       tecl_p=K_CTRL_PGUP
      ELSEIF CLICK_EM("Fim",li,co)  .OR. CLICK_EM(CHR(175),li,co)
       tecl_p=K_CTRL_PGDN
      ELSEIF CLICK_EM(CHR(18),li,co)
       tecl_p=74
      ELSEIF e_calc                     // clique da calculadora sobre
       msg="1234567890.+-*/%^#$C=R"     // um numero ou sinal
       FOR i=1 TO LEN(msg)
        IF CLICK_EM(SUBS(msg,i,1),li,co)
         tecl_p=ASC(SUBS(msg,i,1))
         EXIT
        ENDI
       NEXT
      ENDI
     ENDI
    ELSEIF clic=DIREITO                 // botao da direita
     tecl_p=K_ESC                       // abandona com ESC
    ELSE
     tpo_mouse=-1                       // reseta o tempo do mouse
    ENDI
    IF tecl_p>2                         // tecla de funcao clicada
     KEYB CHR(tecl_p)                   // forca tecla no buffer do teclado
     IN_KEY(0)
    ENDI
   ELSE
    IN_KEY(0)                           // recebe tecla digitada
   ENDI
  ENDD
  MOUSECUR(.f.)                         // deliga cursor do mouse
  tpo_mouse=IF(tpo_mouse=-1,SECONDS()+1,tpo_mouse)
  IF cur_!=0
   SETPOS(lin_cur,col_cur)              // retorna o cursor a posicao original
  ENDI
 ELSE                                   // mouse esta' desligado...

  #ifdef COM_REDE
   tecl_p=IN_KEY(drvtempo)              // faz "refresh" a cada drvtempo seg
  #else
   tecl_p=IN_KEY(0)                     // aguarda usuario teclar algo
  #endi

 ENDI
 RETU tecl_p                            // retorna tecla desejada

 /*
    Sintaxe: CLICK_EM( <ExpC> <,ExpN1> <,ExpN2> )
    Funcao.: Verifica se ExpC esta sobre as coordenadas ExpN1 e ExpN2
    Retorna: .t. se teve sucesso
 */
 STATIC FUNC CLICK_EM(te_cl,li,co)
 LOCAL t_s:="", t1, t2, t_
 t1=LEN(te_cl)                          // salva trecho de tela nas
 t_ := SAVESCREEN(li,co-t1,li,co+t1)    // coordenadas do clique
 t1=LEN(t_)
 FOR t2=1 TO t1 STEP 2                  // separa os atributos das letras
  t_s+=SUBST(t_,t2,1)                   // do trecho salvo
 NEXT
 t1=AT(te_cl,t_s)                       // tecla esta sob o cursor?
 IF t1>0                                // verifica se a tecla nao e'
  t2=ASC(SUBS(t_s,t1-1,1))              // um pedaco de palavvra
  t1=ASC(SUBS(t_s,t1+LEN(te_cl),1))
  IF (t1<65 .OR. t1>125) .AND. (t2<65 .OR. t2>125)
   RETU .t.                             // ok. a tecla foi clicada
  ENDI
 ENDI
 RETU .f.                               // a tecla nao foi clicada

#endi


PROC PWU_incl(reg_cop)  // inclusao no arquivo PWUSUA
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),dbfseq_,;
      ctl_r, ctl_c, t_f3_, t_f4_, l_max
PRIV op_menu:=INCLUSAO, sq_atual_, op_sis, l_s, c_s, l_i, c_i, cod_sos, chv_rela, chv_1, chv_2, tem_borda, criterio:="", cpord:="", l_a
op_sis=EVAL(qualsis,"PWUSUA")
chv_rela=""
FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
 chv_rela+="+"+TRANSCAMPO(.f.,sistema[op_sis,O_CPRELA,i],i)
NEXT
chv_rela=IF(LEN(chv_rela)>2,SUBS(chv_rela,2),"")
PEGACHV2()
FOR i=1 TO FCOU()                         // cria/declara privadas as
 msg=FIEL(i)                              // variaveis de memoria com
 PRIV &msg.                               // o mesmo nome dos campos
NEXT                                      // do arquivo
IF reg_cop!=NIL                           // quer repetir todo o reg atual
 FOR i=1 TO FCOU()                        // para cada campo,
  msg=FIEL(i)                             // salva o conteudo
  rep[i]=&msg.                            // para repetir
 NEXT
ELSE
 AFILL(rep,"")                            // eche com valor vazio
ENDI
t_f3_=SETKEY(K_F3,{||rep()})              // repeticao reg anterior
t_f4_=SETKEY(K_F4,{||conf()})             // confirma campos com ENTER
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})      // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})
DISPBEGIN()                               // monta tela na pagina de traz
IMPRELA()                                 // imp telas do pai
PWU_TELA()                                // imp tela para inclusao
INFOSIS(.t.)                              // exibe informacao no rodape' da tela
l_a=Sistema[op_sis,O_TELA,O_SCROLL]
DISPEND()                                 // apresenta tela de uma vez so
DO WHIL cabem>0
 rola_t=.f.                               // flag se quer rolar a tela
 SELE PWUSUA
 M->pw_codigo="0001"                      // procura proximo numero do usuario
 GO TOP
 DO WHILE !EOF()                          // corre todo dbf e ve qual o valor do maior cod do usuario
  IF VAL(DECRIPT(pw_codigo))>=VAL(M->pw_codigo)
   M->pw_codigo=LPAD(STR(VAL(DECRIPT(pw_codigo))+1),4,[0])
  ENDI
  SKIP
 ENDD
 
 /*
    cria variaveis de memoria identicas as de arquivo, para inclusao
    de registros
 */
 FOR i=3 TO FCOU()
  msg=FIEL(i)
  M->&msg.=IF((fgrep .OR. reg_cop!=NIL).AND.!EMPT(rep[1]),DECRIPT(rep[i]),&msg.)
 NEXT
 
 /*
    inicializa campos de relacionamentos do com os campos do arquivo
    superior (grupo)
 */
 FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
  msg=FIEL(VAL(SUBS(sistema[op_sis,O_ORDEM,1],i*2-1,2)))
  M->&msg.=DECRIPT(&(sistema[op_sis,O_CPRELA,i]))
 NEXT
 cabem=DISKSPACE(;                        // pode incluir mais...
          IF(;
             LEN(sistema[op_sis,O_ARQUI,O_DIR_DBF])<2.OR.sistema[op_sis,O_ARQUI,O_DIR_DBF]="\",;
             0,;
             ASC(sistema[op_sis,O_ARQUI,O_DIR_DBF])-64;
          );
       )
 cabem=INT((cabem-2048)/PWUSUA->(RECSIZE()))
 IF cabem<1                               // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")  // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                   // torna visiveis variaveis de memoria
 PWU_GET1(INCLUI)                         // recebe campos
 SELE PWUSUA
 IF LASTKEY()=K_ESC                       // se cancelou
  cabem=0                                 // prepara saida da inclusao
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                 // vamos bloquear o final do
  SKIP                                    // arq para que nehum outro
  BLOREG(0,.5)                            // usuario possa incluir
 #endi

 M->pw_grupo=ENCRIPT(M->pw_grupo)

 APPEND BLANK                             // inclui reg em branco no dbf
 FOR i=1 TO FCOU()                        // para cada campo,
  msg=FIEL(i)                             // salva o conteudo
  rep[i]=M->&msg.                         // para repetir
  REPL &msg. WITH rep[i]                  // enche o campo do arquivo
 NEXT

 #ifdef COM_REDE
  UNLOCK                                  // libera o registro e
  COMMIT                                  // forca gravacao
 #else
  IF RECC()-INT(RECC()/20)*20=0           // a cada 20 registros
   COMMIT                                 // digitados forca gravacao
  ENDI
 #endi

 TROCASENHA(.t.,DECRIPT(pw_nome))         // digita a senha

 ult_reg=RECN()                           // ultimo registro digitado
 l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
 IF l_s+l_a+1<l_max                       // se nao atingiu o fim da tela
  l_a++                                   // digita na proxima linha
 ELSE                                     // se nao rola a campos para cima
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+02,l_max-1,c_s+05,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+11,l_max-1,c_s+25,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+29,l_max-1,c_s+29,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+37,l_max-1,c_s+51,1)
 ENDI
 IF reg_cop!=NIL                          // estava na consulta e quis rep o campo
  EXIT                                    // cai fora...
 ENDI
ENDD
GO ult_reg                                // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                        // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC PWU_tela     // tela do arquivo PWUSUA
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
@ l_s+01,c_s+1 SAY " C¢digo ³ Nome            ³ Nivel ³ Obs"
@ l_s+02,c_s+1 SAY "ÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY "        ³                 ³       ³"
@ l_s+04,c_s+1 SAY "        ³                 ³       ³"
@ l_s+05,c_s+1 SAY "        ³                 ³       ³"
@ l_s+06,c_s+1 SAY "        ³                 ³       ³"
@ l_s+07,c_s+1 SAY "        ³                 ³       ³"
@ l_s+08,c_s+1 SAY "        ³                 ³       ³"
@ l_s+09,c_s+1 SAY "        ³                 ³       ³"
RETU

PROC PWU_gets     // mostra variaveis do arquivo PWUSUA
LOCAL getlist := {}, l_max, reg_atual:=RECNO()
PRIV  l_a:=Sistema[op_sis,O_TELA,O_SCROLL], _codigo, _nome, _nivel, _obs
PWU_TELA()
l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
DO WHILE !EOF() .AND. l_s+l_a<l_max .AND.;
   &(INDEXKEY(0))=IF(EMPT(criterio),"","T")+chv_1
 _codigo=DECRIPT(pw_codigo)               // desencripta campos
 _nome=DECRIPT(pw_nome)                   // antes de mostrar
 _nivel=DECRIPT(pw_nivel)
 _obs=DECRIPT(pw_obs)
 @ l_s+l_a,c_s+02 GET  _codigo;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]

 @ l_s+l_a,c_s+11 GET  _nome;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]

 @ l_s+l_a,c_s+29 GET  _nivel;
                  PICT sistema[op_sis,O_CAMPO,04,O_MASC]

 @ l_s+l_a,c_s+37 GET  _obs

 SETCOLOR(drvcortel+","+drvcortel+",,,"+drvcortel)
 l_a++
 SKIP
ENDD
GO reg_atual
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CLEAR GETS
RETU

PROC PWU_get1(tp_mov, excl_rela)     // capta variaveis do arquivo PWUSUA
LOCAL getlist := {}
PRIV _codigo, _nome, _nivel, _obs
excl_rela=IF(excl_rela=NIL,.f.,excl_rela) // exclusao do pai?
IF tp_mov=INCLUI
 IF TYPE("l_a")!="N"                      // linha atual do scroll
  l_a=Sistema[op_sis,O_TELA,O_SCROLL]
 ENDI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  IF op_menu=ALTERACAO                    // na alteracao
   _codigo=DECRIPT(pw_codigo)             // desencripta
   _nome=DECRIPT(pw_nome)                 // campos do arquivo
   _nivel=DECRIPT(pw_nivel)
   _obs=DECRIPT(pw_obs)
  ELSE                                    // na inclusao
   _codigo=M->pw_codigo                   // pega da memoria
   _nome=M->pw_nome                       // os campos ja desencriptados
   _nivel=M->pw_nivel
   _obs=M->pw_obs
  ENDI
  @ l_s+l_a,c_s+02 GET _codigo;           // mostra codigo do usuario
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
  CLEA GETS
  @ l_s+l_a,c_s+11 GET  _nome;            // recebe os outros campos
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3

  @ l_s+l_a,c_s+29 GET  _nivel;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+l_a,c_s+37 GET  _obs
                   DEFINICAO 5

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
  IF op_menu=ALTERACAO                    // na alteracao
   REPL pw_codigo WITH ENCRIPT(_codigo),; // encripta e grava
        pw_nome WITH ENCRIPT(_nome),;     // os campos no dbf
        pw_nivel WITH ENCRIPT(_nivel),;
        pw_obs WITH ENCRIPT(_obs)
  ELSE                                    // na inclusao
   M->pw_codigo=DECRIPT(_codigo)          // encripta variaveis
   M->pw_nome=DECRIPT(_nome)              // na memoria
   M->pw_nivel=DECRIPT(_nivel)
   M->pw_obs=DECRIPT(_obs)
  ENDI
  EXIT
 ENDD
ENDI
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA

 #ifdef COM_REDE
  IF !excl_rela                         // esta excluindo o pai
   REPL flag_excl WITH '*'              // coloca uma marca
  ENDI
 #else
  IF !excl_rela                         // esta excluindo o pai
   REPL flag_excl WITH '*'              // coloca uma marca
  ENDI
 #endi

 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (PWGRUPOS->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"PWGRUPOS"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
  ELSE
   IF !excl_rela                       // esta recuperando o pai
    IF op_menu=INCLUSAO                // desfaz a flag
     flag_excl=' '
    ELSE
     REPL flag_excl WITH ' '
    ENDI
   ENDI
   IF op_menu!=INCLUSAO                // se nao esta incluindo
    RECA                               // recura o registro
   ENDI
  ENDI
 ENDI
ENDI
RETU

PROC TROCASENHA(_gerente,_usu)  // pega senha para cadastro
LOCAL rg_:=RECNO(), od_
PRIV cod_sos:=16,l_s,c_s,l_i,c_i, op_sis:=nss
SAVE SCREEN

#ifdef COM_REDE
 IF !USEARQ(sistema[nss,O_ARQUI,O_NOME])           // abre arq de usuarios
  RETU                                             // arquivo volta ao menu anterior
 ENDI
#else
 USEARQ(sistema[nss,O_ARQUI,O_NOME])               // abre arq de usuarios
#endi

DBSETORDER(2)                              // coloca no indice certo
SETCOLOR(drvtittel)                        // cor da tela
tem_borda=.t.
l_s=11; c_s=19; l_i=17; c_i=51             // coordenadas da tela
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)      // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)                // monta caixa da tela
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "     USURIO "+_usu    // com msg na tela
@ l_s+03,c_s+1 SAY IF(_gerente,"       Senha:"," Senha atual:")
@ l_s+04,c_s+1 SAY IF(_gerente," Confirma‡„o:"," Senha  nova:")
@ l_s+05,c_s+1 SAY "              (ESC recome‡ar)"
DO WHILE .t.
 SETCOLOR(drvcorbox)                       // cor da janela
 @ l_s+4,c_s+15 SAY SPAC(6)                // limpa na tela
 SETCOLOR(drvcorget)                       // coloca fundo
 @ l_s+3,c_s+15 SAY SPAC(6)                // da cor do get
 senha=PADR(PWORD(l_s+3,c_s+15),6)         // recebe a senha
 SETCOLOR(drvcorbox)                       // cor da janela
 @ l_s+3,c_s+15 SAY PADR(REPL("þ",LEN(RTRIM(DECRIPT(senha)))),6) // coloca senha na tela se fundo
 IF senha!=senhatu .AND. !EMPT(senha) .AND. _gerente=.f.  // epa! e' um ET!
  ALERTA()                                 // beep, beep, beep
  DBOX(_usu+",|Sua senha n„o confere!",14,40,3,,"ATEN€ŽO!")
  EXIT
 ELSEIF !EMPT(senha)                       // senao, pode alterar
  SETCOLOR(drvcorget)                      // coloca fundo
  @ l_s+4,c_s+15 SAY SPAC(6)               // da cor do get
  senhatu=PADR(PWORD(l_s+04,c_s+15),6)     // recebe nova senha
  SETCOLOR(drvcorbox)                      // coloca cor da janela
  IF senha!=senhatu                        // senha diferente da atual
   IF _gerente=.f.                         // nao e' o gernte
    SEEK ENCRIPT(PADR(_usu,15))+senhatu    // verifica se um outro usuario
    IF FOUND()                             // esta' usando esta senha
     ALERTA()
     msg="Senha inv lida"                  // boing... vamos dar qualquer
     DBOX(msg,l_s+04,c_s+19,3,,"ATEN€ŽO!") // aviso, a menos que esta senha
     @ l_s+03,c_s+15 SAY SPAC(6)           // pertenca a outro usuario
     @ l_s+04,c_s+15 SAY SPAC(6)
    ELSE                                   // senha ok.
     SEEK ENCRIPT(PADR(_usu,15))+senha     // posiciona sobre o registro

     #ifdef COM_REDE
      REPBLO("pw_pass",senhatu)             // bloqueia e muda a senha
     #else
      REPL pw_pass WITH senhatu             // e muda a senha
     #endi

     EXIT
    ENDI
   ELSE                                    // e' o gerente
    msg="Senha n„o confere!"               // entao avisa que
    DBOX(msg,l_s+04,c_s+19,3,,"ATEN€ŽO!")  // a senha nao confere
    @ l_s+03,c_s+15 SAY SPAC(6)
    @ l_s+04,c_s+15 SAY SPAC(6)
   ENDI
  ELSE                                     // senhas nao foi alterada
   IF _gerente                             // e' o gerente
    SEEK ENCRIPT(PADR(_usu,15))+senha      // verifica se um outro usuario
    IF FOUND()                             // esta' usando esta senha
     ALERTA()
     msg="Senha inv lida"                  // boing... vamos dar qualquer
     DBOX(msg,l_s+04,c_s+19,3,,"ATEN€ŽO!") // aviso, a menos que esta senha
     @ l_s+03,c_s+15 SAY SPAC(6)           // pertenca a outro usuario
     @ l_s+04,c_s+15 SAY SPAC(6)
     LOOP
    ELSE                                   // senha ok.
     GO rg_

     #ifdef COM_REDE
      REPBLO("pw_pass",senha)              // bloqueia e muda a senha
     #else
      REPL pw_pass WITH senha              // e muda a senha
     #endi

    ENDI
   ENDI
   EXIT                                    // cai fora
  ENDI
 ENDI
ENDD
DBSETORDER(1)                              // retorna a ordem original
GO rg_
REST SCREEN
RETU

/*
   Sintaxe: CRIADBF()
   Funcao.: Verifica e cria os arquivos DBF e NTX, quando nao existirem.
   Retorna: .t. se teve sucesso
*/
FUNC CRIADBF
LOCAL tel_a:=SAVESCREEN(0,0,MAXROW(),79), cur_atual:=SETCURSOR(0)  // salva a tela/cursor
FOR i=1 TO nss                              // para cada subsistema,
 dbf=sistema[i,O_ARQUI,O_DIR_DBF]+sistema[i,O_ARQUI,O_NOME]; harq=.f. // obtem nome do DBF
 IF !FILE(dbf+".dbf")                       // existe?
  IF i=1
   cod_sos=1
   ALERTA(3)                                // beep, beep, beep
   msg="Criar os arquivos|"+;               // confirma a criacao
       "Abandonar a opera‡„o"
   op_=DBOX(msg,,,E_MENU,,"ARQUIVOS NŽO ENCONTRADOS")
   IF op_!=1
    RETU (.f.)                              // retorna .f. pois abandonou
   ENDI
  ENDI
  harq=.t.                                  // monta o nome do modulo
  stru=LEFT(sistema[i,O_ARQUI,O_NOME],3)+"_estr" // que cria a estrutura
  DBOX(dbf+".DBF",,,,NAO_APAGA,"CRIANDO")   // avisa...
  &stru.()                                  // e cria a estrutura
  RESTSCREEN(0,0,MAXROW(),79,tel_a)         // restaura a tela
 ENDI
 FOR t=1 TO LEN(sistema[i,O_INDIC])         // para cada indice do subsistema
  ntx=sistema[i,O_ARQUI,O_DIR_NTX]+sistema[i,O_INDIC,t] // obtem nome do indice
  IF !FILE(ntx+EXTENSAO()).OR.harq          // se nao existir ou criou estrutura
   POE_GAUGE(ntx+EXTENSAO(),"CRIANDO")      // vamos criar...

   #ifdef COM_REDE
    IF !USEARQ(dbf,.t.,20,1,.f.)            // tenta abrir arquivo modo exclusivo
     SETPOS(23,1)
     RETU (.f.)                             // retorna .f., pois nao conseguiu
    ENDI
   #else
    USEARQ(dbf,,,,.f.)                      // abre arquivo e indexa
   #endi

   INDE ON &(sistema[i,O_CHAVE,t]) TO (ntx) EVAL POE_GAUGE() EVERY (LASTREC()/20)
   RESTSCREEN(0,0,MAXROW(),79,tel_a)        // restaura tela
  ENDI
 NEXT
 CLOS ALL                                   // fecha tudo
NEXT
dbfparam="PAR_ADM"
SELE A

#ifdef COM_REDE
 USEARQ(dbfparam,.t.,,,.f.)
#else
 USEARQ(dbfparam)
#endi

/*
   se nao existir nenhum registro no arquivo cria-o e coloca o valor
   inicial para cada um dos campos
*/
IF EOF() .OR. BOF()
 APPE BLAN
 REPL nrcanc WITH 000000
 REPL contarec WITH [RECEP]
 REPL contapag WITH [RECEP]
 REPL histrccar WITH LPAD([004],03,[0])
 REPL histrcfcc WITH LPAD([001],03,[0])
 REPL histrcrec WITH LPAD([002],03,[0])
 REPL histpg WITH LPAD([003],03,[0])
 REPL p_cidade WITH [LIMEIRA]
 REPL p_recp WITH [S]
 REPL setup1 WITH [Ind£stria de Urnas Bignotto Ltda]
ENDI

/*
   cria variaveis de memoria publicas identicas as de arquivo,
   para serem usadas por toda a aplicacao
*/
FOR i=1 TO FCOU()
 msg=FIEL(i)
 M->&msg.=&msg.
NEXT
USE
SETCURSOR(cur_atual)                        // retorna o cursor ao normal
RETU (.t.)                                  // retorna .t. - ok

/*
   Sintaxe: IMPEXP(<ExpN1> <,ExpN2> <,Exp> <,ExpN3> )
   Funcao.: Imprime conteudo expandido na impressora
              ExpN1 = linha a imprimir o conteudo
              ExpN2 = coluna a imprimir o conteudo
              Exp   = expressao a imprimir
              ExpN3 = largura total ocupada pela expressao
   Retorna: NIL
*/
FUNC IMPEXP(l_,c_,cp_,lg_)
@ l_,c_ SAY &drvpexp.+TRAN(cp_,"")+&drvtexp. // imprime campo expandido
SETPRC(l_,c_+lg_)                            // e ajusta o "carro" da
RETURN NIL                                   // impressora

/*
   Sintaxe: IMPCTL( <ExpC> )
   Funcao.: Imprime codigo de controle na impressora
              ExpC = codigo de controle
   Retorna: NIL
*/
FUNC IMPCTL(ctl_)
LOCAL li_:=PROW(), co_:=PCOL() // salva posicao do carro da impressora
IF LEN(ctl_)>0                 // se foi passado um codigo de controle
 lp_=SET(_SET_PRINTER,.t.)     // liga "echo" para impressora
 lc_=SET(_SET_CONSOLE,.f.)     // desliga saidas para video
 ?? &ctl_.                     // imprime caracteres de controle
 SET(_SET_PRINTER,lp_)         // retorna o "echo" original da impressora
 SET(_SET_CONSOLE,lc_)         // impressao no video habilitada
 SETPRC(li_,co_)               // retorna cabeca impressora
ENDI
RETURN NIL                     // para a posicao original

/*
   Sintaxe: IMPMEMO( <ExpM> <,N1> <,N2> <,N3> <,N4> <,ExpL> )
   Funcao.: Imprime campo "memo" em relat¢rio
              ExpM = campo "memo" a imprimir
              N1   = largura do campo "memo"
              N2   = linha a extrair e imprimir do campo "memo"
              N3/N4= linha e coluna onde sera impressa a linha
              ExpL = se .t., imprime alinhado
   Retorna: NIL
*/
FUNC IMPMEMO(cp_,tam_,nl_,l_,c_,just_)
LOCAL i_:=.f., ii_:=MEMOLINE(cp_,tam_,nl_)
IF just_.AND.RIGHT(RTRIM(ii_),1)!="."  // nao vamos justificar a
 i_=.t.                                // ultima linha do memo
ENDI
IMPAC(ii_,l_,c_,i_)                    // imprime linha do memo acentuada
RETU NIL

/*
   Sintaxe: MANUREF( <ExpC1> <,ExpC2> [,ExpN] <,ExpL> )
   Funcao.: Executa integridade referencial em tabelas
              ExpC1 = chave de acesso ao arquivo em ExpC2
              ExpC2 = arquivo alvo do processo de integridade
              ExpN  = ordem de pesquisa no arquivo. Se omitida, sera 1.
              ExpL  = se .t., soma mais 1 no campo de integridade (INTREF),
                      senao diminui 1.
   Retorna: NIL
*/
FUNC MANUREF(ch_,db_,or_dem,soma_)
or_=or_dem
IF TYPE("or_")="L"                            // ajusta parametros passados
 soma_=or_                                    // se soma ou dininui e a
 or_=1                                        // ordem do indice de pesquisa
ENDI
soma_=IF(soma_,1,-1)                          // transforma logico em numero
IF PTAB(ch_,db_,or_)                          // acha o reg referenciado

 #ifdef COM_REDE
  REPBLO(db_+'->intref',&("{||"+db_+"->intref+"+STR(soma_)+"}"))// atualiza cp da referencia
 #else
  REPL &db_.->intref WITH &db_.->intref+soma_ // atualiza cp da referencia
 #endi

ENDI
RETU NIL

* \\ Final de ADR_FUN2.PRG
