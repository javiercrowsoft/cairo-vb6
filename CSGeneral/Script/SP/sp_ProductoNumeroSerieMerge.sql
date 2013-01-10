if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ProductoNumeroSerieMerge]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoNumeroSerieMerge]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

  select 'update ' + t.name + ' set ' + c.name + ' = @@prns_id_real where '
         + c.name + ' = @@prns_id_to_delete'  
  from sysobjects t inner join syscolumns c on t.id = c.id
  where t.xtype='u'
    and c.name like '%prns_id%'
    and t.name not like '%tmp%'


*/
create procedure sp_ProductoNumeroSerieMerge (
  @@prns_id_to_delete int,
  @@prns_id_real      int
)
as
begin

  set nocount on

  begin transaction

  update Tarea set prns_id = @@prns_id_real where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  update ParteReparacion set prns_id = @@prns_id_real where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  update StockCache set prns_id = @@prns_id_real where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  update OrdenServicioSerie set prns_id = @@prns_id_real where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  update ProductoSerieKit set prns_id = @@prns_id_real where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  update ProductoSerieKitItem set prns_id = @@prns_id_real where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  update StockItem set prns_id = @@prns_id_real where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  update ProductoNumeroSerieServicio set prns_id_reemplazo = @@prns_id_real where prns_id_reemplazo = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  update ParteDiario set prns_id = @@prns_id_real where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  update ProductoNumeroSerieHistoria set prns_id = @@prns_id_real where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  update ProductoNumeroSerieAsinc set prns_id = @@prns_id_real where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  declare @codigo2 varchar(255) 
  declare  @codigo3 varchar(255)

  select @codigo2 = prns_codigo2, @codigo3 = prns_codigo3 
  from productonumeroserie where prns_id = @@prns_id_to_delete

  delete ProductoNumeroSerie where prns_id = @@prns_id_to_delete
  if @@error <> 0 goto ControlError

  declare @os_id     int
  declare @prp_id   int

  select @os_id=max(os.os_id) 
  from OrdenServicio os 
      inner join StockItem sti on os.st_id = sti.st_id 
                              and prns_id  = @@prns_id_real

  select @prp_id=max(prp_id) 
  from ParteReparacion prp
  where prns_id  = @@prns_id_real
    and os_id    = @os_id

  update ProductoNumeroSerieServicio set os_id = @os_id, prp_id = @prp_id
  where prnss_id = @@prns_id_real
  if @@error <> 0 goto ControlError

  update ProductoNumeroSerie set prns_codigo2 = @codigo2, 
                                 prns_codigo3 = @codigo3, 
                                 doct_id_ingreso   = 42, 
                                 doc_id_ingreso   = @os_id
  where prns_id = @@prns_id_real
  if @@error <> 0 goto ControlError

  commit transaction

  select @@prns_id_real as prns_id

  return
ControlError:

  declare @MsgError varchar(5000)

  set @MsgError = 'Ha ocurrido un error al unir los numeros de serie. sp_ProductoNumeroSerieMerge.'
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO