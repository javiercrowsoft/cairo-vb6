-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Stock por depósito
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_9995]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_9995]

GO

/*

DC_CSC_STK_9995 
											1,
											'0','0','0'

*/

create procedure DC_CSC_STK_9995 (

  @@us_id    		int,
  @@stl_id1    	varchar(255),
  @@stl_id2    	varchar(255)

)as 

begin

	/*- ///////////////////////////////////////////////////////////////////////
	
	INICIO PRIMERA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	set nocount on
	
	declare @stl_id1 int
	declare @stl_id2 int
	
	exec sp_ArbConvertId @@stl_id1, @stl_id1 out, 0
	exec sp_ArbConvertId @@stl_id2, @stl_id2 out, 0

	if @stl_id1 = 0 begin

		select 1 as aux_id, 'Debe indicar un solo lote a reemplazar (no puede dejar el campo vacio ni seleccionar una carpeta o multiple seleccion)' as Info
		return
	end
	
	if @stl_id2 = 0 begin

		select 1 as aux_id, 'Debe indicar un solo lote como reemplazo (no puede dejar el campo vacio ni seleccionar una carpeta o multiple seleccion)' as Info
		return
	end

	declare @pr_id 	int
	declare @pr_id2 int

	select @pr_id  from StockLote where stl_id = @stl_id1
	select @pr_id2 from StockLote where stl_id = @stl_id2

	if @pr_id <> @pr_id2 begin

		select 1 as aux_id, 'El articulo asociado a cada lotes no coincide' as Info
		return
	end

	begin transaction

		update ParteProdKitItem 			set stl_id = @stl_id2 where stl_id = @stl_id1
		update ParteReparacionItem 		set stl_id = @stl_id2 where stl_id = @stl_id1
		update ProductoNumeroSerie 		set stl_id = @stl_id2 where stl_id = @stl_id1
		update OrdenServicioItem 			set stl_id = @stl_id2 where stl_id = @stl_id1
		update StockItem 							set stl_id = @stl_id2 where stl_id = @stl_id1
		update RemitoCompraItem 			set stl_id = @stl_id2 where stl_id = @stl_id1
		update FacturaVentaItem 			set stl_id = @stl_id2 where stl_id = @stl_id1
		update RemitoVentaItem 				set stl_id = @stl_id2 where stl_id = @stl_id1
		update ProductoSerieKit 			set stl_id = @stl_id2 where stl_id = @stl_id1
		update ProductoSerieKitItem 	set stl_id = @stl_id2 where stl_id = @stl_id1
		update FacturaCompraItem 			set stl_id = @stl_id2 where stl_id = @stl_id1
		update RecuentoStockItem 			set stl_id = @stl_id2 where stl_id = @stl_id1
		update ImportacionTempItem 		set stl_id = @stl_id2 where stl_id = @stl_id1
		update StockLote 							set stl_id_padre = @stl_id2 where stl_id = @stl_id1

		exec sp_docstockcachecreate2 @pr_id

		delete StockLote where stl_id = @stl_id1

	if @@error <> 0 begin

		rollback transaction

		select 1 as aux_id, 'El reemplazo del lote fallo' as Info

	end else begin

		commit transaction

		select 1 as aux_id, 'El lote fue reemplazado con éxito' as Info
	end

end

GO