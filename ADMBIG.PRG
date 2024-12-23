
procedure admbig
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADMBIG.PRG
 \ Data....: 29-09-96
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Gerenciador geral
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v2.0d
 \ Convert.: v5.0 em 2021081014:57:30 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas

/*
   Funcoes chamadas dentro de macros
*/

REQUEST DESCEND, MTAB, VUF, VHORA, EXT, NMES, MMAA, VDV2, LTOC

#include "ADM_PUBL.ch"  // contem variaveis publicas

V0=SAVESCREEN(0,0,MAXROW(),79)
CLEA SCREEN
NAOPISCA()                   // habilita 256 cores (ega/vga)

/*
   rotina utilizando funcoes em assembly  para pegar o nome do programa
   que e  colocado pelo DOS no PSP (Program Segment Prefix) do programa
   que esta  sendo executado. O segmento do ambiente esta  no  endereco
   44/45 do segmento do PSP
*/
VAL_AX("6200")               // funcao 62h retorna segmento do PSP em BX
CALLINT("21")                // executa interrupt 21
x=VAL_BX()                   // pega o segmento do PSP
Sg=PEEK(x,44)+PEEK(x,45)*256 // calcula endereco do segmento de ambiente

/*
   Agora, procura no segmento de ambiente, por dois bytes ZERO seguidos.
   O nome do programa comeca 2 bytes apos os ZEROs
*/
x=0
DO WHIL .t.
 IF PEEK(Sg,x)=0             // este e o primeiro ZERO
  IF PEEK(Sg,x+1)=0          // se o proximo tambem for,
   x+=2                      // entao pula ambos
   EXIT                      // e sai
  ENDI
 ENDI
 x++                         // continua procurando
ENDD
direxe=""
IF PEEK(Sg,x)=1              // se este byte = 1, entao
 x+=2                        // o nome comeca aqui e vai
 DO WHIL PEEK(Sg,x)>0        // at‚ encontrar outro 0
  direxe+=CHR(PEEK(Sg,x))    // pega mais uma letra do nome
  x++
 ENDD
