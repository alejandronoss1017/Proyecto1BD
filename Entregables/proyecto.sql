-- BORRADO DE ESTRUCTURAS

DROP TABLE movimientos;
DROP TABLE pqrs;
DROP TABLE titulares;
DROP TABLE cuentas;
DROP TABLE oficinas;
DROP TABLE clientes;

-- CREACION --

CREATE TABLE clientes(
    codigoCliente NUMBER (3,0) NOT NULL,
    nombreCliente VARCHAR2 (60) NOT NULL,
    apellidoCliente VARCHAR2 (60) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    fechaPrimeraVinculacion DATE,
    email VARCHAR2(60) NOT NULL, 
    genero CHAR(1) NOT NULL,

	CHECK(REGEXP_LIKE(email, '[a-zA-Z\.\-\_0-9]+@[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+', 'c')), 
    CHECK(genero IN ('M', 'F')),
    PRIMARY KEY(codigoCliente)
);

CREATE TABLE oficinas(
    codigoOficina NUMBER(3,0) NOT NULL,
    nombre VARCHAR2(60) NOT NULL,
    presupuesto NUMBER(20,2) NOT NULL,
    horarioAdicional CHAR(1) NOT NULL,

    CHECK (horarioAdicional IN ('S', 'N')),
    PRIMARY KEY(codigoOficina)
);

CREATE TABLE cuentas(
    numeroCuenta NUMBER(3,0) NOT NULL,
    tipo CHAR(1) NOT NULL,
    codigoOficina NUMBER(3,0) NOT NULL,
    saldo NUMBER(20,0) DEFAULT NULL,

	CHECK(tipo IN ('A', 'C')),
    PRIMARY KEY(numeroCuenta),
    FOREIGN KEY(codigoOficina) REFERENCES oficinas
);

CREATE TABLE titulares(
    codigoCliente NUMBER(3,0) NOT NULL,
    numeroCuenta NUMBER(3,0) NOT NULL,
    porcentajeTitularidad NUMBER(3,0) NOT NULL,

    PRIMARY KEY(codigoCliente, numeroCuenta),
    FOREIGN KEY(codigoCliente) REFERENCES clientes ON DELETE CASCADE,
    FOREIGN KEY(numeroCuenta) REFERENCES cuentas
);

CREATE TABLE pqrs(
    codigoCliente NUMBER(3,0) NOT NULL,
    numero NUMBER(2,0) NOT NULL, 
    tipoQueja CHAR(1) NOT NULL,
	descripcion VARCHAR2(2000) NOT NULL,

    CHECK(tipoQueja IN ('P', 'Q', 'R', 'S')),
    PRIMARY KEY(codigoCliente, numero),
    FOREIGN KEY(codigoCliente) REFERENCES clientes ON DELETE CASCADE
);

CREATE TABLE movimientos(
    numeroCuenta NUMBER(3,0) NOT NULL,
    numero NUMBER(3,0) NOT NULL,
    tipo CHAR(1) NOT NULL,
	naturaleza CHAR(1) NOT NULL, 
	valor NUMBER(10,2) NOT NULL,
    fechaMovimiento TIMESTAMP NOT NULL, 

    CHECK(tipo IN ('D', 'R', 'C', 'I')),
    CHECK(naturaleza IN ('A', 'U')),

    PRIMARY KEY(numeroCuenta,numero),
    FOREIGN KEY(numeroCuenta) REFERENCES cuentas
);

COMMIT;

-- PRUEBAS --

-- INTEGRIDAD INSERCIÓN DE DATOS

-- Clientes que tienen un email en un formato incorrecto
INSERT INTO clientes VALUES(20, 'Carlos', 'Name', TO_DATE('05/03/2002', 'dd/mm/yyyy'), NULL, 'EMAIL NO VALIDO', 'M');
INSERT INTO clientes VALUES(30, 'Andrea', 'García', TO_DATE('07/09/2002', 'dd/mm/yyyy'), NULL, 'andrea.email@novalido', 'F');
INSERT INTO clientes VALUES(40, 'Sofía', 'Bernal', TO_DATE('10/10/2003', 'dd/mm/yyyy'), NULL, 'andrea.email@dominio_incorrecto.com', 'F');

-- Clientes que tienen un campo género no válido
INSERT INTO clientes VALUES(20, 'Carlos', 'Name', TO_DATE('05/03/2002', 'dd/mm/yyyy'), NULL, 'carlos.name@email.com', 'NO VALIDO');
INSERT INTO clientes VALUES(30, 'Andrea', 'García', TO_DATE('07/09/2002', 'dd/mm/yyyy'), NULL, 'garcia_andrea@javeriana.edu.co', 'FEMENINO');
INSERT INTO clientes VALUES(40, 'Sofía', 'Bernal', TO_DATE('10/10/2003', 'dd/mm/yyyy'), NULL, 'sofia_bernal123@minsalud.com', 'Z');

