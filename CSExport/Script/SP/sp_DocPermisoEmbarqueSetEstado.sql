if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPermisoEmbarqueSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPermisoEmbarqueSetEstado]

/*

 sp_DocPermisoEmbarqueSetEstado 21

*/

go
create procedure sp_DocPermisoEmbarqueSetEstado (
	@@pemb_id 		int,
  @@Select      tinyint = 0,
  @@est_id      int = 0 out 
)
as

begin

	if @@pemb_id = 0 return

  declare @est_id 		 					int
  declare @pendiente   					decimal (18,6)
  declare @llevaFirma     			tinyint
  declare @firmado        			tinyint

	declare @estado_pendiente 				int set @estado_pendiente 				=1
	declare @estado_pendienteFirma    int set @estado_pendienteFirma    =4
  declare @estado_finalizado        int set @estado_finalizado        =5
	declare @estado_anulado           int set @estado_anulado           =7

	select @firmado = pemb_firmado, @est_id = est_id, @pendiente = round(pemb_pendiente,2)
  from PermisoEmbarque where pemb_id = @@pemb_id

	if @est_id <> @estado_anulado begin

		if @pendiente = 0 begin								
			set @est_id = @estado_finalizado 
	  end	else begin
			if @firmado = 0 begin             
				set @est_id = @estado_pendienteFirma 
			end else begin                                
				set @est_id = @estado_pendiente
	    end
	  end
	
		update PermisoEmbarque set est_id = @est_id
		where pemb_id = @@pemb_id
	
	end

	set @@est_id = @est_id  
	if @@Select <> 0 select @est_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el estado del permiso de embarque. sp_DocPermisoEmbarqueSetEstado.', 16, 1)

end
GO