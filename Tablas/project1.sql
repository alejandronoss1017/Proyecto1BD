-- Creacion de Tablas --

DROP TABLE movimientos;
DROP TABLE pqrs;
DROP TABLE titulares;
DROP TABLE cuentas;
DROP TABLE oficinas;
DROP TABLE clientes;


CREATE TABLE clientes(
    codigoCliente NUMBER (3,0) NOT NULL,
    nombreCliente VARCHAR2 (60) NOT NULL,
    apellidoCliente VARCHAR2 (60) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    fechaPrimeraVinculacion DATE,
    email VARCHAR2(60) NOT NULL, 
    --CHECK( email = REGEXP_LIKE(email,'^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$','c')), 
    genero CHAR(1) NOT NULL,
    CHECK(genero = 'F'||'M'),
    PRIMARY KEY(codigoCliente)
);

CREATE TABLE oficinas(
    codigoOficina NUMBER(30) NOT NULL,
    nombre VARCHAR2(60) NOT NULL,
    presupuesto NUMBER(20,2) NOT NULL,
    horarioAdicional CHAR(1) NOT NULL,
    CHECK (horarioAdicional = 'S' || 'N'),
    PRIMARY KEY(codigoOficina)
);

CREATE TABLE cuentas(
    numeroCuenta NUMBER(3,0) NOT NULL,
    tipo CHAR(1) NOT NULL
    CHECK(tipo = 'A' || 'C'),
    codigoOficina NUMBER(3,0) NOT NULL,
    saldo NUMBER(20,0) DEFAULT NULL,
    PRIMARY KEY(numeroCuenta),
    FOREIGN KEY (codigoOficina) REFERENCES oficinas
);

CREATE TABLE titulares(
    codigoCliente NUMBER(3,0) NOT NULL,
    numeroCuenta NUMBER(3,0) NOT NULL,
    porcentajeTitularidad NUMBER(3,0) NOT NULL,
    PRIMARY KEY(codigoCliente,numeroCuenta),
    FOREIGN KEY(codigoCliente) REFERENCES clientes,
    FOREIGN KEY(numeroCuenta) REFERENCES cuentas
);

CREATE TABLE pqrs(
    codigoCliente NUMBER(3,0) NOT NULL,
    numero NUMBER(2,0) NOT NULL, 
    tipoQueja CHAR(1) NOT NULL,
    CHECK(tipoQueja = 'P' || 'Q' || 'R' || 'S'),
    descripcion VARCHAR2(2000) NOT NULL,
    PRIMARY KEY(codigoCliente, numero),
    FOREIGN KEY(codigoCliente) REFERENCES clientes
);

CREATE TABLE movimientos(
    numeroCuenta NUMBER(3,0) NOT NULL,
    numero NUMBER(3,0) NOT NULL,
    tipo CHAR(1) NOT NULL,
    CHECK(tipo ='D' || 'C' || 'I' || 'R'),
    naturaleza CHAR(1) NOT NULL, 
    CHECK( naturaleza ='A' || 'U'),
    valor NUMBER(10,2) NOT NULL,
    fechaMovimiento DATE NOT NULL, --TODO:TO_DATE('1998-DEC-25 17:30','YYYY-MON-DD HH24:MI','NLS_DATE_LANGUAGE=AMERICAN')
    PRIMARY KEY(numeroCuenta,numero),
    FOREIGN KEY(numeroCuenta) REFERENCES cuentas
);