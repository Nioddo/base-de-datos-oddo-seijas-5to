
#Crear un Stored Procedure que actualice el stock de los productos teniendo en cuenta los
#ingresos de esta semana.
delimiter //
create procedure actualiStock () begin

declare ctd int;
declare id int;
declare St int;


declare cursorStock cursor for select cantidad, Producto_codProducto from ingresostock_producto join ingresostock on IngresoStock_idIngreso=idIngreso where week(fecha)=week(current_date());
declare continue handler for not found set st = 0;
open cursorStock;
bucle: loop
fetch cursorStock into ctd,id;
if st =0 then
    leave bucle;
end if;
update prodcuto set stock=stock+ctd where codProducto=id;
 end loop bucle;
 close cursorStock;

end //
delimiter ;
call actualiStock();

#Crear un Stored Procedure que reduzca el precio de los productos en un 10% si no se
#vendieron más de 100 unidades en la semana.
delimiter //
create procedure menos10() begin
declare ventas int;
declare st int;
declare id int;

declare cursorPrice cursor for select sum(cantidad),Producto_codProducto from pedido_producto join pedido where week(fecha)=week(current_date()) group by Producto_codProducto;
declare continue handler for not found set st = 0;
    open cursorPrice;
    bucle: loop
fetch cursorPrice into ventas,id;
if st =0 then
    leave bucle;
end if;
    if ventas<100 then
    update producto set precio=precio*0.9 where codProducto=id;
end if;
end loop bucle;
 close cursoPrice;

end //
delimiter ;
#Crear un Stored Procedure que actualice el precio de los productos. Debe ser un 10% más
#que el mayor precio al que lo proveen los proveedores.
delimiter //
create procedure ActPrecios() begin
declare maxPrecio int;
declare st int;
declare id int;

declare cursorPrice cursor for select max(precio), Producto_codProducto from producto_proveedor group by Producto_codProducto;
declare continue handler for not found set st = 0;
    open cursorPrice;
    bucle: loop
fetch cursorPrice into maxPrecio,id;
if st =0 then
    leave bucle;
end if;
	update producto set precio=maxPrecio*1.1 where id=codProducto;
end loop bucle;
 close cursorPrice;

end //
delimiter ;
call ActPrecios();
drop procedure ActPrecios;


#Suponiendo que agregamos una columna llamada “nivel” en la tabla de proveedores, se
#pide realizar un procedimiento que calcule la cantidad de ingresos por proveedor en los
#últimos 2 meses y actualice el nivel del proveedor. Los niveles son “Bronce” hasta 50
#ingresos inclusive, “Plata” de 50 a 100 ingresos inclusive y “Oro” más de 100.

alter table proveedor add column nivel text;

delimiter //
create procedure nivels() begin
declare cantIngresos int;
declare id int;
declare st int;


declare cursorLevel cursor for select count(Proveedor_idProveedor),Proveedor_idProveedor from ingresostock where month(fecha)>month(current_date())-2 group by Proveedor_idProveedor;
declare continue handler for not found set st = 0;
    open cursorLevel;
    bucle: loop
fetch cursorLevel into cantIngresos, id;

if st =0 then
    leave bucle;
end if;

if cantIngresos<=50 then
update proveedor set nivel="Bronce" where id=idProveedor;

else if cantIngresos>50 and cantIngresos<=100 then
update proveedor set nivel="Plata" where id=idProveedor;

else 
update proveedor set nivel="Oro" where id=idProveedor;
end  if;
end if;

end loop bucle;
 close cursorLevel;
end //
delimiter ;
