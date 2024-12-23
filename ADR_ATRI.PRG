procedure adr_atri
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADR_ATRI.PRG
 \ Data....: 29-01-04
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas


/*
   A adicao das  definicoes dos campos (mascara, titulo, cmd esp, when/defa,
   critica, ajuda) dentro do vetor sistema e' feita atraves da funcao AADD(),
   isto previne erro "memory overbooked" do CA-Clipper, durante a compilacao,
   devido a linha ser muito extensa
*/

sistema[001]={;
            "Recebimentos",;                                // opcao do menu
            "Recebimentos",;                                // titulo do sistema
            {"numero","numop+numero","codigo"},;            // chaves do arquivo
            {"N£mero","Caixa","Contrato"},;                 // titulo dos indices para consulta
            {"01","0801","02"},;                            // ordem campos chaves
            {"BXREC",drvdbf,drvntx},;                       // nome do DBF
            {"BXREC1","BXREC2","BXREC3"},;                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,3,7,24,70},;                               // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"},;// condicao de exclusao de registros
            {"nivelop=3","Para alterar este documento|chame o gerente de sistema"},;// condicao de alteracao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"};// condicao de recupercao de registros
           }

AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "99999999",;
     /* titulo        */    "Numero",;
     /* cmd especial  */    "",;
     /* default       */    "RIGHT(DTOC(DATE()),2)+[000001]",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "@!",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,3,20,77,'GRUPOS',{'codigo','grupo','nome','endereco'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "(BXR_07F9().AND.PTAB(ALLTRIM(codigo),[GRUPOS])).AND.!EMPT(LTOC(PTAB(codigo,'TAXAS',1))).AND.CAD_04F9(op_menu)~Contrato inv lido |ou inexistente",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "@!",;
     /* titulo        */    "Cobranca",;
     /* cmd especial  */    "BXR_06F9()",;
     /* default       */    "",;
     /* pre-validacao */    "BXR_06F9()",;
     /* validacao     */    "PTAB(cobranca,[TAXAS],1).or.!EMPT(cobranca)~Necess rio informar COBRANCA",;
     /* help do campo */    "";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor pago",;
     /* cmd especial  */    "BXR_02F9()",;
     /* default       */    "BXR_02F9()",;
     /* pre-validacao */    "!EMPT(cobranca)",;
     /* validacao     */    "valorpg>0.and.!EMPT(BXR_02F9())~VALOR PAGO n„o aceit vel|Digite o valor recebido",;
     /* help do campo */    "Informe o valor pago ou zeros se for retorno.";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Pago com...",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valoraux>=valorpg~VALOR INSUFICIENTE para quitar o d‚bito|A T E N € Ç O",;
     /* help do campo */    "Informe o valor pago";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "@D",;
     /* titulo        */    "Emitido em",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "999999",;
     /* titulo        */    "N§ O.P.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "!9",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "@!",;
     /* titulo        */    "Forma pgto:",;
     /* cmd especial  */    "MTAB([DINHEIRO|CHEQUE|DEBITO|CRED.A VISTA|CRED.PARCELADO|PIX],[FORMA PAGAMENTO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a forma de pagamento desta cobranca";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "@!",;
     /* titulo        */    "Obs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe algo que identifique a forma de pagamento";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "@!",;
     /* titulo        */    "Idxd",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[001,O_CAMPO],{;            // BXREC
     /* mascara       */    "@!",;
     /* titulo        */    "Idxm",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Nome
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[]),35)",;
     /* lin da formula*/    3,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Circ 1 - 4
     /* form mostrar  */    "LEFT(TRAN(BXR_01F9(),[]),48)",;
     /* lin da formula*/    07,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Ult.Circular
     /* form mostrar  */    "GRUPOS->circinic+[ - ]+GRUPOS->ultcirc",;
     /* lin da formula*/    4,;
     /* col da formula*/    52;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Situa‡„o
     /* form mostrar  */    "LEFT(TRAN(IIF(GRUPOS->situacao='2',[CANCELADO],[         ])+[ - Grupo ]+GRUPOS->grupo,[]),22)",;
     /* lin da formula*/    1,;
     /* col da formula*/    36;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Admiss„o
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->admissao,[@D]),10)",;
     /* lin da formula*/    6,;
     /* col da formula*/    52;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Cobrador
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->cobrador,[!!]),02)",;
     /* lin da formula*/    8,;
     /* col da formula*/    52;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Funerais
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->funerais,[99]),02)",;
     /* lin da formula*/    7,;
     /* col da formula*/    52;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Circ.Inicial
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->qtcircs,[999]),03)",;
     /* lin da formula*/    5,;
     /* col da formula*/    52;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Endere‡o
     /* form mostrar  */    "LEFT(TRAN(xDECRIPT(GRUPOS->endereco),[]),35)",;
     /* lin da formula*/    4,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Bairro
     /* form mostrar  */    "LEFT(TRAN(xDECRIPT(GRUPOS->bairro),[]),25)",;
     /* lin da formula*/    5,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Cidade
     /* form mostrar  */    "LEFT(TRAN(xDECRIPT(GRUPOS->cidade),[]),25)",;
     /* lin da formula*/    6,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - CEP
     /* form mostrar  */    "LEFT(TRAN(xDECRIPT(GRUPOS->cep),[@R 99999-999]),09)",;
     /* lin da formula*/    6,;
     /* col da formula*/    29;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - cpf
     /* form mostrar  */    "LEFT(tran(grupos->cpf,[@R 999.999.999-99])+[/]+alltrim(xDECRIPT(grupos->rg)),30)",;
     /* lin da formula*/    9,;
     /* col da formula*/    10;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - telefone
     /* form mostrar  */    "LEFT(alltrim(xDECRIPT(grupos->telefone))+[/]+alltrim(xDECRIPT(grupos->contato)),30)",;
     /* lin da formula*/    7,;
     /* col da formula*/    10;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - email
     /* form mostrar  */    "LEFT(xDECRIPT(grupos->email),30)",;
     /* lin da formula*/    8,;
     /* col da formula*/    10;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Regi„o
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->regiao,[999]),03)",;
     /* lin da formula*/    5,;
     /* col da formula*/    35;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - troco
     /* form mostrar  */    "LEFT(TRAN(valoraux-valorpg,[@E 999,999.99]),11)",;
     /* lin da formula*/    18,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Filial
     /* form mostrar  */    "LEFT(TRAN(filial,[@!]),02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - NrSorte
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nrsorteio,[999999]),06)",;
     /* lin da formula*/    9,;
     /* col da formula*/    52;
                         };
)
AADD(sistema[001,O_FORMULA],{;          // BXREC - Admiss„o
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nascto_,[@D]),10)",;
     /* lin da formula*/    3,;
     /* col da formula*/    52;
                         };
)

