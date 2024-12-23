procedure adm_estr
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_ESTR.PRG
 \ Data....: 29-09-96
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Cria estrutura dos arquivos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v2.0d
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "admbig.ch"    // inicializa constantes manifestas

PROC BXR_estr     // estrutura do arquivo BXREC
DBCREATE(dbf,{;
               {"ano"       ,"C",  2, 0},; // 99
               {"numero"    ,"C",  6, 0},; // 999999
               {"codigo"    ,"C",  6, 0},; // 999999
               {"tipo"      ,"C",  1, 0},; // !
               {"circ"      ,"C",  3, 0},; // 999
               {"valorpg"   ,"N",  9, 2},; // @E 999,999.99
               {"valoraux"  ,"N",  9, 2},; // @E 999,999.99
               {"emitido_"  ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; // 
               {"numop"     ,"C",  6, 0},; // 999999
               {"grupo"     ,"C",  2, 0},; // !9
               {"intlan"    ,"C",  8, 0};  // 99999999
             };
)
RETU

PROC TXA_estr     // estrutura do arquivo TXACONTR
DBCREATE(dbf,{;
               {"codigo"    ,"C",  6, 0};  // 999999
             };
)
RETU

PROC TAX_estr     // estrutura do arquivo TAXAS
DBCREATE(dbf,{;
               {"codigo"    ,"C",  6, 0},; // 999999
               {"tipo"      ,"C",  1, 0},; // !
               {"circ"      ,"C",  3, 0},; // 999
               {"emissao_"  ,"D",  8, 0},; // @D
               {"valor"     ,"N",  9, 2},; // @E 999,999.99
               {"pgto_"     ,"D",  8, 0},; // @D
               {"valorpg"   ,"N",  9, 2},; // @E 999,999.99
               {"cobrador"  ,"C",  2, 0},; // !!
               {"forma"     ,"C",  1, 0},; // !
               {"baixa_"    ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; // 
               {"stat"      ,"C",  1, 0},; // 9
               {"flag_excl" ,"C",  1, 0},; // !
               {"codlan"    ,"C", 20, 0};  // !!!-99999999-999-999
             };
)
RETU

PROC ALE_estr     // estrutura do arquivo ALENDER
DBCREATE(dbf,{;
               {"codigo"    ,"C",  6, 0},; // 999999
               {"endereco"  ,"C", 35, 0},; // @!
               {"bairro"    ,"C", 25, 0},; // @!
               {"cidade"    ,"C", 25, 0},; // @!
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"data_"     ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; // 
               {"dendereco" ,"C", 35, 0},; // @!
               {"dbairro"   ,"C", 25, 0},; // @!
               {"dcidade"   ,"C", 25, 0},; // @!
               {"dcep"      ,"C",  8, 0},; // @R 99999-999
               {"dgrupo"    ,"C",  2, 0},; // 
               {"emitido_"  ,"D",  8, 0};  // @D
             };
)
RETU

PROC OBX_estr     // estrutura do arquivo OBXEC
DBCREATE(dbf,{;
               {"ano"       ,"C",  2, 0},; // 99
               {"numero"    ,"C",  6, 0},; // 999999
               {"codigo"    ,"C",  6, 0},; // 999999
               {"ref"       ,"C", 25, 0},; // @S23
               {"valorpg"   ,"N",  9, 2},; // @E 999,999.99
               {"valoraux"  ,"N",  9, 2},; // @E 999,999.99
               {"emitido_"  ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; // 
               {"numop"     ,"C",  6, 0},; // 999999
               {"grupo"     ,"C",  2, 0},; // !9
               {"intlan"    ,"C",  8, 0};  // 99999999
             };
)
RETU

PROC AFU_estr     // estrutura do arquivo AFUNER
DBCREATE(dbf,{;
               {"processo"  ,"C",  5, 0},; // 99999
               {"proc2"     ,"C",  2, 0},; // 99
               {"ocorr_"    ,"D",  8, 0},; // @D
               {"contrato"  ,"C",  6, 0},; // 999999
               {"grauparcon","C", 10, 0},; // 
               {"nomedec"   ,"C", 35, 0},; // @!
               {"ruadec"    ,"C", 35, 0},; // @!
               {"fonedec"   ,"C", 14, 0},; // @!
               {"codigofal" ,"C", 11, 0},; // 
               {"falecido"  ,"C", 35, 0},; // 
               {"ruares"    ,"C", 30, 0},; // 
               {"baires"    ,"C", 25, 0},; // 
               {"munres"    ,"C", 25, 0},; // 
               {"estres"    ,"C",  2, 0},; // !!
               {"nascto_"   ,"D",  8, 0},; // @D
               {"falecto_"  ,"D",  8, 0},; // @D
               {"horafal"   ,"C",  5, 0},; // 99:99
               {"ruafal"    ,"C", 30, 0},; // 
               {"municfal"  ,"C", 25, 0},; // 
               {"estfal"    ,"C",  2, 0},; // !!
               {"sepult_"   ,"D",  8, 0},; // @D
               {"horasepult","C",  5, 0},; // 99:99
               {"cemitsep"  ,"C", 30, 0},; // 
               {"funcresp"  ,"C",  3, 0},; // 999
               {"procpagto_","D",  8, 0},; // @D
               {"vlauxilio" ,"N", 14, 2},; // 99999999999.99
               {"pagtoem_"  ,"D",  8, 0},; // @D
               {"intlan"    ,"C",  8, 0};  // 99999999
             };
)
RETU

PROC ARQ_estr     // estrutura do arquivo ARQGRUP
DBCREATE(dbf,{;
               {"grup"      ,"C",  2, 0},; // !9
               {"classe"    ,"C",  2, 0},; // 99
               {"inicio"    ,"C",  6, 0},; // 999999
               {"final"     ,"C",  6, 0},; // 999999
               {"acumproc"  ,"N",  2, 0},; // 99
               {"periodic"  ,"N",  3, 0},; // 999
               {"qtdremir"  ,"N",  2, 0},; // 99
               {"ultcirc"   ,"C",  3, 0},; // 999
               {"emissao_"  ,"D",  8, 0},; // @D
               {"procpend"  ,"N",  3, 0},; // 999
               {"contrat"   ,"N",  6, 0},; // 999999
               {"partic"    ,"N",  6, 0},; // 999999
               {"proxcirc"  ,"C",  3, 0};  // 999
             };
)
RETU

PROC CLA_estr     // estrutura do arquivo CLASSES
DBCREATE(dbf,{;
               {"classcod"  ,"C",  2, 0},; // 99
               {"descricao" ,"C", 35, 0},; // @!
               {"contrat"   ,"N",  6, 0},; // 999999
               {"prior"     ,"C",  1, 0},; // !
               {"vljoia"    ,"N", 11, 2},; // 99999999.99
               {"nrparc"    ,"N",  2, 0},; // 99
               {"vlmensal"  ,"N", 11, 2},; // 99999999.99
               {"vldepend"  ,"N", 11, 2},; // 99999999.99
               {"nrmesval"  ,"N",  2, 0},; // 99
               {"renvenc"   ,"C",  1, 0},; // !
               {"renuso"    ,"C",  1, 0},; // !
               {"vltotal"   ,"N", 11, 2};  // @E 99,999,999.99
             };
)
RETU

PROC CLP_estr     // estrutura do arquivo CLPRODS
DBCREATE(dbf,{;
               {"classcod"  ,"C",  2, 0},; // 99
               {"codigo"    ,"C",  4, 0},; // 9999
               {"qtdade"    ,"N",  4, 0},; // 9999
               {"data"      ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; // 
               {"flag_excl" ,"C",  1, 0};  // !
             };
)
RETU

PROC REG_estr     // estrutura do arquivo REGIAO
DBCREATE(dbf,{;
               {"codigo"    ,"C",  3, 0},; // 999
               {"regiao"    ,"C", 30, 0},; // 
               {"cobrador"  ,"C",  2, 0};  // !!
             };
)
RETU

PROC CIR_estr     // estrutura do arquivo CIRCULAR
DBCREATE(dbf,{;
               {"grupo"     ,"C",  2, 0},; // !9
               {"circ"      ,"C",  3, 0},; // 999
               {"procpend"  ,"N",  2, 0},; // 99
               {"emissao_"  ,"D",  8, 0},; // @D
               {"mesref"    ,"C",  4, 0},; // @R 99/99
               {"valor"     ,"N",  9, 2},; // @E 999,999.99
               {"menscirc"  ,"C", 60, 0},; // @S30@!
               {"emitidos"  ,"N",  6, 0},; // 999999
               {"pagos"     ,"N",  6, 0},; // 999999
               {"cancelados","N",  6, 0},; // 999999
               {"lancto_"   ,"D",  8, 0},; // @D
               {"funcionar" ,"C", 10, 0},; // 
               {"impress_"  ,"D",  8, 0};  // @D
             };
)
RETU

PROC CPR_estr     // estrutura do arquivo CPRCIRC
DBCREATE(dbf,{;
               {"grupo"     ,"C",  2, 0},; // !9
               {"circ"      ,"C",  3, 0},; // 999
               {"processo"  ,"C",  9, 0},; // @R 99999/99/!!
               {"categ"     ,"C",  2, 0},; // !!
               {"num"       ,"C",  5, 0},; // 99999
               {"fal"       ,"C", 35, 0},; // @!
               {"ends"      ,"C", 40, 0},; // @!
               {"cids"      ,"C", 15, 0},; // @!
               {"dfal"      ,"D",  8, 0},; // @D
               {"flag_excl" ,"C",  1, 0};  // !
             };
)
RETU

PROC COB_estr     // estrutura do arquivo COBRADOR
DBCREATE(dbf,{;
               {"cobrador"  ,"C",  2, 0},; // !!
               {"funcao"    ,"C",  1, 0},; // !
               {"nome"      ,"C", 30, 0},; // 
               {"endereco"  ,"C", 30, 0},; // 
               {"bairro"    ,"C", 20, 0},; // 
               {"cidade"    ,"C", 25, 0},; // 
               {"telefone"  ,"C", 14, 0},; // 
               {"cpf"       ,"C", 11, 0},; // @R 999.999.999-99
               {"obs"       ,"M", 10, 0},; // @S35
               {"percent"   ,"N",  5, 1};  // 999.9
             };
)
RETU

PROC FCC_estr     // estrutura do arquivo FCCOB
DBCREATE(dbf,{;
               {"cobrador"  ,"C",  2, 0},; // !!
               {"mesref"    ,"C",  4, 0},; // @R 99/99
               {"qtdemit"   ,"N",  6, 0},; // 999999
               {"qtdpaga"   ,"N",  6, 0},; // 999999
               {"qtdret"    ,"N",  6, 0},; // 999999
               {"vlentr"    ,"N",  9, 2},; // @E 999,999.99
               {"vlreceb"   ,"N",  9, 2},; // @E 999,999.99
               {"vlretorn"  ,"N",  9, 2},; // @E 999,999.99
               {"flag_excl" ,"C",  1, 0};  // !
             };
)
RETU

PROC PRC_estr     // estrutura do arquivo PRCESSOS
DBCREATE(dbf,{;
               {"processo"  ,"C",  9, 0},; // @R 99999/99/!!
               {"categ"     ,"C",  2, 0},; // !!
               {"saiu"      ,"C",  3, 0},; // 
               {"grup"      ,"C",  2, 0},; // !9
               {"num"       ,"C",  5, 0},; // 99999
               {"grau"      ,"C",  1, 0},; // 9
               {"seq"       ,"N",  2, 0},; // 99
               {"seg"       ,"C", 35, 0},; // @!
               {"ends"      ,"C", 40, 0},; // @!
               {"cids"      ,"C", 15, 0},; // @!
               {"fal"       ,"C", 35, 0},; // @!
               {"sep"       ,"C", 35, 0},; // @!
               {"dfal"      ,"D",  8, 0},; // @D
               {"codlan"    ,"C", 20, 0};  // !!!-99999999-999-999
             };
)
RETU

PROC GRU_estr     // estrutura do arquivo GRUPOS
DBCREATE(dbf,{;
               {"codigo"    ,"C",  6, 0},; // 999999
               {"grupo"     ,"C",  2, 0},; // !9
               {"situacao"  ,"C",  1, 0},; // 9
               {"nome"      ,"C", 35, 0},; // 
               {"nascto_"   ,"D",  8, 0},; // @D
               {"estcivil"  ,"C",  2, 0},; // !!
               {"cpf"       ,"C", 11, 0},; // @R 999.999.999-99
               {"rg"        ,"C", 20, 0},; // @!
               {"endereco"  ,"C", 35, 0},; // 
               {"bairro"    ,"C", 20, 0},; // 
               {"cidade"    ,"C", 25, 0},; // 
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"contato"   ,"C", 25, 0},; // @!
               {"tipcont"   ,"C",  2, 0},; // 99
               {"vlcarne"   ,"C",  3, 0},; // 
               {"formapgto" ,"C",  2, 0},; // 99
               {"seguro"    ,"N",  2, 0},; // 
               {"admissao"  ,"D",  8, 0},; // @D
               {"tcarencia" ,"D",  8, 0},; // @D
               {"saitxa"    ,"C",  4, 0},; // @R 99/99
               {"vendedor"  ,"C",  2, 0},; // !!
               {"regiao"    ,"C",  3, 0},; // 999
               {"cobrador"  ,"C",  2, 0},; // !!
               {"obs"       ,"M", 10, 0},; // @S35
               {"renovar"   ,"D",  8, 0},; // @D
               {"funerais"  ,"N",  2, 0},; // 99
               {"circinic"  ,"C",  3, 0},; // 999
               {"ultcirc"   ,"C",  3, 0},; // 999
               {"qtcircs"   ,"N",  3, 0},; // 999
               {"qtcircpg"  ,"N",  3, 0},; // 999
               {"titular"   ,"C",  3, 0},; // 
               {"particv"   ,"N",  2, 0},; // 99
               {"particf"   ,"N",  2, 0},; // 99
               {"nrdepend"  ,"N",  2, 0},; // 99
               {"ultimp_"   ,"D",  8, 0},; // @D
               {"ender_"    ,"D",  8, 0},; // @D
               {"ultend"    ,"C", 10, 0};  // 
             };
)
RETU

PROC INS_estr     // estrutura do arquivo INSCRITS
DBCREATE(dbf,{;
               {"codigo"    ,"C",  6, 0},; // 999999
               {"grau"      ,"C",  1, 0},; // 9
               {"seq"       ,"N",  2, 0},; // 99
               {"ehtitular" ,"C",  1, 0},; // !
               {"nome"      ,"C", 35, 0},; // 
               {"nascto_"   ,"D",  8, 0},; // @D
               {"estcivil"  ,"C",  2, 0},; // 
               {"interdito" ,"C",  1, 0},; // !
               {"sexo"      ,"C",  1, 0},; // !
               {"tcarencia" ,"D",  8, 0},; // @D
               {"lancto_"   ,"D",  8, 0},; // @D
               {"vivofalec" ,"C",  1, 0},; // !
               {"falecto_"  ,"D",  8, 0},; // @D
               {"tipo"      ,"C",  3, 0},; // !!!
               {"procnr"    ,"C",  7, 0},; // @R 99999/99
               {"por"       ,"C", 10, 0},; // 
               {"flag_excl" ,"C",  1, 0};  // !
             };
)
RETU

PROC FNC_estr     // estrutura do arquivo FNCS
DBCREATE(dbf,{;
               {"codigo"    ,"C",  3, 0},; // 
               {"nome"      ,"C", 35, 0},; // @!
               {"profiss"   ,"C", 15, 0},; // @!
               {"nacional"  ,"C", 15, 0},; // @!
               {"estciv"    ,"C",  2, 0},; // !A
               {"nascto_"   ,"D",  8, 0},; // @D
               {"endereco"  ,"C", 30, 0},; // @!
               {"bairro"    ,"C", 25, 0},; // @!
               {"cidade"    ,"C", 25, 0},; // @!
               {"cpf"       ,"C", 11, 0},; // @R 999.999.999-99
               {"telefone"  ,"C", 14, 0},; // 
               {"percent"   ,"N",  5, 1},; // 999.9
               {"obs"       ,"M", 10, 0};  // @S35
             };
)
RETU

PROC HIS_estr     // estrutura do arquivo HISTORIC
DBCREATE(dbf,{;
               {"historico" ,"C",  3, 0},; // 999
               {"descricao" ,"C", 40, 0},; // 
               {"tipo"      ,"C",  1, 0},; // !
               {"origem"    ,"C",  3, 0},; // !!!
               {"intlan"    ,"C",  8, 0},; // 99999999
               {"codlan"    ,"C", 20, 0};  // !!!-99999999-999-999
             };
)
RETU

PROC ORD_estr     // estrutura do arquivo ORDPGRC
DBCREATE(dbf,{;
               {"numop"     ,"C",  6, 0},; // 999999
               {"origem"    ,"C",  3, 0},; // !!!
               {"lancto_"   ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; // 
               {"numconta"  ,"C", 10, 0},; // @!
               {"historico" ,"C",  3, 0},; // 999
               {"debcred"   ,"C",  1, 0},; // !
               {"valortotal","N", 11, 2},; // 99999999.99
               {"vencto_"   ,"D",  8, 0},; // @D
               {"documento" ,"C", 12, 0},; // @!
               {"nrdoctos"  ,"N",  5, 0},; // 99999
               {"complement","C", 35, 0},; // @!
               {"fechto_"   ,"D",  8, 0},; // @D
               {"fechpor"   ,"C", 10, 0},; // 
               {"autoriz_"  ,"D",  8, 0},; // @D
               {"autorpor"  ,"C", 10, 0},; // 
               {"numos"     ,"C",  7, 0},; // 9999999
               {"intlan"    ,"C",  8, 0},; // 99999999
               {"codlan"    ,"C", 20, 0};  // !!!-99999999-999-999
             };
)
RETU

PROC PAR_estr     // estrutura do arquivo PAR_ADM
DBCREATE(dbf,{;
               {"pgrupo"    ,"C",  2, 0},; // !9
               {"pcontrato" ,"C",  6, 0},; // 999999
               {"pgrau"     ,"C",  1, 0},; // 9
               {"pseq"      ,"N",  2, 0},; // 99
               {"lastcodigo","C",  6, 0},; // 999999
               {"nrcanc"    ,"N",  6, 0},; // 999999
               {"nrreint"   ,"N",  6, 0},; // 999999
               {"contarec"  ,"C",  5, 0},; // @!
               {"contapag"  ,"C",  5, 0},; // @!
               {"histrcfcc" ,"C",  3, 0},; // 999
               {"histrcrec" ,"C",  3, 0},; // 999
               {"histrccar" ,"C",  3, 0},; // 999
               {"histpg"    ,"C",  3, 0},; // 999
               {"nrauxrec"  ,"C",  8, 0},; // @R 99-999999
               {"mcodigo"   ,"C",  6, 0},; // 999999
               {"mcirc"     ,"C",  3, 0},; // 999
               {"mgrupvip"  ,"C",  2, 0},; // !9
               {"combarra"  ,"C",  1, 0},; // !
               {"cinscr"    ,"C",  1, 0},; // !
               {"comfalec"  ,"C",  1, 0},; // !
               {"mproc1"    ,"C",  5, 0},; // 99999
               {"mproc2"    ,"C",  2, 0},; // 99
               {"impnrrec"  ,"C",  5, 0},; // 99999
               {"procimp"   ,"C",  7, 0},; // @R 99999/99
               {"pvalor"    ,"N",  9, 2},; // @E 999,999.99
               {"setup1"    ,"C", 40, 0},; // 
               {"setup2"    ,"C", 50, 0},; // 
               {"setup3"    ,"C", 50, 0};  // 
             };
)
RETU

* \\ Final de ADM_ESTR.PRG
