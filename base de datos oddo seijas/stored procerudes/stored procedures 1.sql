#1. Crear un SP que liste todos los productos que tengan un precio de compra mayor al precio
#promedio y que devuelva la cantidad de productos que cumplan con esa condición.
delimiter //
create procedure pepito (out aux int) begin
	declare preciopromedio float;
    select avg(buyPrice) into preciopromedio from products;
    select * from products where buyPrice>precioPromedio;
    select count(*) into aux from products where buyPrice>precioPromedio;
end //
delimiter ;
call pepito(@pepo);
select @pepo;
#2. Crear un SP que reciba un orderNumber y la borre. Previamente debe eliminar todos los
#ítems de la tabla orderDetails asociados a él. Tiene que devolver 0 si no encontró filas para
#ese orderNumber, o la cantidad ítems borrados si encontró el orderNumber.
delimiter //
create procedure pepito1 (in orderN int, out aux int) begin
select count(orderNumber) into aux from orderdetails where orderN=orderNumber;
delete from orderdetails where orderN=orderNumber;
end //
delimiter ;
call pepito1(10111100, @aux);
select @aux;
#3. Crear un SP que borre una línea de productos de la tabla Productlines. Tenga en cuenta que
#la línea de productos no podrá ser borrada si tiene productos asociados. El procedure debe
#devolver un mensaje que contenga una de las siguientes leyendas:
#“La línea de productos fue borrada”
#“La línea de productos no pudo borrarse porque contiene productos asociados”.
#Utilizar la función del punto 4.
delimiter //
create procedure pepito2 ( out pip text, in lol text) begin
declare cantidad int;
select pepo4(lol) into cantidad;
set pip="no se borro";
if cantidad=0 then
delete from productLines where productLine=lol;
set pip="se borro la linea";
end if;
end //
delimiter ;
call pepito2(@pip, "Motorcycles");
select @pip;
drop procedure pepito2;

#4. Realizar un SP que liste la cantidad de órdenes que hay por estado