-- Clientes que SÍ SON VÁLIDOS
INSERT INTO clientes VALUES(20, 'Carlos', 'Name', TO_DATE('05/03/2002', 'dd/mm/yyyy'), NULL, 'carlos.name@email.com', 'M');
INSERT INTO clientes VALUES(30, 'Andrea', 'García', TO_DATE('07/09/2002', 'dd/mm/yyyy'), NULL, 'garcia_andrea@javeriana.edu.co', 'F');
INSERT INTO clientes VALUES(40, 'Sofía', 'Bernal', TO_DATE('10/10/2003', 'dd/mm/yyyy'), NULL, 'sofia_bernal123@minsalud.com', 'F');

SELECT * FROM clientes;

-- Oficinas que tienen un horario adicional no valido
INSERT INTO oficinas VALUES(111, 'CC TITAN', '5000000', 'F');
INSERT INTO oficinas VALUES(222, 'CC COLINA', '10000000', 'K');
INSERT INTO oficinas VALUES(333, 'U JAVERIANA', '100000000', 'U');

-- Oficinas que SÍ SON VÁLIDAS
INSERT INTO oficinas VALUES(111, 'CC TITAN', '5000000', 'S');
INSERT INTO oficinas VALUES(222, 'CC COLINA', '10000000', 'S');
INSERT INTO oficinas VALUES(333, 'U JAVERIANA', '100000000', 'N');

SELECT * FROM oficinas;

-- Cuentas que no sean de tipo válido
INSERT INTO cuentas VALUES(111, 'S', 111, 20);
INSERT INTO cuentas VALUES(222, 'D', 222, 10);
INSERT INTO cuentas VALUES(333, 'F', 333, 30);

-- Cuentas VÁLIDAS, No se especifica saldo pues se está verificando el VALOR DEFAULT que es NULL
INSERT INTO cuentas (numerocuenta, tipo, codigooficina) VALUES(111, 'A', 111);
INSERT INTO cuentas (numerocuenta, tipo, codigooficina) VALUES(222, 'A', 222);
INSERT INTO cuentas (numerocuenta, tipo, codigooficina) VALUES(333, 'C', 333);

SELECT * FROM cuentas;

-- INTEGRIDAD ON DELETE CASCADE de CLIENTES

-- Prueba de integridad DELETE CASCADE de clientes
-- Añadir algunos titulares
INSERT INTO titulares VALUES(20, 111, 100);
INSERT INTO titulares VALUES(30, 222, 50);
INSERT INTO titulares VALUES(40, 222, 50);
INSERT INTO titulares VALUES(40, 333, 100);

SELECT * FROM titulares;

-- Añadir algunos PQRS
INSERT INTO pqrs VALUES(20, 1, 'P', 'Descripcion de la peticion');
INSERT INTO pqrs VALUES(30, 2, 'Q', 'Descripcion de la queja');
INSERT INTO pqrs VALUES(30, 3, 'R', 'Descripcion del reclamo');
INSERT INTO pqrs VALUES(40, 4, 'S', 'Descripcion de la sugerencia');

SELECT * FROM pqrs;

-- Los clientes fueron eliminados
DELETE clientes;

SELECT * FROM clientes;

-- Todos los respectivos titulares y pqrs asociados también fueron eliminados
SELECT * FROM titulares;
SELECT * FROM pqrs;

ROLLBACK;

-- INSERCIÓN

-- Datos del enunciado --

-- Clientes
INSERT INTO clientes VALUES (1, 'Klementina', 'Cagua', TO_DATE('07-09-1993', 'dd-mm-yyyy'),TO_DATE('20-11-2005', 'dd-mm-yyyy'), 'klementina0678@gmail.com', 'F');
INSERT INTO clientes VALUES (2, 'Anastasia', 'Robledo', TO_DATE('15-12-1990', 'dd-mm-yyyy'),TO_DATE('08-08-2008', 'dd-mm-yyyy'), 'Anastr1512@gmail.com', 'F');
INSERT INTO clientes VALUES (3, 'Carlos', 'Maldonado', TO_DATE('10-01-1995', 'dd-mm-yyyy'),TO_DATE('31-01-2021', 'dd-mm-yyyy'), 'Maldonad0195@gmail.com', 'M');
INSERT INTO clientes VALUES (4, 'Jacobo', 'Rosas', TO_DATE('22-05-2000', 'dd-mm-yyyy'),TO_DATE('18-08-2007', 'dd-mm-yyyy'), 'Jacros2205@gmail.com', 'M');
INSERT INTO clientes VALUES (5, 'Jennifer', 'Castellanos', TO_DATE('18-03-1987', 'dd-mm-yyyy'),TO_DATE('17-04-2011', 'dd-mm-yyyy'), 'Mushu1803@gmail.com', 'F');
INSERT INTO clientes VALUES (6, 'Esteban', 'Jimenez', TO_DATE('26-08-1999', 'dd-mm-yyyy'),TO_DATE('28-02-2020', 'dd-mm-yyyy'), 'Estebanj2608@gmail.com', 'M');
INSERT INTO clientes VALUES (7, 'Jacobo', 'Giraldo', TO_DATE('14-10-1992', 'dd-mm-yyyy'),TO_DATE('01-06-2001', 'dd-mm-yyyy'), 'Jacobgir1092@gmail.com', 'M');
INSERT INTO clientes VALUES (8, 'Juan', 'Torres', TO_DATE('15-02-2001', 'dd-mm-yyyy'),TO_DATE('12-12-2012', 'dd-mm-yyyy'), 'Torresjuju02@gmail.com', 'M');
INSERT INTO clientes VALUES (9, 'Camilo', 'Lopez', TO_DATE('02-08-1972', 'dd-mm-yyyy'),TO_DATE('13-03-2003', 'dd-mm-yyyy'), 'Camilopez0208@gmail.com', 'M');
INSERT INTO clientes VALUES (10, 'Julia', 'Mendez', TO_DATE('31-10-1990', 'dd-mm-yyyy'),TO_DATE('19-02-2009', 'dd-mm-yyyy'), 'Julesmend3110@gmail.com', 'F');
INSERT INTO clientes VALUES (11, 'Mateo', 'Garcia', TO_DATE('07-09-2001', 'dd-mm-yyyy'), NULL, 'mateoga0901@gmail.com', 'M');
INSERT INTO clientes VALUES (12, 'Andrea', 'Ortega', TO_DATE('14-05-1982', 'dd-mm-yyyy'), NULL, 'andreita1415@gmail.com', 'F');

