/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADR_ATR1.PRG
 \ Data....: 29-01-04
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas


sistema[009]={;
            "Lan‡amento Aux.Funeral",;                      // opcao do menu
            "Aux¡lio Funeral",;                             // titulo do sistema
	    {"processo+proc2+filial+categ","falecido+processo","ruafal"},;// chaves do arquivo
	    {"Processo","Nome Falecido","Data e Local Fal."},;// titulo dos indices para consulta
	    {"01020305","1201","20"},;                          // ordem campos chaves
            {"AFUNER",drvdbf,drvntx},;                      // nome do DBF
            {"AFUNER1","AFUNER2","AFUNER3"},;               // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,3,1,22,78},;                               // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"},;// condicao de exclusao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"},;// condicao de alteracao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"};// condicao de recupercao de registros
           }

AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "99999",;
     /* titulo        */    "Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(PROCESSO)~Este ‚ um campo obrigat¢rio!|Ele ‚ usado como chave principal|para localiza‡„o dos documentos.",;
     /* help do campo */    "Digite neste campo o n£mero de|identifica‡„o do processo";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "99",;
     /* titulo        */    "Ano",;
     /* cmd especial  */    "",;
     /* default       */    "RIGHT(DTOC(DATE()),2)",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(proc2)~Necess rio informar ANO",;
     /* help do campo */    "Informe o ano correspondente ao processo.";
			 };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@D",;
     /* titulo        */    "Data ocorrˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPTY(ocorr_)~DATA OCORRENCIA n„o pode estar vazia",;
     /* help do campo */    "Entre com a Data de Ocorrˆncia";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "!!",;
     /* titulo        */    "Categoria",;
     /* cmd especial  */    "MTAB([PL=Plano|PD=Plano c/Diferen‡a|AF=Auxilio],[CATEGORIA])",;
     /* default       */    "[AF]",;
     /* pre-validacao */    "",;
     /* validacao     */    "categ $ [PL|PD|AF]~CATEGORIA n„o aceit vel",;
     /* help do campo */    "Preencha com:|PL para Plano,| PD p/Diferen‡a ou |AX para Aux.Funeral";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@!",;
     /* titulo        */    "Contrato",;
     /* cmd especial  */    "VDBF(6,3,20,77,'GRUPOS',{'codigo','grupo','nome','endereco'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(contrato,'GRUPOS',1).AND.CAD_04F9(op_menu).AND.(PTAB(contrato,'TAXAS',1).OR.PTAB(GRUPOS->grupo,'ARQGRUP',1).OR.1=1)~CONTRATO n„o existe em arquivo de tabela",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "",;
     /* titulo        */    "Parentesco",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o grau de parentesco deste com o falecido.";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@!",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "GRUPOS->nome",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nomedec)~Necess rio informar NOME",;
     /* help do campo */    "Entre com o nome do declarante";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@!",;
     /* titulo        */    "Rua Declarante",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o endere‡o do respons vel";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@!",;
     /* titulo        */    "Fone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do Telefone para contato|com o respons vel pela solicita‡„o do A.F.";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "",;
     /* titulo        */    "Falecido",;
     /* cmd especial  */    "VDBF(6,3,20,77,'INSCRITS',{'codigo','nome','nascto_'},1,'kinscf9()',[])",;
     /* default       */    "ALLTRIM(contrato)",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigofal,'INSCRITS',1).OR.EMPT(codigofal)~Necess rio informar C¢digo do FALECIDO ou|Tecle F8 para consulta.",;
     /* help do campo */    "Entre com o c¢digo do falecido";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "",;
     /* titulo        */    "Nome do falecido",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(PTAB(codigofal,'INSCRITS',1),INSCRITS->nome,[])",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(falecido)~Necess rio informar NOME DO FALECIDO",;
     /* help do campo */    "Entre com o nome do falecido";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "",;
     /* titulo        */    "Rua Residˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o endere‡o de residˆncia do Falecido";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "",;
     /* titulo        */    "Bairro Residˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o bairro de residˆncia";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "",;
     /* titulo        */    "Munic¡pio de residˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o nome do Munic¡pio de residˆncia";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "!!",;
     /* titulo        */    "UF Residˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "EMPTY(ESTRES).OR.VUF(ESTRES)~ESTADO RESIDENCIA N„o aceit vel",;
     /* help do campo */    "Entre com o estado de Residˆncia";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@D",;
     /* titulo        */    "Nascimento",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(PTAB(codigofal,'INSCRITS',1),INSCRITS->nascto_,CTOD([  /  /  ]))",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de nascimento do falecido.";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@D",;
     /* titulo        */    "Data falcto.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "falecto_<=DATE()~Informe uma data v lida para falecimento|Verifique a data do sistema.",;
     /* help do campo */    "Entre com a data de falecimento";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "99:99",;
     /* titulo        */    "Hora Falcto.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "!EMPTY(falecto_)",;
     /* validacao     */    "VHORA(horafal+':00')~HORA FALCTO. n„o aceit vel|Digite uma hora correta",;
     /* help do campo */    "";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "",;
     /* titulo        */    "Rua Falecimento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o endere‡o (Rua) onde|ocorreu o falecimento";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "",;
     /* titulo        */    "Munic¡pio de falecimento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o nome do munic¡pio";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "!!",;
     /* titulo        */    "UF falecto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "EMPTY(ESTFAL) .OR.VUF(ESTFAL)~ESTADO FALECIMENTO N„o aceit vel",;
     /* help do campo */    "Entre com o Estado onde ocorreu o falecimento";
			 };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@D",;
     /* titulo        */    "Data Sepultamento",;
     /* cmd especial  */    "",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data do sepultamento";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "99:99",;
     /* titulo        */    "Hora sepult.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VHORA(horasepult+':00')~HORA SEPULT. n„o aceit vel|digite uma hora correta",;
     /* help do campo */    "Informe a hora do sepultamento";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "",;
     /* titulo        */    "Cemit‚rio Sepultamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o n£mero do cemit‚rio de sepultamento";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "999",;
     /* titulo        */    "Func.Respons vel",;
     /* cmd especial  */    "VDBF(6,15,20,77,'FNCS',{'codigo','nome','profiss'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(funcresp,'FNCS',1).OR.EMPTY(funcresp)~Funcion rio n„o existe na tabela",;
     /* help do campo */    "Informe o funcion rio far |o registro ou F8 para consulta em tabela";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@D",;
     /* titulo        */    "Proc.pagto em",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Processar pagamento em...";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "99999999999.99",;
     /* titulo        */    "Valor Auxilio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor do Auxilio Funeral";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "@D",;
     /* titulo        */    "Pago em",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[009,O_CAMPO],{;            // AFUNER
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[009,O_FORMULA],{;          // AFUNER - Contratante
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(contrato,'GRUPOS',1),GRUPOS->nome,[]),[]),30)",;
     /* lin da formula*/    3,;
     /* col da formula*/    28;
                         };
)
AADD(sistema[009,O_FORMULA],{;          // AFUNER - Endere‡o Contr.
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(contrato,'GRUPOS',1),xDECRIPT(GRUPOS->endereco),[]),[]),35)",;
     /* lin da formula*/    4,;
     /* col da formula*/    28;
                         };
)
AADD(sistema[009,O_FORMULA],{;          // AFUNER - Func.Resp.
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(funcresp,[FNCS]),FNCS->nome,[ ]),[]),30)",;
     /* lin da formula*/    16,;
     /* col da formula*/    32;
                         };
)
AADD(sistema[009,O_FORMULA],{;          // AFUNER - Categoria
     /* form mostrar  */    "LEFT(TRAN(IIF(categ=[PD],[Plano c/Difer. ],IIF(categ=[PL],[Atend.Plano],[Auxilio Funeral  ])),[]),18)",;
     /* lin da formula*/    1,;
     /* col da formula*/    56;
                         };
)
AADD(sistema[009,O_FORMULA],{;          // AFUNER - Filial
     /* form mostrar  */    "LEFT(TRAN(IIF(EMPT(filial),M->p_filial,filial),[@!]),02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    23;
                         };
)
AADD(sistema[009,O_FORMULA],{;          // AFUNER - Seguro?
     /* form mostrar  */    "LEFT(filial,02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    23;
                         };
)


