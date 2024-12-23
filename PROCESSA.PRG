#include "SIXNSX.CH"
#define RDDNAME "SIXNSX"
#define MEMOEXT ".SMT"
set date brit
set cent on
? [Processando dados do BP-Net]
?
? [Processando Associados.IV]
use gruiv
zap
appe from asssmt
repl codigo with [020]+strzero(VAL(codigo),6), grupo with [IV] all

? [Processando Cobrancas.IV]
use taxiv
zap
appe from receber for str(situacao,1)$[015]
repl codigo with [020]+strzero(VAL(codigo),6), circ with right([000]+circ,3) all

? [Processando Inscritos.IV]
use insiv
zap
appe from inssmt
repl codigo with [020]+strzero(VAL(codigo),6) all

? [Processando Associados.PL]
use grupl
zap
appe from grusmt
repl codigo with [010]+codigo all
? [Processando Cobrancas.PL]
use taxpl
zap
appe from c:\vip4\arquivos\taxas
repl codigo with [010]+codigo, cobranca with codigo+tipo+circ all
? [Processando Inscritos.PL]
use inspl
zap
appe from c:\vip4\arquivos\inscrits
repl codigo with [010]+codigo all


