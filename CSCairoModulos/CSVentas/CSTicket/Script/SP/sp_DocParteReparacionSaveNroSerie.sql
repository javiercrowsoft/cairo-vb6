if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteReparacionSaveNroSerie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteReparacionSaveNroSerie]

/*
 select * from ParteReparacion
 sp_DocParteReparacionSaveNroSerie 26

*/

go
create procedure sp_DocParteReparacionSaveNroSerie (
	@@prpTMP_id        int,
	@@prpi_id          int,
	@@st_id 					 int,
	@@sti_orden				 int out,
	@@prpi_cantidad    decimal(18,6),
  @@prpi_descrip     varchar(255),
  @@pr_id            int,
  @@depl_id_origen   int,
  @@depl_id_destino  int,
	@@stik_id          int,

	@@bSuccess 				 tinyint out,
  @@MsgError         varchar(5000)= '' out
)
as
begin

	declare @prns_descrip 	varchar(255)
	declare @prns_fechavto 	datetime

	declare @prns_id int
  declare @stl_id  int
	declare @n 			 int
	set @n = 1

	while @n <= @@prpi_cantidad begin

		select 
					top 1 @prns_id = prns_id, @prns_descrip = prns_descrip, @prns_fechavto = prns_fechavto
		from 
					ParteReparacionItemSerieTMP 
		where 
							prpi_id     = @@prpi_id 
					and ((pr_id_item = @@pr_id) or (@@pr_id = pr_id and pr_id_item is null))
					and prpTMP_id = @@prpTMP_id

		order by 
							prpis_orden asc

		--/////////////////////////////////////////////////////////////////////////
		-- Actualizo el numero de serie
		--
				Update ProductoNumeroSerie Set
																				prns_descrip	= @prns_descrip, 
																				prns_fechavto = @prns_fechavto, 
																				depl_id 			= @@depl_id_destino
								where prns_id = @prns_id
			  if @@error <> 0 goto ControlError

		--/////////////////////////////////////////////////////////////////////////

		set @stl_id = null
		select @stl_id = stl_id from ProductoNumeroSerie where prns_id = @prns_id

		exec sp_DocParteReparacionStockItemSave 	
																						@@prpi_id,
																						@@st_id,
																						@@sti_orden out,
																						1,
																					  @@prpi_descrip,
																					  @@pr_id,
																					  @@depl_id_origen,
																					  @@depl_id_destino,
																						@prns_id,
																					  @@stik_id,
																						@stl_id,
				
																						@@bSuccess out,
																						@@MsgError out 

		if IsNull(@@bSuccess,0) = 0 goto Validate
		
		update ParteReparacionItemSerieTMP set prpis_orden = prpis_orden + 10000 
		where prns_id = @prns_id and prpTMP_id = @@prpTMP_id

		set @n = @n + 1
	end

	set @@bSuccess = 1
	return

ControlError:
	set @@MsgError = 'Ha ocurrido un error al grabar el item de stock del parte de reparación. sp_DocParteReparacionSaveNroSerie.'

Validate:

	set @@bSuccess = 0

end
go