sistema[010]={;
            "Documento … Imprimir",;                        // opcao do menu
            "Documento … Imprimir",;                        // titulo do sistema
            {"idmaq+base","codlan"},;                       // chaves do arquivo
            {"Esta‡„o","Cod.Lanc"},;                        // titulo dos indices para consulta
            {"0102","04"},;                                 // ordem campos chaves
            {"IMPPAR",drvdbf,drvntx},;                      // nome do DBF
            {"IMPPAR1","IMPPAR2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,8,19,72,3,8},;                           // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
	    {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[010,O_CAMPO],{;            // IMPPAR
     /* mascara       */    "@!",;
     /* titulo        */    "Esta‡„o",;
     /* cmd especial  */    "M->ide_maq",;
     /* default       */    "PADR(SUBSTR(M->ide_maq,2),4)",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(idmaq)~Necess rio informar Esta‡„o|Tecle F8",;
     /* help do campo */    "Informe o nome da esta‡„o|tecle F8 para preencher autom tico";
                         };
)
AADD(sistema[010,O_CAMPO],{;            // IMPPAR
     /* mascara       */    "@!",;
     /* titulo        */    "Base",;
     /* cmd especial  */    "MTAB([AFU-Aux.funeral|BXR-Baixa Recep‡„o|OBX-Outros Receb.],[BASE])",;
     /* default       */    "[BXR]",;
     /* pre-validacao */    "",;
     /* validacao     */    "base $ [AFU|BXR|OBX]~BASE n„o aceit vel,tecle F8",;
     /* help do campo */    "Informe a Base de Dados|tecle F8 para busca em tabela";
                         };
)
AADD(sistema[010,O_CAMPO],{;            // IMPPAR
     /* mascara       */    "",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Digite neste campo o n£mero de|identifica‡„o do documento|(N„o utilize barras nem tra‡os)";
                         };
)
AADD(sistema[010,O_CAMPO],{;            // IMPPAR
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[010,O_FORMULA],{;          // IMPPAR - processo falec.
     /* form mostrar  */    "LEFT(TRAN(IMP_01F9(),[]),35)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    28;
                         };
)


sistema[011]={;
            "Credenciados",;                                // opcao do menu
            "Cadastro de Credenciados",;                    // titulo do sistema
	    {"codbenefic","nome","oldespec+cidade+nome"},;               // chaves do arquivo
	    {"Codigo","M‚dico","Especialidade"},;            // titulo dos indices para consulta
	    {"02","12","071512"},;                            // ordem campos chaves
	    {"MEDICOS",drvdbf,drvntx},;                     // nome do DBF
	    {"MEDICOS1","MEDICOS2","MEDICOS3"},;            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,0,8,24,73},;                               // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Ai",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ai)~Necess rio informar AI",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Codbenefic",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(codbenefic)~Necess rio informar CODBENEFIC",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Oldescrito",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(oldescrito)~Necess rio informar OLDESCRITO",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Oldclasse",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(oldclasse)~Necess rio informar OLDCLASSE",;
     /* help do campo */    "";
			 };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Prioridade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(prioridade)~Necess rio informar PRIORIDADE",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "!!",;
     /* titulo        */    "Situa‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(status)~Necess rio informar SITUA€ŽO",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Oldespec",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(oldespec)~Necess rio informar OLDESPEC",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@S35",;
     /* titulo        */    "Detalhes",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(detalhes)~Necess rio informar DETALHES",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@S35",;
     /* titulo        */    "Vantagens",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(vantagens)~Necess rio informar VANTAGENS",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@S35",;
     /* titulo        */    "Condicoes",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(condicoes)~Necess rio informar CONDICOES",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@S35",;
     /* titulo        */    "Informutil",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(informutil)~Necess rio informar INFORMUTIL",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar NOME",;
     /* help do campo */    "Informe o nome do M‚dico";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(bairro)~Necess rio informar BAIRRO",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf)~UNIDADE DA FEDERA€ŽO inv lida",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Contato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(contato)~Necess rio informar CONTATO",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fonecom1)~Necess rio informar TELEFONE",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Fonecom2",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fonecom2)~Necess rio informar FONECOM2",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Fonecel",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fonecel)~Necess rio informar FONECEL",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Foneres1",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(foneres1)~Necess rio informar FONERES1",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Email",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(email)~Necess rio informar EMAIL",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Fax",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fax)~Necess rio informar FAX",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Bip",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(bip)~Necess rio informar BIP",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@!",;
     /* titulo        */    "Fonesdiv",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fonesdiv)~Necess rio informar FONESDIV",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@D",;
     /* titulo        */    "Datainc",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(datainc)~Necess rio informar DATAINC",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "@D",;
     /* titulo        */    "Dataalt",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(dataalt)~Necess rio informar DATAALT",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Codcidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(codcidade)~Necess rio informar CODCIDADE",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Contrato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(contrato)~Necess rio informar CONTRATO",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Flagetq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(flagetq)~Necess rio informar FLAGETQ",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "",;
     /* titulo        */    "Codclasse",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(codclasse)~Necess rio informar CODCLASSE",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_CAMPO],{;            // MEDICOS
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[011,O_FORMULA],{;          // MEDICOS - porc.desconto
     /* form mostrar  */    "LEFT(TRAN(STR(ultvalor/valorpart*100,6,2),[]),06)",;
     /* lin da formula*/    0,;
     /* col da formula*/    0;
                         };
)


