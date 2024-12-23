/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: CTCGRUP.PRG
 \ Data....: 06-01-00
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Contratos Cancelados
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, ord_
PRIV  prefixo_dbf:="CTC", op_sis:=EVAL(qualsis,"CGRUPOS")
                                                   // arquivo a consultar
op_menu=PROJECOES                                  // flag consulta e faz projecoes
SELE 0

#ifdef COM_REDE
 IF !USEARQ("CGRUPOS",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CGRUPOS")                                 // abre o dbf e seus indices
#endi

col_cp={;                                          // conteudo das colunas
          "numero",;
          "codigo",;
          "motivo",;
          "canclto_",;
          "cancpor",;
          "reintnum",;
          "motreint",;
          "reintem_",;
          "reintpor",;
          "codreint",;
          "situacao",;
          "nome",;
          "nascto_",;
          "estcivil",;
          "cpf",;
          "rg",;
          "endereco",;
          "bairro",;
          "cidade",;
          "uf",;
          "cep",;
          "contato",;
          "telefone",;
          "tipcont",;
          "vlcarne",;
          "formapgto",;
          "admissao",;
          "tcarencia",;
          "saitxa",;
          "vendedor",;
          "regiao",;
          "cobrador",;
          "obs",;
          "renovar",;
          "funerais",;
          "circinic",;
          "ultcirc",;
          "qtcircs",;
          "qtcircpg";
       }
col_ti={;                                          // titulo das colunas
          "N£mero",;
          "Codigo",;
          "Motivo",;
          "Canclto_",;
          "Por",;
          "N£mero",;
          "Motreint",;
          "Reintem",;
          "Reintpor",;
          "Codigo",;
          "Situa‡„o",;
          "Nome",;
          "Nascto",;
          "Est Civil",;
          "CPF",;
          "R.G.",;
          "Endere‡o",;
          "Bairro",;
          "Cidade",;
          "UF",;
          "CEP",;
          "Contato",;
          "Telefone",;
          "TipCont",;
          "Vlcarne",;
          "FormaPgto",;
          "Admiss„o",;
          "T.Carˆncia",;
          "Saitxa",;
          "Vendedor",;
          "Regi„o",;
          "Cobrador",;
          "Obs",;
          "Renovar",;
          "Funerais",;
          "Circ.Inicial",;
          "Ult.Circular",;
          "Qt.Circulares",;
          "Circ.Pagas";
       }
ord_="nome"                                        // ordem inicial
GO TOP                                             // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti,,ord_)
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de CTCGRUP.PRG
