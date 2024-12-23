procedure adr_atr2
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform†tica - Limeira (019)452.6623
 \ Programa: ADR_ATR2.PRG
 \ Data....: 29-01-04
 \ Sistema.: Administradora - RECEPÄÑO
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas


sistema[020]={;
            "Processos da Circular",;                       // opcao do menu
            "Processos da Circular",;                       // titulo do sistema
            {"grupo+circ+processo","DTOS(dfal)","DTOS(dfal)"},;// chaves do arquivo
            {"Grupo/Circular","p/Data","Grupo e Data"},;    // titulo dos indices para consulta
            {"010203","09","09"},;                          // ordem campos chaves
            {"CPRCIRC",drvdbf,drvntx},;                     // nome do DBF
            {"CPRCIRC1","CPRCIRC2","CPRCIRC3"},;            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"CIRCULAR->grupo","CIRCULAR->circ"},;          // campos de relacionamento
            {1,1,8,4,15,76,3,4},;                           // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[020,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[020,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[020,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "@R 99999/99/!!",;
     /* titulo        */    "Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(processo)~Necess†rio informar PROCESSO",;
     /* help do campo */    "Informe o n£mero do processo a incluir";
                         };
)
AADD(sistema[020,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "!!",;
     /* titulo        */    "Categoria",;
     /* cmd especial  */    "MTAB([PL=Plano|PD=Plano c/Diferenáa|AF=Auxilio],[CATEGORIA])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "categ $ [PL|PD|AF]~CATEGORIA nÑo aceit†vel",;
     /* help do campo */    "Preencha com:|PL para Plano,| PD p/Diferenáa ou |AX para Aux.Funeral";
                         };
)
AADD(sistema[020,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "999999",;
     /* titulo        */    "Num",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(num).AND.PTAB(num,'GRUPOS',1)~NUM nÑo existe na tabela",;
     /* help do campo */    "";
                         };
)
AADD(sistema[020,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "@!",;
     /* titulo        */    "Fal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fal)~Necess†rio informar FAL",;
     /* help do campo */    "";
                         };
)
AADD(sistema[020,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "@!",;
     /* titulo        */    "Ends",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[020,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "@!",;
     /* titulo        */    "Cids",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[020,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(dfal)~Necess†rio informar DATA",;
     /* help do campo */    "";
                         };
)
AADD(sistema[020,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[020,O_FORMULA],{;          // CPRCIRC - Nome
     /* form mostrar  */    "LEFT(TRAN(INSCRITS->nome,[]),35)",;
     /* lin da formula*/    0,;
     /* col da formula*/    0;
                         };
)


sistema[021]={;
            "Processos",;                                   // opcao do menu
            "Processos",;                                   // titulo do sistema
            {"processo+categ","grup+DTOS(dfal)","codlan"},; // chaves do arquivo
            {"p/Processo","Grupo+Data","Cod.Lanc"},;        // titulo dos indices para consulta
            {"0102","0413","14"},;                          // ordem campos chaves
            {"PRCESSOS",drvdbf,drvntx},;                    // nome do DBF
            {"PRCESSO1","PRCESSO2","PRCESSO3"},;            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,14,18,68},;                              // num telas/tela atual/coordenadas
            {0,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"EMPT(saiu)","J† emitido nas Taxas|Exclusao nao permitida"},;// condicao de exclusao de registros
            {"EMPT(saiu)","J† emitido nas Taxas|Alteraáao nao permitida"},;// condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@R 99999/99/!!",;
     /* titulo        */    "Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(processo)~Necess†rio informar PROCESSO",;
     /* help do campo */    "Informe o n£mero do processo a incluir";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "!!",;
     /* titulo        */    "Categoria",;
     /* cmd especial  */    "MTAB([PL=Plano|PD=Plano c/Diferenáa|AF=Auxilio],[CATEGORIA])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "categ $ [PL|PD|AF]~CATEGORIA nÑo aceit†vel",;
     /* help do campo */    "Preencha com:|PL para Plano,| PD p/Diferenáa ou |AX para Aux.Funeral";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "",;
     /* titulo        */    "Saiu",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Preencha com o n£mero da circular|ou|deixe em branco se ainda nÑo saiu em cobranáa";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "!!",;
     /* titulo        */    "Grup",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(grup).AND.PTAB(grup,'ARQGRUP',1)~GRUP nÑo existe na tabela",;
     /* help do campo */    "Pertence a qual grupo";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "999999",;
     /* titulo        */    "Num",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(num).AND.PTAB(num,'GRUPOS',1)~NUM nÑo existe na tabela",;
     /* help do campo */    "Qual contrato";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "9",;
     /* titulo        */    "Inscr.",;
     /* cmd especial  */    "MTAB(M->TBTIPGRAU,[INSCR.])",;
     /* default       */    "IIF(M->pgrau<[7],SUBSTR([1234567],VAL(M->pgrau),1),M->pgrau)",;
     /* pre-validacao */    "",;
     /* validacao     */    "grau $ [12345678].and.(PTAB(num,'INSCRITS',1).or.1=1)~INSCR. nÑo aceit†vel",;
     /* help do campo */    "Qual o grau de parentesco|Tecle F8 para consulta";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "99",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "grau>'6'",;
     /* validacao     */    "",;
     /* help do campo */    "Que sequencia";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Seg",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Nome do segurado/Contratante";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Ends",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Cids",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Fal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fal)~Necess†rio informar FAL",;
     /* help do campo */    "Nome do falecido";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Sep",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(sep)~Necess†rio informar SEP",;
     /* help do campo */    "Sepultado em";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Data do falecimento";
                         };
)
AADD(sistema[021,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[021,O_FORMULA],{;          // PRCESSOS - T.Carància
     /* form mostrar  */    "LEFT(TRAN(IIF(INSCRITS->tcarencia>dfal,[Carància do Inscrito],[]),[]),22)",;
     /* lin da formula*/    4,;
     /* col da formula*/    29;
                         };
)


sistema[022]={;
            "Funcion†rios",;                                // opcao do menu
            "Funcion†rios",;                                // titulo do sistema
            {"codigo"},;                                    // chaves do arquivo
            {"N£mero"},;                                    // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            {"FNCS",drvdbf,drvntx},;                        // nome do DBF
            {"FNCS1"},;                                     // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,8,15,73},;                               // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop>2","Permitido apenas para usu†rio cadastrado|com n°vel de Gerància"},;// condicao de exclusao de registros
            {"nivelop>1","Permitido apenas para usu†rio cadastrado|com n°vel de ManutenáÑo ou Gerància"},;// condicao de alteracao de registros
            {"nivelop>2","Permitido apenas para usu†rio cadastrado|com n°vel de Gerància"};// condicao de recupercao de registros
           }

AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(codigo)~Necess†rio informar C¢DIGO",;
     /* help do campo */    "Informe um c¢digo para o funcion†rio";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Nome do funcion†rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess†rio informar NOME DO FUNCIONèRIO",;
     /* help do campo */    "Entre com o nome do funcion†rio autorizado a|assinar a declaraá∆o de ¢bito no|Cart¢rio de Registro C°vil";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "ProfissÑo",;
     /* cmd especial  */    "MTAB([ATENDENTE|COBRADOR|MOTORISTA|VENDEDOR],[PROFISSéO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(profiss)~êsta informaáÑo Ç necess†rio para a DeclaraáÑo de ¢bito",;
     /* help do campo */    "Entre com a profissÑo do funcion†rio.";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Nacionalidade",;
     /* cmd especial  */    "",;
     /* default       */    "[BRASILEIRO]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nacional)~Necess†rio informar NACIONALIDADE",;
     /* help do campo */    "Entre com a nacionalidade";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "!A",;
     /* titulo        */    "Est.Civil",;
     /* cmd especial  */    "MTAB(tbestciv,[EST.CIVIL])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "estciv $ tbestciv~EST.CIVIL nÑo aceit†vel.|Tecle F8 para busca em tabela",;
     /* help do campo */    "Entre com o estado civil ou tecle F8";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "@D",;
     /* titulo        */    "Idade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com a data de nascimento";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Endereáo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(endereco)~Necess†rio informar Endereáo",;
     /* help do campo */    "Informe o endereáo do funcion†rio";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o bairro";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cidade)~Necess†rio informar CIDADE",;
     /* help do campo */    "Entre com o nome do munic°pio";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VDV2(cpf) .OR. EMPT(cpf)~CPF nÑo aceit†vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "999.9",;
     /* titulo        */    "Percentual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "!(percent<0).AND.!(percent>100)~PERCENTUAL nÑo aceit†vel",;
     /* help do campo */    "Informe o percentual de comissÑo|caso o vendedor nÑo receba por n£mero de parcelas";
                         };
)
AADD(sistema[022,O_CAMPO],{;            // FNCS
     /* mascara       */    "@S35",;
     /* titulo        */    "ObservaáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[022,O_FORMULA],{;          // FNCS - estado civil
     /* form mostrar  */    "LEFT(TRAN(SUBS(tbestciv,AT(estciv,tbestciv),11),[]),15)",;
     /* lin da formula*/    3,;
     /* col da formula*/    15;
                         };
)


