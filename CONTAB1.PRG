
procedure contab1
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADRBIG.PRG
 \ Data....: 29-06-98
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Gerenciador geral
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \ Convert.: v5.0 em 2021081014:57:47 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
***************************************
public cod_ret   := 0            // Codigo de retorno da funcao hlleprot
cod_ret := hlleprot( "BIGVIP",;            // Nome cadastrado no HPROT.EXE - opcao Define
     "ADMCONESTFINFUNVIA BIGVIP",;  // Chave de prote‡„o cadastrada no HPROT
     "",;                  // Diret¢rio da onde est  a prote‡„o da aplicacao
     1,;                   // Atualizar controle se for copia com limites
     1 )                   // Controlar Licen‡as de uso em rede nesta chamada
if cod_ret <> 0
 ? HLMSGERR()
 ?
// return
 if dtos(DATE()) > [20020820]
  return
 endi
endif
****************************************

#include "adrbig.ch"    // inicializa constantes manifestas

/*
   Funcoes chamadas dentro de macros
*/

REQUEST DESCEND, MTAB, VDV2, VUF, MMAA, DLAPSO, GDV1, VHORA, NMES, EXT, GDV2
REQUEST VCGC, LTOC

#include "ADR_PUBL.ch"  // contem variaveis publicas

V0=SAVESCREEN(0,0,MAXROW(),79)
CLEA SCREEN

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
nss=33
exrot:=AFILL(ARRAY(nss),""); usuario=""
datac=DATE()
nao_mostra:=l_s:=c_s:=c_i:=l_i := 0
tem_borda:=drvexcl:=drvvisivel := .t.
v_out:=gr_rela:=ve_outros:=cn:=fgrep:=drvmouse :=.f.
tem_t:=fgconf:=drvconf:=brw:=drvincl :=.f.
gcr=CHR(17)+CHR(217); nivelop=3
drvcara=CHR(250); mold="ÚÄ¿³ÙÄÀ³ÃÄ´"
drvmenucen=.f.; drvfonte=3
drvporta="LPT1"
drvcortna="W/N*"; drvtittna="BG+/N*"
nemp="PresServ Inform tica - Limeira (019)452.6623"
nsis="Administradora - RECEP€„O"

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

#ifdef COM_REDE
 ms_uso="Arquivo sendo acessado|COM EXCLUSIVIDADE"
#endi

#ifdef COM_LOCK
 pr_ok=__PPRJ(arq_sos,"ùÿäòäâûüäõáæñòë÷àêþú")
 IF LEN(pr_ok)>0
  CLEAR
  ? pr_ok
  RETU
 ENDI
#endi

