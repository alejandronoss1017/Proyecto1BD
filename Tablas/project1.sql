-- Creacion de Tablas --

CREATE TABLE clientes(
    codigoCLiente NUMBER (3,0) NOT NULL,
    nombreCLiente VARCHAR2 (60) NOT NULL,
    apellidoCliente VARCHAR2 (60) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    fechaPrimeraVinculacion DATE,
    email VARCHAR2(60) NOT NULL,  --TODO: REGEXP_LIKE Para Emails validos
    genero CHAR(1) CHECK('F' OR 'M') NOT NULL,
    PRIMARY KEY(codigoCLiente)
);

CREATE TABLE oficinas(
    codigoOficina NUMBER(30) NOT NULL,
    nombre VARCHAR2(60) NOT NULL,
    presupuesto NUMBER(20,2) NOT NULL,
    horarioAdicional CHAR(1) CHECK ('S' OR 'N') NOT NULL,
    PRIMARY KEY(codigoOficina)
);

CREATE TABLE cuentas(
    numeroCuenta NUMBER(3,0) NOT NULL,
    tipo CHAR(1) CHECK('A' OR 'C') NOT NULL,
    codigoOficina NUMBER(3,0) NOT NULL,
    saldo NUMBER(20,0) DEFAULT NULL,
    PRIMARY KEY(numeroCuenta),
    FOREIGN KEY (codigoOficina) REFERENCES oficinas
);

CREATE TABLE titulares(
    codigoCLiente NUMBER(3,0) NOT NULL,
    numeroCuenta NUMBER(3,0) NOT NULL,
    porcentajeTitularidad NUMBER(3,0) NOT NULL,
    PRIMARY KEY(codigoCLiente,numeroCuenta),
    FOREIGN KEY(codigoCLiente) REFERENCES clientes,
    FOREIGN KEY(numeroCuenta) REFERENCES cuentas
);

CREATE TABLE pqrs(
    codigoCLiente NUMBER(3,0) NOT NULL,
    numero NUMBER(2,0) NOT NULL, 
    tipoQueja CHAR(1) CHECK('P' OR 'Q' OR 'R' OR 'S') NOT NULL,
    descripcion VARCHAR2(2000) NOT NULL,
    PRIMARY KEY(codigoCLiente, numero),
    FOREIGN KEY(codigoCLiente) REFERENCES clientes
);

CREATE TABLE movimientos(
    numeroCuenta NUMBER(3,0) NOT NULL,
    numero NUMBER(3,0) NOT NULL,
    tipo CHAR(1) CHECK('D' OR 'C' OR 'I' OR 'R') NOT NULL,
    naturaleza CHAR(1) CHECK('A' OR 'U') NOT NULL,
    valor NUMBER(10,2) NOT NULL,
    fechaMovimiento DATETIME NOT NULL,
    PRIMARY KEY(numeroCuenta,numero),
    FOREIGN KEY(numeroCuenta) REFERENCES cuentas
);