/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADR_MENU.PRG
 \ Data....: 22-01-08
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Menu geral da aplica‡„o
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

opc_01=1
v01=SAVESCREEN(0,0,MAXROW(),79)
DO WHIL opc_01!=0
 cod_sos=3
 RESTSCREEN(0,0,MAXROW(),79,v01)
 menu01="Lan‡amentos~1|"+;
        "A.Funeral~2|"+;
        "Relat¢rios~3|"+;
        "Tabelas~4|"+;
        "Apoio~5"
 opc_01=DBOX(menu01,0,,E_POPMENU,NAO_APAGA,,,,opc_01)
 BEGIN SEQUENCE
  DO CASE
   CASE opc_01=0      // retornar ao DOS
    ALERTA()
    msgt="ENCERRAMENTO"
    msg ="Finalizar opera‡”es|N„o finalizar"
    cod_sos=1
    op_=DBOX(msg,,,E_MENU,,msgt,,,1)
    IF op_!=1
     opc_01=1
    ENDI

   CASE opc_01=1     // lan‡amentos
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     cod_sos=4
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Recebimentos~1|"+;
            "Endere‡os~2|"+;
            "Outros Recebimentos~3|"+;
            "Consulta Contratos~4|"+;
            "Emiss„o de Guias~5|"+;
            "Avisos / Carencias~6|"+;
            "Cartinha/Falecidos~7|"+;
            "Ajuda Procedimentos~8"
     msgt="LAN€AMENTOS"
     ROLAPOP(1)
     opc_02=DBOX(menu02,1,2,E_MENU,NAO_APAGA,msgt,,,opc_02)
     ROLAPOP()
     DO CASE
      CASE opc_02=1     // recebimentos
       BXREC(3,10)

      CASE opc_02=2     // endere‡os
       ALENDER(3,10)

      CASE opc_02=3     // outros recebimentos
       OBXEC(3,10)

      CASE opc_02=4     // consulta contratos
       GRUPOS(3,10)

      CASE opc_02=5     // emiss„o de guias
       GUIAS(3,10)

      CASE opc_02=6     // avisos / carencias
       MFILIAL(3,10)

      CASE opc_02=7     // Cartinha de Falecidos
       ADP_R101(3,10)

      CASE opc_02=8     // Ajuda aos Procedimentos
       ADR_MANU(3,10)

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
     menu02="Lan‡amento Aux.Funeral~1|"+;
            "Impress„o Modelo 1~2|"+;
            "Recibo Modelo 1~3|"+;
            "Impress„o Modelo 2~4|"+;
            "Recibo Modelo 2~5|"+;
            "Relat¢rio de Processo~6|"+;
            "Capa de Processo~7|"+;
            "Processar Pgto em~8"
     msgt="A.FUNERAL"
     ROLAPOP(1)
     opc_02=DBOX(menu02,1,15,E_MENU,NAO_APAGA,msgt,,,opc_02)
     ROLAPOP()
     DO CASE
      CASE opc_02=1     // lan‡amento aux.funeral
       AFUNER(3,23)

      CASE opc_02=2     // impress„o modelo 1
       ADM_R020(3,23)

      CASE opc_02=3     // recibo modelo 1
       ADR_R029(3,23)

      CASE opc_02=4     // impress„o modelo 2
       ADM_RX20(3,23)

      CASE opc_02=5     // recibo modelo 2
       ADR_RX29(3,23)

      CASE opc_02=6     // relat¢rio de processo
       ADM_R029(3,23)

      CASE opc_02=7     // capa de processo
       ADM_R026(3,23)

      CASE opc_02=8     // processar pgto em
       ADM_R021(3,23)

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
     menu02="Documento … Imprimir~1|"+;
            "Recibos (2¦via)~2|"+;
            "Outros recibos (2¦Via)~3|"+;
            "Endere‡os Alterados~4|"+;
            "Emissao de guia~5|"+;
            "Fechamento Caixa~6|"+;
            "Ficha de Acerto~7"
     msgt="RELAT¢RIOS"
     ROLAPOP(1)
     opc_02=DBOX(menu02,1,26,E_MENU,NAO_APAGA,msgt,,,opc_02)
     ROLAPOP()
     DO CASE
      CASE opc_02=1     // documento … imprimir
       DCI_P001(3,34)

      CASE opc_02=2     // recibos (2¦via)
       ADM_RS18(3,34)

      CASE opc_02=3     // outros recibos (2¦via)
       ADM_R023(3,34)

      CASE opc_02=4     // endere‡os alterados
       ADM_R022(3,34)

      CASE opc_02=5     // emissao de guia
       cod_sos=1
       CON_RX01(3,34)

      CASE opc_02=6     // fechamento caixa
       ADM_R039(3,34)

      CASE opc_02=7     // ficha de acerto
       ADC_RX76(3,34)

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
     menu02="Documento … Imprimir~1|"+;
            "Credenciados~2|"+;
            "Especialidades~3|"+;
            "Parƒmetro de Juros~4|"+;
            "Filiais~5|"+;
            "Grupos~6|"+;
            "Tabelas Secund rias~7|"+;
            "Caixas~8"
     msgt="TABELAS"
     ROLAPOP(1)
     opc_02=DBOX(menu02,1,38,E_MENU,NAO_APAGA,msgt,,,opc_02)
     ROLAPOP()
     DO CASE
      CASE opc_02=1     // documento … imprimir
       IMPPAR(3,46)

      CASE opc_02=2     // credenciados
       MEDICOS(3,46)

      CASE opc_02=3     // especialidades
       TESPEC(3,46)

      CASE opc_02=4     // parƒmetro de juros
       JUROS(3,46)

      CASE opc_02=5     // filiais
       TFILIAIS(3,46)

      CASE opc_02=6     // grupos
       ARQGRUP(3,46)

      CASE opc_02=7     // tabelas secund rias
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
        cod_sos=4
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="Regi”es~1|"+;
               "Cobradores/Vendedores~2|"+;
               "Categoria dos Planos~3|"+;
               "Circulares~4|"+;
               "Processos~5|"+;
               "Funcion rios~6|"+;
               "Hist¢rico Padr„o~7|"+;
               "Custos Adicionais~8|"+;
               "Mensagem p/Contrato~9"
        msgt="TABELAS SECUNDRIAS"
        opc_03=DBOX(menu03,3,46,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // regi”es
          REGIAO(5,54)

         CASE opc_03=2     // cobradores/vendedores
          COBRADOR(5,54)

         CASE opc_03=3     // categoria dos planos
          CLASSES(5,54)

         CASE opc_03=4     // circulares
          CIRCULAR(5,54)

         CASE opc_03=5     // processos
          PRCESSOS(5,54)

         CASE opc_03=6     // funcion rios
          FNCS(5,54)

         CASE opc_03=7     // hist¢rico padr„o
          HISTORIC(5,54)

         CASE opc_03=8     // custos adicionais
          CSTSEG(5,54)

         CASE opc_03=9     // mensagem p/contrato
          MENSAG(5,54)

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD

      CASE opc_02=8     // caixas
       ORDPGRC(3,46)

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
     menu02="Parƒmetros~1|"+;
            "Vˆ relat¢rio gravado~2|"+;
            "Reconstr¢i ¡ndices~3|"+;
            "Elimina reg apagados~4|"+;
            "Configura ambiente~5|"+;
            "Plano de senhas~6|"+;
            "Sobre...~7"
     msgt="APOIO"
     ROLAPOP(1)
     opc_02=DBOX(menu02,1,47,E_MENU,NAO_APAGA,msgt,,,opc_02)
     ROLAPOP()
     DO CASE
      CASE opc_02=1     // parƒmetros
       PAR_ADM(3,55)

      CASE opc_02=2     // vˆ relat¢rio gravado
       VE_REL()

      CASE opc_02=3     // reconstr¢i ¡ndices
       cod_sos=39
       RCLA()

      CASE opc_02=4     // elimina reg apagados
       cod_sos=40
       COMPACTA()

      CASE opc_02=5     // configura ambiente
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
        cod_sos=41
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="ÿ Diret¢rio de trabalho~1|"+;
               "ÿ Marca da impressoraÿÿ~2|"+;
               "ÿ Pano de fundoÿÿÿÿÿÿÿÿ~3|"+;
               "ÿ Fontes de caracteresÿ~4|"+;
               "ÿ Esquemas de coresÿÿÿÿ~5|"+;
               IF(drvconf,"û ","ÿ ")+"Confirma em camposÿÿÿ~6|"+;
               IF(drvexcl,"û ","ÿ ")+"Confirma exclus”esÿÿÿ~7|"+;
               IF(drvincl,"û ","ÿ ")+"Confirma inclus”esÿÿÿ~8|"+;
               IF(drvvisivel,"û ","ÿ ")+"Excluidos vis¡veisÿÿÿ~9|"+;
               IF(drvautohelp,"û ","ÿ ")+"Ajuda de campo ativaÿ~10|"+;
               IF(drvmouse,"û ","ÿ ")+"Liga/desliga mouseÿÿÿ~11|"+;
               "ÿ Sensibilidade mouseÿÿ~12"
        msgt="CONFIGURA AMBIENTE"
        opc_03=DBOX(menu03,3,55,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // diret¢rio de trabalho
          cod_sos=2
          PEGADIR(.f.)

          SAVE TO (arqconf) ALL LIKE drv*          // grava configuracoes,
          CBC1()                                   // monta tela principal e
          v01=SAVESCREEN(0,0,MAXROW(),79)          // salva para o break
          BREAK                                    // que foi configurado
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
          op_x=DBOX(SUBS(msg,2),,63,E_MENU,,"FUNDO",,,t)
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
           op_x=DBOX(msgf,05,63,E_MENU,,"FONTES",,,drvfonte+1)
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

         CASE opc_03=10     // ajuda de campo ativa
          drvautohelp=!drvautohelp

         CASE opc_03=11     // liga/desliga mouse
          IF MOUSE()>0
           drvmouse=!drvmouse
          ENDI

          #ifdef COM_TUTOR
           IF acao_mac!="D"
            drvmouse=.f.
           ENDI
          #endi

         CASE opc_03=12     // sensibilidade mouse
          cod_sos=45
          AJMOUSE()

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD
       SAVE TO (arqconf) ALL LIKE drv*             // diferente do atual

      CASE opc_02=6     // plano de senhas
       cod_sos=17
       MASENHA(1,55)
      CASE opc_02=7     // sobre...
       cod_sos=1
       ABOUT(3,55)

     ENDC
     CLEA GETS
     CLOS ALL
    ENDD

  ENDC
 END
 CLEA GETS
 CLOS ALL
ENDD

RETU

* \\ Final de ADR_MENU.PRG