sistema[012]={;
            "Especialidades",;                              // opcao do menu
            "Especialidades",;                              // titulo do sistema
            {"especialid","codlan"},;                       // chaves do arquivo
            {"Por Especialidade","Cod.Lanc"},;              // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            {"TESPEC",drvdbf,drvntx},;                      // nome do DBF
            {"TESPEC1","TESPEC2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,20,21,61,3,10},;                         // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[012,O_CAMPO],{;            // TESPEC
     /* mascara       */    "@!",;
     /* titulo        */    "Especialidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(especialid)~Necess rio informar ESPECIALIDADE",;
     /* help do campo */    "Informe a|Especialidade/Categoria Profissional.";
                         };
)
AADD(sistema[012,O_CAMPO],{;            // TESPEC
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[013]={;
            "Parƒmetro de Juros",;                          // opcao do menu
            "Parƒmetro de Juros",;                          // titulo do sistema
            {"tipo"},;                                      // chaves do arquivo
            {"Tipo"},;                                      // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            {"JUROS",drvdbf,drvntx},;                       // nome do DBF
            {"JUROS1"},;                                    // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,17,17,66,4,5},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {3,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[013,O_CAMPO],{;            // JUROS
     /* mascara       */    "9",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia |2=Taxa |3=Carnˆ|4=Acerto],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(tipo)~TIPO n„o aceit vel|Deve ser n£mero positivo",;
     /* help do campo */    "Qual o tipo de lan‡amento";
                         };
)
AADD(sistema[013,O_CAMPO],{;            // JUROS
     /* mascara       */    "99.99",;
     /* titulo        */    "Multa %",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "multa>=0~MULTA % n„o aceit vel",;
     /* help do campo */    "Informe a porcentagem de multa";
                         };
)
AADD(sistema[013,O_CAMPO],{;            // JUROS
     /* mascara       */    "999",;
     /* titulo        */    "Carˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "mltcaren>=0~CARENCIA n„o aceit vel",;
     /* help do campo */    "Informe a carˆncia para a |aplica‡„o da multa|em dias.";
                         };
)
AADD(sistema[013,O_CAMPO],{;            // JUROS
     /* mascara       */    "9.999",;
     /* titulo        */    "Juros %",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "juros>=0~JUROS % n„o aceit vel|deve ser maior ou igual a zeros|(Juros Di rios)",;
     /* help do campo */    "Informe a porcentagem do Juros di rios";
                         };
)
AADD(sistema[013,O_CAMPO],{;            // JUROS
     /* mascara       */    "999",;
     /* titulo        */    "Carˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "jrscaren>=0~CARENCIA n„o aceit vel|deve ser maior ou igual a zeros",;
     /* help do campo */    "Informe a carˆncia para a |aplica‡„o do juros|em dias.";
                         };
)


