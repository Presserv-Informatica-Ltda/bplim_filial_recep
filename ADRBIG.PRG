
// <ADRBIG> - <ADR_>

// *Acertos do arquivo principal
function main()
#include "hbgtinfo.ch"
#include "dbinfo.ch"
ntx:=""
drvautohelp:=.F.
Hb_GTInfo(HB_GTI_MOUSESTATUS, .F. )
setmode(25,80)
*--

REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_ES850C
REQUEST DESCEND, MTAB, VUF, VDV2, VCGC, NMES, VHORA, EXT
REQUEST DBFCDX
RDDSETDEFAULT("DBFCDX")

*--
// Variáveis estáticas utilizadas pela lib
Static11:= ""
Static13:= {}
Static14:= "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%"
Static15:= {"412321214","214321214","414321212","212341214","412341212","214341212","212321414","412321412","214321412","212341412","412123214","214123214","414123212", ;
"212143214","412143212","214143212","212123414","412123412","214123412","212143412","412121234","214121234","414121232","212141234","412141232","214141232","212121434", ;
"412121432","214121432","212141432","432121214","234121214","434121212", ;
"232141214","432141212","234141212","232121414","432121412","234121412","232141412","232323212","232321232","232123232","212323232",Nil}
Static16:= "0123456789"
Static17:= "212"
Static18:= "12121"
Static19:= {"1112212","1122112","1121122","1222212","1211122","1221112","1212222","1222122","1221222","1112122"}
Static20:= {"1211222","1221122","1122122","1211112","1122212","1222112","1111212","1121112","1112112","1121222"}
Static21:= {"2221121","2211221","2212211","2111121","2122211","2112221","2121111","2111211","2112111","2221211"}
Static22:= {"AAAAAA","AABABB","AABBAB","AABBBA","ABAABB","ABBAAB","ABBBAA","ABABAB","ABABBA","ABBABA"}
Static23:= {"22442","42224","24224","44222","22424","42422","24422","22244","42242","24242",Nil}
Static24:= {"11331","31113","13113","33111","11313","31311","13311","11133","31131","13131",Nil}
//	Hb_GTInfo(HB_GTI_MOUSESTATUS, .f. )  // mouse off
//	HB_SETCODEPAGE('ES850C')
//    HB_CDPSELECT('ES850C')
//	HB_LANGSELECT('PT')
*--
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda
 \ Programa: ADRBIG.PRG
 \ Data....: 25-06-21
 \ Sistema.: Controle de Processos da Funer ria
 \ Funcao..: Gerenciador geral
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "ADRBIG.ch"    // inicializa constantes manifestas

/*
   Funcoes chamadas dentro de macros
*/

REQUEST DESCEND, MTAB, VUF, VDV2, DLAPSO, NMES, EXT, MMAA, VCGC, LTOC


#include "ADR_PUBL.ch"  // contem variaveis publicas

******
PUBLIC aGauge
PUBLIC aGauge_alias:="     ", aGauge_count:=0
******
V0=SAVESCREEN(0,0,MAXROW(),79)
CLEA SCREEN
VideoSeg=IF(CARDTYPE()=V_MONO,45056,-18432) // area de video