sistema[002]={;
            "Endere‡os",;                                   // opcao do menu
            "Endere‡os",;                                   // titulo do sistema
            {"codigo"},;                                    // chaves do arquivo
            {"Contrato"},;                                  // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            {"ALENDER",drvdbf,drvntx},;                     // nome do DBF
            {"ALENDER1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,2,17,77},;                               // num telas/tela atual/coordenadas
            {1,.f.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"},;// condicao de exclusao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"},;// condicao de alteracao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"};// condicao de recupercao de registros
           }

AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,31,20,77,'GRUPOS',{'codigo','nome'},4,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo,'GRUPOS',1).AND.ALE_01F9().AND.CAD_04F9(op_menu)~CODIGO n„o aceit vel|Tecle F8 para consulta",;
     /* help do campo */    "Entre com o n£mero do contrato|Tecle F8 para consulta";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "99999999",;
     /* titulo        */    "Numero",;
     /* cmd especial  */    "",;
     /* default       */    "RIGHT(DTOC(DATE()),2)+[000001]",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "xDECRIPT(GRUPOS->endereco)",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(endereco)~Necess rio informar ENDERE€O do Titular",;
     /* help do campo */    "Informe o Endere‡o para correspondˆncias.|Rua,n£mero,apto, blocl, etc...";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "xDECRIPT(GRUPOS->bairro)",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(bairro)~Necess rio informar BAIRRO do Titular",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "xDECRIPT(GRUPOS->cidade)",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cidade)~Necess rio informar MUNICIPIO para cobran‡a do Titular.",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf).OR.EMPT(UF)~UNIDADE DA FEDERA€ŽO inv lida",;
     /* help do campo */    "Qual ‚ o estado da federa‡„o";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "xDECRIPT(GRUPOS->cep)",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP do Titular |com 08 digitos",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero de telefone para|Contato com o contratante";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,39,20,77,'REGIAO',{'regiao','cobrador'},2,'cobrador',[!EMPT(cobrador)])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1).OR.EMPT(cobrador)~COBRADOR n„o existe na tabela",;
     /* help do campo */    "Digite o c¢digo do COBRADOR que|receber  as Taxas deste contrato,|Tecle F8 para consultar os cobradores.";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@D",;
     /* titulo        */    "Data_",;
     /* cmd especial  */    "",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "M->usuario",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "",;
     /* titulo        */    "Dgrupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@D",;
     /* titulo        */    "Emitido",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "",;
     /* help do campo */    "Data da emiss„o de solicita‡„o do endere‡o";
                         };
)
AADD(sistema[002,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[002,O_FORMULA],{;          // ALENDER - Nome
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[]),35)",;
     /* lin da formula*/    1,;
     /* col da formula*/    28;
                         };
)
AADD(sistema[002,O_FORMULA],{;          // ALENDER - Filial
     /* form mostrar  */    "LEFT(TRAN(filial,[@!]),02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    24;
                         };
)


sistema[003]={;
            "Outros Recebimentos",;                         // opcao do menu
            "Outros Recebimentos",;                         // titulo do sistema
            {"numero","numop+numero","codigo"},;            // chaves do arquivo
            {"N£mero","Caixa","Contrato"},;                 // titulo dos indices para consulta
            {"01","0801","02"},;                            // ordem campos chaves
            {"OBXEC",drvdbf,drvntx},;                       // nome do DBF
            {"OBXEC1","OBXEC2","OBXEC3"},;                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,3,11,23,62},;                              // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"},;// condicao de exclusao de registros
            {"nivelop=3","Para alterar este documento|chame o gerente de sistema"},;// condicao de alteracao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"};// condicao de recupercao de registros
           }

AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "99999999",;
     /* titulo        */    "Numero",;
     /* cmd especial  */    "",;
     /* default       */    "RIGHT(DTOC(DATE()),2)+[000001]",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "@!",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,3,20,77,'GRUPOS',{'codigo','grupo','nome','endereco'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "(PTAB(ALLTRIM(codigo),[GRUPOS]).AND.OBX_07F9()).AND.(PTAB(codigo,'TAXAS',1).OR.1=1).AND.CAD_04F9(op_menu)~Contrato inv lido |ou inexistente",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "@!S20",;
     /* titulo        */    "Cobranca",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cobranca)~Necess rio informar COBRANCA",;
     /* help do campo */    "";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor pago",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "!EMPT(cobranca)",;
     /* validacao     */    "valorpg>0~VALOR PAGO n„o aceit vel|Digite o valor recebido",;
     /* help do campo */    "Informe o valor pago ou zeros se for retorno.";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Pago com...",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valoraux>=valorpg~VALOR INSUFICIENTE para quitar o d‚bito|A T E N € Ç O",;
     /* help do campo */    "Informe o valor pago";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "@D",;
     /* titulo        */    "Emitido em",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "999999",;
     /* titulo        */    "N§ O.P.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "!9",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "@!",;
     /* titulo        */    "Forma pgto:",;
     /* cmd especial  */    "MTAB([DINHEIRO|CHEQUE|DEBITO|CRED.A VISTA|CRED.PARCELADO|PIX],[FORMA PAGAMENTO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a forma de pagamento desta cobranca";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "@!",;
     /* titulo        */    "Obs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe algo que identifique a forma de pagamento";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "@!",;
     /* titulo        */    "Idxd",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[003,O_CAMPO],{;            // OBXEC
     /* mascara       */    "@!",;
     /* titulo        */    "Idxm",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Nome
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[]),35)",;
     /* lin da formula*/    4,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Circ 1 - 4
     /* form mostrar  */    "LEFT(TRAN(OBX_01F9(),[]),48)",;
     /* lin da formula*/    11,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Ult.Circular
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->ultcirc,[999]),03)",;
     /* lin da formula*/    6,;
     /* col da formula*/    47;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Situa‡„o
     /* form mostrar  */    "LEFT(TRAN(IIF(GRUPOS->situacao='2',[CANCELADO],[         ])+[ - Grupo ]+GRUPOS->grupo,[]),22)",;
     /* lin da formula*/    2,;
     /* col da formula*/    23;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Admiss„o
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->admissao,[@D]),10)",;
     /* lin da formula*/    8,;
     /* col da formula*/    12;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Saitxa
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->saitxa,[@R 99/99]),05)",;
     /* lin da formula*/    8,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Cobrador
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->cobrador,[!!]),02)",;
     /* lin da formula*/    9,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Funerais
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->funerais,[99]),02)",;
     /* lin da formula*/    9,;
     /* col da formula*/    12;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Circ.Inicial
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->circinic,[999]),03)",;
     /* lin da formula*/    5,;
     /* col da formula*/    46;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Endere‡o
     /* form mostrar  */    "LEFT(TRAN(xDECRIPT(GRUPOS->endereco),[]),35)",;
     /* lin da formula*/    5,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Bairro
     /* form mostrar  */    "LEFT(TRAN(xDECRIPT(GRUPOS->bairro),[]),25)",;
     /* lin da formula*/    6,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Cidade
     /* form mostrar  */    "LEFT(TRAN(xDECRIPT(GRUPOS->cidade),[]),25)",;
     /* lin da formula*/    7,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - CEP
     /* form mostrar  */    "LEFT(TRAN(xDECRIPT(GRUPOS->cep),[@R 99999-999]),09)",;
     /* lin da formula*/    7,;
     /* col da formula*/    29;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Regi„o
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->regiao,[999]),03)",;
     /* lin da formula*/    6,;
     /* col da formula*/    35;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - troco
     /* form mostrar  */    "LEFT(TRAN(valoraux-valorpg,[@E 999,999.99]),11)",;
     /* lin da formula*/    17,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[003,O_FORMULA],{;          // OBXEC - Filial
     /* form mostrar  */    "LEFT(TRAN(filial,[@!]),02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    23;
                         };
)


sistema[004]={;
            "Consulta Contratos",;                          // opcao do menu
            "Consulta contratos",;                          // titulo do sistema
            {"codigo","nome"},;                             // chaves do arquivo
            {"Contrato","p/Nome"},;                         // titulo dos indices para consulta
            {"01","04"},;                                   // ordem campos chaves
            {"GRUPOS",drvdbf,drvntx},;                      // nome do DBF
            {"GRUPOS1","GRUPOS2"},;                         // nomes dos NTX
            {"TAXAS","ECOB","INSCRITS"},;                   // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,3,22,77},;                               // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"1=3","Mantido pelo sistema de Plano"},;       // condicao de exclusao de registros
            {"1=3","Mantido pelo sistema de Plano"},;       // condicao de alteracao de registros
            {"1=3","Mantido pelo sistema de Plano"};        // condicao de recupercao de registros
           }

AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "GRU_02F9()",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB('',[ARQGRUP],1).AND.GRU_01F9()~CODIGO n„o aceit vel|N„o cadastrado na tabela de grupos",;
     /* help do campo */    "Entre com o n£mero do contrato";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "9",;
     /* titulo        */    "Situa‡„o",;
     /* cmd especial  */    "MTAB([1=Ativo|2=Cancelado],[SITUA€ŽO])",;
     /* default       */    "[1]",;
     /* pre-validacao */    "",;
     /* validacao     */    "situacao $ [12]~SITUA€ŽO n„o aceit vel",;
     /* help do campo */    "Digite 1 para ativo ou 2 para cancelado";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Nascto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de nascimento do titular";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "!!",;
     /* titulo        */    "Est Civil",;
     /* cmd especial  */    "MTAB(tbestciv,[EST CIVIL])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "(estcivil$tbestciv)~Informe Estado Civil|ou|Tecle F8 para consulta em tabela",;
     /* help do campo */    "Digite o Estado Civil do Titular|ou|Tecle F8 para consulta em tabela";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VDV2(cpf).OR.EMPT(cpf)~CPF nÆo aceit vel",;
     /* help do campo */    "Informe o CIC (CPF) do titular";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "R.G.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do documento do titular";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(endereco)~Este endere‡o ser  utilizado na emissÆo das Taxas|para cobran‡a e em todas as telas de consulta.",;
     /* help do campo */    "Informe o Endere‡o para correspondˆncias.|Rua,n£mero,apto, blocl, etc...";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(bairro)~Necess rio informar BAIRRO do Titular",;
     /* help do campo */    "Informe o bairro ou regi„o do titular do contrato";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "M->p_cidade",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cidade)~Necess rio informar MUNICIPIO para cobran‡a do Titular.",;
     /* help do campo */    "Digite a Cidade para correspondˆncia.";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf).OR.EMPT(UF)~UNIDADE DA FEDERA€ŽO inv lida",;
     /* help do campo */    "Qual ‚ o estado da federa‡„o";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP do Titular |com 08 digitos",;
     /* help do campo */    "Informe o CEP (8 digitos)|para facilitar a correspondˆncia";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@K!",;
     /* titulo        */    "Naturalidade",;
     /* cmd especial  */    "",;
     /* default       */    "M->p_cidade",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a naturalidade do titular";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!S20",;
     /* titulo        */    "Relig",;
     /* cmd especial  */    "__KEYBOARD([CATOLICO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a religi„o do titular";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Contato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Digite o nome da pessoa para contato|";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero de telefone para|Contato com o contratante";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "TipCont",;
     /* cmd especial  */    "VDBF(6,20,20,77,'CLASSES',{'classcod','descricao','vljoia'},1,'classcod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(tipcont,'CLASSES',1)~Informe a Classe deste contrato",;
     /* help do campo */    "Qual a categoria do Contrato?|Tecle F8 para consulta em tabela";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Vlcarne",;
     /* cmd especial  */    "VDBF(6,52,20,77,'TCARNES',{'tip','pari','vali','parf'},1,'tip',[])",;
     /* default       */    "",;
     /* pre-validacao */    "!(CLASSES->prior=[S])",;
     /* validacao     */    "",;
     /* help do campo */    "Qual o c¢digo de classifica‡Æo do valor do contrato?|Tecle F8 para consultar tabela|Obs.|Ser  preenchido quando for lan‡ada a|venda do contrato.";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "FormaPgto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "CLASSES->prior=[S]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a forma de pagamento desejada|A Taxa de manuten‡Æo ser  emitida cada NN meses.";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Seguro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Admiss„o",;
     /* cmd especial  */    "DATE()",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(admissao)~Necess rio informar DATA DE ADMISSŽO",;
     /* help do campo */    "Informe a data da Admiss„o neste contrato";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "T.Carˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de t‚rmino da Carˆncia";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Saitxa",;
     /* cmd especial  */    "",;
     /* default       */    "SUBSTR(DTOC(admissao+(CLASSES->nrparc*30)),4,2)+RIGHT(DTOC(admissao+(CLASSES->nrparc*30)),2)",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(saitxa).AND.MMAA(saitxa) .or.nivelop==3~Necess rio informar SAITXA (MM/AA)",;
     /* help do campo */    "Informe o Mˆs a sair a 1¦ Taxa.";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Dia Pgto.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "diapgto<[31]~DIA PGTO. n„o aceit vel|Digite um dia entre 01 e 30|ou|deixe com 00 para data igual ao grupo",;
     /* help do campo */    "Informe o melhor dia para pagamento";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "!!!",;
     /* titulo        */    "Vendedor",;
     /* cmd especial  */    "VDBF(6,7,20,77,'COBRADOR',{'cobrador','funcao','nome','cidade'},1,'cobrador')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(vendedor,'COBRADOR',1).OR.EMPT(vendedor)~VENDEDOR n„o existe na tabela",;
     /* help do campo */    "Informe o c¢digo do Vendedor|ou|Tecle F8 para consulta em arquivo";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Regi„o",;
     /* cmd especial  */    "VDBF(6,38,20,77,'REGIAO',{'codigo','regiao'},1,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(regiao,'REGIAO',1).OR.EMPT(VAL(regiao))~REGIŽO n„o existe na tabela",;
     /* help do campo */    "Informe a regi„o ou tecle F8 para busca em tabela";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,39,20,77,'REGIAO',{'regiao','cobrador'},2,'cobrador',[!EMPT(cobrador)])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1)~COBRADOR n„o existe na tabela",;
     /* help do campo */    "Digite o c¢digo do COBRADOR que|receber  as Taxas deste contrato,|Tecle F8 para consultar os cobradores.";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@S35",;
     /* titulo        */    "Obs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Renovar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Data final para renova‡Æo";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Funerais",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(funerais<0)~FUNERAIS n„o aceit vel",;
     /* help do campo */    "N£mero de Funerais efetuados|para este processo";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Circ.Inicial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero da 1¦ Circular|que saiu para este contrato.";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Ult.Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(IIF(CLASSES->prior=[S],M->mgrupvip,grupo)+ultcirc,'CIRCULAR',1).OR.ultcirc=[000].or.nivelop==3~Necess rio informar ULT.CIRCULAR",;
     /* help do campo */    "Entre com o £ltimo n£mero de circular|deste contrato.";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Qt.Circulares",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(qtcircs<0)~QT.CIRCULARES n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Circ.Pagas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de Circulares|pagas/retornadas deste contrato";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Titular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Part.Vivos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Part.Falecidos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "N§ Depend.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Ult.Impress.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "élt.alter.endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "UltEnd",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Em",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Atendimento:",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quem pertence o atendimento";
                         };
)
AADD(sistema[004,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Atendimento:",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Segunda opcao";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Ult.Emitida",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Ult.Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@R 999,999.99",;
     /* titulo        */    "Ult.Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "eMail",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o endereco de email.";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "SeguroData",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com a data da admissao do seguro.";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "SeguroCod",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o Cod.Seguro.";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "SeguroServ",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o Serv.Seguro.";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "NrSorteio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o Numero Sorteio.";
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Situacao
     /* form mostrar  */    "LEFT(TRAN(IIF(situacao=[2],[CANCELADO],[         ]),[]),09)",;
     /* lin da formula*/    1,;
     /* col da formula*/    62;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Part.Vivos
     /* form mostrar  */    "LEFT(TRAN(particv,[99]),02)",;
     /* lin da formula*/    16,;
     /* col da formula*/    24;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Part.Falecidos
     /* form mostrar  */    "LEFT(TRAN(particf,[99]),02)",;
     /* lin da formula*/    16,;
     /* col da formula*/    38;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Nome do Cobrado
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(cobrador,'COBRADOR',1),COBRADOR->nome,[ ]),[]),30)",;
     /* lin da formula*/    13,;
     /* col da formula*/    16;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Nome do Vendedr
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(vendedor,'COBRADOR',1),COBRADOR->nome,[ ]),[]),30)",;
     /* lin da formula*/    11,;
     /* col da formula*/    16;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - grupo
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(grupo),grupo,[  ]),[]),02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    22;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Descri‡„o Reg
     /* form mostrar  */    "LEFT(TRAN(REGIAO->regiao,[]),30)",;
     /* lin da formula*/    12,;
     /* col da formula*/    16;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Est.Civil
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(estcivil),SUBS(tbestciv,AT(estcivil,tbestciv),11),[]),[]),11)",;
     /* lin da formula*/    4,;
     /* col da formula*/    13;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - N§ Depend.
     /* form mostrar  */    "LEFT(TRAN(nrdepend,[99]),02)",;
     /* lin da formula*/    16,;
     /* col da formula*/    54;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Ult.Impress.
     /* form mostrar  */    "LEFT(TRAN(ultimp_,[@D]),10)",;
     /* lin da formula*/    16,;
     /* col da formula*/    54;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - élt.alter.ender
     /* form mostrar  */    "LEFT(TRAN(ender_,[@D]),10)",;
     /* lin da formula*/    18,;
     /* col da formula*/    17;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - UltEnd
     /* form mostrar  */    "LEFT(TRAN(ultend,[]),10)",;
     /* lin da formula*/    18,;
     /* col da formula*/    28;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Seguro
     /* form mostrar  */    "LEFT(TRAN(IIF(seguro>0,'SEGURO ('+str(seguro,2)+')',[   ]),[]),12)",;
     /* lin da formula*/    1,;
     /* col da formula*/    28;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Qt.Circulares
     /* form mostrar  */    "LEFT(TRAN(qtcircs,[999]),03)",;
     /* lin da formula*/    0,;
     /* col da formula*/    0;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - periodicidade
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(tipcont,'CLASSES',1),ALLTRIM(CLASSES->descricao),[])+[ ]+IIF(formapgto$'01020304',SUBSTR(tbfpgto,(VAL(formapgto)-1)*13+1,13),[]),[]),35)",;
     /* lin da formula*/    9,;
     /* col da formula*/    39;
                         };
)
AADD(sistema[004,O_FORMULA],{;          // GRUPOS - Idade
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(nascto_),LEFT(DLAPSO(DATE(),nascto_),10),[          ]),[]),10)",;
     /* lin da formula*/    3,;
     /* col da formula*/    64;
                         };
)


