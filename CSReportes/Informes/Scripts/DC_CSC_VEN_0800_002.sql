/*---------------------------------------------------------------------
Nombre: Ventas Agrupadas por Cliente, Carpeta, Rubro, Articulo, Empresa en Moneda Default, Costo y Origen
---------------------------------------------------------------------*/
/*  

Tabla de valores para @@metodoVal
Precio Promedio Ponderado		|1|
Lista de Precios						|2|
Ultima Compra								|3|
Por Despacho de Importación	|4|

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0800_002]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0800_002]

go
create procedure DC_CSC_VEN_0800_002 (

	@@arb_id          int = 0

)as 
begin

	set nocount on
	
	if @@arb_id = 0	select @@arb_id = min(arb_id) from arbol where tbl_id = 30 -- producto
	
	declare @arb_nombre varchar(255) 	select @arb_nombre = arb_nombre from arbol where arb_id = @@arb_id
	declare @n 					int 					set @n = 2
	declare @raiz 			int
	
	while exists(select * from rama r
							 where  arb_id = @@arb_id
									and not exists (select * from #DC_CSC_VEN_0800_producto where nodo_2 = r.ram_id)
									and not exists (select * from #DC_CSC_VEN_0800_producto where nodo_3 = r.ram_id)
									and not exists (select * from #DC_CSC_VEN_0800_producto where nodo_4 = r.ram_id)
									and not exists (select * from #DC_CSC_VEN_0800_producto where nodo_5 = r.ram_id)
									and not exists (select * from #DC_CSC_VEN_0800_producto where nodo_6 = r.ram_id)
									and not exists (select * from #DC_CSC_VEN_0800_producto where nodo_7 = r.ram_id)
									and not exists (select * from #DC_CSC_VEN_0800_producto where nodo_8 = r.ram_id)
									and not exists (select * from #DC_CSC_VEN_0800_producto where nodo_9 = r.ram_id)
	
									and @n <= 9
							)
	begin
	
		if @n = 2 begin
	
			select @raiz = ram_id from rama where arb_id = @@arb_id and ram_id_padre = 0
			insert #DC_CSC_VEN_0800_producto (nodo_id, nodo_2) 
			select ram_id, ram_id from rama where ram_id_padre = @raiz
	
		end else begin if @n = 3 begin
	
			insert #DC_CSC_VEN_0800_producto (nodo_id, nodo_2, nodo_3) 
			select ram_id, nodo_2, ram_id 
			from rama r inner join #DC_CSC_VEN_0800_producto n on r.ram_id_padre = n.nodo_2
	
		end else begin if @n = 4 begin
	
			insert #DC_CSC_VEN_0800_producto (nodo_id, nodo_2, nodo_3, nodo_4) 
			select ram_id, nodo_2, nodo_3, ram_id
			from rama r inner join #DC_CSC_VEN_0800_producto n on r.ram_id_padre = n.nodo_3
	
		end else begin if @n = 5 begin
	
			insert #DC_CSC_VEN_0800_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5) 
			select ram_id, nodo_2, nodo_3, nodo_4, ram_id
			from rama r inner join #DC_CSC_VEN_0800_producto n on r.ram_id_padre = n.nodo_4
	
		end else begin if @n = 6 begin
	
			insert #DC_CSC_VEN_0800_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6) 
			select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, ram_id
			from rama r inner join #DC_CSC_VEN_0800_producto n on r.ram_id_padre = n.nodo_5
	
		end else begin if @n = 7 begin
	
			insert #DC_CSC_VEN_0800_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7) 
			select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, ram_id
			from rama r inner join #DC_CSC_VEN_0800_producto n on r.ram_id_padre = n.nodo_6
	
		end else begin if @n = 8 begin
	
			insert #DC_CSC_VEN_0800_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8) 
			select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, ram_id
			from rama r inner join #DC_CSC_VEN_0800_producto n on r.ram_id_padre = n.nodo_7
	
		end else begin if @n = 9 begin
	
			insert #DC_CSC_VEN_0800_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, nodo_9) 
			select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, ram_id
			from rama r inner join #DC_CSC_VEN_0800_producto n on r.ram_id_padre = n.nodo_8
	
		end
		end
		end
		end
		end
		end
		end
		end
	
		set @n = @n + 1
	
	end
	

end
go

