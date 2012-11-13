/*

[DC_CSC_VEN_9701] 79,'N82953',3.000000,'Insumos para',-1,-1,0,-1,0,20.000000,30.000000,10.000000,0,0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,''

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9701]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9701]

go
create procedure DC_CSC_VEN_9701 (

@@us_id         			int,
@@pr_id								varchar(255)

)as 
begin

	set nocount on

  declare @pr_id int
	declare @ram_id_Producto int
	
	declare @clienteID 	int
	declare @IsRaiz 		tinyint

	exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out
	
	exec sp_GetRptId @clienteID out

	if @ram_id_Producto <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
		end else 
			set @ram_id_Producto = 0
	end

	declare @pr_id_to_update int

	declare c_productos_to_update insensitive cursor for 
		select pr_id 
		from Producto 
		where (			
							      (pr_id = @pr_id or @pr_id=0)
							
							-- Arboles
							and   (
												(exists(select rptarb_hojaid 
							                  from rptArbolRamaHoja 
							                  where
							                       rptarb_cliente = @clienteID
							                  and  tbl_id = 30 
							                  and  rptarb_hojaid = pr_id
														   ) 
							           )
							        or 
												 (@ram_id_Producto = 0)
										 )
					)

	open c_productos_to_update

	fetch next from c_productos_to_update into @pr_id_to_update

	while @@fetch_status=0
	begin

		exec sp_ProductoSaveNombres @@us_id, @pr_id_to_update

		fetch next from c_productos_to_update into @pr_id_to_update	
	end

	close c_productos_to_update
	deallocate c_productos_to_update

	select pr_id,
				 pr_nombrecompra 		as [Nombre Compra],
				 pr_nombreventa  		as [Nombre Venta],
         pr_nombrefactura 	as [Nombre Factura],
				 pr_nombreweb       as [Nombre Web],
				 ''									as dummy_col

	from Producto
	where (			
						      (pr_id = @pr_id or @pr_id=0)
						
						-- Arboles
						and   (
											(exists(select rptarb_hojaid 
						                  from rptArbolRamaHoja 
						                  where
						                       rptarb_cliente = @clienteID
						                  and  tbl_id = 30 
						                  and  rptarb_hojaid = pr_id
													   ) 
						           )
						        or 
											 (@ram_id_Producto = 0)
									 )
				)
	
end
go