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
delimiter //
create procedure pepito3 () begin
select count(*) from orders group by status;
end //
delimiter ;
call pepito3();
drop procedure pepito3;

#5 Realice un SP que liste para cada empleado con gente subordinada, cuántos empleados
#tiene a cargo.
delimiter //
create procedure pepito4 () begin
select firstName, lastName, count(salesRepEmployeeNumber) from employees join customers on salesRepEmployeeNumber=employeeNumber group by employeeNumber;
end //
delimiter ;
call pepito4();

#6. Realice un SP que liste el número de orden y su precio total.
delimiter //
create procedure pepito5 () begin
select orderNumber, sum(quantityOrdered*priceEach) from orderdetails ;
end //
delimiter ;
call pepito5();
drop procedure pepito5;

#7. Crear un SP que liste el número de cliente y nombre, junto con las órdenes asociadas a ese
#cliente y el total por orden.
delimiter //
create procedure pepito6 () begin
select customers.customerNumber, customerName, orders.orderNumber, sum(quantityOrdered*priceEach)   from customers join orders on customers.customerNumber=orders.customerNumber join orderdetails on orders.orderNumber= orderdetails.orderNumber group by orderNumber;
end //
delimiter ;
call pepito6();
drop procedure pepito6;

#8. Realizar un SP que modifique el campo comments de la tabla orders. El procedimiento
#recibe un orderNumber y el comentario. El procedimiento devuelve 1 si se encontró la
#orden y se modificó, y 0 en caso contrario.

delimiter //
create procedure pepito7 () begin
select customers.customerNumber, customerName, orders.orderNumber, sum(quantityOrdered*priceEach)   from customers join orders on customers.customerNumber=orders.customerNumber join orderdetails on orders.orderNumber= orderdetails.orderNumber group by orderNumber;
end //
delimiter ;
call pepito6();
drop procedure pepito7;


#9. Crear un SP que utilice un cursor para recorrer la tabla de offices y que genere una lista con
#las ciudades en las cuales hay oficinas. La lista tendrá que devolverse en un parámetro de
#salida VARCHAR(4000) que contenga todas las ciudades separadas por coma.
#getCiudadesOffices()
	delimiter //
    create procedure pepito8 (out citys varchar(4000)) begin
    declare hayFilas int default 1;
    declare aux text;
    declare ciudades cursor for select city from offices;
	declare continue handler for not found set hayFilas = 0;
    open ciudades;
    bucle: loop
    fetch ciudades into aux;
    if hayFilas =0 then
    leave bucle;
    end if;
    set citys=concat_ws(", ", aux, citys);
    end loop bucle;
    close ciudades;
	end //
	delimiter ;
call pepito8(@lista);
select @lista;
#Agregar una tabla llamada CancelledOrders con el mismo diseño que la tabla de Orders.
#Crear un SP que recorra la tabla de orders y que cuente la cantidad de órdenes en estado
#cancelled. El procedimiento debe insertar una fila en la tabla CancelledOrders por cada
#orden cancelada y tiene que devolver la cantidad de órdenes canceladas.
#insertCancelledOrders()
create table cancelled_orders(
	orderNumber int primary key,
    orderDate date,
    shippedDate date,
    customerNumber int,
    foreign key(customerNumber) references customers(customerNumber));	
    select* from orders;
delimiter //
create procedure creation(out canti int)
	begin 
	declare hayFilas boolean default 1;
    declare variable1, variable4 int;
    declare variable2, variable3 date;
    declare ordenesCursor cursor for select orderNumber, orderDate, shippedDate, customerNumber 
    from orders where status="cancelled";
    declare continue handler for not found set hayFilas=0;
    open ordenesCursor;
    bucle:loop
		fetch ordenesCursor into variable1, variable2, variable3, variable4;
        if hayFilas=0 then
			leave bucle;
        end if;
        insert into cancelled_orders values(variable1, variable2, variable3, variable4);
    end loop bucle;
    select count(*) into canti from cancelled_orders;
    close ordenesCursor;
end//
delimiter ;    
call creation(@canti);
select @canti;
select * from cancelled_orders;


#11
delimiter //
create procedure alterCommentOrder(in customerNumberP int)
begin
	declare Aux int default 0;
	declare Filas boolean default 1;
	declare comentObt varchar(500) default "";
    declare numObt int default 0;
    declare orderCursor cursor for select orders.comments, orders.orderNumber from orders
    where orders.customerNumber = customerNumberP;
	declare continue handler for not found set hayFilas = 0;
    open orderCursor;
    ordersLoop:loop
		fetch orderCursor into comentarioObtenido, numeroObtenido;
		if hayFilas = 0 then
			leave ordersLoop;
		end if;
        if comentarioObtenido is null then
            set varAux = (select sum(priceEach*quantityOrdered) from orderdetails join orders on 
            orderdetails.orderNumber= orders.orderNumber where orderdetails.orderNumber=numeroObtenido);
			update orders set comments = concat("el total de la orden es:"," ",varAux) where orders.orderNumber=numeroObtenido; 
        end if;
	end loop ordersLoop;
    close orderCursor;
end//
delimiter ;


#12
delimiter //
create procedure ejer12 (out listaphone text)
begin
declare Aux int default 0;
	declare numObt int default 0;
	declare numero text;
    declare fecha date;
	declare custm int;
    declare orderCursor cursor for select customers.phone, max(orderDate), customers.customerNumber from customers join orders on orders.customerNumber=customers.customerNumber where status = "Cancelled" group by customers.customerNumber;
	declare continue handler for not found set numObt = 0;
    
    	set listaphone="";
        
    open orderCursor;
    ordersLoop:loop
		fetch orderCursor into numero, fecha, custm;
		if numObt = 0 then
			leave ordersLoop;
		end if;
        if not exists(select * from orders where orderDate > fecha and customerNumber=custm) then 
        set listaphone = concat_ws(" - ", numero, listaphone);
        end if;
        end loop ordersLoop;
        close orderCursor;
        end //
        delimiter ;
call ejer12(@aux);
select @aux;
drop procedure ejer13;


alter table  employees add column comision int;
#13
delimiter //
create procedure ejer13 (out listaphone text) 
begin
	declare salto int default 0;
	declare empleado int;
	declare plata float;
    declare ventas cursor for select amount, salesRepEmployeeNumber from payments join customers on payments.customerNumber=customers.customerNumber;
	declare continue handler for not found set salto = 0;
    
        open ventas;
    ventas:loop
		fetch ventas into plata, empleado;
        
			if salto = 0 then
			leave ventas;
		end if;
        
	if plata > 100000 then
    update employees set comision=5 where employeeNumber=empleado;
    else if plata >50000 and plata<100000 then
	update employees set comision=3 where employeeNumber=empleado;
    end if;
    end if;

end loop ventas;
        close ventas;
	end //
        delimiter ;
	call ejer13(@aux);
select @aux;
#14