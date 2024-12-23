procedure bxross
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica -Limeira (019)452.6623
 \ Programa: BXREC.PRG
 \ Data....: 12-04-98
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Gerenciador do subsistema de recebimento de taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"BXREC")
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
 RESTSCREEN(,0,MAXROW(),79,t_fundo)                // restaura tela do fundo
 cod_sos=5 ; cn=.f.
 CLEA TYPEAHEAD                                    // limpa o buffer do teclado
 fgrep=.f.
 SET KEY K_F3 TO                                   // retira das teclas F3 e F4 as
 SET KEY K_F4 TO                                   // funcoes de repeticao e confirmacao
 msg="Inclus„o|"+;
     "Manuten‡„o|"+;
     "Consulta"
 op_cad=DBOX(msg,lin_menu,col_menu,E_MENU,NAO_APAGA,MAIUSC(sistema[op_sis,O_MENU]),,,op_cad)
 IF op_cad!=0                                      // se escolheu uma opcao
  Tela_fundo=SAVESCREEN(0,0,MAXROW(),79)           // salva a tela para ROLATELA()
  SELE A                                           // e abre o arquivo e seus indices

  #ifdef COM_REDE
   IF !USEARQ(sistema[op_sis,O_ARQUI],.f.,20,1)    // se falhou a abertura do
    RETU                                           // arquivo volta ao menu anterior
   ENDI
  #else
   USEARQ(sistema[op_sis,O_ARQUI])
  #endi

  SET KEY K_F9 TO veoutros                         // habilita consulta em outros arquivos
 ENDI
 DO CASE
  CASE op_cad=01                                   // inclus„o
   op_menu=INCLUSAO
   IF AT("D",exrot[op_sis])=0                      // se usuario pode fazer inclusao
    BXR_INCL()                                     // neste arquivo chama prg de inclusao
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
   EDITA(3,3,MAXROW()-2,77)

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC BXR_incl     // inclusao no arquivo BXREC
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),dbfseq_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:=""
FOR i=1 TO FCOU()                                  // cria/declara privadas as
 msg=FIEL(i)                                       // variaveis de memoria com
 PRIV &msg.                                        // o mesmo nome dos campos
NEXT                                               // do arquivo
AFILL(rep,"")
t_f3_=SETKEY(K_F3,{||rep()})                       // repeticao reg anterior
t_f4_=SETKEY(K_F4,{||conf()})                      // confirma campos com ENTER
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})               // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})

#ifdef COM_REDE
 BXR_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com estensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE BXREC
 GO BOTT                                           // forca o
 SKIP                                              // final do arquivo
 
 /*
    cria variaveis de memoria identicas as de arquivo, para inclusao
    de registros
 */
 FOR i=1 TO FCOU()
  msg=FIEL(i)
  M->&msg.=IF(fgrep.AND.!EMPT(rep[1]),rep[i],&msg.)
 NEXT
 DISPBEGIN()                                       // apresenta a tela de uma vez so
 BXR_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 BXR_GERA_SEQ()
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/BXREC->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 M->ano=LPAD(RIGHT(DTOC(DATE()),2),02,[0])
 SELE 0                                            // torna visiveis variaveis de memoria
 BXR_GET1(INCLUI)                                  // recebe campos
 SELE BXREC
 IF LASTKEY()=K_ESC                                // se cancelou
  cabem=0
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
 BXR_REL(ult_reg)                               // imprime relat apos inclusao
ENDD

#ifdef COM_REDE
 BXR_ANT_SEQ()                                     // restaura sequencial anterior
 SELE BXREC
#endi

GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC BXR_REL(ult_reg)  // imprime relatorio apos inclusao
op_=1
msg_t="TAXAS (RECEP€ŽO)"
msg="Autentica‡„o|Recibo"
op_=DBOX(msg,,,E_MENU,,msg_t,,,2)  // quer emitir outra copia?
if op_ = 2
 DO WHIL .t.
  msg_t="RECEBIMENTOS"
  SAVE SCREEN                     // salva a tela

  #ifdef COM_REDE
    tps=TP_SAIDA(,,.t.)            // escolhe a impressora
    IF LASTKEY()=K_ESC             // se teclou ESC
     EXIT                          // cai fora...
    ENDI
    IF tps=2 .OR. PREPIMP(msg_t)   // se nao vai para video conf impressora pronta
     ADR_R067(tps,0,ult_reg)
  #else
   IF PREPIMP(msg_t)              // confima preparacao da impressora
    ADM_R067(0,0,ult_reg)
  #endi

   REST SCREEN                    // restaura tela
   msg="Prosseguir|Outra c¢pia"
   op_=DBOX(msg,,,E_MENU,,msg_t)  // quer emitir outra copia?
   IF op_=2
    LOOP                          // nao quer...
   ENDI
  ENDI
  EXIT
 ENDD
