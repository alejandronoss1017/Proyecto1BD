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