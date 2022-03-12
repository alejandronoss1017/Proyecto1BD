-- Crear la vista
CREATE OR replace VIEW estadisticaOficinas (
oficina,
presupuesto,
"Numero de cuentas",
"Saldo cuenta ahorros",
"Saldo cuenta Corriente"
) AS
SELECT  a.nombre, 
        a.presupuesto,
        COUNT(c.numeroCuenta),
        SUM(DECODE(Tipo, 'A', saldo, 0)) Ahorros,
        SUM(DECODE(Tipo, 'C', saldo, 0)) Corriente
FROM 	oficinas A,
     	titulares B, 
     	cuentas C
WHERE	c.codigoOficina = a.codigoOficina
		AND b.numeroCuenta = c.numeroCuenta
GROUP BY a.nombre, a.presupuesto;

-- Dar permisos
GRANT SELECT ON estadisticaOficinas TO dba  ; 

-- Ver la vista
SELECT * FROM estadisticaOficinas;

COMMIT;