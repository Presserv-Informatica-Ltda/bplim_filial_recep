// <ADRBIG> - <ADR_>
procedure ADR_outr
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: ADR_OUTR.PRG
 \ Data....: 19-08-95
 \ Sistema.: Controle de Processos da Funer ria V.á
 \ Funcao..: Define vari veis p£blicas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v2.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "ADRBIG.ch"    // inicializa constantes manifestas


#ifdef COM_CALE
 PROC CALE      // Rotina para exibir calend rio

 /*
    Simplificando a estrutura CASE   (thank you Rick Spence!)
    tbc e' um vetor bidimensional que contem as teclas a serem testadas
    e suas respectivas acoes (dentro de "code blocks")
 */
 LOCAL cale_tela:=SAVESCREEN(0,0,MAXROW(),79), cor_atual:=SETCOLOR(),;
       col_dia, dia_1, lisu_:=6, cosu_:=58, liin_:=20, coin_:=79,;
       i_, cl_, vr_cale, m_e_s, a_n_o, ult_dia,;
       tbc:={;
              {K_DOWN, {||datac:=datac-30}},;
              {K_UP,   {||datac:=datac+30}},;
              {K_PGDN, {||datac:=datac-365}},;
              {K_PGUP, {||datac:=datac+365}},;
              {K_RIGHT,{||datac:=datac+1}},;
              {K_LEFT, {||datac:=datac-1}};
            }
 PRIVA datac:=datac
 SETCOLOR(drvtitmsg)
 vr_cale=NOVAPOSI(@lisu_,@cosu_,@liin_,@coin_)      // posicao atual do calendario
 CAIXA(mold,lisu_,cosu_,liin_,coin_)                // monta tela de apresentacao
 SETCOLOR(drvcorenf)                                // do calendario
 @ lisu_+2,cosu_+1 SAY "Do 2a 3a 4a 5a 6a Sa"
 SETCOLOR(drvtitmsg)
 @ lisu_+ 9,cosu_+1 SAY REPL("Ä",coin_-cosu_-1)
 @ lisu_+10,cosu_+2 SAY " Incrementa o mˆs"        // montra teclas disponiveis
 @ lisu_+11,cosu_+2 SAY " Decrementa o mˆs"
 @ lisu_+12,cosu_+2 SAY CHR(26)+" Incrementa o dia"
 @ lisu_+13,cosu_+2 SAY CHR(27)+" Decrementa o dia"
 @ lisu_+14,cosu_+2 SAY CHR(30)+" Incrementa o ano"
 @ lisu_+15,cosu_+2 SAY CHR(31)+" Decrementa o ano"
 SETCOLOR(drvcormsg)
 DO WHIL .t.
  @ lisu_+1,cosu_+1 SAY PADL(TRIM(NMES(datac))+" - "+STR(YEAR(datac)),20)
  dia_1=DOW(datac-DAY(datac)+1)          // dia da semana do 1o. dia do mes
  cl_=lisu_+3
  @ cl_,cosu_+1 CLEAR TO liin_-8,coin_-1 // limpa area dos dias
  col_dia=1+cosu_+3*(dia_1-1)            // coluna inicai do 1o. dia do mes
  m_e_s=MONTH(datac)                     // mes
  a_n_o=YEAR(datac)                      // ano
  IF INT(m_e_s/2) = m_e_s/2              // acha ultimo dia do mes
   ult_dia=IF(m_e_s<8,IF(m_e_s=2,IF(INT(a_n_o/4)=a_n_o/4,29,28),30),31)
  ELSE
   ult_dia=IF(m_e_s<8,31,30)
  ENDI
  FOR i_=1 TO ult_dia                    // imprime os dias
   IF DAY(DATE())=i_                     // se for heje
    SETCOLOR(drvcorenf)                  // enfatiza
   ENDI
   @ cl_,col_dia SAY PADL(STR(i_,2),2)   // imprime o dia na tela
   SETCOLOR(drvcormsg)                   // retorna a cor normal
   col_dia+=3                            // proxima coluna
   IF dia_1/7=INT(dia_1/7)               // fim da tela do calendario
    cl_++ ; col_dia=cosu_+1              // passa para proxima linha
   ENDI
   dia_1++                               // proximo dia
  NEXT
  x=SETCURSOR(0)                         // apaga cursor, x=cursor atual

  #ifdef COM_MOUSE
   k=MOUSETECLA(lisu_+10,cosu_+2,liin_-1,cosu_+2)
  #else
   k=INKEY(0)                            // aguarda pressionar tecla
  #endi

  SETCURSOR(x)                           // volta tamanho original do cursor
  nm=ASCAN(tbc,{|ve_a| k=ve_a[1]})       // procura tecla dentro do vetor tbc (e' o CASE)
  IF nm!=0                               // achou!
   EVAL(tbc[nm,2])                       // portanto, executa a acao...
  ELSE
   IF k=K_ALT_F8                         // muda calendario de posicao
    MUDA_PJ(@lisu_,@cosu_,@liin_,@coin_,cale_tela,.t.)
    sinal_=" "
    PUBL &vr_cale.:=STR(lisu_,2)+STR(cosu_,2)
    SAVE TO (arqconf) ALL LIKE drv*      // salva as coordenadas em disco
   ELSE                                  // tecla sem acao, portanto,

    #ifdef COM_MOUSE
     MOUSEGET(@li_,@co_)                 // pega coordenadas do mouse
     x=""                                // pega o dia clicado
     FOR i=co_-1 TO co_+1
      x+=CHR(PEEK(-18432,(li_*160)+(i*2)))
     NEXT
     x=ALLTRIM(x)
     IF AT(" ",x)=0 .AND. VAL(x)>0       // dia valido, muda a data
      datac=CTOD(RIGHT(STR(100+VAL(x)),2)+"/"+RIGHT(STR(100+m_e_s),2)+"/"+RIGHT(STR(10000+a_n_o),4))
      k=K_ENTER
     ENDI
    #endi

    IF k=K_ENTER .AND. LEN(READVAR())>0  // enter captura data...
     KEYB DTOC(datac)
    ENDI
    EXIT                                 // fora...
   ENDI
  ENDI
 ENDD
 RESTSCREEN(0,0,MAXROW(),79,cale_tela)   // restaura tela e
 SETCOLOR(cor_atual)                     // o esquema de cor

 #ifdef COM_MOUSE
  IF drvmouse                            // se o mouse esta' ativo
   DO WHIL MOUSEGET(0,0)!=0              // espera que os botoes sejam
   ENDD                                  // liberados (nao pressionados)
  ENDI
 #endi

 SETCURSOR(curx)                         // volta tamanho original do cursor
 RETU
