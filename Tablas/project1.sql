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
    fechaMovimiento DATE NOT NULL, 

    CHECK(tipo IN ('D', 'R', 'C', 'I')),
    CHECK(naturaleza IN ('A', 'U')),

    PRIMARY KEY(numeroCuenta,numero),
    FOREIGN KEY(numeroCuenta) REFERENCES cuentas
);