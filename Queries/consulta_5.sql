create or replace view estadisticaOficinas (
oficina,
presupuesto,
"Numero de cuentas",
"Saldo cuenta ahorros",
"Saldo cuenta Corriente"
)as
Select  a.nombre, 
        a.presupuesto,
        Count(c.numeroCuenta),
        Sum(decode(Tipo, 'A', saldo, 0)) Ahorros,
        Sum(decode(Tipo, 'C', saldo, 0)) Corriente
From oficinas a,
     titulares b, 
     cuentas c
Where c.codigoOficina = a.codigoOficina
And   b.numeroCuenta = c.numeroCuenta
Group by  a.nombre, a.presupuesto;
/

grant select on estadisticaOficinas to dba  ; 


select  *
from estadisticaOficinas;