sistema[005]={;
            "Taxas",;                                       // opcao do menu
            "Cadastro de Taxas",;                           // titulo do sistema
	    {"codigo","codlan"},;       // chaves do arquivo
	    {"Contrato","Cod.Lanc"},;            // titulo dos indices para consulta
	    {"01","16"},;                            // ordem campos chaves
	    {"TAXAS",drvdbf,drvntx},;                       // nome do DBF
	    {"TAXAS1","TAXAS3"},;                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"GRUPOS->codigo"},;                            // campos de relacionamento
            {1,1,13,0,23,79,3,7},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@!",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
			 };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@!",;
     /* titulo        */    "Cobranca",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
			 };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@D",;
     /* titulo        */    "Emissao",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao_)~Necess rio informar EMISSAO v lida",;
     /* help do campo */    "Data da Emiss„o da Circular|Mantido pela emissao do recibo";
			 };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~VALOR n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@D",;
     /* titulo        */    "Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de pagamento/Baixa";
			 };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor pago",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "!(valorpg<0)~VALOR PAGO n„o aceit vel",;
     /* help do campo */    "Informe o valor pago/baixado";
                         };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,3,20,77,'COBRADOR',{'cobrador','funcao','nome','cidade','telefone'},1,'cobrador',[])",;
     /* default       */    "GRUPOS->cobrador",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1).AND.(PTAB(cobrador+M->mmesref,'FCCOB',1).OR.1=1)~Problemas encontrados no arquivo Cobrador ou |Circular do grupo n„o cadastrada para|este cobrador.",;
     /* help do campo */    "Informe o Cobrador que recebeu este.";
			 };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "!",;
     /* titulo        */    "Forma",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "forma$[PR ]~FORMA n„o aceit vel",;
     /* help do campo */    "Esta lan‡amento foi Pago ou Cancelado|Deixe sem preencher se ainda em aberto";
                         };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@D",;
     /* titulo        */    "Baixa_",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
			 };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "9",;
     /* titulo        */    "Status",;
     /* cmd especial  */    "MTAB([1=Gerada|2=Impressa|6=Pg Recep‡„o|7=Bx.p/FCC|9=Bx.Plano],[STATUS])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "stat $ [12679]~STATUS n„o aceit vel",;
     /* help do campo */    "Informe a situa‡„o deste recibo|Tecle F8 para busca em tabela";
			 };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
			 };
)
AADD(sistema[005,O_CAMPO],{;            // TAXAS
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[005,O_FORMULA],{;          // TAXAS - Status
     /* form mostrar  */    "LEFT(TRAN(LEFT(TAX_02F9(),3),[]),03)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    75;
                         };
)
AADD(sistema[005,O_FORMULA],{;          // TAXAS - numero
     /* form mostrar  */    "LEFT(TRAN(substr(codigo,11),[]),08)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    1;
                         };
)


sistema[006]={;
            "Outros Endere‡os",;                            // opcao do menu
            "Outros Endere‡os",;                            // titulo do sistema
            {"codigo+tipo"},;                               // chaves do arquivo
            {"Contrato"},;                                  // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            {"ECOB",drvdbf,drvntx},;                        // nome do DBF
            {"ECOB1"},;                                     // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"GRUPOS->codigo"},;                            // campos de relacionamento
            {1,1,8,17,16,65},;                              // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
	    {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([Residˆncia|Trabalho|Outro],[TIPO])",;
     /* default       */    "[R]",;
     /* pre-validacao */    "MTAB([Residˆncia|Trabalho|Outro],[TIPO])",;
     /* validacao     */    "tipo $ [RTO]~TIPO n„o aceit vel|Apenas endere‡os de Residˆncia e Trabalho.",;
     /* help do campo */    "Informe que tipo de Endere‡o ‚ este.|R=Residˆncia, T=Trabalho";
                         };
)
AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(endereco)~Informe a localiza‡„o ou tecle ESC para cancelar",;
     /* help do campo */    "Informe o Endere‡o|Rua,n£mero,apto, blocl, etc...";
                         };
)
AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Digite o Bairro|ou complemento| do endere‡o";
                         };
)
AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o CEP para facilitar a localiza‡„o";
                         };
)
AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade/Municipio";
                         };
)
AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf).OR. EMPT(uf)~UNIDADE DA FEDERA€ŽO inv lida",;
     /* help do campo */    "Informe o Estado.|Ex.: SP,RJ,GO,AM,...";
                         };
)
AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do telefone para contato";
                         };
)
AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "",;
     /* titulo        */    "Obs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[006,O_CAMPO],{;            // ECOB
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[006,O_FORMULA],{;          // ECOB - Tipo
     /* form mostrar  */    "LEFT(TRAN(IIF(tipo=[R],[Residˆncia],IIF(tipo=[T],[Trabalho],[Outro])),[]),12)",;
     /* lin da formula*/    1,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[006,O_FORMULA],{;          // ECOB - Data
     /* form mostrar  */    "LEFT(TRAN(data_,[@D]),08)",;
     /* lin da formula*/    7,;
     /* col da formula*/    39;
                         };
)


