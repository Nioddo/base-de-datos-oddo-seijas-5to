#1
delimiter //
create trigger actualizar_cantidad after insert on pedido_producto for each row
begin

update ingresostock_producto set ingresostock_producto.cantidad=ingresostock_producto.cantidad-new.cantidad;

end//
insert into pedido_producto values(1, 5, 30.00, 1, 2);
#2 
create trigger actualizar_cantidad before delete on ingresostock for each row
begin
delete * from ingresostock_producto;
end//
delete from ingresostock;
#3
