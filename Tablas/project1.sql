-- Creacion de Tablas --

CREATE TABLE clientes(
    codigoCLiente NUMBER (3,0) NOT NULL
    nombreCLiente VARCHAR2 (60) NOT NULL
    apellidoCliente VARCHAR2 (60) NOT NULL
    fechaNacimiento DATE NOT NULL
    fechaPrimeraVinculacion DATE
    email VARCHAR2(60) NOT NULL  --TODO: REGEXP_LIKE Para Emails validos
    genero CHAR(1) NOT NULL --TODO: Unicas Opciones F y M
);

CREATE TABLE oficinas(
    codigoOficina NUMBER(30) NOT NULL
    nombre VARCHAR2(60) NOT NULL
    presupuesto NUMBER(20,2) NOT NULL
    horarioAdicional CHAR(1) NOT NULL --TODO: Valores permitidos S(si) y N(no)
);

CREATE TABLE cuentas(
    numeroCuenta NUMBER(3,0) NOT NULL
    tipo CHAR(1) NOT NULL --TODO: Valores permitidos A(Ahorros) o C(Corriente)
    codigoOficina NUMBER(3,0) NOT NULL
    saldo NUMBER(20,0) --TODO: Saldo debe crearse con NULL
);

CREATE TABLE titulares(
    codigoCLiente NUMBER(3,0) NOT NULL
    numeroCuenta NUMBER(3,0) NOT NULL
    porcentajeTitularidad NUMBER(3,0) NOT NULL
);

CREATE TABLE pqrs(
    codigoCLiente NUMBER(3,0) NOT NULL
    numero NUMBER(2,0) NOT NULL 
    tipoQueja CHAR(1) NOT NULL --TODO: Valores permitidos son P,Q,R,S
    descripcion VARCHAR2(2000) NOT NULL
);

CREATE TABLE movimientos(
    numeroCuenta NUMBER(3,0) NOT NULL
    numero NUMBER(3,0) NOT NULL
    tipo CHAR(1) NOT NULL --TODO: Posibles valores D(debitos),C(creditos),I(impuestos),R(rendimientos)
    naturaleza CHAR(1) NOT NULL --TODO: Valores permitidos A (automatico) y U (usuario)
    valor NUMBER(10,2) NOT NULL
    fechaMovimiento DATE NOT NULL
);