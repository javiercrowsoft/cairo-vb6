if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteReparacionSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteReparacionSetEstado]

/*

 sp_DocParteReparacionSetEstado 21

*/

go
create procedure sp_DocParteReparacionSetEstado (
  @@prp_id       int,
  @@Select      tinyint = 0,
  @@est_id      int = 0 out 
)
as

begin

  if @@prp_id = 0 return

  declare @est_id          int
  declare @prns_id          int
  declare @os_id            int
  declare @st_id            int
  declare @osi_id          int
  declare @rvi_id          int
  declare @st_id_remito   int

  declare @estado_pendiente         int set @estado_pendiente   =1
  declare @estado_finalizado        int set @estado_finalizado  =5
  declare @estado_anulado           int set @estado_anulado     =7


  select @est_id = est_id
  from ParteReparacion where prp_id = @@prp_id

  if @est_id <> @estado_anulado begin

    -- Obtengo el numero de serie de este parte
    --
    select @prns_id = prns_id from ParteReparacion where prp_id = @@prp_id

    -- Obtengo la orden de servicio por la que
    -- entro el numero de serie
    --
    select @os_id = doc_id_ingreso from ProductoNumeroSerie where prns_id = @prns_id and doct_id_ingreso = 42

    -- Obtengo el movimiento de stock de la orden de servicio
    --
    select @st_id = st_id from OrdenServicio where os_id = @os_id

    -- Obtengo el item de la orden de servicio para 
    -- este numero de serie
    --
    select @osi_id = osi_id from StockItem sti 
        inner join OrdenServicioItem osi on st_id     = @st_id 
                                        and os_id     = @os_id
                                        and sti_grupo = osi_id
    where prns_id = @prns_id

    -- Obtengo el remitoventaitem asociado al ordenservicioitem
    -- de este numero de serie. Esto significa que ya se remitio
    --
    select @rvi_id = rvi_id from OrdenRemitoVenta where osi_id = @osi_id

    -- Obtengo el movimiento de stock del remito de venta
    --
    select @st_id_remito = st_id from RemitoVenta rv 
        inner join RemitoVentaItem rvi on rv.rv_id = rvi.rv_id
    where rvi_id = @rvi_id

    -- Si existe un stockitem que lo envie a tercero 
    -- entonces ya esta finalizado
    --
    if exists(select * from StockItem where st_id     = @st_id_remito 
                                        and sti_grupo = @rvi_id 
                                        and prns_id   = @prns_id)
    begin
      set @est_id = @estado_finalizado          
    end else begin
      set @est_id = @estado_pendiente  
    end
  
    update ParteReparacion set est_id = @est_id
    where prp_id = @@prp_id
  
  end

  set @@est_id = @est_id  
  if @@Select <> 0 select @est_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado del Remito de venta. sp_DocParteReparacionSetEstado.', 16, 1)

end
GO