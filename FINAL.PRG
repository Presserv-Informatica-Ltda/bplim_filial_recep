procedure final
#include "SIXNSX.CH"
#define RDDNAME "SIXNSX"
#define MEMOEXT ".SMT"
set date brit
set cent on
? [Juntando arquivos Plano e IV]
?
? [Processando Associados.]
use ..\arquivos\grupos
zap
? [Juntando Vip4]
appe from grupl
? [Juntando IV]
appe from gruiv
? [organizando por contrato]
inde on codigo to ..\indices\grupos1
? [organizando por nome]
inde on nome to ..\indices\grupos2

? [Processando Cobrancas.]
use ..\arquivos\taxas
zap
? [Juntando Vip4]
appe from taxpl
? [juntando IV]
appe from taxiv
? [Reorganizando codigos]
repl circ with right([000]+circ,3), tipo with IIF(tipo$[0123456789],tipo,[0]) all
repl codigo with left(codigo,9)+tipo+circ all
? [Organizando por contrato]
inde on codigo to ..\indices\taxas1
? [Organizando por cobranca]
inde on cobranca to ..\indices\taxas2
? [Organizando por cod.Lancto]
inde on codlan to ..\indices\taxas3


? [Processando Inscritos.]
use ..\arquivos\inscrits
zap
? [Juntando Vip4]
appe from inspl
? [Juntando IV]
appe from insiv
? [Reorganizando codigos]
repl codigo with left(codigo,9)+grau+str(seq,3) all
? [Organizando por contrato]
inde on codigo to ..\indices\inscrit1
? [Organizando por nome]
inde on nome to ..\indices\inscrit2
