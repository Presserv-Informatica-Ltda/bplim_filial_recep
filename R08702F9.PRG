procedure r08702f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R08701F9.PRG
 \ Data....: 17-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valor Total do relat¢rio ADP_R087
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adrbig.ch"    // inicializa constantes manifestas

 LOCAL reg_dbf1:=POINTER_DBF()
 cod:=codigo     // C¢digo da taxa a imprimir
 emx:=emissao_   // Emiss„o da taxa a ser impressa...
 keycst:=TAXAS->codigo+SUBSTR('123  123',VAL(TAXAS->tipo),1)+TAXAS->circ
 M->recvalor:=IIF(M->racum=[S],0,valor)
 vlseg:=0
 IF PTAB(keycst,[CSTSEG],3)
  SELE CSTSEG
  DO WHILE ! EOF() .AND. keycst = codigo+tipo+circ
   vlseg+=CSTSEG->vlcontr
   SKIP
  ENDDO
  SELE TAXAS
 ENDI

 SELE TAXAS

 PTAB(codigo,'TAXAS',1,.t.)

 M->contx:=0
 lindeb:=[]

 DO WHILE !EOF().AND.TAXAS->codigo=cod.AND.M->racum=[S]
  IF TAXAS->valorpg>0         // Somente taxas pendentes
   SKIP
   LOOP
  ENDI

// Ser„o consideradas vencidas as taxas anteriores a emiss„o da
// que ser  impressa.

  IF TAXAS->emissao_ <= emx .AND. ;
     (SUBSTR('123  123',VAL(TAXAS->tipo),1)$M->rtipo) // Somente taxas pendentes

   M->recvalor+=TAXAS->valor
   keycst:=TAXAS->codigo+SUBSTR('123  123',VAL(TAXAS->tipo),1)+TAXAS->circ
   IF PTAB(keycst,[CSTSEG],3)
    SELE CSTSEG
    DO WHILE ! EOF() .AND. keycst = codigo+tipo+circ
     vlseg+=CSTSEG->vlcontr
     SKIP
    ENDDO
    SELE TAXAS
   ENDI

   contx+=1
   IF CONTX<11
    detdeb[contx]:=TAXAS->tipo+[ ]+TAXAS->circ+[ ]+DTOC(TAXAS->emissao_)+[ ]+;
    TRANSF(TAXAS->valor,"@E 9,999.99")+[ | ]
   ENDI
   lindeb+=TAXAS->tipo+[ ]+TAXAS->circ+[, ]
  ENDI
  SKIP
 ENDDO

 M->recvalor-=M->vlseg

 POINTER_DBF(reg_dbf1)

RETU M->recvalor          // <- deve retornar um valor qualquer

* \\ Final de R08701F9.PRG