arqgeral="CTB"

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

 ******
 ntxpw=drverr+arqgeral+"PW"
 dbfpw=ntxpw+".SYS"                 // nomes dos arquivos de senhas
 ******

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
 drvdbf:=drvntx:=drverr := PADR(QUALDIR(),23) // diretorio dos dbf's, ntx's e erros.dbf
 drvcorpad="W+/BG"  ; drvcorbox="W+/B"        // cores default
 drvcormsg="W+/W"   ; drvcorenf="W+/R"
 drvcorget="GR+/N*" ; drvcortel="W+/B"
 drvcorhlp="BG+/B"  ; drvcortna="W/N*"
 drvtitpad="GR+/BG" ; drvtitbox="GR+/B"       // cores dos titulos default
 drvtitmsg="GR+/W"  ; drvtitenf="GR+/R"
 drvtitget="R+/N*"  ; drvtittel="GR+/B"
 drvtithlp="GR+/B"  ; drvtittna="BG+/N*"
 drvultusu=LEFT(M->usuario,10)
 drvultval=0
 drvautent=.f.
 CBC1()
 ALERTA()
 cod_sos=2
 IF !PEGADIR(.t.)                  // se nao informou diretorios de trabalho
  RESTSCREEN(0,0,MAXROW(),79,v0)   // restaura tela
  SETPOS(MAXROW()-1,1)             // cursor na penultima linha, coluna 1
  RETU                             // de volta ao DOS
 ENDI
 ******
 ntxpw=drverr+arqgeral+"PW"
 dbfpw=ntxpw+".SYS"                 // nomes dos arquivos de senhas
 ******

 /*
    cria arquivo de senha e o inicializa com o primeiro usuario
 */
 IF !FILE(dbfpw)                    // nao encontrou arquivo de senhas,
  DBCREATE(dbfpw,{;                 // entao, cria estrutura
		  {"pass"       ,"C", 6,0},;
		  {"nome"       ,"C",15,0},;
		  {"nace"       ,"C", 1,0},;
		  {"exbxrec"    ,"C",20,0},;
			{"exalender"  ,"C",20,0},;
		  {"exobxec"    ,"C",20,0},;
		  {"exgrupos"   ,"C",20,0},;
		  {"extaxas"    ,"C",20,0},;
		  {"execob"     ,"C",20,0},;
		  {"exinscrits" ,"C",20,0},;
		  {"exguias"    ,"C",20,0},;
		  {"exafuner"   ,"C",20,0},;
		  {"extx2via"   ,"C",20,0},;
		  {"eximppar"   ,"C",20,0},;
		  {"exmedicos"  ,"C",20,0},;
		  {"extespec"   ,"C",20,0},;
		  {"exjuros"    ,"C",20,0},;
		  {"extfiliais" ,"C",20,0},;
		  {"exarqgrup"  ,"C",20,0},;
		  {"exfcgrupo"  ,"C",20,0},;
		  {"extxproc"   ,"C",20,0},;
		  {"exregiao"   ,"C",20,0},;
		  {"excobrador" ,"C",20,0},;
		  {"expcbrad"   ,"C",20,0},;
		  {"exfccob"    ,"C",20,0},;
		  {"exclasses"  ,"C",20,0},;
		  {"exclprods"  ,"C",20,0},;
		  {"excircular" ,"C",20,0},;
		  {"excprcirc"  ,"C",20,0},;
		  {"exprcessos" ,"C",20,0},;
		  {"exfncs"     ,"C",20,0},;
		  {"exhistoric" ,"C",20,0},;
		  {"excstseg"   ,"C",20,0},;
		  {"exmensag"   ,"C",20,0},;
		  {"exordpgrc"  ,"C",20,0},;
		  {"expar_adm"  ,"C",20,0};
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

#ifdef COM_TUTOR
 IF acao_mac!="D"
  drvmouse=.f.
 ENDI
#endi

arq_prn=drverr+"PRINTERS.DBF"            // nome dbf de "drivers" da prn
IF !FILE(arq_prn)                        // se o arquivo de "drivers"
 DBCREATE(arq_prn,{;                     // de impressoras nao existir
		   {"marca" ,"C",15,0},;  // entao vamos cria-lo
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
  RESTSCREEN(0,0,MAXROW(),79,v0)    // restaura tela
  SETPOS(MAXROW()-1,1)              // cursor na penultima linha, coluna 1
  RETU
 ENDI
ENDI
AFILL(sistema:=ARRAY(nss+1),{})     // enche sistema[] com vetores nulos
ADR_ATRI()                          // enche sistema[] com atributos dos arquivos
ADR_ATR1()
ADR_ATR2()

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

IF !FILE(ntxpw+".idx")                             // se nao ha indice,
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
@ 13,26 SAY "ESC para recome‡ar/finalizar"         // da senha de acesso
cp_=1
DO WHIL .t.
 COLORSELECT(COR_GET)
 senha=PADR(PWORD(12,36),6)                        // recebe a senha do usuario
 COLORSELECT(COR_PADRAO)
 SEEK senha                                        // ve se esta' credenciado
 IF FOUND()                                        // OK!
  usuario=TRIM(DECRIPT(nome))                      // nome do usuario
  senhatu=senha                                    // sua senha
  nivelop=VAL(DECRIPT(nace))                       // seu nivel
  FOR t=1 TO nss                                   // exrot[] contera' as
   msg=sistema[t,O_ARQUI,O_NOME]                          // rotinas nao acessadas
   exrot[t]=ex&msg.                                // de cada subsistema
  NEXT
  IF nivelop>0.AND.nivelop<4                       // de 1 a 3...
   DBOX("Bom trabalho, "+usuario,13,45,2)          // boas vindas!
   EXIT                                            // use e abuse...
  ENDI
 ELSE
  IF cp_<2 .AND. !EMPTY(senha)                     // epa! senha invalida
   cp_++                                           // vamos dar outra chance
   ALERTA()                                        // estamos avisando!
	 DBOX("Senha inv lida!",,,1)
   COLORSELECT(COR_GET)
   @ 12,36 SAY SPAC(6)
  ELSE                                             // errou duas vezes!
   IF !EMPTY(senha)                                // se informou senha errada
    ALERTA()                                       // pode ser um E.T.
    DBOX("Usu rio n„o autorizado!",,,2)
   ENDI

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

if adr_rx68()

 use f:\vip41\arquivos\bxrec
 ? " Fazendo c¢pia de seguranca"
 copy to f:\vip41\bxrold
 ? " Acrescentando arquivo temporario"
 appe from f:\vip41\bxrtmp
 set uniq on
 ? " Verificando as duplicidades"
 inde on ano+numero to bxrec
 copy to f:\vip41\bxrok
 use f:\vip41\bxrok
 ? " Reposicionando o arquivo correto"
 copy to f:\vip41\arquivos\bxrec
 ? " Procedimento de finaliza‡Æo"
endi

#ifndef COM_REDE
 EDBF(dbfpw,.f.)                                   // protege arquivo senhas
#endi

#ifdef COM_PROTECAO
 EVAL(protdbf,.f.)                                 // protege DBF
#endi

#ifdef COM_TUTOR
 IF acao_mac!="D"
  FCLOSE(handle_mac)
  acao_mac="D"
 END IF
#endi

RESTSCREEN(0,0,MAXROW(),79,v0)                     // s'imbora
SETPOS(MAXROW()-1,1)                               // e cursor na penultima linha, coluna 1
RETU                                               // volta ao DOS

* \\ Final de ADRBIG.PRG