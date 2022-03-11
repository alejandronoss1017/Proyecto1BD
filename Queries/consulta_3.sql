SELECT  CLTE.codigocliente CODIGO,
        CLTE.nombrecliente || ' ' || CLTE.apellidocliente AS CLIENTE,
        NVL(cuentas100.n_cuentas, 0) Cuentas_con_titularidad_100,
        NVL(cuentasno100.n_cuentas, 0) Cuentas_sin_titularidad_100,
        PRIMERMOV.tiempo PRIMER_MOVIMIENTO,
        NVL(MOVSN.movimientos, 0) CANTIDAD_MOVIMIENTOS,
        NVL(DEBITOS.total, 0) SUMA_DEBITOS,
        NVL(CREDITOS.total,0) SUMA_CREDITOS,
        NVL(RENDIMIENTOS.total, 0) SUMA_RENDIMIENTOS,
        NVL(IMPUESTOS.total, 0) SUMA_IMPUESTOS
FROM    clientes CLTE

-- Cuetnas 100
LEFT OUTER JOIN 
(SELECT  codigocliente CLTE, COUNT(*) N_CUENTAS
FROM    titulares
WHERE   porcentajetitularidad  = 100
GROUP BY codigocliente) CUENTAS100 
ON clte.codigocliente = cuentas100.clte

-- Numero cuentas titularidad < 100
LEFT OUTER JOIN
(SELECT  codigocliente CLTE, COUNT(*) N_CUENTAS
FROM    titulares
WHERE   porcentajetitularidad  < 100
GROUP BY codigocliente) CUENTASNO100
ON clte.codigocliente = cuentasno100.clte

-- Fecha primer movimientos
LEFT OUTER JOIN
        (SELECT  codigocliente CLTE, MIN(movs.time) tiempo
        FROM    titulares LEFT OUTER JOIN 
        (SELECT  numerocuenta CUENTA,
        TO_CHAR(MIN(mov.fechamovimiento), 'DD/MM/YYYY HH24:MI:SS') TIME
        FROM movimientos MOV
        GROUP BY numerocuenta) MOVS
        ON movs.cuenta = titulares.numerocuenta
        GROUP BY codigocliente) PRIMERMOV
    ON   CLTE.codigocliente = PRIMERMOV.clte

-- Cantidad de movimientos
LEFT OUTER JOIN
(SELECT  codigocliente CLTE,
        SUM(movs.nmov) MOVIMIENTOS
        FROM    titulares LEFT OUTER JOIN 
            (SELECT  numerocuenta CUENTA,
        COUNT(*) NMOV
            FROM movimientos MOV
            GROUP BY numerocuenta) MOVS
        ON movs.cuenta = titulares.numerocuenta
        GROUP BY codigocliente) MOVSN
    ON movsn.clte = clte.codigocliente
    
-- Créditos
LEFT OUTER JOIN
(SELECT  codigocliente CLTE,
        SUM(debitos.suma) TOTAL
FROM    titulares LEFT OUTER JOIN 
        (SELECT  numerocuenta CUENTA,
                SUM(valor) SUMA
                FROM movimientos MOV
                WHERE mov.tipo = 'D'
                GROUP BY numerocuenta) DEBITOS
        ON debitos.cuenta = titulares.numerocuenta
GROUP BY codigocliente) DEBITOS
ON debitos.clte = clte.codigocliente
-- creditos
LEFT OUTER JOIN
(SELECT  codigocliente CLTE,
        SUM(creditos.suma) TOTAL
FROM    titulares LEFT OUTER JOIN 
        (SELECT  numerocuenta CUENTA,
                SUM(valor) SUMA
                FROM movimientos MOV
                WHERE mov.tipo = 'C'
                GROUP BY numerocuenta) creditos
        ON creditos.cuenta = titulares.numerocuenta
GROUP BY codigocliente) creditos
ON creditos.clte = clte.codigocliente
-- rendimientos
LEFT OUTER JOIN
(SELECT  codigocliente CLTE,
        SUM(rendimientos.suma) TOTAL
FROM    titulares LEFT OUTER JOIN 
        (SELECT  numerocuenta CUENTA,
                SUM(valor) SUMA
                FROM movimientos MOV
                WHERE mov.tipo = 'R'
                GROUP BY numerocuenta) rendimientos
        ON rendimientos.cuenta = titulares.numerocuenta
GROUP BY codigocliente) rendimientos
ON rendimientos.clte = clte.codigocliente
-- impuestos
LEFT OUTER JOIN
(SELECT  codigocliente CLTE,
        SUM(impuestos.suma) TOTAL
FROM    titulares LEFT OUTER JOIN 
        (SELECT  numerocuenta CUENTA,
                SUM(valor) SUMA
                FROM movimientos MOV
                WHERE mov.tipo = 'I'
                GROUP BY numerocuenta) impuestos
        ON impuestos.cuenta = titulares.numerocuenta
GROUP BY codigocliente) impuestos
ON impuestos.clte = clte.codigocliente
ORDER BY clte.codigocliente
;