#endi


#ifdef COM_MAQCALC
 PROC MAQCALC      // Apresenta "pop-calculadora"
 LOCAL tela_c:=SAVESCREEN(0,0,MAXROW(),79), cur_sor:=SETCURSOR(1),;
       getlist:={}, vr_calc, pg_up, pg_dn, tec_f3, tec_f4, tec_f9, tec_f8
 PRIV  sinal_:=" ", num_disp, fgpaste, cor_calc:=SETCOLOR(),;
       lisu_:=1, cosu_:=40, liin_:=9, coin_:=64, sinal_ant:=" "
 vr_calc=NOVAPOSI(@lisu_,@cosu_,@liin_,@coin_) // pega posicao atual da calculadora
 fgpaste=(!EMPT(READVAR()).AND.;   // ve se ha campo pendente (captura)
         LEFT(READVAR(),4)!="OPC_")
 SETKEY(K_F6,NIL)                  // evita recursividade
 pg_up =SETKEY(K_PGUP,NIL)         // desabilita PgUp,
 pg_dn =SETKEY(K_PGDN,NIL)         // PgDn,
 tec_f3=SETKEY(K_F3,NIL)           // F3,
 tec_f4=SETKEY(K_F4,NIL)           // F4,
 tec_f9=SETKEY(K_F9,NIL)           // F9 e move caixa ( ALT-F8 )
 tec_f8=SETKEY(K_ALT_F8,{||sinal_dig()})

 SETKEY(35 ,{||sinal_dig()})       // #   raiz quadrada
 SETKEY(36 ,{||sinal_dig()})       // $   inteiro/flutuante
 SETKEY(37 ,{||sinal_dig()})       // %   percentual
 SETKEY(42 ,{||sinal_dig()})       // *   multiplica
 SETKEY(43 ,{||sinal_dig()})       // +   soma
 SETKEY(45 ,{||sinal_dig()})       // -   subtrai
 SETKEY(47 ,{||sinal_dig()})       // /   divide
 SETKEY(61 ,{||sinal_dig()})       // =   total
 SETKEY(94 ,{||sinal_dig()})       // ^   exponencial
 SETKEY(99 ,{||sinal_dig()})       // c   limpa display
 SETKEY(67 ,{||sinal_dig()})       // C
 IF fgpaste
  SETKEY(82 ,{||sinal_dig()})      // R   captura resultado do display
  SETKEY(114,{||sinal_dig()})      // r
 ENDI
 SETCOLOR(drvcormsg)
 CAIXA(mold,lisu_,cosu_,liin_,coin_)
 @ lisu_+1,cosu_+2 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
 @ lisu_+2,cosu_+2 SAY "³                   ³"
 @ lisu_+3,cosu_+2 SAY "³                   ³"
 @ lisu_+4,cosu_+2 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
 @ lisu_+5,cosu_+2 SAY " 7 8 9 C     +  -  * "
 @ lisu_+6,cosu_+2 SAY " 4 5 6 .  =  /  %  ^ "
 @ lisu_+7,cosu_+2 SAY " 1 2 3 0     "+CHR(K_ESC)+"  #  $ "
 SETCOLOR(drvcorget)
 @ lisu_+8,cosu_+2 SAY IF(fgpaste,"R, resultado no campo","")
 SETCOLOR(drvcorget+","+drvcorget+",,,"+drvcorget)
 DO WHIL .t.
  gab=IF(fgint,"   999999999999999",;     // mascara
               "999999999999999.99")
  num_disp=0.00                           // numero no display
  @ lisu_+2,cosu_+3 SAY "="
  @ lisu_+2,cosu_+4 GET nu_calc PICT gab  // mostra total
  CLEAR GETS
  @ lisu_+3,cosu_+3 SAY sinal_ant
  @ lisu_+3,cosu_+4 GET num_disp PICT gab // capta operando
  READ
  IF sinal_="%" .AND. num_disp<>0 .AND. nu_calc<>0  // opera o %
   num_disp = nu_calc/100*num_disp                  // antes de prosseguir
   sinal_="="
  ENDI
  DO CASE
   CASE LASTKEY()=K_ESC.OR.sinal_="R"     // finalizou
    IF fgpaste.AND.sinal_="R"
     KEYB ALLTRIM(TRAN(nu_calc,gab))      // joga resultado no campo
    ENDI
    EXIT                                  // e sai
   CASE sinal_="AF8"                      // muda calculadora de posicao
    MUDA_PJ(@lisu_,@cosu_,@liin_,@coin_,tela_c,.t.)
    sinal_=" "
    PUBL &vr_calc.:=STR(lisu_,2)+STR(cosu_,2)
    SAVE TO (arqconf) ALL LIKE drv*       // salva as coordenadas em disco
   CASE sinal_="$"                        // chaveou inteiro/decimal
    fgint=(!fgint); sinal_=" "
   CASE sinal_="C"                        // limpa display
    nu_calc=0; sinal_=" "
   CASE sinal_="#"                        // raiz quadrada
    IF !EMPTY(num_disp)                   // algum numero no display?
     IF sinal_ant="-"                     // op anterior=subtracao?
      nu_calc-=SQRT(num_disp)             // subtrai a raiz
     ELSE                                 // do display no resultado
      nu_calc+=SQRT(num_disp)             // senao, soma
     ENDI
    ELSE                                  // nao exite numero no
     nu_calc=SQRT(nu_calc)                // display, porisso
    ENDI                                  // calcula raiz do total
    sinal_=" "
   OTHERWISE
    DO CASE
     CASE sinal_ant="-"                   // subtrai
      nu_calc-=num_disp
     CASE sinal_ant="*"                   // multiplica
      nu_calc=nu_calc*num_disp
     CASE sinal_ant="/"                   // divide
      nu_calc=nu_calc/num_disp
     CASE sinal_ant="^"                   // eleva potencia
      nu_calc=nu_calc^num_disp
     CASE sinal_ant="%"                   // obtem percentual
      nu_calc=nu_calc/100*num_disp
     OTHERWISE                            // soma (+) ou sem operador
      nu_calc+=num_disp
   ENDC
  ENDC
  sinal_=IF(sinal_="="," ",sinal_)        // igual nao pode ser exibido
  sinal_ant=sinal_; sinal_=" "            // salva sinal digitado
 ENDD
 SETCOLOR(cor_calc)                       // volta com as cores anteriores
 SETCURSOR(cur_sor)                       // volta cursor com era antes
 SET KEY K_F6 TO maqcalc                  // reabilita calculadora (f6)
 SETKEY(35,NIL); SETKEY(36,NIL)           // desabilita as teclas
 SETKEY(37,NIL); SETKEY(42,NIL)           // utilizadas na operacao
 SETKEY(43,NIL); SETKEY(45,NIL)           // da calculadora
 SETKEY(47,NIL); SETKEY(67,NIL)
 SETKEY(94,NIL); SETKEY(99,NIL)
 SETKEY(82,NIL); SETKEY(114,NIL)
 SETKEY(61,NIL)
 SETKEY(K_PGUP,pg_up)                     // habilita teclas PgUp,
 SETKEY(K_PGDN,pg_dn)                     // PgDn,
 SETKEY(K_F3,tec_f3)                      // F3,
 SETKEY(K_F4,tec_f4)                      // F4,
 SETKEY(K_F9,tec_f9)                      // F9 e
 SETKEY(K_ALT_F8,tec_f8)                  // ALT-F8
 RESTSCREEN(0,0,MAXROW(),79,tela_c)       // restaura a tela
 RETU

 STATIC PROC SINAL_DIG  // Recebe sinal da calculadora
 sinal_=IF(LASTKEY()=K_ALT_F8,"AF8",;     // recebe sinal digitado e
        UPPER(CHR(LASTKEY())))            // forca saida do get com
 KEYB CHR(K_ENTER)                        // ENTER simulado
 RETU
