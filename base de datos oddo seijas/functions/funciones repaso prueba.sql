#1- Crear una Stored Function que reciba un id de cliente e indique si es o no frecuente. Es
#frecuente si realizó al menos un 5% de las compras totales, en los últimos 6 meses.

delimiter //
create function ejer1 (cliente int) returns text deterministic begin
declare cantu int;
declare cantt int;
declare resp text;
select count(Cliente_codCliente) into cantu from pedido where Cliente_codCliente=cliente and fecha>"2019-11-4";
select count(*) into cantt from pedido;

if (cantu*100)/cantt >5 then 
set resp ="es fecuente";
else 
set resp="no es fecuente";
end if;
return resp;
end//
delimiter ;
select ejer1 (1);
drop function ejer1;

#4- Crear una Stored Function que reciba un id de cliente y devuelva la cantidad de pedidos
#pendientes de pago de ese cliente.

delimiter //
create function ejer4 (cliente int) returns int deterministic begin
declare resp int;
select count(idEstado)  into resp from estado join pedido on idEstado=Estado_idEstado where nombre="Por enviar" and Cliente_codCliente=cliente;
return resp;
end//
delimiter ;
select ejer4(1);
#2- Crear una Stored Function que reciba un código de producto y devuelva el precio
#promedio al que lo proveen todos los proveedores.
#delimiter //
delimiter //
create function ejer2 (producto int) returns int deterministic begin
declare resp int;
select avg(precio) into resp from producto_proveedor where producto=Producto_codProducto;
return resp;
end//
delimiter ;
select ejer2(1);

delimiter //
create function ejer12 (id int) returns int deterministic begin
declare cant int;
select sum(cantEntradas) into cant from compra where id=cliente_idcliente;
end//
delimiter ;


delimiter //
create function ejer12 (id int) returns int deterministic begin
declare cant int;
select sum(cantEntradas) into cant from compra where id=cliente_idcliente;
end//
delimiter ;

create c