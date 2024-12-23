procedure adr_outr
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_OUTR.PRG
 \ Data....: 23-07-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Define vari veis p£blicas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v2.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas


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
              {K_RIGHT,{||datac:=datac+365}},;
              {K_LEFT, {||datac:=datac-365}};
            }
 SETCOLOR(drvtitmsg)
 vr_cale=NOVAPOSI(@lisu_,@cosu_,@liin_,@coin_)      // posicao atual do calendario
 CAIXA(mold,lisu_,cosu_,liin_,coin_)                // monta tela de apresentacao
 SETCOLOR(drvcorenf)                                // do calendario
 @ lisu_+2,cosu_+1 SAY "Do 2a 3a 4a 5a 6a Sa"
 SETCOLOR(drvtitmsg)
 @ lisu_+ 9,cosu_+1 SAY REPL("Ä",coin_-cosu_-1)
 @ lisu_+10,cosu_+2 SAY " Incrementa o MES"        // montra teclas disponiveis
 @ lisu_+11,cosu_+2 SAY " Decrementa o MES"
 @ lisu_+12,cosu_+2 SAY CHR(26)+" Incrementa o ANO"
 @ lisu_+13,cosu_+2 SAY CHR(27)+" Decrementa o ANO"
 SETCOLOR(drvcormsg)
 DO WHIL .t.
  @ lisu_+1,cosu_+1 SAY PADL(TRIM(NMES(datac))+" - "+STR(YEAR(datac)),20)
  dia_1=DOW(datac-DAY(datac)+1)          // dia da semana do 1o. dia do mes
  cl_=lisu_+3
  @ cl_,cosu_+1 CLEAR TO liin_-6,coin_-1 // limpa area dos dias
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


* \\ Final de ADM_OUTR.PRG
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
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623.
 \ Programa: V00101F9.PRG
 \ Data....: 03-10-95
 \ Sistema.: Controle de Convˆnios
 \ Funcao..: Valida‡„o da variavel GNUMERO, relatorio CON_R001
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

func v00101f9
//PARAMETROS('pnumero',gnumero)

  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[GUI],[IMPPAR],1)
   ord_=LEN(sistema[EVAL(qualsis,"IMPPAR"),O_CHAVE])
   FAZ_LANC("IMPPAR",[ ])
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
	IMPPAR->base WITH [GUI]
  ENDI
   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

   IF PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[GUI],[IMPPAR],1)
    REPBLO('IMPPAR->docto',{||gnumero})
   ENDI

RETU .T.      // <- deve retornar um valor L¢GICO

* \\ Final de V00101F9.PRG


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
 SEEK M->mcod       // Verifica todas as taxas do contrato
ENDI
SELE TAXAS
DO WHILE !EOF() .AND. TAXAS->codigo+TAXAS->tipo+TAXAS->circ=M->Mcod //.AND.ct_tx < M->rpend
 IF TAXAS->valorpg>0    // Das pagas, compara vencto e pgto.
  IF (pgto_ - emissao_) >= v_intervalo     // se atrasou nn dias,
	 dt_ultpg:=TAXAS->pgto_                  // guarda data pgto.
   dt_fimcar:=TAXAS->pgto_ + dias_carencia // calcula fim carencia
   IF DATE() < dt_fimcar                   // compara com data atual
    esta_em:=.T.                           // se carencia maior q data = carencia
   ENDI
  ELSE  // se nao atrasou (ou intervalo for menor q carencia)
   IF (pgto_ >= dt_fimcar)     // Se pagou depois do fim de carencia, tira-o
    esta_em:=.F.
   ENDI
  ENDI
 ELSE    // Se ainda num foi paga
  IF (date() - emissao_) >= v_intervalo // e ja venceu alem do intervalo...
   vai_entrar:=.T.                     // entra em suspenso...
  ENDI
 ENDI
 SKIP
ENDDO
IF DATE() > dt_fimcar   // mas, se ja passou a data final de carencia...
 esta_em:=.F.           // sai da carencia (ja cumpriu...)
ENDI
//POINTER_DBF(reg_dbf)
sele (i_)
go (rec_dbf)
IF (esta_em)
 RETU 2      // Pagou e esta na Carencia,
ELSEIF (vai_entrar)
 RETU 1      // num pagou, esta suspenso...
ENDI
RETU 0 //(esta_em.OR.vai_entrar)       // <- deve retornar um valor L¢GICO


//020760835
//Cancelamento e reintegra‡ao, verificar os campos transferidos (COROAS)

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

function calc_idx()
return DTOS(DATE())+time()+M->usuario
