if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaCdoGetCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaCdoGetCliente]

go

/*

select max(fv_id) from facturaventa
sp_DocCobranzaCdoGetCliente  29183

*/

create procedure sp_DocCobranzaCdoGetCliente (
  @@fv_id   int
)
as

begin

  declare @item varchar(4000)
  declare @venta varchar(7000)

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  -- Venta
  --
  set @venta = ''

  declare c_items insensitive cursor for
  select convert(varchar,convert(decimal(18,2),fvi_cantidad)) + ' ' + pr_nombreventa + ' - ' + fvi_descrip 
  from FacturaVentaItem fvi inner join Producto pr on fvi.pr_id = pr.pr_id
  where fv_id = @@fv_id

  open c_items

  fetch next from c_items into @item
  while @@fetch_status = 0
  begin

    set @venta = @item + char(13)+char(10)

    fetch next from c_items into @item
  end
  close c_items
  deallocate c_items

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  -- Pago
  --

  declare c_pagos insensitive cursor for 
  
    select distinct   'MercadoPago: ' + cmic_cobrado + char(13)+char(10)
                    + 'Fecha: ' + convert(varchar,cmic_fecha,105) + ' (' + cmic_fechastr + ')' + char(13)+char(10)
                    + 'Estado: ' + cmic_estado + char(13)+char(10)
                    + 'Articulo:' + cmic_articulo + char(13)+char(10)
                    + cmic_descrip,
                    cmic_cobrado

    from ComunidadInternetCobro cmic 
    where pv_id in (  select pv_id 
                      from PedidoFacturaVenta pvfv 
                              inner join FacturaVentaItem fvi
                                  on pvfv.fvi_id = fvi.fvi_id
                              inner join PedidoVentaItem pvi
                                  on pvfv.pvi_id = pvi.pvi_id 
                      where fvi.fv_id = @@fv_id
                  )
  
  open c_pagos
  
  declare @pago        varchar(4000)
  declare @pagos      varchar(7000)
  declare @pagocvxi   varchar(255)
  declare @pagoscvxi  decimal(18,6)

  set @pagos = ''
  set @pagoscvxi = 0
  
  fetch next from c_pagos into @pago, @pagocvxi
  while @@fetch_status=0
  begin

    set @pagocvxi = replace(replace(@pagocvxi,'.',''),',','.')

    if isnumeric(@pagocvxi) <> 0 begin

      set @pagoscvxi = @pagoscvxi + convert(decimal(18,6),@pagocvxi)
    end

    set @pagos = @pago + char(13)+char(10)
  
    fetch next from c_pagos into @pago, @pagocvxi
  end
  
  close c_pagos
  deallocate c_pagos

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  -- Venta
  --

  declare @factura varchar(7000)

  select     cli_nombre, 
            cli_codigocomunidad, 
            @venta as venta, 
            @pagos as pago, 
            fv_nrodoc + ' -- ' + convert(varchar(10),fv_fecha,105) as factura, 
            @pagoscvxi as pagocvxi,
            fv.cli_id,
            fv.suc_id,
            fv.ccos_id,
            fv.lgj_id,
            fv_fecha,
            fv_pendiente fv_total
            
  from FacturaVenta fv inner join Cliente cli on fv.cli_id = cli.cli_id
  where fv_id = @@fv_id

end