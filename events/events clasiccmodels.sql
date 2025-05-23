#1
delimiter //
create event actEstado on schedule every 1 day starts now() do begin
update orders set status="Delayed" where status="in Process" and requiredDate < current_date();
end //
delimiter ;
#2
delimiter //
create event deletePagos on schedule every 1 month starts now() do begin 
delete from payments where year(paymentDate)< year(current_date());
end //
delimiter ;
#3
