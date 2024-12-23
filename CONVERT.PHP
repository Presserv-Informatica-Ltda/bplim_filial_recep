
#!/usr/local/bin/php
<?

//cria banco de dados CREDENC.DBF
if (!file_exists("smb/dados/CREDENC.DBF"))
{
  $dbf_name="smb/dados/CREDENC.DBF";
  $def = array(array("ai"        ,"C",  5),; //
	       array("codbenefic","C", 10),; //
	       array("oldescrito","C",  5),; //
	       array("oldclasse" ,"C",  3),; //
	       array("prioridade","C",  2),; //
	       array("status"    ,"C",  2),; // !!
	       array("oldespec"  ,"C", 50),; // @!
	       array("detalhes"  ,"M", 10),; // @S35
	       array("vantagens" ,"M", 10),; // @S35
	       array("condicoes" ,"M", 10),; // @S35
	       array("informutil","M", 10),; // @S35
	       array("nome"      ,"C", 50),; //
	       array("endereco"  ,"C", 50),; //
	       array("bairro"    ,"C", 30),; // @!
	       array("cidade"    ,"C", 30),; // @!
	       array("uf"        ,"C",  2),; // !!
	       array("cep"       ,"C",  8),; // @R 99999-999
	       array("contato"   ,"C", 50),; // @!
	       array("fonecom1"  ,"C", 15),; //
	       array("fonecom2"  ,"C", 15),; // @!
	       array("fonecel"   ,"C", 15),; // @!
	       array("foneres1"  ,"C", 15),; // @!
	       array("email"     ,"C", 50),; // @!
	       array("fax"       ,"C", 15),; // @!
	       array("bip"       ,"C", 15),; // @!
	       array("fonesdiv"  ,"C", 30),; // @!
	       array("datainc"   ,"D",  8),; // @D
	       array("dataalt"   ,"D",  8),; // @D
	       array("codcidade" ,"C",  4),; //
	       array("contrato"  ,"C", 10),; //
	       array("flagetq"   ,"C", 10),; //
	       array("codclasse" ,"C",  6) //
	       );
  dbase_create($dbf_name, $def);
}

include("config.inc");

$conexao = "iv";
$connect = mysql_connect($ip,$login,$senha) or die ("Erro ao abrir conexao");
mysql_select_db($conexao,$connect) or die("Erro ao selecionar base");

// alimenta base CREDENC.DBF para sistema VIP4.

$dbf_name = "smb/dados/credenc.DBF";
$con_dbf2 = dbase_open($dbf_name,2) or die("Erro ao abrir base DBF: $dbf_name");

$consulta = "SELECT * FROM credenciado;
$executa = mysql_query($consulta,$connect);

while ($resultado = mysql_fetch_array($executa))
{
    $def = array($resultado[codassoc],$resultado[parc],$resultado[data],$resultado[valorpg],$resultado[cx_num],$resultado[login]);
  $def = array($resultado[ai],
	       $resultado[codbenefic],
	       $resultado[oldescrito],
	       $resultado[oldclasse],
	       $resultado[prioridade],
	       $resultado[status],
	       $resultado[oldespec],
	       $resultado[detalhes],
	       $resultado[vantagens],
	       $resultado[condicoes],
	       $resultado[informutil],
	       $resultado[nome],
	       $resultado[endereco],
	       $resultado[bairro],
	       $resultado[cidade],
	       $resultado[uf],
	       $resultado[cep],
	       $resultado[contato],
	       $resultado[fonecom1],
	       $resultado[fonecom2],
	       $resultado[fonecel],
	       $resultado[foneres1],
	       $resultado[email],
	       $resultado[fax],
	       $resultado[bip],
	       $resultado[fonesdiv],
	       $resultado[datainc],
	       $resultado[dataalt],
	       $resultado[codcidade],
	       $resultado[contrato],
	       $resultado[flagetq],
	       $resultado[codclasse])

    dbase_add_record($con_dbf2,$def);
}
dbase_close($con_dbf2);

mysql_close($connect);
?>