sistema[014]={;
            "Filiais",;                                     // opcao do menu
            "Filiais",;                                     // titulo do sistema
            {"codigo"},;                                    // chaves do arquivo
            {"C¢digo"},;                                    // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            {"TFILIAIS",drvdbf,drvntx},;                    // nome do DBF
            {"TFILIAI1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,8,16,74},;                               // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"},;// condicao de exclusao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"},;// condicao de alteracao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"};// condicao de recupercao de registros
           }

AADD(sistema[014,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@!",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(codigo)~Necess rio informar C¢DIGO",;
     /* help do campo */    "Informe o c¢digo da filial";
                         };
)
AADD(sistema[014,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "",;
     /* titulo        */    "Abreviatura",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(abrev)~Necess rio informar ABREVIATURA",;
     /* help do campo */    "Dˆ um nome abreviado para a filial|Ser  utilizada para identifica‡Æo nas telas";
                         };
)
AADD(sistema[014,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@!",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar NOME",;
     /* help do campo */    "Entre com o nome da filial";
                         };
)
AADD(sistema[014,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@!",;
     /* titulo        */    "Endereco",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[014,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[014,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@S35",;
     /* titulo        */    "Ref",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[014,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@!",;
     /* titulo        */    "Contato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(contato)~Necess rio informar CONTATO",;
     /* help do campo */    "";
                         };
)


sistema[015]={;
            "Grupos",;                                      // opcao do menu
            "Grupos",;                                      // titulo do sistema
            {"grup"},;                                      // chaves do arquivo
            {"Grupo"},;                                     // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            {"ARQGRUP",drvdbf,drvntx},;                     // nome do DBF
            {"ARQGRUP1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,15,22,62},;                              // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(grup)~Necess rio informar GRUPO",;
     /* help do campo */    "Entre com o c¢digo do Grupo";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "99",;
     /* titulo        */    "Classe",;
     /* cmd especial  */    "VDBF(6,38,20,77,'CLASSES',{'classcod','descricao','contrat'},1,'classcod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(classe,'CLASSES',1)~CLASSE n„o existe na tabela",;
     /* help do campo */    "Informe a categoria dos planos deste grupo.|Para grupo VIP, digite 00";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999999",;
     /* titulo        */    "Nr.Inicial",;
     /* cmd especial  */    "",;
     /* default       */    "IF(classe=[00],[000001],STRZERO(VAL(M->lastcodigo)+1,6))",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999999",;
     /* titulo        */    "Nr.Final",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(classe=[00],[999999],STRZERO(VAL(inicio)+CLASSES->contrat-1,6))",;
     /* pre-validacao */    "",;
     /* validacao     */    "VAL(final)>VAL(inicio)~NR.FINAL n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "99",;
     /* titulo        */    "N§.Processos",;
     /* cmd especial  */    "",;
     /* default       */    "INT((1+VAL(final)-VAL(inicio))/50)",;
     /* pre-validacao */    "!(CLASSES->prior=[S])",;
     /* validacao     */    "!(acumproc<0)~N§.PROCESSOS n„o aceit vel",;
     /* help do campo */    "Informe quantos processos s„o nescess rios|para se emitir recibos.";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "99",;
     /* titulo        */    "N§.Processos",;
     /* cmd especial  */    "",;
     /* default       */    "acumproc",;
     /* pre-validacao */    "!(CLASSES->prior=[S])",;
     /* validacao     */    "maxproc>=acumproc~N§.PROCESSOS n„o aceit vel|Informe o n£mero m ximo de processos |a se incluir na circular",;
     /* help do campo */    "Informe o n£mero m ximo de processos|para se emitir na cobran‡a.";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "!",;
     /* titulo        */    "Comp.AdmissXAtend.",;
     /* cmd especial  */    "",;
     /* default       */    "[S]",;
     /* pre-validacao */    "acumproc<maxproc",;
     /* validacao     */    "cpadmiss$[SN]~Digite S ou N|S, n„o ser„o incluidos atendimentos|efetuados antes da admiss„o do contrato.",;
     /* help do campo */    "Se digitar S, n„o ser„o incluidos atendimentos|efetuados antes da admiss„o do contrato|quando da 1¦Cobran‡a.";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999",;
     /* titulo        */    "Periodicidade",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(CLASSES->prior=[S],30,INT((VAL(final)-VAL(inicio)+1)*90/500))",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(periodic<0)~PERIODICIDADE n„o aceit vel",;
     /* help do campo */    "Informe o intervalo m¡nimo em dias entre circulares.";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999",;
     /* titulo        */    "Remido",;
     /* cmd especial  */    "",;
     /* default       */    "acumproc*5",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(qtdremir<0)~REMIDO n„o aceit vel",;
     /* help do campo */    "Entre com o n§ de taxas nescess rias para que|o processo fique remido.";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "!",;
     /* titulo        */    "P/Atend.",;
     /* cmd especial  */    "",;
     /* default       */    "[S]",;
     /* pre-validacao */    "",;
     /* validacao     */    "poratend$[SN]~Digite|S para deixar de ser remido na utiliza‡„o|ou|N para continuar remido.",;
     /* help do campo */    "Digite S para considerar uma quantidade|a ser paga por atendimento efetuado|ou N para considerar quantidade total.";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999",;
     /* titulo        */    "Ultcirc",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "@D",;
     /* titulo        */    "Emissao",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999",;
     /* titulo        */    "Processos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999999",;
     /* titulo        */    "Contratos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999999",;
     /* titulo        */    "Partic.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[015,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999",;
     /* titulo        */    "N§Proxima Circ.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "proxcirc>=ultcirc.OR.proxcirc=[000]~A Pr¢xima circular deve ser maior|ou igual a| £ltima emitida ou zeros p/ n„o emitir.",;
     /* help do campo */    "Entre com o n£mero da pr¢xima circular ou|zeros se n„o for emitir.";
                         };
)
AADD(sistema[015,O_FORMULA],{;          // ARQGRUP - Classe/Categor.
     /* form mostrar  */    "LEFT(TRAN(CLASSES->descricao,[]),25)",;
     /* lin da formula*/    2,;
     /* col da formula*/    17;
                         };
)
AADD(sistema[015,O_FORMULA],{;          // ARQGRUP - Ultcirc
     /* form mostrar  */    "LEFT(TRAN(ultcirc,[999]),03)",;
     /* lin da formula*/    13,;
     /* col da formula*/    19;
                         };
)
AADD(sistema[015,O_FORMULA],{;          // ARQGRUP - Emissao
     /* form mostrar  */    "LEFT(TRAN(emissao_,[@D]),08)",;
     /* lin da formula*/    13,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[015,O_FORMULA],{;          // ARQGRUP - Processos
     /* form mostrar  */    "LEFT(TRAN(procpend,[999]),03)",;
     /* lin da formula*/    15,;
     /* col da formula*/    10;
                         };
)
AADD(sistema[015,O_FORMULA],{;          // ARQGRUP - Contratos
     /* form mostrar  */    "LEFT(TRAN(contrat,[999999]),06)",;
     /* lin da formula*/    14,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[015,O_FORMULA],{;          // ARQGRUP - Partic.
     /* form mostrar  */    "LEFT(TRAN(partic,[999999]),06)",;
     /* lin da formula*/    14,;
     /* col da formula*/    27;
                         };
)


sistema[016]={;
            "Regi”es",;                                     // opcao do menu
            "Regi”es",;                                     // titulo do sistema
            {"codigo","regiao"},;                           // chaves do arquivo
            {"p/C¢digo","Nome"},;                           // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            {"REGIAO",drvdbf,drvntx},;                      // nome do DBF
            {"REGIAO1","REGIAO2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,14,15,67,3,4},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"},;// condicao de exclusao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"},;// condicao de alteracao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"};// condicao de recupercao de registros
           }

AADD(sistema[016,O_CAMPO],{;            // REGIAO
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[016,O_CAMPO],{;            // REGIAO
     /* mascara       */    "",;
     /* titulo        */    "Descri‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(regiao)~Necess rio informar a REGIAO",;
     /* help do campo */    "Informe o nome do bairro, distrito ou regi„o";
                         };
)
AADD(sistema[016,O_CAMPO],{;            // REGIAO
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,11,20,77,'COBRADOR',{'cobrador','nome','cidade'},1,'cobrador')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1).OR.EMPT(cobrador)~Necess rio informar COBRADOR",;
     /* help do campo */    "Informe o c¢digo do cobrador.|F8 consulta em tabela.";
                         };
)


sistema[017]={;
            "Cobradores/Vendedores",;                       // opcao do menu
            "Cobradores/Vendedores",;                       // titulo do sistema
            {"cobrador"},;                                  // chaves do arquivo
            {"C¢digo"},;                                    // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            {"COBRADOR",drvdbf,drvntx},;                    // nome do DBF
            {"COBRADO1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,15,16,66},;                              // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "COB_01F9()",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cobrador)~Necess rio informar COBRADOR",;
     /* help do campo */    "Informe um c¢digo para o cobrador.";
                         };
)
AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "!",;
     /* titulo        */    "Fun‡„o",;
     /* cmd especial  */    "MTAB([Cobrador|Vendedor|Supervisor],[FUN€ŽO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "funcao $ [CVS]~FUN€ŽO n„o aceit vel",;
     /* help do campo */    "Informe se ‚ um Cobrador ou Vendedor|";
                         };
)
AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "",;
     /* titulo        */    "Nome do Cobrador",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar NOME DO COBRADOR",;
     /* help do campo */    "";
                         };
)
AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VDV2(cpf).OR.EMPT(cpf)~CPF n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "@S35",;
     /* titulo        */    "Observa‡Æo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "999.9",;
     /* titulo        */    "Percentual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(percent<0).AND.!(percent>100)~PERCENTUAL n„o aceit vel",;
     /* help do campo */    "Informe o percentual de comiss„o";
                         };
)
AADD(sistema[017,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "!!!",;
     /* titulo        */    "Supervisor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Digite o c¢digo do SUPERVISOR deste cobrador";
                         };
)
AADD(sistema[017,O_FORMULA],{;          // COBRADOR - Fun‡„o
     /* form mostrar  */    "LEFT(TRAN(SUBSTR([Cobrador  |Vendedor  |Supervisor],AT(funcao,[Cobrador  |Vendedor  |Supervisor]),10),[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    35;
                         };
)