#endi

* \\ Final de ADR_OUTR.PRG
func extcivil
para est_civ,se_xo
if pcount()<2
 se_xo=[M]
endi
auxpos=AT(est_civ,tbestcivx) //tbestcivx:=[SO,CA,VI,DI,SE,IG,JU,CO,S.]
auxpos=INT(auxpos/3)+1
RETU IIF(se_xo=[M],tbestcivmx[auxpos],tbestcivfx[auxpos])

FUNC CALC_IDX
RETUR DTOS(DATE())+LEFT(TIME(),5)+M->USUARIO

func pulames
para _data_, _nrmes_
if pcount() < 2
 _nrmes_:=1
elseif pcount()<1
 _nrmes_:=1
 _data_:=date()
endi
_nrmes_=val(tran(_nrmes_,[999]))
sinal_:=iif(_nrmes_ < 0 ,-1 ,1)
_nrmes_:=abs(_nrmes_)
mes_:=(year(_data_)*12) + month(_data_)+(_nrmes_*sinal_)
ano_:=int(mes_/12)
mes_:=strzero(((mes_/12)-int(mes_/12))*12,2)
if mes_=[00]
 mes_=[12]
 ano_--
endi
ano_=strzero(ano_,4)
retu ctod(tran(strzero(day(_data_),2)+[/]+mes_+[/]+ano_,"@D"))


