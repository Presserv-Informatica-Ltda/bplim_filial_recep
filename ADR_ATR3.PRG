
procedure adr_atr3
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Presserv Informatica Ltda (19)99886.3225
 \ Programa: ADR_ATR3.PRG
 \ Data....: 01-05-98
 \ Sistema.: Administradora - RECEPÄÑO
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \ Convert.: v5.0 em 2021081014:58:00 Fase_01
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas


sistema[33]={;
            "Mensagem p/Contrato",;                         // opcao do menu
            "Mensagem p/Contrato",;                         // titulo do sistema
            {"seq","codigo"},;                              // chaves do arquivo
            {"Sequencia","Contrato"},;                      // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            {"MENSAG",drvdbf,drvntx},;                      // nome do DBF
            {"MENSAG1","MENSAG2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,9,13,14,67},;                              // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[33,O_CAMPO],{;            // MENSAG
     /* mascara       */    "999999",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[33,O_CAMPO],{;            // MENSAG
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo,'GRUPOS',1)~Contrato cancelado |ou inexistente",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[33,O_CAMPO],{;            // MENSAG
     /* mascara       */    "",;
     /* titulo        */    "Mens1",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(mens1)~Necess†rio informar a primeira linha de mensagen|Tecle ESC para cancelar.",;
     /* help do campo */    "Informe a mensagem a imprimir na cobranáa|Vocà tem tràs linhas com atÇ 80 caracteres.";
                         };
)
AADD(sistema[33,O_CAMPO],{;            // MENSAG
     /* mascara       */    "@D",;
     /* titulo        */    "Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[33,O_CAMPO],{;            // MENSAG
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[33,O_FORMULA],{;          // MENSAG - Nome
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[]),35)",;
     /* lin da formula*/    2,;
     /* col da formula*/    18;
                         };
)
AADD(sistema[33,O_FORMULA],{;          // MENSAG - Lanáamento
     /* form mostrar  */    "LEFT(TRAN(lancto_,[@D]),08)",;
     /* lin da formula*/    1,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[33,O_FORMULA],{;          // MENSAG - Por
     /* form mostrar  */    "LEFT(TRAN(por,[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    42;
                         };
)


sistema[34]={;
            "Pgtos / Recebtos",;                            // opcao do menu
            "Ordens Pgto/Recto",;                           // titulo do sistema
            {"numop","numconta+historico+DTOS(fechto_)","codlan"},;// chaves do arquivo
            {"p/N£mero","p/Conta","Cod.Lanc"},;             // titulo dos indices para consulta
            {"01","050613","19"},;                          // ordem campos chaves
            {"ORDPGRC",drvdbf,drvntx},;                      // nome do DBF
            {"ORDPGRC1","ORDPGRC2","ORDPGRC3"},;            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,7,12,20,71},;                              // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "999999",;
     /* titulo        */    "Nß O.P.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(numop)~Necess†rio informar Nß O.P.",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "!!!",;
     /* titulo        */    "Origem",;
     /* cmd especial  */    "MTAB([ADMinistradora|FUNer†ria|CONvenio|ESToque|FINanceiro|VIAtura],[ORIGEM])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "origem $ [ADM|FUN|CON|EST|FIN|VIA]~ORIGEM nÑo aceit†vel",;
     /* help do campo */    "Informe o prefixo do sistema que|gerou o lanáamento";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@D",;
     /* titulo        */    "Lancto_",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@!",;
     /* titulo        */    "Conta",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(numconta)~Campo obrigat¢rio!|Identifique a Conta/Cadastro com um n£mero | ou nome qualquer.",;
     /* help do campo */    "Informe a conta que receber† este lanáamento.";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$']+origem+[   '])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "EMPT(historico).OR.PTAB(historico,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento.";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "!",;
     /* titulo        */    "DÇb/CrÇd",;
     /* cmd especial  */    "MTAB([DÇbito|CrÇdito],[DêB/CRêD])",;
     /* default       */    "HISTORIC->tipo",;
     /* pre-validacao */    "",;
     /* validacao     */    "debcred$[CD]~Necess†rio informar DêB/CRêD",;
     /* help do campo */    "Se for um documento a pagar ser† D, senÑo C";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "99999999.99",;
     /* titulo        */    "Valor Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(VALORtotal<0.00)~VALOR TOTAL DO LANÄAMENTO| deve ser positivo ou zeros",;
     /* help do campo */    "Entre com o valor total do documento,|se valor = zero, ser† apenas agendado.";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@D",;
     /* titulo        */    "Vencto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(vencto_)~Necess†rio informar VENCTO",;
     /* help do campo */    "Entre com a data do vencimento deste.";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@!",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPTY(documento)~Digite algo para identificar o documento",;
     /* help do campo */    "Entre com o n£mero do documento";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "99999",;
     /* titulo        */    "NßDoctos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(nrdoctos<0)~NßDOCTOS nÑo aceit†vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@!",;
     /* titulo        */    "Complemento de Hist¢rico",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(complement)~Entre com uma informaáÑo que diferencie este|lanáamento de outros com mesmo hist¢rico.",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@D",;
     /* titulo        */    "Fechto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "",;
     /* titulo        */    "Fechpor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@D",;
     /* titulo        */    "Autorizado em",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "",;
     /* titulo        */    "Autorizado",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "9999999",;
     /* titulo        */    "Lanáamento Nß",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_FORMULA],{;          // ORDPGRC - DescriáÑo de Hi
     /* form mostrar  */    "LEFT(TRAN(HISTORIC->descricao,[]),40)",;
     /* lin da formula*/    5,;
     /* col da formula*/    17;
                         };
)


