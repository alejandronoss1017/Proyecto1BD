-- Drop tables --

DROP TABLE movimientos;
DROP TABLE pqrs;
DROP TABLE titulares;
DROP TABLE cuentas;
DROP TABLE oficinas;
DROP TABLE clientes;

-- Creacion de las tablas --

CREATE TABLE clientes(
    codigoCliente NUMBER (3,0) NOT NULL,
    nombreCliente VARCHAR2 (60) NOT NULL,
    apellidoCliente VARCHAR2 (60) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    fechaPrimeraVinculacion DATE,
    email VARCHAR2(60) NOT NULL, 
    genero CHAR(1) NOT NULL,

	CHECK(REGEXP_LIKE(email, '[a-zA-Z\.\-\_0-9]+@(.[a-zA-Z0-9][a-zA-Z\_0-9]+)', 'c')), 
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
    FOREIGN KEY(codigoCliente) REFERENCES clientes,
    FOREIGN KEY(numeroCuenta) REFERENCES cuentas
);

CREATE TABLE pqrs(
    codigoCliente NUMBER(3,0) NOT NULL,
    numero NUMBER(2,0) NOT NULL, 
    tipoQueja CHAR(1) NOT NULL,
	descripcion VARCHAR2(2000) NOT NULL,

    CHECK(tipoQueja IN ('P', 'Q', 'R', 'S')),
    PRIMARY KEY(codigoCliente, numero),
    FOREIGN KEY(codigoCliente) REFERENCES clientes
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

-- Inserción de los datos --

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