func V_carencia
para v_intervalo,dias_carencia
/*
Funcao criada para verificar a carencia dos contratos MA e MB.
 entra em carencia de [dias_carencia] depois de paga parcela com
[v_intervalo] de dias em atraso.
-limpar detalhes e deixar so 25 dias de pagas;
-o contrato q aparecer com mais de 70 dias em aberto, direito suspenso;
-taxas mais de 70 dias de vencidas e paga a menos de 25 dia (carencia);
*/
LOCAL dt_tx:=ctod(''),donex:=[] //,reg_dbf:=POINTER_DBF()
rec_dbf:=RECNO()                // inicializa vetor de retorno
i_=SELECT()                     // salva area atual
Mcod=GRUPOS->codigo
vai_entrar:=esta_em:=.F.
dt_fimcar:=dt_ultpg:=ctod([])
IF EMPTY(SELECT([TAXAS]))                      // o arquivo nao esta' em uso, vamos abri-lo...
 PTAB(Mcod,[TAXAS],1,.T.)
 SELE TAXAS
ELSE
 SELE TAXAS
 SEEK M->mcod
ENDI
SELE TAXAS
DO WHILE !EOF() .AND. TAXAS->codigo+TAXAS->tipo+TAXAS->circ=M->Mcod //.AND.ct_tx < M->rpend
 IF TAXAS->valorpg>0
  IF (pgto_ - emissao_) >= v_intervalo
	 dt_ultpg:=TAXAS->pgto_
   dt_fimcar:=TAXAS->pgto_ + dias_carencia
   IF DATE() < dt_fimcar
    esta_em:=.T.
   ENDI
  ELSE
   IF (pgto_ >= dt_fimcar)
    esta_em:=.F.
   ENDI
  ENDI
 ELSE
  IF (date() - emissao_) > v_intervalo
   vai_entrar:=.T.
  ENDI
 ENDI
 SKIP
ENDDO
IF DATE() > dt_fimcar
 esta_em:=.F.
ENDI
//POINTER_DBF(reg_dbf)
sele (i_)
go (rec_dbf)
IF (esta_em)
 RETU 2
ELSEIF (vai_entrar)
 RETU 1
ENDI
RETU 0 //(esta_em.OR.vai_entrar)       // <- deve retornar um valor L¢GICO

FUNC MONTA_MENS
PARA arq_texto
arqtexto:=drvdbf+arq_texto
arqorig:=linhax:=textook:=restolin:=[]
IF FILE(arqtexto)
 arqorig:=memoread(arqtexto)
 FOR aclinha=1 to mlcount(arqorig,70)
  linhax=memoline(arqorig,70,aclinha)+[ ]
  posmacro=at([&],linhax)

  DO WHILE !EMPT(posmacro)
   campomac:=SUBSTR(linhax,posmacro+1,AT([ ],SUBSTR(linhax,posmacro+1))-1)
   restolin:=SUBSTR(linhax,posmacro+LEN(campomac)+1)
//   linhax:=LEFT(linhax,posmacro-1)+alltrim(TRAN(&campomac,"@!"))+restolin
   linhax:=LEFT(linhax,posmacro-1)+ALLTRIM(TRAN(&campomac,[@!]))+restolin
   posmacro=at([&],linhax)
  ENDD
  textook+=linhax
 NEXT aclinha
ELSE
// textook:=[Pelo presente, eu ]+ALLTRIM(DECLAR->declarante)+[ representante legal do(a) falecido(a) ]+ALLTRIM(CADPROC->falecido)+[ ap¢s obter informa‡”es sobre o procedimento, solicito e autorizo ]+;
// [a realiza‡„o de cortes, perfura‡”es, quando necess rio, inje‡„o de l¡quidos e embalsamento, objetivando restaurar, conservar e manter a aparencia natural do corpo]
ENDI
RETU M->textook      // <- deve retornar um valor qualquer

Function XCRIPTOGRAFA(Pstr, Psenha, Pencript)
LOCAL Tcript, Tx, Tascii
LOCAL Tlensenha
Tlensenha = Len(AllTrim(Psenha))
      Tcript = ""
      For Tx = 1 To Len(Pstr)
          If Pencript           //&& Criptografa
             Tascii = Asc(Subs(Pstr, Tx, 1)) + ;
                       Asc(Subs(Psenha, ((Tx + 77) % Tlensenha) + 1, 1))
          Else                          && DesCriptografa
             Tascii = Asc(Subs(Pstr, Tx, 1)) - ;
                       Asc(Subs(Psenha, ((Tx + 77) % Tlensenha) + 1, 1))
          EndIf
          Tcript = Tcript + Chr(Tascii)
      Next
Return(Tcript)


function xencript(caracteres)
return xCRIPTOGRAFA(caracteres, 'bompastor', .t.)

