/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADR_ADAP.PRG
 \ Data....: 29-01-04
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Adapta arquivos do sistema
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "adrbig.ch"    // inicializa constantes manifestas

REQUEST IN_KEY

V0=SAVESCREEN(0,0,MAXROW(),79) // tela do DOS
CLEA SCREEN                    // limpa a tela

NAOPISCA()                     // habilita 256 cores (ega/vga)
SETCANCEL(.f.)                 // desativa ALT-C/BREAK
SET SCOREBOARD OFF             // habilita uso da linha 0
SET CENTURY ON               // datas com informa‡„o do s‚culo DD/MM/AAAA
SET DATE BRIT                  // datas no formato 'britasileiro`
SET WRAP ON                    // habilita rolagem de menus
SETKEY(K_INS,{||;              // muda tamanho do cursor quando inserindo
              IF(READINSERT(),SETCURSOR(1),SETCURSOR(3)),;
              READINSERT(!READINSERT());
             };
)

VideoSeg=IF(CARDTYPE()=V_MONO,45056,-18432) // area de video

/*
   rotina utilizando funcoes em assembly para pegar o  nome do programa
   que e' colocado pelo DOS no PSP (Program Segment Prefix) do programa
   que esta sendo executado.  O segmento do ambiente esta  no  endereco
   44/45 do segmento do PSP
*/
VAL_AX("6200")                 // funcao 62h retorna segmento do PSP em BX
CALLINT("21")                  // executa interrupt 21
x=VAL_BX()                     // pega o segmento do PSP
Sg=PEEK(x,44)+PEEK(x,45)*256   // calcula endereco do segmento de ambiente

/*
   Agora, procura no segmento de ambiente, por dois bytes ZERO seguidos.
   O nome do programa comeca 2 bytes apos os ZEROs
*/
x=0
DO WHIL .t.
 IF PEEK(Sg,x)=0               // este e o primeiro ZERO
  IF PEEK(Sg,x+1)=0            // se o proximo tambem for,
   x+=2                        // entao pula ambos
   EXIT                        // e sai
  ENDI
 ENDI
 x++                           // continua procurando
ENDD
exe=""
IF PEEK(Sg,x)=1                // se este byte = 1, entao
 x+=2                          // o nome comeca aqui e vai
 DO WHIL PEEK(Sg,x)>0          // at‚ encontrar outro 0
  exe+=CHR(PEEK(Sg,x))         // pega mais uma letra do nome
  x++
 ENDD
ENDI
IF EMPTY(exe)                  // CA-Clipper nao pegou diretorio do exe
 exe=TRATADIR(QUALDIR())       // assume diretorio atual
ENDI

/*
   inicializa variaveis publicas
*/
nss=030
drvdbf:=drvntx:=drverr:=drvpw := TRATADIR(QUALDIR())
drvcara=CHR(178); mold="ÚÄ¿³ÙÄÀ³ÃÄ´"
drvmenucen=.f.; drvfonte=1
nemp="PresServ Inform tica - Limeira (019)452.6623"
nsis="Administradora - RECEP€„O"
arqgeral="ADR"
drvcorpad="W+/RB"  ; drvcorbox="W+/B"         // cores default
drvcormsg="W+/W"   ; drvcorenf="W+/R"
drvcorget="W+/BG"  ; drvcortel="W+/B"
drvcorhlp="GR+/GR" 
drvtitpad="GR+/RB" ; drvtitbox="GR+/B"        // cores dos titulos default
drvtitmsg="GR+/W"  ; drvtitenf="GR+/R"
drvtitget="GR+/BG" ; drvtittel="GR+/B"
drvtithlp="W+/GR"  
IF EMPTY(exe)                      // CA-Clipper nao pegou diretorio do exe
 cod_sos=1
 msgt="DIRET¢RIO DO EXECUTVEL"    // entao, vamos solicitar ao usuario
 exe=DBOX("Informe o nome do diret¢rio|onde o arquivo EXE esta",,,,,msgt,SPAC(60),"@!",,"W+/N")
 IF LASTKEY()=K_ESC .OR.;          // desistiu...
    EMPTY(exe)                     // ou nao informou
  RESTSCREEN(0,0,MAXROW(),79,v0)   // restaura tela
  SETPOS(MAXROW()-1,1)             // cursor na penultima linha, coluna 1
  RETU                             // e volta ao DOS
 ENDI
 exe=TRATADIR(exe)                 // assume diretorio atual
