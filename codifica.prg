para regini
set dele on
set cent on
set date brit
use grupos
go top
ctk:=1
//goto ((ctk-1)*1000)+1
PRIVATE rend:=space(35)
PRIVATE rbai:=space(20)
PRIVATE rcid:=space(25)
PRIVATE rcep:=space(08)
PRIVATE rtel:=space(25)
PRIVATE rcon:=space(25)
PRIVATE rema:=space(50)
PRIVATE rrg:=space(15)
REM PRIVATE rcpf:=space(15)
do while !eof()

 rend:=encript(endereco)
 rbai:=encript(bairro)
 rcid:=encript(cidade)
 rcep:=encript(cep)
 rtel:=encript(telefone)
 rcon:=encript(contato)
 rema:=encript(email)
 rrg:=encript(rg)
// rcpf:=encript(cpf)
/*
 rend:=(endereco)
 rbai:=(bairro)
 rcid:=(cidade)
 rcep:=(cep)
 rtel:=(telefone)
*/
 repl endereco with M->rend ,;
     bairro with M->rbai
 repl cidade with M->rcid,;
     cep with M->rcep,;
     telefone with M->rtel,;
     contato with M->rcon,;
     email with M->rema,;
     rg  with M->rrg

//     cpf with M->rcpf,;

  @ 10,10 SAY RECNO()
 skip
endd

retu

Function CRIPTOGRAFA(Pstr, Psenha, Pencript)
LOCAL Tcript, Tx, Tascii
LOCAL Tlensenha
Tlensenha = Len(AllTrim(Psenha))
      Tcript = ""
      For Tx = 1 To Len(Pstr)
          If Pencript           //&& Criptografa
             Tascii = Asc(Subs(Pstr, Tx, 1)) + ;
                       Asc(Subs(Psenha, ((Tx + 77) % Tlensenha) + 1, 1))
          Else                          && DesCriptografa
             Tascii = Asc(Subs(Pstr, Tx, 1)) - ;
                       Asc(Subs(Psenha, ((Tx + 77) % Tlensenha) + 1, 1))
          EndIf
          Tcript = Tcript + Chr(Tascii)
      Next
Return(Tcript)


function encript(caracteres)
return CRIPTOGRAFA(caracteres, 'bompastor', .t.)

function decript(caracteres)
return CRIPTOGRAFA(caracteres, 'bompastor', .f.)

