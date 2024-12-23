procedure acins03
#ifdef CDX
  #include "SIXCDX.CH"
  #define RDDNAME "SIXCDX"
  #define MEMOEXT ".FPT"
#else
  #include "SIXNSX.CH"
  #define RDDNAME "SIXNSX"
  #define MEMOEXT ".SMT"
#endif


para rfil
set cent on
set date brit

if !file("d:grupos.dbf")
 use grupos
 copy next 1 to d:grupos
 use d:grupos
 zap
endi
use grupos
if val(codigo)>0
 repl codigo with rfil+codigo all
else
 repl codigo with rfil+substr(codigo,3) all
endi
use d:grupos
appe from c:grupos


if !file("d:inscrits.dbf")
 use inscrits
 copy next 1 to d:inscrits
 use d:inscrits
 zap
endi
use inscrits
if val(codigo)>0
 repl codigo with rfil+left(codigo,6)+grau+str(seq,2) all
else
 repl codigo with rfil+substr(codigo,3,6)+grau+str(seq,2) all
endi
use d:inscrits
appe from c:inscrits


if !file("d:taxas.dbf")
 use taxas
 copy next 1 to d:taxas
 use d:taxas
 zap
endi
use taxas
if val(codigo)>0
 repl codigo with rfil+left(codigo,6)+[  ]+tipo+circ all
else
 repl codigo with rfil+substr(codigo,3) all
endi
use d:taxas
appe from taxas



