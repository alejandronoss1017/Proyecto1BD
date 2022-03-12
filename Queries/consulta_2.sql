--Consulta MASTER

SELECT oficinas.nombre,
    NVL(num_cuentas_totales.conteo, 0) AS numero_cuentas_totales,
    NVL(num_cuentas_hombres.conteo_cuentas_hombres,0) AS numero_cuentas_hombres,
    NVL(num_cuentas_mujeres.conteo_cuentas_mujeres,0) AS numero_cuentas_mujeres,
    TO_CHAR(NVL(prom_saldo_ahorros_hombres.promedio,0)) AS promedio_cuentas_ahorros_hombres,
    TO_CHAR(NVL(prom_saldo_ahorros_mujeres.promedio,0)) AS promedio_cuentas_ahorros_mujeres,
    NVL(cantidad_movimientos.conteo_movimientos,0) AS cantidad_de_movimientos

FROM oficinas
    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre ,COUNT(cuentas.numerocuenta) AS conteo
    FROM cuentas
    LEFT OUTER JOIN oficinas
        ON oficinas.codigooficina = cuentas.codigooficina
    GROUP BY oficinas.nombre
    ) num_cuentas_totales
    ON oficinas.nombre = num_cuentas_totales.nombre

    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre,COUNT(DISTINCT(cuentas.numeroCuenta)) AS conteo_cuentas_hombres
    FROM oficinas
    LEFT OUTER JOIN cuentas
        ON oficinas.codigoOficina = cuentas.codigoOficina
    LEFT OUTER JOIN titulares 
        ON cuentas.numeroCuenta = titulares.numeroCuenta
    LEFT OUTER JOIN clientes
        ON titulares.codigoCliente = clientes.codigoCliente
    WHERE clientes.genero = 'M'
    GROUP BY oficinas.nombre
    ) num_cuentas_hombres
    ON oficinas.nombre = num_cuentas_hombres.nombre

    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre,COUNT(DISTINCT(cuentas.numeroCuenta)) AS conteo_cuentas_mujeres
    FROM oficinas
    LEFT OUTER JOIN cuentas
        ON oficinas.codigoOficina = cuentas.codigoOficina
    LEFT OUTER JOIN titulares 
        ON cuentas.numeroCuenta = titulares.numeroCuenta
    LEFT OUTER JOIN clientes
        ON titulares.codigoCliente = clientes.codigoCliente
    WHERE clientes.genero = 'F'
    GROUP BY oficinas.nombre
    ) num_cuentas_mujeres
    ON oficinas.nombre = num_cuentas_mujeres.nombre

    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre,AVG(cuentas.Saldo) AS promedio
    FROM oficinas
    LEFT OUTER JOIN cuentas
        ON oficinas.codigoOficina = cuentas.codigoOficina
    LEFT OUTER JOIN titulares 
        ON cuentas.numeroCuenta = titulares.numeroCuenta
    LEFT OUTER JOIN clientes
        ON titulares.codigoCliente = clientes.codigoCliente
    WHERE clientes.genero = 'M'
    AND cuentas.tipo = 'A'
    GROUP BY oficinas.nombre
    ) prom_saldo_ahorros_hombres
    ON oficinas.nombre = prom_saldo_ahorros_hombres.nombre

    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre,AVG(cuentas.Saldo) AS promedio
    FROM oficinas
    LEFT OUTER JOIN cuentas
        ON oficinas.codigoOficina = cuentas.codigoOficina
    LEFT OUTER JOIN titulares 
        ON cuentas.numeroCuenta = titulares.numeroCuenta
    LEFT OUTER JOIN clientes
        ON titulares.codigoCliente = clientes.codigoCliente
    WHERE clientes.genero = 'F'
    AND cuentas.tipo = 'A'
    GROUP BY oficinas.nombre
    ) prom_saldo_ahorros_mujeres
    ON oficinas.nombre = prom_saldo_ahorros_mujeres.nombre

    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre,COUNT(movimientos.numero) AS conteo_movimientos
    FROM oficinas
    LEFT OUTER JOIN cuentas
        ON  oficinas.codigoOficina = cuentas.codigoOficina
    LEFT OUTER JOIN movimientos 
        ON cuentas.numeroCuenta = movimientos.numeroCuenta
    GROUP BY oficinas.nombre
    ) cantidad_movimientos
    ON  oficinas.nombre = cantidad_movimientos.nombre

UNION ALL

