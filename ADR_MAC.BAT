@echo off
REM - programa para preparar a execu‡„o/grava‡„o de tutorial
REM - (apaga *.DB*, *.NTX, *.SYS e consultas gravadas)
echo 
echo                       A T E N € Ž O !
echo Os arquivos de dados do sistema "ADMINISTRADORA - RECEP€ŽO" ser„o
echo eliminados para execu‡„o da macro. Se desejar cancelar esta opera‡„o
echo pressione CTRL-C AGORA!
PAUSE >NUL
if exist BXREC.DB* DEL BXREC.DB*
if exist BXR*..PRG DEL BXR*.NTX
if exist DB*.BXR DEL DB*.BXR
if exist ALENDER.DB* DEL ALENDER.DB*
if exist ALE*..PRG DEL ALE*.NTX
if exist DB*.ALE DEL DB*.ALE
if exist OBXEC.DB* DEL OBXEC.DB*
if exist OBX*..PRG DEL OBX*.NTX
if exist DB*.OBX DEL DB*.OBX
if exist GRUPOS.DB* DEL GRUPOS.DB*
if exist GRU*..PRG DEL GRU*.NTX
if exist DB*.GRU DEL DB*.GRU
if exist TAXAS.DB* DEL TAXAS.DB*
if exist TAX*..PRG DEL TAX*.NTX
if exist DB*.TAX DEL DB*.TAX
if exist ECOB.DB* DEL ECOB.DB*
if exist ECO*..PRG DEL ECO*.NTX
if exist DB*.ECO DEL DB*.ECO
if exist INSCRITS.DB* DEL INSCRITS.DB*
if exist INS*..PRG DEL INS*.NTX
if exist DB*.INS DEL DB*.INS
if exist GUIAS.DB* DEL GUIAS.DB*
if exist GUI*..PRG DEL GUI*.NTX
if exist DB*.GUI DEL DB*.GUI
if exist AFUNER.DB* DEL AFUNER.DB*
if exist AFU*..PRG DEL AFU*.NTX
if exist DB*.AFU DEL DB*.AFU
if exist IMPPAR.DB* DEL IMPPAR.DB*
if exist IMP*..PRG DEL IMP*.NTX
if exist DB*.IMP DEL DB*.IMP
if exist MEDICOS.DB* DEL MEDICOS.DB*
if exist MED*..PRG DEL MED*.NTX
if exist DB*.MED DEL DB*.MED
if exist TESPEC.DB* DEL TESPEC.DB*
if exist TES*..PRG DEL TES*.NTX
if exist DB*.TES DEL DB*.TES
if exist JUROS.DB* DEL JUROS.DB*
if exist JUR*..PRG DEL JUR*.NTX
if exist DB*.JUR DEL DB*.JUR
if exist TFILIAIS.DB* DEL TFILIAIS.DB*
if exist TFI*..PRG DEL TFI*.NTX
if exist DB*.TFI DEL DB*.TFI
if exist ARQGRUP.DB* DEL ARQGRUP.DB*
if exist ARQ*..PRG DEL ARQ*.NTX
if exist DB*.ARQ DEL DB*.ARQ
if exist REGIAO.DB* DEL REGIAO.DB*
if exist REG*..PRG DEL REG*.NTX
if exist DB*.REG DEL DB*.REG
if exist COBRADOR.DB* DEL COBRADOR.DB*
if exist COB*..PRG DEL COB*.NTX
if exist DB*.COB DEL DB*.COB
if exist CLASSES.DB* DEL CLASSES.DB*
if exist CLA*..PRG DEL CLA*.NTX
if exist DB*.CLA DEL DB*.CLA
if exist CIRCULAR.DB* DEL CIRCULAR.DB*
if exist CIR*..PRG DEL CIR*.NTX
if exist DB*.CIR DEL DB*.CIR
if exist CPRCIRC.DB* DEL CPRCIRC.DB*
if exist CPR*..PRG DEL CPR*.NTX
if exist DB*.CPR DEL DB*.CPR
if exist PRCESSOS.DB* DEL PRCESSOS.DB*
if exist PRC*..PRG DEL PRC*.NTX
if exist DB*.PRC DEL DB*.PRC
if exist FNCS.DB* DEL FNCS.DB*
if exist FNC*..PRG DEL FNC*.NTX
if exist DB*.FNC DEL DB*.FNC
if exist HISTORIC.DB* DEL HISTORIC.DB*
if exist HIS*..PRG DEL HIS*.NTX
if exist DB*.HIS DEL DB*.HIS
if exist CSTSEG.DB* DEL CSTSEG.DB*
if exist CST*..PRG DEL CST*.NTX
if exist DB*.CST DEL DB*.CST
if exist MENSAG.DB* DEL MENSAG.DB*
if exist MEN*..PRG DEL MEN*.NTX
if exist DB*.MEN DEL DB*.MEN
if exist ORDPGRC.DB* DEL ORDPGRC.DB*
if exist ORD*..PRG DEL ORD*.NTX
if exist DB*.ORD DEL DB*.ORD
if exist PAR_ADM.DB* DEL PAR_ADM.DB*
if exist ADR_*.SYS DEL ADR_*.SYS
