if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSaveNroSerie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSaveNroSerie]

/*
 select * from FacturaVenta
 sp_DocFacturaVentaSaveNroSerie 26

*/

go
create procedure sp_DocFacturaVentaSaveNroSerie (
  @@fvTMP_id        int,
  @@fvi_id          int,
  @@st_id           int,
  @@sti_orden        int out,
  @@fvi_cantidad    decimal(18,6),
  @@fvi_descrip     varchar(255),
  @@pr_id           int,
  @@depl_id_origen  int,
  @@depl_id_destino int,
  @@stik_id         int,

  @@bSuccess         tinyint out,
  @@MsgError        varchar(5000)= '' out
)
as
begin

  declare @prns_descrip   varchar(255)
  declare @prns_fechavto   datetime

  declare @prns_id int
  declare @stl_id  int
  declare @n int
  set @n = 1

  while @n <= @@fvi_cantidad begin

    select 
          top 1 @prns_id = prns_id, @prns_descrip = prns_descrip, @prns_fechavto = prns_fechavto
    from 
          FacturaVentaItemSerieTMP 
    where 
              fvi_id     = @@fvi_id 
          and ((pr_id_item = @@pr_id) or (@@pr_id = pr_id and pr_id_item is null))
          and fvTMP_id   = @@fvTMP_id

    order by 
              fvis_orden asc

    --/////////////////////////////////////////////////////////////////////////
    -- Actualizo el numero de serie
    --
        Update ProductoNumeroSerie Set
                                        prns_descrip  = @prns_descrip, 
                                        prns_fechavto = @prns_fechavto
                where prns_id = @prns_id
        if @@error <> 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////

    set @stl_id = null
    select @stl_id = stl_id from ProductoNumeroSerie where prns_id = @prns_id

    exec sp_DocFacturaVentaStockItemSave   
                                            @@fvi_id,
                                            @@st_id,
                                            @@sti_orden out,
                                            1,
                                            @@fvi_descrip,
                                            @@pr_id,
                                            @@depl_id_origen,
                                            @@depl_id_destino,
                                            @prns_id,
                                            @@stik_id,
                                            @stl_id,
        
                                            @@bSuccess out,
                                            @@MsgError out 

    if IsNull(@@bSuccess,0) = 0 goto Validate
    
    update FacturaVentaItemSerieTMP set fvis_orden = fvis_orden + 10000 
    where prns_id = @prns_id and fvTMP_id = @@fvTMP_id

    set @n = @n + 1
  end

  set @@bSuccess = 1
  return

ControlError:
  set @@MsgError = 'Ha ocurrido un error al grabar el item de stock del Factura de venta. sp_DocFacturaVentaSaveNroSerie.'

Validate:

  set @@bSuccess = 0

end
go