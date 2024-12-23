
procedure recmens

dbox([Informe uma expressao valida])
criterio=[]
auxiliar=space(150)
PTAB([],[GRUPOS],1,.T.)
SELE GRUPOS
filtra(.F.)
auxiliar=criterio+[~TRUE]
GO TOP
DO WHILE .NOT. EOF()
 IF CRIT ( auxiliar )
  ? codigo,nome,situacao
 ENDI
 skip
endd


dbox(auxiliar)
retur