sistema[018]={;
            "Categoria dos Planos",;                        // opcao do menu
            "Categoria dos Planos",;                        // titulo do sistema
            {"classcod"},;                                  // chaves do arquivo
            {"Classe"},;                                    // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            {"CLASSES",drvdbf,drvntx},;                     // nome do DBF
            {"CLASSES1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,12,21,68},;                              // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(classcod)~Necess rio informar C¢DIGO",;
     /* help do campo */    "Informe um c¢digo para esta categoria";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "@!",;
     /* titulo        */    "Descri‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(descricao)~Informe uma descri‡„o deste tipo de contrato.",;
     /* help do campo */    "Informe o nome desta categoria. Ex.: POPULAR, ESPECIAL,...";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "999999",;
     /* titulo        */    "Contratos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero de contratos desta categoria|Para categoria VIP, desconsidere esta informa‡„o";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "!",;
     /* titulo        */    "Prior",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "prior$' SN'~Necess rio informar PRIORIDADE",;
     /* help do campo */    "Os contratos enquadrados nesta categoria|ter„o cobran‡as emitidas periodicamente,|independente de n§ de falecimentos do grupo?";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99999999.99",;
     /* titulo        */    "Valor da J¢ia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(VLjoia<0.00)~Valor da j¢ia deve ser positivo",;
     /* help do campo */    "Informe o valor da J¢ia do contrato";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99",;
     /* titulo        */    "N§Parcelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "vljoia>0",;
     /* validacao     */    "!(nrparc<0)~NR.Parcelas n„o aceit vel",;
     /* help do campo */    "A j¢ia pode ser parcelada em quantas vezes?";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99",;
     /* titulo        */    "N§Parcelas",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "vljoia>0",;
     /* validacao     */    "!(parcger<1 .OR. parcger>nrparc)~NR.Parcelas a gerar n„o aceit vel|",;
     /* help do campo */    "Gerar a partir da parcela de J¢ia de n§...";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99999999.99",;
     /* titulo        */    "Valor Mensal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(VLmensal<0.00)~Valor da mensal deve ser positivo",;
     /* help do campo */    "Informe o valor mensal do contrato";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99999999.99",;
     /* titulo        */    "V.p/Dependente",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(VLdepend<0.00)~Valor mensal cobrado a mais por|dependente deve ser maior ou igual a zeros",;
     /* help do campo */    "Informe o valor a ser acrescido por dependente";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99",;
     /* titulo        */    "V lidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(nrmesval<0)~Validade n„o aceit vel",;
     /* help do campo */    "Contratos v lidos por quantos meses?";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "!",;
     /* titulo        */    "RenVencto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "renvenc$[ SN]~RENVENCTO n„o aceit vel",;
     /* help do campo */    "Os contratos terÆo|renova‡Æo automatica no vencimento?";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "!",;
     /* titulo        */    "RenUso",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "renuso$[ SN]~RENUSO n„o aceit vel",;
     /* help do campo */    "Os contratos terÆo|renova‡Æo automatica quando|utilizarem os servi‡os de atendimento/Auxilio?";
                         };
)
AADD(sistema[018,O_CAMPO],{;            // CLASSES
     /* mascara       */    "@E 99,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[018,O_FORMULA],{;          // CLASSES - Valor
     /* form mostrar  */    "LEFT(TRAN(vltotal,[@E 99,999,999.99]),13)",;
     /* lin da formula*/    16,;
     /* col da formula*/    39;
                         };
)
AADD(sistema[018,O_FORMULA],{;          // CLASSES - Valor da J¢ia
     /* form mostrar  */    "LEFT(TRAN((vljoia/vltotal)*100,[999.99]),06)",;
     /* lin da formula*/    9,;
     /* col da formula*/    29;
                         };
)
AADD(sistema[018,O_FORMULA],{;          // CLASSES - Valor Mensal
     /* form mostrar  */    "LEFT(TRAN((vlmensal/vltotal)*100,[999.99]),06)",;
     /* lin da formula*/    11,;
     /* col da formula*/    29;
                         };
)
AADD(sistema[018,O_FORMULA],{;          // CLASSES - V.p/Dependente
     /* form mostrar  */    "LEFT(TRAN((vldepend/vltotal)*100,[999.99]),06)",;
     /* lin da formula*/    12,;
     /* col da formula*/    29;
                         };
)