SELECT 'Total' AS oficinasnombre,
        SUM(numero_cuentas_totales) AS numero_cuentas_totales,
        SUM(numero_cuentas_hombres) AS numero_cuentas_hombres,
        SUM(numero_cuentas_mujeres) AS numero_cuentas_mujeres,
        ' 'AS promedio_cuentas_ahorros_hombres,
        ' 'AS promedio_cuentas_ahorros_mujeres,
        SUM(cantidad_de_movimientos) AS cantidad_de_movimientos

FROM (SELECT oficinas.nombre,

    NVL(num_cuentas_totales.conteo, 0) AS numero_cuentas_totales,
    NVL(num_cuentas_hombres.conteo_cuentas_hombres,0) AS numero_cuentas_hombres,
    NVL(num_cuentas_mujeres.conteo_cuentas_mujeres,0) AS numero_cuentas_mujeres,
    NVL(prom_saldo_ahorros_hombres.promedio,0) AS promedio_cuentas_ahorros_hombres,
    NVL(prom_saldo_ahorros_mujeres.promedio,0) AS promedio_cuentas_ahorros_mujeres,
    NVL(cantidad_movimientos.conteo_movimientos,0) AS cantidad_de_movimientos

    FROM oficinas
    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre ,COUNT(cuentas.numerocuenta) AS conteo
    FROM cuentas
    LEFT OUTER JOIN oficinas
        ON oficinas.codigooficina = cuentas.codigooficina
    GROUP BY oficinas.nombre
    ) num_cuentas_totales
    ON oficinas.nombre = num_cuentas_totales.nombre

    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre,COUNT(DISTINCT(cuentas.numeroCuenta)) AS conteo_cuentas_hombres
    FROM oficinas
    LEFT OUTER JOIN cuentas
        ON oficinas.codigoOficina = cuentas.codigoOficina
    LEFT OUTER JOIN titulares 
        ON cuentas.numeroCuenta = titulares.numeroCuenta
    LEFT OUTER JOIN clientes
        ON titulares.codigoCliente = clientes.codigoCliente
    WHERE clientes.genero = 'M'
    GROUP BY oficinas.nombre
    ) num_cuentas_hombres
    ON oficinas.nombre = num_cuentas_hombres.nombre

    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre,COUNT(DISTINCT(cuentas.numeroCuenta)) AS conteo_cuentas_mujeres
    FROM oficinas
    LEFT OUTER JOIN cuentas
        ON oficinas.codigoOficina = cuentas.codigoOficina
    LEFT OUTER JOIN titulares 
        ON cuentas.numeroCuenta = titulares.numeroCuenta
    LEFT OUTER JOIN clientes
        ON titulares.codigoCliente = clientes.codigoCliente
    WHERE clientes.genero = 'F'
    GROUP BY oficinas.nombre
    ) num_cuentas_mujeres
    ON oficinas.nombre = num_cuentas_mujeres.nombre

    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre,AVG(cuentas.Saldo) AS promedio
    FROM oficinas
    LEFT OUTER JOIN cuentas
        ON oficinas.codigoOficina = cuentas.codigoOficina
    LEFT OUTER JOIN titulares 
        ON cuentas.numeroCuenta = titulares.numeroCuenta
    LEFT OUTER JOIN clientes
        ON titulares.codigoCliente = clientes.codigoCliente
    WHERE clientes.genero = 'M'
    AND cuentas.tipo = 'A'
    GROUP BY oficinas.nombre
    ) prom_saldo_ahorros_hombres
    ON oficinas.nombre = prom_saldo_ahorros_hombres.nombre

    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre,AVG(cuentas.Saldo) AS promedio
    FROM oficinas
    LEFT OUTER JOIN cuentas
        ON oficinas.codigoOficina = cuentas.codigoOficina
    LEFT OUTER JOIN titulares 
        ON cuentas.numeroCuenta = titulares.numeroCuenta
    LEFT OUTER JOIN clientes
        ON titulares.codigoCliente = clientes.codigoCliente
    WHERE clientes.genero = 'F'
    AND cuentas.tipo = 'A'
    GROUP BY oficinas.nombre
    ) prom_saldo_ahorros_mujeres
    ON oficinas.nombre = prom_saldo_ahorros_mujeres.nombre

    LEFT OUTER JOIN
    (
    SELECT oficinas.nombre,COUNT(movimientos.numero) AS conteo_movimientos
    FROM oficinas
    LEFT OUTER JOIN cuentas
        ON  oficinas.codigoOficina = cuentas.codigoOficina
    LEFT OUTER JOIN movimientos 
        ON cuentas.numeroCuenta = movimientos.numeroCuenta
    GROUP BY oficinas.nombre
    ) cantidad_movimientos
    ON  oficinas.nombre = cantidad_movimientos.nombre)

;