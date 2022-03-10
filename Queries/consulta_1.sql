-- 1. El saldo de cada cuenta es calculado debe ser calculado así:
--  Sume los débitos y rendimientos financieros y reste los créditos y los impuestos.
SELECT  ctas.numerocuenta CUENTA,
        CASE ctas.tipo
            WHEN 'A' THEN 'Ahorros'
            WHEN 'C' THEN 'Corriente'
        END AS TIPO,
        dr.total DEBITOS,
        ci.total CREDITOS,
        (dr.total - ci.total) SALDO,
        primermov.fecha PRIMERMOVIMIENTO,
        ultimomov.fecha ULTIMOMOVIMIENTO,
        ntitulares.total CANTIDADTITULARES,
        office.nombre OFICINA
        
FROM    cuentas CTAS,
    -- Sumar todas las cuentas Crédito + Impuestos
    (SELECT  cta.numerocuenta CUENTA, NVL(SUM(mov.valor), 0) TOTAL
    FROM    cuentas CTA LEFT OUTER JOIN movimientos MOV
        ON mov.numerocuenta = cta.numerocuenta
        AND MOV.tipo IN ('C', 'I')
    GROUP BY cta.numerocuenta ) CI ,
    -- Sumar todas las cuentas Débito + Recaudos
    (SELECT  cta.numerocuenta CUENTA, NVL(SUM(mov.valor), 0) TOTAL
    FROM    cuentas CTA LEFT OUTER JOIN movimientos MOV
        ON mov.numerocuenta = cta.numerocuenta
        AND MOV.tipo IN ('D', 'R')
    GROUP BY cta.numerocuenta ) DR,
    -- Primer movimiento
    (SELECT  cta.numerocuenta CUENTA, MIN(mov.fechamovimiento) FECHA
    FROM    cuentas CTA LEFT OUTER JOIN movimientos MOV
        ON mov.numerocuenta = cta.numerocuenta
    GROUP BY cta.numerocuenta) PRIMERMOV,
    -- Último movimiento
    (SELECT  cta.numerocuenta CUENTA, MAX(mov.fechamovimiento) FECHA
    FROM    cuentas CTA LEFT OUTER JOIN movimientos MOV
        ON mov.numerocuenta = cta.numerocuenta
    GROUP BY cta.numerocuenta) ULTIMOMOV,
    -- Cantidad de titulares
    (SELECT  cta.numerocuenta CUENTA, COUNT(tit.codigocliente) TOTAL
    FROM    cuentas CTA LEFT OUTER JOIN titulares TIT
        ON cta.numerocuenta = tit.numerocuenta
    GROUP BY cta.numerocuenta) NTITULARES,
    -- Oficina de la cuenta
    oficinas OFFICE
    
    -- Unir según número de cuenta
WHERE   ctas.numerocuenta = ci.cuenta
        AND ci.cuenta = dr.cuenta
        AND ctas.numerocuenta = primermov.cuenta
        AND ctas.numerocuenta = ultimomov.cuenta
        AND ctas.numerocuenta = ntitulares.cuenta
        AND ctas.codigooficina = office.codigooficina
        
    -- Ordenar según número de cuenta
ORDER BY ctas.numerocuenta;