ELSEIF op_ = 1

 DO WHIL .t.
  msg_t="TAXAS (RECEP€ŽO)"
  SAVE SCREEN                     // salva a tela

  #ifdef COM_REDE
    tps:=1

   IF tps=2 .OR. 1=1 //PREPIMP(msg_t)   // se nao vai para video conf impressora pronta
    op_=2
    msg="Fita|Autenticar|Sair"
    op_=DBOX(msg,,,E_MENU,,msg_t,,,2)  // quer emitir outra copia?
    if op_=1.or.op_=2
     arq_=drvporta                                    // porta de saida configurada
     SET PRINTER TO (arq_)                             // redireciona saida
     SET DEVI TO PRIN                                   // inicia a impressao

     IMPCTL(drvpcom)

     cl:=PROW()
/*
     IF ORDPGRC->nrdoctos=1.AND.op_<2
      cl+=2
      @ cl,000 SAY [CAIXA: ]+TRAN(numop,"999999")	      // N§ O.P.
      @ cl,014 SAY TRAN(ORDPGRC->lancto_,"@D")               // Emitido em
      cl+=1
      @ cl,000 SAY [Oper.: ]+ORDPGRC->por
      cl+=1
      @ cl,000 SAY [Saldo: ]+TRAN(ORDPGRC->valortotal-valorpg,"@E 999,999.99")
      cl+=1
     ENDI
*/
     @ cl,000 SAY TRAN(ORDPGRC->nrdoctos,"9999")               // Emitido em
     @ cl,005 SAY TRAN(DATE(),"@D")               // Emitido em
     @ cl,013 SAY LEFT(TIME(),5)               // Emitido em
 //    @ cl,018 SAY TRAN(numero,"999999")             // Numero
     @ cl,018 SAY TRAN(codigo,"999999")             // Codigo
     @ cl,025 SAY TRAN(tipo,"!")                    // Tipo
     @ cl,026 SAY TRAN(circ,"999")                  // Circular
     @ cl,029 SAY TRAN(valorpg,"@E 99,999.99")     // Valor pago
 //    @ cl,046 SAY TRAN(numop,"999999")              // N§ O.P.
 //    @ cl,053 SAY M->usuario              // N§ O.P.

     IMPCTL(drvtcom)                                    // retira comprimido
     SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
     SET DEVI TO SCRE                                   // direciona saida p/ video
    endi
   ENDI

  #endi

   REST SCREEN                    // restaura tela
   IF op_=2
    LOOP                          // nao quer...
   ENDI
   if op_=1
    SET PRINTER TO (arq_)                             // redireciona saida
    SET DEVI TO PRIN                                   // inicia a impressao
    cl+=1
    @ cl,000 SAY []
    SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
    SET DEVI TO SCRE                                   // direciona saida p/ video
   endi
  EXIT
 ENDD
endi


RETU


#ifdef COM_REDE
 PROC BXR_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE BXR_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == numero
  REPL numero WITH sq_numero
  REPL intlan WITH sq_intlan
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC BXR_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"BXR_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"numero"    ,"C",  6, 0},;
                    {"intlan"    ,"C",  8, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE BXREC
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL BXR_SEQ->numero WITH numero
  REPL BXR_SEQ->intlan WITH intlan
  SET ORDER TO 1                // retorna ao indice principal
 ENDI
 SELE BXR_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC BXR_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE BXR_SEQ
 BLOARQ(0,.5)
 sq_numero=BXR_SEQ->numero
 sq_intlan=BXR_SEQ->intlan
#else
 SET ORDER TO 0
 GO BOTT
#endi

M->numero=LPAD(STR(VAL(numero)+1),06,[0])
M->intlan=LPAD(STR(VAL(intlan)+1),08,[0])

#ifdef COM_REDE
 BXR_GRAVA_SEQ()
 sq_atual_=BXR_SEQ->numero
 UNLOCK                                            // libera o registro
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC BXR_GRAVA_SEQ
REPL numero WITH M->numero
REPL intlan WITH M->intlan
RETU

PROC BXR_tela     // tela do arquivo BXREC
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
@ l_s+01,c_s+1 SAY " Numero:   -      -                 (                                )"
@ l_s+02,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY " Inscri‡„o:"
@ l_s+05,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+06,c_s+1 SAY " D‚bito:    N§:        Valor:               Pago com:"
@ l_s+07,c_s+1 SAY "                                            Troco...:"
@ l_s+08,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
RETU

PROC BXR_gets     // mostra variaveis do arquivo BXREC
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS()
BXR_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(CODIGO,'GRUPOS',1)
PTAB(IIF(EMPT(M->USUARIO),PADR(M->CONTAREC+IDE_MAQ,10,' '),PADR(M->USUARIO,10,' '))+M->HISTRCREC+[       ],'ORDPGRC',2)
PTAB(PADR(SUBSTR(M->IDE_MAQ,2),4)+[BXR],[IMPPAR],1)
CRIT("",,"4")
@ l_s+01 ,c_s+10 GET  ano;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+01 ,c_s+13 GET  numero;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+03 ,c_s+13 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"1|2")

