procedure adr_estr
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADR_ESTR.PRG
 \ Data....: 29-01-04
 \ Sistema.: Administradora - RECEP€„O
 \ Funcao..: Cria estrutura dos arquivos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0o
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

PROC BXR_estr     // estrutura do arquivo BXREC
DBCREATE(dbf,{;
               {"numero"    ,"C",  8, 0},; // 99999999
               {"codigo"    ,"C",  9, 0},; // @!
               {"cobranca"  ,"C", 18, 0},; // @!
               {"valorpg"   ,"N",  9, 2},; // @E 999,999.99
               {"valoraux"  ,"N",  9, 2},; // @E 999,999.99
               {"emitido_"  ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; // 
               {"numop"     ,"C",  6, 0},; // 999999
               {"grupo"     ,"C",  2, 0},; // !9
               {"filial"    ,"C",  2, 0},; // @!
               {"intlan"    ,"C",  8, 0},;  // 99999999
               {"forma_pg"  ,"C", 15, 0},; // @!
               {"obs_pg"    ,"C", 35, 0},;  // @!
               {"idxd"      ,"C", 30, 0},; // @!
               {"idxm"      ,"C", 30, 0};  // @!
             };
)
RETU

PROC ALE_estr     // estrutura do arquivo ALENDER
DBCREATE(dbf,{;
               {"codigo"    ,"C",  9, 0},; // @!
               {"numero"    ,"C",  8, 0},; // 99999999
               {"endereco"  ,"C", 35, 0},; // 
               {"bairro"    ,"C", 25, 0},; // 
               {"cidade"    ,"C", 25, 0},; // 
               {"uf"        ,"C",  2, 0},; // !!
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"telefone"  ,"C", 14, 0},; // @!
               {"cobrador"  ,"C",  3, 0},; // !!!
               {"data_"     ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; // 
               {"dendereco" ,"C", 35, 0},; // 
               {"dbairro"   ,"C", 25, 0},; // 
               {"dcidade"   ,"C", 25, 0},; // 
               {"duf"       ,"C",  2, 0},; // !!
               {"dcep"      ,"C",  8, 0},; // @R 99999-999
               {"dtelefone" ,"C", 14, 0},; // @!
               {"dcobrador" ,"C",  3, 0},; // !!!
               {"dgrupo"    ,"C",  2, 0},; // 
               {"emitido_"  ,"D",  8, 0},; // @D
               {"filial"    ,"C",  2, 0};  // @!
             };
)
RETU

PROC OBX_estr     // estrutura do arquivo OBXEC
DBCREATE(dbf,{;
               {"numero"    ,"C",  8, 0},; // 99999999
               {"codigo"    ,"C",  9, 0},; // @!
	       {"cobranca"  ,"C", 25, 0},; // @!
               {"valorpg"   ,"N",  9, 2},; // @E 999,999.99
               {"valoraux"  ,"N",  9, 2},; // @E 999,999.99
               {"emitido_"  ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; // 
               {"numop"     ,"C",  6, 0},; // 999999
               {"grupo"     ,"C",  2, 0},; // !9
               {"filial"    ,"C",  2, 0},; // @!
               {"intlan"    ,"C",  8, 0},;  // 99999999
               {"forma_pg"  ,"C", 15, 0},; // @!
               {"obs_pg"    ,"C", 35, 0},;  // @!
               {"idxd"      ,"C", 30, 0},; // @!
               {"idxm"      ,"C", 30, 0};  // @!
             };
)
RETU

PROC GRU_estr     // estrutura do arquivo GRUPOS
DBCREATE(dbf,{;
               {"codigo"    ,"C", 10, 0},; // @!
               {"grupo"     ,"C",  2, 0},; // !!
               {"situacao"  ,"C",  1, 0},; // 9
               {"nome"      ,"C", 35, 0},; // @!
               {"nascto_"   ,"D",  8, 0},; // @D
               {"estcivil"  ,"C",  2, 0},; // !!
               {"cpf"       ,"C", 11, 0},; // @R 999.999.999-99
               {"rg"        ,"C", 20, 0},; // @!
               {"endereco"  ,"C", 35, 0},; // @!
               {"bairro"    ,"C", 20, 0},; // @!
               {"cidade"    ,"C", 25, 0},; // @!
               {"uf"        ,"C",  2, 0},; // !!
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"natural"   ,"C", 25, 0},; // @K!
               {"relig"     ,"C", 40, 0},; // @!
               {"contato"   ,"C", 25, 0},; // @!
               {"telefone"  ,"C", 14, 0},; // @!
               {"tipcont"   ,"C",  2, 0},; // 99
               {"vlcarne"   ,"C",  3, 0},; // 
               {"formapgto" ,"C",  2, 0},; // 99
               {"seguro"    ,"N",  2, 0},; // 
               {"admissao"  ,"D",  8, 0},; // @D
               {"tcarencia" ,"D",  8, 0},; // @D
               {"saitxa"    ,"C",  4, 0},; // @R 99/99
               {"diapgto"   ,"C",  2, 0},; // 99
               {"vendedor"  ,"C",  3, 0},; // !!!
               {"regiao"    ,"C",  3, 0},; // 999
               {"cobrador"  ,"C",  3, 0},; // !!!
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
               {"ultend"    ,"C", 10, 0},; //
               {"em_"       ,"D",  8, 0},; // @D    ****
               {"por"       ,"C", 10, 0},; // @!    ****
               {"atend1"    ,"C", 15, 0},; // @!    ****
               {"atend2"    ,"C", 15, 0},; // @!    ****
               {"ultnraux"  ,"C",  3, 0},; // @!    ****
               {"ultdtaux"  ,"D",  8, 0},; // @!    ****
               {"ultvlaux"  ,"N", 11, 2},; // @!    ****
               {"email"     ,"C", 50, 0},; //
               {"segmesref" ,"D",  8, 0},; // @!    ****
               {"segcodcob" ,"C",  3, 0},; // @!    ****
               {"segservcod","C",  3, 0},; // @!    ****
               {"nrsorteio" ,"C",  6, 0};  //       ****
             };
)
RETU

PROC TAX_estr     // estrutura do arquivo TAXAS
DBCREATE(dbf,{;
      	       {"codigo"    ,"C", 15, 0},; // @!
               {"cobranca"  ,"C", 18, 0},; // @!
               {"tipo"      ,"C",  1, 0},; // !
               {"circ"      ,"C",  3, 0},; // 999
               {"emissao_"  ,"D",  8, 0},; // @D
               {"valor"     ,"N",  9, 2},; // @E 999,999.99
               {"pgto_"     ,"D",  8, 0},; // @D
               {"valorpg"   ,"N",  9, 2},; // @E 999,999.99
               {"cobrador"  ,"C",  3, 0},; // !!!
               {"forma"     ,"C",  1, 0},; // !
               {"baixa_"    ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; //
               {"stat"      ,"C",  1, 0},; // 9
               {"filial"    ,"C",  2, 0},; // @!
               {"flag_excl" ,"C",  1, 0},; // !
               {"codlan"    ,"C", 20, 0};  // !!!-99999999-999-999
             };
)
RETU

PROC ECO_estr     // estrutura do arquivo ECOB
DBCREATE(dbf,{;
               {"codigo"    ,"C",  9, 0},; // @!
               {"tipo"      ,"C",  1, 0},; // !
               {"endereco"  ,"C", 35, 0},; // @!
               {"bairro"    ,"C", 20, 0},; // @!
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"cidade"    ,"C", 25, 0},; // @!
               {"uf"        ,"C",  2, 0},; // !!
               {"telefone"  ,"C", 14, 0},; // @!
               {"obs"       ,"C", 20, 0},; // 
               {"data_"     ,"D",  8, 0},; // @D
               {"flag_excl" ,"C",  1, 0};  // !
             };
)
RETU

PROC INS_estr     // estrutura do arquivo INSCRITS
DBCREATE(dbf,{;
	       {"codigo"    ,"C", 15, 0},; // @!
	       {"grau"      ,"C",  1, 0},; // 9
               {"seq"       ,"N",  2, 0},; // 99
               {"ehtitular" ,"C",  1, 0},; // !
               {"nome"      ,"C", 35, 0},; // @!
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
               {"flag_excl" ,"C",  1, 0},; //
               {"cpf"       ,"C", 15, 0},; //
               {"segmesref" ,"D",  8, 0},; // @!    ****
               {"segpercen" ,"N",  6, 2},; // @!    ****
               {"segcodcob" ,"C",  3, 0},; // @!    ****
               {"segservcod","C",  3, 0};  // !
             };
)
RETU

PROC GUI_estr     // estrutura do arquivo GUIAS
DBCREATE(dbf,{;
               {"numero"    ,"C",  8, 0},; // 99999999
               {"data"      ,"D",  8, 0},; // @D
               {"hora"      ,"C",  5, 0},; // 99:99
               {"filial"    ,"C",  2, 0},; // 
               {"login"     ,"C", 10, 0},; // 
               {"contrato"  ,"C",  9, 0},; // @!
               {"nome"      ,"C", 35, 0},; // @!
               {"inscrito"  ,"C", 18, 0},; // @!
               {"medico"    ,"C", 10, 0},; // @!
               {"por"       ,"C", 10, 0},; // 
               {"intlan"    ,"C",  8, 0};  // 99999999
             };
)
RETU

PROC AFU_estr     // estrutura do arquivo AFUNER
DBCREATE(dbf,{;
               {"processo"  ,"C",  5, 0},; // 99999
               {"proc2"     ,"C",  2, 0},; // 99
               {"filial"    ,"C",  2, 0},; // @!
               {"ocorr_"    ,"D",  8, 0},; // @D
               {"categ"     ,"C",  2, 0},; // !!
               {"contrato"  ,"C",  9, 0},; // @!
               {"grauparcon","C", 10, 0},; // 
               {"nomedec"   ,"C", 35, 0},; // @!
               {"ruadec"    ,"C", 35, 0},; // @!
               {"fonedec"   ,"C", 14, 0},; // @!
	       {"codigofal" ,"C", 15, 0},; //
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

PROC IMP_estr     // estrutura do arquivo IMPPAR
DBCREATE(dbf,{;
               {"idmaq"     ,"C",  4, 0},; // @!
               {"base"      ,"C",  3, 0},; // @!
               {"docto"     ,"C", 12, 0},; // 
               {"codlan"    ,"C", 20, 0};  // !!!-99999999-999-999
             };
)
RETU

PROC MED_estr     // estrutura do arquivo MEDICOS
DBCREATE(dbf,{;
               {"ai"        ,"C",  5, 0},; // 
               {"codbenefic","C", 10, 0},; // 
               {"oldescrito","C",  5, 0},; // 
               {"oldclasse" ,"C",  3, 0},; // 
               {"prioridade","C",  2, 0},; // 
               {"status"    ,"C",  2, 0},; // !!
               {"oldespec"  ,"C", 50, 0},; // @!
               {"detalhes"  ,"M", 10, 0},; // @S35
               {"vantagens" ,"M", 10, 0},; // @S35
               {"condicoes" ,"M", 10, 0},; // @S35
               {"informutil","M", 10, 0},; // @S35
               {"nome"      ,"C", 50, 0},; // 
               {"endereco"  ,"C", 50, 0},; // 
               {"bairro"    ,"C", 30, 0},; // @!
               {"cidade"    ,"C", 30, 0},; // @!
               {"uf"        ,"C",  2, 0},; // !!
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"contato"   ,"C", 50, 0},; // @!
               {"fonecom1"  ,"C", 15, 0},; // 
               {"fonecom2"  ,"C", 15, 0},; // @!
               {"fonecel"   ,"C", 15, 0},; // @!
               {"foneres1"  ,"C", 15, 0},; // @!
               {"email"     ,"C", 50, 0},; // @!
               {"fax"       ,"C", 15, 0},; // @!
               {"bip"       ,"C", 15, 0},; // @!
               {"fonesdiv"  ,"C", 30, 0},; // @!
               {"datainc"   ,"D",  8, 0},; // @D
               {"dataalt"   ,"D",  8, 0},; // @D
               {"codcidade" ,"C",  4, 0},; // 
               {"contrato"  ,"C", 10, 0},; // 
               {"flagetq"   ,"C", 10, 0},; // 
               {"codclasse" ,"C",  6, 0},; // 
               {"intlan"    ,"C",  8, 0};  // 99999999
             };
)
RETU

PROC TES_estr     // estrutura do arquivo TESPEC
DBCREATE(dbf,{;
               {"especialid","C", 30, 0},; // @!
               {"codlan"    ,"C", 20, 0};  // !!!-99999999-999-999
             };
)
RETU

PROC JUR_estr     // estrutura do arquivo JUROS
DBCREATE(dbf,{;
               {"tipo"      ,"C",  1, 0},; // 9
               {"multa"     ,"N",  5, 2},; // 99.99
               {"mltcaren"  ,"N",  3, 0},; // 999
               {"juros"     ,"N",  5, 3},; // 9.999
               {"jrscaren"  ,"N",  3, 0};  // 999
             };
)
RETU

PROC TFI_estr     // estrutura do arquivo TFILIAIS
DBCREATE(dbf,{;
               {"codigo"    ,"C",  2, 0},; // @!
               {"abrev"     ,"C", 25, 0},; // 
               {"nome"      ,"C", 50, 0},; // @!
               {"endereco"  ,"C", 50, 0},; // @!
               {"cidade"    ,"C", 50, 0},; // @!
               {"ref"       ,"M", 10, 0},; // @S35
               {"contato"   ,"C", 20, 0};  // @!
             };
)
RETU

PROC ARQ_estr     // estrutura do arquivo ARQGRUP
DBCREATE(dbf,{;
               {"grup"      ,"C",  2, 0},; // !!
               {"classe"    ,"C",  2, 0},; // 99
               {"inicio"    ,"C",  6, 0},; // 999999
               {"final"     ,"C",  6, 0},; // 999999
               {"acumproc"  ,"N",  2, 0},; // 99
               {"maxproc"   ,"N",  2, 0},; // 99
               {"cpadmiss"  ,"C",  1, 0},; // !
               {"periodic"  ,"N",  3, 0},; // 999
               {"qtdremir"  ,"N",  3, 0},; // 999
               {"poratend"  ,"C",  1, 0},; // !
               {"ultcirc"   ,"C",  3, 0},; // 999
               {"emissao_"  ,"D",  8, 0},; // @D
               {"procpend"  ,"N",  3, 0},; // 999
               {"contrat"   ,"N",  6, 0},; // 999999
               {"partic"    ,"N",  6, 0},; // 999999
               {"proxcirc"  ,"C",  3, 0};  // 999
             };
)
RETU

PROC REG_estr     // estrutura do arquivo REGIAO
DBCREATE(dbf,{;
               {"codigo"    ,"C",  3, 0},; // 999
               {"regiao"    ,"C", 30, 0},; // 
               {"cobrador"  ,"C",  3, 0};  // !!!
             };
)
RETU

PROC COB_estr     // estrutura do arquivo COBRADOR
DBCREATE(dbf,{;
               {"cobrador"  ,"C",  3, 0},; // !!!
               {"funcao"    ,"C",  1, 0},; // !
               {"nome"      ,"C", 30, 0},; // 
               {"endereco"  ,"C", 30, 0},; // 
               {"bairro"    ,"C", 20, 0},; // 
               {"cidade"    ,"C", 25, 0},; // 
               {"telefone"  ,"C", 14, 0},; // 
               {"cpf"       ,"C", 11, 0},; // @R 999.999.999-99
               {"obs"       ,"M", 10, 0},; // @S35
               {"percent"   ,"N",  5, 1},; // 999.9
               {"superv"    ,"C",  3, 0};  // !!!
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
               {"parcger"   ,"N",  2, 0},; // 99
               {"vlmensal"  ,"N", 11, 2},; // 99999999.99
               {"vldepend"  ,"N", 11, 2},; // 99999999.99
               {"nrmesval"  ,"N",  2, 0},; // 99
               {"renvenc"   ,"C",  1, 0},; // !
               {"renuso"    ,"C",  1, 0},; // !
               {"vltotal"   ,"N", 11, 2};  // @E 99,999,999.99
             };
)
RETU

PROC CIR_estr     // estrutura do arquivo CIRCULAR
DBCREATE(dbf,{;
               {"grupo"     ,"C",  2, 0},; // !!
               {"circ"      ,"C",  3, 0},; // 999
               {"procpend"  ,"N",  2, 0},; // 99
               {"emissao_"  ,"D",  8, 0},; // @D
               {"mesref"    ,"C",  4, 0},; // @R 99/99
               {"valor"     ,"N",  9, 2},; // @E 999,999.99
               {"menscirc"  ,"C", 60, 0},; // @S35
               {"menscirc1" ,"C", 35, 0},; // 
               {"menscirc2" ,"C", 35, 0},; // 
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
               {"grupo"     ,"C",  2, 0},; // !!
               {"circ"      ,"C",  3, 0},; // 999
               {"processo"  ,"C",  9, 0},; // @R 99999/99/!!
               {"categ"     ,"C",  2, 0},; // !!
               {"num"       ,"C",  6, 0},; // 999999
               {"fal"       ,"C", 35, 0},; // @!
               {"ends"      ,"C", 40, 0},; // @!
               {"cids"      ,"C", 15, 0},; // @!
               {"dfal"      ,"D",  8, 0},; // @D
               {"flag_excl" ,"C",  1, 0};  // !
             };
)
RETU

PROC PRC_estr     // estrutura do arquivo PRCESSOS
DBCREATE(dbf,{;
               {"processo"  ,"C",  9, 0},; // @R 99999/99/!!
               {"categ"     ,"C",  2, 0},; // !!
               {"saiu"      ,"C",  3, 0},; // 
               {"grup"      ,"C",  2, 0},; // !!
               {"num"       ,"C",  9, 0},; // 999999
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
               {"recdesp"   ,"C",  1, 0},; // !
               {"codigo"    ,"C",  6, 0},; // @!
               {"intlan"    ,"C",  8, 0},; // 99999999
               {"codlan"    ,"C", 20, 0};  // !!!-99999999-999-999
             };
)
RETU

PROC CST_estr     // estrutura do arquivo CSTSEG
DBCREATE(dbf,{;
               {"emissao_"  ,"D",  8, 0},; // @D
               {"hora"      ,"C",  5, 0},; // 99:99
               {"quem"      ,"C", 10, 0},; // 
               {"historic"  ,"C",  3, 0},; // 999
               {"contrato"  ,"C",  6, 0},; // 999999
               {"complement","C", 35, 0},; // @!
               {"qtdade"    ,"N",  5, 0},; // 99999
               {"valor"     ,"N",  9, 2},; // 999999.99
               {"tipo"      ,"C",  1, 0},; // 9
               {"circ"      ,"C",  3, 0};  // 999
             };
)
RETU

PROC MEN_estr     // estrutura do arquivo MENSAG
DBCREATE(dbf,{;
               {"seq"       ,"C",  6, 0},; // 999999
               {"filtro"    ,"C",210, 0},; // @S50
               {"mens1"     ,"M", 10, 0},; // @S50
               {"lancto_"   ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0};  // 
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
               {"pgrupo"    ,"C",  2, 0},; // !!
               {"p_filial"  ,"C",  2, 0},; // @!
               {"pcontrato" ,"C",  6, 0},; // 999999
               {"pgrau"     ,"C",  1, 0},; // 9
               {"pseq"      ,"N",  2, 0},; // 99
               {"pverpag"   ,"C",  1, 0},; // !
               {"preplanc"  ,"C",  1, 0},; // !
               {"lastcodigo","C",  6, 0},; // 999999
               {"nrcanc"    ,"N",  6, 0},; // 999999
               {"nrreint"   ,"N",  6, 0},; // 999999
               {"contarec"  ,"C",  5, 0},; // @!
               {"contapag"  ,"C",  5, 0},; // @!
               {"histrccar" ,"C",  3, 0},; // 999
               {"histrcfcc" ,"C",  3, 0},; // 999
               {"histrcrec" ,"C",  3, 0},; // 999
               {"histpg"    ,"C",  3, 0},; // 999
               {"nrauxrec"  ,"C",  8, 0},; // @R 99-999999
               {"mcodigo"   ,"C",  6, 0},; // 999999
               {"mtipo"     ,"C",  1, 0},; // !
               {"mcirc"     ,"C",  3, 0},; // 999
               {"mgrupvip"  ,"C",  2, 0},; // !!
               {"combarra"  ,"C",  1, 0},; // !
               {"cinscr"    ,"C",  1, 0},; // !
               {"comfalec"  ,"C",  1, 0},; // !
               {"mproc1"    ,"C",  5, 0},; // 99999
               {"mproc2"    ,"C",  2, 0},; // 99
               {"mproc3"    ,"C",  2, 0},; // !!
               {"impnrrec"  ,"C",  5, 0},; // 99999
               {"procimp"   ,"C",  9, 0},; // @R 99999/99/!!
               {"pvalor"    ,"N",  9, 2},; // @E 999,999.99
               {"pcob"      ,"C",  3, 0},; // !!!
               {"mmesref"   ,"C",  4, 0},; // @R 99/99
               {"pnumfcc"   ,"C",  8, 0},; // 
               {"p_cidade"  ,"C", 25, 0},; // @!
               {"p_recp"    ,"C",  1, 0},; // !
               {"setup1"    ,"C", 40, 0},; // 
               {"cgcsetup"  ,"C", 14, 0},; // @R 99.999.999/9999-99
               {"setup2"    ,"C", 50, 0},; // 
               {"setup3"    ,"C", 50, 0};  // 
             };
)
RETU

PROC MFI_estr     // estrutura do arquivo MFILIAL
DBCREATE(dbf,{;
               {"filial"    ,"C",  2, 0},; // @!
               {"seq0"      ,"C",  6, 0},; // 999999
               {"data_"     ,"D",  8, 0},; // @D
               {"por"       ,"C", 10, 0},; // 
               {"codigo"    ,"C",  9, 0},; // @!
               {"tcarenc_"  ,"D",  8, 0},; // @D
               {"obs1"      ,"C", 50, 0},; // @!
               {"obs2"      ,"C", 50, 0},; // @!
               {"obs3"      ,"C", 50, 0},; // @!
               {"idxd"      ,"C", 15, 0},; // @!
               {"idxm"      ,"C", 15, 0};  // @!
             };
)
RETU

* \\ Final de ADR_ESTR.PRG