sistema[007]={;
	    "Inscritos",;                                   // opcao do menu
	    "Inscritos",;                                   // titulo do sistema
	    {"codigo","nome"},;                        // chaves do arquivo
	    {"Codigo","Nome"},;                             // titulo dos indices para consulta
	    {"01","05"},;                                 // ordem campos chaves
	    {"INSCRITS",drvdbf,drvntx},;                    // nome do DBF
	    {"INSCRIT1","INSCRIT2"},;                       // nomes dos NTX
	    {},;                                            // nome dos dbf's relacionados
	    {"GRUPOS->codigo"},;                            // campos de relacionamento
	    {1,1,17,3,23,77},;                              // num telas/tela atual/coordenadas
	    {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@!",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "9",;
     /* titulo        */    "Inscr.",;
     /* cmd especial  */    "MTAB(M->TBTIPGRAU,[INSCR.])",;
     /* default       */    "IIF(M->pgrau<[7],SUBSTR([234567],VAL(M->pgrau),1),M->pgrau)",;
     /* pre-validacao */    "MTAB(M->TBTIPGRAU,[INSCR.])",;
     /* validacao     */    "grau $ [12345678]~INSCR. n„o aceit vel",;
     /* help do campo */    "Informe o grau de liga‡„o deste com o|titular do contrato|ou|tecle F8 para consulta em tabela";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "99",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "INS_01F9()",;
     /* pre-validacao */    "grau>[6]",;
     /* validacao     */    "seq>0~SEQ n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!",;
     /* titulo        */    "Titular?",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@!",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(ehtitular=[S],GRUPOS->nome,[ ])",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@D",;
     /* titulo        */    "Nascto",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(ehtitular=[S],GRUPOS->nascto_,ctod('  /  /  '))",;
     /* pre-validacao */    "",;
     /* validacao     */    "INS_02F9()~NASCTO n„o aceit vel",;
     /* help do campo */    "Informe a Data de Nascimento deste Inscrito";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "",;
     /* titulo        */    "Est Civil",;
     /* cmd especial  */    "MTAB(tbestciv,[EST CIVIL])",;
     /* default       */    "IIF(grau<[7],[CA],[SO])",;
     /* pre-validacao */    "MTAB(tbestciv,[EST CIVIL])",;
     /* validacao     */    "(ESTCIVIL$tbestciv)~Necess rio informar ESTADO CIVIL|ou tecle F8",;
     /* help do campo */    "Digite o Estado Civil do Falecido";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!",;
     /* titulo        */    "Interdito",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!",;
     /* titulo        */    "Sexo",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(grau$[124],[M],IIF(grau$[356],[F],[ ]))",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Digite M ou F |(Masculino ou Feminino)";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@D",;
     /* titulo        */    "T.Carˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(GRUPOS->tcarencia>DATE(),GRUPOS->tcarencia,CTOD('  /  /  '))",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@D",;
     /* titulo        */    "Lan‡to.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!",;
     /* titulo        */    "V/F",;
     /* cmd especial  */    "MTAB([Vivo|Falecido],[V/F])",;
     /* default       */    "[V]",;
     /* pre-validacao */    "",;
     /* validacao     */    "vivofalec$[VF]~Necess rio informar VIVOFALEC",;
     /* help do campo */    "Vivo ou Falecido";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@D",;
     /* titulo        */    "Falecto.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "vivofalec==[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com a data de falecimento";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!!!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([Funeral|Auxilio],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "vivofalec==[F]",;
     /* validacao     */    "EMPTY(tipo).OR.UPPER(tipo) $ [FUN|AUX]~Necess rio informar TIPO",;
     /* help do campo */    "Com Direitos (Funeral) ou com Auxilio.";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@R 99999/99",;
     /* titulo        */    "N§Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "vivofalec==[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do processo";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[007,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VDV2(cpf).OR.EMPT(cpf)~CPF nÆo aceit vel",;
     /* help do campo */    "Informe o CIC (CPF) do titular";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "",;
     /* titulo        */    "SeguroData",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com a data da admissao do seguro.";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "",;
     /* titulo        */    "Seg.Porcentagem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o Cod.Seguro.";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "",;
     /* titulo        */    "SeguroCod",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o Cod.Seguro.";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "",;
     /* titulo        */    "SeguroServ",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o Serv.Seguro.";
                         };
)
AADD(sistema[007,O_FORMULA],{;          // INSCRITS - graupart
     /* form mostrar  */    "LEFT(TRAN(SUBSTR([TitPaiMaeSgoSgaEspFilDep],(VAL(grau)-1)*3+1,3),[]),03)",;
     /* lin da formula*/    1,;
     /* col da formula*/    13;
                         };
)
AADD(sistema[007,O_FORMULA],{;          // INSCRITS - Lan‡to.
     /* form mostrar  */    "LEFT(TRAN(lancto_,[@D]),08)",;
     /* lin da formula*/    1,;
     /* col da formula*/    53;
                         };
)
AADD(sistema[007,O_FORMULA],{;          // INSCRITS - Por
     /* form mostrar  */    "LEFT(TRAN(por,[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    62;
                         };
)
AADD(sistema[007,O_FORMULA],{;          // INSCRITS - Idade
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(nascto_),LEFT(DLAPSO(DATE(),nascto_),12),[            ]),[]),12)",;
     /* lin da formula*/    3,;
     /* col da formula*/    62;
                         };
)


