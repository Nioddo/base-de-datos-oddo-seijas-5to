#1
select codigo, nombre from proveedor where ciudad="La Plata";
#2
delete from articulo where codigo not in (select articulo_codigo from compuesto_por); 
delete from articulo where not exists 
(select material_codigo from compuesto_por where codigo = articulo_codigo); 
#3
select codigo, descripcion from articulo join compuesto_por on codigo=articulo_codigo join provisto_por on compuesto_por.material_codigo=provisto_por.material_codigo where proveedor_codigo=1;
#4
select proveedor.codigo, nombre from proveedor join provisto_por on proveedor.codigo=proveedor_codigo join compuesto_por on compuesto_por.material_codigo=provisto_por.material_codigo join articulo on articulo_codigo=articulo.codigo where precio>10000;
#5
select codigo from articulo order by precio asc;
#6
select descripcion, sum(stock) from articulo join tiene on codigo=articulo_codigo group by codigo order by sum(stock) desc limit 1;
#7
select almacen_codigo from tiene join compuesto_por on tiene.articulo_codigo=compuesto_por.articulo_codigo where material_codigo=2;
#8
select descripcion, count(articulo_codigo)  from articulo join compuesto_por on codigo = articulo_codigo group by codigo having count(*) = (select count(articulo_codigo) from compuesto_por group by articulo_codigo order by count(articulo_codigo) desc limit 1);
select descripcion, count(articulo_codigo) from compuesto_por join articulo on articulo_codigo=codigo group by articulo_codigo order by count(articulo_codigo) desc limit 1;
#9
update articulo join tiene on codigo=articulo_codigo set precio=(precio*1.2) where (select sum(stock) from tiene where articulo_codigo= codigo)<20;
#10
select avg(cantidad) from (select count(*)as cantidad from compuesto_por join articulo on articulo_codigo=codigo group by articulo_codigo)as hola;
#11
select almacen_codigo, avg(precio), max(precio), min(precio) from tiene 
join articulo on articulo_codigo = articulo.codigo 
group by almacen_codigo;
 
#12
select almacen_codigo, sum(precio*stock) from tiene 
join articulo on articulo_codigo = articulo.codigo 
group by almacen_codigo;
 
#13
select articulo_codigo, sum(precio*stock) from tiene 
join articulo on articulo_codigo = articulo.codigo
where stock > 100
group by articulo_codigo;
 
#14
select articulo_codigo, count(material_codigo) as cant from compuesto_por group by articulo_codigo having cant > 3;
 
#15
select material.descripcion from material join compuesto_por on material.codigo = material_codigo
where articulo_codigo in
(select codigo from articulo where precio >
(select avg(precio) from tiene 
join articulo on articulo_codigo = articulo.codigo 
group by almacen_codigo having almacen_codigo = 2)) group by material.descripcion