#ifdef COM_TUTOR
 PARAM arq_mac, acao_                        // recebe parametros
 acao_mac="D"                                // inicializa flag
 IF !EMPT(arq_mac) .AND. !EMPT(acao_)        // passou os dois paramentros
  acao_=UPPER(acao_)                         // acao em maiusculo
  IF SUBS(acao_,2,1)$'LGCA'.AND.LEN(acao_)=2 // acao e' valida?
   acao_=SUBS(acao_,2,1)                     // separa so a letra
   IF acao_ $ "LCA" .AND. !FILE(arq_mac)     // leitura, se o arq
    ALERTA(2)                                // nao existir vamos
    ? "Arquivo "+arq_mac+" n„o encontrado!"  // avisar e
    RETU                                     // voltar para os DOS
   ELSE
    IF acao_="G"                             // gravacao de tutorial
     IF FILE(arq_mac)                        // se o arq existir
      ALERTA(2)                              // pergunta se pode
      x="N"                                  // mata-lo...
      @ 10,20 SAY "Arquivo "+arq_mac+" j  existe sobrepor?" GET x PICT "!"
      READ
      CLEA SCREEN
      IF LASTKEY()=K_ESC .OR. x!="S"         // nao confirmou...
       ? "Execu‡„o interrompida!"            // da mensagem e
       RETU                                  // retorna para o DOS
      ENDI
      ERASE (arq_mac)                        // mata arq antigo
     ENDI
     handle_mac=FCREATE(arq_mac)             // cria um novo arq
    ELSE
     handle_mac=FOPEN(arq_mac,2)             // abre arq existente
    ENDI
    IF handle_mac=-1                         // se deu erro na abertura
     ? "N„o foi poss¡vel utilizar "+arq_mac  // avisa e
     RETU                                    // retorna
    ENDI
    fat_mac=5                                // fator de tempo default
    acao_mac=acao_                           // seta a acao da macro
   END IF
  END IF
 ENDI
#endi

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
IF EMPTY(direxe)             // CA-Clipper nao pegou diretorio do exe
 direxe=TRATADIR(QUALDIR())  // assume diretorio atual
