? "Programa para transferencia de arquivos"
? 
? "Informe sua senha para iniciar o programa"
cl= row()
senha="      "
set console off

@ cl,10 get senha
read
set console on
if senha#"123456"
 retu
endif
? " Abrindo arquivo de recebimentos"
use f:\vip4\arquivos\bxrec shared
? " Reorganizando arquivo"
set inde to f:\vip4\indices\bxr_serv
? " Criando arquivo tempor rio"
copy to f:\vip41\bxrtmp
use f:\vip41\arquivos\bxrec
? " Fazendo c¢pia de seguranca"
copy to bxrold
? " Acrescentando arquivo temporario"
appe from f:\vip41\bxrtmp
set uniq on
? " Verificando as duplicidades"
inde on ano+numero to bxrec
copy to f:\vip41\bxrok
use f:\vip41\bxrok
? " Reposicionando o arquivo correto"
copy to f:\vip41\arquivos\bxrec
? " Procedimento de finaliza‡Æo"