sistema[008]={;
            "Emiss„o de Guias",;                            // opcao do menu
            "Emiss„o de Guias",;                            // titulo do sistema
            {"numero","numero"},;                           // chaves do arquivo
            {"p/N£mero","p/N§Transf."},;                    // titulo dos indices para consulta
            {"01","01"},;                                   // ordem campos chaves
            {"GUIAS",drvdbf,drvntx},;                       // nome do DBF
            {"GUIAS1","GUIAS2"},;                           // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,10,23,75},;                              // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "99999999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "RIGHT(DTOC(DATE()),2)+[000001]",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "@D",;
     /* titulo        */    "Emiss„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "99:99",;
     /* titulo        */    "Hora",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "",;
     /* titulo        */    "Login",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "@!",;
     /* titulo        */    "N§ Contrato",;
     /* cmd especial  */    "VDBF(6,3,20,77,'GRUPOS',{'grupo','codigo','nome','endereco'},1,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "GUI_07F9(contrato).AND.CAD_04F9(op_menu).AND.((PTAB(contrato,'INSCRITS',1).and.PTAB(contrato,'TAXAS',1)).OR.1=1)~N£mero do contrato inv lido,|ou |Titular n„o cadastrado|Tecle F8 para consulta.",;
     /* help do campo */    "Entre com o c¢digo do contrato";
                         };
)
AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "@!",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "GUI_06F9()",;
     /* default       */    "GRUPOS->nome",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome).AND.(PTAB([],'MEDICOS',1).OR.1=1)~Informar NOME",;
     /* help do campo */    "Informe o nome do benefici rio.";
                         };
)
AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "@!",;
     /* titulo        */    "Inscrito",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "@!",;
     /* titulo        */    "M‚dico",;
     /* cmd especial  */    "VDBF(6,3,20,77,'MEDICOS',{'LEFT(oldespec,20)','nome','endereco','cidade','codbenefic','fonesdiv','fonecom1'},3,'codbenefic',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(medico,'MEDICOS',1).OR.GUI_08F9()~MDICO n„o existe na tabela",;
     /* help do campo */    "Informe o m‚dico";
                         };
)
AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[008,O_CAMPO],{;            // GUIAS
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - circ 1-4
     /* form mostrar  */    "LEFT(TRAN(GUI_02F9(),[]),45)",;
     /* lin da formula*/    6,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Nome do titular
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[]),35)",;
     /* lin da formula*/    3,;
     /* col da formula*/    26;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Admiss„o
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->admissao,[@D]),10)",;
     /* lin da formula*/    4,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Saitxa
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->saitxa,[@R 99/99]),05)",;
     /* lin da formula*/    5,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Cobrador
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->cobrador,[!!]),02)",;
     /* lin da formula*/    5,;
     /* col da formula*/    59;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Endere‡o contr
     /* form mostrar  */    "LEFT(TRAN(xDECRIPT(GRUPOS->endereco),[]),35)",;
     /* lin da formula*/    4,;
     /* col da formula*/    26;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Bairro contr
     /* form mostrar  */    "LEFT(TRAN(xDECRIPT(GRUPOS->bairro),[]),25)",;
     /* lin da formula*/    5,;
     /* col da formula*/    26;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Endere‡o
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(medico).AND.PTAB(medico,'MEDICOS',1),MEDICOS->endereco,SPACE(40)),[]),40)",;
     /* lin da formula*/    15,;
     /* col da formula*/    24;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Munic¡pio
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(medico,'MEDICOS',1),MEDICOS->cidade,[]),[]),30)",;
     /* lin da formula*/    16,;
     /* col da formula*/    32;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Fone
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(medico),MEDICOS->fonecom1,SPACE(14)),[]),14)",;
     /* lin da formula*/    15,;
     /* col da formula*/    9;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Nome m‚dico
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(medico),MEDICOS->nome,SPACE(40)),[]),40)",;
     /* lin da formula*/    14,;
     /* col da formula*/    24;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Especialidade
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(medico),MEDICOS->oldespec,SPACE(30)),[]),30)",;
     /* lin da formula*/    16,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Emiss„o
     /* form mostrar  */    "LEFT(TRAN(IIF(EMPT(data),DATE(),data),[@D]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    43;
                         };
)
AADD(sistema[008,O_FORMULA],{;          // GUIAS - Por
     /* form mostrar  */    "LEFT(TRAN(IIF(EMPT(por),M->usuario,por),[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    54;
                         };
)

* \\ Final de ADR_ATRI.PRG