@ l_s+06 ,c_s+10 GET  tipo;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+06 ,c_s+17 GET  circ;
		 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+06 ,c_s+31 GET  valorpg;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+06 ,c_s+55 GET  valoraux;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,07,O_CRIT],,"3")

@ l_s+01 ,c_s+49 GET  emitido_;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+01 ,c_s+38 GET  por

@ l_s+01 ,c_s+64 GET  numop;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]

CLEAR GETS
RETU

PROC BXR_get1     // capta variaveis do arquivo BXREC
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS()
PRIV  blk_bxrec:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+10 GET ano;
                   PICT sistema[op_sis,O_CAMPO,01,O_MASC]
  @ l_s+01 ,c_s+13 GET numero;
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
  @ l_s+01 ,c_s+49 GET emitido_;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
  @ l_s+01 ,c_s+38 GET por
  @ l_s+01 ,c_s+64 GET numop;
                   PICT sistema[op_sis,O_CAMPO,11,O_MASC]
  CLEA GETS
  CRIT("",,"4")
  @ l_s+03 ,c_s+13 GET  codigo;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3
                   MOSTRA sistema[op_sis,O_FORMULA,1]
                   MOSTRA sistema[op_sis,O_FORMULA,2]

  @ l_s+06 ,c_s+10 GET  tipo;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+06 ,c_s+17 GET  circ;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+06 ,c_s+31 GET  valorpg;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+06 ,c_s+55 GET  valoraux;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7
		   MOSTRA sistema[op_sis,O_FORMULA,3]

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
PTAB(CODIGO,'TAXAS',1)
PTAB(CODIGO+TIPO+CIRC,'TAXAS',1)
PTAB(IIF(EMPT(M->USUARIO),PADR(M->CONTAREC+IDE_MAQ,10,' '),PADR(M->USUARIO,10,' '))+M->HISTRCREC+[       ],'ORDPGRC',2)
PTAB(PADR(SUBSTR(M->IDE_MAQ,2),4)+[BXR],[IMPPAR],1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA

 #ifdef COM_REDE
  IF PTAB(numop,'ORDPGRC',1)
   REPBLO('ORDPGRC->valortotal',{||ORDPGRC->valortotal -valorpg})
   REPBLO('ORDPGRC->nrdoctos',{||ORDPGRC->nrdoctos - 1})
  ENDI
  IF !EMPT(valorpg)
   REPBLO('TAXAS->pgto_',{||CTOD('  /  /  ')})
   REPBLO('TAXAS->forma',{||[ ]})
   REPBLO('TAXAS->baixa_',{||CTOD('  /  /  ')})
   REPBLO('TAXAS->stat',{||[ ]})
   REPBLO('TAXAS->valorpg',{||0})
  ENDI
 #else
  IF PTAB(numop,'ORDPGRC',1)
   REPL ORDPGRC->valortotal WITH ORDPGRC->valortotal -valorpg
   REPL ORDPGRC->nrdoctos WITH ORDPGRC->nrdoctos - 1
  ENDI
  IF !EMPT(valorpg)
   REPL TAXAS->pgto_ WITH CTOD('  /  /  ')
   REPL TAXAS->forma WITH [ ]
   REPL TAXAS->baixa_ WITH CTOD('  /  /  ')
   REPL TAXAS->stat WITH [ ]
   REPL TAXAS->valorpg WITH 0
  ENDI
 #endi

 IF 1=3
  IF !EMPTY(ORDPGRC->codlan)
   TIRA_LANC("ORDPGRC",LEFT(ORDPGRC->codlan,16),.f.)
  ENDI
 ENDI
 IF 1=3
  IF !EMPTY(IMPPAR->codlan)
   TIRA_LANC("IMPPAR",LEFT(IMPPAR->codlan,16))
  ENDI
 ENDI
 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF !PTAB(IIF(EMPT(M->usuario),PADR(M->contarec+ide_maq,10,' '),PADR(M->usuario,10,' '))+M->histrcrec+[       ],'ORDPGRC',2)
   ord_=LEN(sistema[EVAL(qualsis,"ORDPGRC"),O_CHAVE])
   chv_="BXR-"+intlan+"-001"
   PTAB(chv_,"ORDPGRC",ord_)
   FAZ_LANC("ORDPGRC",chv_,.t.)
   REPL ORDPGRC->origem WITH [ADM],;
        ORDPGRC->lancto_ WITH DATE(),;
        ORDPGRC->por WITH M->usuario,;
        ORDPGRC->numconta WITH IIF(EMPT(M->usuario),PADR(M->contarec+ide_maq,10,' '),PADR(M->usuario,10,' ')),;
        ORDPGRC->historico WITH M->histrcrec,;
        ORDPGRC->debcred WITH [C],;
	ORDPGRC->valortotal WITH 0,;
        ORDPGRC->vencto_ WITH DATE(),;
	ORDPGRC->documento WITH [FCC/Taxas],;
        ORDPGRC->complement WITH [FCC/Taxas pagas na Recep‡„o]

   #ifdef COM_REDE
    ORDPGRC->(DBUNLOCK())                          // libera o registro
   #endi

  ENDI
  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1)
   ord_=LEN(sistema[EVAL(qualsis,"IMPPAR"),O_CHAVE])
   chv_="BXR-"+intlan+"-002"
   PTAB(chv_,"IMPPAR",ord_)
   FAZ_LANC("IMPPAR",chv_)
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
        IMPPAR->base WITH [BXR]

   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

  ENDI
   IF EMPT(numop)
    IF op_menu=INCLUSAO
     numop=ORDPGRC->numop
    ELSE
     REPL numop WITH ORDPGRC->numop
    ENDI
   ENDI

  #ifdef COM_REDE
   IF PTAB(numop,'ORDPGRC',1)
    REPBLO('ORDPGRC->valortotal',{||ORDPGRC->valortotal +valorpg})
    REPBLO('ORDPGRC->nrdoctos',{||ORDPGRC->nrdoctos + 1})
   ENDI
   IF !EMPT(valorpg)
    REPBLO('TAXAS->pgto_',{||DATE()})
    REPBLO('TAXAS->forma',{||[P]})
    REPBLO('TAXAS->baixa_',{||DATE()})
    REPBLO('TAXAS->por',{||M->usuario})
    REPBLO('TAXAS->stat',{||[6]})
    REPBLO('TAXAS->valorpg',{||valorpg})
   ENDI
   IF op_menu=INCLUSAO
    emitido_=DATE()
   ELSE
    REPL emitido_ WITH DATE()
   ENDI
   IF op_menu=INCLUSAO
    por=M->usuario
   ELSE
    REPL por WITH M->usuario
   ENDI
   IF op_menu=INCLUSAO
    hemit=TIME()
   ELSE
    REPL hemit WITH TIME()
   ENDI
   IF op_menu=INCLUSAO
    filial=M->p_filial
   ELSE
    REPL filial WITH M->p_filial
   ENDI
   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1)
    REPBLO('IMPPAR->docto',{||ano+numero})
   ENDI
  #else
   IF EMPT(numop)
    IF op_menu=INCLUSAO
     numop=ORDPGRC->numop
    ELSE
     REPL numop WITH ORDPGRC->numop
    ENDI
   ENDI
   IF PTAB(numop,'ORDPGRC',1)
    REPL ORDPGRC->valortotal WITH ORDPGRC->valortotal +valorpg
    REPL ORDPGRC->nrdoctos WITH ORDPGRC->nrdoctos + 1
   ENDI
   IF !EMPT(valorpg)
    REPL TAXAS->pgto_ WITH DATE()
    REPL TAXAS->forma WITH [P]
    REPL TAXAS->baixa_ WITH DATE()
    REPL TAXAS->por WITH M->usuario
    REPL TAXAS->stat WITH [6]
    REPL TAXAS->valorpg WITH valorpg
   ENDI
   IF op_menu=INCLUSAO
    emitido_=DATE()
   ELSE
    REPL emitido_ WITH DATE()
   ENDI
   IF op_menu=INCLUSAO
    por=M->usuario
   ELSE
    REPL por WITH M->usuario
   ENDI
   IF op_menu=INCLUSAO
    hemit=TIME()
   ELSE
    REPL hemit WITH TIME()
   ENDI
   IF op_menu=INCLUSAO
    filial=M->p_filial
   ELSE
    REPL filial WITH M->p_filial
   ENDI
   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1)
    REPL IMPPAR->docto WITH ano+numero
   ENDI
  #endi

  IF op_menu!=INCLUSAO
   RECA
  ENDI
 ENDI
ENDI
RETU

* \\ Final de BXREC.PRG
