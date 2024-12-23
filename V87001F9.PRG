/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: V87001F9.PRG
 \ Data....: 21-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valida‡„o da variavel CONFIRME, relatorio ADM_R038
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

// Preparados em R08701F9()
PUBL vlseg:=0, valororig:=0  // Composi‡„o do valor
PUBL lindeb:=[]  // Linha resumo dos d‚bitos (Tipo+circ ...)
PUBL detdeb [10] // Detalhamento dos d‚bitos tipo+circ+vencto+valor...
AFILL(detdeb,[])

// Preparados em R08703F9()
PUBL ultprc:=[]  // Ultima cartinha montada, se for igual n„o refaz...
PUBL detprc [10] // Cartinha dos falecidos
AFILL(detprc,[])

RETU .t.       // <- deve retornar um valor L¢GICO

* \\ Final de V87001F9.PRG
