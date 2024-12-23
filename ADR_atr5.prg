// <ADRBIG> - <ADR_>
procedure ADR_ATR5
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda
 \ Programa: ADR_ATR5.PRG
 \ Data....: 25-06-21
 \ Sistema.: Controle de Processos da Funer ria
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "ADRBIG.ch"    // inicializa constantes manifestas


sistema[nss-2]={;
            "Senhas",;                   // opcao do menu
            "Grupos de usu rios",;       // titulo do sistema
            {"pw_grupo"},;               // chaves do arquivo
            {"Codigo"},;                 // titulo dos indices para consulta
            {"01"},;                     // ordem campos chaves
            {"PWGRUPOS",drvpw,drvpw},;   // nome do DBF
            {"PWGRUPO1"},;               // nomes dos NTX
            {"PWTABELA","PWUSUA"},;      // nome dos dbf's relacionados
            {},;                         // campos de relacionamento
            {1,1,1,12,3,65},;            // num telas/tela atual/coordenadas
            {3,.t.,.f.},;                // nivel acesso/tp chave/pede dir
            {},;                         // campos do arquivo
            {},;// fromula { mascara, titulo, formula, linha, coluna }
            {"",""},;      // condicao de exclusao de registros
            {"",""},;      // condicao de alteracao de registros
            {"",""};       // condicao de recuperacao de registros
           }

AADD(sistema[nss-2,O_CAMPO],{;           // PWGRUPOS
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss-2,O_CAMPO],{;           // PWGRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(_nogrupo)~Necess rio informar GRUPO",;
     /* help do campo */    "";
                         };
)

sistema[nss-1]={;
            "Tabelas",;                  // opcao do menu
            "Tabelas",;                  // titulo do sistema
            {"pw_grupo+pw_dbf"},;        // chaves do arquivo
            {"Por Grupo"},;              // titulo dos indices para consulta
            {"0102"},;                   // ordem campos chaves
            {"PWTABELA",drvpw,drvpw},;   // nome do DBF
            {"PWTABEL1"},;               // nomes dos NTX
            {},;                         // nome dos dbf's relacionados
            {"PWGRUPOS->pw_grupo"},;     // campos de relacionamento
            {1,1,4,12,12,65,3,5},;       // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {3,.t.,.f.},;                // nivel acesso/tp chave/pede dir
            {},;                         // campos do arquivo
            {},;// fromula { mascara, titulo, formula, linha, coluna }
            {"",""},;      // condicao de exclusao de registros
            {"",""},;      // condicao de alteracao de registros
            {"",""};       // condicao de recuperacao de registros
           }

AADD(sistema[nss-1,O_CAMPO],{;           // PWTABELA
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss-1,O_CAMPO],{;           // PWTABELA
     /* mascara       */    "@S27",;
     /* titulo        */    "Arquivo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(_dbf)~Necess rio informar ARQUIVO",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss-1,O_CAMPO],{;           // PWTABELA
     /* mascara       */    "@!",;
     /* titulo        */    "Permis”es",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "DIGITE INICIAIS DAS ROTINAS CERCEADAS AO USURIO|"+;
                            "P. Procura    F. Filtragem    D. Digita‡„o     ÿ|"+;
                            "M. Modifica   E. Exclui       R. Recupera      ÿ|"+;
                            "V. Vˆ global  N. Nova coluna  A. Apaga coluna  ÿ|"+;
                            "I. Imprime    O. Ordena       Q. Quantifica    ÿ|"+;
                            "L. Localiza   G. Global       C. Congela Colunas|"+;
                            "T. Tamanho    J. nova Janela ÿX. eXporta       ÿ|"+;
                            "Z. totaliZa   B. marca linha                   ÿ|";
                         };
)
AADD(sistema[nss-1,O_CAMPO],{;           // PWTABELA
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)

sistema[nss]={;
            "Usu rios",;                               // opcao do menu
            "Usu rios",;                               // titulo do sistema
            {"pw_grupo+pw_codigo","pw_nome+pw_pass"},; // chaves do arquivo
            {"Por Grupo","Nome+pass"},;                // titulo dos indices para consulta
            {"0102","0306"},;                          // ordem campos chaves
            {"PWUSUA",drvpw,drvpw},;                   // nome do DBF
            {"PWUSUA1","PWUSUA2"},;                    // nomes dos NTX
            {},;                                       // nome dos dbf's relacionados
            {"PWGRUPOS->pw_grupo"},;                   // campos de relacionamento
            {1,1,13,12,23,65,3,7},;                    // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {3,.f.,.f.},;                              // nivel acesso/tp chave/pede dir
            {},;                                       // campos do arquivo
            {},;// fromula { mascara, titulo, formula, linha, coluna }
            {"",""},;      // condicao de exclusao de registros
            {"",""},;      // condicao de alteracao de registros
            {"",""};       // condicao de recuperacao de registros
           }

AADD(sistema[nss,O_CAMPO],{;            // PWUSUA
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss,O_CAMPO],{;            // PWUSUA
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss,O_CAMPO],{;            // PWUSUA
     /* mascara       */    "@!",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(_nome)~Necess rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss,O_CAMPO],{;            // PWUSUA
     /* mascara       */    "9",;
     /* titulo        */    "Nivel",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "MTAB([1. Opera‡„o|2. Manuten‡„o|3. Gerˆncia],[N¡VEL DE ACESSO])",;
     /* validacao     */    "VAL(_nivel)>0~NIVEL n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss,O_CAMPO],{;            // PWUSUA
     /* mascara       */    "",;
     /* titulo        */    "Obs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss,O_CAMPO],{;            // PWUSUA
     /* mascara       */    "",;
     /* titulo        */    "PW",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss,O_CAMPO],{;            // PWUSUA
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)

* \\ Final de ADR_ATR5.PRG
// troca_nome