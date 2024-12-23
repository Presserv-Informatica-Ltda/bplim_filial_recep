
sele b
use ordpgrc
inde on numop to bb

sele a
use bxrec
go top
do while .not. eof()
 mnumop=numop
 sele b
 seek mnumop
 if eof()
	appe blank
	REPL ORDPGRC->origem WITH [ADM],;
				ORDPGRC->lancto_ WITH DATE(),;
				ORDPGRC->por WITH a->por,;
				ORDPGRC->numconta WITH IIF(EMPT(M->usuario),PADR(M->contarec+ide_maq,10,' '),PADR(M->usuario,10,' ')),;
        ORDPGRC->historico WITH M->histrcfcc,;
        ORDPGRC->debcred WITH [C],;
        ORDPGRC->valortotal WITH 0,;
        ORDPGRC->vencto_ WITH DATE(),;
        ORDPGRC->documento WITH [FCC/Taxas],;
        ORDPGRC->complement WITH [FCC/Taxas pagas na Recep‡„o]

   #ifdef COM_REDE
    ORDPGRC->(DBUNLOCK())                          // libera o registro
   #endi

  ENDI
  IF !PTAB(PADR(SUBSTR(M->ide_maq,2),4)+[BXR],[IMPPAR],1)
   ord_=LEN(sistema[EVAL(qualsis,"IMPPAR"),O_CHAVE])
   chv_="BXR-"+intlan+"-002"
   PTAB(chv_,"IMPPAR",ord_)
   FAZ_LANC("IMPPAR",chv_)
   REPL IMPPAR->idmaq WITH PADR(SUBSTR(M->ide_maq,2),4),;
        IMPPAR->base WITH [BXR]

   #ifdef COM_REDE
    IMPPAR->(DBUNLOCK())                           // libera o registro
   #endi

  ENDI
   IF EMPT(numop)
    IF op_menu=INCLUSAO
     numop=ORDPGRC->numop
    ELSE
     REPL numop WITH ORDPGRC->numop
    ENDI
   ENDI

  #ifdef COM_REDE
	 IF PTAB(numop,'ORDPGRC',1)
    REPBLO('ORDPGRC->nrdoctos',{||ORDPGRC->nrdoctos + 1})
   ENDI
   IF !EMPT(valorpg)
    REPBLO('TAXAS->pgto_',{||DATE()})
    REPBLO('TAXAS->forma',{||[P]})
    REPBLO('TAXAS->baixa_',{||DATE()})
    REPBLO('TAXAS->por',{||M->usuario})
    REPBLO('TAXAS->stat',{||[6]})
    REPBLO('TAXAS->valorpg',{||valorpg})
   ENDI
   IF op_menu=INCLUSAO
    emitido_=DATE()
    por=M->usuario
    filial=M->p_filial
   ELSE
    REPL emitido_ WITH DATE()
    REPL por WITH M->usuario
    REPL filial WITH M->p_filial
   ENDI
   IF EMPT(numop).AND.PTAB(IIF(EMPT(M->usuario),PADR(M->contarec+ide_maq,10,' '),PADR(M->usuario,10,' '))+M->histrcfcc+[       ],'ORDPGRC',2)
    REPBLO('ORDPGRC->valortotal',{||ORDPGRC->valortotal+valorpg})
   ENDI
   IF !EMPT(numop).AND.PTAB(numop,'ORDPGRC',1)
    REPBLO('ORDPGRC->valortotal',{||ORDPGRC->valortotal +valorpg})
