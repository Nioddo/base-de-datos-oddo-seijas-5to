#1- Crear una función que dado un empleado devuelva "Nivel 3" si está a cargo de más de 20
#empleados,"Nivel 2" si está a cargo de más de 10 pero menos de 20, y "Nivel 1" si está a cargo
#de menos de 10.
delimiter //
create function pepo10 (empleado int) returns text deterministic begin
declare nivel text;
declare cantEmpleados int;
select count(employeeNumber) into cantEmpleados from employees where reportsTo=empleado;
if cantEmpleados>20 then 
set nivel="nivel 3";
else if cantEmpleados>10 and cantEmpleados<20 then
 set nivel="nivel 2";
else 
set nivel="nivel 1";
end if;
end if;
return nivel;
end//
delimiter ;
select pepo10 (1102);

#2- Crear una función que reciba dos fechas (orderDate y shippedDate) y devuelva la cantidad
#de días que pasaron entre ambas.
delimiter //
create function pepo11 (requiredDate date, shippedDate date) returns int deterministic begin
declare dias int;
select datediff(requiredDate, shippedDate) into dias;
return dias;
end//
delimiter ;
select pepo11 ("2023-03-21", "2021-04-15");
#3- Crear una función que modifique el estado de las órdenes. Si pasaron más de 10 días entre la
#orderDate y la shippedDate el estado debe pasar a Cancelled y debe devolver la cantidad de
#órdenes modificadas. Utilizar la función del ejercicio anterior.
delimiter //
create function pepo12() returns int deterministic begin
declare ctd int;
update orders set status ="Cancelled" where pepo11(orderDate, shippedDate)>10;
select count(orderNumber) into ctd from orders where pepo11(orderDate, shippedDate)>10;
return ctd;
end//
delimiter ;
select pepo12();

#4- Crear una función que elimine cierto producto de una orden. Debe devolver la cantidad de
#unidades de ese producto que había en la orden.
delimiter //
create function pepo13(producto text, orden int) returns int deterministic begin
declare ctd int;
select quantityOrdered into ctd from orderdetails where productCode=producto and orderNumber=orden;
delete from orderdetails where productCode=producto and orderNumber=orden;
return ctd;
end//
delimiter ;
select pepo13("S10_1678",10121);

#5- Crear una función que reciba un código de producto (productCode) y devuelva "Sobrestock"
#si la cantidad en stock (quantityInStock) es mayor a 5000,"Stock Adecuado" si está entre 1000
#y 5000, y "Bajo Stock" si es menor a 1000.
#6- Crear una función que reciba un año y devuelva el top 3 productos más vendidos (por
#cantidad de unidades) en ese año, concatenados en un solo string separados por comas
delimiter //
create function pepo15(año int) returns int deterministic begin
declare productosventas int;
select quantityOrdered into ctd from orderdetails where productCode=producto and orderNumber=orden;
return productosventas;
end//
delimiter ;
select pepo15("S10_1678",10121);
