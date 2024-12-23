call memoconv assoc asssmt
call memoconv inscrit inssmt
call memoconv c:\vip4\arquivos\grupos grusmt
call processa
call final
cd \teste
arj a arqsv5 arquivos\grupos.* arquivos\inscrits.* arquivos\taxas.* -r
arj a arqsv5X indices\grupo*.* indices\inscri*.* indices\taxa*.* -r
