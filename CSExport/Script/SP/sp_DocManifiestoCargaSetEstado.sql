if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaSetEstado]

/*
 sp_DocManifiestoCargaSetEstado 21
*/

go
create procedure sp_DocManifiestoCargaSetEstado (
	@@mfc_id 			int,
  @@Select      tinyint = 0,
  @@est_id      int = 0 out 
)
as

begin

	if @@mfc_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id 		 		int
	declare @cli_id 		 		int
  declare @pendiente   		decimal (18,6)
  declare @creditoTotal		decimal (18,6)
  declare @llevaFirma     tinyint
  declare @firmado        tinyint

	declare @estado_pendienteDespacho int set @estado_pendienteDespacho =2
	declare @estado_pendienteCredito  int set @estado_pendienteCredito  =3
	declare @estado_pendienteFirma    int set @estado_pendienteFirma    =4
  declare @estado_finalizado        int set @estado_finalizado        =5
	declare @estado_anulado           int set @estado_anulado           = 7

	select @cli_id = cli_id, @firmado = mfc_firmado, @est_id = est_id
  from ManifiestoCarga where mfc_id = @@mfc_id

	if @est_id <> @estado_anulado begin
		select 
					 @pendiente 		= round(sum(clicc_importe),2)
	  from ClienteCacheCredito where cli_id = @cli_id
	
		select 
					 @creditoTotal 	= cli_creditototal 
	  from Cliente where cli_id = @cli_id
	
	  if @@trancount = 0 begin
	    set @bInternalTransaction = 1
			begin transaction
	  end
	
		if @pendiente = 0 begin								
				set @est_id = @estado_finalizado 
	  end
		else begin 
			if @pendiente > @creditoTotal begin	
				set @est_id = @estado_pendienteCredito 
	    end 
			else begin
				if @firmado = 0 begin             
					set @est_id = @estado_pendienteFirma 
				end
		    else begin                                
						set @est_id = @estado_pendienteDespacho
		    end
	    end
	  end
	
		update ManifiestoCarga set est_id = @est_id
		where mfc_id = @@mfc_id
	
		if @bInternalTransaction <> 0 
			commit transaction
	end

	set @@est_id = @est_id  
	if @@Select <> 0 select @est_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el estado del manifiesto de carga. sp_DocManifiestoCargaSetEstado.', 16, 1)

	if @bInternalTransaction <> 0 
		rollback transaction	

end
GO