sistema[35]={;
            "ParÉmetros",;                                  // opcao do menu
            "ParÉmetros do sistema",;                       // titulo do sistema
            {},;                                            // chaves do arquivo
            {},;                                            // titulo dos indices para consulta
            {},;                                            // ordem campos chaves
            {"PAR_ADM",drvdbf,drvntx},;                      // nome do DBF
            {},;                                            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,2,8,23,71},;                               // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o c¢digo da filial";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "9",;
     /* titulo        */    "Inscr.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Verificar Pagas?",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Repetir lanáamento?",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Maior Contrato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "000000",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Nrreint",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "Conta Recepcao",;
     /* cmd especial  */    "",;
     /* default       */    "[RECEP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(contarec)~Necess†rio informar CONTA RECEPCAO p/recebimentos",;
     /* help do campo */    "Informe a Conta que receber†|os lanáamentos da recepáÑo.";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "Conta Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "[RECEP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(contapag)~Necess†rio informar CONTA RECEPCAO p/Pagamentos",;
     /* help do campo */    "Informe a Conta que pagar†|os lanáamentos da recepáÑo.";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "[001]",;
     /* pre-validacao */    "",;
     /* validacao     */    "histrcfcc=[000].OR. PTAB(histrcfcc,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento de|recebimento de FCC.";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "[002]",;
     /* pre-validacao */    "",;
     /* validacao     */    "histrcrec=[000].OR. PTAB(histrcrec,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento|para taxas recebidas na RecepáÑo.";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "[004]",;
     /* pre-validacao */    "",;
     /* validacao     */    "histrccar=[000].OR. PTAB(histrccar,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento|para parcelas recebidas na RecepáÑo.";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "[003]",;
     /* pre-validacao */    "",;
     /* validacao     */    "histpg=[000].OR. PTAB(histpg,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico|para lanáamento de pagamentos.";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99-999999",;
     /* titulo        */    "Nß Recibo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nrauxrec)~Necess†rio informar Nß RECIBO",;
     /* help do campo */    "Informe o n£mero do recibo a imprimir.|no formato AA-NNNNNN|onde: AA=Ano, N=n£mero";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo',[situacao=1])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(mcodigo,'GRUPOS',1).AND.PTAB(mcodigo,'TAXAS',1).OR.mcodigo=[00000]~C¢digo inv†lido ou sem Taxas pendentes",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnà|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnà+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "mtipo $ [123678]~TIPO nÑo aceit†vel",;
     /* help do campo */    "Qual o tipo de lanáamento";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "VDBF(6,22,20,77,'TAXAS',{'codigo','circ','emissao_','valor','valorpg','forma'},1,'circ',[])",;
     /* default       */    "",;
     /* pre-validacao */    "!(mcodigo=[00000])",;
     /* validacao     */    "PTAB(mcodigo+mcirc,'TAXAS',1).AND.PTAB(GRUPOS->grupo+mcirc,'CIRCULAR',1)~Necess†rio informar CIRCULAR existente",;
     /* help do campo */    "N£mero da Circular|Mantido pela emissao de recibos";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!",;
     /* titulo        */    "Grup",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "EMPT(mgrupvip).OR.PTAB(mgrupvip,'ARQGRUP',1)~GRUP nÑo existe na tabela",;
     /* help do campo */    "Entre com o c¢digo do Grupo que ser† utilizado|como controle dos contratos VIPs.";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Combarra",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "combarra$'SN '~COMBARRA nÑo aceit†vel|Digite S ou N",;
     /* help do campo */    "Informe se os recibos devem ser impressos|com o c¢digo de barras";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Com Inscritos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "cinscr$'SN '~Digite S ou N",;
     /* help do campo */    "Informe se os Inscritos est∆o cadastrados";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Com Recibo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "comfalec$'SN '~Digite S para imprimir recibos| ou| N para utilizar autenticacÑo.",;
     /* help do campo */    "Informe se a recepá∆o utiliza recibo|ou|autenticaá∆o";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99999",;
     /* titulo        */    "Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99",;
     /* titulo        */    "Ano",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!",;
     /* titulo        */    "Mproc3",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99999/99/!!",;
     /* titulo        */    "Procimp",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Màs Ref.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Pnumfcc",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "Munic°pio",;
     /* cmd especial  */    "",;
     /* default       */    "[LIMEIRA]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(p_cidade)~Necess†rio informar MUNIC°PIO",;
     /* help do campo */    "Entre com o nome do Munic°pio";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Recibo PadrÑo",;
     /* cmd especial  */    "MTAB([S-Recibos em papÇl branco|N-Recibos prÇ-impressos],[RECIBO PADRéO])",;
     /* default       */    "[S]",;
     /* pre-validacao */    "",;
     /* validacao     */    "(p_recp$[SN ])~RECIBO PADRéO nÑo aceit†vel|Digite S, N ou deixe sem preencher.",;
     /* help do campo */    "Digite S para utilizar o modelo|Padronizado de recibos (formul†rio branco)|ou N para recibos personalizados";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Ident1",;
     /* cmd especial  */    "",;
     /* default       */    "[BIGNOTTO IND.DE URNAS LTDA]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(setup1)~Digite o nome da Empresa|Ser† utilizado em relat¢rios",;
     /* help do campo */    "Informe o nome da Empresa";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99.999.999/9999-99",;
     /* titulo        */    "CGC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VCGC(cgcsetup).or.EMPT(cgcsetup)~Necess†rio informar CGC",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Ident2",;
     /* cmd especial  */    "Informe o endereáo da Empresa",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(setup2)~Digite o endereáo,|ser† a 2¶ linha de cabeáalho|de alguns relat¢rios",;
     /* help do campo */    "Digite o endereáo.";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Setup3",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a 3¶ linha de cabeáalho.|Ex.: Telefone, Fax, etc...";
                         };
)
AADD(sistema[35,O_FORMULA],{;          // PAR_ADM - Desc.Pgto.
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histpg,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
     /* lin da formula*/    5,;
     /* col da formula*/    22;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // PAR_ADM - Desc.Recebto
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histrcrec,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
		 /* lin da formula*/    4,;
		 /* col da formula*/    22;
												 };
)
AADD(sistema[35,O_FORMULA],{;          // PAR_ADM - Desc.Receb.FCC
		 /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histrcfcc,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
		 /* lin da formula*/    3,;
		 /* col da formula*/    22;
												 };
)
AADD(sistema[35,O_FORMULA],{;          // PAR_ADM - DescriáÑo de Hi
		 /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histrccar,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
		 /* lin da formula*/    2,;
     /* col da formula*/    22;
                         };
)


