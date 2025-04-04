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
