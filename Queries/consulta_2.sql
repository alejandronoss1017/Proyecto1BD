-- 2. Muestre un listado de la forma. Deben salir todas las oficinas independiente que no tengan datos

-- Mostrar todos los clientes y a la oficina a la que pertenecen
SELECT  clientes.codigocliente CLIENTE, codigooficina OFICINA
FROM    clientes LEFT OUTER JOIN
        oficinas NATURAL JOIN cuentas NATURAL JOIN titulares
    ON titulares.codigocliente = clientes.codigocliente;
    
-- Mostrar número de clientes en la oficina
SELECT  oficinas.codigooficina, COUNT(cltexoficina.cliente)
FROM    oficinas LEFT OUTER JOIN
        (SELECT  clientes.codigocliente CLIENTE, codigooficina OFICINA
        FROM    clientes LEFT OUTER JOIN
        oficinas NATURAL JOIN cuentas NATURAL JOIN titulares
        ON titulares.codigocliente = clientes.codigocliente) CLTEXOFICINA
        ON oficinas.codigooficina = cltexoficina.oficina
GROUP BY oficinas.codigooficina;