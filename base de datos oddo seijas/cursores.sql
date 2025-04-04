#10
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
#11. Realizar un SP que reciba el customerNumber y para todas las órdenes de ese
#customerNumber, si el campo comments esta vacío que lo complete con el siguiente
#comentario: “El total de la orden es … “ Y el total de la orden tendrá que calcularlo el
#procedimiento sumando todos los productos incluidos en la orden de la tabla OrderDetails.
#alterCommentOrder()
#la procedure 6 devuelve el total!!!!
delimiter //
create procedure alterCommentOrder(in customerNumberP int)
begin
	declare varAux int default 0;
	declare hayFilas boolean default 1;
	declare comentarioObtenido varchar(500) default "";
    declare numeroObtenido int default 0;
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
