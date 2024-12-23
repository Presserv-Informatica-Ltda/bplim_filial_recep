NET USE J: /D
NET USE J: \\BP1\DADOS BOMPASTOR
del c:\window\temp\*.rem
CD J:\BPNET\ARQUIVOS
D:
cd d:\teste\prepara
copy asschk.db* assoc.* /y
COPY J:ASSO*.* D:\DADOS\BPNET\ARQUIVOS /Y
call DB2DBF D:\DADOS\BPNET\ARQUIVOS\ASSOC D:\TESTE\PREPARA\ASSOC
COPY J:RECEB*.* D:\DADOS\BPNET\ARQUIVOS /Y
copy recchk.db* receber.* /y
@echo off
@echo Aguardando liberacao do associado
:wait
@if exist c:\windows\temp\inmem*.rem goto wait:
@echo on
call DB2DBF D:\DADOS\BPNET\ARQUIVOS\RECEBER D:\TESTE\PREPARA\RECEBER
COPY J:INSCR*.* D:\DADOS\BPNET\ARQUIVOS /Y
copy inschk.d* inscrit.* /y
@echo off
@echo Aguardando liberacao de contas a receber
:wait1
@if exist c:\windows\temp\inmem*.rem goto wait1:
@echo on
call DB2DBF D:\DADOS\BPNET\ARQUIVOS\INSCRIT D:\TESTE\PREPARA\INSCRIT
NET USE J: /D
@echo off
@echo Aguardando liberacao de Inscritos
:wait2
@if exist c:\windows\temp\inmem*.rem goto wait2:
@call poscop.bat