sistema[019]={;
            "Circulares",;                                  // opcao do menu
            "Circulares",;                                  // titulo do sistema
            {"grupo+circ"},;                                // chaves do arquivo
            {"Grupo/Circular"},;                            // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            {"CIRCULAR",drvdbf,drvntx},;                    // nome do DBF
            {"CIRCULA1"},;                                  // nomes dos NTX
            {"CPRCIRC"},;                                   // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,7,15,18,66},;                              // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(grupo,'ARQGRUP',1).and.PTAB(ARQGRUP->classe,'CLASSES',1)~GRUPO ou Classe lan‡ada no Grupo|n„o existe na tabela.",;
     /* help do campo */    "Informe o grupo";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "STRZERO(VAL(ARQGRUP->proxcirc),3)",;
     /* default       */    "STRZERO(VAL(ARQGRUP->proxcirc),3)",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero da CIRCULAR a emitir.";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "99",;
     /* titulo        */    "Procpend",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@D",;
     /* titulo        */    "Emiss„o",;
     /* cmd especial  */    "",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao_)~Necess rio informar EMISSŽO",;
     /* help do campo */    "Data da Emiss„o da Circular";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Mˆs Ref.",;
     /* cmd especial  */    "",;
     /* default       */    "SUBSTR(DTOC(emissao_),4,2)+RIGHT(DTOC(emissao_),2)",;
     /* pre-validacao */    "",;
     /* validacao     */    "MMAA(mesref)~MES REF. n„o aceit vel",;
     /* help do campo */    "Entre com o mˆs de referˆncia desta circular.";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~VALOR n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@S35",;
     /* titulo        */    "Mensagem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com uma mensagem exclusiva … ‚sta circular.";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "",;
     /* titulo        */    "Mensagem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com uma mensagem exclusiva … ‚sta circular.";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "",;
     /* titulo        */    "Mensagem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com uma mensagem exclusiva … ‚sta circular.";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "999999",;
     /* titulo        */    "Emitidos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "999999",;
     /* titulo        */    "Pagos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "999999",;
     /* titulo        */    "Cancelados",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@D",;
     /* titulo        */    "Lancamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "",;
     /* titulo        */    "Usu rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[019,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@D",;
     /* titulo        */    "Impress„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[019,O_FORMULA],{;          // CIRCULAR - Descri‡„o
     /* form mostrar  */    "LEFT(TRAN(IIF(CLASSES->prior=[S],[Valor por mˆs......:],IIF(ARQGRUP->maxproc>ARQGRUP->acumproc,[Valor p/atendimento:],[Valor da circular.:])),[]),18)",;
     /* lin da formula*/    3,;
     /* col da formula*/    2;
                         };
)

* \\ Final de ADR_ATR1.PRG