sistema[36]={;
            "Senhas",;                                      // opcao do menu
            "Usu†rios do sistema",;                         // titulo do sistema
            {"pass"},;                                      // chaves do arquivo
            {""},;                                          // titulo dos indices para consulta
            {"02"},;                                        // ordem dos campos chvs
            {"ADRPW",drvdbf,drvntx},;                      // nome do DBF
            {ntxpw},;                                       // nome do NTX
            {},;                                            // nome dos DBF relacionados
            {},;                                            // campos de relacionamento
            {1,1,11,19,17,51},;                             // qde telas, tela atual, coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},; // campos  { mascara, titulo, when, critica }
            {},;// fromula { mascara, titulo, formula, linha, coluna }
            {"",""},;      // condicao de exclusao de registros
            {"",""},;      // condicao de alteracao de registros
            {"",""};       // condicao de recuperacao de registros
           }

msg="DIGITE INICIAIS DAS ROTINAS CERCEADAS AO USUèRIO|"+;
    "P. Procura    F. Filtragem    D. DigitaáÑo     ˇ|"+;
    "M. Modifica   E. Exclui       R. Recupera      ˇ|"+;
    "V. Và global  N. Nova coluna  A. Apaga coluna  ˇ|"+;
    "I. Imprime    O. Ordena       Q. Quantifica    ˇ|"+;
    "L. Localiza   G. Global       C. Congela Colunas|"+;
    "T. Tamanho    J. nova Janela ˇX. eXporta       ˇ|"+;
    "Z. totaliZa                                    ˇ|"
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "",;
     /* titulo        */    "Pass",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@!",;
     /* titulo        */    "Usu†rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPTY(nome)~Necess†rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "9",;
     /* titulo        */    "Nivel",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "MTAB([1. OperaáÑo ˇ|2. ManutenáÑo|3. Gerància ˇ],[N°VEL DE ACESSO])",;
     /* validacao     */    "nace$[123]~N°VEL DE ACESSO inv†lido",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Recebimento de Taxas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Consulta Contrato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Taxas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Endereáos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Outros Recebimentos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Lanáamento Aux.Funeral",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Taxas a Imprimir",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Documento Ö Imprimir",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "ParÉmetro de Juros",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Filiais",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Grupos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Cobranáas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Contratos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Outros Endereáos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Inscritos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Taxas a processar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Regiîes",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Cobradores/Vendedores",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Parcelas do Vendedor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Cobranáas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Categoria dos Planos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Produtos p/Categoria",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Circulares",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Processos da Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Processos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Funcion†rios",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Segurados",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Inscritos no Seguro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Sinistros",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Controle de Sinistro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Hist¢rico PadrÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Custos Adicionais",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Mensagem p/Contrato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Pgtos / Recebtos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[36,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "ParÉmetros",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)

* \\ Final de ADR_ATR3.PRG