function xdecript(caracteres)
return xCRIPTOGRAFA(caracteres, 'bompastor', .f.)

function Upperlower ( mTexto )
LOCAL mTexto2 := "", mMaiuscula := .T., nCont, mLetra
FOR nCont = 1 to Len (mTexto)
 mLetra := Substr( mTexto, nCont, 1 )
 DO CASE
 CASE mLetra = " "
  mTexto2 += mLetra
  mMaiuscula := .T.
 CASE mMaiuscula
  mTexto2 += Upper( mLetra )
  mMaiuscula := .F.
 OtherWise
  mTexto2 += Lower (mLetra )
 ENDCASE
Next
Return ALLTRIM(mTexto2)

function dayext ( ddata )
Retu ALLTRIM(STR(DAY(ddata)))+[ de ]+ALLTRIM(nmes(ddata))+[ de ]+LTRIM(STR(Year(ddata)))


Function TIRAAC(xArg1)

   Local xVar1:= "aeioucAEIOUC",xVar2:= " ‚¡¢£‡¡¢£€ÿ…Š•£‡¡¢£€ÿ„‰ÿ”‡Žÿÿ™š€ÿƒˆŒ“‡Žÿÿ™š€",xVar3:= "'`~^",xVar4,xVar5,xVar6,xVar7

   ts_:= Len(xArg1)
   If .t.
      For xVar7:= 1 To Len(xArg1)
         xVar5:= At(SubStr(xArg1,xVar7,1),xVar2)
         If (xVar5 > 0)
            If (SubStr(xArg1,xVar7,1) $ "€‡")
               xVar4:= IIf(SubStr(xArg1,xVar7,1) = "€","C","c")
            Else
               xVar4:= SubStr(xVar1,xVar5%13,1)
            EndIf
            xArg1:= Left(xArg1,xVar7-1)+xVar4+SubStr(xArg1,xVar7+1)
            xVar7:= xVar7+2
         EndIf
      Next
   EndIf
/*
   If chr(248) $ xArg1
    xArg1:= left(xArg1,At(chr(248),xArg1)-1)+[.]+subst(xArg1,At(chr(248),xArg1)+1)
   Endif
*/
 for ct_x=1 to len(xArg1)
  chr2 := substr(xArg1,ct_x,1)
  IF (chr2 $ [ABCDEFGHIJKLMNOPQRSTUVXYWZ 0123456789:,.-()])
//  ELSEIF (chr2 $ " ‚¡¢£‡¡¢£€ÿ…Š•£‡¡¢£€ÿ„‰ÿ”‡Žÿÿ™š€ÿƒˆŒ“‡Žÿÿ™š€.:,-()")
  ELSE
   xArg1:=left(xArg1,ct_x-1)+[.]+substr(xArg1,ct_x+1)
  ENDIF
 next ct_x

 Return xArg1
// transfere dados para excel
// Parametros: arquivo excel, linha inicial, coluna inicial, dados, condição
Function CopyToExcel
PARA xls_file, xls_row, xls_col, xls_dados, xls_condic
// Gera uma planilha Excel a partir de um DBF
//-----------------------------------------------------------------
oExcel:= TOleauto():New( "Excel.Application")
// Ole2TxtError()

if .F. //Ole2TxtError() # "S_OK"
 ?  "EXCEL não está instalado nesta máquina,Impossível gerar planilha"
 return nil
endif
xls_file:=drverr+xls_file
//oExcel:WorkBooks:Add()
if !file(xls_file)
 oExcel:WorkBooks:Add()
else
 oExcel:WorkBooks:Open(xls_file)
endi
oFolha := oExcel:Get( "ActiveSheet")
oFolha:Cells:Font:Name := "Arial"
oFolha:Cells:Font:Size := 10
xls_range:=CHR(xls_col+64)+ltrim(str(xls_row))+[:]
//xls_range:=CHR(xls_col+64+len(xls_dados [1]))+ltrim(str(len(xls_dados)))
xls_range+=[M90]

IF .T. //(xls_condic)
 oFolha:Range(xls_range):Value := xls_dados
ENDI

oExcel:Visible = .T.
use
RETURN NIL

FUNC QTNRDEP
PARA mcod,mtip
LOCAL ct_tx:=0 //, reg_dbf:=POINTER_DBF()
IF pcount()=0                //Se nao passou parametros
 mcod = codigo               // utiliza codigo atual e
 mtip=[8]                    // tipo = 8
ELSEIF PCOUNT()=1            // Se passou codigo,
 mtip=[8]                    // so tipo = 8
ENDI
AREAATU=SELECT()             // guarda area em uso
IF select([INSCRITS])=0       // se nao tiver inscritos aberto
 PTAB(Mcod,[INSCRITS],1,.T.) // abre-o
ENDI
SELE INSCRITS                // vamos contas os inscritos!
seek Mcod
DO WHILE !EOF() .AND. INSCRITS->codigo=Mcod //.AND.ct_tx < M->rpend
 IF INSCRITS->grau $ mtip//.OR.; // so dos tipos desejados!
//  (!EMPT(INSCRITS->nascto_).AND.INSCRITS->nascto_<(DATE()-365.25*30))
	ct_tx++
 ENDI
 SKIP
