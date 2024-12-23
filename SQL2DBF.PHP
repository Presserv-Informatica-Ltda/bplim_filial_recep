<?
include"conf.php";

$connect = mysql_connect($ip,$login,$senha) or die ("Erro ao conectar");
mysql_select_db($conexao,$connect) or die("Erro ao selecionar base");

$con_associado_dbf = dbase_open($dbf_name_associados,2) or die("Erro ao abrir base DBF: $dbf_name_associados");                   // 2=R/W

$consulta = "SELECT * FROM associado";
$sel_associado = mysql_query($consulta,$connect);

while ($resultado = mysql_fetch_array($sel_associado))
{
$def = array(
 $resultado[codassoc],
 $resultado[nome],
 $resultado[situacao],
 $resultado[sexo],
 $resultado[estcivil],
 $resultado[nascimento],
 $resultado[cpf],
 $resultado[rg ],
 $resultado[exp],
 $resultado[endereco],
 $resultado[bairro],
 $resultado[cidade],
 $resultado[cep],
 $resultado[uf],
 $resultado[fone1],
 $resultado[fone2],
 $resultado[protocolo],
 $resultado[categoria],
 $resultado[codfuner],
 $resultado[codplano],
 $resultado[planonum],
 $resultado[atendimento],
 $resultado[data_adesao],
 $resultado[obs],
 $resultado[atrasado],
 $resultado[regiao],
 $resultado[cobrador],
 $resultado[funerais],
 $resultado[qtcircs],
 $resultado[mensagem],
 $resultado[flagfalecida],
 $resultado[plano],
 $resultado[confeccao],
 $resultado[pedcartao],
 $resultado[validadestr],
 $resultado[codlegivel],
 $resultado[cartao],
 $resultado[carencia],
 $resultado[saitaxa]
);
// echo $resultado[codassoc];
    dbase_add_record($con_associado_dbf,$def);
}
dbase_close($con_associado_dbf);
echo "Associado OK!<br>\n";
//-----------------------------------------------

$con_inscritos_dbf = dbase_open($dbf_name_inscritos,2) or die("Erro ao abrir base DBF: $dbf_name_inscritos");   // 2=Read/Write

$consulta = "SELECT * FROM inscritos";
$sel_inscritos = mysql_query($consulta,$connect);

while ($resultado = mysql_fetch_array($sel_inscritos))
{
$def = array(
 $resultado[codassoc],
 $resultado[seq],
 $resultado[nome],
 $resultado[situacao],
 $resultado[data_falecto],
 $resultado[flagfalecida],
 $resultado[parentesco],
 $resultado[plano],
 $resultado[confeccao],
 $resultado[pedcartao],
 $resultado[validadestr],
 $resultado[codlegivel],
 $resultado[cartao],
 $resultado[incdata],
 $resultado[carencia]
);
    dbase_add_record($con_inscritos_dbf,$def);
}
dbase_close($con_inscritos_dbf);
echo "Inscritos OK!<br>\n";
//-----------------------------------------------------------------

$con_rec_parcela_dbf = dbase_open($dbf_name_rec_parcela,2) or die("Erro ao abrir base DBF: $dbf_name_rec_parcela");   // 2=Read/Write

$consulta = "SELECT * FROM rec_parcela";
$sel_rec_parcela = mysql_query($consulta,$connect);

while ($resultado = mysql_fetch_array($sel_rec_parcela))
{
$def = array(
 $resultado[ai],
 $resultado[codassoc],
 $resultado[codadesao],
 $resultado[parc],
 $resultado[emissao],
 $resultado[codcobr],
 $resultado[codvend],
 $resultado[vencto],
 $resultado[vlrsaldo],
 $resultado[situacao],
 $resultado[estado],
 $resultado[valor],
 $resultado[valor60],
 $resultado[valor30],
 $resultado[valornais],
 $resultado[original],
 $resultado[plano],
 $resultado[regiao]
);          

    dbase_add_record($con_rec_parcela_dbf,$def);
}           
dbase_close($con_rec_parcela_dbf);
echo "Rec_Parcela OK!<br>\n";
//-------------------------------------------------------
/*

$con_cre_cadastro_dbf = dbase_open($dbf_name_cre_cadastro,2) or die("Erro ao abrir base DBF: $dbf_name_cre_cadastro");   // 2=Read/Write

$consulta = "SELECT * FROM cre_cadastro";
$sel_cre_cadastro = mysql_query($consulta,$connect);

while ($resultado = mysql_fetch_array($sel_cre_cadastro))
{
$def = array(
 $resultado[codbenefic],
 $resultado[nome],
 $resultado[fonesdiv],
 $resultado[endereco],
 $resultado[bairro],
 $resultado[cidade],
 $resultado[cep],
 $resultado[uf],
 $resultado[detalhes],
 $resultado[vantagens],
 $resultado[condicoes],
 $resultado[informutil],
 $resultado[prioridade],
 $resultado[status],
 $resultado[contrato],
 $resultado[email],
 $resultado[fonecom1],
 $resultado[fonecom2],
 $resultado[fonecel],
 $resultado[foneres],
 $resultado[fax],
 $resultado[bip],
 $resultado[oldespec],
 $resultado[datainc],
 $resultado[dataalt]
);
    dbase_add_record($con_cre_cadastro_dbf,$def);
}
dbase_close($con_cre_cadastro_dbf);
echo "Cre_Cadastro OK!<br>\n";
*/
mysql_close($connect);
echo "<br><b>Concluido!</b><br>\n";
?>
