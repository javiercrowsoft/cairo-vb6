if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocImportacionTempSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocImportacionTempSetEstado]

/*
 sp_DocImportacionTempSetEstado 21
*/

go
create procedure sp_DocImportacionTempSetEstado (
  @@impt_id       int,
  @@Select      tinyint = 0,
  @@est_id      int = 0 out 
)
as

begin

  if @@impt_id = 0 return

  declare @est_id          int
  declare @pendiente       decimal (18,6)
  declare @creditoTotal    decimal (18,6)
  declare @llevaFirma     tinyint
  declare @firmado        tinyint

  declare @estado_pendienteDespacho int set @estado_pendienteDespacho =2
  declare @estado_pendienteFirma    int set @estado_pendienteFirma    =4
  declare @estado_finalizado        int set @estado_finalizado        =5
  declare @estado_anulado           int set @estado_anulado           =7

  select @firmado = impt_firmado, @est_id = est_id
  from ImportacionTemp where impt_id = @@impt_id

  if @est_id <> @estado_anulado begin
  
    set @est_id = @estado_pendienteDespacho
  
    update ImportacionTemp set est_id = @est_id
    where impt_id = @@impt_id
  
  end

  set @@est_id = @est_id  
  if @@Select <> 0 select @est_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado de la importación temporal. sp_DocImportacionTempSetEstado.', 16, 1)

end
GO