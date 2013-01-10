if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoEnvioSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoEnvioSetEstado]

/*
 sp_DocPresupuestoEnvioSetEstado 21
*/

go
create procedure sp_DocPresupuestoEnvioSetEstado (
  @@pree_id       int,
  @@Select      tinyint = 0,
  @@est_id      int = 0 out 
)
as

begin

  if @@pree_id = 0 return

  declare @est_id          int
  declare @cli_id          int
  declare @pendiente       decimal (18,6)
  declare @creditoTotal    decimal (18,6)
  declare @llevaFirma     tinyint
  declare @firmado        tinyint

  declare @estado_pendienteDespacho int set @estado_pendienteDespacho =2
  declare @estado_pendienteCredito  int set @estado_pendienteCredito  =3
  declare @estado_pendienteFirma    int set @estado_pendienteFirma    =4
  declare @estado_finalizado        int set @estado_finalizado        =5
  declare @estado_anulado           int set @estado_anulado           =7

  select @cli_id = cli_id, @firmado = pree_firmado, @est_id = est_id
  from PresupuestoEnvio where pree_id = @@pree_id

  if @est_id <> @estado_anulado begin
    select 
           @pendiente     = round(sum(clicc_importe),2)
    from ClienteCacheCredito where cli_id = @cli_id
  
    select 
           @creditoTotal   = cli_creditototal 
    from Cliente where cli_id = @cli_id
  
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
  
    update PresupuestoEnvio set est_id = @est_id
    where pree_id = @@pree_id
  
  end

  set @@est_id = @est_id  
  if @@Select <> 0 select @est_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado del presupuesto. sp_DocPresupuestoEnvioSetEstado.', 16, 1)

end