ENDDO
//POINTER_DBF(reg_dbf)
SELECT(AREAATU)              // retornando a area original

RETU ct_tx       // <- deve retornar um valor L¢GICO

FUNC QTNRDEp89
PARA mcod
LOCAL ct_tx:={0,0,0,0} //, reg_dbf:=POINTER_DBF()
AREAATU=SELECT()             // guarda area em uso
IF select([INSCRITS])=0       // se nao tiver inscritos aberto
 PTAB(Mcod,[INSCRITS],1,.T.) // abre-o
ENDI
SELE INSCRITS                // vamos contas os inscritos!
seek Mcod
DO WHILE !EOF() .AND. INSCRITS->codigo=Mcod //.AND.ct_tx < M->rpend
 IF !(INSCRITS->grau $ [89]) // conta os tipos 8 e 9
  SKIP
  LOOP
 ENDI
 IF INSCRITS->vivofalec=[F]
  SKIP
  LOOP
 ENDI
 Midade=UPPER(IIF(!EMPT(INSCRITS->nascto_),DLAPSO(DATE(),INSCRITS->nascto_),[ ]))
 WICHLINE:=0
 IF ([ANO]$Midade.AND.VAL(midade)>30)
  WICHLINE:=2
 ENDI
 IF INSCRITS->grau=[8]
  ct_tx [1+WICHLINE] ++
 ELSE
  ct_tx [2+WICHLINE] ++
 ENDIF
 SKIP
ENDDO
//POINTER_DBF(reg_dbf)
SELECT(AREAATU)              // retornando a area original

RETU ct_tx       // <- deve retornar um valor L¢GICO

func unico
para chave
set uniq on
retu (chave)

func agregados(mesaux) // "11/02"
IF !(GRUPOS->situacao=[1]).OR.GRUPOS->saitxa=[9999]
 retu .f.
ENDI
if pcount()<1
 mesaux:=substr(dtoc(date()),4)  // 13/02/2003
endi
dt1aux:=ctod([01/]+mesaux)       // 01/02/2003
mesaux:=substr(dtoc(dt1aux),4,2)+right(dtoc(dt1aux),2)
dt2aux:=dt1aux-5                // 27/01/2003
dt2aux-=day(dt2aux)             // 31/12/2002
dt1aux:=dt2aux-day(dt2aux)+1    // 01/12/2002

// Quantos dependentes cadastrados < 30 >
  nr_depend:=qtnrdep89(codigo)
  nr_depend8:=nr_depend [1]+nr_depend [2]
// J  calcula o valor dos agregados
//  vlagregado:=(nr_depend8*CLASSES->vldepend)+(nr_depend9*CLASSES->vltotal)

retu (GRUPOS->saitxa=mesaux.OR.(!EMPT(nr_depend8).AND.;
      GRUPOS->admissao>=dt1aux.AND.GRUPOS->admissao<=dt2aux))

func weekday
para dt_aux
dt_par=dt_aux
//Incluido em 14/01/2004 - nao imprimir cobran‡a com vencto sabados/domingos
IF DOW(M->dt_aux)=7
 M->dt_aux+=2
ELSEIF DOW(M->dt_aux)=1
 M->dt_aux+=1
ENDI
do while !(substr(dtoc(dt_par),4)=substr(dtoc(dt_aux),4))
 dt_aux:=dt_par
endd
retu M->dt_aux

// Funcao de calculo de Termino de Carencia
func mk_tcar
PARA dtinic_
if pcount()<1
 dtinic_=DATE()
endi
qtdatac:=0
msg="Dias de Car‰ncia"
qtdatac=DBOX(msg,,,,,"ATEN€ŽO!",qtdatac,"999")    // confirma o prazo de carencia
retu (dtinic_+qtdatac)

// Funcao para substituir macros em um arquivo texto pelo conteudo do campo
FUNC R01401F9
PARA ARQ_TEXTO
ARQ_TEXTO:=drvdbf+ARQ_TEXTO
arqorig:=linhax:=textook:=restolin:=[]
IF FILE(ARQ_TEXTO)
 arqorig:=memoread(ARQ_TEXTO)
 FOR aclinha=1 to mlcount(arqorig,70)
  linhax=memoline(arqorig,70,aclinha)+[ ]
  posmacro=at([&],linhax)

  DO WHILE !EMPT(posmacro)
   campomac:=SUBSTR(linhax,posmacro+1,AT([ ],SUBSTR(linhax,posmacro+1)))
   restolin:=SUBSTR(linhax,posmacro+LEN(campomac)+1)
//   restolin:=SUBSTR(linhax,AT([ ],SUBSTR(linhax,posmacro+2)))
   linhax:=LEFT(linhax,posmacro-1)+alltrim(TRAN(&campomac,"@!"))+;
           ALLTRIM(restolin)
   posmacro=at([&],linhax)
  ENDD
  textook+=linhax
 NEXT aclinha
ELSE
 textook:=[]
ENDI
RETU M->textook      // <- deve retornar um valor qualquer


func  vcobrador  // Retorna verdadeiro se o cobrador for lixo.
if (GRUPOS->cobrador$[C44,C5 ,ZZ ])
 retu .T.
