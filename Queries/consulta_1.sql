-- 1. El saldo de cada cuenta es calculado debe ser calculado así:
--  Sume los débitos y rendimientos financieros y reste los créditos y los impuestos.

SELECT  a.cuenta,
        NVL(b.tipo, ' ') TIPO,
        a.debitos,
        a.creditos,
        a.saldo,
        b.primermovimiento,
        b.ultimomovimiento,
        NVL(CAST(b.cantidadtitulares AS VARCHAR2(20)), ' ') CANTIDAD_TITULAREs,
        NVL(b.oficina, ' ') OFICINA
FROM (
SELECT  NVL(CAST(ctas.numerocuenta AS VARCHAR2(60)), 'TOTAL') CUENTA,
        SUM(dr.total) DEBITOS,
        SUM(ci.total) CREDITOS,
        SUM((dr.total - ci.total)) SALDO
        
FROM    cuentas CTAS,
    -- Sumar todas las cuentas Crédito + Impuestos
    (SELECT  cta.numerocuenta CUENTA, NVL(SUM(mov.valor), 0) TOTAL
    FROM    cuentas CTA LEFT OUTER JOIN movimientos MOV
        ON mov.numerocuenta = cta.numerocuenta
        AND MOV.tipo IN ('C', 'I')
    GROUP BY cta.numerocuenta) CI ,
    -- Sumar todas las cuentas Débito + Recaudos
    (SELECT  cta.numerocuenta CUENTA, NVL(SUM(mov.valor), 0) TOTAL
    FROM    cuentas CTA LEFT OUTER JOIN movimientos MOV
        ON mov.numerocuenta = cta.numerocuenta
        AND MOV.tipo IN ('D', 'R')
    GROUP BY cta.numerocuenta) DR
    -- Unir según número de cuenta
WHERE   ctas.numerocuenta = ci.cuenta
        AND ci.cuenta = dr.cuenta
    -- Ordenar según número de cuenta
GROUP BY rollup(ctas.numerocuenta)
) A LEFT OUTER JOIN (
SELECT  CAST(ctas.numerocuenta AS VARCHAR2(60)) CUENTA,
        CASE ctas.tipo
            WHEN 'A' THEN 'Ahorros'
            WHEN 'C' THEN 'Corriente'
        END AS TIPO,
        primermov.fecha PRIMERMOVIMIENTO,
        ultimomov.fecha ULTIMOMOVIMIENTO,
        ntitulares.total CANTIDADTITULARES,
        office.nombre OFICINA
        
FROM    cuentas CTAS,
    -- Primer movimiento
    (SELECT  cta.numerocuenta CUENTA, TO_CHAR(MIN(mov.fechamovimiento), 'DD/MM/YYYY') FECHA
    FROM    cuentas CTA LEFT OUTER JOIN movimientos MOV
        ON mov.numerocuenta = cta.numerocuenta
    GROUP BY cta.numerocuenta) PRIMERMOV,
    -- Último movimiento
    (SELECT  cta.numerocuenta CUENTA, TO_CHAR(MAX(mov.fechamovimiento), 'DD/MM/YYYY') FECHA
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
WHERE   ctas.numerocuenta = primermov.cuenta
        AND ctas.numerocuenta = ultimomov.cuenta
        AND ctas.numerocuenta = ntitulares.cuenta
        AND ctas.codigooficina = office.codigooficina
) B

ON A.cuenta = b.cuenta
ORDER BY A.cuenta DESC;
