#1) Crear una función que devuelva la cantidad de órdenes con determinado estado en el rango de dos fechas (orderDate). La función recibe por parámetro las fechas desde, hasta y el estado.
delimiter //
create function pepo1 (fecha1 date, fecha2 date, estado varchar(15))returns int deterministic begin
	declare cantOrdenes int default 0;
	select count(*) into cantOrdenes from orders where status = estado and orderDate between fecha1 and fecha2;
    return cantOrdenes;
end//
delimiter ;
select pepo1 ("2003-09-27", "2003-11-14", "shipped");


#2) Crear una función que reciba por parámetro dos fechas de envío (shippedDate) desde, hasta y devuelve la cantidad de órdenes entregadas.
delimiter //
create function pepo2 (fecha1 date, fecha2 date) returns int deterministic begin
declare cantOrdenes int default 0;
select count(*) into cantOrdenes from orders where status = "shipped" and orderDate between fecha1 and fecha2;
return cantOrdenes;
end//
delimiter ;
select pepo2 ("2003-11-9","2004-5-24");
#3) Crear una función que reciba un número de cliente y devuelva la ciudad a la que corresponde el empleado que lo atiende.
delimiter //
create function pepo3 (clientnumer int) returns text deterministic begin
declare ciudadEmpleado text;
select offices.city into ciudadEmpleado from offices join employees on offices.officeCode = employees.officeCode join customers on employeeNumber=salesRepEmployeeNumber where customerNumber=clientnumer;
return ciudadEmpleado;
end//
delimiter ;
select pepo3 ("103");

#4) Crear una función que reciba una productline y devuelva la cantidad de productos existentes en esa línea de producto.
delimiter //
create function pepo4 (categora int) returns text deterministic begin
declare category text;
select count(*) into category from products where productLine = categora;
return category;
end//
delimiter ;
select pepo4 ("5005");
#5) Crear una función que reciba un officeCode y devuelva la cantidad de clientes que tiene la oficina.
delimiter //
create function pepo5 (codigoOficina int) returns text deterministic begin
declare cant text;
select count(*) into cant from customers join employees on employeeNumber = salesRepEmployeeNumber where officeCode = codigoOficina;
return cant;
end//
delimiter ;
select pepo5 ("5005");
#6) Crear una función que reciba un officeCode y devuelva la cantidad de órdenes que se hicieron en esa oficina.
delimiter //
create function pepo6 (codigoOficina int) returns int deterministic begin
declare cant text;
select count(*) into cant from orders join customers on customers.customerNumber = orders.customerNumber join employees on salesRepEmployeeNumber = employees.employeeNumber join offices on offices.officeCode = employees.officeCode where offices.officeCode = codigoOficina;
return cant;
end//
delimiter ;
select pepo6 ("5005");
drop function pepo6;
#7) Crear una función que reciba un nro de orden y un nro de producto, y devuelva el beneficio obtenido con ese producto. El beneficio debe calcularse como priceEach – buyPrice.
delimiter //
create function pepo7 (nroO int, nroP text) returns float deterministic begin
declare beneficio float;
select (priceEach-buyPrice) into beneficio from products join orderdetails on products.productCode = orderdetails.productCode join orders on orders.orderNumber = orderdetails.orderNumber where orders.orderNumber=nroO and  products.productCode=nroP;
return beneficio;
end//
delimiter ;
select pepo7 (10100,"S18_1749");
drop function pepo7;
#8) Crear una función que reciba un orderNumber y si el mismo está en estado cancelado devuelva -1, sino 0.
delimiter //
create function pepo8 (orderN int) returns int deterministic begin
declare estado text;
select status into estado from orders where orderNumber=orderN;
if(estado = "Cancelled")
then return -1;
else
return 0;
end if;
end//
delimiter ;
select pepo8 (10167);
#9) Crear una función que devuelva la fecha de la primera orden hecha por ese cliente. Recibe el nro de cliente por parámetro.
delimiter //
create function pepo9 (clientN int) returns date deterministic begin
declare fecha date;
select orderDate into fecha from orders where customerNumber=clientN order by orderDate asc limit 1;
return fecha;
end//
delimiter ;
select pepo9 (321);

#10) La columna MSRP en la tabla de productos significa manufacturer 's suggested retail price (precio de venta sugerido por el fabricante). Crear una SF que reciba un código de producto y devuelva el porcentaje de veces que el producto se vendió por debajo de dicho precio.
#11) Crear una función que reciba un código de producto y devuelva la última fecha en la que fue pedido el mismo.
#12) Crear una SF que reciba dos fechas desde, hasta y un código de producto. Si el producto fue ordenado en alguna orden entre esas fechas que devuelva el mayor precio. Si el producto no fue ordenado en esas fechas que devuelva 0.
#13) Crear una SF que reciba el número de empleado y devuelva la cantidad de clientes que atiende.
#14) Crear una SF que reciba un número de empleado y devuelva el apellido del empleado al que reporta.