if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_StockProductoGetData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockProductoGetData]

/*

 select pr_id,pr_llevanroserie from producto where pr_eskit <> 0
 sp_StockProductoGetData 611

*/

go
create procedure sp_StockProductoGetData (
  @@pr_id     int,
  @@cli_id     int = null,
  @@prov_id   int = null
)
as

begin

  set nocount on

  declare @cue_id_compra int
  declare @cue_id_venta  int

  exec sp_productoGetCueId @@cli_id, null,       @@pr_id, 0, @cue_id_venta out
  exec sp_productoGetCueId null,      @@prov_id, @@pr_id, 0, @cue_id_compra out

  declare @ccos_id int

  select @ccos_id = ccos_id
  from ProveedorCentroCosto
  where prov_id = @@prov_id 
    and pr_id = @@pr_id

  if @ccos_id is null
    select @ccos_id = ccos_id
    from ProveedorCentroCosto
    where prov_id = @@prov_id 
      and pr_id is null    

  -- Si es un kit la cosa se pone mas complicada ya que hay que fijarse
  -- si las componentes del kit llevan stock y numero de serie
  --
  if exists(select pr_id from Producto where pr_id = @@pr_id and pr_eskit <> 0) begin

    declare @bLlevaNroSerie tinyint
    declare @Unidad         varchar(255)

    exec sp_StockProductoKitLlevaNroSerie @@pr_id, @bLlevaNroSerie out

    -- Esto lo hacemos asi, por que si bien solo puede
    -- haber una formula por defecto esta regla esta impuesta
    -- por codigo y no por el motor y en consecuencia puede fallar :)
    declare @prfk_id     int

    select @prfk_id = max(prfk_id) 
    from ProductoFormulaKit 
    where pr_id = @@pr_id and prfk_default <> 0
    
    select   
            uns.un_nombre, -- La unidad de los kits es de ventas
            unv.un_nombre   as unidadVenta,
            unc.un_nombre   as unidadCompra,
            @bLlevaNroSerie as pr_llevanroserie,
            pr_llevanrolote,
            pr_lotefifo,
            pr_eskit,
            rub_id,
            @cue_id_compra as cue_id_compra, 
            @cue_id_venta   as cue_id_venta,
            prfk_id,
            prfk_nombre,
            pr_kitResumido,
            pr_kitIdentidad,
            case when exists(select prka_id 
                             from ProductoKitItemA pka 
                                  inner join ProductoKit pk on     pka.prk_id = pk.prk_id
                                                              and prfk_id = prfk.prfk_id)
                 then    1
                 else    0
            end  as tiene_alternativas,
            ccos_id_compra,
            ccos_id_venta,
            ccosc.ccos_nombre as centro_costo_compra,
            ccosv.ccos_nombre as centro_costo_venta

    from Producto left  join Unidad uns               on Producto.un_id_stock   = uns.un_id 
                  left  join Unidad unv               on Producto.un_id_venta   = unv.un_id
                  left  join Unidad unc               on Producto.un_id_compra   = unc.un_id                    
                  left  join ProductoFormulaKit prfk  on     Producto.pr_id   = prfk.pr_id
                                                        and  prfk_id          = @prfk_id
                  left  join CentroCosto ccosc on isnull(@ccos_id,Producto.ccos_id_compra) = ccosc.ccos_id
                  left  join CentroCosto ccosv on Producto.ccos_id_venta = ccosv.ccos_id

    where 
          Producto.pr_id = @@pr_id

  end else begin 

    select   uns.un_nombre, 
            unv.un_nombre   as unidadVenta,
            unc.un_nombre   as unidadCompra,
            pr_llevanroserie,
            pr_llevanrolote,
            pr_lotefifo,
            pr_eskit,
            rub_id,
            @cue_id_compra  as cue_id_compra, 
            @cue_id_venta    as cue_id_venta,
            ccos_id_compra,
            ccos_id_venta,
            ccosc.ccos_nombre as centro_costo_compra,
            ccosv.ccos_nombre as centro_costo_venta
  
    from Producto left  join Unidad uns on Producto.un_id_stock   = uns.un_id 
                  left  join Unidad unv on Producto.un_id_venta   = unv.un_id
                  left  join Unidad unc on Producto.un_id_compra   = unc.un_id
                  left  join CentroCosto ccosc on isnull(@ccos_id,Producto.ccos_id_compra) = ccosc.ccos_id
                  left  join CentroCosto ccosv on Producto.ccos_id_venta = ccosv.ccos_id
  
    where 
          pr_id = @@pr_id
  end

end