ENDI
exe=UPPER(exe)                 // captaliza nome do programa
drvexe=LEFT(exe,RAT("\",exe))
arqconf=drvexe+arqgeral+"_temp.sys"
acao_mac="D"                                   // inicializa flag
IF FILE(arqconf)
 REST FROM (arqconf) ADDI                      // restaura configuracoes gravadas
ENDI
drvautohelp:=drvmouse:=drvsom :=.f.            // sem ajuda ativa, sem mouse e som
AFILL(sistema:=ARRAY(nss),{})                  // enche sistema[] com vetores nulos
SETCOLOR(drvcorpad)                            // imprime pano de fundo
CAIXA(REPL(drvcara,9),0,0,MAXROW(),79)
SETCOLOR(drvtitbox)
CAIXA(mold,01,03,05,77)                        // monta cabecalho do programa
SETCOLOR(drvcorbox)
@ 02,05 SAY nemp                               // conteudo do cabecalho
@ 02,66 SAY DATE()
@ 02,57 SAY NSEM(DATE())
@ 03,05 SAY nsis
@ 04,05 SAY "ADAPTADOR DE ARQUIVOS DBF"
cn=.f.; cod_sos=4
DO WHIL !cn
 V1=SAVESCREEN(0,0,MAXROW(),79)                // salva fundo/cabecalho
 SETCOLOR(drvtittel)
 CAIXA(mold,07,16,16,63)
 @ 10,16 SAY SUBS(mold,9,1)+REPL(SUBS(mold,10,1),46)+SUBS(mold,11,1)
 SETCOLOR(drvcortel)
 @ 08,29 SAY "DIRET¢RIOS DE TRABALHO"          // monta tela para receber
 @ 09,31 SAY "F10=pega diret¢rio"
 @ 11,18 SAY "Arquivos de dados..:"            // os diretorios dos dados
 @ 12,18 SAY "Arquivos de indices:"
 @ 13,18 SAY "Arquivos de apoio..:"
 @ 14,18 SAY "Arquivo execut vel.:"
 @ 15,18 SAY "Arquivo de senha...:"
 drvdbf=PADR(drvdbf,50)                        // prepara diretorio para o get
 drvntx=PADR(drvntx,50)
 drverr=PADR(drverr,50)
 drvexe=PADR(drvexe,50)
 drvpw=PADR(drvpw,50)
 SET KEY K_F10 TO CAPTURADIR()
 @ 11,39 GET drvdbf PICT "@S23@!" VALI DRVEXISTE(drvdbf)
 @ 12,39 GET drvntx PICT "@S23@!" VALI DRVEXISTE(drvntx)
 @ 13,39 GET drverr PICT "@S23@!" VALI DRVEXISTE(drverr)
 @ 14,39 GET drvexe PICT "@S23@!" VALI DRVEXISTE(drvexe)
 @ 15,39 GET drvpw PICT "@S23@!" VALI DRVEXISTE(drvpw)
 READ
 SET KEY K_F10 TO
 IF LASTKEY()=K_ESC                            // abandonado...
  op_=3
 ELSE
  drvdbf=TRATADIR(drvdbf)                      // coloca "\" ao final
  drvntx=TRATADIR(drvntx)                      // do diretorio
  drverr=TRATADIR(drverr)
  drvexe=TRATADIR(drvexe)
  drvpw=TRATADIR(drvpw)
  AFILL(sistema:=ARRAY(nss),{})                // enche sistema[] com vetores nulos
  ADR_ATRI()                                   // enche sistema[] com atributos dos DBF
ADR_ATR1()
ADR_ATR2()
  dbfdefa:=ntxdefa := ""
  FOR t=1 TO nss-3                             // verifica que mais pede diretorio
   IF sistema[t,O_OUTROS,O_PEDEDIR]            // esse pede...
    RESTSCREEN(0,0,MAXROW(),79,v1)             // restaura cabecalho e pano de fundo
    SETCOLOR(drvtittel)
    CAIXA(mold,07,16,13,63)                    // janela dos diretorios
    @ 10,16 SAY SUBS(mold,9,1)+REPL(SUBS(mold,10,1),46)+SUBS(mold,11,1)
    SETCOLOR(drvcortel)
    @ 08,17 SAY PADC(UPPER(sistema[t,O_MENU]),46)
    @ 09,17 SAY PADC("F10=pega diret¢rio",46)
    @ 11,18 SAY "Arquivos de dados..:"
    @ 12,18 SAY "Arquivos de indices:"
    cn=.f.; cod_sos=4
    drv_="drvdbf"+LEFT(sistema[t,O_ARQUI,O_NOME],3)
    ntx_="drvntx"+LEFT(sistema[t,O_ARQUI,O_NOME],3)
    IF EMPTY(dbfdefa)
     dbfdefa=&drv_.
     ntxdefa=&ntx_.
    ENDI
    &drv_.=PADR(dbfdefa,50)                     // prepara diretorio para o get
    &ntx_.=PADR(ntxdefa,50)
    SET KEY K_F10 TO CAPTURADIR()
    @ 11,39 GET &drv_. PICT "@S23@!" VALI DRVEXISTE(&drv_.)
    @ 12,39 GET &ntx_. PICT "@S23@!" VALI DRVEXISTE(&ntx_.)
    READ
    SET KEY K_F10 TO
    IF LASTKEY()=K_ESC                         // cancelou...
     RESTSCREEN(0,0,MAXROW(),79,v0)            // s'imbora
     SETPOS(MAXROW()-1,1)                      // cursor na penultima linha, coluna 1
     RETU                                      // retorna ao DOS
    ENDI
    &drv_.=TRATADIR(&drv_)                     // coloca "\" ao final
    &ntx_.=TRATADIR(&ntx_)                     // coloca "\" ao final
    dbfdefa=&drv_.
    ntxdefa=&ntx_.
   ENDI
  NEXT
  ALERTA(1)
  msg="Prosseguir|Corrigir|Retornar ao DOS"
  op_=DBOX(msg,12,55,E_MENU,,"DIRET¢RIOS")     // confirma as informacoes
 ENDI
 IF op_=1                                      // se tudo certo,
  EXIT                                         // sai do loop
 ELSEIF op_=3
  RESTSCREEN(0,0,MAXROW(),79,v0)               // s'imbora
  SETPOS(MAXROW()-1,1)                         // cursor na penultima linha, coluna 1
  RETU                                         // retorna ao DOS
 ENDI
ENDD
RESTSCREEN(0,0,MAXROW(),79,v1)                 // restaura cabecalho e pano de fundo
msg_veri="Verificando arquivos..."             // pode demorar um pouco entao vamos
DBOX(msg_veri,,,,NAO_APAGA,"AGUARDE!")         // avisar que estamos trabalhando
cod_sos=1
cps_:=ARRAY(100)                               // armazenara' os novos conteudos dos cps
ADR_ATRI()                                     // enche sistema[] com atributos dos DBF
ADR_ATR1()
ADR_ATR2()

/*
   protege arquivo de dados contra acesso dBase e muda para "read-only"
*/
protdbf={|fg|pt:=fg,;                          // torna a flag visivel no proximo "code block"
          tel_p:=SAVESCREEN(0,0,MAXROW(),79),; // salva a tela
          DBOX("Um momento!",,,,NAO_APAGA),;   // mensagem ao usuario
          AEVAL(sistema,{|sis|;                // executa o "code block" para cada
                          EDBF(sis[O_ARQUI,O_DIR_DBF]+;  // um dos arquivos do vetor sistema
                              sis[O_ARQUI,O_NOME],pt);// (se pt, desprotege; senao, protege)
                        };
          ),;
          RESTSCREEN(0,0,MAXROW(),79,tel_p);   // restaura a tela
        }
arq_prn=drverr+"PRINTERS.DBF"                    // nome dbf de "drivers" da prn
IF FILE(arq_prn)                                 // se o arquivo de "drivers"
 estru_prn={;                                    // de impressoras existir
             {"marca" ,"C",15,0},;               // entao vamos verificar se ele
             {"porta" ,"C", 4,0},;               // necessita de alguma adaptacao
             {"padrao","C", 1,0},;
             {"tapg"  ,"C",40,0},;
             {"pcom"  ,"C",40,0},;
             {"tcom"  ,"C",40,0},;
             {"pc20"  ,"C",40,0},;
             {"tc20"  ,"C",40,0},;
             {"peli"  ,"C",40,0},;
             {"teli"  ,"C",40,0},;
             {"penf"  ,"C",40,0},;
             {"tenf"  ,"C",40,0},;
             {"pexp"  ,"C",40,0},;
             {"texp"  ,"C",40,0},;
             {"pde8"  ,"C",40,0},;
             {"tde8"  ,"C",40,0},;
             {"land"  ,"C",40,0},;
             {"port"  ,"C",40,0};
           }
 USE (arq_prn)                                   // abre DBF de impressoras
 IF LEN(DBSTRUCT())!=LEN(estru_prn)              // se a qde de campos for
  USE                                            // diferente da nova estrutura
  bak=LEFT(arq_prn,LEN(arq_prn)-3)+"bak"         // entao vamos adaptar o DBF
  IF FILE(bak)                                   // se existir o arquivo temporario
   ERASE (bak)                                   // entao elimina-o
  ENDI
  RENAME (arq_prn) TO (bak)                      // cria .bak
  DBCREATE(arq_prn,estru_prn)                    // cria novo DBF para as impressoras
  USE (arq_prn)                                  // abre o DBF e aproveita
  APPEND FROM (bak)                              // os dados nele digitados
  USE
 ENDI
 CLOSE ALL                                       // fecha o DBF das impressoras aberto
ENDI
EVAL(protdbf,.t.)                                   // desprotege DBF
FOR op_sis=1 TO nss-3                            // vamos verificar quais DBF
 IF FILE(sistema[op_sis,O_ARQUI,O_DIR_DBF]+sistema[op_sis,O_ARQUI,O_NOME]+".dbf") // necessitam ser adaptados
  dbf=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"temp9"  // se existir o DBF,
  stru=LEFT(sistema[op_sis,O_ARQUI,O_NOME],3)+"_estr"  // cria a estrutura atual
  &stru.()                                       // em um arquivo temporario
  USE (dbf)                                      // abre DBF temporario
  estru_nov=DBSTRUCT()                           // e captura a nova estrutura
  dbf=sistema[op_sis,O_ARQUI,O_DIR_DBF]+sistema[op_sis,O_ARQUI,O_NOME] // vamos fazer a mesma coisa
  USE (dbf)                                      // para capturar a antiga
  estru_vel=DBSTRUCT()                           // estrutura do arquivo,
  USE                                            // abrindo o DBF anterior
  ok=(LEN(estru_nov)=LEN(estru_vel))             // se a qde de campos for
  IF ok                                          // a mesma, entao vamos
   FOR t=1 TO LEN(estru_nov)                     // ver se os atributos dos
    FOR tt=1 TO 4                                // dois arquivos sao iguais
     IF !(estru_nov[t,tt]==estru_vel[t,tt])      // (nome, tipo, tam, dec)
      ok=.f.; t:=tt:= 9999
     ENDI
    NEXT
   NEXT
  ENDI
  IF !ok                                         // se o arquivo esta' diferente
   IF !CONVERTE(op_sis,estru_nov,estru_vel)      // executa a conversao do DBF
    RESTSCREEN(0,0,MAXROW(),79,v0)               // cancelou a adaptacao
    SETPOS(MAXROW()-1,1)                         // reposiciona cursor e
    RETU                                         // volta para o DOS
   ENDI
  ENDI
  FOR t=1 TO LEN(sistema[op_sis,O_INDIC])        // para eliminar os arquivos
   ntx=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,t]+EXTENSAO()
   IF FILE(ntx)                                  // de indices caso existam
    ERASE (ntx)
   ENDI
  NEXT
  dbf=sistema[op_sis,O_ARQUI,O_DIR_DBF]+LEFT(sistema[op_sis,O_ARQUI,O_NOME],3)+"_SEQ.dbf" // mata dbf de sequenciais
  IF FILE(dbf)
   ERASE (dbf)
  ENDI
  dbf=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"temp9.dbf"
  IF FILE(dbf)                                   // se foi criado algum arquivo
   ERASE (dbf)                                   // temporario elimina-o antes
  ENDI                                           // de retornar ao DOS
  dbt=sistema[op_sis,O_ARQUI,O_DIR_DBF]+"temp9"+EXTENSAO(.f.)
  IF FILE(dbt)                                   // se foi criado algum arquivo
   ERASE (dbt)                                   // temporario do memo elimina-o
  ENDI                                           // antes de retornar ao DOS
 ENDI
NEXT
CLOSE ALL

#ifdef COM_PROTECAO
 EVAL(protdbf,.f.)                               // protege DBF
#endi

EVAL(protdbf,.t.)                                // desprotege DBF
dbft=drvpw+"temp9.dbf"                           // arq temporario
dbfg=drvpw+sistema[nss-2,O_ARQUI,O_NOME]+".dbf"  // grupos das senhas
dbf=drvpw+sistema[nss-1,O_ARQUI,O_NOME]+".dbf"   // acesso aos arq dbf dos grupos
IF FILE(dbf) .AND. FILE(dbfg)                    // se exite os aquivos de senhas
 IF FILE(dbft)                                   // se o arq temporario existir
  ERASE (dbft)                                   // vamos mata-lo
 ENDI
 DBCREATE(dbft,{;                                // cria arquio temp = acesso aos
                {"pw_grupo"  ,"C",  4, 0},;      // arq dbf dos gupos
                {"pw_dbf"    ,"C", 35, 0},;
                {"pw_permis" ,"C", 20, 0},;
                {"flag_excl" ,"C",  1, 0};
               };
         )
 SET DELE ON                                     // excluidos nao serao adaptados
 SELE A                                          // seleciona uma area vazia
 USE (dbfg)                                      // abre o arq de gupos de senhas
 SELE B                                          // seleciona outra area vazia
 USE (dbf)                                       // abre o arq de acessos
 INDEX ON pw_grupo+pw_dbf TO &drvpw.temp9        // cria indice temp pelo grupo+nome do arquivo
 SELE C                                          // outra area vazia
 USE (dbft)                                      // abre arq temporario
 SELE A                                          // vamos correr
 GO TOP                                          // todos os grupos
 DO WHILE !EOF()
  FOR i=1 TO nss-3                               // para cada arquivo
   SELE C                                        // vamos colocar seu acesso
   APPEND BLANK                                  // dentro do arq temporario
   REPL pw_grupo WITH A->pw_grupo,;
        pw_dbf WITH ENCRIPT(PADR(sistema[i,O_MENU],35))
   SELE B                                        // procura este acesso no arquivo velho
   SEEK A->pw_grupo+ENCRIPT(PADR(sistema[i,O_MENU],35))
   IF FOUND()                                    // achou...
    REPL C->pw_permis WITH B->pw_permis          // aproveita as permissoes anteriores
   ELSE
    REPL C->pw_permis WITH ENCRIPT(SPACE(20))    // nao achou, coloca brancos
   ENDI
  NEXT
  SELE A
  SKIP                                           // proximo grupo...
 ENDD
 CLOSE ALL                                       // fecha todos os arq
 ERASE (dbf)                                     // mata arq de acessos velho
 RENAME (dbft) TO (dbf)                          // troca o nome do arq temp para arq de acessos
 ERASE &drvpw.temp.ntx                           // mata indice temp
 FOR op_sis=nss-2 TO nss                         // corre os arq de senhas
  FOR t=1 TO LEN(sistema[op_sis,O_INDIC])        // para eliminar os arquivos
   ntx=sistema[op_sis,O_ARQUI,O_DIR_NTX]+sistema[op_sis,O_INDIC,t]+EXTENSAO()
   IF FILE(ntx)                                  // de indices caso existam
    ERASE (ntx)
   ENDI
  NEXT
 NEXT
ENDI
dbf=drvpw+"temp9"+EXTENSAO()                     // arq de indice temporario
IF FILE(dbf)                                     // se foi criado algum arquivo
 ERASE (dbf)                                     // temporario de indice elimina-o antes
ENDI                                             // de retornar ao DOS

#ifdef COM_PROTECAO
 EVAL(protdbf,.f.)                               // protege DBF
#endi

ALERTA(3)                                        // beep, beep, beep
DBOX("OK! Opera‡„o terminada",13,40,4)           // mostra msg de fim de operacao
RESTSCREEN(0,0,MAXROW(),79,v0)                   // s'imbora
SETPOS(MAXROW()-1,1)                             // cursor na penultima linha, coluna 1
RETU                                             // retorna para o DOS

FUNC CONVERTE(op_sis,estru_nov,estru_vel)        // converte DBF ...
dbf=sistema[op_sis,O_ARQUI,O_DIR_DBF]+sistema[op_sis,O_ARQUI,O_NOME]        // DBF a converter
USE (dbf)
AFILL(cps_,"")                                   // 'cps_` e' o vetor que armazenara'
qtcps=LEN(estru_nov)                             // os conteudos dos campos
FOR t=1 TO qtcps                                 // da nova estrutura
 i=ASCAN(estru_vel,;                             // inicializa 'cps_` com os
           {|cp|cp[1]==estru_nov[t,1].AND.;      // conteudos da estrutura anterior
                cp[2]==estru_nov[t,2];           // se o campo tiver o mesmo
           };                                    // nome e tamanho da nova estrutura
   )
 IF i>0                                          // ok! este campo e' o mesmo
  cps_[t]=estru_vel[i,1]                         // enche 'cps_` com o nome do
 ENDI                                            // campo da estrutura anterior
NEXT
op_a=1
DO WHIL op_a!=0
 RESTSCREEN(0,0,MAXROW(),79,v1)                  // retira msg 'aguarde...`
 msg=""                                          // msg armazenara' as opcoes
 FOR t=1 TO qtcps                                // de menu dos campos da
  msg+="|"+PADR(estru_nov[t,1],11)+"³ "+;        // nova estrutura e o conteudo
       PADR(cps_[t],30)                          // que sera' colocado em
 NEXT                                            // cada um deles
 msg =SUBS(msg,2)                                // retira o '|` do inicio
 cod_sos=1
 msgt='ARQUIVO "'+sistema[op_sis,O_ARQUI,O_NOME]+; // titulo do menu
      '"|*|ESTRUTURA    PREENCHER COM:'+SPAC(17)
 op_a=DBOX(msg,,,E_MENU,NAO_APAGA,msgt,,,op_a)   // apresenta o menu
 IF op_a>0                                       // escolheu um campo
  cp_=cps_[op_a]
  DO WHIL .t.
   SET KEY K_F10 TO ve_campos                    // F10 monta menu de campos
   cp_=LEFT(cp_+SPACE(250),250)                  // ate' 250 caracteres para digitar
   msg ="Entre com a express„o para preencher o campo"
   msgt='CONTEUDO DO CAMPO "'+estru_nov[op_a,1]+;
        '"|(F10=ESTRUTURA ANTERIOR)'
   cod_sos=2
   cp_=DBOX(msg,,,,NAO_APAGA,msgt,cp_,"@S50")    // recebe o novo conteudo...
   SET KEY K_F10 TO                              // desabilita a tecla F10
   IF LASTKEY()=K_ESC                            // se cancelou,
    EXIT                                         // retorna ao menu de campos
   ENDI
   cp_=ALLTRIM(cp_)                              // retira os espacos do novo conteudo
   tp_crit=TYPE(cp_)                             // se a expressao=indeterminada,
   IF tp_crit="UI"                               // existe funcao fora da clipper.lib
    tp_crit=VALTYPE(&cp_.)                       // na expressao, logo avalia o seu
   ENDI                                          // conteudo...
   IF EMPT(cp_).OR.tp_crit==estru_nov[op_a,2]    // se o tipo da expressao
    cps_[op_a]=cp_                               // informada for igual ao tipo
    EXIT                                         // do campo em questao,
   ENDI                                          // entao prossegue,
   ALERTA(3)                                     // caso contrario, vamos avisar
   DBOX("EXPRESSŽO ILEGAL",15)                   // que a expressao nao atende
  ENDD
 ELSE                                            // teclou ESC, entao vamos
  msg ="Prosseguir convers„o|"+;                 // perguntar se o usuario
       "Refazer conte£do dos campos|"+;          // quer continuar com a
       "Cancelar a opera‡„o"                     // adaptacao do DBF...
  msgt="ARQUIVO "+sistema[op_sis,O_ARQUI,O_NOME]
  cod_sos=3
  op_=DBOX(msg,12,45,E_MENU,,msgt)               // apresenta menu
  IF op_=1                                       // quer continuar...
   msg='Atualizando o arquivo "'+;
       sistema[op_sis,O_ARQUI,O_NOME]+'"'        // avisa que estamos
   DBOX(msg,,,,NAO_APAGA,"AGUARDE!")             // trabalhando...
   CLOSE ALL                                     // fecha todos os arquivos abertos
   drv_dbf=sistema[op_sis,O_ARQUI,O_DIR_DBF]
   dbf=drv_dbf+sistema[op_sis,O_ARQUI,O_NOME]+".dbf" // nome do arquivo para adaptar
   IF FILE(drv_dbf+"temp9.dbf") // se o backup existir
    ERASE &drv_dbf.temp9.dbf                     // vamos elimina-lo
   ENDI
   RENAME (dbf) TO &drv_dbf.temp9.dbf            // troca o nome do DBF para temp9
   dbt=drv_dbf+sistema[op_sis,O_ARQUI,O_NOME]+EXTENSAO(.f.) // nome do arq memo p/ adaptar
   IF FILE(dbt)                                   // se dbf tem memo e
    dbtt=drv_dbf+"temp9"+EXTENSAO(.f.)
    IF FILE(dbtt)                                 // se o backup existir
     ERASE (dbtt)                                 // vamos elimina-lo
    ENDI
    RENAME (dbt) TO (dbtt)                        // troca o nome do DBT para temp9
   ENDI
   stru=LEFT(sistema[op_sis,O_ARQUI,O_NOME],3)+"_estr" // nome do prg da nova estrutura
   &stru.()                                      // cria nova estrutura
   SELE A
   USE (dbf) ALIAS ATUAL                         // abre o novo DBF
   SELE B
   USE &drv_dbf.temp9 ALIAS VELHO                // abre o dbf antigo
   DO WHILE !EOF()                               // processaremos todos os registros...
    SELE ATUAL
    APPEND BLANK                                 // cria um novo registro
    FOR i=1 TO qtcps                             // coloca em cada campo
     msg=estru_nov[i,1]                          // do novo registro, o conteudo
     IF !EMPTY(cps_[i])                          // escolhido do DBF anterior
      REPL &msg. WITH VELHO->(&(cps_[i]))
     ENDI
    NEXT
    IF VELHO->(DELE())                           // se o reg esta macado para
     DELE                                        // exclusao vamos marcar no
    ENDI                                         // novo tambem
    SELE VELHO                                   // proximo...
    SKIP
   ENDD
   op_a=0
  ELSEIF op_=2 .OR. op_=0                        // quer redigitar os conteudos
   op_a=1
  ELSE                                           // cancelou a operacao
   RETU .f.
  ENDI
 ENDI
ENDD
RESTSCREEN(0,0,MAXROW(),79,v1)                   // coloca cabecalho e pano de fundo
DBOX(msg_veri,,,,NAO_APAGA,"AGUARDE!")           // avisa que estamos trabalhando...
CLOSE ALL                                        // fecha todos os arquivos e
RETU .t.                                         // prossegue conversao de outros arquivos

FUNC TRATADIR(drv_)                              // trata diretorio informado
drv_=ALLTRIM(drv_)                               // tira espacos
drv_=IF(RIGHT(drv_,1)!="\".AND.;                 // diretorio tem que
       LEN(drv_)>0,drv_+"\",drv_)                // terminar com barra (\)
RETU drv_

FUNC DRVEXISTE(drv_)                             // testa se diretorio existe
LOCAL drv_atual:="\"+CURDIR(),x
drv_=ALLTRIM(drv_)                               // tira espacos
drv_=IF(RIGHT(drv_,1)!="\".AND.;
     LEN(drv_)>0,drv_+"\",drv_)                  // terminar com barra (\)
drv_=LEFT(drv_,LEN(drv_)-1)
IF !CHDIR(drv_) .AND. LEN(drv_)>2                // se diretorio nao existe,
 ALERTA(2)                                       // beep, beep e
 op_=DBOX("Diret¢rio ilegal!",,,,,"ATEN€ŽO!")    // avisa
 RETU .f.
ELSE                                             // ok, diretorio existe,
 CHDIR(drv_atual)                                // posiciona no diretorio anterior
ENDI
RETU .t.

PROC VE_CAMPOS                                   // mostra os campos da
LOCAL ve_op:=""                                  // estrutura anterior e
FOR i=1 TO LEN(estru_vel)                        // permite a captura do
 ve_op+="|"+PADR(estru_vel[i,1],12)+;            // nome do campo para
        " "+estru_vel[i,2]+;                     // dentro da expressao
        LPAD(STR(estru_vel[i,3]),4)+;            // que esta sendo informada
        LPAD(STR(estru_vel[i,4]),3)
NEXT
op_campo=DBOX(SUBS(ve_op,2),,50,E_MENU,,"CAMPOS DA ESTRUTURA|ANTERIOR|Nome         T Tam CD")
IF op_campo>0
 KEYB ALLTRIM(estru_vel[op_campo,1])
ENDI
RETU

PROC HELP                                        // ajuda (F1)
LOCAL tela_, cor_, t, estr_db, tec_f10, txt:=ARRAY(6)
SETKEY(K_F1,NIL)                                 // evita recursividade
tec_f10=SETKEY(K_F10,NIL)                        // desabilita tecla F10
tela_=SAVESCREEN(0,0,MAXROW(),79)                // salva a tela por baixo e
cor_=SETCOLOR(drvcorenf)                         // o esquema de cor vigente
DO CASE
 CASE cod_sos=1
  txt={;
        "A coluna ESTRUTURA deste menu mostra os campos atuais do",;
        "arquivo de  dados que necessitam ser adaptados. Na colu-",;
        "na PREENCHER COM: aparecem as sugest”es para serem colo-",;
        "cadas dentro de cada campo.     Caso queira mudar alguma",;
        "sugest„o  pressione ENTER  sobre o campo  desejado  caso",;
        "contrario, tecle ESC para prosseguir a opera‡„o.        ";
      }
 CASE cod_sos=2
  txt={;
        "     Informe um novo conte£do para colocar no campo,  em",;
        "todos os registros do arquivo.  Pode ser utilizada qual-",;
        "quer express„o em CA-Clipper, nomes de campos, etc, des-",;
        "de que tenham o mesmo tipo do campo a modificar. A tecla",;
        "F10 pode ser utilizada para capturar conte£dos de campos",;
        "da estrutura anterior deste arquivo DBF.";
      }
 CASE cod_sos=3
  txt={;
        "     Selecione a op‡„o PROSSEGUIR para iniciar o proces-",;
        "so de convers„o do arquivo  em  destaque no t¡tulo  dete",;
        "menu (todos os registros do arquivo ser„o atingidos). Se",;
        "desejar corrigir mais alguma informa‡„o, selecione REFA-",;
        "ZER CONTEUDO ou tecle ESC.   A op‡„o CANCELAR A OPERA€ŽO",;
        "serve para retornar ao DOS.";
      }
 CASE cod_sos=4
  txt={;
        "     Informe os diret¢rios onde residem os diversos  ar-",;
        "quivos (DBF, NTX e senhas) da aplica‡„o que ir  sofrer a",;
        "adapta‡„o.    Os nomes dos diret¢rios informados dever„o",;
        "terminar com o caracter '\'.   Informados os diret¢rios,",;
        "selecione a op‡„o 'Prosseguir` para  este programa  ini-",;
        "ciar as adapta‡”es necess rias.";
      }
ENDC
SETCOLOR("GR+"+SUBS(drvcorenf,AT("/",drvcorenf)))// prepara esquema de cor
CAIXA(mold,2,10,9,69)                            // monta janela
@ 9,37 SAY " ESC "                               // mostra tecla de finalizacao
SETCOLOR(drvcorenf)
FOR t=1 TO 6                                     // apresenta msg na janela
 @ 2+t,12 SAY txt[t]
NEXT
INKEY(0)                                         // espera uma tecla
SETCOLOR(cor_)                                   // retorna a cor original
RESTSCREEN(0,0,MAXROW(),79,tela_)
SETKEY(K_F10,tec_f10)                            // habilita tecla F10
SET KEY K_F1 TO help                             // reprograma o help
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
      t_f10:=SETKEY(K_F10,NIL), msgt:=""
PRIVATE _Escolheu
IF !EMPTY(v_ar)
 dir_base=ALLTRIM(&v_ar.)
ENDI
IF EMPTY(dir_base)
 dir_base=drvdbf
ENDI
IF !DRVEXISTE(dir_base)
 dir_base=drvdbf
 IF !DRVEXISTE(dir_base)
  dir_base=QUALDIR()
 ENDI
ENDI
IF RIGHT(dir_base,1)<>"\"
 dir_base=dir_base+"\"
ENDI
DO WHILE .t.
 _Escolheu=.f.
 IF _comarq
  dir_arq=DIRECTORY(dir_base+mask_)
  msgt=mask_
 ELSE
  dir_arq:={}
  msgt="|F10=Escolhe"
 ENDI
 dir_=DIRECTORY(dir_base+"*.*","D")
 qt_dir=1
 FOR t=1 TO LEN(dir_)
  IF dir_[t,5]="D" .AND. "."!=dir_[t,1]
   AADD(dir_arq,{})
   AINS(dir_arq,qt_dir)
   ACOPY(dir_,dir_arq,t,1,qt_dir)
   qt_dir++
  ENDI
 NEXT
 FOR t=1 TO LEN(dir_arq)
  IF AT("~",dir_arq[t,1])>0
   dir_arq[t,1]=STRTRAN(dir_arq[t,1],"~","ô")
  ENDI
 NEXT
 IF _comarq=.f.
  SET KEY K_F10 TO ESCOLHIDOUM()
 ENDI
 op_a=DBOX(dir_arq,,,.T.,,dir_base+msgt)
 IF op_a=0
  EXIT
 ENDI
 IF AT("ô",dir_arq[op_a,1])>0
  dir_arq[op_a,1]=STRTRAN(dir_arq[op_a,1],"ô","~")
 ENDI
 IF dir_arq[op_a,5]="D" .AND. _escolheu=.f.
  IF dir_arq[op_a,1]=".."
   dir_base=LEFT(dir_base,LEN(dir_base)-1)
   dir_base=LEFT(dir_base,RAT("\",dir_base))
  ELSE
   dir_base=dir_base+dir_arq[op_a,1]+"\"
  ENDI
 ELSE
  KEYB CHR(K_HOME)+CHR(K_CTRL_Y)+dir_base+IIF(dir_arq[op_a,1]="..","",dir_arq[op_a,1])
  EXIT
 ENDI
ENDD
SETKEY(K_F10,t_f10)
RETU

* \\ Final de ADR_ADAP.PRG