sistema[023]={;
            "Hist¢rico PadrÑo",;                            // opcao do menu
            "Hist¢rico PadrÑo",;                            // titulo do sistema
            {"historico","codigo","codlan"},;               // chaves do arquivo
            {"Por C¢digo","C¢digo Estruturado","Cod.Lanc"},;// titulo dos indices para consulta
            {"01","06","08"},;                              // ordem campos chaves
            {"HISTORIC",drvdbf,drvntx},;                    // nome do DBF
            {"HISTORI1","HISTORI2","HISTORI3"},;            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,4,21,77,3,10},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"origem=[ADM]","Registro utilizado por outro Sistema"},;// condicao de exclusao de registros
            {"orimgem=[ADM]","Registro mantido por outro sistema"},;// condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[023,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "999",;
     /* titulo        */    "Hist",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(HISTORICO)~Este Ç um campo de preenchimento obrigat¢rio.",;
     /* help do campo */    "Entre com um c¢digo para identificar| este hist¢rico.";
                         };
)
AADD(sistema[023,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "",;
     /* titulo        */    "DescriáÑo de Hist¢rico",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "!EMPTY(historico)",;
     /* validacao     */    "!EMPT(DESCRICAO)~Informe uma DESCRIÄéO para este c¢digo.",;
     /* help do campo */    "Entre com a identificaáao do Hist¢rico.|Ex.:Cheque, Dep¢sito, Pgto de Duplic., etc...";
                         };
)
AADD(sistema[023,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "!",;
     /* titulo        */    "D/C",;
     /* cmd especial  */    "MTAB('DÇbito|CrÇdito',[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "!EMPTY(historico)",;
     /* validacao     */    "EMPTY(TIPO).OR.tipo$[DC]~ê necess†rio informar se TIPO Ç DÇbito ou CrÇdito.|D p/Pagamentos e C para recebimentos.",;
     /* help do campo */    "Este hist¢rico Ç um DÇbito ou CrÇdito|Se for DÇb., reduzir† no saldo da conta de|lanáamento e acrescido na de baixa.";
                         };
)
AADD(sistema[023,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "!!!",;
     /* titulo        */    "C/C",;
     /* cmd especial  */    "MTAB([ADMinistradora|FUNer†ria|CONvenio|ESToque|FINanceiro|VIAtura],[ORIGEM])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o prefixo do sistema que|gerou o lanáamento|O Centro de Custo";
                         };
)
AADD(sistema[023,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "!",;
     /* titulo        */    "R/D",;
     /* cmd especial  */    "MTAB([Receita|Despesa|Transferància],[R/D])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "recdesp $ [RDT]~Receita/Despesa nÑo aceit†vel",;
     /* help do campo */    "ê Receita ou Despesa";
                         };
)
AADD(sistema[023,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "@!",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o c¢digo estruturado|para os lanáamentos com |este hist¢rico.";
                         };
)
AADD(sistema[023,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[023,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[024]={;
            "Custos Adicionais",;                           // opcao do menu
            "Custos Adicionais",;                           // titulo do sistema
            {"DTOS(emissao_)","historic+contrato","contrato+circ","circ+contrato"},;// chaves do arquivo
            {"Ocorrencia","Hist¢rico","Contrato","NßCobranáa"},;// titulo dos indices para consulta
            {"01","0405","0510","1005"},;                   // ordem campos chaves
            {"CSTSEG",drvdbf,drvntx},;                      // nome do DBF
            {"CSTSEG1","CSTSEG2","CSTSEG3","CSTSEG4"},;     // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,15,13,66},;                              // num telas/tela atual/coordenadas
            {1,.f.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[024,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "@D",;
     /* titulo        */    "EmissÑo",;
     /* cmd especial  */    "DATE()",;
     /* default       */    "date()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao_)~Necess†rio informar DATA DE EMISSAO v†lida",;
     /* help do campo */    "Informe a data da geraáÑo desta cobranáa";
                         };
)
AADD(sistema[024,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "99:99",;
     /* titulo        */    "Hora",;
     /* cmd especial  */    "",;
     /* default       */    "TIME()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(hora)~Necess†rio informar HORA",;
     /* help do campo */    "Informe a hora|Se necess†rio";
                         };
)
AADD(sistema[024,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "",;
     /* titulo        */    "Quem",;
     /* cmd especial  */    "",;
     /* default       */    "M->usuario",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[024,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(historic,'HISTORIC',1)~Este Ç um campo de preenchimento obrigat¢rio.|Tecle F8 para busca em tabela",;
     /* help do campo */    "Entre com um c¢digo para identificar| a cobranáa";
                         };
)
AADD(sistema[024,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "999999",;
     /* titulo        */    "Contrato",;
     /* cmd especial  */    "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(contrato,'GRUPOS',1)~Contrato inv†lido |ou inexistente",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[024,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "@!",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(complement)~Entre com uma informaáÑo que diferencie este|lanáamento de outros com mesmo hist¢rico.",;
     /* help do campo */    "Informe algo para identificar esta cobranáa";
                         };
)
AADD(sistema[024,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "99999",;
     /* titulo        */    "Qtdade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(qtdade<0)~Informe uma quantidade v†lida (>=0)",;
     /* help do campo */    "";
                         };
)
AADD(sistema[024,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "999999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(valor=0)~VALOR nÑo aceit†vel|Deve ser diferente de zeros",;
     /* help do campo */    "Informe o valor do serviáo";
                         };
)
AADD(sistema[024,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "9",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnà],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Qual o tipo de lanáamento";
                         };
)
AADD(sistema[024,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "999",;
     /* titulo        */    "Circ",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "(PTAB(contrato+tipo+circ,'TAXAS',1).AND.TAXAS->valorpg=0).or.circ<[001]~Taxa nÑo cadastrada,|ou,| j† paga.",;
     /* help do campo */    "Informe o n£mero da circular a consultar";
                         };
)


sistema[025]={;
            "Mensagem p/Contrato",;                         // opcao do menu
            "Mensagem p/Contrato",;                         // titulo do sistema
            {"seq"},;                                       // chaves do arquivo
            {"Sequencia"},;                                 // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            {"MENSAG",drvdbf,drvntx},;                      // nome do DBF
            {"MENSAG1"},;                                   // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,9,9,18,72},;                               // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[025,O_CAMPO],{;            // MENSAG
     /* mascara       */    "999999",;
     /* titulo        */    "Sequància",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(seq)~Necess†rio informar SEQUENCIA",;
     /* help do campo */    "Informe o n£mero sequencial|os menores serÑo apresentados antes";
                         };
)
AADD(sistema[025,O_CAMPO],{;            // MENSAG
     /* mascara       */    "@S50",;
     /* titulo        */    "CritÇrio",;
     /* cmd especial  */    "MEN_01F9()",;
     /* default       */    "MEN_01F9()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(filtro)~Informe uma expressÑo v†lida",;
     /* help do campo */    "Informe o critÇrio de filtragem|para exibiáÑo da mensagem.";
                         };
)
AADD(sistema[025,O_CAMPO],{;            // MENSAG
     /* mascara       */    "@S50",;
     /* titulo        */    "Menssagem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(mens1)~Informe a mensagem a apresentar,|tecle F7 para entrar e sair do campo",;
     /* help do campo */    "Informe a mensagem que ser† apresentada |na tela quando for satisfeita a condiáÑo informada";
                         };
)
AADD(sistema[025,O_CAMPO],{;            // MENSAG
     /* mascara       */    "@D",;
     /* titulo        */    "Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[025,O_CAMPO],{;            // MENSAG
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[025,O_FORMULA],{;          // MENSAG - Lanáamento
     /* form mostrar  */    "LEFT(TRAN(lancto_,[@D]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    40;
                         };
)
AADD(sistema[025,O_FORMULA],{;          // MENSAG - mensagem1
     /* form mostrar  */    "LEFT(TRAN(MEMOLINE(MENSAG->mens1,50,1),[]),50)",;
     /* lin da formula*/    4,;
     /* col da formula*/    12;
                         };
)
AADD(sistema[025,O_FORMULA],{;          // MENSAG - MENSAGEM 2
     /* form mostrar  */    "LEFT(TRAN(MEMOLINE(MENSAG->mens1,50,2),[]),50)",;
     /* lin da formula*/    5,;
     /* col da formula*/    12;
                         };
)
AADD(sistema[025,O_FORMULA],{;          // MENSAG - MENSAGEM 3
     /* form mostrar  */    "LEFT(TRAN(MEMOLINE(MENSAG->mens1,50,3),[]),50)",;
     /* lin da formula*/    6,;
     /* col da formula*/    12;
                         };
)
AADD(sistema[025,O_FORMULA],{;          // MENSAG - MENSAGEM 4
     /* form mostrar  */    "LEFT(TRAN(MEMOLINE(MENSAG->mens1,50,4),[]),50)",;
     /* lin da formula*/    7,;
     /* col da formula*/    12;
                         };
)
AADD(sistema[025,O_FORMULA],{;          // MENSAG - MENSAGEM 5
     /* form mostrar  */    "LEFT(TRAN(MEMOLINE(MENSAG->mens1,50,5),[]),50)",;
     /* lin da formula*/    8,;
     /* col da formula*/    12;
                         };
)
AADD(sistema[025,O_FORMULA],{;          // MENSAG - Por
     /* form mostrar  */    "LEFT(TRAN(por,[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    51;
                         };
)


sistema[026]={;
            "Caixas",;                                      // opcao do menu
            "Caixas",;                                      // titulo do sistema
            {"numop","numconta+historico+DTOS(fechto_)","codlan"},;// chaves do arquivo
            {"p/N£mero","p/Conta","Cod.Lanc"},;             // titulo dos indices para consulta
            {"01","050613","19"},;                          // ordem campos chaves
            {"ORDPGRC",drvdbf,drvntx},;                     // nome do DBF
            {"ORDPGRC1","ORDPGRC2","ORDPGRC3"},;            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,7,12,20,71},;                              // num telas/tela atual/coordenadas
            {3,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "999999",;
     /* titulo        */    "Nß O.P.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(numop)~Necess†rio informar Nß O.P.",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "!!!",;
     /* titulo        */    "Origem",;
     /* cmd especial  */    "MTAB([ADMinistradora|FUNer†ria|CONvenio|ESToque|FINanceiro|VIAtura],[ORIGEM])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "origem $ [ADM|FUN|CON|EST|FIN|VIA]~ORIGEM nÑo aceit†vel",;
     /* help do campo */    "Informe o prefixo do sistema que|gerou o lanáamento";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@D",;
     /* titulo        */    "Lancto_",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@!",;
     /* titulo        */    "Conta",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(numconta)~Campo obrigat¢rio!|Identifique a Conta/Cadastro com um n£mero | ou nome qualquer.",;
     /* help do campo */    "Informe a conta que receber† este lanáamento.";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$']+origem+[   '])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "EMPT(historico).OR.PTAB(historico,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento.";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "!",;
     /* titulo        */    "DÇb/CrÇd",;
     /* cmd especial  */    "MTAB([DÇbito|CrÇdito],[DêB/CRêD])",;
     /* default       */    "HISTORIC->tipo",;
     /* pre-validacao */    "",;
     /* validacao     */    "debcred$[CD]~Necess†rio informar DêB/CRêD",;
     /* help do campo */    "Se for um documento a pagar ser† D, senÑo C";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "99999999.99",;
     /* titulo        */    "Valor Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(VALORtotal<0.00)~VALOR TOTAL DO LANÄAMENTO| deve ser positivo ou zeros",;
     /* help do campo */    "Entre com o valor total do documento,|se valor = zero, ser† apenas agendado.";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@D",;
     /* titulo        */    "Vencto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(vencto_)~Necess†rio informar VENCTO",;
     /* help do campo */    "Entre com a data do vencimento deste.";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@!",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPTY(documento)~Digite algo para identificar o documento",;
     /* help do campo */    "Entre com o n£mero do documento";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "99999",;
     /* titulo        */    "NßDoctos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(nrdoctos<0)~NßDOCTOS nÑo aceit†vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@!",;
     /* titulo        */    "Complemento de Hist¢rico",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(complement)~Entre com uma informaáÑo que diferencie este|lanáamento de outros com mesmo hist¢rico.",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@D",;
     /* titulo        */    "Fechto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "",;
     /* titulo        */    "Fechpor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "@D",;
     /* titulo        */    "Autorizado em",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "",;
     /* titulo        */    "Autorizado",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "9999999",;
     /* titulo        */    "Lanáamento Nß",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_CAMPO],{;            // ORDPGRC
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[026,O_FORMULA],{;          // ORDPGRC - DescriáÑo de Hi
     /* form mostrar  */    "LEFT(TRAN(HISTORIC->descricao,[]),40)",;
     /* lin da formula*/    5,;
     /* col da formula*/    17;
                         };
)


sistema[027]={;
            "ParÉmetros",;                                  // opcao do menu
            "ParÉmetros do sistema",;                       // titulo do sistema
            {},;                                            // chaves do arquivo
            {},;                                            // titulo dos indices para consulta
            {},;                                            // ordem campos chaves
            {"PAR_ADM",drvdbf,drvntx},;                     // nome do DBF
            {},;                                            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,2,8,23,71},;                               // num telas/tela atual/coordenadas
            {2,.f.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o c¢digo da filial";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "9",;
     /* titulo        */    "Inscr.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Verificar Pagas?",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Repetir lanáamento?",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Maior Contrato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "000000",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Nrreint",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "Conta Recepcao",;
     /* cmd especial  */    "",;
     /* default       */    "[RECEP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(contarec)~Necess†rio informar CONTA RECEPCAO p/recebimentos",;
     /* help do campo */    "Informe a Conta que receber†|os lanáamentos da recepáÑo.";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "Conta Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "[RECEP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(contapag)~Necess†rio informar CONTA RECEPCAO p/Pagamentos",;
     /* help do campo */    "Informe a Conta que pagar†|os lanáamentos da recepáÑo.";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "[004]",;
     /* pre-validacao */    "",;
     /* validacao     */    "histrccar=[000].OR. PTAB(histrccar,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento|para parcelas recebidas na RecepáÑo.";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "[001]",;
     /* pre-validacao */    "",;
     /* validacao     */    "histrcfcc=[000].OR. PTAB(histrcfcc,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento de|recebimento de FCC.";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "[002]",;
     /* pre-validacao */    "",;
     /* validacao     */    "histrcrec=[000].OR. PTAB(histrcrec,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento|para taxas recebidas na RecepáÑo.";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "[003]",;
     /* pre-validacao */    "",;
     /* validacao     */    "histpg=[000].OR. PTAB(histpg,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico|para lanáamento de pagamentos.";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99-999999",;
     /* titulo        */    "Nß Recibo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nrauxrec)~Necess†rio informar Nß RECIBO",;
     /* help do campo */    "Informe o n£mero do recibo a imprimir.|no formato AA-NNNNNN|onde: AA=Ano, N=n£mero";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo',[situacao=1])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(mcodigo,'GRUPOS',1).AND.PTAB(mcodigo,'TAXAS',1).OR.mcodigo=[00000]~C¢digo inv†lido ou sem Taxas pendentes",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnà|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnà+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "mtipo $ [123678]~TIPO nÑo aceit†vel",;
     /* help do campo */    "Qual o tipo de lanáamento";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "VDBF(6,22,20,77,'TAXAS',{'codigo','circ','emissao_','valor','valorpg','forma'},1,'circ',[])",;
     /* default       */    "",;
     /* pre-validacao */    "!(mcodigo=[00000])",;
     /* validacao     */    "PTAB(mcodigo+mcirc,'TAXAS',1).AND.PTAB(GRUPOS->grupo+mcirc,'CIRCULAR',1)~Necess†rio informar CIRCULAR existente",;
     /* help do campo */    "N£mero da Circular|Mantido pela emissao de recibos";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!",;
     /* titulo        */    "Grup",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "EMPT(mgrupvip).OR.PTAB(mgrupvip,'ARQGRUP',1)~GRUP nÑo existe na tabela",;
     /* help do campo */    "Entre com o c¢digo do Grupo que ser† utilizado|como controle dos contratos VIPs.";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Combarra",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "combarra$'SN '~COMBARRA nÑo aceit†vel|Digite S ou N",;
     /* help do campo */    "Informe se os recibos devem ser impressos|com o c¢digo de barras";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Com Inscritos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "cinscr$'SN '~Digite S ou N",;
     /* help do campo */    "Informe se os Inscritos est∆o cadastrados";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Com Falecido",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "comfalec$'SN '~Digite S para imprimir recibos com os|Falecidos da circular.",;
     /* help do campo */    "Informe se os recibos da recepá∆o|devem ser impressos com os|falecidos (cartinha)";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99999",;
     /* titulo        */    "Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99",;
     /* titulo        */    "Ano",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!",;
     /* titulo        */    "Mproc3",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99999/99/!!",;
     /* titulo        */    "Procimp",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Màs Ref.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Pnumfcc",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "Munic°pio",;
     /* cmd especial  */    "",;
     /* default       */    "[LIMEIRA]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(p_cidade)~Necess†rio informar MUNIC°PIO",;
     /* help do campo */    "Entre com o nome do Munic°pio";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Recibo PadrÑo",;
     /* cmd especial  */    "MTAB([S-Recibos em papÇl branco|N-Recibos prÇ-impressos],[RECIBO PADRéO])",;
     /* default       */    "[S]",;
     /* pre-validacao */    "",;
     /* validacao     */    "(p_recp$[SN ])~RECIBO PADRéO nÑo aceit†vel|Digite S, N ou deixe sem preencher.",;
     /* help do campo */    "Digite S para utilizar o modelo|Padronizado de recibos (formul†rio branco)|ou N para recibos personalizados";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Ident1",;
     /* cmd especial  */    "",;
     /* default       */    "[Ind£stria de Urnas Bignotto Ltda]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(setup1)~Digite o nome da Empresa|Ser† utilizado em relat¢rios",;
     /* help do campo */    "Informe o nome da Empresa";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99.999.999/9999-99",;
     /* titulo        */    "CGC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VCGC(cgcsetup).or.EMPT(cgcsetup)~Necess†rio informar CGC",;
     /* help do campo */    "";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Ident2",;
     /* cmd especial  */    "Informe o endereáo da Empresa",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(setup2)~Digite o endereáo,|ser† a 2¶ linha de cabeáalho|de alguns relat¢rios",;
     /* help do campo */    "Digite o endereáo.";
                         };
)
AADD(sistema[027,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Setup3",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a 3¶ linha de cabeáalho.|Ex.: Telefone, Fax, etc...";
                         };
)
AADD(sistema[027,O_FORMULA],{;          // PAR_ADM - Desc.Pgto.
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histpg,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
     /* lin da formula*/    5,;
     /* col da formula*/    22;
                         };
)
AADD(sistema[027,O_FORMULA],{;          // PAR_ADM - Desc.Recebto
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histrcrec,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
     /* lin da formula*/    3,;
     /* col da formula*/    22;
                         };
)
AADD(sistema[027,O_FORMULA],{;          // PAR_ADM - Desc.Receb.FCC
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histrcfcc,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
     /* lin da formula*/    2,;
     /* col da formula*/    22;
                         };
)
AADD(sistema[027,O_FORMULA],{;          // PAR_ADM - DescriáÑo de Hi
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histrccar,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
     /* lin da formula*/    4,;
     /* col da formula*/    22;
                         };
)

sistema[028]={;
            "Avisos / Carencias",;                          // opcao do menu
            "Avisos / carencias",;                          // titulo do sistema
            {"seq0","codigo"},;                             // chaves do arquivo
            {"Sequencia","Contrato"},;                      // titulo dos indices para consulta
            {"02","05"},;                                   // ordem campos chaves
            {"MFILIAL",drvdbf,drvntx},;                     // nome do DBF
            {"MFILIAL1","MFILIAL2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,7,5,16,76},;                               // num telas/tela atual/coordenadas
            {1,.t.,.f.},;                                   // nivel acesso/tp chave/pede dir
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "999999",;
     /* titulo        */    "Seq0",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "@D",;
     /* titulo        */    "Data_",;
     /* cmd especial  */    "",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "M->usuario",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "@!",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,3,20,77,'GRUPOS',{'codigo','grupo','nome','endereco'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "(PTAB(ALLTRIM(codigo),[GRUPOS]).AND.BXR_07F9()).AND.(PTAB(codigo,'TAXAS',1).OR.(1=1)).AND.CAD_04F9(op_menu)~Contrato inv†lido |ou inexistente",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "@D",;
     /* titulo        */    "Termino Carencia",;
     /* cmd especial  */    "date()+90",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data do termino da carencia";
                         };
)
AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "@!",;
     /* titulo        */    "Obs1",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "@!",;
     /* titulo        */    "Obs2",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "@!",;
     /* titulo        */    "Obs3",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "@!",;
     /* titulo        */    "Idxd",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[028,O_CAMPO],{;            // MFILIAL
     /* mascara       */    "@!",;
     /* titulo        */    "Idxm",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[028,O_FORMULA],{;          // MFILIAL - nome
     /* form mostrar  */    "LEFT(TRAN(iif(ptab(codigo,[grupos]),grupos->nome,[ ]),[]),35)",;
     /* lin da formula*/    3,;
     /* col da formula*/    31;
                         };
)

sistema[nss-2]={;
            "Senhas",;                   // opcao do menu
            "Grupos de usu†rios",;       // titulo do sistema
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
     /* validacao     */    "!EMPT(_nogrupo)~Necess†rio informar GRUPO",;
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
     /* validacao     */    "!EMPT(_dbf)~Necess†rio informar ARQUIVO",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss-1,O_CAMPO],{;           // PWTABELA
     /* mascara       */    "@!",;
     /* titulo        */    "Permisîes",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "DIGITE INICIAIS DAS ROTINAS CERCEADAS AO USUèRIO|"+;
                            "P. Procura    F. Filtragem    D. DigitaáÑo     ˇ|"+;
                            "M. Modifica   E. Exclui       R. Recupera      ˇ|"+;
                            "V. Và global  N. Nova coluna  A. Apaga coluna  ˇ|"+;
                            "I. Imprime    O. Ordena       Q. Quantifica    ˇ|"+;
                            "L. Localiza   G. Global       C. Congela Colunas|"+;
                            "T. Tamanho    J. nova Janela ˇX. eXporta       ˇ|"+;
                            "Z. totaliZa   B. marca linha                   ˇ|";
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
            "Usu†rios",;                               // opcao do menu
            "Usu†rios",;                               // titulo do sistema
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
     /* validacao     */    "!EMPT(_nome)~Necess†rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[nss,O_CAMPO],{;            // PWUSUA
     /* mascara       */    "9",;
     /* titulo        */    "Nivel",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "MTAB([1. OperaáÑo|2. ManutenáÑo|3. Gerància],[N°VEL DE ACESSO])",;
     /* validacao     */    "VAL(_nivel)>0~NIVEL nÑo aceit†vel",;
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

* \\ Final de ADR_ATR2.PRG