-- Oficinas
INSERT INTO oficinas VALUES (1, 'Oficina Norte', 27190210.00, 'N');
INSERT INTO oficinas VALUES (2, 'Oficina Sur', 15000240.00, 'N');
INSERT INTO oficinas VALUES (3, 'Oficina Este', 8510348.00, 'S');
INSERT INTO oficinas VALUES (4, 'Oficina Oeste', 3258903.00, 'S');

-- Cuentas
INSERT INTO cuentas VALUES (134, 'A', 4, 0);
INSERT INTO cuentas VALUES (135, 'C', 1, 0);
INSERT INTO cuentas VALUES (136, 'C', 2, 0);
INSERT INTO cuentas VALUES (137, 'A', 2, 0);
INSERT INTO cuentas VALUES (138, 'C', 3, 0);

-- Datos de prueba --

-- Movimientos
INSERT INTO movimientos VALUES(134, 1, 'D', 'U', 150000, TO_TIMESTAMP('10-03-2022 12:12:21', 'dd-mm-yyyy HH24:MI:SS'));
INSERT INTO movimientos VALUES(134, 2, 'R', 'A', 50000, TO_TIMESTAMP('09-03-2022 12:12:21', 'dd-mm-yyyy HH24:MI:SS'));
INSERT INTO movimientos VALUES(134, 3, 'C', 'U', 25000, TO_TIMESTAMP('20-03-2022 12:12:21', 'dd-mm-yyyy HH24:MI:SS'));
INSERT INTO movimientos VALUES(134, 4, 'I', 'A', 5000, TO_TIMESTAMP('10-03-2022 12:12:21', 'dd-mm-yyyy HH24:MI:SS'));
INSERT INTO movimientos VALUES(135, 1, 'D', 'U', 5000, TO_TIMESTAMP('10-03-2022 12:12: 21', 'dd-mm-yyyy HH24:MI:SS'));
INSERT INTO movimientos VALUES(135, 2, 'I', 'A', 1000, TO_TIMESTAMP('10-03-2022 12:12:21', 'dd-mm-yyyy HH24:MI:SS'));
INSERT INTO movimientos VALUES(136, 1, 'D', 'A', 500, TO_TIMESTAMP('10-04-2022 12:12:21', 'dd-mm-yyyy HH24:MI:SS'));

-- Titulares
INSERT INTO titulares VALUES(1, 134, 80);
INSERT INTO titulares VALUES(2, 134, 20);
INSERT INTO titulares VALUES(3, 135, 100);
INSERT INTO titulares VALUES(4, 136, 10);
INSERT INTO titulares VALUES(5, 136, 10);
INSERT INTO titulares VALUES(6, 136, 10);
INSERT INTO titulares VALUES(7, 136, 10);
INSERT INTO titulares VALUES(8, 136, 10);
INSERT INTO titulares VALUES(9, 136, 40);
INSERT INTO titulares VALUES(10, 136, 5);
INSERT INTO titulares VALUES(11, 136, 5);
INSERT INTO titulares VALUES(1, 137, 80);
INSERT INTO titulares VALUES(2, 137, 20);
INSERT INTO titulares VALUES(2, 138, 100);

-- Confirmar los cambios
COMMIT;

-- CONSULTAS

-- CONSULTA 1
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

-- CONSULTA 2
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

-- CONSULTA 3
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

-- CONSULTA 4

-- CONSULTA 5
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