elseif LEFT(GRUPOS->cobrador,2)=[CJ]
 retu .T.
elseif LEFT(GRUPOS->cobrador,2)=[AD]
 retu .T.
elseif LEFT(GRUPOS->cobrador,2)=[ZZ]
 retu .T.
endi
retu .F.

func vfatorvcto
para par_aux
IF ([/]$par_aux)
 retu ctod(par_aux) - ctod([07/10/1997])
ELSE
 RETU ctod([07/10/1997]) + VAL(par_aux)
ENDI
RETU []

FUNC QMES
PARA INIC_1, FIM_1
IF PCOUNT() < 1     // Se nao passou data nenhuma,
 RETU MONTH(DATE()) // retorna o mˆs atual
ENDI
IF PCOUNT() = 1  // Se informado apenas uma data,
 fim_1 = DATE()
ENDI
IF TYPE([inic_1]) = [C]
 inic_1:=CTOD(inic_1)
ENDIF
IF TYPE([fim_1]) = [C]
 fim_1 = CTOD(fim_1)
ENDI
donex:=(YEAR(fim_1)-YEAR(inic_1))*12
donex+=MONTH(fim_1)-MONTH(inic_1)
IF DAY(fim_1) < DAY(inic_1)
 donex--
ENDI
RETU donex //INT((fim_1-inic_1)/30.44)


FUNC ATUVALOR
PARA P_TIPO,P_VALOR,P_DAT1,P_DAT2 // tipo da cobranca, valor e vencimento
IF PCOUNT() < 4
 P_DAT2:=DATE()
ENDI
p_dat2++
v_add:=p_valor
IF p_dat1 < p_dat2                 // S¢ acerta os j  vencidos
 IF PTAB(p_tipo,'JUROS',1)         // S¢ acerta se houver na tabela de multa
  nrd:=(p_dat2 - p_dat1)           // Dias de atraso
  nrm:=QMES(p_dat1, p_dat2)        // Meses de atraso
	IF (nrd > JUROS->mltcaren)       // Se h  passou a carˆncia da multa...
	 v_add+=v_add * JUROS->multa/100 // Cobra multa
	ENDI
	IF (nrd > JUROS->jrscaren) // Se h  passou a carˆncia dos juros...
   IF PCOUNT() < 4 // Se nao for per¡odo fechado, conta os dias
	  v_add+=p_valor * (JUROS->juros/30) /100 * nrd  // Cobra juros
   ELSE   //  S¢ mˆs inteiro
	  v_add+=p_valor * JUROS->juros/100 * nrm  // Cobra juros
   ENDIF
	ENDI
 ENDI
ENDI
RETU (INT((v_add+0.005)*100)/100) // Retorna o valor total com o acrescimo

/*** Pendentes do VIP5
FUNC PENDENTES
PARA mcod,venf_
LOCAL ct_tx:=0 //,reg_dbf:=POINTER_DBF()
IF pcount()=0
 mcod = codigo
 venf_:=DATE()
ELSEIF PCOUNT()=1
 venf_:=DATE()
ENDI

nWorkArea:=SELECT()
//PTAB(Mcod,[TAXAS],1,.T.)
SELE TAXAS
SEEK Mcod

DO WHILE !EOF() .AND. TAXAS->codigo=Mcod //.AND.ct_tx < M->rpend
 IF TAXAS->valorpg>0
	SKIP
	LOOP
 ENDI
 IF TAXAS->emissao_ <= IIF(EMPT(M->venf_),DATE(),M->venf_)
	ct_tx++
 ENDI
 SKIP
ENDDO

//POINTER_DBF(reg_dbf)
SELECT(nWorkArea)
RETU ct_tx       // <- deve retornar um valor L¢GICO
********/

FUNC ULTIMATAXA
PARA mcod,mtipo
LOCAL dt_tx:=ctod('  /  /  ') //reg_dbf:=POINTER_DBF(),
rec_dbf:=RECNO()                // inicializa vetor de retorno
i_=SELECT()                     // salva area atual
IF pcount()=0
 mcod = codigo
 mtipo=[]
ELSEIF PCOUNT()=1
 mtipo=[  ]
ENDI
IF EMPTY(SELECT([TAXAS]))                      // o arquivo nao esta' em uso, vamos abri-lo...
 PTAB(Mcod,[TAXAS],1,.T.)
 SELE TAXAS
ELSE
 SELE TAXAS
 SEEK M->mcod
ENDI

DO WHILE !EOF() .AND. TAXAS->codigo+TAXAS->tipo+TAXAS->circ=M->Mcod //.AND.ct_tx < M->rpend
 IF TAXAS->emissao_ > dt_tx
    dt_tx:=TAXAS->emissao_
 ENDI
 SKIP
ENDDO

//POINTER_DBF(reg_dbf)
sele (i_)
go (rec_dbf)

RETU dt_tx       // <- deve retornar um valor L¢GICO

FUNC PENDENTES
PARA mcod,venf_
LOCAL  vl_tx:=ct_tx:=0 //, reg_dbf:=POINTER_DBF()
don_e:=[]
rec_dbf:=RECNO()                // inicializa vetor de retorno
i_=SELECT()                     // salva area atual
IF pcount()=0
 mcod :=codigo
 venf_:=DATE()
 don_e:=[Q]