ENDI
direxe=UPPER(LEFT(direxe,RAT("\",direxe)))
arq_sos=direxe+"ADRBIG.SOS"  // nome do arquivo de ajuda
SET CENTURY ON               // datas com informa‡„o do s‚culo DD/MM/AAAA
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
nss=032
exrot:=AFILL(ARRAY(nss),""); usuario:=obs_usuario:=senha:=senhatu:=msg_auto:=pw_grupo:=pw_codigo := ""
quer_sair:=.f.
datac=DATE()
nao_mostra:=l_s:=c_s:=c_i:=l_i := 0
tem_borda:=drvpvdbf:=drvexcl:=drvvisivel := .t.
lin_h:={}; col_h:={}; for_h:={}; tim_h:={}
v_out:=gr_rela:=ve_outros:=cn:=fgrep:=drvmouse:=drvpesq :=.f.
tem_t:=fgconf:=drvconf:=brw:=drvincl :=.f.
gcr=CHR(17)+CHR(217); nivelop=3
drvdbf:=drvntx:=drverr:=drvpw := TRATADIR(QUALDIR())
drvcara=CHR(178); mold="ÚÄ¿³ÙÄÀ³ÃÄ´"
drvmenucen=.t.; drvfonte=1
drvporta="LPT1"
drvcortna="GR/N"; drvtittna="W/N"
nemp="Presserv Informatica-(19)99886.3225"
nsis="Controle de Processos da Funer ria"

#ifdef COM_MOUSE
 drvmouse=(MOUSE()>0)                   // verifica e inicializa mouse

 #ifdef COM_TUTOR
  IF acao_mac!="D"
   drvmouse=.f.
  ENDI
 #endi

 drvratH=8; drvratV=16                  // default da sensibilidade do mouse
 tpo_mouse=0
#endi

#ifdef COM_LOCK
 pr_ok=__PPRJ(arq_sos,"ùÿãóæçüüâôççúøåýâæýû")
 IF LEN(pr_ok)>0
  CLEAR
  ? pr_ok
  RETU
 ENDI
#endi

#ifdef COM_REDE
 ms_uso="Arquivo sendo acessado|COM EXCLUSIVIDADE"
#endi

arqgeral="ADR"  // corrigido???

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
#else
 ide_maq="_temp"                   // nome do arquivo de configuracoes
#endi


/*
   verifica qual subscricao do vetor SISTEMA corresponde ao arquivo
   aberto na area selecionada
*/
qualsis={|db_f|db_:=UPPE(db_f),ASCAN(sistema,{|si|si[O_ARQUI,O_NOME]==db_})}
AFILL(sistema:=ARRAY(nss),{})      // enche sistema[] com vetores nulos
ADR_ATRI()                         // enche sistema[] com atributos dos arquivos
ADR_ATR1()
ADR_ATR2()
//ADR_ATR3()
//ADR_ATR4()
//ADR_ATR5()
arqconf=direxe+arqgeral+;          // nome do arquivo de configuracoes
        ide_maq+".sys"
IF FILE(arqconf)
 REST FROM (arqconf) ADDI          // restaura configuracoes gravadas
******
ntxpw=drverr+arqgeral+"PW"
dbfpw=ntxpw+".SYS"                 // nomes dos arquivos de senhas
******

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
 drvmarca := "Padr„o IBM"                     // nome da configuracao/marca impressora
 drvprn =1                                    // configuracao atual
 drvpadrao="1"                                // padrao da impressora
 drvtapg="CHR(27)+'C'+CHR(NNN)"               // tamanho da pagina
 drvpcom="CHR(15)"                            // ativa comprimido (17,5 cpp)
 drvtcom="CHR(18)"                            // desativa comprimido (17,5 cpp)
 drvpc20="CHR(30)+'5'"                        // ativa comprimido (20 cpp)
 drvtc20="CHR(30)+'0'"                        // desativa comprimido (20 cpp)
 drvpeli="CHR(30)+'2'"                        // ativa elite
 drvteli="CHR(30)+'0'"                        // desativa elite
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
 drvcorpad="W+/RB"  ; drvcorbox="W+/B"        // cores default
 drvcormsg="W+/W"   ; drvcorenf="W+/R"
 drvcorget="W+/BG"  ; drvcortel="W+/B"
 drvcorhlp="GR+/GR" ; drvcortna="GR/N"
 drvtitpad="GR+/RB" ; drvtitbox="GR+/B"       // cores dos titulos default
 drvtitmsg="GR+/W"  ; drvtitenf="GR+/R"
 drvtitget="GR+/BG" ; drvtittel="GR+/B"
 drvtithlp="W+/GR"  ; drvtittna="W/N"
 CBC1()
 ALERTA()
 cod_sos=2
 IF !PEGADIR(.t.)                  // se nao informou diretorios de trabalho
  RESTSCREEN(0,0,MAXROW(),79,v0)   // restaura tela
  SETPOS(MAXROW()-1,1)             // cursor na penultima linha, coluna 1
  RETU                             // de volta ao DOS
 ENDI

 /*
    cria os arquivos de senha e o inicializa com o primeiro usuario
 */
 FOR i=nss-2 TO nss
  dbf=drvpw+sistema[i,O_ARQUI,O_NOME]          // nome do arquivo de (1=grupos,2=acessos e 3=usuarios)
  IF !FILE(dbf+".dbf")                         // nao existe arq de senha
   IF i=nss-2                                  // cria arq de grupos
    DBCREATE(dbf,{;
                   {"pw_grupo"  ,"C",  4, 0},; // codigo do grupo
                   {"pw_nogrupo","C", 15, 0};  // nome do grupo
                 };
    )
   ELSEIF i=nss-1                              // acessos dos arquivos
    DBCREATE(dbf,{;
                   {"pw_grupo"  ,"C",  4, 0},; // codigo do grupo
                   {"pw_dbf"    ,"C", 35, 0},; // titulo do dbf
                   {"pw_permis" ,"C", 20, 0},; // permissoes do dbf
                   {"flag_excl" ,"C",  1, 0};  // flag de integridade
                 };
    )
   ELSEIF i=nss                                // usuarios de cada grupo
    DBCREATE(dbf,{;
                   {"pw_grupo"  ,"C",  4, 0},; // codigo do grupo
                   {"pw_codigo" ,"C",  4, 0},; // codigo do usuario
                   {"pw_nome"   ,"C", 15, 0},; // nome do usuario
                   {"pw_nivel"  ,"C",  1, 0},; // nivel de acesso
                   {"pw_obs"    ,"C", 15, 0},; // observacao
                   {"pw_pass"   ,"C",  6, 0},; // senhas
                   {"flag_excl" ,"C",  1, 0};  // flag de integridade
                 };
    )
   ENDI

   #ifdef COM_REDE
    IF !USEARQ(dbf,.t.,5,1,.f.)            // se nao conseguiu abrir o dbf
     RETU                                  // cancela a operacao
    ENDI
   #else
    USEARQ(dbf,,,,.f.)                     // abre o arquivo
   #endi

   IF i=nss-2
    APPE BLAN                              // credencia usuario ficticio (1o. acesso)
    REPL pw_grupo WITH ENCRIPT("0001"),;   // grupo 1 - administrcao
         pw_nogrupo WITH ENCRIPT(PADR("ADMINISTRACAO",15))
   ELSEIF i=nss-1                          // acesso dos arquivos
    FOR j=1 TO nss-3                       // cadastra todos
     APPEND BLANK                          // com permissoes em branco (pode tudo)
     REPL pw_grupo WITH ENCRIPT("0001"),;
          pw_dbf WITH ENCRIPT(PADR(sistema[j,O_MENU],35)),;
          pw_permis WITH ENCRIPT(SPACE(20))

    NEXT
   ELSEIF i=nss                             // vamos criar o 1o. usuario
    APPEND BLANK                            // com o nome de supervisor
    REPL pw_grupo WITH ENCRIPT("0001"),;    // se senha FUN
         pw_codigo  WITH ENCRIPT("0001"),;
         pw_nome  WITH ENCRIPT(PADR("SUPERVISOR",15)),;
         pw_nivel WITH ENCRIPT("3"),;
         pw_obs WITH ENCRIPT(SPACE(15)),;
         pw_pass WITH PWORD(arqgeral)
   ENDI
   CLOS ALL
  ENDI
 NEXT
ENDI

arq_log=drvpw+"ADRBIG.LOG"   // nome do arquivo de log
ADR_ATRI()                                  // enche sistema[] com atributos dos arquivos
ADR_ATR1()
ADR_ATR2()
//ADR_ATR3()
//ADR_ATR4()
//ADR_ATR5()

#ifdef COM_TUTOR
 IF acao_mac!="D"
  drvmouse=.f.
 ENDI
#endi

#ifdef COM_PROTECAO

 /*
    protege arquivo de dados contra acesso dBase e muda para "read-only"
    vamos comentar este "code block" ...
 */
 protdbf={|fg|pt:=fg,;                             // torna a flag visivel no proximo "code block"
           tel_p:=SAVESCREEN(0,0,MAXROW(),79),;    // salva a tela
           DBOX("Um momento!",,,,NAO_APAGA),;      // mensagem ao usuario
           AEVAL(sistema,{|sis|;                   // executa o "code block" para cada
                           EDBF(sis[O_ARQUI,O_DIR_DBF]+;    // um dos arquivos do vetor sistema
                                sis[O_ARQUI,O_NOME],pt); // (se pt, desprotege; senao, protege)
                         };
           ),;
           RESTSCREEN(0,0,MAXROW(),79,tel_p);      // restaura a tela
         }

 EVAL(protdbf,.t.)                                 // desprotege DBFs
#endi


/*
   cria indices para os arquivos de senha se nao existir
*/
FOR i=nss-2 TO nss                     // corre os 3 arq de senhas
 dbf=drvpw+sistema[i,O_ARQUI,O_NOME]   // nome do arquivo
 IF FILE(dbf+".dbf")                   // arquivo existe
  FOR t=1 TO LEN(sistema[i,O_INDIC])   // recria todos os ntx do arquivo
   ntx=drvpw+sistema[i,O_INDIC,t]      // e este e' o nome do seu indice
   IF !FILE(ntx+EXTENSAO())                   // arquivo existe

    IF EMPTY(SELECT(sistema[i,O_ARQUI,O_NOME]))  // o arquivo nao esta' em uso, vamos abri-lo...

     #ifdef COM_REDE
      IF !USEARQ(dbf,.t.,5,1,.f.)         // se nao conseguiu abrir o dbf

       #ifdef COM_PROTECAO
        EVAL(protdbf,.f.)                 // protege DBFs
       #endi

       RETU                               // cancela a operacao
      ENDI
     #else
      USEARQ(dbf,,,,.f.)                  // abre o arquivo
     #endi

    ENDI
    ntxtag:=dbf
    tagname:=sistema[i,O_INDIC,t]
    chvind=sistema[i,O_CHAVE,t]         // chave de indexacao
    INDE ON &chvind. TAG (tagname) TO (ntxtag)
   ENDI
  NEXT
  CLOS ALL
 ENDI
NEXT

arq_prn=drverr+"PRINTERS.DBF"            // nome dbf de "drivers" da prn
IF !FILE(arq_prn)                        // se o arquivo de "drivers"
 DBCREATE(arq_prn,{;                     // de impressoras nao existir
                   {"marca" ,"C",15,0},; // entao vamos cria-lo
                   {"porta" ,"C", 4,0},;
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
                  };
 )

 #ifdef COM_REDE
  USEARQ(arq_prn,.t.,20,1,.f.)      // tenta abrir configuracoes, exclusivo
 #else
  USE (arq_prn)                     // abre arquivo de configuracoes
 #endi

 APPE BLAN                          // inclui uma configuracao
 REPL marca  WITH drvmarca,;        // marca da impressora
      porta  WITH drvporta,;        // porta de saida
      padrao WITH drvpadrao,;       // padrao da impressora
      tapg   WITH drvtapg,;         // tamanho da pagina
      pcom   WITH drvpcom,;         // ativa comprimido (17,5 cpp)
      tcom   WITH drvtcom,;         // desativa comprimido (17,5 cpp)
      pc20   WITH drvpc20,;         // ativa comprimido (20 cpp)
      tc20   WITH drvtc20,;         // desativa comprimido (20 cpp)
      peli   WITH drvpeli,;         // ativa elite
      teli   WITH drvteli,;         // desativa elite
      penf   WITH drvpenf,;         // ativa enfatizado
      tenf   WITH drvtenf,;         // desativa enfatizado
      pexp   WITH drvpexp,;         // ativa expansao
      texp   WITH drvtexp,;         // desativa expansao
      pde8   WITH drvpde8,;         // ativa 8 lpp
      tde8   WITH drvtde8,;         // desativa 8 lpp
      land   WITH drvland,;         // ativa landscape
      port   WITH drvport           // ativa portrait
 USE
ENDI
MUDAFONTE(drvfonte)                 // troca a fonte de caracteres
corcampo=drvtittel                  // cor "unselected"
SETCOLOR(drvcorpad+","+drvcorget+",,,"+corcampo)
SET(_SET_DELETED,!drvvisivel)       // visibilidade dos reg excluidos
CBC1()

/*
   se informado drive A para criar arquivo, previne preparo do disquete
*/
IF ASC(drvdbf)=65.OR.ASC(drvntx)=65 // informou drive A
 ALERTA()
 cod_sos=1
 op_a=DBOX("Disco pronto|Cancelar a opera‡„o",,,E_MENU,,"DISCO DE DADOS EM "+LEFT(drvdbf,1))
 IF op_a!=1

  #ifdef COM_PROTECAO
   EVAL(protdbf,.f.)                   // protege DBFs
  #endi

  RESTSCREEN(0,0,MAXROW(),79,v0)    // restaura tela
  SETPOS(MAXROW()-1,1)              // cursor na penultima linha, coluna 1
  RETU
 ENDI
ENDI

IF !PEGA_SENHA()                                   // recebe senha

 #ifdef COM_PROTECAO
  EVAL(protdbf,.f.)                                // protege DBFs
 #endi

 MUDAFONTE(0)                                      // retorna com a fonte normal
 RESTSCREEN(0,0,MAXROW(),79,v0)                    // restaura tela
 SETPOS(MAXROW()-1,1)                              // cursor na penultima linha, coluna 1
 RETU                                              // um estranho no ninho!
ENDI

IF !CRIADBF()                                      // se DBF nao criado,

 #ifdef COM_PROTECAO
  EVAL(protdbf,.f.)                                // protege DBF
 #endi

 MUDAFONTE(0)                                   // retorna com a fonte normal
 RESTSCREEN(0,0,MAXROW(),79,v0)                    // restaura tela
 SETPOS(MAXROW()-1,1)                              // cursor na penultima linha, coluna 1
 RETU                                              // volta ao DOS
ENDI
SET CONF (drvconf)                                 // ajusta SET CONFIRM
dbfparam="PAR_ADM"
SELE A

#ifdef COM_REDE
 USEARQ(dbfparam,.t.,,,.f.)
#else
 USEARQ(dbfparam)
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
SET KEY K_CTRL_INS TO VE_LOG()                     // ctrl+ins ve arquivo de log
_ag_data:=_ag_hora := ""
CBC1()

ADR_MENU()                                        // menu geral da aplicacao

#ifdef COM_PROTECAO
 EVAL(protdbf,.f.)                                 // protege DBF
#endi

#ifdef COM_TUTOR
 IF acao_mac!="D"
  FCLOSE(handle_mac)
  acao_mac="D"
 END IF
#endi

MUDAFONTE(0)                                    // retorna com a fonte normal
RESTSCREEN(0,0,MAXROW(),79,v0)                     // s'imbora
SETPOS(MAXROW()-1,1)                               // e cursor na penultima linha, coluna 1
RETU                                               // volta ao DOS

FUNC PEGA_SENHA()       // pega senha de acesso ao sistema
LOCAL ret_val:=.f., v1, t_f4_:=SETKEY(K_F4,{||FIM_PW()})

#ifdef COM_REDE
 IF !USEARQ(sistema[nss-1,O_ARQUI,O_NOME],.f.,20,1)// abre arquivo de senhas
  RETU .f.                                         // nao consegui cai fora...
 ENDI
#else
 USEARQ(sistema[nss-1,O_ARQUI,O_NOME])             // abre arq de acessos
#endi

#ifdef COM_REDE
 IF !USEARQ(sistema[nss,O_ARQUI,O_NOME],.f.,20,1)  // abre arq de usuarios
  RETU .f.                                         // se falhou cai fora...
 ENDI
#else
 USEARQ(sistema[nss,O_ARQUI,O_NOME])               // abre arq de usuarios
#endi

DBSETORDER(2)                                   // vamos usar o indice 2
cod_sos=15                                         // codigo do help
COLORSELECT(COR_GET)                               // poe cor de get na frente
v1=SAVESCREEN(0,0,MAXROW(),79)                     // salva tela e coloca tela de senha
DBOX(PADR(" Nome.:",25)+"|"+PADR(" Senha:",25)+"| F4 para finalizar|ESC para recome‡ar",9,25,,NAO_APAGA,"SENHA DE ACESSO")
cp_=1
usuario=SPACE(15)                                  // nome do usuario
DO WHIL .t.
 @ 12,36 GET usuario PICT "@!"                     // receve o nome
 READ
 IF quer_sair                                      // cancelou...
  EXIT
 ENDI
 IF LASTKEY()=K_ESC                                // recome‡a
  usuario=SPACE(15)                                // nome do usuario
  LOOP
 ENDI
 SETCOLOR(drvcorget)                               // coloca fundo
 @ 13,36 SAY SPAC(6)                               // da cor do get
 senha=PADR(PWORD(13,36),6)                        // recebe a senha do usuario
 SETCOLOR(drvcorbox)                               // volta para cor normal
 IF quer_sair                                      // cancelou...
  EXIT
 ENDI
 IF EMPTY(senha)                                   // senha em branco
  @ 13,36 SAY SPAC(6)
  LOOP                                             // cai fora
 ENDI
 SEEK ENCRIPT(usuario)+senha                       // ve se esta' credenciado
 IF FOUND()                                        // OK!
  usuario=TRIM(DECRIPT(pw_nome))                   // nome do usuario
  msg_auto="Opera‡„o n„o autorizada, "+usuario     // monta mensagem usuario
  obs_usuario=TRIM(DECRIPT(TRIM(pw_obs)))          // nome do usuario
  senhatu=senha                                    // sua senha
  nivelop=VAL(DECRIPT(pw_nivel))                   // seu nivel
  M->pw_codigo=DECRIPT(pw_codigo)                  // codigo do usuario
  M->pw_grupo =DECRIPT(pw_grupo)                   // codigo do grupo do usuario
  SELE PWTABELA
  FOR t=1 TO nss-3                                 // corre todos dbf's menos os 3 da senha
   SEEK ENCRIPT(M->pw_grupo)+ENCRIPT(PADR(sistema[t,O_MENU],35))
   IF FOUND()                                      // para cada arq vamos
    exrot[t]=DECRIPT(pw_permis)                    // colocar as permissoes
   ELSE
    exrot[t]=REPL("*",30)                          // arq nao localizado nao deixa fazer nada...
   ENDI
   IF sistema[t,O_OUTROS,O_NIVEL]>5 .AND.;         // usuario anterior nao
      sistema[t,O_OUTROS,O_NIVEL]<9                // podia usar talvez
    sistema[t,O_OUTROS,O_NIVEL]-=5                 // este possa...
   END IF
   IF LEN(ALLTRIM(exrot[t]))>=20                   // se nao pode fazer nada
    sistema[t,O_OUTROS,O_NIVEL]+=5                 // nao deixa nem consultar
   ENDI
  NEXT
  exrot[nss]="VNGA"                                // permissoes dos arquivos
  exrot[nss-1]=exrot[nss]+"EDR"                    // que controlam a senha
  exrot[nss-2]=exrot[nss]
  IF nivelop>0.AND.nivelop<4                       // de 1 a 3...
   DBOX("Bom trabalho, "+usuario,13,45,2)          // boas vindas!
   ret_val=.t.
   RESTSCREEN(0,0,MAXROW(),79,v1)
   EXIT                                            // use e abuse...
  ENDI
 ELSE
  IF cp_<2                                         // epa! senha invalida
   cp_++                                           // vamos dar outra chance
   ALERTA()                                        // estamos avisando!
   DBOX("Senha inv lida!",,,1)
   @ 13,36 SAY SPAC(6)
  ELSE                                             // errou duas vezes!
   ALERTA()                                        // pode ser um E.T.
   DBOX("Usu rio n„o autorizado!",,,2)

   #ifdef COM_PROTECAO
    EVAL(protdbf,.f.)                              // protege DBF
   #endi

   RESTSCREEN(0,0,MAXROW(),79,v0)                  // restaura tela,
   SETPOS(MAXROW()-1,1)                            // cursor na penultima linha, coluna 1
   MUDAFONTE(0)                                    // retorna com a fonte normal
   EXIT                                            // e tchau!
  ENDI
 ENDI
ENDD
SETKEY(K_F4,t_f4_)
CLOSE ALL
SETCOLOR(drvcorpad)                                // cor normal
RETU ret_val

PROC FIM_PW()
quer_sair=.t.
KEYB CHR(K_ESC)
RETU

* \\ Final de ADRBIG.PRG