ENDI
direxe=UPPER(LEFT(direxe,RAT("\",direxe)))
arq_sos=direxe+"ADMBIG.SOS"  // nome do arquivo de ajuda
SETCANCEL(.f.)               // desativa ALT-C/BREAK
SET DATE BRIT                // datas no formato 'britasileiro`
SET EXAC OFF                 // comparacoes parciais habilitadas
SET SCOREBOARD OFF           // habilita uso da linha 0
SET WRAP ON                  // habilita rolagem de menus
SET KEY K_ALT_F2  TO doscom  // ALT-F2 ativa DOS-SHELL
SETKEY(K_INS,{||;            // muda tamanho do cursor quando inserindo
              IF(READINSERT(),SETCURSOR(1),SETCURSOR(3)),;
              READINSERT(!READINSERT());
             };
)


/*
   inicializa variaveis publicas
*/
msg:=cpord:=criterio:=chv_rela:=chv_1:=chv_2:=vr_memo := ""
op_sis:=cod_sos:=nucop:=op_posi:=op_menu :=1
nss=21
exrot:=AFILL(ARRAY(nss),""); usuario=""
datac=DATE()
nao_mostra:=l_s:=c_s:=c_i:=l_i := 0
tem_borda:=drvexcl:=drvvisivel := .t.
v_out:=gr_rela:=ve_outros:=cn:=fgrep:=drvmouse :=.f.
tem_t:=fgconf:=drvconf:=brw:=drvincl :=.f.
gcr=CHR(17)+CHR(217); nivelop=3

#ifdef COM_MOUSE
 drvmouse=(MOUSE()>0)                   // verifica e inicializa mouse
 drvratH=8; drvratV=16                  // default da sensibilidade do mouse
 tpo_mouse=0
#endi

drvcara=CHR(250); mold="ÚÄ¿³ÙÄÀ³ÃÄ´"
drvmenucen=.t.; drvfonte=0
drvporta="LPT1"
drvcortna="W/N*"; drvtittna="BG+/N*"
nemp="PresServ Inform tica-Limeira (019)452.6623"
nsis="Administradora - RECEP€„O"
arqgeral="ADM"

#ifdef COM_REDE

 #undef COM_PROTECAO

 drvtempo=25
 ide_maq=RIGHT(ALLTRIM(NETNAME()),4)    // tenta pegar nome da estacao
 IF EMPTY(ide_maq)                      // se netname() retornou nulo,
  ide_maq=LEFT(GETENV("ESTACAO"),4)     // tenta variavel de ambiente ESTACAO
 ENDI

 /*
    Se rede, e se NETNAME() do Clipper ou ESTACAO retornam "", pede ao usuario
    a identificacao da estacao para gravar arquivos de configuracoes
    especificos para cada usuario da rede
 */
 IF EMPTY(ide_maq)                 // CA-Clipper nao reconheceu nome da estacao
  cod_sos=49                       // nem existe variavel ambiental,
  msgt="IDENTIFICA€ŽO DA ESTA€ŽO"  // entao, vamos solicitar ao usuario
  SET KEY K_F1 TO                  // desativa help
  ide_maq=DBOX("Nome da esta‡„o",,,,,msgt,SPAC(4),"@!",,"W+/N")
  SET KEY K_F1 TO help             // habilita F1 (help)
  IF LASTKEY()=K_ESC .OR.;         // desistiu...
     EMPTY(ide_maq)                // ou nao informou
   RESTSCREEN(0,0,MAXROW(),79,v0)  // restaura tela
   SETPOS(MAXROW()-1,1)            // cursor na penultima linha, coluna 1
   RETU                            // e volta ao DOS
  ENDI
 ENDI
 ide_maq="_"+ALLTRIM(ide_maq)
 ms_uso="Arquivo sendo acessado|COM EXCLUSIVIDADE"
#else
 ide_maq="_temp"                   // nome do arquivo de configuracoes
#endi

ntxpw=direxe+arqgeral+"PW"
dbfpw=ntxpw+".SYS"                 // nomes dos arquivos de senhas
arqconf=direxe+arqgeral+;          // nome do arquivo de configuracoes
        ide_maq+".sys"
IF FILE(arqconf)
 REST FROM (arqconf) ADDI          // restaura configuracoes gravadas

 #ifdef COM_MOUSE
  IF drvmouse
   drvmouse=(MOUSE()>0)            // verifica e inicializa mouse
   MOUSERAT(drvratH,drvratV)       // ajusta sensibilidade do mouse
  ENDI
 #else
  drvmouse=.f.
 #endi

ELSE

 /*
    cria variaveis default de cores, codigos de impressao, etc...
 */
 drvmarca := "Epson"                          // nome da configuracao/marca impressora
 drvprn =1                                    // configuracao atual
 drvtapg="CHR(27)+'C'+CHR(NNN)"               // tamanho da pagina
 drvpcom="CHR(15)"                            // ativa comprimido (17,5 cpp)
 drvtcom="CHR(18)"                            // desativa comprimido (17,5 cpp)
 drvpc20="CHR(27)+'M'+CHR(15)"                // ativa comprimido (20 cpp)
 drvtc20="CHR(27)+'P'"                        // desativa comprimido (20 cpp)
 drvpeli="CHR(27)+'M'"                        // ativa elite
 drvteli="CHR(27)+'P'"                        // desativa elite
 drvpenf="CHR(27)+'E'"                        // ativa enfatizado
 drvtenf="CHR(27)+'F'"                        // desativa enfatizado
 drvpexp="CHR(27)+'W'+CHR(1)"                 // ativa expansao
 drvtexp="CHR(27)+'W'+CHR(0)"                 // desativa expansao
 drvpde8="CHR(27)+'0'"                        // ativa 8 lpp
 drvtde8="CHR(27)+'2'"                        // desativa 8 lpp
 drvland=""                                   // ativa landscape (paisagem)
 drvport=""                                   // ativa portrait (retrato)
 drvsom=.f.                                   // tipo de saida/efeitos sonoro
 drvautohelp=.f.                              // ajuda automatica em campos
 drvdbf:=drvntx:=drverr := PADR(QUALDIR(),23) // diretorio dos dbf's, ntx's e erros.dbf
 drvcorpad="N/BG"   ; drvcorbox="W+/B"        // cores default
 drvcormsg="W+/W"   ; drvcorenf="W+/R"
 drvcorget="GR+/N*" ; drvcortel="W+/B"
 drvcorhlp="BG+/B"  ; drvcortna="W/N*"
 drvtitpad="GR+/BG" ; drvtitbox="GR+/B"       // cores dos titulos default
 drvtitmsg="GR+/W"  ; drvtitenf="GR+/R"
 drvtitget="R+/N*"  ; drvtittel="GR+/B"
 drvtithlp="GR+/B"  ; drvtittna="BG+/N*"
 CBC1()                            // monta cabecalho e pano de fundo
 ALERTA()
 cod_sos=2
 IF !PEGADIR(.t.)                  // se nao informou diretorios de trabalho
  RESTSCREEN(0,0,MAXROW(),79,v0)   // restaura tela
  SETPOS(MAXROW()-1,1)             // cursor na penultima linha, coluna 1
  RETU                             // de volta ao DOS
 ENDI

 /*
    cria arquivo de senha e o inicializa com o primeiro usuario
 */
 IF !FILE(dbfpw)                    // nao encontrou arquivo de senhas,
  DBCREATE(dbfpw,{;                 // entao, cria estrutura
                  {"pass","C", 6,0},;
                  {"nome","C",15,0},;
                  {"nace","C", 1,0},;
                  {"ex01","C",20,0},;
                  {"ex02","C",20,0},;
                  {"ex03","C",20,0},;
                  {"ex04","C",20,0},;
                  {"ex05","C",20,0},;
                  {"ex06","C",20,0},;
                  {"ex07","C",20,0},;
                  {"ex08","C",20,0},;
                  {"ex09","C",20,0},;
                  {"ex10","C",20,0},;
                  {"ex11","C",20,0},;
                  {"ex12","C",20,0},;
                  {"ex13","C",20,0},;
                  {"ex14","C",20,0},;
                  {"ex15","C",20,0},;
                  {"ex16","C",20,0},;
                  {"ex17","C",20,0},;
                  {"ex18","C",20,0},;
                  {"ex19","C",20,0},;
                  {"ex20","C",20,0},;
                  {"ex21","C",20,0};
                 };
  )

  #ifdef COM_REDE
   USEARQ(dbfpw,.t.,20,1,.f.)       // tenta abrir senhas, exclusivo
  #else
   USE (dbfpw)                      // abre arquivo de senhas
  #endi

  INDE ON pass TO (ntxpw)           // indexa pela password
  APPE BLAN                         // credencia usuario ficticio (1o. acesso)
  senha=PWORD(arqgeral)             // com senha = tres primeiras letras
  REPL nome WITH ENCRIPT(SPAC(15)),;
       pass WITH senha, nace WITH ENCRIPT("3")
  USE
 ENDI
ENDI
arq_prn=drverr+"PRINTERS.DBF"            // nome dbf de "drivers" da prn
IF !FILE(arq_prn)                        // se o arquivo de "drivers"
 DBCREATE(arq_prn,{;                     // de impressoras nao existir
                   {"marca","C",15,0},;  // entao vamos cria-lo
                   {"porta","C", 4,0},;
                   {"tapg", "C",40,0},;
                   {"pcom", "C",40,0},;
                   {"tcom", "C",40,0},;
                   {"pc20", "C",40,0},;
                   {"tc20", "C",40,0},;
                   {"peli", "C",40,0},;
                   {"teli", "C",40,0},;
                   {"penf", "C",40,0},;
                   {"tenf", "C",40,0},;
                   {"pexp", "C",40,0},;
                   {"texp", "C",40,0},;
                   {"pde8", "C",40,0},;
                   {"tde8", "C",40,0},;
                   {"land", "C",40,0},;
                   {"port", "C",40,0};
                  };
 )

 #ifdef COM_REDE
  USEARQ(arq_prn,.t.,20,1,.f.)      // tenta abrir configuracoes, exclusivo
 #else
  USE (arq_prn)                     // abre arquivo de configuracoes
 #endi

 APPE BLAN                          // inclui uma configuracao
 REPL marca WITH drvmarca,;         // marca da impressora
      porta WITH drvporta,;         // porta de saida
      tapg  WITH drvtapg,;          // tamanho da pagina
      pcom  WITH drvpcom,;          // ativa comprimido (17,5 cpp)
      tcom  WITH drvtcom,;          // desativa comprimido (17,5 cpp)
      pc20  WITH drvpc20,;          // ativa comprimido (20 cpp)
      tc20  WITH drvtc20,;          // desativa comprimido (20 cpp)
      peli  WITH drvpeli,;          // ativa elite
      teli  WITH drvteli,;          // desativa elite
      penf  WITH drvpenf,;          // ativa enfatizado
      tenf  WITH drvtenf,;          // desativa enfatizado
      pexp  WITH drvpexp,;          // ativa expansao
      texp  WITH drvtexp,;          // desativa expansao
      pde8  WITH drvpde8,;          // ativa 8 lpp
      tde8  WITH drvtde8,;          // desativa 8 lpp
      land  WITH drvland,;          // ativa landscape
      port  WITH drvport            // ativa portrait
 USE
ENDI
MUDAFONTE(drvfonte)                 // troca a fonte de caracteres
corcampo=drvtittel                  // cor "unselected"
SETCOLOR(drvcorpad+","+drvcorget+",,,"+corcampo)
SET(_SET_DELETED,!drvvisivel)       // visibilidade dos reg excluidos
CBC1()                              // monta cabecalho e pano de fundo

/*
   se informado drive A para criar arquivo, previne preparo do disquete
*/
IF ASC(drvdbf)=65.OR.ASC(drvntx)=65 // informou drive A
 ALERTA()
 cod_sos=1
 op_a=DBOX("Disco pronto|Cancelar a opera‡„o",,,E_MENU,,"DISCO DE DADOS EM "+LEFT(drvdbf,1))
 IF op_a!=1
  RESTSCREEN(0,0,MAXROW(),79,v0)    // restaura tela
  SETPOS(MAXROW()-1,1)              // cursor na penultima linha, coluna 1
  RETU
 ENDI
ENDI
AFILL(sistema:=ARRAY(nss+1),{})     // enche sistema[] com vetores nulos
ADM_ATRI()                          // enche sistema[] com atributos dos arquivos
ADM_ATR1()
ADM_ATR2()

/*
   verifica qual subscricao do vetor SISTEMA corresponde ao arquivo
   aberto na area selecionada
*/
qualsis={|db_f|db_:=db_f,ASCAN(sistema,{|si|si[O_ARQUI,O_NOME]==db_})}

#ifdef COM_PROTECAO

 /*
    protege arquivo de dados contra acesso dBase e muda para "read-only"
    vamos comentar este "code block" ...
 */
 protdbf={|fg|pt:=fg,;                             // torna a flag visivel no proximo "code block"
           tel_p:=SAVESCREEN(0,0,MAXROW(),79),;    // salva a tela
           DBOX("Um momento!",,,,NAO_APAGA),;      // mensagem ao usuario
           AEVAL(sistema,{|sis|;                   // executa o "code block" para cada
                           EDBF(drvdbf+;           // um dos arquivos do vetor sistema
                                sis[O_ARQUI,O_NOME],pt);  // (se pt, desprotege; senao, protege)
                         };
           ),;
           RESTSCREEN(0,0,MAXROW(),79,tel_p);      // restaura a tela
         }
#endi

IF !FILE(dbfpw)                                    // se nao existir arquivo de
 ALERTA()                                          // senhas, avisa
 DBOX("Arquivo de senhas ausente!",,,2)
 RESTSCREEN(0,0,MAXROW(),79,v0)                    // restaura a tela
 SETPOS(MAXROW()-1,1)                              // cursor na penultima linha, coluna 1
 RETU                                              // retorna ao DOS
ENDI

#ifdef COM_REDE
 IF ! USEARQ(dbfpw,.f.,20,1,.f.)                   // falhou abertura modo compartilhado,
  RESTSCREEN(0,0,MAXROW(),79,v0)                   // restaura tela
  SETPOS(MAXROW()-1,1)                             // cursor na penultima linha, coluna 1
  RETU                                             // retorna ao DOS
 ENDI
#else
 EDBF(dbfpw,.t.)                                   // desprotege arquivo de
 USE (dbfpw)                                       // senhas e o utiliza
#endi

IF !FILE(ntxpw+".ntx")                             // se nao ha indice,
 INDE ON pass TO (ntxpw)                           // cria o arquivo indice
ENDI
SET INDE TO (ntxpw)
IF ASC(nace)>48 .AND. ASC(nace)<52                 // previne erro

 #ifdef COM_REDE
  IF !BLOARQ(3,.5)                                 // se nao conseguiu bloquear o arquivo,
   RESTSCREEN(0,0,MAXROW(),79,v0)                  // restaura tela
   SETPOS(MAXROW()-1,1)                            // cursor na penultima linha, coluna 1
   RETU                                            // retorna ao DOS
  ENDI
 #endi

 REPL ALL nace WITH ENCRIPT(nace),;                // manipulacao das senhas
          nome WITH ENCRIPT(nome)                  // criptografando o nivel e nome

 #ifdef COM_REDE
  UNLOCK                                           // libera arquivo
 #endi

ENDI
cod_sos=15
COLORSELECT(COR_GET)
v1=SAVESCREEN(0,0,MAXROW(),79)
CAIXA(mold,10,22,14,58,440)
@ 11,30 SAY "INFORME A SUA SENHA"                  // monta janela para
@ 12,35 SAY "Þ      Ý"                             // solicitar a entrada
@ 13,31 SAY "ESC para recome‡ar"                   // da senha de acesso
cp_=1
DO WHIL .t.
 COLORSELECT(COR_GET)
 senha=PWORD(12,36)                                // recebe a senha do usuario
 COLORSELECT(COR_PADRAO)
 SEEK senha                                        // ve se esta' credenciado
 IF FOUND()                                        // OK!
  usuario=TRIM(DECRIPT(nome))                      // nome do usuario
  senhatu=senha                                    // sua senha
  nivelop=VAL(DECRIPT(nace))                       // seu nivel
  FOR t=1 TO nss                                   // exrot[] contera' as
   msg=RIGHT(STR(100+t),2)                         // rotinas nao acessadas
   exrot[t]=ex&msg.                                // para cada subsistema
  NEXT
  IF nivelop>0.AND.nivelop<4                       // de 1 a 3...
   DBOX("Bom trabalho, "+usuario,13,45,2)          // boas vindas!
   EXIT                                            // use e abuse...
  ENDI
 ELSE
  IF cp_<2                                         // epa! senha invalida
   cp_++                                           // vamos dar outra chance
   ALERTA()                                        // estamos avisando!
   DBOX("Senha inv lida!",,,1)
   COLORSELECT(COR_GET)
   @ 12,36 SAY SPAC(6)
  ELSE                                             // errou duas vezes!
   ALERTA()                                        // este pode ser um E.T.
   DBOX("Usu rio n„o autorizado!",,,2)

   #ifndef COM_REDE
    EDBF(dbfpw,.f.)                                // protege o arquivo de senhas
   #endi

   #ifdef COM_PROTECAO
    EVAL(protdbf,.f.)                              // protege DBF
   #endi

   RESTSCREEN(0,0,MAXROW(),79,v0)                  // restaura tela,
   SETPOS(MAXROW()-1,1)                            // cursor na penultima linha, coluna 1
   MUDAFONTE(0)                                    // retorna com a fonte normal
   RETU                                            // e tchau!
  ENDI
 ENDI
ENDD
RESTSCREEN(0,0,MAXROW(),79,v1)                     // restaura tela
USE                                                // fecha o arquivo de senhas

#ifdef COM_PROTECAO
 EVAL(protdbf,.t.)                                 // desprotege DBFs
#endi

msg_auto="Opera‡„o n„o autorizada, "+usuario
IF !CRIADBF()                                      // se DBF nao criado,

 #ifdef COM_PROTECAO
  EVAL(protdbf,.f.)                                // protege DBF
 #endi

 RESTSCREEN(0,0,MAXROW(),79,v0)                    // restaura tela
 SETPOS(MAXROW()-1,1)                              // cursor na penultima linha, coluna 1
 RETU                                              // volta ao DOS
ENDI
SET CONF (drvconf)                                 // ajusta SET CONFIRM
cod_sos=1
ALERTA(1)
msg="Atualize a data de hoje"
datac=DBOX(msg,,,,,"ATEN€ŽO!",datac,"99/99/99")    // confirma a data
IF UPDATED()                                       // se modificou sugestao,
 DOSDATA(DTOC(datac))                              // vamos atualizar o DOS
ENDI
dbfparam=drvdbf+"PAR_ADM"
SELE A

#ifdef COM_REDE
 USEARQ(dbfparam,.t.,,,.f.)
#else
 USE (dbfparam)
#endi


/*
   cria variaveis de memoria publicas identicas as de arquivo,
   para serem usadas por toda a aplicacao
*/
FOR i=1 TO FCOU()
 msg=FIEL(i)
 M->&msg.=&msg.
NEXT
USE
CBC1()                                             // atualiza parametros do cabecalho
opc_01=1
v01=SAVESCREEN(0,0,MAXROW(),79)
DO WHIL opc_01!=0
 cod_sos=3
 RESTSCREEN(0,0,MAXROW(),79,v01)
 menu01="Lan‡amentos|"+;
        "A.Funeral|"+;
        "Relat¢rios|"+;
        "Tabelas|"+;
        "Apoio"
 msgt="MENU GERAL DO SISTEMA"
 opc_01=DBOX(menu01,5,7,E_MENU,NAO_APAGA,msgt,,,opc_01)
 BEGIN SEQUENCE
  DO CASE
   CASE opc_01=0      // retornar ao DOS
    ALERTA()
    msgt="ENCERRAMENTO"
    msg ="Finalizar opera‡”es|N„o finalizar"
    cod_sos=1
    op_=DBOX(msg,,,E_MENU,,msgt,,,1)
    IF op_=1
     MUDAFONTE(0)
    ELSE
     opc_01=1
    ENDI

   CASE opc_01=1     // lan‡amentos
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     cod_sos=4
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Recebimento de Taxas|"+;
            "Consulta Contrato|"+;
            "Endere‡os|"+;
            "Outros Recebimentos"
     msgt="LAN€AMENTOS"
     opc_02=DBOX(menu02,7,15,E_MENU,NAO_APAGA,msgt,,,opc_02)
     DO CASE
      CASE opc_02=1     // recebimento de taxas
       BXREC(9,23)

      CASE opc_02=2     // consulta contrato
       TXACONTR(9,23)

      CASE opc_02=3     // endere‡os
       ALENDER(9,23)

      CASE opc_02=4     // outros recebimentos
       OBXEC(9,23)

     ENDC
     CLEA GETS
     CLOS ALL
    ENDD

   CASE opc_01=2     // a.funeral
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     cod_sos=4
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Lan‡amento Aux.Funeral|"+;
            "Impress„o Aux.Funeral|"+;
            "Relat¢rio de Processo|"+;
            "Capa de Processo|"+;
            "Processar Pgto em"
     msgt="A.FUNERAL"
     opc_02=DBOX(menu02,7,15,E_MENU,NAO_APAGA,msgt,,,opc_02)
     DO CASE
      CASE opc_02=1     // lan‡amento aux.funeral
       AFUNER(9,23)

      CASE opc_02=2     // impress„o aux.funeral
       ADM_R020(9,23)

      CASE opc_02=3     // relat¢rio de processo
       ADM_R029(9,23)

      CASE opc_02=4     // capa de processo
       ADM_R026(9,23)

      CASE opc_02=5     // processar pgto em
       ADM_R021(9,23)

     ENDC
     CLEA GETS
     CLOS ALL
    ENDD

   CASE opc_01=3     // relat¢rios
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     cod_sos=4
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Recibo COM falecidos|"+;
            "Recibos Sem Falecidos|"+;
            "Endere‡os Alterados|"+;
            "Outros recibos (2¦Via)|"+;
            "Fechamento Caixa|"+;
            "Fechamento 2¦Via"
     msgt="RELAT¢RIOS"
     opc_02=DBOX(menu02,7,15,E_MENU,NAO_APAGA,msgt,,,opc_02)
     DO CASE
      CASE opc_02=1     // recibo com falecidos
       ADM_R018(9,23)

      CASE opc_02=2     // recibos sem falecidos
       ADM_RS18(9,23)

      CASE opc_02=3     // endere‡os alterados
       ADM_R022(9,23)

      CASE opc_02=4     // outros recibos (2¦via)
       ADM_R023(9,23)

      CASE opc_02=5     // fechamento caixa
       ADM_R039(9,23)

      CASE opc_02=6     // fechamento 2¦via
       ADM_R050(9,23)

     ENDC
     CLEA GETS
     CLOS ALL
    ENDD

   CASE opc_01=4     // tabelas
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     cod_sos=4
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Grupos|"+;
            "Categoria dos Planos|"+;
            "Regi”es|"+;
            "Circulares|"+;
            "Cobradores/Vendedores|"+;
            "Processos|"+;
            "Contratos|"+;
            "Funcion rios|"+;
            "Hist¢rico Padr„o|"+;
            "Pgtos / Recebtos"
     msgt="TABELAS"
     opc_02=DBOX(menu02,7,15,E_MENU,NAO_APAGA,msgt,,,opc_02)
     DO CASE
      CASE opc_02=1     // grupos
       ARQGRUP(9,23)

      CASE opc_02=2     // categoria dos planos
       CLASSES(9,23)

      CASE opc_02=3     // regi”es
       REGIAO(9,23)

      CASE opc_02=4     // circulares
       CIRCULAR(9,23)

      CASE opc_02=5     // cobradores/vendedores
       COBRADOR(9,23)

      CASE opc_02=6     // processos
       PRCESSOS(9,23)

      CASE opc_02=7     // contratos
       GRUPOS(9,23)

      CASE opc_02=8     // funcion rios
       FNCS(9,23)

      CASE opc_02=9     // hist¢rico padr„o
       HISTORIC(9,23)

      CASE opc_02=10     // pgtos / recebtos
       ORDPGRC(9,23)

     ENDC
     CLEA GETS
     CLOS ALL
    ENDD

   CASE opc_01=5     // apoio
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     op_menu=PROJECOES
     cod_sos=9
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Parƒmetros|"+;
            "Vˆ relat¢rio gravado|"+;
            "Backup|"+;
            "Restaura backup|"+;
            "Reconstr¢i ¡ndices|"+;
            "Elimina reg apagados|"+;
            "Configura ambiente|"+;
            "Plano de senhas"
     msgt="APOIO"
     opc_02=DBOX(menu02,7,15,E_MENU,NAO_APAGA,msgt,,,opc_02)
     DO CASE
      CASE opc_02=1     // parƒmetros
       PAR_ADM(9,23)

      CASE opc_02=2     // vˆ relat¢rio gravado
       arq_=ARQGER()                               // pega nome do arquivo
       IF !EMPTY(arq_)                             // se cancelou ou nao informou
        cod_sos=1
        BROWSE_REL(arq_,2,3,MAXROW()-2,78)         // mostra o arquivo gravado
       ENDI

      CASE opc_02=3     // backup
       GBAK()

      CASE opc_02=4     // restaura backup
       RBAK()

      CASE opc_02=5     // reconstr¢i ¡ndices
       cod_sos=39
       RCLA()

      CASE opc_02=6     // elimina reg apagados
       cod_sos=40
       COMPACTA()

      CASE opc_02=7     // configura ambiente
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
        cod_sos=41
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="ÿ Diret¢rio de trabalho|"+;
               "ÿ Marca da impressoraÿÿ|"+;
               "ÿ Pano de fundoÿÿÿÿÿÿÿÿ|"+;
               "ÿ Fontes de caracteresÿ|"+;
               "ÿ Esquemas de coresÿÿÿÿ|"+;
               IF(drvconf,"û ","ÿ ")+"Confirma em camposÿÿÿ|"+;
               IF(drvexcl,"û ","ÿ ")+"Confirma exclus”esÿÿÿ|"+;
               IF(drvincl,"û ","ÿ ")+"Confirma inclus”esÿÿÿ|"+;
               IF(drvvisivel,"û ","ÿ ")+"Excluidos vis¡veisÿÿÿ|"+;
               IF(drvsom,"û ","ÿ ")+"Efeitos sonorosÿÿÿÿÿÿ|"+;
               IF(drvautohelp,"û ","ÿ ")+"Ajuda de campo ativaÿ|"+;
               IF(drvmouse,"û ","ÿ ")+"Liga/desliga mouseÿÿÿ|"+;
               "ÿ Sensibilidade mouseÿÿ"
        msgt="CONFIGURA AMBIENTE"
        opc_03=DBOX(menu03,9,23,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // diret¢rio de trabalho
          cod_sos=2
          PEGADIR(.f.)

         CASE opc_03=2     // marca da impressora
          CONFPRN()

         CASE opc_03=3     // pano de fundo
          cod_sos=43; msg=""                       // menu de caracteres para fundo
          FOR t=1 TO 255                           // enche msg com as opcoes
           IF t!=124                               // exceto o '|` que e o
            msg+="|"+STR(t,3)+" - "+CHR(t)         // caracter separador das
           ENDI                                    // opcoes da DBOX(
          NEXT
          t=ASC(drvcara)-IF(ASC(drvcara)>123,1,0)
          op_x=DBOX(SUBS(msg,2),,31,E_MENU,,"FUNDO",,,t)
          IF op_x!=0                               // escolhido um caracter
           op_x+=IF(op_x>123,1,0)                  // desconta o '|`
           IF drvcara!=CHR(op_x)                   // se caracter
            drvcara=CHR(op_x)                      // diferente do atual
            SAVE TO (arqconf) ALL LIKE drv*        // grava configuracoes,
            CBC1()                                 // monta tela principal e
            v01=SAVESCREEN(0,0,MAXROW(),79)        // salva para o break
            BREAK                                  // que foi configurado
           ENDI
          ENDI

         CASE opc_03=4     // fontes de caracteres
          op_x=1; cod_sos=53
          msgf=MUDAFONTE(999)
          DO WHILE op_x!=0 .AND.LEN(msgf)>0
           msgf=STRTRAN(msgf,CHR(251)," ")
           msgf=LEFT(msgf,13*drvfonte)+CHR(251)+SUBS(msgf,13*drvfonte+2)
           op_x=DBOX(msgf,11,31,E_MENU,,"FONTES",,,drvfonte+1)
           IF op_x>0
            drvfonte=op_x-1
            MUDAFONTE(drvfonte)
           ENDI
          ENDD

         CASE opc_03=5     // esquemas de cores
          CONFCORES()

         CASE opc_03=6     // confirma em campos
          drvconf=!drvconf
          SET(_SET_CONFIRM,drvconf)

         CASE opc_03=7     // confirma exclus”es
          drvexcl=!drvexcl

         CASE opc_03=8     // confirma inclus”es
          drvincl=!drvincl

         CASE opc_03=9     // excluidos vis¡veis
          drvvisivel=!drvvisivel
          SET(_SET_DELETED,!drvvisivel)

         CASE opc_03=10     // efeitos sonoros
          drvsom=!drvsom

         CASE opc_03=11     // ajuda de campo ativa
          drvautohelp=!drvautohelp

         CASE opc_03=12     // liga/desliga mouse
          IF MOUSE()>0
           drvmouse=!drvmouse
          ENDI
         CASE opc_03=13     // sensibilidade mouse
          cod_sos=45
          AJMOUSE()
        ENDC
        CLEA GETS
        CLOS ALL
       ENDD
       SAVE TO (arqconf) ALL LIKE drv*             // diferente do atual

      CASE opc_02=8     // plano de senhas
       cod_sos=17
       MASENHA(7,23)
     ENDC
     CLEA GETS
     CLOS ALL
    ENDD

  ENDC
 END
 CLEA GETS
 CLOS ALL
ENDD

#ifndef COM_REDE
 EDBF(dbfpw,.f.)                                   // protege arquivo senhas
#endi

#ifdef COM_PROTECAO
 EVAL(protdbf,.f.)                                 // protege DBF
#endi

RESTSCREEN(0,0,MAXROW(),79,v0)                     // s'imbora
SETPOS(MAXROW()-1,1)                               // e cursor na penultima linha, coluna 1
RETU                                               // volta ao DOS

* \\ Final de ADMBIG.PRG