ELSEIF PCOUNT()=1
 venf_:=DATE()
 IF mcod$[Qq,Vv,1,2]
  don_e:=UPPER(mcod)
  mcod:=codigo
 ENDI
ENDI
IF EMPTY(SELECT([TAXAS]))                      // o arquivo nao esta' em uso, vamos abri-lo...
 PTAB(Mcod,[TAXAS],1,.T.)
 SELE TAXAS
ELSE
 SELE TAXAS
 SEEK M->mcod
ENDI
DO WHILE !EOF() .AND. TAXAS->codigo+TAXAS->tipo=Mcod
 IF TAXAS->valorpg=0.AND.TAXAS->emissao_ <= M->venf_
	ct_tx++
  vl_tx+=TAXAS->valor
 ENDI
 SKIP
ENDDO
// POINTER_DBF(reg_dbf)
sele (i_)
go (rec_dbf)
IF DON_E$[V,2]
 ct_tx:=vl_tx
ENDI
RETU ct_tx       // <- deve retornar um valor L¢GICO

/* -------------------------------------------------------------------------- */
// Retorna Digito de Controle Modulo 11 (p/ Banco)                            //
// bradesco -> DC_Mod11("237", 7, .F., carteira+agencia+nossonumero)

FUNCTION DC_Mod11( mCDBC, mBSDG, mFGCB, mNMOG, lMult10 )

   LOCAL mSMMD, mCTDG, mSQMP, mRSDV, mDCMD
   mFGCB :=.F.
   lMult10:=.F.
   mSMMD := 0
   mSQMP := 2

   FOR mCTDG := 1 TO LEN(mNMOG)
       mSMMD += VAL(SUBSTR(mNMOG, LEN(mNMOG) - mCTDG + 1, 1)) * (mSQMP)
       mSQMP := IF(mSQMP == mBSDG, 2, mSQMP+1)
   NEXT
   IF lMult10
      mSMMD *= 10
   ENDIF
   mRSDV := MOD(mSMMD, 11)
   IF mFGCB
      mDCMD := IF(mRSDV > 9 .OR. mRSDV < 2, "1", STR(11 - mRSDV, 1))
   ELSE
      IF mCDBC == "001"        // Brasil
         mDCMD := IF(mRSDV == 0, "0", IF(mRSDV == 1, "X", STR(11 - mRSDV, 1)))
      ELSEIF mCDBC $ "(008|033|353)"  //Santander Banespa
         mDCMD := IF(mRSDV < 2, "0", IF(mRSDV == 10, "1", STR(11 - mRSDV, 1)))
       //mDCMD := IF(mRSDV == 0, "0", IF(mRSDV == 1, "X", STR(11 - mRSDV, 1)))
      ELSEIF mCDBC=="104"      // Caixa
         mRSDV := 11 - mRSDV
         mDCMD := IF(mRSDV > 9, "0", STR(mRSDV, 1))
      ELSEIF mCDBC == "237"    // Bradesco
         mDCMD := IF(mRSDV == 0, "0", IF(mRSDV == 1, "P", STR(11 - mRSDV, 1)))
      ELSEIF mCDBC == "341"    // Itau
         mDCMD := IF(mRSDV == 11, "1", STR(11 - mRSDV, 1))
      ELSEIF mCDBC == "409"    // Unibanco
         mDCMD := IF(mRSDV == 0 .OR. mRSDV == 10, "0", STR(mRSDV, 1))
      ELSEIF mCDBC == "422"    // Safra
         mDCMD := IF(mRSDV==0, "1", IF(mRSDV == 1, "0", STR(11 - mRSDV, 1)))
      ENDIF
   ENDIF
RETURN mDCMD

FUNC pre_remido // Plano
para codigo
IF SELE([ARQGRUP])=0
 PTAB(GRUPOS->grupo,[ARQGRUP],1,.T.)
ENDI
SELE ARQGRUP
SEEK GRUPOS->grupo
SELE GRUPOS
RETU (situacao=[1].AND.qtcircs=((funerais+1)*ARQGRUP->qtdremir)-1)

FUNC veinscrits(Vinscr)
vinscr:=[Inscritos n„o cadastrados]
vcod:=LEFT(codigo,10)
if PTAB(LEFT(codigo,10),'INSCRITS',1)
 reg_dbfx:=POINTER_DBF()
 SELE INSCRITS
 Vinscr:=[]
 DO WHILE !EOF() .AND. INSCRITS->codigo=vcod
  Vinscr+=INSCRITS->nome+[ (]+;
        SUBSTR([TitPaiMaeSgoSgaEspFilDep],(VAL(grau)-1)*3+1,3)+[) tc ]+;
        dtoc(tcarencia)+[ ]+vivofalec+[ ]+tipo+[|]
  SKIP
 ENDDO
 POINTER_DBF(reg_dbfx)
endi

retu  DBOX(Vinscr,,,E_MENU,,[INSCRITOS DO CONTRATO])
// op_cad=DBOX(Vinscr,,,E_MENU,,[INSCRITOS DO CONTRATO],,,op_cad)
