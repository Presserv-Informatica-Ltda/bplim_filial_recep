
procedure bx_bxrec
para nrdays
if pcount()<1
 nrdays:=[20]
endi
?
? [Baixando ]+nrdays+[ dias.]
nrdays:=val(nrdays)
crow=row()
ccol=col()
sele b
use taxas
inde on codigo+tipo+circ to taxas EVAL ODOMETER() EVERY 50
sele a
use bxrec
go top

?
? [>>]
do while .not. eof()
// @ crow,ccol say [           ]
// @ crow,ccol say str(recno(),8)
 if BXREC->emitido_ < (DATE() -nrdays)
  skip
  loop
 endi
 ?? [.]
 chave=codigo+tipo+circ
 sele taxas
 seek chave

 IF !EMPT(valorpg).or.codigo<[000001]
  sele bxrec
  skip
  loop
 ENDI
 ?? chr(8)+[;]
 rlock()
 REPL TAXAS->pgto_ WITH BXREC->EMITIDO_,;
	    TAXAS->forma WITH [P]   ,;
	    TAXAS->baixa_ WITH DATE(),;
	    TAXAS->por WITH BXREC->por ,;
	    TAXAS->stat WITH [6]       ,;
	    TAXAS->valorpg WITH BXREC->valorpg
 unlock
 sele bxrec
 skip
enddo
